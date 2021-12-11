" GVim config
" Created: Aug 2005
" Last Modified: 11/12/2021, 08:02:20 +0530
"

" Window Appearance {{{1
"
if GetPlatform() == "win"
    "set guifont=consolas:h9:cANSI
    "set guifont=JetBrains_Mono:h12:cANSI:qDRAFT
    if has("nvim")
        set guifont=Cascadia\ Code:h12
    else
        set guifont=Cascadia_Code:h12:cANSI:qDRAFT
    endif
    au GUIEnter * simalt ~x " maximize window on start
else
    set guifont=JetBrains\ Mono\ 12
    "set guifont=Consolas\ 14
endif

set guiheadroom=0	    " use up all space allocated to vim
set guioptions-=T           " get rid of toolbars
set guioptions-=m           " get rid of menus
set guioptions-=r           " get rid of scrollbars
set mousehide		    " hide the mouse when typing text

" Pure gvim {{{1
"
"set lines=80

" NVim Qt {{{1
if has("nvim")
    " enable Shift+Insert
    inoremap <silent>  <S-Insert>  <C-R>+
endif

" Key bindings {{{1
"
" paste w/ shift-insert
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>
