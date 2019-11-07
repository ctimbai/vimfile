" ***************** 全局设置 ************** "

" 开启文件类型侦测
filetype on
" 根据侦测到的不同类型加载对应的插件
filetype plugin on

" 自动缩进
filetype indent on

" 开启语法高亮功能
syntax enable
" 允许用指定语法高亮配色方案替换默认方案
syntax on

set nocompatible "关闭兼容模式
set incsearch "开启实时搜索功能
set ignorecase "搜索时忽略大小写
set smartcase "搜索时如果只包含小写字母，匹配结果忽略大小写，如果包含大写字母，匹配结果是大小写敏感。
set wildmenu "vim命令自动补全
set autoread "文件自动更新
set gcr=a:block-blinkon0 "禁止关闭闪烁
set laststatus=2 "总是显示状态栏
set ruler "显示光标位置
set number "显示行号
set cursorline "高亮显示当前行
"set cursorcolumn "高亮显示当前列
set hlsearch "高亮显示搜索结果
" set nowrap "禁止折行
set backspace=2 "回退键生效
"set backspace=indent,eol,start

" set {} 自动换行缩进
set smartindent
imap { {}<ESC>i<CR>

" 禁止显示滚动条
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R

" 禁止显示菜单和工具条
set guioptions-=m
set guioptions-=T

" 将制表符扩展为空格
set expandtab
" 设置编辑时制表符占用空格数
set tabstop=4
" 设置格式化时制表符占用空格数
set shiftwidth=4
" 让 vim 把连续数量的空格视为一个制表符
set softtabstop=4
" 基于缩进或语法进行代码折叠
set foldmethod=syntax
" 启动 vim 时关闭折叠代码
set nofoldenable

" 打开上次文件关闭的位置
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"新文件标题
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"新建.c,.h,.sh,.java文件，自动插入文件头 
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.rb,*.java,*.py exec ":call SetTitle()" 
""定义函数SetTitle，自动插入文件头 
func SetTitle() 
	"如果文件类型为.sh文件 
	if expand("%:e") == 'sh'
		call setline(1,"\#!/bin/bash") 
		call append(line("."), "")
	elseif expand("%:e") == 'py'
		call setline(1,"#!/usr/bin/env python3")
        call append(line("."),"# coding=utf-8")
	    call append(line(".")+1, "")
	elseif expand("%:e") == 'ruby'
		call setline(1,"#!/usr/bin/env ruby")
        call append(line("."),"# encoding: utf-8")
	    call append(line(".")+1, "")	
	else 
		call setline(1, "/******************************************************************************") 
		call append(line("."), " *	File Name: ".expand("%")) 
		call append(line(".")+1, " *	Author: by, 公众号: Linux云计算网络") 
		call append(line(".")+2, " *	Created Time: ".strftime("%c")) 
		call append(line(".")+3, " *****************************************************************************/") 
		call append(line(".")+4, "")
	endif
	if expand("%:e") == 'cpp'
		call append(line(".")+5, "#include <iostream>")
		call append(line(".")+6, "using namespace std;")
		call append(line(".")+7, "")
	endif
	if expand("%:e") == 'c'
		call append(line(".")+5, "#include <stdio.h>")
		call append(line(".")+6, "")
	endif
	if expand("%:e") == 'h'
		call append(line(".")+5, "#ifndef _".toupper(expand("%:r"))."_H")
		call append(line(".")+6, "#define _".toupper(expand("%:r"))."_H")
		call append(line(".")+7, "")
	endif
	"新建文件后，自动定位到文件末尾
endfunc 
autocmd BufNewFile * normal G

" *************** 设置全局快捷键 *****************

" 定义快捷键的前缀，即<Leader>
"let mapleader="\<space>"
"let mapleader="'"
let mapleader=";"

" 设置快捷键将选中文本块复制至系统剪贴板
vnoremap <Leader>y "+y

" 设置快捷键将系统剪贴板内容粘贴至 vim
nmap <Leader>p "+p

" 定义快捷键关闭当前分割窗口
nmap <Leader>q :q<CR>

" 定义快捷键保存当前窗口内容
nmap <Leader>w :w<CR>
" 使用sudo强制保存文件
nmap <Leader>W :w !sudo tee %<CR>

" 定义快捷键保存所有窗口内容并退出 vim
"nmap <Leader>WQ :wa<CR>:q<CR>

" 不做任何保存，直接退出 vim
"nmap <Leader>Q :qa!<CR>

" 跳转至右方的窗口
nnoremap <Leader>l <C-W>l

" 跳转至左方的窗口
nnoremap <Leader>h <C-W>h

" 跳转至上方的子窗口
nnoremap <Leader>k <C-W>k

" 跳转至下方的子窗口
nnoremap <Leader>j <C-W>j

" 清除高亮显示
nmap <Leader>N :noh<CR>

" 定义快捷键在结对符之间跳转
nmap <Leader>M %

nnoremap <Leader>g <C-]>
nnoremap <Leader>b <C-t>


" ************** 插件管理与设置 ************ "

" vundle 环境设置
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
" vundle 管理的插件列表必须位于 vundle#begin() 和 vundle#end() 之间
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'Lokaltog/vim-powerline' "status 美化
Plugin 'octol/vim-cpp-enhanced-highlight' "对c++语法高亮增强
Plugin 'kshenoy/vim-signature' "书签可视化的插件
Plugin 'vim-scripts/BOOKMARKS--Mark-and-Highlight-Full-Lines' "书签行高亮
Plugin 'majutsushi/tagbar' "taglist的增强版，查看标签，依赖于ctags
Plugin 'scrooloose/nerdcommenter' "多行注释，leader键+cc生成, leader+cu删除注释
Plugin 'scrooloose/nerdtree' "文件浏览
Plugin 'Valloric/YouCompleteMe' "自动补全
Plugin 'kien/ctrlp.vim' "搜索历史打开文件，在命令行模式下按ctrl+p触发
Plugin 'vim-scripts/grep.vim' "在命令行模式使用grep命令，:Grep
Plugin 'Lokaltog/vim-easymotion' "快速跳转，按两下leader键和f组合
Plugin 'vim-scripts/ShowTrailingWhitespace.git' "高亮显示行尾的多余空白字符
Plugin 'vim-scripts/indentpython.vim.git'
Plugin 'vim-scripts/Solarized.git' "主题方案
Plugin 'nathanaelkane/vim-indent-guides.git' "缩进对齐显示
"Plugin 'vim-scripts/indexer.tar.gz' "自动生成标签
"Plugin 'vim-scripts/DfrankUtil' "indexer 依赖
"Plugin 'vim-scripts/vimprj' "indexer 依赖
Plugin 'davidhalter/jedi-vim' "python 补全，不依赖于tags,但比较慢，可以使用indexer替换，但不能跳转项目外
Plugin 'vim-scripts/Markdown'
Plugin 'tpope/vim-surround'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'ConradIrwin/vim-bracketed-paste' " 使用bracketed-paste mode，粘贴代码时避免格式化
Plugin 'Raimondi/delimitMate' " 符号自动补全
" 插件列表结束
call vundle#end()
filetype on

" Powerline 设置
" 设置状态栏主题风格
let g:Powerline_colorscheme='solarized256'

" 输入{}自动换行缩进
let delimitMate_expand_cr = 1

" 设置tagbar
" 设置 tagbar 子窗口的位置出现在主编辑区的左边
let tagbar_left=1
" " 设置显示／隐藏标签列表子窗口的快捷键。速记：identifier list by tag
nnoremap <Leader>t :TagbarToggle<CR>
" " 设置标签子窗口的宽度
let tagbar_width=32
" " tagbar 子窗口中不显示冗余帮助信息
let g:tagbar_compact=1
" " 设置 ctags 对哪些代码标识符生成标签

" signature设置
let g:SignatureMap = {
        \ 'Leader'             :  "m",
        \ 'PlaceNextMark'      :  "m,",
        \ 'ToggleMarkAtLine'   :  "m.",
        \ 'PurgeMarksAtLine'   :  "m-",
        \ 'DeleteMark'         :  "dm",
        \ 'PurgeMarks'         :  "mda",
        \ 'PurgeMarkers'       :  "m<BS>",
        \ 'GotoNextLineAlpha'  :  "']",
        \ 'GotoPrevLineAlpha'  :  "'[",
        \ 'GotoNextSpotAlpha'  :  "`]",
        \ 'GotoPrevSpotAlpha'  :  "`[",
        \ 'GotoNextLineByPos'  :  "]'",
        \ 'GotoPrevLineByPos'  :  "['",
        \ 'GotoNextSpotByPos'  :  "mn",
        \ 'GotoPrevSpotByPos'  :  "mp",
        \ 'GotoNextMarker'     :  "[+",
        \ 'GotoPrevMarker'     :  "[-",
        \ 'GotoNextMarkerAny'  :  "]=",
        \ 'GotoPrevMarkerAny'  :  "[=",
        \ 'ListLocalMarks'     :  "ms",
        \ 'ListLocalMarkers'   :  "m?"
        \ }

" 使用 NERDTree 插件查看工程文件。设置快捷键，速记：file list
nmap <Leader>f :NERDTreeToggle<CR>
" 设置NERDTree子窗口宽度
let NERDTreeWinSize=32
" 设置NERDTree子窗口位置
let NERDTreeWinPos="right"
" 显示隐藏文件
let NERDTreeShowHidden=1
" NERDTree 子窗口中不显示冗余帮助信息
let NERDTreeMinimalUI=1
" 删除文件时自动删除文件对应 buffer
let NERDTreeAutoDeleteBuffer=1

" YCM 补全菜单配色
" 菜单
"highlight Pmenu ctermfg=2 ctermbg=3 guifg=#005f87 guibg=#EEE8D5
" 选中项
"highlight PmenuSel ctermfg=2 ctermbg=3 guifg=#AFD700 guibg=#106900
" 补全功能在注释中同样有效
let g:ycm_complete_in_comments=1
" 允许 vim 加载 .ycm_extra_conf.py 文件，不再提示
let g:ycm_confirm_extra_conf=0
" 开启 YCM 标签补全引擎
let g:ycm_collect_identifiers_from_tags_files=1
" 引入 C++ 标准库tags
set tags+=/data/misc/software/misc./vim/stdcpp.tags
" YCM 集成 OmniCppComplete 补全引擎，设置其快捷键
"inoremap <leader>; <C-x><C-o>
" 补全内容不以分割子窗口形式出现，只显示补全列表
set completeopt-=preview
" 从第一个键入字符就开始罗列匹配项
let g:ycm_min_num_of_chars_for_completion=1
" 禁止缓存匹配项，每次都重新生成匹配项
let g:ycm_cache_omnifunc=0
" 语法关键字补全
let g:ycm_seed_identifiers_with_syntax=1
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'


""" color settings
set t_Co=256
if has("gui_running")
    set guioptions=gR
    set mousemodel=popup
    set background=light
    ""hi LineNr cterm=bold guibg=black guifg=white
    ""hi CursorLine cterm=none ctermbg=lightgray ctermfg=none
    ""hi CursorColumn cterm=none ctermbg=lightgray ctermfg=none
else
    set background=dark
    ""hi LineNr cterm=bold ctermbg=black ctermfg=white
    ""hi CursorLine cterm=none ctermbg=darkgray ctermfg=none
    ""hi CursorColumn cterm=none ctermbg=darkgray ctermfg=none
endif

:silent! colorscheme solarized
"colorscheme default

" indent guides
"let g:indent_guides_enable_on_vim_startup=1
" 从第二层开始可视化显示缩进
let g:indent_guides_start_level=2
"let g:indent_guides_auto_colors = 0
"hi IndentGuidesOdd  guibg=red   ctermbg=3
"hi IndentGuidesEven guibg=green ctermbg=4
" 色块宽度
let g:indent_guides_guide_size=1
" 快捷键 i 开/关缩进可视化
noremap <Leader>sj :IndentGuidesToggle<CR>

" 每行不能超过80字符，否则高亮显示
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%80v.\+/
