" VIM config file
" Created: Aug 2005
" Last Modified: 17/11/2018, 15:33:33 IST

" Platform related {{{1
"
" Unleash the pathogen!
call pathogen#infect()

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
set wildignore=*.bak,*.o,*.e,*~,*.pyc	" ignore these

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

" Diff {{{2
set diffopt+=vertical       " vertical diffs are natural

" Editor appearance {{{2
set t_Co=256
set t_ut=                   " disable BCE, makes vim colors play nice in tmux
colorscheme apprentice
set background=dark
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
"set winheight=99999 winminheight=0  " rolodex look for vim
set visualbell              " oh no beeps please!
set cursorline              " highlight the line our cursor is in

" Key mappings in general {{{2
nmap <silent><S-Tab> :tabnext<CR>
nnoremap <silent><C-F4> :bdelete<CR>

" Omnicomplete {{{2
" Automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

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
" Quickfix mode: command line msbuild error format
if GetPlatform() == "win"
    au FileType c,cpp set errorformat=%f(%l)\ :\ error\ C%n:\ %m
endif
au FileType c,cpp setlocal softtabstop=2 shiftwidth=2 tabstop=2 colorcolumn=80 textwidth=80

" C# {{{2
" Folding : http://vim.wikia.com/wiki/Syntax-based_folding, see comment by Ostrygen
au FileType cs set foldmethod=indent foldmarker={,} foldtext=substitute(getline(v:foldstart+1),'{.*','{...}',) foldlevel=3

" HTML {{{2
au FileType html setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=4

" Javascript {{{2
au FileType javascript setlocal omnifunc=tern#Complete

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
au FileType python setlocal et sw=4 sts=4 ts=4 ai foldmethod=indent foldlevel=99 colorcolumn=80 textwidth=80
au FileType python NeoCompleteLock
" Type :make and browse through syntax errors.
" http://www.sontek.net/post/Python-with-a-modular-IDE-(Vim).aspx
"au BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\" 
au BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

" Markdown {{{2
" Don't insert linebreaks in documents, it screws up conversions
au FileType markdown setlocal tw=80 nolist wrapmargin=0 ai formatoptions=tcroqn comments=n:>

" Text {{{2
"au BufRead,BufNewFile *.txt set filetype=txt
au FileType txt set tw=100 autoindent expandtab formatoptions=taqn

" Typescript {{{2
au FileType typescript setlocal filetype=typescript.javascript omnifunc=tsuquyomi#complete

" VimWiki {{{2
au FileType vimwiki set foldlevel=2 foldlevelstart=2
au FileType vimwiki map <F8> :!ctags -R .<CR>
au FileType vimwiki let tlist_vimwiki_settings = 'wiki;h:Headers'

" XML {{{2
au FileType xml setlocal et sw=2 sts=2 ts=2 ai

" Misc {{{2
" Change the working directory to the directory containing the current file
"if has("autocmd")
  "autocmd BufEnter,BufRead,BufNewFile,BufFilePost * :lcd %:p:h
"endif " has("autocmd")

" Plugins {{{1
"
" Ale - language checks {{{2
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'cpp': ['clangtidy']
\}
let g:ale_fixers = {
\   'cpp': ['clang-format']
\}

" Bind F8 to fixing problems with ALE
nmap <F8> <Plug>(ale_fix)

" Ctrl-p {{{2
" Ignore node_modules and bower_components
let g:ctrlp_custom_ignore = '\v[\/](\.(git|hg|svn)|node_modules|bower_components|bin|obj|dll|exe|lib)$'
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" Fu-git-ive-ness {{{2
nmap <leader>gs :Gstatus<cr>
nmap <leader>gc :Gcommit<cr>
nmap <leader>ga :Gwrite<cr>
nmap <leader>gl :Glog<cr>
nmap <leader>gd :Gdiff<cr>
nmap <leader>g2 :diffget //2<cr>
nmap <leader>g3 :diffget //3<cr>
nmap <leader>g0 :Gwrite!<cr>

" Limelight {{{2
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" NERD Tree/Commenter {{{2
let g:NERDShutUp = 1
let NERDTreeChDirMode=0     " please don't chdir for me
nmap <silent><F7> :NERDTreeToggle<cr>

" Netrw plugin {{{2
let g:netrw_browse_split=3  " all edits in new tab

" Table mode {{{2
" Settings for vim-table-mode
let g:table_mode_corner="|" " markdown compatible tables by default
let g:table_mode_tableize_map = '<Leader>tb'

" Tagbar {{{2
" Settings for tagbar.vim
let g:tagbar_singleclick = 1
let g:tagbar_autofocus = 1
nmap <Leader>tt :TagbarToggle<CR>

" Timestamp {{{2
let g:timestamp_regexp = '\v\C%(<Last %([cC]hanged?|[Mm]odified|[Uu]pdated):\s+)@<=.*$'
let g:timestamp_modelines = 50
let g:timestamp_rep = "%d/%m/%Y, %T %Z"

" Ultisnips {{{2
let g:ultisnips_python_style = "google"

" Vim-clang {{{2
" Setup using a compilation database from build directory
let g:clang_compilation_database = './build'

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
if filereadable(expand(s:localFile))
    exe "source " . s:localFile
endif

" vim: foldmethod=marker
" EOF
