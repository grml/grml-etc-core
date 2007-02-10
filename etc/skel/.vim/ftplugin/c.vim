" Filename:      c.vim
" Purpose:       configuration file for c programming with Vim
" Authors:       grml-team (grml.org), (c) Michael Prokop <mika@grml.org>, Bart Trojanowski <bart@jukie.net>
" Bug-Reports:   see http://grml.org/bugs/
" Latest change: Sam Feb 10 11:31:21 CET 2007 [mika]
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This file is heavily based on Bart's blog entry
" "vim and linux CodingStyle" => http://jukie.net/~bart/blog/20070209172606

" some general options
  set noexpandtab                  " use tabse, not spaces
  set tabstop=8                    " tabstops of 8
  set shiftwidth=8                 " indents of 8
  set textwidth=78                 " screen in 80 columns wide, wrap at 78
  set autoindent smartindent       " turn on auto/smart indenting
  set smarttab                     " make <tab> and <backspace> smarter
  set backspace=eol,start,indent   " allow backspacing over indent, eol, & start
  set foldmethod=syntax            " syntax highlighting items specify folds

" keybindings
  nmap <C-J> vip=                  " forces (re)indentation of a block of code
"  imap if(      if () {<cr>}<esc>k$2hi
"  imap ife(     <ESC>:call IfElse()<CR>a
"  imap while(   while () {<cr>}<esc>k$2hi
"  imap switch(  switch () {<cr>default:<cr>break;<cr>}<esc>3k$2hi
"  imap do{      <ESC>:call DoWhile()<CR>a
"  imap for(     for (;;) {<cr>}<esc>k$3hi

" Edit compile speedup (hotkeys)
" --------- start info -----------------
" F2 - update file without confirmation
" F3 - file open dialog
" F5 - calls manual of function
" F6 - list all errors
" F7 - display previous error
" F8 - display next error
" --------- end info -------------------
  map <F2>  :update<CR>
  map <F3>  :browse confirm e<CR>
  map <F5>  <Esc>:! man <cfile> <CR>
  map <F6>  :copen<CR>
  map <F7>  :cp<CR>
  map <F8>  :cn<CR>

" abbreviations...
  abb #i #include
  abb #d #define
  abb #f #ifdef
  abb #n #endif
"  iab ,I if()<CR>{<CR>}<ESC>kk$i
"  iab ,F for(;;)<CR>{<CR>}<ESC>kk$hhi
"  iab ,E else<CR>{<CR>}<ESC>O

" syntax highlighting
  syntax on
  syn keyword cType uint ubyte ulong uint64_t uint32_t uint16_t uint8_t boolean_t int64_t int32_t int16_t int8_t u_int64_t u_int32_t u_int16_t u_int8_t
  syn keyword cOperator likely unlikely
  syn match ErrorLeadSpace /^ \+/         " highlight any leading spaces
  syn match ErrorTailSpace / \+$/         " highlight any trailing spaces

" C-mode formatting options
"   t auto-wrap comment
"   c allows textwidth to work on comments
"   q allows use of gq* for auto formatting
"   l don't break long lines in insert mode
"   r insert '*' on <cr>
"   o insert '*' on newline with 'o'
"   n recognize numbered lists
  set formatoptions=tcqlron

" C-mode options (cinoptions==cino)
" N     number of spaces
" Ns    number of spaces * shiftwidth
" >N    default indent
" eN    extra indent if the { is at the end of a line
" nN    extra indent if there is no {} block
" fN    indent of the { of a function block
" gN    indent of the C++ class scope declarations (public, private, protected)
" {N    indent of a { on a new line after an if,while,for...
" }N    indent of a } in reference to a {
" ^N    extra indent inside a function {}
" :N    indent of case labels
" =N    indent of case body
" lN    align case {} on the case line
" tN    indent of function return type
" +N    indent continued algibreic expressions
" cN    indent of comment line after /*
" )N    vim searches for closing )'s at most N lines away
" *N    vim searches for closing */ at most N lines away
  set cinoptions=:0l1t0g0

" folding
"  - reserve 4 columns on the left for folding tree
"  - fold by syntax, use {}'s
"  - start with all folds open
  if winwidth(0) > 80
    set foldcolumn=4
  endif

" EOF
