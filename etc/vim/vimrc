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

" | Begin of defaults.vim related stuff {
" |
" | Comments starting with a bar ('|') are added by the Grml-Team
" | and the settings below override the default.vim configuration everything
" | else is copied from $VIMRUNTIME/defaults.vim.
" |
" | Do *not* source $VIMRUNTIME/defaults.vim (in case no user vimrc is found),
" | since that prevents overwriting values we want to set in this file,
" | instead we set settings similar to what can be found in default.vim below
" |
" | Only do this part when Vim was compiled with the +eval feature.
if 1
  let g:skip_defaults_vim=1
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

" When the +eval feature is missing, the set command above will be skipped.
" Use a trick to reset compatible only when the +eval feature is missing.
silent! while 0
  set nocompatible
silent! endwhile

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Show @@@ in the last line if it is truncated.
" | This features is only available in later versions
if has("patch-7.4.2115")
  set display=truncate
endif

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries.
if has('win32')
  set guioptions-=t
endif

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
"
" | We prefer to disable the mouse usage though and use what we're used
" | from older Vim versions.
" |
" | if has('mouse')
" |   set mouse=a
" | endif
if has('mouse')
  set mouse=
endif

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
  " Revert with ":syntax off".
  syntax on

  " I like highlighting strings inside C comments.
  " Revert with ":unlet c_comment_strings".
  let c_comment_strings=1
endif

" Only do this part when Vim was compiled with the +eval feature.
if 1

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on

  " Put these in an autocmd group, so that you can revert them with:
  " ":augroup vimStartup | au! | augroup END"
  augroup vimStartup
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

  augroup END

endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif

" | End of defaults.vim related stuff }

" Begin of custom Grml configuration {
" The Grml-Team believes that the options and configuration values which override
" the Vim defaults are useful and helpful for our users.
"
" A lot of options are Grml defaults since the very start and we cleaned up as
" much as possible but if you do not like any of these settings feel free to
" change them back in your user vimrc or file a bug and tell us to change the
" default.
"
" The idea behind commented out options and configuration values is to show
" you interesting settings you should know about but we did not set them by
" default because they might have to much of an impact for everyone.
"
" If a commented option precedes an option set by us it usually shows the
" Vim default.

  set autoindent                            " always set autoindenting on
  set dictionary=/usr/share/dict/words      " used with CTRL-X CTRL-K
  set esckeys                               " recognize keys that start with <Esc> in insert mode
  set formatoptions=cqrt                    " list of flags that tell how automatic formatting works
  set laststatus=2                          " when to use a status line for the last window
  set nobackup                              " don't keep a backup file
  set noerrorbells                          " don't ring the bell (beep or screen flash) for error messages
  set nostartofline                         " keep cursor in the same column (if possible) when moving cursor
  set pastetoggle=<f11>                     " don't change text when copy/pasting
  set shortmess=at                          " list of flags to make messages shorter
  set showmatch                             " show matching brackets.
  set textwidth=0                           " don't wrap lines by default
  set viminfo=%,'100,<100,s10,h             " what to store in .viminfo file
  set visualbell                            " use a visual bell instead of beeping
  set whichwrap=<,>,h,l                     " list of flags specifying which commands wrap to another line

" set expandtab                             " Use appropriate number of spaces to insert a <Tab>
" set linebreak                             " Don't wrap words by default
  set ignorecase                            " Do case insensitive matching
  set smartcase                             " Do smart case matching
" set autowrite                             " Automatically save before commands like :next and :make
" set nodigraph                             " enter characters that normally cannot be entered by an ordinary keyboard

" list of strings used for list mode
" set list listchars=eol:$
  if (&encoding =~ 'utf-8')
    set listchars=eol:$,precedes:«,extends:»,tab:»·,trail:·
  else
    set listchars=eol:$
  endif

" list of file names to search for tags
" set tags=./tags,tags
  set tags=./tags,./TAGS,tags,TAGS,../tags,../../tags,../../../tags,../../../../tags

" When switching between different buffers you can't use undo without 'set hidden':
  set hidden                                " Hide buffers when they are abandoned

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
" set suffixes=.bak,~,.o,.h,.info,.swp,.obj
  set suffixes=.bak,~,.o,.h,.info,.swp,.obj,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" set the screen hardstatus to vim(filename.ext)
  if ((&term =~ '^screen') && ($VIM_PLEASE_SET_TITLE =~ '^yes$') || has('gui_running'))
    set t_ts=k
    set t_fs=\
    set title
    if has("autocmd")
      autocmd BufEnter * let &titlestring = "vim(" . expand("%:t") . ")"
    endif
    let &titleold = fnamemodify(&shell, ":t")
  endif

" autocommands:
  if has("autocmd")
     " when the file type is "mail" then set the textwidth to "70":
     autocmd FileType mail   set tw=70
  endif

" some useful mappings:

" remove/delete trailing whitespace:
  nmap ;tr :%s/\s\+$//
  vmap ;tr  :s/\s\+$//

" execute the command in the current line (minus the first word, which
" is intended to be a shell prompt) and insert the output in the buffer
  map ,e ^wy$:r!"

" update timestamp
  iab YDATE <C-R>=strftime("%a %b %d %T %Z %Y")<CR>
  map ,L  1G/Latest change:\s*/e+1<CR>CYDATE<ESC>

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

  " set maximum number of suggestions listed top 10 items:
  set spellsuggest=best,10

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
  if filereadable("/etc/vim/vimrc.local")
    source /etc/vim/vimrc.local
  endif

" source user-specific local configuration file
"
" NOTE: If this vimrc file is used as system vimrc the initialization of Vim looks like this:
"
"   `system-vimrc (this file) + /etc/vim/vimrc.local + $HOME/.vimrc.local -> user-vimrc`
"
" This means that user-vimrc overrides the settings set in `$HOME/.vimrc.local`.
"
" If this file is used as user-vimrc the initialization of Vim looks like this
"
"   `system-vimrc + /etc/vim/vimrc.local -> user-vimrc (this file) + /etc/vim/vimrc.local + $HOME/.vimrc.local`
"
" This means that `/etc/vim/vimrc.local` + `$HOME/.vimrc.local` overrides the
" settings set in the user-vimrc (and `/etc/vim/vimrc.local` is sourced twice).
"
" Either way, this might or might not be something a user would expect.
  if filereadable(expand("$HOME/.vimrc.local"))
    source $HOME/.vimrc.local
  endif

" End of custom Grml configuration }

"# END OF FILE #################################################################
