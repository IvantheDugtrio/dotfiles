#!/usr/bin/env bash

# Replace existing dotfiles with those in this repo

# Initialize variables
distro=""
installBash=""
installTmux=""
installVim=""

# Get OS type and distro
function getSysInfo(){
    # Find linux version
    if [[ "$OSTYPE" == *"linux"* ]]; then
        quotesDistro="$(cut -d= -f 2- <<< `cat /etc/*-release | grep ID_LIKE`)"
        tempDistro="${quotesDistro%\"}"
        distro="${tempDistro#\"}"
    elif [[ "$OSTYPE" == *"darwin"* || "$OSTYPE" == *"freebsd"* ]]; then
        distro="bsd"
    elif [[ "$OSTYPE" == *"cygwin"* || "$OSTYPE" == *"msys"* || "$OSTYPE" == *"win32"* ]]; then
        distro="win32"
    fi
    echo "This system is based off of $distro"
}

# Check for bash, tmux, and vim
function checkProgs(){
    if [[ $(which bash) ]]; then
        if [[ "$distro" == "bsd" ]]; then
            cp `pwd`/.bashrc ~/.bash_profile
        elif [[ "$distro" == "win32" ]]; then
            # Figure out later
            cp `pwd`/.bashrc ~/.bashrc
        elif [[ "$distro" != "" ]]; then
            cp `pwd`/.bashrc ~/.bashrc
        fi
    else
        # Skip for now
        echo "Skipping .bashrc"
        installBash="bash "
    fi

    if [[ $(which tmux) ]]; then
        # tmux is installed!
        if [[ "$(tmux -V | grep 2)" ]]; then
            # Use new .tmux.conf
            exec cp `pwd`/.tmux.conf ~/.tmux.conf
            exec cp -r `pwd`/.tmux ~/.tmux
        else
            # use old .tmux.conf
            exec cp `pwd`/.tmux.conf.old ~/.tmux.conf
            exec cp -r `pwd`/.tmux ~/.tmux
        fi
    else
        echo "Skipping .tmux and .tmux.conf"
        installTmux="tmux "
    fi

    if [[ $(which vim) ]]; then
        if [[ "$(vim --version | grep 7.4)" ]]; then
            # Use new .vimrc
            exec cp `pwd`/.vimrc ~/.vimrc
            exec cp -r `pwd`/.vim ~/.vim
        fi
    else
        echo "Skipping .vim and .vimrc"
        installVim="vim "
    fi
}

# Install bash, tmux, or vim
function installProgs(){
    if [[ $installBash != "" || $installTmux != "" || $installVim != "" ]]; then
        case "$distro" in
            "arch") echo "Updating pacman and installing ${installBash}${installTmux}${installVim}"
                `sudo pacman -Syu $installBash $installTmux $installVim`
                ;;
            "rhel fedora") echo "Updating yum and installing ${installBash}${installTmux}${installVim}"
                `sudo yum update`
                `sudo yum install $installBash $installTmux $installVim`
                ;;
            "debian") echo "Updating apt-get and installing ${installBash}${installTmux}${installVim}"
                `sudo apt-get update && sudo apt-get upgrade`
                `sudo apt-get install $installBash $installTmux $installVim`
                ;;
            *) echo "Install ${installBash}${installTmux}${installVim}manually"
                ;;
        esac
    fi
}

# Run the above functions
getSysInfo
checkProgs
installProgs

exit 0
