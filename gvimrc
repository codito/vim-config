" GVim config
" Created: Aug 2005
" Last Modified: Fri 01 Jan 2010 11:19:29 PM IST
"

" Window Appearance {{{1
"
if GetPlatform() == "win"
    set guifont=consolas:h9:cANSI
    au GUIEnter * simalt ~x " maximize window on start
else
    set guifont=inconsolata
endif

set guiheadroom=0	    " use up all space allocated to vim
set guioptions-=T           " get rid of toolbars
set guioptions-=m           " get rid of menus
set guioptions-=r           " get rid of scrollbars
set mousehide		    " hide the mouse when typing text

" Editor Appearance {{{1
"
colorscheme twilight

" Pure gvim {{{1
"
"set lines=80

" Key bindings {{{1
"
" paste w/ shift-insert
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>
