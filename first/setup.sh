#!/bin/bash
echo "将安装一些必要的插件，可能花费一定的时间，请耐心等待直到安装完成哦……^_^"
# 支持 ubuntu
if which apt-get >/dev/null; then
    sudo apt-get install -y vim vim-gnome ctags xclip astyle python-setuptools python-dev git
# 支持 centos
elif which yum >/dev/null; then
    sudo yum install -y gcc vim git ctags xclip astyle python-setuptools python-devel
# 支持 macos
elif which brew >/dev/null; then
    brew install vim ctags git astyle
fi

sudo easy_install -ZU autopep8
sudo ln -s /usr/bin/ctags /usr/local/bin/ctags

cd ~/ && git clone https://github.com/chambakari/vimfile.git
mv -f ~/.vim ~/.vim_bak
mv -f ~/vimfile ~/.vim
mv -f ~/.vimrc ~/.vimrc_bak
mv -f ~/vimfile/.vimrc ~/

git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

mkdir -p ~/.vim/bundle/pathogen/autoload/
curl -LSso  ~/.vim/bundle/pathogen/autoload/pathogen.vim https://tpo.pe/pathogen.vim

echo "正在努力为您安装bundle程序" > test
echo "安装完毕将自动退出" >> test
echo "请耐心等待" >> test
vim test -c "BundleInstall" -c "q" -c "q"
rm test
echo "安装完成"
