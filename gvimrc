" GVim config
" Created: Aug 2005
" Last Modified: Sat 08 Jan 2011 10:37:57 AM IST
"

" Window Appearance {{{1
"
if GetPlatform() == "win"
    set guifont=consolas:h9:cANSI
    au GUIEnter * simalt ~x " maximize window on start
else
    set guifont=Inconsolata\ Medium\ 12
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
