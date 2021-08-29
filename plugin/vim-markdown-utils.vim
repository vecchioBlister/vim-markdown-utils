" ================================================
" Filename: plugin/vim-markdown-utils
" Author: LionSpeck
" License: GPLv3
" ================================================

" markdown heading
function! MarkdownHeading(level)
	if a:level == 1
		normal! yypVr=
	elseif a:level == 2
		normal! yypVr-
	else
		normal! I### 
	endif
endfunction

nnoremap <leader>u1 :call MarkdownHeading(1)<cr>
nnoremap <leader>u2 :call MarkdownHeading(2)<cr>
nnoremap <leader>u3 :call MarkdownHeading(3)<cr>

" markdown table
function! MarkdownTable()
	normal! yypf|
	let position = col(".")
	let columns = 1
	normal! ?|<cr>
	normal! 0lvt|r-b
	while position < col("$") - 1
		normal! lvt|r-f|
		let position = col(".")
		let columns = columns + 1
	endwhile
	normal! ?|<cr>lvt|r-f|
	normal! o|
	while columns > 0
		normal! a|
		let columns = columns - 1
	endwhile
	normal! 0l
	startinsert
endfunction

nnoremap <leader>tbl :call MarkdownTable()<cr>

" markdown italic, bold, strong
function! MarkdownItalic(enum)
	if col(".") != 1
		normal! h
		if matchstr(getline("."), '\%' . col(".") . 'c.') != ' '
			normal! lb
		else
			normal! l
		endif
	endif
	if a:enum == 0
		" italic
		normal! i*
		normal! ea*
	elseif a:enum == 1
		" bold
		normal! i**
		normal! ea**
	elseif a:enum == 2
		" strong
		normal! i***
		normal! ea***
	endif
endfunction

nnoremap <leader>iw :call MarkdownItalic(0)<cr>
nnoremap <leader>bw :call MarkdownItalic(1)<cr>
nnoremap <leader>sw :call MarkdownItalic(2)<cr>

" markdown footnote
function! MarkdownFootnote()
	if !exists("b:footnotes")
		" check if other footnotes exist in the same buffer
		let b:footnotes = 1
	endif
	if !exists("g:markdownfootnote_mark")
		let g:markdownfootnote_mark = "n"
	endif
	exe "normal! m" . g:markdownfootnote_mark
		" set marker to come back
	normal! A [^
	exe "normal! a" . b:footnotes . "\<esc>"
	normal! a]
	normal! Go
	if b:footnotes == 1
		normal! o
	endif
	normal! a[^
	exe "normal! a" . b:footnotes . "\<esc>"
	normal! a]: 
	startinsert!
	let b:footnotes = b:footnotes + 1
endfunction

nnoremap <leader>fn :call MarkdownFootnote()<cr>
