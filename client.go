// TODO can we remove the Client state altogether, pass as parameters to individual
//      goroutines, and deal with everything on a message basis? gut feeling says no.

package client

import (
	"bytes"
	"log"
	"net"
	"sync"
	"time"

	"global"
	"msg"
)

// ErrorCode is an integer
type ErrorCode int

// Client error code
const (
	Unhandled = iota
	TimeOut
	ServerClientVerNotMatch
	ClientBuildVerNotMatch
	GameAlreadyRunning
)

// MessageWithSender has a pointer to a client in addition to the network message
type MessageWithSender struct {
	Sender *Client
	msg.Message
}

// ClientMetrics contains metrics information for this client
type ClientMetrics struct {
	StartTime        time.Time
	BandwidthInquiry chan chan int

	Bandwidth     int
	IncomingBytes int
	OutgoingBytes int
}

// ClientGameRequest has a pointer to the requesting client and the requested match id
type ClientGameRequest struct {
	*Client
	MatchID  uint32
	GameSize uint16
	BuildVer int32
}

// ClientGameRequestResponse contains the three channels that a game requires to connect with a game
type ClientGameRequestResponse struct {
	AddClient    chan *Client
	RemoveClient chan *Client
	ToGame       chan MessageWithSender
	MatchID      uint32
	IsRunning    bool
}

// Client struct holds the state for a single client connection
type Client struct {
	ID              uint64
	conn            net.Conn
	ttl             time.Time
	initialized     chan bool
	fromClientConn  chan msg.Message
	toGameRequest   chan ClientGameRequest
	FromGameRequest chan ClientGameRequestResponse
	ToGame          chan MessageWithSender
	ToClient        chan msg.Message
	Metrics         ClientMetrics
	Wg              sync.WaitGroup
	ListenIP        [4]byte
	ListenPort      uint16
	PlayerName      string
	matchID         uint32
	gameSize        uint16
	buildVer        int32
	Ready           bool
	LoadingComplete bool
}

// RemoteAddr gets the IP address of a client
func (c *Client) RemoteAddr() net.Addr {
	return c.conn.RemoteAddr()
}

func (c *Client) receiver() {
	// cleanup
	defer func() {
		log.Printf("client(%v) receiver() done", c.RemoteAddr())
		// close the channel we write to
		close(c.fromClientConn)
	}()

	// main receive loop
	for {
		// get next message
		m, _, err := msg.ReadMessage(c.conn)
		if err != nil {
			log.Printf("failed to read message from client(%v) with error: %v", c.RemoteAddr(), err)
			return
		}

		// set deadline
		deadline := time.Now().Add(global.TCPReadDeadline)
		if err := c.conn.SetReadDeadline(deadline); err != nil {
			panic(err) // TODO
		}

		// discard pings
		if m.Type() != msg.TypeClientPing {
			// put the message in the channel to be consumed
			c.fromClientConn <- m
		}

		// update ttl
		c.ttl = time.Now()
	}
}

func (c *Client) sender() {
	// cleanup
	defer func() {
		log.Printf("client(%v) sender() done", c.RemoteAddr())
		// close the connection we write to
		c.conn.Close()
	}()

	// main send loop
	for {
		select {
		case m, ok := <-c.ToClient:
			if !ok {
				return
			}
			log.Printf("client(%v) sending %v\n", c.RemoteAddr(), m)
			_, err := m.WriteTo(c.conn)

			// if we send an error to the client, it's the last message
			// we send, so it's time to die
			if m.Type() == msg.TypeServerError {
				log.Printf("terminal error sent to client(%v)", c.RemoteAddr())
				return
			}

			// if we fail to write because the connection was closed,
			// it's time to die
			if err != nil {
				log.Printf("client(%v) sender connection is dead", c.RemoteAddr())
				return
			}
		}
	}
}

func (c *Client) collectMetrics() {
	var in, out int
	timer := time.NewTimer(time.Second)
	for {
		select {
		case <-timer.C:
			c.Metrics.Bandwidth += c.Metrics.IncomingBytes - in
			c.Metrics.Bandwidth += c.Metrics.OutgoingBytes - out
			in = c.Metrics.IncomingBytes
			out = c.Metrics.OutgoingBytes
			timer.Reset(time.Second)
			break

		case inquiry := <-c.Metrics.BandwidthInquiry:
			inquiry <- c.Metrics.Bandwidth
			break
		}
	}
}

func (c *Client) initialize() {
	success := false

	defer func() {
		log.Printf("client(%v) done with intialization", c.RemoteAddr())
		c.initialized <- success
	}()

	select {
	// got a message from the client connection
	case m, ok := <-c.fromClientConn:
		if !ok {
			return
		}

		// confirm message type
		if m.Type() != msg.TypeClientHello {
			log.Printf("invalid hello msg from client(%v)", c.RemoteAddr())
			c.sendError(Unhandled)
			return
		}

		log.Printf("received hello msg from client(%v)", c.RemoteAddr())

		// cast message to type
		mch := m.(*msg.ClientHello)

		// validate protocol version
		if mch.Ver != global.ProtocolVersion {
			log.Printf("client(%v) validation failed", c.RemoteAddr())
			c.sendError(ServerClientVerNotMatch)
			return
		}

		log.Printf("client(%v) validated", c.RemoteAddr())

		// store init values
		c.ID = mch.ClientID
		c.ListenIP = mch.IP
		c.ListenPort = mch.Port
		n := bytes.Index(mch.PlayerName[:], []byte{0})
		c.PlayerName = string(mch.PlayerName[:n])
		c.matchID = mch.MatchID
		c.gameSize = mch.GameSize
		c.buildVer = mch.BuildVer

		// send game request
		gameReq := ClientGameRequest{c, c.matchID, c.gameSize, c.buildVer}
		c.toGameRequest <- gameReq

		// initialization completed successfully
		success = true
	case <-time.After(5 * time.Second):
		// timeout
		log.Printf("timeout waiting for hello msg from client(%v)", c.RemoteAddr())
		c.sendError(TimeOut)
		return
	}
}

func (c *Client) playGame() {
	defer func() {
		log.Printf("client(%v) done with game", c.RemoteAddr())
	}()

	// wait for the client to be initialized
	initSuccess := <-c.initialized

	if !initSuccess {
		return
	}

	// wait for the game request response (started by c.initialize())
	game := <-c.FromGameRequest

	// add to game's client list
	game.AddClient <- c

	// assign new toGame channel
	c.ToGame = game.ToGame

	defer func() {
		log.Printf("telling game#%v about dead client(%v)", game.MatchID, c.RemoteAddr())
		game.RemoveClient <- c

		log.Printf("client(%v) disconnected", c.RemoteAddr())
	}()

	// forward messages to game until the client message channel is closed
	for {
		select {
		case m, ok := <-c.fromClientConn:
			if !ok {
				return
			}

			// create MessageWithSender and pass connection messages to the game
			mws := MessageWithSender{c, m}
			c.ToGame <- mws
		}
	}
}

func (c *Client) sendError(id ErrorCode) {
	// TODO: add error ids
	var m msg.ServerError
	m.ErrorID = byte(id)
	c.ToClient <- &m
}

// Handle creates a new client struct and launches the goroutines to handle its lifetime
func Handle(c net.Conn, gameRequest chan ClientGameRequest, metricsInquiry, connPool chan struct{}) {
	log.Printf("instantiate new client(%v)", c.RemoteAddr())
	client := &Client{
		conn:            c,
		ttl:             time.Now(),
		initialized:     make(chan bool),
		fromClientConn:  make(chan msg.Message),
		toGameRequest:   gameRequest,
		FromGameRequest: make(chan ClientGameRequestResponse),
		ToClient:        make(chan msg.Message, 100), // buffer channel as a hack to prevent deadlock
		Metrics:         ClientMetrics{time.Now(), make(chan chan int), 0, 0, 0},
	}

	client.Wg.Add(4)

	go func() {
		client.sender()
		client.Wg.Done()
	}()
	go func() {
		client.receiver()
		client.Wg.Done()
	}()
	go func() {
		client.collectMetrics()
		client.Wg.Done()
	}()
	go func() {
		client.initialize()
		client.Wg.Done()
	}()
	go func() {
		client.playGame()
		client.Wg.Done()
	}()

	client.Wg.Wait()

	// release a semaphore from connection pool
	<-connPool
}
