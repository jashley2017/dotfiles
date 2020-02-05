#!/bin/sh
mkdir -p old

# keep your home safe and clean
mv -f ~/.bashrc old/bashrc.old
mv -f ~/.bash_aliases old/bash_aliases.old
mv -f ~/.bash_logout old/bash_logout.old
mv -f ~/.bash_profile old/bash_profile.old
mv -f ~/.vimrc old/.vimrc_old
mv -f ~/.vim old/.vim_old
mv -f ~/.config/nvim old/config_nvim_old

# link the new ones
ln -s $PWD/bashrc.sh ~/.bashrc
ln -s $PWD/bash_aliases.sh ~/.bash_aliases
ln -s $PWD/bash_logout.sh ~/.bash_logout
ln -s $PWD/bash_profile.sh ~/.bash_profile
ln -s $PWD/bashrc.sh ~/.bashrc
ln -s $PWD/vimrc ~/.vimrc
ln -s $PWD/vim ~/.vim
ln -s $PWD/config/nvim ~/.config/nvim

# protect the directory once they are linked
chmod u-w ../dotfiles 
