" ------------------------------------------------
" starter vimrc file
" Last modified: Tue Mar 20 23:40:52 PDT 2018
" ------------------------------------------------
"
" must do this before any other mappings
let mapleader = ","

" reset all autocmds
autocmd!

" syntax & color
syntax on
colorscheme darkblue

" wildmenu
set wildmenu
set wildmode=list:longest,full

" auto reading/writing  {{{1
set autoread							 " auto read externalled modified files

" UI {{{1
set nocompatible						 " no vi compatibility
set cursorline							 " show cursor line by default
set number								 " turn on line numbering
set nowrap								 " no line wrapping on default
set nobackup							 " no more ~ files
set nowritebackup						 " no more ~ files
set noundofile							 " no more un~ files

" indentation {{{1
set autoindent                           " autoindent
set expandtab                          " use spaces
set shiftwidth=4 tabstop=4               " tab size
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
