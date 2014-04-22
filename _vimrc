" ------------------------------------------------
" starter vimrc file
" Last modified: Mon Mar 10, 2014  02:27PM
" ------------------------------------------------
" NOTE: on windows I do source bitbucket/.vimrc in my $HOME/.vimrc
"
" must do this before any other mappings
let mapleader = ","

" reset all autocmds
autocmd!

" Some Linux distributions set filetype in /etc/vimrc. {{{1
" Clear filetype flags before changing runtimepath to force Vim to reload them.
filetype off
filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim
filetype plugin indent on
syntax on

" auto reading/writing  {{{1
set autoread							 " auto read externalled modified files

" UI {{{1
set nocompatible						 " no vi compatibility
set cursorline							 " show cursor line by default
set number								 " turn on line numbering
set nowrap								 " no line wrapping on default
set nobackup							 " no more ~ files
set nowritebackup						 " no more ~ files

" indentation {{{1
set autoindent                           " autoindent
set noexpandtab                          " use tab characters
set shiftwidth=4                         " tab size
set tabstop=4                            " tab size
set listchars=tab:>.,trail:.,extends:\

" searching {{{1
set gdefault                             " default /g in substrings
set hlsearch                             " highlight matched text
set incsearch                            " incremental search
set ignorecase                           " by default ignore case
set smartcase                            " but, use case if any caps used
set nowrapscan                           " if you want to wrap, use the 'gg' or 'G' command

" syntax highlighting  {{{1
syntax on                                " enable syntax highlighting
filetype on                              " enable filetype detection
filetype indent on                       " enable filetype-specific indenting
filetype plugin on                       " enable filetype-specific plugins

" MODE MAPPINGS {{{1

" TIP: way to check if mapping is already taken:
" :map x
" where 'x' is the key or keys pressed

" visual studio save shortcut key 

" edit file in visual studio {{{1
" and w/in visual studio, use this for the arguments when running gvim: 
" -c "simalt ~x" --servername gmain --remote-silent +$(CurLine) +"normal zz" $(ItemPath)

" windows copy/paste like behavior {{{1

