grml-etc-core
=============

This repository contains the core /etc files for the Grml system.

Documentation
-------------

* [blog post describing the setup](https://grml.org/console/)
* [zshrc manual page](./doc/grmlzshrc.adoc)

Installation on non-Debian systems
----------------------------------

While generally these files are distributed as a Debian package, named
"grml-etc-core", they are also useful on other systems.

To use the most important files for your user, use the following commands:

    # IMPORTANT: please note that you might overwrite existing
    # configuration files in the current working directory!
    wget -O .screenrc   https://grml.org/console/screenrc
    wget -O .tmux.conf  https://grml.org/console/tmux.conf
    wget -O .vimrc      https://grml.org/console/vimrc
    wget -O .zshrc      https://grml.org/console/zshrc
    # optional:
    # wget -O .zshrc.local https://grml.org/console/zshrc.local
    # wget -O .screenrc_v4   https://grml.org/console/screenrc_v4

Or, on operating systems without wget:

    # IMPORTANT: please note that you might overwrite existing
    # configuration files in the current working directory!
    curl -sSfL -o .screenrc   https://grml.org/console/screenrc
    curl -sSfL -o .tmux.conf  https://grml.org/console/tmux.conf
    curl -sSfL -o .vimrc      https://grml.org/console/vimrc
    curl -sSfL -o .zshrc      https://grml.org/console/zshrc
    # optional:
    # curl -sSfL -o .zshrc.local https://grml.org/console/zshrc.local
    # curl -sSfL -o .screenrc_v4   https://grml.org/console/screenrc_v4
