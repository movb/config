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
 
 NeoBundle 'vim-airline/vim-airline'
 NeoBundle 'vim-airline/vim-airline-themes'

 NeoBundle 'edkolev/tmuxline.vim'

 NeoBundle 'altercation/vim-colors-solarized'

 call neobundle#end()

 " If there are uninstalled bundles found on startup,
 " this will conveniently prompt you to install them.
 NeoBundleCheck
" }}}

set autoread                             " Перечитывать открытые файлы если они были изменены извне

filetype on                              " Включаем распознавание типов файлов и типо-специфичные плагины
filetype plugin on
filetype indent on

set encoding=utf-8                       " Кодировка по-умолчанию utf-8
set termencoding=utf-8                   " Кодировка терминала тоже utf-8
set fileencodings=utf-8,cp1251,koi8-r    " Список кодировок, которые vim будет перебирать при открытии файла

set novisualbell                         " Выключаем бибиканье и мигание
set t_vb=

set si                                   " Умное добавление табов (с учетом скобок и пр.)
set tabstop=4                            " Ширина таба - 4 пробела
set shiftwidth=4                         " Количество вставляемых пробелов при использовании < и >
set expandtab                            " Разворачивать табы в пробелы
set smarttab                             " Удалять пробелы по 4, если они в начале строки

syntax on

set number                               " Включить нумерацию строк
set cursorline                           " Подсвечивать текущую строку
set cursorcolumn                         " Подсвечивать текущую колонку - опция на любителя
set t_Co=256                             " Сказать виму, что твой терминал поддерживает 256 цветов

" AirLine
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'
let g:airline_theme='solarized'
let g:solarized_termcolors=256
set background=dark
colorscheme solarized

" Key Remappings for russian keyboard
map ё `
map й q
map ц w
map у e
map к r
map е t
map н y
map г u
map ш i
map щ o
map з p
map х [
map ъ ]
map ф a
map ы s
map в d
map а f
map п g
map р h
map о j
map л k
map д l
map ж ;
map э '
map я z
map ч x
map с c
map м v
map и b
map т n
map ь m
map б ,
map ю .
map Ё ~
map Й Q
map Ц W
map У E
map К R
map Е T
map Н Y
map Г U
map Ш I
map Щ O
map З P
map Х {
map Ъ }
map Ф A
map Ы S
map В D
map А F
map П G
map Р H
map О J
map Л K
map Д L
map Ж :
map Э "
map Я Z
map Ч X
map С C
map М V
map И B
map Т N
map Ь M
map Б <
map Ю >
