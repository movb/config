" {{{ BASIC SETUP

" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if &compatible
  set nocompatible               " Be iMproved
endif

syntax enable
set clipboard=unnamed

set path+=**
set wildmenu


" command! MakeTags !ctags -R .

" File bindings
" let g:netrw_banner=0        " disable annoying banner
" let g:netrw_browse_split=4  " open in prior window
" let g:netrw_altv=1          " open splits to the right
" let g:netrw_liststyle=3     " tree view
" let g:netrw_list_hide=netrw_gitignore#Hide()
" let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" }}}

" {{{ Plugins
 " Required:
 set runtimepath+=~/.vim/bundle/neobundle.vim/

 " Required:
 call neobundle#begin(expand('~/.vim/bundle/'))

 " Let NeoBundle manage NeoBundle
 " Required:
 NeoBundleFetch 'Shougo/neobundle.vim'
 NeoBundle 'https://github.com/easymotion/vim-easymotion'
 NeoBundle 'https://github.com/sheerun/vim-polyglot'
 NeoBundle 'https://github.com/tpope/vim-surround'
 NeoBundle 'https://github.com/tomtom/tcomment_vim'
 NeoBundle 'https://github.com/scrooloose/nerdtree'

 call neobundle#end()

 " If there are uninstalled bundles found on startup,
 " this will conveniently prompt you to install them.
 NeoBundleCheck
" }}}

syntax on
filetype plugin indent on
set expandtab
set shiftwidth=4
set softtabstop=4
