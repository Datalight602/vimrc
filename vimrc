" ------------------------------------------------
" starter vimrc file
" Last modified: Mon Mar 10, 2014  02:27PM
" ------------------------------------------------
"
" must do this before any other mappings
let mapleader = ","

" reset all autocmds
autocmd!

" pathogen
"execute pathogen#infect()

" syntax & color
syntax on
"set background=dark
"colorscheme solarized
if has('gui_running')
  set guifont=Consolas:h11
endif

" wildmenu
set wildmenu
set wildmode=list:longest,full

" Edit vimrc
"nnoremap <silent> ,ev :e $HOME/vimrc/_vimrc<cr>
"nnoremap <silent> ,es :so $HOME/vimrc/_vimrc<cr>

" auto reading/writing  {{{1
set autoread							 " auto read externalled modified files

" UI {{{1
set nocompatible						 " no vi compatibility
"set cursorline							 " show cursor line by default
set number								 " turn on line numbering
set nowrap								 " no line wrapping on default
set nobackup							 " no more ~ files
set nowritebackup						 " no more ~ files
set noundofile							 " no more un~ files

" indentation {{{1
set autoindent                           " autoindent
set noexpandtab                          " use tab characters
set shiftwidth=4                         " tab size
set tabstop=4                            " tab size
set listchars=tab:>.,trail:.,extends:\

" searching {{{1
"set gdefault                             " default /g in substrings
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
