" ================================================
" Filename: plugin/vim-markdown-utils
" Author: LionSpeck
" License: GPLv3
" ================================================
" Copyright (C) 2021  LionSpeck
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

nnoremap <leader>u1 :call MarkdownHeading(1)<cr>
nnoremap <leader>u2 :call MarkdownHeading(2)<cr>
nnoremap <leader>u3 :call MarkdownHeading(3)<cr>

" ================================================
" markdown table
function! MarkdownTable()
	normal! yypf|
	let position = col(".")
	let columns = 0
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

" ================================================
" markdown italic, bold, strong, strikethrough
function! MarkdownEmphasis(enum)
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
	elseif a:enum == 3
		" strikethrough
		normal! i~~
		normal! ea~~
	endif
endfunction

nnoremap <leader>iw :call MarkdownEmphasis(0)<cr>
nnoremap <leader>bw :call MarkdownEmphasis(1)<cr>
nnoremap <leader>sw :call MarkdownEmphasis(2)<cr>
nnoremap <leader>stw :call MarkdownEmphasis(3)<cr>

" ================================================
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

nnoremap <c-h> :call LineSwappie(0)<cr>
nnoremap <c-j> :call LineSwappie(1)<cr>
nnoremap <c-k> :call LineSwappie(2)<cr>
nnoremap <c-l> :call LineSwappie(3)<cr>

" ================================================
" markdown task
function! MarkdownTask(done)
	normal! mz
		"set marker to come back
	normal! 0f-
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
		" go back to marker
	endwhile
endfunction

nnoremap <leader>tt : call MarkdownTask(0)<cr>
nnoremap <leader>td : call MarkdownTask(1)<cr>
