""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""".vimrc"""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""" ENVIRONMENT VARIABLES
" small workaround to make clangd work on my ubuntu 22.04 machine
" also make sure that it won't work on my macos machine
if has('unix') && !has('mac')
    let $CPLUS_INCLUDE_PATH='/usr/lib/llvm-14/include/c++/v1/'
endif

"""""" PLUGIN INSTALLATION
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
    " let Vundle manage Vundle, required
    Plugin 'VundleVim/Vundle.vim'

    Plugin 'jiangmiao/auto-pairs'
    Plugin 'preservim/nerdtree'
    Plugin 'vim-scripts/a.vim'
    Plugin 'tpope/vim-surround'
    Plugin 'morhetz/gruvbox'
    Plugin 'christoomey/vim-tmux-navigator'
    Plugin 'tpope/vim-fugitive'
    Plugin 'lambdalisue/suda.vim'

    " syntax highlighting
    Plugin 'grisumbras/vim-b2'
    Plugin 'dag/vim-fish'
    Plugin 'jneen/ragel.vim'

    " disable vim-lsp if using vimdiff
    if !&diff
        Plugin 'prabirshrestha/vim-lsp'
        Plugin 'mattn/vim-lsp-settings'
    endif
call vundle#end()
filetype plugin indent on

packadd termdebug


"""""" COLORSCHEME
colorscheme gruvbox
set background=dark
syntax on


"""""" KEYS REMAP
" vim-lsp mappings
nnoremap gd :LspDefinition<CR>
nnoremap gD :LspDeclaration<CR>
nnoremap gl :LspReferences<CR>
nnoremap gI :LspImplementation<CR>
" exit terminal by esc
tnoremap <Esc> <C-\><C-n> 
" switch between *.c and *.h via A.vim
nnoremap gc :A<CR>
" copy `+<line_number> <filename>`
nnoremap yp :let @+='+' . line(".") . ' ' . expand("%")<CR>
" copy `<filename>:<line_number>`
nnoremap yP :let @+=expand("%") . ':' . line(".")<CR>
" NERDTree mappings
nnoremap \nt :NERDTreeToggle<CR>
nnoremap \nf :NERDTreeFind<CR>


"""""" CUSTOM COMMANDS
" clear search highlight
command CS let @/ = ""


"""""" PLUGIN SETTINGS
" enable human layout for termdebug
let g:termdebug_wide=1


"""""" CODESTYLE INIT FUNCTIONS
function GnuCodeStyle()
    set tabstop=8 shiftwidth=2 softtabstop=2 noexpandtab
    set ai cin cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
endfunction

function DrwCodeStyle()
    " tab settings (expandtab changes tabs to spaces)
    set tabstop=4 shiftwidth=4 softtabstop=4 expandtab
    " autoindent settings. cinoptions are fucky, so tldr:
    " `l1` = don't fuck up curly braces in `case`
    " `g0` = `private`, `public`, `protected` not indented
    " `N-s` = namespaces not indented
    " `(0,W4` = `void foo(<CR> /* next line is 4 space indented`
    " `(s,m1` = `void foo(<CR>` will have `)` on beginning of the next line
    " `j1` = don't fuck up lambda definitions in an argument list
    set ai cin cinoptions=l1,g0,N-s,(0,W4,(s,m1,j1
endfunction


"""""" GENERAL VIM SETTINGS
" numbers on left
set number
" autocompletions in command mode
set wildmenu wildmode=list,longest,full
" long lines will be wrapped onto next line
set linebreak wrap
" search config
set showmatch hlsearch incsearch
" russian layout settings. includes setting default layout to english (last
" two commands)
set keymap=russian-jcukenwin iminsert=0 imsearch=0
" Xorg settings
set clipboard=unnamedplus mouse=a
" angle brackets matching behaviour
set matchpairs+=<:>
" fuzzy finder (use with `:find`)
set path+=**
" do not fold file by default
set nofoldenable
" set codestyle
call DrwCodeStyle()
