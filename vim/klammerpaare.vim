syn region klammer10a matchgroup=KLAMMER10a start='\[' end='\]' contained
syn region klammer10b matchgroup=KLAMMER10a start='{' end='}'   contained
syn region klammer9a matchgroup=KLAMMER9a start='\[' end='\]' contained contains=klammer10a,klammer10b
syn region klammer9b matchgroup=KLAMMER9a start='{' end='}'   contained contains=klammer10a,klammer10b
syn region klammer8a matchgroup=KLAMMER8a start='\[' end='\]' contained contains=klammer9a,klammer9b
syn region klammer8b matchgroup=KLAMMER8a start='{' end='}'   contained contains=klammer9a,klammer9b
syn region klammer7a matchgroup=KLAMMER7a start='\[' end='\]' contained contains=klammer8a,klammer8b
syn region klammer7b matchgroup=KLAMMER7a start='{' end='}'   contained contains=klammer8a,klammer8b
syn region klammer6a matchgroup=KLAMMER6a start='\[' end='\]' contained contains=klammer7a,klammer7b
syn region klammer6b matchgroup=KLAMMER6a start='{' end='}'   contained contains=klammer7a,klammer7b
syn region klammer5a matchgroup=KLAMMER5a start='\[' end='\]' contained contains=klammer6a,klammer6b
syn region klammer5b matchgroup=KLAMMER5a start='{' end='}'   contained contains=klammer6a,klammer6b
syn region klammer4a matchgroup=KLAMMER4a start='\[' end='\]' contained contains=klammer5a,klammer5b
syn region klammer4b matchgroup=KLAMMER4a start='{' end='}'   contained contains=klammer5a,klammer5b
syn region klammer3a matchgroup=KLAMMER3a start='\[' end='\]' contained contains=klammer4a,klammer4b
syn region klammer3b matchgroup=KLAMMER3a start='{' end='}'   contained contains=klammer4a,klammer4b
syn region klammer2a matchgroup=KLAMMER2a start='\[' end='\]' contained contains=klammer3a,klammer3b
syn region klammer2b matchgroup=KLAMMER2a start='{' end='}'   contained contains=klammer3a,klammer3b
syn region klammer1a matchgroup=KLAMMER1a start='\[' end='\]' contains=klammer2a,klammer2b
syn region klammer1b matchgroup=KLAMMER1a start='{' end='}'   contains=klammer2a,klammer2b

hi klammer1a ctermfg=Red ctermbg=Black guifg=Red guibg=Black
hi klammer1b ctermfg=Red ctermbg=Black guifg=Red guibg=Black
hi KLAMMER1b ctermfg=Red ctermbg=Black guifg=Red guibg=Black

hi klammer2a ctermfg=Green ctermbg=Black guifg=Green guibg=Black
hi klammer2b ctermfg=Green ctermbg=Black guifg=Green guibg=Black
hi KLAMMER2b ctermfg=Green ctermbg=Black guifg=Green guibg=Black

hi klammer3a ctermfg=Cyan ctermbg=Black guifg=Cyan guibg=Black
hi klammer3b ctermfg=Cyan ctermbg=Black guifg=Cyan guibg=Black
hi KLAMMER3b ctermfg=Cyan ctermbg=Black guifg=Cyan guibg=Black

hi klammer4a ctermfg=Yellow ctermbg=Black guifg=Yellow guibg=Black
hi klammer4b ctermfg=Yellow ctermbg=Black guifg=Yellow guibg=Black
hi KLAMMER4b ctermfg=Yellow ctermbg=Black guifg=Yellow guibg=Black

hi klammer5a ctermfg=Magenta ctermbg=Black guifg=Magenta guibg=Black
hi klammer5b ctermfg=Magenta ctermbg=Black guifg=Magenta guibg=Black
hi KLAMMER5b ctermfg=Magenta ctermbg=Black guifg=Magenta guibg=Black

hi klammer6a ctermfg=Darkred ctermbg=Black guifg=Darkred guibg=Black
hi klammer6b ctermfg=Darkred ctermbg=Black guifg=Darkred guibg=Black
hi KLAMMER6b ctermfg=Darkred ctermbg=Black guifg=Darkred guibg=Black

hi klammer7a ctermfg=Darkgreen ctermbg=Black guifg=Darkgreen guibg=Black
hi klammer7b ctermfg=Darkgreen ctermbg=Black guifg=Darkgreen guibg=Black
hi KLAMMER7b ctermfg=Darkgreen ctermbg=Black guifg=Darkgreen guibg=Black

hi klammer8a ctermfg=Darkcyan ctermbg=Black guifg=Darkcyan guibg=Black
hi klammer8b ctermfg=Darkcyan ctermbg=Black guifg=Darkcyan guibg=Black
hi KLAMMER8b ctermfg=Darkcyan ctermbg=Black guifg=Darkcyan guibg=Black

hi klammer9a ctermfg=Darkyellow ctermbg=Black guifg=Darkyellow guibg=Black
hi klammer9b ctermfg=Darkyellow ctermbg=Black guifg=Darkyellow guibg=Black
hi KLAMMER9b ctermfg=Darkyellow ctermbg=Black guifg=Darkyellow guibg=Black

hi klammer10a ctermfg=Darkmagenta ctermbg=Black guifg=Darkmagenta guibg=Black
hi klammer10b ctermfg=Darkmagenta ctermbg=Black guifg=Darkmagenta guibg=Black
hi KLAMMER10b ctermfg=Darkmagenta ctermbg=Black guifg=Darkmagenta guibg=Black

syn sync minlines=300
