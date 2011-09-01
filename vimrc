" VIM config file
" Created: Aug 2005
" Last Modified: Thu 01 Sep 2011 01:35:09 PM IST Standard Time

" Platform related {{{1
"
" Unleash the pathogen!
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Local settings file, default to linux
let s:localFile = "~/.local.vim" 

" Know the platform we're running on
function! GetPlatform()
    if has("win32") || has("win64")
        return "win"
    else
        return "nix"
    endif
endfunction
 
" Get ready for life w/o walls
if GetPlatform() == "win"
    let s:localFile = "~/local.vim"
    let g:skip_loading_mswin = 1    " don't need the shortcuts
    behave mswin
endif

" Pure vim {{{1
"
" Autocomplete {{{2
set complete+=k             " scan the files given with the 'dictionary' option
set wildmenu		    " command-line completion operates in an enhanced mode
set wildignore=*.bak,*.o,*.e,*~	" ignore these

" Buffers {{{2
set autoread                " read open files again when changed outside Vim
set autowrite               " write a modified buffer on each :next , ...
set backspace=indent,eol,start  " define backspace behavior
set bufhidden=delete        " delete hidden buffers, changes will be lost!
set switchbuf=split,usetab  " split/open new tab while switching buffers, for quickfix

" Directories {{{2
set noautochdir                 " don't switch directory to current file
if GetPlatform() == "win"
    set backupdir=d:\backups
    set directory=d:\backups
else
    set backupdir=~/.vim/tmp    " isolate the swap files to some corner
    set directory=~/.vim/tmp    " directories for swap files
endif

" Editor appearance {{{2
colorscheme desert
set foldmethod=syntax       " default fold by syntax
set number		    " enable line number
set nocp                    " don't be vi compatible
set ruler                   " show the line,col info at bottom
set showcmd		    " show partial cmd in the last line
set showmatch               " jump to the other end of a curly brace
set showmode                " show the mode INSERT/REPLACE/...
syntax enable               " enable syntax highlighting
set textwidth=100           " break a line after 100 characters
set noequalalways           " for :split don't split space equally
set winheight=99999 winminheight=0  " rolodex look for vim
set visualbell              " oh no beeps please!

" Key mappings in general {{{2
nmap <silent><S-Tab> :tabnext<CR>

" Search {{{2
set incsearch               " use incremental search
set whichwrap=<,>,h,l,[,]]  " set wrapping at the end of line 
set wrapscan                " wrap the search

" Tabs and Indentation {{{2
set cindent                 " support c indenting style
set expandtab		    " use spaces for indentation
set softtabstop=4           " replace tabs with 4 spaces
set shiftwidth=4	    " for inserting spaces with S-<< and S->>
set tabstop=8               " defacto tab standard

" Tags {{{2
set sft                     " show full tags while autocompleting
set tags=tags,./tags,../,../..

" Misc {{{2
filetype plugin on          " enable plugin support


" Language and file types {{{1
"
" Generic {{{2
" Filetype plugin
filetype plugin indent on
" Quickfix mode shortcuts
nmap <silent><F9> :make<cr>
nmap <silent><F10> :cl<cr>
nmap <silent><F11> :cp<cr>
nmap <silent><F12> :cn<cr>

" C/C++ {{{2
au FileType cc,cpp map <F8> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
" Quickfix mode: command line msbuild error format
if GetPlatform() == "win"
    au FileType c,cpp set errorformat=%f(%l)\ :\ error\ C%n:\ %m
endif

" C# {{{2
" Folding : http://vim.wikia.com/wiki/Syntax-based_folding, see comment by Ostrygen
"au FileType cs set omnifunc=syntaxcomplete#Complete
au FileType cs set foldmethod=indent
au FileType cs set foldmarker={,} 
au FileType cs set foldtext=substitute(getline(v:foldstart+1),'{.*','{...}',)
au FileType cs set foldlevelstart=3
" Quickfix mode: command line msbuild error format
if GetPlatform() == "win"
    au FileType cs set errorformat=\ %#%f(%l\\\,%c):\ error\ CS%n:\ %m
endif
" C# tags
au FileType cs map <F8> :!ctags --recurse --extra=+fq --fields=+ianmzS --c\#-kinds=cimnp .<CR>

" Mail {{{2
autocmd BufNewFile,BufRead /tmp/mutt-* set filetype=mail
au FileType mail setlocal spell spelllang=en_us
au FileType mail set tw=66 autoindent expandtab formatoptions=tcqn
au FileType mail set list listchars=tab:»·,trail:·
au FileType mail set comments=nb:>
au FileType mail vmap D dO[...]^[
" go to a good starting point
au FileType mail silent normal /--\s*$^MO^[gg/^$^Mj

" PHP {{{2
let php_sql_query=1         " highlight all sql queries
let php_htmlInStrings=1     " highlight html syntax within strings
let php_noShortTags=1       " disable short tags
let php_folding=1           " enable folding for classes and functions

" php pear coding guidelines
" http://wiki.geeklog.net/wiki/index.php/Coding_Guidelines#Indenting_and_Line_Length
au FileType php setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4
 
" Powershell {{{2
au BufRead,BufNewFile *.ps1 set ft=ps1

" Python {{{2
au FileType python set omnifunc=pythoncomplete#Complete
au FileType python setlocal et sw=4 sts=4 ts=4 ai foldmethod=indent foldlevel=99
" Type :make and browse through syntax errors.
" http://www.sontek.net/post/Python-with-a-modular-IDE-(Vim).aspx
au BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\" 
au BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
" Compile/check selected blocks in .py
python << EOL 
import vim 
def EvaluateCurrentRange(): 
    eval(compile('\n'.join(vim.current.range),'','exec'),globals()) 
EOL 
map <C-h> :py EvaluateCurrentRange()

" Markdown {{{2
" Don't insert linebreaks in documents, it screws up conversions
au FileType markdown setlocal tw=0 wrap linebreak nolist wrapmargin=0 ai formatoptions=tcroqn2 comments=n:>

" Text {{{2
"au BufRead,BufNewFile *.txt set filetype=txt
au FileType txt set tw=100 autoindent expandtab formatoptions=taqn

" VimWiki {{{2
au FileType vimwiki set foldlevel=2 foldlevelstart=2
au FileType vimwiki map <F8> :!ctags -R .<CR>
au FileType vimwiki let tlist_vimwiki_settings = 'wiki;h:Headers'

" XML {{{2
au FileType xml setlocal et sw=2 sts=2 ts=2 ai

" Misc {{{2
" Change the working directory to the directory containing the current file
if has("autocmd")
  autocmd BufEnter,BufRead,BufNewFile,BufFilePost * :lcd %:p:h
endif " has("autocmd")

" Plugins {{{1
"
" Command T {{{2
let g:CommandTMatchWindowAtTop = 1
nnoremap <silent> sj     :CommandTBuffer<CR>
nnoremap <silent> sk     :CommandT<CR>

" NERD Commenter {{{2
let g:NERDShutUp = 1
nmap <silent><F7> :NERDTreeToggle<cr>

" Netrw plugin {{{2
let g:netrw_browse_split=3  " all edits in new tab

" OmniCppComplete {{{2
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest

" Tagbar {{{2
" Settings for tagbar.vim
let g:tagbar_singleclick = 1
let g:tagbar_autofocus = 1
nmap <Leader>tt :TagbarToggle<cr>

" Timestamp {{{2
if GetPlatform() == "win"
    let timestamp_regexp = '\v\C%(<Last %([cC]hanged?|[Mm]odified):\s+)@<=.*$'
endif
let g:timestamp_modelines = 50

" Vimwiki {{{2
let g:vimwiki_folding = 1
let g:vimwiki_list = [{'path' : '~/docs'}]
let g:vimwiki_dir_link = 'index'

" Extensions and utils {{{1
"
" Enable camelCase text navigation {{{2
" Key Mappings for camelCase
":let g:camelchar = "A-Z"               " stop on capital letters
":let g:camelchar = "A-Z0-9"            " stop on numbers
:let g:camelchar = "A-Z0-9.,;:{([`'\""  " catch-all. class member, separator, end of statement, brackets and quotes

nnoremap <silent><C-Left> :<C-u>cal search('\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%^','bW')<CR>
nnoremap <silent><C-Right> :<C-u>cal search('\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%$','W')<CR>
inoremap <silent><C-Left> <C-o>:cal search('\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%^','bW')<CR>
inoremap <silent><C-Right> <C-o>:cal search('\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%$','W')<CR>
" Expand current date time stamp {{{2
:iab <expr> dts strftime("%Y %b %d, %H:%M")

" Local machine dependent mods {{{1
"
exe "source " . s:localFile

" vim: foldmethod=marker
" EOF
