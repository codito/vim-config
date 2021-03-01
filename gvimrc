" GVim config
" Created: Aug 2005
" Last Modified: 02/02/2021, 07:59:14 IST
"

" Window Appearance {{{1
"
if GetPlatform() == "win"
    "set guifont=consolas:h9:cANSI
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

" Key bindings {{{1
"
" paste w/ shift-insert
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>
