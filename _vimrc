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
set autoread                             " auto read externally modified files
set autochdir                            " automatically cd to dir of file in current buffer
set path+=**                             " path for opening files
set sessionoptions-=options
set nobackup
" UI {{{1
set lines=70 columns=150			 " default window size"
set backspace=eol,start,indent           " make backspace better
set clipboard+=unnamed                   " allow yank/paste b/tw 2 different Vim windows
set cursorline                           " show cursor line by default
set nocompatible                         " no vi compatibility QUITE POSSIBLE THE MOST IMPORTANT ONE!
set hidden                               " deal with multiple buffers better
set history=1000                         " remember more than 20 commands
set linebreak                            " don't break in the middle of a word
set number                               " Turn on line numbering
set relativenumber                       " Turn on relative line numbering
set ruler                                " show cursor position
set shortmess=imtI                       " clean up the 'Press ENTER ...' prompts
set showcmd                              " show command keys
set showmatch                            " show matching brackets
set showmode                             " show -- INSERT --, etc.
set textwidth=150                        " turn off autowrapping when typing
set title                                " set terminal title
set timeoutlen=500                       " normally vim will wait 1 sec before deciding if you will press another key
set visualbell                           " don't play audible sound
set wildmenu                             " enhanced file/command tab completion
set wildmode=list:longest,full           " set file/command completion mode
set wildignore=*.meta,*.swp,*.bak        " ignore these files when auto-completing files
set nowrap                               " default to display no line wrapping
if has("win32")
	runtime macros/matchit.vim           " extend % matching (on osx, better to copy plugin into .vim directory)
	set wak=no                           " disable win32 alt keys (so F10 can be remapped)
endif
set fillchars=""                         " get rid of the characters in window separators
set diffopt+=vertical                    " start 'diffthis' vertically by default
set laststatus=2                         " always a status line

set statusline=%<%F\ %h%m%r%=%-14.(%l,%c%V%)\ %P  " basically the standard statusline, but show the full path instead of relative

" right click context menu to jump back
menu <silent> 1.05 PopUp.Back<Tab><C-O> <C-O>
menu <silent> 1.06 PopUp.Forward<Tab><C-I> <C-I>
menu <silent> 1.07 PopUp.Top<Tab>gg gg
menu <silent> 1.0701 PopUp.Close :wincmd c<CR>
an 1.08 PopUp.-SEP0-			<Nop>
menu <silent> 1.09 PopUp.Find<Tab>/<C-R>+ /<C-R>+<CR>
an 1.095 PopUp.-SEP0-5-			<Nop>

" allow virtualedit in visual mode
set virtualedit=block

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

" syntax highlighting                    {{{1
syntax on                                " enable syntax highlighting
filetype on                              " enable filetype detection
filetype indent on                       " enable filetype-specific indenting
filetype plugin on                       " enable filetype-specific plugins

" MODE MAPPINGS {{{1

" TIP: way to check if mapping is already taken:
" :map x
" where 'x' is the key or keys pressed

" visual studio save shortcut key 
nnoremap <C-S> :w<CR>
inoremap <C-S> <ESC>:w<CR>
vnoremap <C-S> <ESC>:w<CR>gv
" this is the equivalent of <Alt-S>
nnoremap ó :wa<CR>
inoremap ó <ESC>:wa<CR>
vnoremap ó <ESC>:wa<CR>gv

" better way to press escape:
inoremap jj <Esc>
inoremap kj <Esc>:w<CR> 
inoremap jk <Esc>:w<CR>
inoremap ijk <Esc>:w<CR>
inoremap kk <Esc>

" complete options
"   . = current buffer
"   w = windows
"   b = buffers
"   u = unloaded buffers
"   t = tag completion
set complete=.,w,b,u,t

" easy line completion
inoremap <C-L> <C-X><C-L>

" better backtick than single quote
nnoremap ' `

" 'e'dit 'v'imrc, and 's'ource 'v'imrc, respectively)
nnoremap <silent> <Leader>ev :e ~/.vimrc<CR>
nnoremap <silent> <Leader>sv :source ~/.vimrc<CR>

" Return to last edit position when opening files (You want this!) '\" is the cursor position when last exiting the current buffer
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" only have cursorline in current window
autocmd WinLeave * set nocursorline
autocmd WinEnter * set cursorline

" usually want regular line numbers when editing, but relative while in normal mode
autocmd InsertEnter * set norelativenumber
autocmd InsertLeave * set relativenumber

" open a file in p4
if has("win32")
	nnoremap <A-F5> :!p4 open "%:p"<CR><CR>
	vnoremap <A-F5> <ESC>:!p4 open "%:p"<CR><CR>gv
endif

" edit file in visual studio {{{1
" and w/in visual studio, use this for the arguments when running gvim: 
" -c "simalt ~x" --servername gmain --remote-silent +$(CurLine) +"normal zz" $(ItemPath)
function! GotoVisualStudio()
   " save current file if modified
   wall

   " go to visual studio w/ usual process 
   set norelativenumber
   set number
   silent exec '!start "C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\devenv.exe" /edit ' . expand("%")
endfunction
if has("win32")
	noremap <silent> <F7> :call GotoVisualStudio()<CR>
	inoremap <silent> <F7> :call GotoVisualStudio()<CR>
endif

" windows copy/paste like behavior {{{1
nnoremap <C-C> "+yy
vnoremap <C-C> "+y
noremap <C-V> "+p

" vim:ft=vim:fdm=marker:relativenumber
