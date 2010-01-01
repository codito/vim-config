if exists("b:did_ftplugin")
    finish
endif

let b:did_ftplugin = 1

if &filetype!="calendar"
    finish
endif

set ai
set tw=80

imap <localleader>z <C-R>=strftime("%Y-%m-%d %X")<CR>
nmap <localleader>z i<C-R>=strftime("%Y-%m-%d %X")<CR><ESC>
