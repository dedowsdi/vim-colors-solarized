" Adapted from http://ethanschoonover.com/solarized by dedowsdi@outllook.com
"
" Usage "{{{
" ---------------------------------------------------------------------
" COLOR VALUES
" ---------------------------------------------------------------------
" Download palettes and files from: http://ethanschoonover.com/solarized
"
" L\*a\*b values are canonical (White D65, Reference D50), other values are
" matched in sRGB space.
"
"
" lightness:
" base03 < base02 < base01 < base00 < base0 < base1 < base2 < base3
" base03 is background for dark, base0 is foreground for dark
"
" SOLARIZED HEX     16/8 TERMCOL  XTERM/HEX   L*A*B      sRGB        HSB
" --------- ------- ---- -------  ----------- ---------- ----------- -----------
" base03    #002b36  8/4 brblack  234 #1c1c1c 15 -12 -12   0  43  54 193 100  21
" base02    #073642  0/4 black    235 #262626 20 -12 -12   7  54  66 192  90  26
" base01    #586e75 10/7 brgreen  240 #4e4e4e 45 -07 -07  88 110 117 194  25  46
" base00    #657b83 11/7 bryellow 241 #585858 50 -07 -07 101 123 131 195  23  51
" base0     #839496 12/6 brblue   244 #808080 60 -06 -03 131 148 150 186  13  59
" base1     #93a1a1 14/4 brcyan   245 #8a8a8a 65 -05 -02 147 161 161 180   9  63
" base2     #eee8d5  7/7 white    254 #d7d7af 92 -00  10 238 232 213  44  11  93
" base3     #fdf6e3 15/7 brwhite  230 #ffffd7 97  00  10 253 246 227  44  10  99
" yellow    #b58900  3/3 yellow   136 #af8700 60  10  65 181 137   0  45 100  71
" orange    #cb4b16  9/3 brred    166 #d75f00 50  50  55 203  75  22  18  89  80
" red       #dc322f  1/1 red      160 #d70000 50  65  45 220  50  47   1  79  86
" magenta   #d33682  5/5 magenta  125 #af005f 50  65 -05 211  54 130 331  74  83
" violet    #6c71c4 13/5 brmagenta 61 #5f5faf 50  15 -45 108 113 196 237  45  77
" blue      #268bd2  4/4 blue      33 #0087ff 55 -10 -45  38 139 210 205  82  82
" cyan      #2aa198  6/6 cyan      37 #00afaf 60 -35 -05  42 161 152 175  74  63
" green     #859900  2/2 green     64 #5f8700 60 -20  65 133 153   0  68 100  60
"
" ---------------------------------------------------------------------
" COLORSCHEME HACKING
" ---------------------------------------------------------------------
"
" Useful commands for testing colorschemes:
" :source $VIMRUNTIME/syntax/hitest.vim
" :help highlight-groups
" :help cterm-colors
" :help group-name
"
" Useful links for developing colorschemes:
" http://www.vim.org/scripts/script.php?script_id=2937
" http://vimcasts.org/episodes/creating-colorschemes-for-vim/
" http://www.frexx.de/xterm-256-notes/"
"
" }}}
" Environment Specific Overrides "{{{
" Allow or disallow certain features based on current terminal emulator or
" environment.

" ---------------------------------------------------------------------
" ABOUT reverse
" ---------------------------------------------------------------------
" linux-16color doesn't have full support for reverse, these commands are
" equal:
"
" tput setaf 1 ; tput setab 10 ; tput rev ; echo 123
" tput setaf 2 ; tput setab 9 ; echo 123
"
" 2 = 10%2, 9 = 1 + 8
"
" bold(1) and blink(5) is used to make fg or bg color brighter(+8), rev works on
" color%8 , bold or blink stays unchanged.
"
" You can only use rev if both fg and bg is greater or less equal to 7. The same
" rule applies to standout, it's better to stay away from them.

" ---------------------------------------------------------------------
" ABOUT bold
" ---------------------------------------------------------------------
" bold:
"    term          |     behavior
" --------------------------------------
"    linux console |     if i < 8
"                  |       i+=8
"                  |     else
"                  |       ignored
" --------------------------------------
"    256 color     |    if i < 8
"                  |       i += 8
"                  |       make it bold
"                  |    else
"                  |       make it bold
"
"  To make it consistent across different terminals, bold should only be applied
"  to 8+ index colors.

" }}}
" Default option values"{{{
" ---------------------------------------------------------------------

let s:cap_italic = has('gui_running') ||
      \ !empty(filter(['rxvt', 'gnome-terminal'], { i,v -> stridx($TERM, v) != -1 }))
let s:solarized_termtrans_default = $TERM_PROGRAM ==? 'apple_terminal' && &t_Co < 256

let g:solarized_termtrans  = get(g:, 'solarized_termtrans', s:solarized_termtrans_default)
let g:solarized_bold       = get(g:, 'solarized_bold', 1)
let g:solarized_underline  = get(g:, 'solarized_underline', 1)
let g:solarized_italic     = get(g:, 'solarized_italic', 1) && s:cap_italic
let g:solarized_termcolors = get(g:, 'solarized_termcolors', 16)

"}}}
" Colorscheme initialization "{{{
" ---------------------------------------------------------------------
hi clear
if exists('syntax_on')
  syntax reset
endif
let colors_name = 'solarized'

"}}}

" GUI & CSApprox hexadecimal palettes"{{{

" look, I swapped 0 and 8, 7 and 12. I prefer to let Normal be the same as
" terminal bg and fg.
let g:terminal_ansi_colors = [
            \ '#002b36',
            \ '#dc322f',
            \ '#859900',
            \ '#b58900',
            \ '#268bd2',
            \ '#d33682',
            \ '#2aa198',
            \ '#839496',
            \ '#073642',
            \ '#cb4b16',
            \ '#586e75',
            \ '#657b83',
            \ '#93a1a1',
            \ '#6c71c4',
            \ '#eee8d5',
            \ '#fdf6e3',
            \ ]

" ---------------------------------------------------------------------
let s:pallete = {
      \ 'mode'    :  [ 'gui'                      , 'cterm' , 'cterm'        ]  ,
      \ 'base03'  :  [ g:terminal_ansi_colors[0]  , 0       , 'DarkGray'     ]  ,
      \ 'red'     :  [ g:terminal_ansi_colors[1]  , 1       , 'DarkRed'      ]  ,
      \ 'green'   :  [ g:terminal_ansi_colors[2]  , 2       , 'DarkGreen'    ]  ,
      \ 'yellow'  :  [ g:terminal_ansi_colors[3]  , 3       , 'DarkYellow'   ]  ,
      \ 'blue'    :  [ g:terminal_ansi_colors[4]  , 4       , 'DarkBlue'     ]  ,
      \ 'magenta' :  [ g:terminal_ansi_colors[5]  , 5       , 'DarkMagenta'  ]  ,
      \ 'cyan'    :  [ g:terminal_ansi_colors[6]  , 6       , 'DarkCyan'     ]  ,
      \ 'base0'   :  [ g:terminal_ansi_colors[7]  , 7       , 'LightGray'    ]  ,
      \ 'base02'  :  [ g:terminal_ansi_colors[8]  , 8       , 'Black'        ]  ,
      \ 'orange'  :  [ g:terminal_ansi_colors[9]  , 9       , 'LightRed'     ]  ,
      \ 'base01'  :  [ g:terminal_ansi_colors[10] , 10      , 'LightGreen'   ]  ,
      \ 'base00'  :  [ g:terminal_ansi_colors[11] , 11      , 'LightYellow'  ]  ,
      \ 'base1'   :  [ g:terminal_ansi_colors[12] , 12      , 'LightGreen'   ]  ,
      \ 'violet'  :  [ g:terminal_ansi_colors[13] , 13      , 'LightMagenta' ]  ,
      \ 'base2'   :  [ g:terminal_ansi_colors[14] , 14      , 'LightCyan'    ]  ,
      \ 'base3'   :  [ g:terminal_ansi_colors[15] , 15      , 'White'        ]  ,
      \}


let s:amode = has('gui_running') ? 'gui' : &t_Co >= 16 ? 'cterm' : 'term'
let s:idx = has('gui_running') || &termguicolors ? 0 : &t_Co >= 16 ? 1 : 2

let s:vmode   = s:pallete.mode[s:idx]
let s:base03  = s:pallete.base03[s:idx]
let s:base02  = s:pallete.base02[s:idx]
let s:base01  = s:pallete.base01[s:idx]
let s:base00  = s:pallete.base00[s:idx]
let s:base0   = s:pallete.base0[s:idx]
let s:base1   = s:pallete.base1[s:idx]
let s:base2   = s:pallete.base2[s:idx]
let s:base3   = s:pallete.base3[s:idx]
let s:yellow  = s:pallete.yellow[s:idx]
let s:orange  = s:pallete.orange[s:idx]
let s:red     = s:pallete.red[s:idx]
let s:magenta = s:pallete.magenta[s:idx]
let s:violet  = s:pallete.violet[s:idx]
let s:blue    = s:pallete.blue[s:idx]
let s:cyan    = s:pallete.cyan[s:idx]
let s:green   = s:pallete.green[s:idx]

"}}}
" Formatting options and null values for passthrough effect "{{{
" ---------------------------------------------------------------------
let s:none            = 'NONE'
let s:c               = ',undercurl'
let s:r               = ',reverse'
let s:s               = ',standout'
let s:ou              = ''
let s:ob              = ''
"}}}
" Background value based on termtrans setting "{{{
" ---------------------------------------------------------------------
if (has('gui_running') || g:solarized_termtrans == 0)
    let s:back        = s:base03
else
    let s:back        = 'NONE'
endif
"}}}
" Alternate light scheme "{{{
" ---------------------------------------------------------------------
if &background ==# 'light'
    let s:temp03      = s:base03
    let s:temp02      = s:base02
    let s:temp01      = s:base01
    let s:temp00      = s:base00
    let s:base03      = s:base3
    let s:base02      = s:base2
    let s:base01      = s:base1
    let s:base00      = s:base0
    let s:base0       = s:temp00
    let s:base1       = s:temp01
    let s:base2       = s:temp02
    let s:base3       = s:temp03
    if (s:back !=# 'NONE')
        let s:back    = s:base03
    endif
endif
"}}}
" Overrides dependent on user specified values and environment "{{{
" ---------------------------------------------------------------------
let s:b = g:solarized_bold ? ',bold' : ''
let s:u = g:solarized_underline ? ',underline' : ''
let s:i = g:solarized_italic ? ',italic' : ''

"}}}
" Highlighting primitives"{{{
" ---------------------------------------------------------------------

let s:bg_none      = ' ' . s:vmode . 'bg=' . s:none
let s:bg_back      = ' ' . s:vmode . 'bg=' . s:back
let s:bg_base03    = ' ' . s:vmode . 'bg=' . s:base03
let s:bg_base02    = ' ' . s:vmode . 'bg=' . s:base02
let s:bg_base01    = ' ' . s:vmode . 'bg=' . s:base01
let s:bg_base00    = ' ' . s:vmode . 'bg=' . s:base00
let s:bg_base0     = ' ' . s:vmode . 'bg=' . s:base0
let s:bg_base1     = ' ' . s:vmode . 'bg=' . s:base1
let s:bg_base2     = ' ' . s:vmode . 'bg=' . s:base2
let s:bg_base3     = ' ' . s:vmode . 'bg=' . s:base3
let s:bg_green     = ' ' . s:vmode . 'bg=' . s:green
let s:bg_yellow    = ' ' . s:vmode . 'bg=' . s:yellow
let s:bg_orange    = ' ' . s:vmode . 'bg=' . s:orange
let s:bg_red       = ' ' . s:vmode . 'bg=' . s:red
let s:bg_magenta   = ' ' . s:vmode . 'bg=' . s:magenta
let s:bg_violet    = ' ' . s:vmode . 'bg=' . s:violet
let s:bg_blue      = ' ' . s:vmode . 'bg=' . s:blue
let s:bg_cyan      = ' ' . s:vmode . 'bg=' . s:cyan
let s:bg           = ' ' . s:vmode . 'bg=bg'
let s:bg_fg        = ' ' . s:vmode . 'bg=fg'

let s:fg_none      = ' ' . s:vmode . 'fg=' . s:none
let s:fg_back      = ' ' . s:vmode . 'fg=' . s:back
let s:fg_base03    = ' ' . s:vmode . 'fg=' . s:base03
let s:fg_base02    = ' ' . s:vmode . 'fg=' . s:base02
let s:fg_base01    = ' ' . s:vmode . 'fg=' . s:base01
let s:fg_base00    = ' ' . s:vmode . 'fg=' . s:base00
let s:fg_base0     = ' ' . s:vmode . 'fg=' . s:base0
let s:fg_base1     = ' ' . s:vmode . 'fg=' . s:base1
let s:fg_base2     = ' ' . s:vmode . 'fg=' . s:base2
let s:fg_base3     = ' ' . s:vmode . 'fg=' . s:base3
let s:fg_green     = ' ' . s:vmode . 'fg=' . s:green
let s:fg_yellow    = ' ' . s:vmode . 'fg=' . s:yellow
let s:fg_orange    = ' ' . s:vmode . 'fg=' . s:orange
let s:fg_red       = ' ' . s:vmode . 'fg=' . s:red
let s:fg_magenta   = ' ' . s:vmode . 'fg=' . s:magenta
let s:fg_violet    = ' ' . s:vmode . 'fg=' . s:violet
let s:fg_blue      = ' ' . s:vmode . 'fg=' . s:blue
let s:fg_cyan      = ' ' . s:vmode . 'fg=' . s:cyan
let s:fg           = ' ' . s:vmode . 'fg=fg'
let s:fg_bg        = ' ' . s:vmode . 'fg=bg'

let s:fmt_none     = ' ' . s:amode . '=NONE' .           ' term=NONE'
let s:fmt_bold     = ' ' . s:amode . '=NONE' . s:b.      ' term=NONE' . s:b
let s:fmt_undr     = ' ' . s:amode . '=NONE' . s:u.      ' term=NONE' . s:u
let s:fmt_undb     = ' ' . s:amode . '=NONE' . s:u.s:b.  ' term=NONE' . s:u.s:b
let s:fmt_uopt     = ' ' . s:amode . '=NONE' . s:ou.     ' term=NONE' . s:ou
let s:fmt_curl     = ' ' . s:amode . '=NONE' . s:c.      ' term=NONE' . s:c
let s:fmt_ital     = ' ' . s:amode . '=NONE' . s:i.      ' term=NONE' . s:i

if has('gui_running')
    let s:sp_none      = ' guisp=' . s:none
    let s:sp_back      = ' guisp=' . s:back
    let s:sp_base03    = ' guisp=' . s:base03
    let s:sp_base02    = ' guisp=' . s:base02
    let s:sp_base01    = ' guisp=' . s:base01
    let s:sp_base00    = ' guisp=' . s:base00
    let s:sp_base0     = ' guisp=' . s:base0
    let s:sp_base1     = ' guisp=' . s:base1
    let s:sp_base2     = ' guisp=' . s:base2
    let s:sp_base3     = ' guisp=' . s:base3
    let s:sp_green     = ' guisp=' . s:green
    let s:sp_yellow    = ' guisp=' . s:yellow
    let s:sp_orange    = ' guisp=' . s:orange
    let s:sp_red       = ' guisp=' . s:red
    let s:sp_magenta   = ' guisp=' . s:magenta
    let s:sp_violet    = ' guisp=' . s:violet
    let s:sp_blue      = ' guisp=' . s:blue
    let s:sp_cyan      = ' guisp=' . s:cyan
else
    let s:sp_none      = ''
    let s:sp_back      = ''
    let s:sp_base03    = ''
    let s:sp_base02    = ''
    let s:sp_base01    = ''
    let s:sp_base00    = ''
    let s:sp_base0     = ''
    let s:sp_base1     = ''
    let s:sp_base2     = ''
    let s:sp_base3     = ''
    let s:sp_green     = ''
    let s:sp_yellow    = ''
    let s:sp_orange    = ''
    let s:sp_red       = ''
    let s:sp_magenta   = ''
    let s:sp_violet    = ''
    let s:sp_blue      = ''
    let s:sp_cyan      = ''
endif

"}}}
" Basic highlighting"{{{
" ---------------------------------------------------------------------
" note that link syntax to avoid duplicate configuration doesn't work with the
" exe compiled formats

exe 'hi! Normal'         s:fmt_none     s:fg_base0    s:bg_back

exe 'hi SolarizedRedSign'       s:fmt_none  s:bg_none   s:fg_red
exe 'hi SolarizedYellowSign'    s:fmt_none  s:bg_none   s:fg_yellow
exe 'hi SolarizedOrangeSign'    s:fmt_none  s:bg_none   s:fg_orange
exe 'hi SolarizedRedSign'       s:fmt_none  s:bg_none   s:fg_red
exe 'hi SolarizedMagentaSign'   s:fmt_none  s:bg_none   s:fg_magenta
exe 'hi SolarizedVioletSign'    s:fmt_none  s:bg_none   s:fg_violet
exe 'hi SolarizedBlueSign'      s:fmt_none  s:bg_none   s:fg_blue
exe 'hi SolarizedCyanSign'      s:fmt_none  s:bg_none   s:fg_cyan

exe 'hi! Comment'        s:fmt_none     s:fg_base01   s:bg_none
"       *Comment         any comment

exe 'hi! Constant'       s:fmt_none     s:fg_cyan     s:bg_none
"       *Constant        any constant
"        String          a string constant: "this is a string"
"        Character       a character constant: 'c', '\n'
"        Number          a number constant: 234, 0xff
"        Boolean         a boolean constant: TRUE, false
"        Float           a floating point constant: 2.3e10

exe 'hi Identifier'       s:fmt_none     s:fg_blue     s:bg_none
"       *Identifier      any variable name
"        Function        function name (also: methods for classes)
"
exe 'hi! Statement'      s:fmt_none     s:fg_green    s:bg_none
"       *Statement       any statement
"        Conditional     if, then, else, endif, switch, etc.
"        Repeat          for, do, while, etc.
"        Label           case, default, etc.
"        Operator        "sizeof", "+", "*", etc.
"        Keyword         any other keyword
"        Exception       try, catch, throw

exe 'hi! PreProc'        s:fmt_none     s:fg_orange   s:bg_none
"       *PreProc         generic Preprocessor
"        Include         preprocessor #include
"        Define          preprocessor #define
"        Macro           same as Define
"        PreCondit       preprocessor #if, #else, #endif, etc.

exe 'hi! Type'           s:fmt_none     s:fg_yellow   s:bg_none
"       *Type            int, long, char, etc.
"        StorageClass    static, register, volatile, etc.
"        Structure       struct, union, enum, etc.
"        Typedef         A typedef

exe 'hi! Special'        s:fmt_none     s:fg_red      s:bg_none
"       *Special         any special symbol
"        SpecialChar     special character in a constant
"        Tag             you can use CTRL-] on this
"        Delimiter       character that needs attention
"        SpecialComment  special things inside a comment
"        Debug           debugging statements

exe 'hi! Underlined'     s:fmt_none     s:fg_violet   s:bg_none
"       *Underlined      text that stands out, HTML links

exe 'hi! Ignore'         s:fmt_none     s:fg_none     s:bg_none
"       *Ignore          left blank, hidden  |hl-Ignore|

exe 'hi! Error'          s:fmt_bold     s:fg_orange      s:bg_none
"       *Error           any erroneous construct

exe 'hi! Todo'           s:fmt_bold     s:fg_violet   s:bg_none
"       *Todo            anything that needs extra attention; mostly the
"                        keywords TODO FIXME and XXX
"
"}}}
" Extended highlighting "{{{
" ---------------------------------------------------------------------
exe 'hi! SpecialKey'      s:fmt_bold     s:fg_base00   s:bg_base02
exe 'hi! NonText'         s:fmt_bold     s:fg_base00   s:bg_none
exe 'hi! StatusLine'      s:fmt_none     s:bg_base00   s:fg_base03
exe 'hi! StatusLineNC'    s:fmt_none     s:bg_base02   s:fg_base00
hi! link StatusLineTerm   StatusLine
hi! link StatusLineTermNC StatusLineNC

exe 'hi! Visual'          s:fmt_none     s:bg_base01   s:fg_base02   s:fmt_bold
exe 'hi! Directory'       s:fmt_none     s:fg_blue     s:bg_none
exe 'hi! ErrorMsg'        s:fmt_none     s:bg_red      s:fg_base2
exe 'hi! IncSearch'       s:fmt_none     s:bg_orange   s:fg_base03
exe 'hi! Search'          s:fmt_none     s:bg_yellow   s:fg_base03
exe 'hi! MoreMsg'         s:fmt_none     s:fg_blue     s:bg_none
exe 'hi! ModeMsg'         s:fmt_none     s:fg_blue     s:bg_none
exe 'hi! LineNr'          s:fmt_none     s:fg_base01   s:bg_base02
exe 'hi! Question'        s:fmt_bold     s:fg_base1     s:bg_none
exe 'hi! VertSplit'       s:fmt_none     s:fg_base00   s:bg_base00
exe 'hi! Title'           s:fmt_bold     s:fg_orange   s:bg_none
exe 'hi! VisualNOS'       s:fmt_none     s:bg_base02   s:fg_base02
exe 'hi! WarningMsg'      s:fmt_bold     s:fg_orange   s:bg_none
exe 'hi! WildMenu'        s:fmt_none     s:bg_base1    s:fg_base02   s:fmt_bold
exe 'hi! Folded'          s:fmt_undr     s:fg_base1    s:bg_base02   s:sp_base03
exe 'hi! FoldColumn'      s:fmt_none     s:fg_base0    s:bg_base02

exe 'hi! DiffAdd'         s:fmt_none     s:bg_green    s:fg_base03
exe 'hi! DiffChange'      s:fmt_none     s:bg_yellow   s:fg_base03
exe 'hi! DiffDelete'      s:fmt_none     s:bg_red      s:fg_base03
exe 'hi! DiffText'        s:fmt_none     s:bg_blue     s:fg_base03

exe 'hi! SignColumn'      s:fmt_none     s:fg_base0
exe 'hi! Conceal'         s:fmt_none     s:fg_blue     s:bg
exe 'hi! SpellBad'        s:fmt_undr     s:fg          s:bg_none  s:sp_red
exe 'hi! SpellCap'        s:fmt_undr     s:fg          s:bg_none  s:sp_violet
exe 'hi! SpellRare'       s:fmt_undr     s:fg          s:bg_none  s:sp_cyan
exe 'hi! SpellLocal'      s:fmt_undr     s:fg          s:bg_none  s:sp_yellow

exe 'hi! Pmenu'           s:fmt_none     s:bg_base02   s:fg_base0
exe 'hi! PmenuSel'        s:fmt_none     s:bg_base01   s:fg_base02    s:fmt_bold
exe 'hi! PmenuSbar'       s:fmt_none     s:bg_base02   s:fg_base02
exe 'hi! PmenuThumb'      s:fmt_none     s:bg_base0    s:fg_base02

exe 'hi! TabLine'         s:fmt_none     s:fg_base0    s:bg_base02    s:sp_base0
exe 'hi! TabLineFill'     s:fmt_none     s:fg_base0    s:bg_base02    s:sp_base0
exe 'hi! TabLineSel'      s:fmt_none     s:fg_base03   s:bg_base0     s:sp_base0

exe 'hi! CursorColumn'    s:fmt_none     s:fg_none     s:bg_base02
exe 'hi! CursorLine'      s:fmt_uopt     s:fg_none     s:bg_base02    s:sp_base1
exe 'hi! CursorLineNr'    s:fmt_uopt     s:fg_none     s:bg_base02    s:sp_base1
exe 'hi! ColorColumn'     s:fmt_none     s:fg_none     s:bg_base02
exe 'hi! Cursor'          s:fmt_none     s:fg_base03   s:bg_base0
hi! link lCursor Cursor
exe 'hi! MatchParen'      s:fmt_bold     s:fg_orange   s:bg_base01

"}}}

" Termdebug "{{{
hi link debugBreakpoint SolarizedMagentaSign
exe 'hi! debugPC' s:fmt_none s:fg_base03 s:bg_base0

"}}}
" Utility autocommand "{{{
" ---------------------------------------------------------------------
" In cases where Solarized is initialized inside a terminal vim session and
" then transferred to a gui session via the command `:gui`, the gui vim process
" does not re-read the colorscheme (or .vimrc for that matter) so any `has_gui`
" related code that sets gui specific values isn't executed.
"
" Currently, Solarized sets only the cterm or gui values for the colorscheme
" depending on gui or terminal mode. It's possible that, if the following
" autocommand method is deemed excessively poor form, that approach will be
" used again and the autocommand below will be dropped.
"
" However it seems relatively benign in this case to include the autocommand
" here. It fires only in cases where vim is transferring from terminal to gui
" mode (detected with the script scope s:vmode variable). It also allows for
" other potential terminal customizations that might make gui mode suboptimal.
"
augroup ag_solarized
  autocmd GUIEnter *
        \ if (s:vmode != 'gui') | exe 'colorscheme ' . g:colors_name | endif
augroup end
"}}}
" License "{{{
" ---------------------------------------------------------------------
"
" Copyright (c) 2011 Ethan Schoonover
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
" THE SOFTWARE.
"
" vim:foldmethod=marker:foldlevel=0
"}}}
