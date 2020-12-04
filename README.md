grml-etc-core
=============

This repository contains the core /etc files for the Grml system.

While generally these files are distributed as a Debian package, named
"grml-etc-core", they are also useful on other systems.

To use the most important files for your user, use the following commands:

    # IMPORTANT: please note that you might override existing
    # configuration files in the current working directory!
    wget -O .screenrc     https://git.grml.org/f/grml-etc-core/etc/grml/screenrc_generic
    wget -O .tmux.conf    https://git.grml.org/f/grml-etc-core/etc/tmux.conf
    wget -O .vimrc        https://git.grml.org/f/grml-etc-core/etc/vim/vimrc
    wget -O .zshrc        https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc


Or, on operating systems without wget:

    # IMPORTANT: please note that you might override existing
    # configuration files in the current working directory!
    curl -Lo .screenrc    https://git.grml.org/f/grml-etc-core/etc/grml/screenrc_generic
    curl -Lo .tmux.conf   https://git.grml.org/f/grml-etc-core/etc/tmux.conf
    curl -Lo .vimrc       https://git.grml.org/f/grml-etc-core/etc/vim/vimrc
    curl -Lo .zshrc       https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc


Further information is available from https://grml.org/console/

