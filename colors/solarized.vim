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

" Terminals that support italics
let s:terms_italic=[
            \'rxvt',
            \'gnome-terminal'
            \]
" For reference only, terminals are known to be incomptible.
" Terminals that are in neither list need to be tested.
let s:terms_noitalic=[
            \'iTerm.app',
            \'Apple_Terminal'
            \]
if has('gui_running')
    let s:terminal_italic=1 " TODO: could refactor to not require this at all
else
    let s:terminal_italic=0 " terminals will be guilty until proven compatible
    for term in s:terms_italic
        if $TERM =~? term
            let s:terminal_italic=1
        endif
    endfor
endif

" }}}
" Default option values"{{{
" ---------------------------------------------------------------------
function! s:SetOption(name,default)
    if type(a:default) == type(0)
        let l:wrap=''
    else
        let l:wrap='"'
    endif
    if !exists('g:solarized_' . a:name) || g:solarized_{a:name} == a:default
        exe 'let g:solarized_' . a:name . '=' . l:wrap . a:default . l:wrap.'"'
    endif
endfunction

if ($TERM_PROGRAM ==? 'apple_terminal' && &t_Co < 256)
    let s:solarized_termtrans_default = 1
else
    let s:solarized_termtrans_default = 0
endif
call s:SetOption('termtrans',s:solarized_termtrans_default)
call s:SetOption('degrade',0)
call s:SetOption('bold',1)
call s:SetOption('underline',1)
call s:SetOption('italic',1) " note that we need to override this later if the terminal doesn't support
call s:SetOption('termcolors',16)
call s:SetOption('contrast','normal')
call s:SetOption('visibility','normal')
call s:SetOption('diffmode','normal')
call s:SetOption('hitrail',0)
call s:SetOption('menu',1)

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
" ---------------------------------------------------------------------
"
" Set both gui and terminal color values in separate conditional statements
" Due to possibility that CSApprox is running (though I suppose we could just
" leave the hex values out entirely in that case and include only cterm colors)
" We also check to see if user has set solarized (force use of the
" neutral gray monotone palette component)
if (has('gui_running') && g:solarized_degrade == 0)
    let s:vmode       = 'gui'
    let s:base03      = '#002b36'
    let s:base02      = '#073642'
    let s:base01      = '#586e75'
    let s:base00      = '#657b83'
    let s:base0       = '#839496'
    let s:base1       = '#93a1a1'
    let s:base2       = '#eee8d5'
    let s:base3       = '#fdf6e3'
    let s:yellow      = '#b58900'
    let s:orange      = '#cb4b16'
    let s:red         = '#dc322f'
    let s:magenta     = '#d33682'
    let s:violet      = '#6c71c4'
    let s:blue        = '#268bd2'
    let s:cyan        = '#2aa198'
    "let s:green       = '#859900' "original
    let s:green       = '#719e07' "experimental
elseif (has('gui_running') && g:solarized_degrade == 1)
    " These colors are identical to the 256 color mode. They may be viewed
    " while in gui mode via "let g:solarized_degrade=1", though this is not
    " recommened and is for testing only.
    let s:vmode       = 'gui'
    let s:base03      = '#1c1c1c'
    let s:base02      = '#262626'
    let s:base01      = '#4e4e4e'
    let s:base00      = '#585858'
    let s:base0       = '#808080'
    let s:base1       = '#8a8a8a'
    let s:base2       = '#d7d7af'
    let s:base3       = '#ffffd7'
    let s:yellow      = '#af8700'
    let s:orange      = '#d75f00'
    let s:red         = '#af0000'
    let s:magenta     = '#af005f'
    let s:violet      = '#5f5faf'
    let s:blue        = '#0087ff'
    let s:cyan        = '#00afaf'
    let s:green       = '#5f8700'
elseif g:solarized_termcolors != 256 && &t_Co >= 16
    "  0 and 8 are swapped, linux VT use 0 as default background
    let s:vmode       = 'cterm'
    let s:base03      = '0'
    let s:base02      = '8'
    let s:base01      = '10'
    let s:base00      = '11'
    let s:base0       = '12'
    let s:base1       = '14'
    let s:base2       = '7'
    let s:base3       = '15'
    let s:yellow      = '3'
    let s:orange      = '9'
    let s:red         = '1'
    let s:magenta     = '5'
    let s:violet      = '13'
    let s:blue        = '4'
    let s:cyan        = '6'
    let s:green       = '2'
elseif g:solarized_termcolors == 256
    let s:vmode       = 'cterm'
    let s:base03      = '234'
    let s:base02      = '235'
    let s:base01      = '239'
    let s:base00      = '240'
    let s:base0       = '244'
    let s:base1       = '245'
    let s:base2       = '187'
    let s:base3       = '230'
    let s:yellow      = '136'
    let s:orange      = '166'
    let s:red         = '124'
    let s:magenta     = '125'
    let s:violet      = '61'
    let s:blue        = '33'
    let s:cyan        = '37'
    let s:green       = '64'
else
    "  0 and 8 are swapped, linux VT use 0 as default background
    let s:vmode       = 'cterm'
    let s:bright      = '* term=bold cterm=bold'
"   let s:base03      = '0'.s:bright
"   let s:base02      = '0'
"   let s:base01      = '2'.s:bright
"   let s:base00      = '3'.s:bright
"   let s:base0       = '4'.s:bright
"   let s:base1       = '6'.s:bright
"   let s:base2       = '7'
"   let s:base3       = '7'.s:bright
"   let s:yellow      = '3'
"   let s:orange      = '1'.s:bright
"   let s:red         = '1'
"   let s:magenta     = '5'
"   let s:violet      = '5'.s:bright
"   let s:blue        = '4'
"   let s:cyan        = '6'
"   let s:green       = '2'
    let s:base02      = 'DarkGray'      " 0*
    let s:base03      = 'Black'         " 0
    let s:base01      = 'LightGreen'    " 2*
    let s:base00      = 'LightYellow'   " 3*
    let s:base0       = 'LightBlue'     " 4*
    let s:base1       = 'LightCyan'     " 6*
    let s:base2       = 'LightGray'     " 7
    let s:base3       = 'White'         " 7*
    let s:yellow      = 'DarkYellow'    " 3
    let s:orange      = 'LightRed'      " 1*
    let s:red         = 'DarkRed'       " 1
    let s:magenta     = 'DarkMagenta'   " 5
    let s:violet      = 'LightMagenta'  " 5*
    let s:blue        = 'DarkBlue'      " 4
    let s:cyan        = 'DarkCyan'      " 6
    let s:green       = 'DarkGreen'     " 2

endif
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
    let s:back        = 'none'
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
    if (s:back !=# 'none')
        let s:back    = s:base03
    endif
endif
"}}}
" Overrides dependent on user specified values and environment "{{{
" ---------------------------------------------------------------------
if (g:solarized_bold == 0)
    let s:b           = ''
else
    let s:b           = ',bold'
endif

if g:solarized_underline == 0
    let s:u           = ''
else
    let s:u           = ',underline'
endif

if g:solarized_italic == 0 || s:terminal_italic == 0
    let s:i           = ''
else
    let s:i           = ',italic'
endif
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

let s:fmt_none     = ' ' . s:vmode . '=NONE' .           ' term=NONE'
let s:fmt_bold     = ' ' . s:vmode . '=NONE' . s:b.      ' term=NONE' . s:b
let s:fmt_undr     = ' ' . s:vmode . '=NONE' . s:u.      ' term=NONE' . s:u
let s:fmt_undb     = ' ' . s:vmode . '=NONE' . s:u.s:b.  ' term=NONE' . s:u.s:b
let s:fmt_uopt     = ' ' . s:vmode . '=NONE' . s:ou.     ' term=NONE' . s:ou
let s:fmt_curl     = ' ' . s:vmode . '=NONE' . s:c.      ' term=NONE' . s:c
let s:fmt_ital     = ' ' . s:vmode . '=NONE' . s:i.      ' term=NONE' . s:i

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

exe 'hi! Comment'        s:fmt_ital     s:fg_base01   s:bg_none
"       *Comment         any comment

exe 'hi! Constant'       s:fmt_none     s:fg_cyan     s:bg_none
"       *Constant        any constant
"        String          a string constant: "this is a string"
"        Character       a character constant: 'c', '\n'
"        Number          a number constant: 234, 0xff
"        Boolean         a boolean constant: TRUE, false
"        Float           a floating point constant: 2.3e10

exe 'hi! Identifier'     s:fmt_none     s:fg_base2    s:bg_none
exe 'hi! Function'       s:fmt_none     s:fg_blue     s:bg_none
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
exe 'hi! StatusLine'      s:fmt_none     s:bg_base00   s:fg_base03   s:fmt_bold
exe 'hi! StatusLineNC'    s:fmt_none     s:bg_base02   s:fg_base00
hi! link StatusLineTerm   StatusLine
hi! link StatusLineTermNC StatusLineNC

exe 'hi! Visual'          s:fmt_none     s:bg_base01   s:fg_base03   s:fmt_bold
exe 'hi! Directory'       s:fmt_none     s:fg_blue     s:bg_none
exe 'hi! ErrorMsg'        s:fmt_none     s:bg_red      s:fg_base3
exe 'hi! IncSearch'       s:fmt_none     s:bg_orange   s:fg_base03
exe 'hi! Search'          s:fmt_none     s:bg_yellow   s:fg_base03
exe 'hi! MoreMsg'         s:fmt_none     s:fg_blue     s:bg_none
exe 'hi! ModeMsg'         s:fmt_none     s:fg_blue     s:bg_none
exe 'hi! LineNr'          s:fmt_none     s:fg_base01   s:bg_base02
exe 'hi! Question'        s:fmt_bold     s:fg_base1     s:bg_none
if ( has('gui_running') || &t_Co > 8 )
    exe 'hi! VertSplit'   s:fmt_none     s:fg_base00   s:bg_base00
else
    exe 'hi! VertSplit'   s:bg_base00   s:fg_base02
endif
exe 'hi! Title'           s:fmt_bold     s:fg_orange   s:bg_none
exe 'hi! VisualNOS'       s:fmt_none     s:bg_base02   s:fg_base02
exe 'hi! WarningMsg'      s:fmt_bold     s:fg_orange   s:bg_none
exe 'hi! WildMenu'        s:fmt_none     s:bg_base2    s:fg_base02   s:fmt_bold
exe 'hi! Folded'          s:fmt_undb     s:fg_base0    s:bg_base02   s:sp_base03
exe 'hi! FoldColumn'      s:fmt_none     s:fg_base0    s:bg_base02
if has('gui_running')
    exe 'hi! DiffAdd'         s:fmt_bold     s:fg_green    s:bg_base02   s:sp_green
    exe 'hi! DiffChange'      s:fmt_bold     s:fg_yellow   s:bg_base02   s:sp_yellow
    exe 'hi! DiffDelete'      s:fmt_bold     s:fg_red      s:bg_base02
    exe 'hi! DiffText'        s:fmt_bold     s:fg_blue     s:bg_base02   s:sp_blue
else
    exe 'hi! DiffAdd'         s:fmt_none     s:fg_green    s:bg_base02   s:sp_green
    exe 'hi! DiffChange'      s:fmt_none     s:fg_base0    s:bg_base02   s:sp_yellow
    exe 'hi! DiffDelete'      s:fmt_none     s:fg_red      s:bg_base02
    exe 'hi! DiffText'        s:fmt_none     s:fg_magenta  s:bg_base02   s:sp_blue
endif
exe 'hi! SignColumn'      s:fmt_none     s:fg_base0
exe 'hi! Conceal'         s:fmt_none     s:fg_blue     s:bg_none
exe 'hi! SpellBad'        s:fg_red       s:bg_base02   s:sp_red
exe 'hi! SpellCap'        s:fg_base0     s:bg_base02
exe 'hi! SpellRare'       s:fg_green     s:bg_none
exe 'hi! SpellLocal'      s:fg_none      s:bg_none

exe 'hi! Pmenu'           s:fmt_none     s:bg_base02   s:fg_base0
exe 'hi! PmenuSel'        s:fmt_none     s:bg_base01   s:fg_base02    s:fmt_bold
exe 'hi! PmenuSbar'       s:fmt_none     s:bg_base03   s:fg_none
exe 'hi! PmenuThumb'      s:fmt_none     s:bg_base0    s:fg_base03
exe 'hi! TabLine'         s:fmt_none     s:fg_base0    s:bg_base02    s:sp_base0
exe 'hi! TabLineFill'     s:fmt_none     s:fg_base0    s:bg_base02    s:sp_base0
exe 'hi! TabLineSel'      s:fmt_none     s:fg_base03   s:bg_base1     s:sp_base0
exe 'hi! CursorColumn'    s:fmt_none     s:fg_none     s:bg_base02
exe 'hi! CursorLine'      s:fmt_uopt     s:fg_none     s:bg_base02    s:sp_base1
exe 'hi! ColorColumn'     s:fmt_none     s:fg_none     s:bg_base02
exe 'hi! Cursor'          s:fmt_none     s:fg_base03   s:bg_base0
hi! link lCursor Cursor
exe 'hi! MatchParen'      s:fmt_bold     s:fg_orange   s:bg_base01

"}}}
" vim syntax highlighting "{{{
" ---------------------------------------------------------------------
"exe "hi! vimLineComment"  s:fg_base01   s:bg_none     s:fmt_ital
"hi! link vimComment Comment
"hi! link vimLineComment Comment
hi! link vimVar Identifier
hi! link vimFunc Function
hi! link vimUserFunc Function
hi! link helpSpecial Special
hi! link vimSet Normal
hi! link vimSetEqual Normal
exe 'hi! vimCommentString'   s:fmt_none      s:fg_violet   s:bg_none
exe 'hi! vimCommand'         s:fmt_none      s:fg_yellow   s:bg_none
exe 'hi! vimCmdSep'          s:fmt_bold      s:fg_blue     s:bg_none
exe 'hi! helpExample'        s:fmt_none      s:fg_base1    s:bg_none
exe 'hi! helpOption'         s:fmt_none      s:fg_cyan     s:bg_none
exe 'hi! helpNote'           s:fmt_none      s:fg_magenta  s:bg_none
exe 'hi! helpVim'            s:fmt_none      s:fg_magenta  s:bg_none
exe 'hi! helpHyperTextJump'  s:fmt_undr      s:fg_blue     s:bg_none
exe 'hi! helpHyperTextEntry' s:fmt_none      s:fg_green    s:bg_none
exe 'hi! vimIsCommand'       s:fmt_none      s:fg_base00   s:bg_none
exe 'hi! vimSynMtchOpt'      s:fmt_none      s:fg_yellow   s:bg_none
exe 'hi! vimSynType'         s:fmt_none      s:fg_cyan     s:bg_none
exe 'hi! vimHiLink'          s:fmt_none      s:fg_blue     s:bg_none
exe 'hi! vimHiGroup'         s:fmt_none      s:fg_blue     s:bg_none
exe 'hi! vimGroup'           s:fmt_undb      s:fg_blue     s:bg_none
"}}}
" diff highlighting "{{{
" ---------------------------------------------------------------------
hi! link diffAdded Statement
hi! link diffLine Identifier
"}}}
" git & gitcommit highlighting "{{{
"git
"exe "hi! gitDateHeader"
"exe "hi! gitIdentityHeader"
"exe "hi! gitIdentityKeyword"
"exe "hi! gitNotesHeader"
"exe "hi! gitReflogHeader"
"exe "hi! gitKeyword"
"exe "hi! gitIdentity"
"exe "hi! gitEmailDelimiter"
"exe "hi! gitEmail"
"exe "hi! gitDate"
"exe "hi! gitMode"
"exe "hi! gitHashAbbrev"
"exe "hi! gitHash"
"exe "hi! gitReflogMiddle"
"exe "hi! gitReference"
"exe "hi! gitStage"
"exe "hi! gitType"
"exe "hi! gitDiffAdded"
"exe "hi! gitDiffRemoved"
"gitcommit
"exe "hi! gitcommitSummary"
exe 'hi! gitcommitComment'       s:fmt_ital       s:fg_base01      s:bg_none
hi! link gitcommitUntracked gitcommitComment
hi! link gitcommitDiscarded gitcommitComment
hi! link gitcommitSelected  gitcommitComment
exe 'hi! gitcommitUnmerged'      s:fmt_bold       s:fg_green       s:bg_none
exe 'hi! gitcommitOnBranch'      s:fmt_bold       s:fg_base01      s:bg_none
exe 'hi! gitcommitBranch'        s:fmt_bold       s:fg_magenta     s:bg_none
hi! link gitcommitNoBranch gitcommitBranch
exe 'hi! gitcommitDiscardedType' s:fmt_none       s:fg_red         s:bg_none
exe 'hi! gitcommitSelectedType'  s:fmt_none       s:fg_green       s:bg_none
"exe "hi! gitcommitUnmergedType"
"exe "hi! gitcommitType"
"exe "hi! gitcommitNoChanges"
"exe "hi! gitcommitHeader"
exe 'hi! gitcommitHeader'        s:fmt_none       s:fg_base01      s:bg_none
exe 'hi! gitcommitUntrackedFile' s:fmt_bold       s:fg_cyan        s:bg_none
exe 'hi! gitcommitDiscardedFile' s:fmt_bold       s:fg_red         s:bg_none
exe 'hi! gitcommitSelectedFile'  s:fmt_bold       s:fg_green       s:bg_none
exe 'hi! gitcommitUnmergedFile'  s:fmt_bold       s:fg_yellow      s:bg_none
exe 'hi! gitcommitFile'          s:fmt_bold       s:fg_base0       s:bg_none
hi! link gitcommitDiscardedArrow gitcommitDiscardedFile
hi! link gitcommitSelectedArrow  gitcommitSelectedFile
hi! link gitcommitUnmergedArrow  gitcommitUnmergedFile
"exe "hi! gitcommitArrow"
"exe "hi! gitcommitOverflow"
"exe "hi! gitcommitBlank"
" }}}
" html highlighting "{{{
" ---------------------------------------------------------------------
exe 'hi! htmlTag'            s:fmt_none   s:fg_base01   s:bg_none
exe 'hi! htmlEndTag'         s:fmt_none   s:fg_base01   s:bg_none
exe 'hi! htmlTagN'           s:fmt_bold   s:fg_base1    s:bg_none
exe 'hi! htmlTagName'        s:fmt_bold   s:fg_blue     s:bg_none
exe 'hi! htmlSpecialTagName' s:fmt_ital   s:fg_blue     s:bg_none
exe 'hi! htmlArg'            s:fmt_none   s:fg_base00   s:bg_none
exe 'hi! javaScript'         s:fmt_none   s:fg_yellow   s:bg_none
"}}}
" perl highlighting "{{{
" ---------------------------------------------------------------------
exe 'hi! perlHereDoc'           s:fg_base1    s:bg_back     s:fmt_none
exe 'hi! perlVarPlain'          s:fg_yellow   s:bg_back     s:fmt_none
exe 'hi! perlStatementFileDesc' s:fg_cyan  s:bg_back  s:fmt_none

"}}}
" tex highlighting "{{{
" ---------------------------------------------------------------------
exe 'hi! texStatement'    s:fg_cyan     s:bg_back     s:fmt_none
exe 'hi! texMathZoneX'    s:fg_yellow   s:bg_back     s:fmt_none
exe 'hi! texMathMatcher'  s:fg_yellow   s:bg_back     s:fmt_none
exe 'hi! texMathMatcher'  s:fg_yellow   s:bg_back     s:fmt_none
exe 'hi! texRefLabel'     s:fg_yellow   s:bg_back     s:fmt_none
"}}}
" ruby highlighting "{{{
" ---------------------------------------------------------------------
exe 'hi! rubyDefine'      s:fg_base1    s:bg_back     s:fmt_bold
"rubyInclude
"rubySharpBang
"rubyAccess
"rubyPredefinedVariable
"rubyBoolean
"rubyClassVariable
"rubyBeginEnd
"rubyRepeatModifier
"hi! link rubyArrayDelimiter    Special  " [ , , ]
"rubyCurlyBlock  { , , }

"hi! link rubyClass             Keyword
"hi! link rubyModule            Keyword
"hi! link rubyKeyword           Keyword
"hi! link rubyOperator          Operator
"hi! link rubyIdentifier        Identifier
"hi! link rubyInstanceVariable  Identifier
"hi! link rubyGlobalVariable    Identifier
"hi! link rubyClassVariable     Identifier
"hi! link rubyConstant          Type
"}}}
" haskell syntax highlighting"{{{
" ---------------------------------------------------------------------
" For use with syntax/haskell.vim : Haskell Syntax File
" http://www.vim.org/scripts/script.php?script_id=3034
" See also Steffen Siering's github repository:
" http://github.com/urso/dotrc/blob/master/vim/syntax/haskell.vim
" ---------------------------------------------------------------------
"
" Treat True and False specially, see the plugin referenced above
let hs_highlight_boolean=1
" highlight delims, see the plugin referenced above
let hs_highlight_delimiters=1

exe 'hi! cPreCondit' s:fg_orange  s:bg_none     s:fmt_none

exe 'hi! VarId'     s:fg_blue     s:bg_none     s:fmt_none
exe 'hi! ConId'     s:fg_yellow   s:bg_none     s:fmt_none
exe 'hi! hsImport'  s:fg_magenta  s:bg_none     s:fmt_none
exe 'hi! hsString'  s:fg_base00   s:bg_none     s:fmt_none

exe 'hi! hsStructure'         s:fg_cyan     s:bg_none     s:fmt_none
exe 'hi! hs_hlFunctionName'   s:fg_blue     s:bg_none
exe 'hi! hsStatement'         s:fg_cyan     s:bg_none     s:fmt_none
exe 'hi! hsImportLabel'       s:fg_cyan     s:bg_none     s:fmt_none
exe 'hi! hs_OpFunctionName'   s:fg_yellow   s:bg_none     s:fmt_none
exe 'hi! hs_DeclareFunction'  s:fg_orange   s:bg_none     s:fmt_none
exe 'hi! hsVarSym'            s:fg_cyan     s:bg_none     s:fmt_none
exe 'hi! hsType'              s:fg_yellow   s:bg_none     s:fmt_none
exe 'hi! hsTypedef'           s:fg_cyan     s:bg_none     s:fmt_none
exe 'hi! hsModuleName'        s:fg_green    s:bg_none     s:fmt_undr
exe 'hi! hsModuleStartLabel'  s:fg_magenta  s:bg_none     s:fmt_none
hi! link hsImportParams      Delimiter
hi! link hsDelimTypeExport   Delimiter
hi! link hsModuleStartLabel  hsStructure
hi! link hsModuleWhereLabel  hsModuleStartLabel

" following is for the haskell-conceal plugin
" the first two items don't have an impact, but better safe
exe 'hi! hsNiceOperator'      s:fg_cyan     s:bg_none     s:fmt_none
exe 'hi! hsniceoperator'      s:fg_cyan     s:bg_none     s:fmt_none

"}}}
" pandoc markdown syntax highlighting "{{{
" ---------------------------------------------------------------------

"PandocHiLink pandocNormalBlock
exe 'hi! pandocTitleBlock'                s:fg_blue     s:bg_none     s:fmt_none
exe 'hi! pandocTitleBlockTitle'           s:fg_blue     s:bg_none     s:fmt_bold
exe 'hi! pandocTitleComment'              s:fg_blue     s:bg_none     s:fmt_bold
exe 'hi! pandocComment'                   s:fg_base01   s:bg_none     s:fmt_ital
exe 'hi! pandocVerbatimBlock'             s:fg_yellow   s:bg_none     s:fmt_none
hi! link pandocVerbatimBlockDeep          pandocVerbatimBlock
hi! link pandocCodeBlock                  pandocVerbatimBlock
hi! link pandocCodeBlockDelim             pandocVerbatimBlock
exe 'hi! pandocBlockQuote'                s:fg_blue     s:bg_none     s:fmt_none
exe 'hi! pandocBlockQuoteLeader1'         s:fg_blue     s:bg_none     s:fmt_none
exe 'hi! pandocBlockQuoteLeader2'         s:fg_cyan     s:bg_none     s:fmt_none
exe 'hi! pandocBlockQuoteLeader3'         s:fg_yellow   s:bg_none     s:fmt_none
exe 'hi! pandocBlockQuoteLeader4'         s:fg_red      s:bg_none     s:fmt_none
exe 'hi! pandocBlockQuoteLeader5'         s:fg_base0    s:bg_none     s:fmt_none
exe 'hi! pandocBlockQuoteLeader6'         s:fg_base01   s:bg_none     s:fmt_none
exe 'hi! pandocListMarker'                s:fg_magenta  s:bg_none     s:fmt_none
exe 'hi! pandocListReference'             s:fg_magenta  s:bg_none     s:fmt_undr

" Definitions
" ---------------------------------------------------------------------
let s:fg_pdef = s:fg_violet
let s:bg_pdef = s:bg_violet
exe 'hi! pandocDefinitionBlock'                   s:fg_pdef    s:bg_none    s:fmt_none
exe 'hi! pandocDefinitionTerm'                    s:bg_pdef    s:bg_none    s:fmt_none
exe 'hi! pandocDefinitionIndctr'                  s:fg_pdef    s:bg_none    s:fmt_bold
exe 'hi! pandocEmphasisDefinition'                s:fg_pdef    s:bg_none    s:fmt_ital
exe 'hi! pandocEmphasisNestedDefinition'          s:fg_pdef    s:bg_none    s:fmt_bold
exe 'hi! pandocStrongEmphasisDefinition'          s:fg_pdef    s:bg_none    s:fmt_bold
exe 'hi! pandocStrongEmphasisNestedDefinition'    s:fg_pdef    s:bg_none    s:fmt_bold
exe 'hi! pandocStrongEmphasisEmphasisDefinition'  s:fg_pdef    s:bg_none    s:fmt_bold
exe 'hi! pandocStrikeoutDefinition'               s:bg_pdef    s:fg_none    s:fmt_none
exe 'hi! pandocVerbatimInlineDefinition'          s:fg_pdef    s:bg_none    s:fmt_none
exe 'hi! pandocSuperscriptDefinition'             s:fg_pdef    s:bg_none    s:fmt_none
exe 'hi! pandocSubscriptDefinition'               s:fg_pdef    s:bg_none    s:fmt_none

" Tables
" ---------------------------------------------------------------------
let s:fg_ptable = s:fg_blue
let s:bg_ptable = s:bg_blue
exe 'hi! pandocTable'                         s:fg_ptable  s:bg_none    s:fmt_none
exe 'hi! pandocTableStructure'                s:fg_ptable  s:bg_none    s:fmt_none
hi! link pandocTableStructureTop             pandocTableStructre
hi! link pandocTableStructureEnd             pandocTableStructre
exe 'hi! pandocTableZebraLight'               s:fg_ptable  s:bg_base03  s:fmt_none
exe 'hi! pandocTableZebraDark'                s:fg_ptable  s:bg_base02  s:fmt_none
exe 'hi! pandocEmphasisTable'                 s:fg_ptable  s:bg_none    s:fmt_ital
exe 'hi! pandocEmphasisNestedTable'           s:fg_ptable  s:bg_none    s:fmt_bold
exe 'hi! pandocStrongEmphasisTable'           s:fg_ptable  s:bg_none    s:fmt_bold
exe 'hi! pandocStrongEmphasisNestedTable'     s:fg_ptable  s:bg_none    s:fmt_bold
exe 'hi! pandocStrongEmphasisEmphasisTable'   s:fg_ptable  s:bg_none    s:fmt_bold
exe 'hi! pandocStrikeoutTable'                s:bg_ptable  s:fg_none    s:fmt_none
exe 'hi! pandocVerbatimInlineTable'           s:fg_ptable  s:bg_none    s:fmt_none
exe 'hi! pandocSuperscriptTable'              s:fg_ptable  s:bg_none    s:fmt_none
exe 'hi! pandocSubscriptTable'                s:fg_ptable  s:bg_none    s:fmt_none

" Headings
" ---------------------------------------------------------------------
let s:fg_phead = s:fg_orange
let s:bg_phead = s:bg_orange
exe 'hi! pandocHeading'                       s:fg_phead   s:bg_none  s:fmt_bold
exe 'hi! pandocHeadingMarker'                 s:fg_yellow  s:bg_none  s:fmt_bold
exe 'hi! pandocEmphasisHeading'               s:fg_phead   s:bg_none  s:fmt_bold
exe 'hi! pandocEmphasisNestedHeading'         s:fg_phead   s:bg_none  s:fmt_bold
exe 'hi! pandocStrongEmphasisHeading'         s:fg_phead   s:bg_none  s:fmt_bold
exe 'hi! pandocStrongEmphasisNestedHeading'   s:fg_phead   s:bg_none  s:fmt_bold
exe 'hi! pandocStrongEmphasisEmphasisHeading' s:fg_phead   s:bg_none  s:fmt_bold
exe 'hi! pandocStrikeoutHeading'              s:bg_phead   s:fg_none  s:fmt_none
exe 'hi! pandocVerbatimInlineHeading'         s:fg_phead   s:bg_none  s:fmt_bold
exe 'hi! pandocSuperscriptHeading'            s:fg_phead   s:bg_none  s:fmt_bold
exe 'hi! pandocSubscriptHeading'              s:fg_phead   s:bg_none  s:fmt_bold

" Links
" ---------------------------------------------------------------------
exe 'hi! pandocLinkDelim'                 s:fg_base01   s:bg_none     s:fmt_none
exe 'hi! pandocLinkLabel'                 s:fg_blue     s:bg_none     s:fmt_undr
exe 'hi! pandocLinkText'                  s:fg_blue     s:bg_none     s:fmt_undb
exe 'hi! pandocLinkURL'                   s:fg_base00   s:bg_none     s:fmt_undr
exe 'hi! pandocLinkTitle'                 s:fg_base00   s:bg_none     s:fmt_undr
exe 'hi! pandocLinkTitleDelim'            s:fg_base01   s:bg_none     s:fmt_undr     s:sp_base00
exe 'hi! pandocLinkDefinition'            s:fg_cyan     s:bg_none     s:fmt_undr     s:sp_base00
exe 'hi! pandocLinkDefinitionID'          s:fg_blue     s:bg_none     s:fmt_bold
exe 'hi! pandocImageCaption'              s:fg_violet   s:bg_none     s:fmt_undb
exe 'hi! pandocFootnoteLink'              s:fg_green    s:bg_none     s:fmt_undr
exe 'hi! pandocFootnoteDefLink'           s:fg_green    s:bg_none     s:fmt_bold
exe 'hi! pandocFootnoteInline'            s:fg_green    s:bg_none     s:fmt_undb
exe 'hi! pandocFootnote'                  s:fg_green    s:bg_none     s:fmt_none
exe 'hi! pandocCitationDelim'             s:fg_magenta  s:bg_none     s:fmt_none
exe 'hi! pandocCitation'                  s:fg_magenta  s:bg_none     s:fmt_none
exe 'hi! pandocCitationID'                s:fg_magenta  s:bg_none     s:fmt_undr
exe 'hi! pandocCitationRef'               s:fg_magenta  s:bg_none     s:fmt_none

" Main Styles
" ---------------------------------------------------------------------
exe 'hi! pandocStyleDelim'                s:fg_base01   s:bg_none    s:fmt_none
exe 'hi! pandocEmphasis'                  s:fg_base0    s:bg_none    s:fmt_ital
exe 'hi! pandocEmphasisNested'            s:fg_base0    s:bg_none    s:fmt_bold
exe 'hi! pandocStrongEmphasis'            s:fg_base0    s:bg_none    s:fmt_bold
exe 'hi! pandocStrongEmphasisNested'      s:fg_base0    s:bg_none    s:fmt_bold
exe 'hi! pandocStrongEmphasisEmphasis'    s:fg_base0    s:bg_none    s:fmt_bold
exe 'hi! pandocStrikeout'                 s:bg_base01   s:fg_none    s:fmt_none
exe 'hi! pandocVerbatimInline'            s:fg_yellow   s:bg_none    s:fmt_none
exe 'hi! pandocSuperscript'               s:fg_violet   s:bg_none    s:fmt_none
exe 'hi! pandocSubscript'                 s:fg_violet   s:bg_none    s:fmt_none

exe 'hi! pandocRule'                      s:fg_blue     s:bg_none    s:fmt_bold
exe 'hi! pandocRuleLine'                  s:fg_blue     s:bg_none    s:fmt_bold
exe 'hi! pandocEscapePair'                s:fg_red      s:bg_none    s:fmt_bold
exe 'hi! pandocCitationRef'               s:fg_magenta  s:bg_none     s:fmt_none
exe 'hi! pandocNonBreakingSpace'          s:bg_red     s:fg_none    s:fmt_none
hi! link pandocEscapedCharacter          pandocEscapePair
hi! link pandocLineBreak                 pandocEscapePair

" Embedded Code
" ---------------------------------------------------------------------
exe 'hi! pandocMetadataDelim'             s:fg_base01   s:bg_none     s:fmt_none
exe 'hi! pandocMetadata'                  s:fg_blue     s:bg_none     s:fmt_none
exe 'hi! pandocMetadataKey'               s:fg_blue     s:bg_none     s:fmt_none
exe 'hi! pandocMetadata'                  s:fg_blue     s:bg_none     s:fmt_bold
hi! link pandocMetadataTitle             pandocMetadata

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
