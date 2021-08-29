vim-markdown-utils
==================

A small collection of functions for markdown syntax.


MarkdownHeading(level)
----------------------

Make the current line a heading.
Supported levels 1~3.

Example:

![heading_example](images/heading.png)

Keybinds:
```
<leader>u1
<leader>u2
<leader>u3
```


MarkdownTable()
---------------

Create the second-line for a table using the current line as header.
It creates the third (empty) line as well, just with the columns separators, ready to punch-in your data.

Example:

![table_example](images/table.png)

Keybind:
```
<leader>tbl
```


MarkdownItalic(enum)
--------------------

Set the current word to *italic*, **bold** or ***strong***.

Keybinds:
```
<leader>iw
<leader>bw
<leader>sw
```


MarkdownFootnote()
------------------

Add a footnote to the current line, then start editing.
It also saves a mark ("n" is default), to jump back to the previous line. You can also press `^o` / `C-o`, but (as per vim's default functionality), you will just jump back to the line, not the exact point.

Example:

![footnote_example](images/footnote.png)

Keybind:
```
<leader>fn
```

Change mark letter:
```
let g:markdownfootnote_mark = "x"
```

to whatever you prefer, by adding this to your .vimrc.


### Known bugs:

- MarkdownFootnote() 's current footnote number can reset.
	- It tracks the number of footnotes with a buffer-scoped variable; if the buffer is unloaded, or footnotes existed already before opening it, the newly added ones will start from 1.
	- To patch this, you can type the command `:let b:footnotes = N`, replacing `N` with the **footnote you want next**.
- MarkdownFootnote() 's global variable for the default mark doesn't work properly.
