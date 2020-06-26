vimrc 配置文件参考 `.vimrc`，具体的意思直接看文件中的注释即可。更多更全的内容可以参考[这里](https://raw.githubusercontent.com/BroQiang/vim-go-ide/master/vimrc)。

最终配置好的效果如下图：

![](/images/govim.png)



配置过程：

1、安装 Go 环境：

```sh
wget https://dl.google.com/go/go1.14.4.linux-amd64.tar.gz
sudo tar xzvf go1.14.4.linux-amd64.tar.gz -C /usr/local/
```



配置 PATH 和 GOPATH：

```sh
# 这是默认的位置，也可以按照需求指定到其他目录
mkdir -p $HOME/go/{bin,pkg,src}
```



然后，`vim /etc/profile.d/go.sh`

```sh
export GOPATH=$HOME/go
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
```

然后，`source /etc/profile.d/go.sh ` 生效



2、添加 `.vimrc` 到 `~/.vimrc`



3、安装基本插件，推荐使用 [vim-plug](https://github.com/junegunn/vim-plug) 这个插件，[Vundle](https://github.com/VundleVim/Vundle.vim) 当插件装多了会不太流畅。

 ```sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
 ```



然后进入 `~/.vimrc` 输入 `:PlugInstall` 安装插件。

当看见 `Finishing … Done` 的内容，即表示插件安装成功了。



4、安装 `vim-go` 插件工具

进入 `~/.vimrc` ，输入 `:GoInstallBinaries`，当出现 `vim-go: installing finished!`，即表示安装成功了，可以使用 Go 插件的相关功能了。



**问题：** 这里会从 `golang.org` 下载相关工具，由于 `golang.org` 在 Google 的服务器上，会被墙，没有梯子是安装不了的。具体有哪些工具，可以进入 `vim ~/.vim/plugged/vim-go/plugin/go.vim` 文件中查看，如下：

```sh
let s:packages = {
    \ 'asmfmt':        ['github.com/klauspost/asmfmt/cmd/asmfmt@master'],
    \ 'dlv':           ['github.com/go-delve/delve/cmd/dlv@master'],
    \ 'errcheck':      ['github.com/kisielk/errcheck@master'],
    \ 'fillstruct':    ['github.com/davidrjenni/reftools/cmd/fillstruct@master'],
    \ 'godef':         ['github.com/rogpeppe/godef@master'],
    \ 'goimports':     ['golang.org/x/tools/cmd/goimports@master'],
    \ 'golint':        ['golang.org/x/lint/golint@master'],
    \ 'gopls':         ['golang.org/x/tools/gopls@latest', {}, {'after': function('go#lsp#Restart', [])}],
    \ 'golangci-lint': ['github.com/golangci/golangci-lint/cmd/golangci-lint@master'],
    \ 'gomodifytags':  ['github.com/fatih/gomodifytags@master'],
    \ 'gorename':      ['golang.org/x/tools/cmd/gorename@master'],
    \ 'gotags':        ['github.com/jstemmer/gotags@master'],
    \ 'guru':          ['golang.org/x/tools/cmd/guru@master'],
    \ 'impl':          ['github.com/josharian/impl@master'],
    \ 'keyify':        ['honnef.co/go/tools/cmd/keyify@master'],
    \ 'motion':        ['github.com/fatih/motion@master'],
    \ 'iferr':         ['github.com/koron/iferr@master'],
    \ }
```



其中，凡是来源于 `golang.org` 的包都会安装失败，对于这些包，我们只能手动安装了。

如何手动安装呢？

**方法一：配置代理**

在 `/etc/profile` 中加入如下配置，然后 `source /etc/profile` 生效。

```sh
# Enable the go modules feature
export GO111MODULE=on
# Set the GOPROXY environment variable
export GOPROXY=https://goproxy.io
```



**方法二：go get**

幸运的是，在 `github` 上有 `golang.org` 所有包的同名镜像 `mirror`，在 `github` 上 `golang` 的[项目主页](https://github.com/golang) 上可以看到，搜索`mirror`关键字即可查看所有的镜像包：

![](/images/gomirror.png)

所以要做的就是，缺什么包，就到上面下载什么包进行手动安装即可。

可以通过 `go get` 下载并安装，比如：

```sh
go get github.com/golang/tools/cmd/goimports
go get github.com/golang/tools/cmd/guru
go get github.com/golang/tools/cmd/gorename
```



**特别注意：** 该方法和下面的方法都需要依赖 Go 的两个环境变量 `GOROOT` 和 `GOPATH`，所以，在安装之前请先确保这两个环境变量配置正确了。



**方法三：go install**

也可以先 `git clone` 相关包下到本地，再用 `git install`一个个进行安装：

```sh
git clone https://github.com/golang/tools.git $GOPATH/src/golang.org/x/tools
go install golang.org/x/tools/cmd/guru
# 安装成功后就可以在$GOPATH/bin 目录下看到guru的二进制文件了
```

其余的包一样安装，就不再累赘了。

不过提一下，有些包需要依赖其他的包，都要一并下载安装，比如 gopls 包

```sh
git clone https://github.com/golang/tools/gopls $GOPATH/src/golang.org/x/tools/gopls

# 依赖以下包

git clone https://github.com/sergi/go-diff.git $GOPATH/src/sergi/go-diff
git clone https://github.com/BurntSushi/toml $GOPATH/src/BurntSushi/toml
git clone https://github.com/golang/sync.git $GOPATH/src/golang.org/x/sync
git clone https://github.com/golang/xerrors.git $GOPATH/src/golang.org/x/xerrors
git clone https://github.com/golang/tools $GOPATH/src/golang.org/x/tools

# 再执行
go install golang.org/x/tools/gopls
```



当用上面任何一个方法安装完所有包之后，就可以再次进入 Vim 用 `:GoInstallBinaries`，这次应该会一切顺利了。



5、其他插件配置

**YouCompleteMe**

这个插件是自动完成的，不过也需要手动做一些额外的配置

```sh
# 安装依赖包
sudo apt install build-essential cmake python3-dev
```

```sh
# 编译
cd ~/.vim/plugged/YouCompleteMe
# 编译，并加入 go 的支持
python3 install.py --go-completer 
```

```sh
# 配置和 SirVer/ultisnips 冲突的快捷键
let g:ycm_key_list_select_completion = ['<C-n>', '<space>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
```



**其他插件**

其他的插件配置不多，直接看配置文件的注释即可，下面将所有的配置全部贴出来。

下面是全部的 `~/.vimrc` 中的配置，也可以直接下载这个比较全的 [vimrc](https://raw.githubusercontent.com/BroQiang/vim-go-ide/master/vimrc) 文件。

```sh
"==============================================================================
" vim 内置配置 
"==============================================================================

" 设置 vimrc 修改保存后立刻生效，不用在重新打开
" 建议配置完成后将这个关闭，否则配置多了之后会很卡
" autocmd BufWritePost $MYVIMRC source $MYVIMRC

" 关闭兼容模式
set nocompatible

set nu " 设置行号
set cursorline "突出显示当前行
" set cursorcolumn " 突出显示当前列
set showmatch " 显示括号匹配

" tab 缩进
set tabstop=4 " 设置Tab长度为4空格
set shiftwidth=4 " 设置自动缩进长度为4空格
set autoindent " 继承前一行的缩进方式，适用于多行注释

" 定义快捷键的前缀，即<Leader>
let mapleader=";" 

" ==== 系统剪切板复制粘贴 ====
" v 模式下复制内容到系统剪切板
vmap <Leader>c "+yy
" n 模式下复制一行到系统剪切板
nmap <Leader>c "+yy
" n 模式下粘贴系统剪切板的内容
nmap <Leader>v "+p

" 开启实时搜索
set incsearch
" 搜索时大小写不敏感
set ignorecase
syntax enable
syntax on                    " 开启文件类型侦测
filetype plugin indent on    " 启用自动补全

" 退出插入模式指定类型的文件自动保存
au InsertLeave *.go,*.sh,*.php write

"==============================================================================
" 插件配置 
"==============================================================================

" 插件开始的位置
call plug#begin('~/.vim/plugged')

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
" 可以快速对齐的插件
Plug 'junegunn/vim-easy-align'

" 用来提供一个导航目录的侧边栏
Plug 'scrooloose/nerdtree'

" 可以使 nerdtree Tab 标签的名称更友好些
Plug 'jistr/vim-nerdtree-tabs'

" 可以在导航目录中看到 git 版本信息
Plug 'Xuyuanp/nerdtree-git-plugin'

" 查看当前代码文件中的变量和函数列表的插件，
" 可以切换和跳转到代码中对应的变量和函数的位置
" 大纲式导航, Go 需要 https://github.com/jstemmer/gotags 支持
Plug 'majutsushi/tagbar'

" 自动补全括号的插件，包括小括号，中括号，以及花括号
Plug 'jiangmiao/auto-pairs'

" Vim状态栏插件，包括显示行号，列号，文件类型，文件名，以及Git状态
Plug 'vim-airline/vim-airline'

" 有道词典在线翻译
Plug 'ianva/vim-youdao-translater'

" 代码自动完成，安装完插件还需要额外配置才可以使用
Plug 'Valloric/YouCompleteMe'

" 可以在文档中显示 git 信息
Plug 'airblade/vim-gitgutter'


" 下面两个插件要配合使用，可以自动生成代码块
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" 配色方案
" colorscheme neodark
Plug 'KeitaNakamura/neodark.vim'
" colorscheme monokai
Plug 'crusoexia/vim-monokai'
" colorscheme github 
Plug 'acarapetis/vim-colors-github'
" colorscheme one 
Plug 'rakr/vim-one'

" go 主要插件
Plug 'fatih/vim-go', { 'tag': '*' }
" go 中的代码追踪，输入 gd 就可以自动跳转
Plug 'dgryski/vim-godef'

" markdown 插件
Plug 'iamcco/mathjax-support-for-mkdp'
Plug 'iamcco/markdown-preview.vim'

" 插件结束的位置，插件全部放在此行上面
call plug#end()


"==============================================================================
" 主题配色 
"==============================================================================

" 开启24bit的颜色，开启这个颜色会更漂亮一些
set termguicolors
" 配色方案, 可以从上面插件安装中的选择一个使用 
colorscheme one " 主题
set background=dark " 主题背景 dark-深色; light-浅色


"==============================================================================
" vim-go 插件
"==============================================================================
let g:go_fmt_command = "goimports" " 格式化将默认的 gofmt 替换
let g:go_autodetect_gopath = 1
let g:go_list_type = "quickfix"

let g:go_version_warning = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_methods = 1
let g:go_highlight_generate_tags = 1

let g:godef_split=2


"==============================================================================
" NERDTree 插件
"==============================================================================

" 打开和关闭NERDTree快捷键
map <F10> :NERDTreeToggle<CR>
" 显示行号
let NERDTreeShowLineNumbers=1
" 打开文件时是否显示目录
let NERDTreeAutoCenter=1
" 是否显示隐藏文件
let NERDTreeShowHidden=0
" 设置宽度
" let NERDTreeWinSize=31
" 忽略一下文件的显示
let NERDTreeIgnore=['\.pyc','\~$','\.swp']
" 打开 vim 文件及显示书签列表
let NERDTreeShowBookmarks=2

" 在终端启动vim时，共享NERDTree
let g:nerdtree_tabs_open_on_console_startup=1


"==============================================================================
"  majutsushi/tagbar 插件
"==============================================================================

" majutsushi/tagbar 插件打开关闭快捷键
nmap <F9> :TagbarToggle<CR>

let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }


"==============================================================================
"  nerdtree-git-plugin 插件
"==============================================================================
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "",
    \ "Dirty"     : "✗",
    \ "Clean"     : "︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

let g:NERDTreeShowIgnoredStatus = 1



"==============================================================================
"  Valloric/YouCompleteMe 插件
"==============================================================================

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<space>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"


"==============================================================================
"  其他插件配置
"==============================================================================

" markdwon 的快捷键
map <silent> <F5> <Plug>MarkdownPreview
map <silent> <F6> <Plug>StopMarkdownPreview

" tab 标签页切换快捷键
:nn <Leader>1 1gt
:nn <Leader>2 2gt
:nn <Leader>3 3gt
:nn <Leader>4 4gt
:nn <Leader>5 5gt
:nn <Leader>6 6gt
:nn <Leader>7 7gt
:nn <Leader>8 8gt
:nn <Leader>9 8gt
:nn <Leader>0 :tablast<CR>


"==============================================================================
" GVim 的配置
"==============================================================================
" 如果不使用 GVim ，可以不用配置下面的配置
if has('gui_running')
        colorscheme one
    " 设置启动时窗口的大小
    set lines=999 columns=999 linespace=4

    " 设置字体及大小
        set guifont=Roboto\ Mono\ 13

    set guioptions-=m " 隐藏菜单栏
    set guioptions-=T " 隐藏工具栏
    set guioptions-=L " 隐藏左侧滚动条
    set guioptions-=r " 隐藏右侧滚动条
    set guioptions-=b " 隐藏底部滚动条
            " 在 gvim 下不会和 terminal 的 alt+数字的快捷键冲突，
    " 所以将 tab 切换配置一份 alt+数字的快捷键
    :nn <M-1> 1gt
    :nn <M-2> 2gt
    :nn <M-3> 3gt
    :nn <M-4> 4gt
    :nn <M-5> 5gt
    :nn <M-6> 6gt
    :nn <M-7> 7gt
    :nn <M-8> 8gt
        :nn <M-9> 9gt
        :nn <M-0> :tablast<CR>
endif
```



---

参考：

https://cloud.tencent.com/developer/article/1533830

https://www.jianshu.com/p/8426cef1f4f5

https://blog.csdn.net/Wind4study/article/details/104561976

https://learnku.com/articles/24924