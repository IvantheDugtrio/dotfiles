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
        echo -n "Do you want tmux to start by default (y/N)? "
        read tmuxprompt
        if [[ "$tmuxprompt" == "y" || "$tmuxprompt" == "Y" ]]; then
            echo "Starting tmux by default"
            if [[ "$distro" == "bsd" ]]; then
                cp `pwd`/.bashrc ~/.bash_profile
                source ~/.bash_profile
            elif [[ "$distro" == "win32" ]]; then
                # Figure out later
                cp `pwd`/.bashrc ~/.bashrc
                source ~/.bashrc
            elif [[ "$distro" != "" ]]; then
                cp `pwd`/.bashrc ~/.bashrc
                source ~/.bashrc
            fi
        else
            if [[ "$distro" == "bsd" ]]; then
                cp `pwd`/.bashrc_notmux ~/.bash_profile
                source ~/.bash_profile
            elif [[ "$distro" == "win32" ]]; then
                # Figure out later
                cp `pwd`/.bashrc_notmux ~/.bashrc
                source ~/.bashrc
            elif [[ "$distro" != "" ]]; then
                cp `pwd`/.bashrc_notmux ~/.bashrc
                source ~/.bashrc
            fi
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
            cp `pwd`/.tmux.conf ~/.tmux.conf
            cp -r `pwd`/.tmux ~/
        else
            # use old .tmux.conf
            cp `pwd`/.tmux.conf.old ~/.tmux.conf
            cp -ar `pwd`/.tmux ~/
        fi
    else
        echo "Skipping .tmux and .tmux.conf"
        installTmux="tmux "
    fi

    if [[ $(which vim) ]]; then
        if [[ "$(vim --version | grep 7.4)" ]]; then
            if [ -d ~/.vim ]; then
                rm -rf ~/.vim
            fi
            # Use new .vimrc
            cp `pwd`/.vimrc ~/.vimrc
            cp -ar `pwd`/.vim ~/
        fi
    else
        echo "Skipping .vim and .vimrc"
        installVim="vim "
    fi

    if [[ $(which zsh) ]]; then
        echo "Would you like to install oh-my-zsh (y/N)? "
        read ohmyzshprompt
        if [[ "$ohmyzshprompt" == "y" || "$ohmyzshprompt" == "Y" ]]; then
            echo "Installing oh-my-zsh"
            sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
        fi
    else
        echo "Would you like to install zsh (y/N)? "
        read zshprompt
        if [[ "$zshprompt" == "y" || "$zshprompt" == "Y" ]]; then
            installZsh="zsh "
        fi
    fi
}

# Install bash, tmux, or vim
function installProgs(){
    if [[ $installBash != "" || $installTmux != "" || $installVim != "" ]]; then
        case "$distro" in
            "arch") echo "Updating pacman and installing ${installBash}${installTmux}${installVim}${installZsh}"
                `sudo pacman -Syu $installBash$installTmux$installVim$installZsh`
                ;;
            "rhel fedora") echo "Updating yum and installing ${installBash}${installTmux}${installVim}${installZsh}"
                `sudo yum update`
                `sudo yum install $installBash$installTmux$installVim$installZsh`
                ;;
            "debian") echo "Updating apt-get and installing ${installBash}${installTmux}${installVim}${installZsh}"
                `sudo apt-get update && sudo apt-get upgrade`
                `sudo apt-get install $installBash$installTmux$installVim$installZsh`
                ;;
            *) echo "Install ${installBash}${installTmux}${installVim}${installZsh}manually"
                ;;
        esac
    fi
}

# Run the above functions
getSysInfo
checkProgs
installProgs

exit 0
