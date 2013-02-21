" Filename:      /etc/vim/vimrc
" Purpose:       configuration file for vim
" Authors:       grml-team (grml.org), (c) Michael Prokop <mika@grml.org>
" Bug-Reports:   see http://grml.org/bugs/
" License:       This file is licensed under the GPL v2.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" All system-wide defaults are set in $VIMRUNTIME/debian.vim (usually just
" /usr/share/vim/vimcurrent/debian.vim) and sourced by the call to :runtime you
" can find below.  If you wish to change any of those settings, you should do it
" in the file /etc/vim/vimrc.local, since debian.vim will be overwritten
" everytime an upgrade of the vim packages is performed and this file
" (/etc/vim/vimrc) every time the package grml-etc-core is upgraded.  It is
" recommended to make changes after sourcing debian.vim since it alters the
" value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
  runtime! debian.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible', but only if debian.vim is available,
" so let's make sure we run in nocompatible mode:
  set nocompatible

" Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
" set compatible

  set backspace=indent,eol,start        " more powerful backspacing

" Now we set some defaults for the editor
  set autoindent        " always set autoindenting on
" set linebreak         " Don't wrap words by default
  set textwidth=0       " Don't wrap lines by default
  set nobackup          " Don't keep a backup file
  set viminfo='20,\"50  " read/write a .viminfo file, don't store more than
                        " 50 lines of registers
  set history=50        " keep 50 lines of command line history
  set ruler             " show the cursor position all the time

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
  set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" Vim5 and later versions support syntax highlighting.
" Just load the main syntax file when Vim was compiled with "+syntax".
  if has("syntax")
     syntax on
  endif

" Debian uses compressed helpfiles. We must inform vim that the main
" helpfiles is compressed. Other helpfiles are stated in the tags-file.
" set helpfile=$VIMRUNTIME/doc/help.txt.gz

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
  set background=dark

" begin of grml specials:
"  set list listchars=tab:»·
"  set listchars=eol:$,precedes:«,extends:»,tab:··,trail:·
" end of grml specials

" Uncomment the following to have Vim jump to the last position when
" reopening a file
" if has("autocmd")
"   au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
"     \| exe "normal g'\"" | endif
" endif

" Uncomment the following to have Vim load indentation rules according to the
" detected filetype. Per default Debian Vim only load filetype specific
" plugins.
  if has("autocmd")
    filetype indent on
  endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
  set showcmd           " Show (partial) command in status line.
  set showmatch         " Show matching brackets.
" set ignorecase        " Do case insensitive matching
" set smartcase         " Do smart case matching
" set incsearch         " Incremental search
" set autowrite         " Automatically save before commands like :next and :make
" When switching between different buffers you can't use undo without 'set hidden':
  set hidden            " Hide buffers when they are abandoned
" set mouse=a           " Enable mouse usage (all modes) in terminals
  set wildmenu          " command-line completion operates in an enhanced mode

  set pastetoggle=<f11>               " don't change text when copy/pasting
  set dictionary=/usr/share/dict/word " used with CTRL-X CTRL-K

""" set the screen hardstatus to vim(filename.ext)
  if ((&term =~ '^screen') && ($VIM_PLEASE_SET_TITLE =~ '^yes$') || has('gui_running'))
    set t_ts=k
    set t_fs=\
    set title
    autocmd BufEnter * let &titlestring = "vim(" . expand("%:t") . ")"
    let &titleold = fnamemodify(&shell, ":t")
  endif

" turn these ON:
  set ek vb
" set digraph
" turn these OFF ("no" prefix):
  set nodigraph noeb noet nosol
" non-toggles:
  set bs=2 fo=cqrt ls=2 shm=at ww=<,>,h,l
" set bs=2 fo=cqrt ls=2 shm=at tw=72 ww=<,>,h,l
  set comments=b:#,:%,fb:-,n:>,n:)
"  set list listchars=tab:»·,trail:·
  set listchars=eol:$,precedes:«,extends:»,tab:»·,trail:·
  set viminfo=%,'50,\"100,:100,n~/.viminfo
  set tags=./tags,./TAGS,tags,TAGS,../tags,../../tags,../../../tags,../../../../tags

" autocommands:
" when the file type is "mail" then set the textwidth to "70":
  if has("autocmd")
     au FileType mail   set tw=70
" When editing a file, always jump to the last cursor position
"  au BufReadPost * if line("'\"") | exe "'\"" | endif
     autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif
  endif

" some colors - as an example "white on black" [use bold fonts]:
"  hi normal   ctermfg=white  ctermbg=black guifg=white  guibg=black
"  hi nontext  ctermfg=blue   ctermbg=black guifg=blue   guibg=black
" set t_Co=256                " number of colors

" some useful mappings:

" with F7 copy all current buffer to clipboard, or a selection.
" with shift-F7, paste all clipboard contents
" see: http://www.vim.org/tips/tip.php?tip_id=964
  map   <F7>  :w !xclip<CR><CR>
  vmap  <F7>  "*y
  map <S-F7>  :r!xclip -o<CR>

" remove/delete trailing whitespace:
  nmap ;tr :%s/\s\+$//
  vmap ;tr  :s/\s\+$//

" execute the command in the current line (minus the first word, which
" is intended to be a shell prompt) and insert the output in the buffer
  map ,e ^wy$:r!"

" update timestamp
  iab YDATE <C-R>=strftime("%a %b %d %T %Z %Y")<CR>
  map ,L  1G/Latest change:\s*/e+1<CR>CYDATE<ESC>

" the shell in a box mode. found in posting by Stefan `Sec` Zehl
" in newsgroup de.alt.sysadmin.recovery, msg­id:  <df7lhe$2hup$1@ice.42.org>
" Requires zsh for "print -P $PS1" / replace if needed.
" Your prompt should end in > (and only contain one)
" so run something like:
"   % export PS1='%n@%m > '
" in your zsh, press ',l' and <enter> for running commands, end mode via <esc>
  map __start :imap <C-V><C-M> <C-O>__cmd<C-V>\|imap <C-V><ESC> <C-V><ESC>__end<C-M>
  noremap __end :iunmap <C-V><CR>\|iunmap <C-V><ESC><C-M>:"Vish ended.<C-M>
  noremap __cmd 0<ESC>f>ly$:r !<C-R>";print -P $PS1<C-M>A
  noremap __scmd :r !print -P $PS1<c-M>A
  map ,l __start__scmd

" Kill quote spaces (when quoting a quote)
  map ,kqs mz:%s/^> >/>>/<cr>

" Interface to Mercurial Version Control
  if filereadable( "/usr/share/doc/mercurial/examples/vim/hg-menu.vim" )
    source /usr/share/doc/mercurial/examples/vim/hg-menu.vim
  endif

" Vim 7 brings cool new features - see ':he version7'!
" The coolest features of Vim7 by mika
" ====================================
"  1) omni/intellisense completion: use CTRL-X CTRL-O in insert mode to start it [:he compl-omni]
"  2) internal grep: vimgrep foo bar [:he vimgrep]
"  3) tab pages: vim -p file1 file2 - then use the :tab command [:he tabpage]
"     gt -> next tab
"     gT -> previous tab
"  4) undo branches: :undolist / :earlier 2h / :later 2h
"     instead of using u (undo) and CTRL-R (redo), you might experiment with g-
"     and g+ to move through the text state [:he undolist]
"  5) browse remote directories via scp using netrw plugin: :edit scp://host//path/to/ [:he netrw.vim]
"  6) start editing the filename under the cursor and jump to the line
"     number following the file name: press gF [:he gF]
"  7) press 'CTRL-W F' to start editing the filename under the cursor in a new
"     window and jump to the line number following the file name. [:he CTRL-W_F]
"  8) spelling correction (see later for its configuration) [:he spell]:
"      ]s  -> Move to next misspelled word after the cursor.
"      zg  -> Add word under the cursor as a good word to the first name in 'spellfile'
"      zw  -> Like "zg" but mark the word as a wrong (bad) word.
"      z=  -> For the word under/after the cursor suggest correctly spelled words.
" 9)  highlight active cursor line using 'set cursorline' [:he cursorline]
" 10) delete inner quotes inside HTML-code using <C-O>cit (see its mapping later) [:he tag-blocks]
"
if version >= 700
  " Thanks for some ideas to Christian 'strcat' Schneider and Julius Plenz
  " turn spelling on by default:
  "  set spell
  " toggle spelling with F12 key:
    map <F12> :set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>
    set spellfile=~/.vim/spellfile.add
  " change language -  get spell files from http://ftp.vim.org/pub/vim/runtime/spell/ =>
  " cd ~/.vim/spell && wget http://ftp.vim.org/pub/vim/runtime/spell/de.{latin1,utf-8}.spl
  " change to german:
  "  set spelllang=de
  " highlight spelling correction:
  "  highlight SpellBad    term=reverse   ctermbg=12 gui=undercurl guisp=Red       " badly spelled word
  "  highlight SpellCap    term=reverse   ctermbg=9  gui=undercurl guisp=Blue      " word with wrong caps
  "  highlight SpellRare   term=reverse   ctermbg=13 gui=undercurl guisp=Magenta   " rare word
  "  highlight SpellLocale term=underline ctermbg=11 gui=undercurl guisp=DarkCyan  " word only exists in other region

  " set maximum number of suggestions listed to top 10 items:
  set sps=best,10

  " highlight matching parens:
  " set matchpairs=(:),[:],{:},< :>
  " let loaded_matchparen = 1
  " highlight MatchParen term=reverse   ctermbg=7   guibg=cornsilk

  " highlight the cursor line and column:
  " set cursorline
  " highlight CursorLine   term=reverse   ctermbg=7   guibg=#333333
  " highlight CursorColumn guibg=#333333

  " change inner tag - very useful e.g. within HTML-code!
  " ci" will remove the text between quotes, also works for ' and `
  imap <F10> <C-O>cit

  " use the popup menu also when there is only one match:
  " set completeopt=menuone
  " determine the maximum number of items to show in the popup menu for:
  set pumheight=7
  " set completion highlighting:
  "  highlight Pmenu      ctermbg=13     guifg=Black   guibg=#BDDFFF              " normal item
  "  highlight PmenuSel   ctermbg=7      guifg=Black   guibg=Orange               " selected item
  "  highlight PmenuSbar  ctermbg=7      guifg=#CCCCCC guibg=#CCCCCC              " scrollbar
  "  highlight PmenuThumb cterm=reverse  gui=reverse guifg=Black   guibg=#AAAAAA  " thumb of the scrollbar
endif


" To enable persistent undo uncomment following section.
" The undo files will be stored in $HOME/.cache/vim

" if version >= 703
" " enable persistent-undo
"  set undofile
"
"  " store the persistent undo file in ~/.cache/vim
"  set undodir=~/.cache/vim/
"
"  " create undodir directory if possible and does not exist yet
"  let targetdir=$HOME . "/.cache/vim"
"  if isdirectory(targetdir) != 1 && getftype(targetdir) == "" && exists("*mkdir")
"   call mkdir(targetdir, "p", 0700)
"  endif
" endif

" Source a global configuration file if available
" Deprecated by Debian but still supported by grml
  if filereadable("/etc/vim/vimrc.local")
    source /etc/vim/vimrc.local
  endif

" source user-specific local configuration file
  if filereadable(expand("$HOME/.vimrc.local"))
    source $HOME/.vimrc.local
  endif
"# END OF FILE #################################################################
