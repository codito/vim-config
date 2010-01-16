" Vim indent file
" Language: C#
" Maintainer: Arun <codito@codito.in>

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

" Use c like indent to start
" b0: break must align the other statements in case
" j1: align anonymous delegates properly
setlocal cindent cinoptions& cinoptions+=,b0,j1
setlocal indentexpr=GetCSIndent()

" Undo indent
let b:undo_indent = "setlocal cin< cinoptions< indentexpr<"

function! GetCSIndent()
    let this_line = getline(v:lnum)
    let prev_line_num = prevnonblank(v:lnum - 1)
    let prev_line = getline(prev_line_num)

    " Handle the custom attributes on methods.
    " Source: http://www.vim.org/scripts/script.php?script_id=1168
    if prev_line =~? '^\s*\[[A-Za-z]' && prev_line =~? '\]$'
        return indent(v:lnum - 1)
    endif

    " Align the #region and #endregion with normal indent level (instead of
    " aligning as preprocessor directives.
    if this_line =~ '^\s*#region'
        let next_line_num = nextnonblank(v:lnum + 1)
        return indent(next_line_num)
    endif

    if this_line =~ '^\s*#endregion'
        return indent(prev_line_num)
    endif

    " Fallback to c indent
    return cindent(v:lnum)
endfunction
