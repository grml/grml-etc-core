grml-etc-core
=============

This repository contains the core /etc files for the Grml system.

While generally these files are distributed as a Debian package, named
"grml-etc-core", they are also useful on other systems.

To use the most important files for your user, use the following commands:

    # IMPORTANT: please note that you might override existing
    # configuration files in the current working directory!
    wget -O .screenrc     http://git.grml.org/f/grml-etc-core/etc/grml/screenrc_generic
    wget -O .vimrc        http://git.grml.org/f/grml-etc-core/etc/vim/vimrc
    wget -O .zshrc        http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc


Or, on operating systems without wget:

    # IMPORTANT: please note that you might override existing
    # configuration files in the current working directory!
    curl -Lo .screenrc    http://git.grml.org/f/grml-etc-core/etc/grml/screenrc_generic
    curl -Lo .vimrc       http://git.grml.org/f/grml-etc-core/etc/vim/vimrc
    curl -Lo .zshrc       http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc


Further information is available from http://grml.org/console/

