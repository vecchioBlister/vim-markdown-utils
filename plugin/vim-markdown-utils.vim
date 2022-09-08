" ================================================
" Filename: plugin/vim-markdown-utils
" Author: vecchioBlister
" License: GPLv3
" ================================================
" Copyright (C) 2021  vecchioBlister
"
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <https://www.gnu.org/licenses/>.

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

"nnoremap <leader>u1 :call MarkdownHeading(1)<cr>
"nnoremap <leader>u2 :call MarkdownHeading(2)<cr>
"nnoremap <leader>u3 :call MarkdownHeading(3)<cr>

" ================================================
" markdown table
function! MarkdownTable()
	normal! yypf|
		" create second line
	let position = col(".")
	let columns = 0
	normal! ?|<cr>
	normal! 0lvt|r-b
		" replace column text with '-'s
	while position < col("$") - 1
		normal! lvt|r-f|
		let position = col(".")
		let columns = columns + 1
	endwhile
	normal! ?|<cr>lvt|r-f|
	normal! o|
	while columns > 0
		" add third line
		normal! a|
		let columns = columns - 1
	endwhile
	normal! 0l
	startinsert
endfunction

"nnoremap <leader>tbl :call MarkdownTable()<cr>

" ================================================
" markdown emphasis
function! MarkdownEmphasis(enum)
	if col(".") != 1
		" check if the cursor is in the first col of the line
		normal! h
		if (matchstr(getline("."), '\%' . col(".") . 'c.') != ' ' && matchstr(getline("."), '\%' . col(".") . 'c.') != '	')
			" check if the cursor is on the first char of a word
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
	elseif a:enum == 3
		" strikethrough
		normal! i~~
		normal! ea~~
	endif
endfunction

"nnoremap <leader>iw :call MarkdownEmphasis(0)<cr>
"nnoremap <leader>bw :call MarkdownEmphasis(1)<cr>
"nnoremap <leader>sw :call MarkdownEmphasis(2)<cr>
"nnoremap <leader>stw :call MarkdownEmphasis(3)<cr>

" ================================================
" markdown footnote
function! MarkdownFootnote()
	if !exists("b:footnotes")
		" check if other footnotes exist in the same buffer
		let b:footnotes = 1
	endif
	if !exists("g:markdownfootnote_mark")
		let g:markdownfootnote_mark = "x"
	endif
	exe "normal! m" . g:markdownfootnote_mark
		" set marker to come back
	normal! A [^
	exe "normal! a" . b:footnotes . "\<esc>"
	normal! a]
	normal! Go
	if b:footnotes == 1
		" if it's the first footnote, add a line at EOF
		normal! o
	endif
	normal! a[^
	exe "normal! a" . b:footnotes . "\<esc>"
	normal! a]: 
	startinsert!
	let b:footnotes = b:footnotes + 1
endfunction

"nnoremap <leader>fn :call MarkdownFootnote()<cr>

" ================================================
" markdown footnote import
function! MarkdownFootnoteImport()
	normal! mz
		" set marker
	normal! G0
	if matchstr(getline("."), '\%' . col(".") . 'c.') == '['
		normal! l
		if matchstr(getline("."), '\%' . col(".") . 'c.') == '^'
			normal! t]
			let b:footnotes = matchstr(getline("."), '\%' . col(".") . 'c.') + 1
				" import lowest significant figure
			let figure = 1
			while matchstr(getline("."), '\%' . col(".") . 'c.') != '^'
				" import all other figures
				normal! h
				let figure = figure * 10
				let b:footnotes = b:footnotes + matchstr(getline("."), '\%' . col(".") . 'c.') * figure
			endwhile
			exe "echo \"Footnotes found: \"" b:footnotes - 1
			normal! `z
		else
			echo "No footnotes found! Make sure the latest is at the last line of the file."
		endif
	endif
endfunction

"nnoremap <leader>fi :call MarkdownFootnoteImport()<cr>

"augroup FootnoteAutoimport
"	" automatically call MarkdownFootnoteImport() on markdown files
"	autocmd!
"	autocmd FileType markdown call MarkdownFootnoteImport()
"augroup END

" ================================================
" swap lines
function! LineSwappie(direction)
	if a:direction == 0
		" left
		normal! <<
	elseif a:direction == 1
		" down
		normal! dd
		normal! p
	elseif a:direction == 2
		" up
		let current_line = line(".")
		normal! dd
		if current_line != line("$") + 1
			normal! k
		endif
		normal! P
	elseif a:direction == 3
		" right
		normal! >>
	endif
endfunction

"nnoremap <c-h> :call LineSwappie(0)<cr>
"nnoremap <c-j> :call LineSwappie(1)<cr>
"nnoremap <c-k> :call LineSwappie(2)<cr>
"nnoremap <c-l> :call LineSwappie(3)<cr>

" ================================================
" markdown task
function! MarkdownTask(done)
	normal! mz
		"set marker to come back
	normal! 0
	if matchstr(getline("."), '\%' . col(".") . 'c.') != '-'
		normal! f-
	endif
	if matchstr(getline("."), '\%' . col(".") . 'c.') != '-'
		let markeroffset = 2
		normal! i- 
		echo "This task wasn't in a list; automatically indented"
		normal! l
	else
		let markeroffset = 0
		normal! 2l
	endif
	if matchstr(getline("."), '\%' . col(".") . 'c.') != '['
		" if not a task, set it
		let markeroffset = markeroffset + 4
		normal! i[ ] 
		normal! 2h
	else
		normal! l
	endif
	if a:done == 0
		normal! r 
	else
		normal! rx
	endif
	normal! `z
	while markeroffset > 0
		normal! l
		let markeroffset = markeroffset - 1
		" go back to exact position
	endwhile
endfunction

function! DeleteMarkdownTask()
	normal! mz
		"set marker to come back
	normal! 0
	normal! t[
	normal! 4x
	normal! `z
	normal! 4h
endfunction

"nnoremap <leader>tt : call MarkdownTask(0)<cr>
"nnoremap <leader>td : call MarkdownTask(1)<cr>
"nnoremap <leader>dt : call DeleteMarkdownTask()<cr>
