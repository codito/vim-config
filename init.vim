" NVIM config file
" Created: Aug 2005 (see vimrc). Ported to neovim on 11/12/2021.
" Last Modified: 29/07/2024, 21:23:01 +0530

" Platform {{{1
"
" Local settings file, default to linux
let s:localFile = "~/.local.vim"
let s:pluginDir = "~/.vim/bundle"
let s:sessionDir = $HOME . "/.vim/sessions"
let s:snippetsDir = $HOME . "/.vim/snips"

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
    let s:sessionDir = $HOME . "/vimfiles/sessions"
    let s:snippetsDir = $HOME . "/vimfiles/snips"
    let g:skip_loading_mswin = 1    " don't need the shortcuts

    " `behave mswin` replace for nvim >=0.10
    set selection=exclusive
    set selectmode=mouse,key
    set mousemodel=popup
    set keymodel=startsel,stopsel
endif

" Plugins {{{1
"
function! PlugIf(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction
let s:platform = GetPlatform()

silent! if plug#begin(s:pluginDir)

Plug '3rd/image.nvim', PlugIf(GetPlatform() == 'nix', { 'for': 'markdown' })
Plug 'andythigpen/nvim-coverage'
Plug 'antoinemadec/FixCursorHold.nvim'      " for neotest
Plug 'brenoprata10/nvim-highlight-colors'
Plug 'david-kunz/gen.nvim'
Plug 'dhruvasagar/vim-table-mode', { 'for': 'markdown' }
Plug 'editorconfig/editorconfig-vim'
Plug 'ellisonleao/glow.nvim'
Plug 'folke/trouble.nvim'
Plug 'folke/twilight.nvim'
Plug 'folke/zen-mode.nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-emoji'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'issafalcon/neotest-dotnet'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'kdheepak/lazygit.nvim'
Plug 'konfekt/fastfold'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'l3mon4d3/luasnip'
Plug 'lewis6991/impatient.nvim'
Plug 'mattn/calendar-vim'
Plug 'mfussenegger/nvim-dap'
Plug 'neovim/nvim-lspconfig'
Plug 'numtostr/comment.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-neotest/neotest'
Plug 'nvim-neotest/neotest-python', { 'for': 'python' }
Plug 'nvim-neotest/nvim-nio'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'pocco81/DAPInstall.nvim'
Plug 'preservim/vim-pencil', { 'for': 'markdown' }
Plug 'preservim/vim-lexical', { 'for': 'markdown' }
Plug 'rafamadriz/friendly-snippets'
Plug 'romgrk/nvim-treesitter-context'
Plug 'ron89/thesaurus_query.vim'
Plug 'rouge8/neotest-rust', { 'for': 'rust' }
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'stevearc/aerial.nvim'
Plug 'stevearc/conform.nvim'
Plug 'tabbyml/vim-tabby', { 'on': 'Tabby' }
Plug 'thaerkh/vim-workspace'
Plug 'tweekmonster/startuptime.vim'
Plug 'uga-rosa/cmp-dictionary'
Plug 'vim-scripts/timestamp.vim'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

" Colors {{{2
"
Plug 'kepano/flexoki-neovim'
Plug 'sainnhe/gruvbox-material'

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

" Directories and files {{{2
set noautochdir                 " don't switch directory to current file
set isfname+=32                 " consider space as a valid filename char, useful for `gf`
if GetPlatform() == "win"
    set backupdir=~/vimfiles/tmp
    set directory=~/vimfiles/tmp
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
set textwidth=80            " break a line after 80 characters
set noequalalways           " for :split don't split space equally
"set winheight=99999 winminheight=0  " rolodex look for vim
set visualbell              " oh no beeps please!
set cursorline              " highlight the line our cursor is in
set signcolumn=no           " disabled/do not shift text when error message shows

" Ruler and status {{{2
set rulerformat=
set rulerformat+=%25(%)                             " 25 chars wide
set rulerformat+=%=
set rulerformat+=%(%Ll,%{\ wordcount().words}\w%)   " Lines and words
set rulerformat+=%=
set rulerformat+=%(\ %l,%c%V%)                      " Cursor line and char
set rulerformat+=%=
set rulerformat+=%P                                 " Pager

" Key mappings in general {{{2
nmap <silent><S-Tab> :tabnext<CR>
nnoremap <silent><C-F4> :bdelete<CR>

" Omnicomplete {{{2
" Automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,noinsert,noselect,preview
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

" GUI {{{2
if has("gui") || exists("nvy") || exists("GuiLoaded") || exists("g:neovide")
    "set guifont=Cascadia\ Code:h12
    "set guifont=Cascadia\ Code\ PL:h12
    "set guifont=Delugia:h12
    set guifont=Iosevka\ NFM:h14

    " enable Shift+Insert
    inoremap <silent>  <S-Insert>  <C-R>+
endif

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
au FileType markdown setlocal tw=80 et sw=2 sts=2 ts=2 nolist wrapmargin=0 ai formatoptions=tcroqn comments=n:> conceallevel=2 nofoldenable

" Text {{{2
"au BufRead,BufNewFile *.txt set filetype=txt
au FileType txt set tw=80 autoindent expandtab formatoptions=tawqn

" Typescript {{{2
au FileType typescript setlocal et sw=2 sts=2 ts=2 ai
au FileType typescriptreact setlocal et sw=2 sts=2 ts=2 ai


" XML {{{2
au FileType xml setlocal et sw=2 sts=2 ts=2 ai

" Misc {{{2
" Change the working directory to the directory containing the current file
"if has("autocmd")
  "autocmd BufEnter,BufRead,BufNewFile,BufFilePost * :lcd %:p:h
"endif " has("autocmd")

" Plugins {{{1
"

" Ctrl-p {{{2
" Ignore node_modules and bower_components
let g:ctrlp_custom_ignore = '\v[\/](\.(git|hg|svn)|node_modules|bower_components|bin|obj|dll|exe|lib)$'
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" Fugitive {{{2
nmap <leader>gs :Git<cr>
nmap <leader>gc :Git commit<cr>
nmap <leader>gp :Git push<cr>
nmap <leader>ga :Gwrite<cr>
nmap <leader>gl :Gclog<cr>
nmap <leader>gd :Gdiffsplit<cr>
nmap <leader>g2 :diffget //2<cr>
nmap <leader>g3 :diffget //3<cr>
nmap <leader>g0 :Gwrite!<cr>

" Fzf {{{2
" Customize fzf colors to match your color scheme
" - fzf#wrap translates this to a set of `--color` options
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
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

" replace Ctrl-p
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <leader>a :Buffers<CR>
nnoremap <silent> <leader>A :Windows<CR>
nnoremap <silent> <leader>; :BLines<CR>
nnoremap <silent> <leader>o :BTags<CR>
nnoremap <silent> <leader>O :Tags<CR>
nnoremap <silent> <leader>? :History<CR>
nnoremap <silent> <leader>/ :Rg<CR>

if executable("fd")
    let $FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
endif

" Glow {{{2
noremap <leader>p :Glow<CR>

" Gruvbox color {{{2
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_diagnostic_text_highlight = 1
let g:gruvbox_material_better_performance = 1
colorscheme gruvbox-material
" colorscheme flexoki-light

" Lexical {{{2
augroup lexical
    autocmd!
    autocmd FileType markdown call lexical#init()
augroup END

" Markdown {{{2
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_strikethrough = 1

" Netrw plugin {{{2
let g:netrw_browse_split=3  " all edits in new tab
if GetPlatform() != "win"
    let g:netrw_browsex_viewer="xdg-open"
endif

" nvim-tree {{{2
nmap <silent><F7> :NvimTreeToggle<cr>

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

" Table mode {{{2
" Settings for vim-table-mode
let g:table_mode_corner="|" " markdown compatible tables by default
let g:table_mode_tableize_map = '<leader>tb'

" Timestamp {{{2
let g:timestamp_regexp = '\v\C%(<[lL]ast %([cC]hanged?|[Mm]odified|[Uu]pdated):\s+)@<=.*$|TIMESTAMP'
let g:timestamp_modelines = 50
let g:timestamp_rep = "%d/%m/%Y, %T %z"

" Treesitter {{{2
" See lua/config.lua for configuration
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" Vim-workspace {{{2
let g:workspace_session_directory = s:sessionDir
let g:workspace_autosave_untrailspaces = 0
let g:workspace_persist_undo_history = 0
let g:workspace_autosave = 0    " disable autosave, it generates too much disk io

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
" Use for file timestamp updates or journal.
:iab <expr> dts strftime(g:timestamp_rep)
inoremap <expr> <leader>ts strftime(g:timestamp_rep)

" Timestamp for blog posts.
inoremap <expr> <leader>tb strftime("%Y-%m-%d %H:%M")

" Journal entries.
inoremap <expr> <leader>tj "[".strftime("%Y-%m-%d")."]"."(./journal/".strftime("%Y-%m-%d").".md)"

" Load lua based plugin configuration {{{1
" Setup local luarock packages
" Required for image.nvim for now
lua << EOF
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"
EOF

lua require("impatient")
lua require("config")

" Local machine dependent mods {{{1
"
if filereadable(expand(s:localFile))
    exe "source " . s:localFile
endif

" vim: foldmethod=marker fileformat=unix
" EOF
