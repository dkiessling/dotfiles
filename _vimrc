" Location of .vimrc
" ==================
"
" Unix      $HOME/.vimrc
" Windows   $HOME\_vimrc or $VIMR\vimrc
"
" How to install pathogene and 'solarized' colors
" ===============================================
"
" cd ~/.vim
" git clone git://github.com/tpope/vim-pathogen.git
" mkdir bundle
" cd bundle
" git clone git://github.com/altercation/vim-colors-solarized.git
"
" How to change end-of-line format for dos-mac-unix
" =================================================
" http://vim.wikia.com/wiki/File_format
"
" convert from dos/unix to unix
" -----------------------------
" :update           "Save any changes
" :e ++ff=dos       "Edit file again, using dos file format
" :setlocal ff=unix "This buffer will use LF-only line endings when written
" :w                "Write buffer using unix (LF-only) line endings
"
" convert from dos/unix to dos
" ----------------------------
"  :update          "Save any changes
"  :e ++ff=dos      "Edit file again, using dos file format
"  :w               "Write buffer using dos (CRLF) line endings

filetype off
" use pathogen.vim to manage and load plugins
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

filetype plugin on              " enable file type detection, use the default filetype settings
filetype indent on              " load indent files, to automatically do language-dependent indenting

set nocompatible                " no vi compatibility
set modelines=0                 " prevent some exploits having to do with modelines in files

" color settings
syntax on                       " switch syntax highlighting on
colorscheme molokai

" Input support
set backspace=indent,eol,start  " backspacing over everything in insert mode

" Command completion
set wildignore+=*.git,*.hg,*.svn
set wildignore+=*.aux,*.out,*.toc
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest
set wildignore+=*.DS_Store
set wildignore+=*.orig
set wildignore+=*.bak,*.swp
set wildignore+=*.class
set wildmenu                    " command-line completion in an enhanced mode
set wildmode=longest,list,full

" Search
set hlsearch                    " highlight the last used search pattern
set incsearch                   " do incremental searching
set ignorecase                  " searches are case insensitive
set smartcase                   " override 'ignorecase' when pattern has upper case characters

set scrolloff=4                 " minimal number of lines to keep above and below the cursor
set sidescrolloff=2             " minimal number of columns to keep left and right of the cursor
" Size of new GVim window
if has("gui_running")
    set lines=80
    set columns=170
    set colorcolumn=81
    set guioptions-=T           " no toolbar in GUI
endif
set listchars=tab:>.\,eol:\$    " strings to use in 'list' mode
set number                      " show the line number for each line

set cursorline                  " highlight the screen line of the cursor

set autoindent                  " automatically set the indent of a new line
set autoread                    " read open files again when changed outside Vim
set autowrite                   " write a modified buffer on each :next
set browsedir=current           " which directory to use for the file browser
set clipboard=unnamed           " copy to Windows clipboard
set complete+=k                 " scan the files given with the 'dictionary' option
set encoding=utf-8              " character encoding used in vim: "latin1", "utf-8", "euc-jp", "big5", etc.
set expandtab                   " use the appropriate number of spaces to insert a <Tab>

set fileencodings=utf-8         " character encoding for the current file
set fileformats=dos,unix        " format of the line ends

if has("folding")
    set foldenable          " enable folding
    set foldmethod=syntax   " the kind of folding (manual, indent, syntax, expr)
    set foldlevelstart=99   " start editing with all folds open

    " toggle folds
    nnoremap <Space> za
    vnoremap <Space> za
endif

set history=1000                " keep 1000 lines of command line history
" enable the use of the mouse
if has('mouse')
    set mouse=a
endif
set mousehide                   " hide the mouse pointer when characters are typed
set nobackup                    " do not keep a backup file
set noerrorbells                " do not beep
set noswapfile                  " turn of swap files
set wrap                        " do wrap lines
set nowritebackup
set ruler                       " display the current cursor position all the time

set shiftround                  " when at 3 spaces, and I hit > ... go to 4, not to 7
set shiftwidth=4                " number of spaces used for each step of (auto)indent
set showcmd                     " display incomplete commands
set showmatch                   " when inserting a bracket, briefly jump to its match
set showmode                    " display the mode

set smartindent                 " do clever autodindenting
set smarttab
set softtabstop=4               " number of spaces a <Tab> in the text stands for
set spelllang=en,de             " spell checking
set tabstop=4                   " number of spaces a <Tab> in the text stands for
try
    if has("win32") || has("win64")
        set guifont=Lucida_Console:h9:cDEFAULT
        set directory=$TMP
        set backupdir=$TMP      " set the backup directory
        set undodir=$TMP        " set the undo directory
    else
        set guifont=Monospace:h10
        set directory=/tmp
        set backupdir=/tmp      " set the backup directory
        set undodir=/tmp        " set the undo directory
    endif
    set undofile                " saves undo history to an undo file
catch
endtry
set visualbell
set laststatus=2                " always display a status line at the bottom of the window
set statusline=
set statusline+=%-3.3n\                      " buffer number
set statusline+=%f\                          " file name
set statusline+=%h%m%r%w                     " flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&encoding},                " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%=                           " right align
set statusline+=0x%-8B\                      " current char
set statusline+=%-10.(%l,%c%V%)\ %<%P        " offset

if has("autocmd")
    " when vimrc is edited, reload it
    au BufWritePost _vimrc so $HOME\_vimrc

    " remember last location in a file
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

    " set custom file types
    au BufNewFile,BufRead jquery.*.js,*.json set ft=javascript syntax=jquery
    au BufNewFile,BufRead *.ps1,*.psc1 setf ps1

    " for ruby, autoindent with two spaces, always expand tabs
    autocmd FileType ruby,html,javascript,xml,xhtml set autoindent shiftwidth=2 softtabstop=2 expandtab

    " set color for text files
    autocmd FileType text set filetype=markdown
endif

" Mappings
" ========
let mapleader=","

" movement with wrap turned on
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" ROT13 - fun
map <F12> ggVGg?

" smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" clear search highlighting with ESC
nnoremap <esc> :noh<cr><esc>

" moving lines with enter and shift enter
map <CR> o<Esc>k
map <S-Enter> O<Esc>j

" shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>

" insert blank lines without going into insert mode
nmap t o<ESC>k
nmap T O<ESC>j
