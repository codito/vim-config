" VIM config file
" Created: Aug 2005
" Last Modified: 01/12/2020, 11:49:15 IST

" Platform {{{1
"
" Local settings file, default to linux
let s:localFile = "~/.local.vim"
let s:pluginDir = "~/.vim/bundle"

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
    let s:pluginDir = "~/vimfiles/bundle"
    let g:skip_loading_mswin = 1    " don't need the shortcuts
    behave mswin
endif

" Plugins {{{1
"
silent! if plug#begin(s:pluginDir)

Plug 'ActivityWatch/aw-watcher-vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'majutsushi/tagbar'
Plug 'mattn/calendar-vim'
Plug 'Rip-Rip/clang_complete',  { 'for': 'cpp' }
Plug 'vim-scripts/timestamp.vim'
Plug 'hail2u/vim-css3-syntax'
Plug 'ap/vim-css-color'
Plug 'lotabout/skim', { 'dir': '~/.skim', 'do': './install' }
Plug 'lotabout/skim.vim'
Plug 'tpope/vim-fugitive'
Plug 'maralla/completor.vim'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'tpope/vim-dispatch'
Plug 'w0rp/ale'
Plug 'hynek/vim-python-pep8-indent'
Plug 'dhruvasagar/vim-table-mode'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'konfekt/fastfold'
Plug 'reedes/vim-pencil'
Plug 'reedes/vim-lexical'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-unimpaired'
Plug 'sheerun/vim-polyglot'
Plug 'OmniSharp/omnisharp-vim', { 'for': 'cs' }
Plug 'ruanyl/coverage.vim', { 'for': 'javascript' }

" Colors {{{2
"
Plug 'altercation/vim-colors-solarized'
Plug 'w0ng/vim-hybrid'
Plug 'romainl/apprentice'
Plug 'morhetz/gruvbox'

call plug#end()
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
if exists('+termguicolors')
    let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
    let &t_Cs = "\e[6m"     " show underlines for undercurl in terminals
    let &t_Ce = "\e[24m"
    set termguicolors
endif
set background=light
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
set signcolumn=yes          " do not shift text when error message shows

" Key mappings in general {{{2
nmap <silent><S-Tab> :tabnext<CR>
nnoremap <silent><C-F4> :bdelete<CR>

" Omnicomplete {{{2
" Automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,noselect,preview
set shortmess+=c            " do not pass short messages to completion menu

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

" CSS {{{2
au FileType css setlocal shiftwidth=2 softtabstop=2 tabstop=4

" HTML {{{2
au FileType html setlocal shiftwidth=2 softtabstop=2 tabstop=4

" Javascript {{{2
au FileType javascript setlocal shiftwidth=2 softtabstop=2 tabstop=4

" Json {{{2
au FileType json setlocal foldmethod=manual shiftwidth=2 softtabstop=2 tabstop=4

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
" Type :make and browse through syntax errors.
" http://www.sontek.net/post/Python-with-a-modular-IDE-(Vim).aspx
"au BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
au BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

" Markdown {{{2
" Don't insert linebreaks in documents, it screws up conversions
au FileType markdown setlocal tw=80 nolist wrapmargin=0 ai formatoptions=tcroqn comments=n:> conceallevel=2 nofoldenable

" Text {{{2
"au BufRead,BufNewFile *.txt set filetype=txt
au FileType txt set tw=100 autoindent expandtab formatoptions=taqn

" Typescript {{{2
au FileType typescript setlocal et sw=2 sts=2 ts=2 ai filetype=typescript.javascript omnifunc=tsuquyomi#complete


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
\   'cpp': ['clangtidy'],
\   'cs': ['OmniSharp'],
\   'css': ['stylelint', 'prettier'],
\   'javascript': ['eslint', 'prettier'],
\   'typescript': ['eslint', 'prettier'],
\   'markdown': ['proselint', 'vale'],
\}
let g:ale_linter_aliases = {'typescriptreact': 'typescript'}
let g:ale_fixers = {
\   'cpp': ['clang-format'],
\   'javascript': ['eslint', 'prettier'],
\   'typescript': ['eslint', 'prettier'],
\   'typescriptreact': ['eslint', 'prettier'],
\   'markdown': ['prettier'],
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\}

" Bind F8 to fixing problems with ALE
nmap <F8> <Plug>(ale_fix)
nmap <silent> <leader>aj :ALENextWrap<cr>
nmap <silent> <leader>ak :ALEPreviousWrap<cr>

let g:ale_lint_on_enter = 1
let g:ale_lint_on_text_changed = 'never'
highlight ALEErrorSign ctermbg=NONE ctermfg=red
highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
let g:ale_linters_explicit = 1
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1

" Coc completion {{{2
" See https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#implemented-coc-extensions
" download following extensions by default.
let g:coc_global_extensions = ['coc-tsserver', 'coc-json', 'coc-html', 'coc-css', 'coc-python']

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Code navigation
nmap <leader>fd <Plug>(coc-definition)
nmap <leader>ft <Plug>(coc-type-definition)
nmap <leader>fi <Plug>(coc-implementation)
nmap <leader>fr <Plug>(coc-references)

" Code refactoring
nmap <leader>ri <Plug>:call CocAction('runCommand', 'editor.action.organizeImport')
nmap <leader>rn <Plug>(coc-rename)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Formatting selected code.
xmap <leader>fo  <Plug>(coc-format-selected)
nmap <leader>fo  <Plug>(coc-format-selected)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

augroup coc_commands
    autocmd!

    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup END

" Completor {{{2
let g:completor_auto_trigger = 0

" Coverage {{{2
" Setup the coverage json to match jest convention
let g:coverage_json_report_path = 'coverage/coverage-final.json'
let g:coverage_show_covered = 1

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

" Goyo {{{2
let g:goyo_width=&textwidth

" Gruvbox color {{{2
let g:gruvbox_italic=1
let g:gruvbox_contrast_light='medium'
colorscheme gruvbox

" Lexical {{{2
augroup lexical
    autocmd!
    autocmd FileType markdown call lexical#init()
augroup END

" Limelight {{{2
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" Markdown {{{2
let g:vim_markdown_frontmatter = 1

" NERD Tree/Commenter {{{2
let g:NERDShutUp = 1
let NERDTreeChDirMode=0     " please don't chdir for me
nmap <silent><F7> :NERDTreeToggle<cr>

" Netrw plugin {{{2
let g:netrw_browse_split=3  " all edits in new tab

" Pencil {{{2
augroup pencil
    autocmd!
    autocmd FileType markdown call pencil#init({'wrap': 'hard'})
    let g:pencil#textwidth = &textwidth
    let g:pencil#conceallevel = 3
    let g:pencil#concealcursor = 'c'

    " Disable autoformat to allow markdown bullets to work without auto joins with previous line
    let g:pencil#autoformat = 0
augroup END

" Skim {{{2
" See https://github.com/lotabout/skim.vim
" Customize fzf colors to match your color scheme
let g:skim_colors =
            \ { 'fg':    ['fg', 'Normal'],
            \ 'bg':      ['bg', 'Normal'],
            \ 'hl':      ['fg', 'Comment'],
            \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+':     ['fg', 'Statement'],
            \ 'info':    ['fg', 'PreProc'],
            \ 'border':  ['fg', 'Ignore'],
            \ 'prompt':  ['fg', 'Conditional'],
            \ 'pointer': ['fg', 'Exception'],
            \ 'marker':  ['fg', 'Keyword'],
            \ 'spinner': ['fg', 'Label'],
            \ 'header':  ['fg', 'Comment'] }
" Enable per-command history.
" Use interactive ag and rg commands
command! -bang -nargs=* Rg call fzf#vim#rg_interactive(<q-args>, fzf#vim#with_preview('right:50%:hidden', 'alt-h'))
let $SKIM_DEFAULT_COMMAND = '(fd --type f || git ls-files -c -o --exclude-standard || rg -l "" || ag -l -g "" || find . -type f)'
"let $SKIM_DEFAULT_OPTIONS = '--bind ctrl-f:toggle,ctrl-p:up,ctrl-n:down,up:previous-history,down:next-history'

" replace Ctrl-p
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <leader>a :Buffers<CR>
nnoremap <silent> <leader>A :Windows<CR>
nnoremap <silent> <leader>; :BLines<CR>
nnoremap <silent> <leader>o :BTags<CR>
nnoremap <silent> <leader>O :Tags<CR>
nnoremap <silent> <leader>? :History<CR>
nnoremap <silent> <leader>/ :Rg<CR>

" Table mode {{{2
" Settings for vim-table-mode
let g:table_mode_corner="|" " markdown compatible tables by default
let g:table_mode_tableize_map = '<leader>tb'

" Tagbar {{{2
" Settings for tagbar.vim
let g:tagbar_singleclick = 1
let g:tagbar_autofocus = 1
nmap <leader>tt :TagbarToggle<CR>

" Markdown for tagbar.vim
let g:tagbar_type_markdown = {
    \ 'ctagstype' : 'markdown',
    \ 'kinds' : [
        \ 'h:headings',
        \ 'l:links',
        \ 'i:images'
    \ ],
    \ "sort" : 0
\ }

" Timestamp {{{2
let g:timestamp_regexp = '\v\C%(<[lL]ast %([cC]hanged?|[Mm]odified|[Uu]pdated):\s+)@<=.*$'
let g:timestamp_modelines = 50
let g:timestamp_rep = "%d/%m/%Y, %T %Z"

" Ultisnips {{{2
let g:ultisnips_python_style = "google"
let g:UltiSnipsSnippetDirectories=["UltiSnips", "snips"]

" Vim-clang {{{2
" Setup using a compilation database from build directory
let g:clang_compilation_database = './build'

" OmniSharp {{{2
let g:OmniSharp_server_stdio = 1
let g:OmniSharp_highlight_types = 1
let g:OmniSharp_selector_ui = 'ctrlp'
let g:OmniSharp_timeout = 5
augroup omnisharp_commands
    autocmd!

    " Show type information automatically when the cursor stops moving
    "autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

    " Update the highlighting whenever leaving insert mode
    autocmd InsertLeave *.cs call OmniSharp#HighlightBuffer()

    " Alternatively, use a mapping to refresh highlighting for the current buffer
    autocmd FileType cs nnoremap <buffer> <leader>th :OmniSharpHighlightTypes<CR>

    " The following commands are contextual, based on the cursor position.
    autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
    autocmd FileType cs nnoremap <buffer> <leader>fi :OmniSharpFindImplementations<CR>
    autocmd FileType cs nnoremap <buffer> <leader>fs :OmniSharpFindSymbol<CR>
    autocmd FileType cs nnoremap <buffer> <leader>fu :OmniSharpFindUsages<CR>

    " Finds members in the current buffer
    autocmd FileType cs nnoremap <buffer> <leader>fm :OmniSharpFindMembers<CR>

    autocmd FileType cs nnoremap <buffer> <leader>fx :OmniSharpFixUsings<CR>
    autocmd FileType cs nnoremap <buffer> <leader>tt :OmniSharpTypeLookup<CR>
    autocmd FileType cs nnoremap <buffer> <leader>dc :OmniSharpDocumentation<CR>
    autocmd FileType cs nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
    autocmd FileType cs inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>

    " Navigate up and down by method/property/field
    autocmd FileType cs nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
    autocmd FileType cs nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>
augroup END

" Contextual code actions (uses fzf, CtrlP or unite.vim when available)
nnoremap <leader><Space> :OmniSharpGetCodeActions<CR>
" Run code actions with text selected in visual mode to extract method
xnoremap <leader><Space> :call OmniSharp#GetCodeActions('visual')<CR>

" Rename with dialog
nnoremap <leader>nm :OmniSharpRename<CR>
nnoremap <F2> :OmniSharpRename<CR>
" Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

nnoremap <leader>cf :OmniSharpCodeFormat<CR>

" Start the omnisharp server for the current solution
nnoremap <leader>ss :OmniSharpStartServer<CR>
nnoremap <leader>sp :OmniSharpStopServer<CR>

" Enable snippet completion
let g:OmniSharp_want_snippet=1

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
:iab <expr> dts strftime(g:timestamp_rep)
inoremap <expr> <leader>ts strftime(g:timestamp_rep)

" Local machine dependent mods {{{1
"
if filereadable(expand(s:localFile))
    exe "source " . s:localFile
endif

" vim: foldmethod=marker
" EOF
