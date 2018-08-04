# 使用
## 自动安装

运行脚本 ./setup.sh 即可。

## 手动安装

### 01 前提条件
安装之前先确保环境上安装了以下包：
#### ubuntu
```
sudo apt-get install -y vim vim-gnome ctags xclip astyle python-setuptools python-dev git
```

#### centos
```
sudo yum install -y gcc vim git ctags xclip astyle python-setuptools python-devel
```

#### macos
```
brew install vim ctags git astyle
```

可能还需要：
```
sudo easy_install -ZU autopep8 
```

### 02 clone 到本地
```
cd ~/ && git clone https://github.com/chambakari/vimfile.git
```

### 03 替换使用
```
mv -f ~/.vim ~/.vim_bak
mv -f ~/vimfile ~/.vim
mv -f ~/.vimrc ~/.vimrc_bak
mv -f ~/.vim/.vimrc ~/
```

### 04 安装插件
clone bundle 程序：
```
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
```

打开 vim 并执行 bundle 程序:BundleInstall

然后，安装 pathogen
```
mkdir -p ~/.vim/bundle/pathogen/autoload/    
curl -LSso ~/.vim/bundle/pathogen/autoload/pathogen.vim https://tpo.pe/pathogen.vim
```

然后打开 vim 就可以看到效果。
