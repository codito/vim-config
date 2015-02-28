My vimrc and vim configuration files.

# Usage
In linux

        git clone git@github.com:codito/vim-config.git ~/.vim
        ln -s ~/.vim/vimrc ~/.vimrc
        cd ~/.vim
        python ./update.py

In Windows

        git clone git@github.com:codito/vim-config.git ~\vimfiles
        # ~ is your %userprofile% or %home%
        # cmd /c mklink %userprofile%\_vimrc %userprofile%\vimfiles\vimrc
        # cmd /c mklink %userprofile%\_gvimrc %userprofile%\vimfiles\gvimrc
        # cd ~\vimfiles
        # python .\update.py

# Plugins
**Bundles.json** lists the plugins
**Update.py** is a simple script to add/update the scripts, requires pathogen.vim

Refer **Plugins** section in _vimrc_ for details on configuration.
