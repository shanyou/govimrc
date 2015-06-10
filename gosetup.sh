#!/bin/bash
#
# go env setup script 
# include go and vim ide setup
# the env base on centos 7.0
# reference https://github.com/golang/go/wiki/IDEsAndTextEditorPlugins
#

info() {
    local green="\033[1;32m"
    local normal="\033[0m"
    echo "[${green}info${normal}] $1"
}

export GOPATH=/opt/go
if [ ! -f $GOPATH ]; then
	mkdir $GOPATH -p
fi

info "begin install go"
# setup go with yum
yum install -y go

# install gocode gotags and goimports
# issue: can not get from china for greatwall FW
#info "begin install goimports"
#go get -u -v github.com/bradfitz/goimports

info "begin install gotags"
go get -u -v github.com/jstemmer/gotags

info "begin install gocode"
go get -u -v github.com/nsf/gocode

info "begin install vim and plugins"

# install vim ide related pkg
# python and boost used to install vim YCM plugin
yum install -y vim python-devel boost-devel boost

#install Vundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

#get template from git
curl "https://raw.githubusercontent.com/shanyou/govimrc/master/vimrc_template" -o ~/.vimrc

info "copy color schema to vim"
git clone https://github.com/fatih/molokai ~/molokai
mkdir -p ~/.vim/colors
cp ~/molokai/colors/molokai.vim ~/.vim/colors/
rm -rf ~/molokai

# install vim plugin
vim +PluginInstall +qall

info "install cmake"
curl "http://www.cmake.org/files/v3.3/cmake-3.3.0-rc1-Linux-x86_64.sh" -o ~/cmake.sh
chmod +x cmake.sh
cmake_dir=/opt/cmake
if [ ! -f $cmake_dir ];then
    mkdir -p /opt/cmake
fi

~/cmake.sh --prefix=$cmake_dir --skip-license
ln -s $cmake_dir/bin/cmake /usr/bin/cmake

info "compile YCM."
pushd ~/.vim/bundle/YouCompleteMe
./install.sh --gocode-completer --system-boost
popd

info "done with go env setup."
info "the default GOPATH is $GOPATH"
info "enjoin it!!!"
