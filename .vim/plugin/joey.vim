:let joeymods = ""

:let Tmenu_ctags_cmd = "/usr/bin/ctags-exuberant"
:let Tlist_Ctags_Cmd = "/usr/bin/ctags-exuberant"
" :let Tlist_Display_Prototype = 1
:let Jlist_Ctags_Cmd = "/usr/bin/ctags-exuberant"
:let Tlist_Well_Spaced = 1
:let Tlist_Fold_Tags = 1
:let Tlist_Fold_Tagtypes = 1
:filetype on

" Doesn't work if it comes after the :so's
:set hlsearch

" :set titlestring="hello"
" :set title



" :so ~/.vim/joey/joeykeymap.vim
" Causes nasty slowdown on tex!
" :so /home/joey/.vim/joey/joeysyntax.vim
" For some reason, syn on cancels folding wherever it is!
:syn on
" :so /home/joey/.vim/joey/joeyfolding.vim
" No point: always cleared unless we source after syntax.
" :so /home/joey/.vim/joey/joeyhighlight.vim

:set autoindent
" :set cindent
:set nowrap
" :set wrap
" :set background=dark

:set incsearch
" :set wrapmargin=8
:set shiftwidth=3
:set ts=3
:set list
" :set listchars=tab:::,trail:$
" :set listchars=tab:>\ ,trail:$
" :set listchars=tab:-\ ,trail:$
" :set listchars=tab:\|\ ,trail:$
" :set listchars=tab:\\_,trail:$
" :set listchars=tab:\|-,trail:$
:set listchars=tab:\>-,trail:$
:highlight SpecialKey ctermfg=DarkGrey cterm=bold guifg=#606060
" :set expandtab
":set noautoindent
":set nocindent
:set mouse=a

" I hope you never need to type a �, because I've remapped it to leave ins mode!
inoremap � <esc>


" This is very nice but I am just testing word_complete

" Tab expands if over a word, otherwise normal tab.
" function! InsertTabWrapper()
	" let col = col('.') - 1
	" if !col || getline('.')[col - 1] !~ '\k'
	" return "\<tab>"
	" else
	" return "\<c-p>"
	" endif
" endfunction 
" inoremap <tab> <c-r>=InsertTabWrapper()<cr>




" Make these work for modifiable only - they seriously warp the online help!
":autocmd BufReadPost   *.* set ts=8 | set expandtab | retab | set ts=2 | set noexpandtab | retab!
":autocmd BufWritePre,FilterWritePre     *.* set expandtab | retab!



" <Leader> defaults to "\", I use ","
" let mapleader = ","

:nmap <Leader>/ :call MyRepeatedSearch()<CR>

:fun! MyRepeatedSearch()
	if @/ != "" && search(@/, 'W') == 0
		n
		call MyRepeatedSearch()
	endif
endfun





" This needs fixing!

" Set this variable to a nonzero value if you want to rewind the
" argument list if there was no match in the last (or first) buffer:
let SearchBuffersRewind = 0

" Set this variable to specify which buffers to search.
" Possible values:
"       ""      argument list (default)
"       "b"     buffer list
"       "w"     window list
let SearchBuffersList = ""


" Search for the last search pattern (register /)
" The direction of the last search (? or /) is ignored.
map <Leader>n :call SearchBuffers(@/, "n")<Return>
map <Leader>N :call SearchBuffers(@/, "N")<Return>

" Search through buffers for a specified pattern, either forward
" or backwards ("n" and "N" respectively).
" Global variables are check for which list of buffers to search
" and whether we should rewind the list after the last buffer. See
" below for details.
" Return codes:
"       0       match was found
"       1       no match was found
"       2       an error occured
" Todo: May fail if the match is on the first character of a buffer.
"       With the args list, we may end prematurely if the first buffer
"       is not in the list.
fun! SearchBuffers(pat, direction)
	" On nonzero value here, we rewind the argument/buffer/window
	" list after the last argument/buffer/window
	let rewind = 0
	if exists("g:SearchBuffersRewind")
		let rewind = g:SearchBuffersRewind
	endif

	" Which list to search, "" means args, "b" buffers and "w" windows
	let list = ""
	if exists("g:SearchBuffersList")
		let list = g:SearchBuffersList[0]
		fi
		if list !~ '^[bw]\=$'
			echoerr "First letter, if any, of g:SearchBuffersList must be 'b' or 'w'"
			return 2
		endif

		" Quick hack to get the number of the last window
		let lastwin = 1
		while winheight(lastwin + 1) != -1
			let lastwin = lastwin + 1
		endwhile

		" Search backwards in buffer with "N"
		" This does not take honour the direction of the last search (/ or ?)
		" Also, set the direction we search buffers
		if a:direction == "N"
			let flags = "bW"
			if list == "w"
				let nextcmd = "wincmd k"
				let rewcmd = lastwin . "wincmd w"
			else
				let nextcmd = "silent " . list . "previous"
				let rewcmd = "last"
			endif
		else
			let flags = "W"
			if list == "w"
				let nextcmd = "wincmd j"
				let rewcmd = "1wincmd w"
			else
				let nextcmd = "silent " . list . "next"
				let rewcmd = "rewind"
			endif
		endif

		" Break points when we rewind on the last buffer/window
		let origbufnr = bufnr("%")
		let origwinnr = winnr()
		let didrewind = 0

		" Use these to test if we changed buffer -- avoids duplicated code
		if list == "w"
			let testbuf = 'let samebuf = (winnr == winnr())'
			let testorigbuf = 'let sameorigbuf = (origwinnr == winnr())'
		else
			let testbuf = 'let samebuf = (bufnr == bufnr("%"))'
			let testorigbuf = 'let sameorigbuf = (origbufnr == bufnr("%"))'
		endif

		" Break this loop as appropriate; here we can just return.
		while 1 == 1
			" Just use the buffer/window number to check if nextcmd failed
			let bufnr = bufnr("%")
			let winnr = winnr()

			" search() returns zero when no match is found
			if search(a:pat, flags) != 0
				return 0
			else
				exec nextcmd
				exec testbuf
				if samebuf
					if rewind == 0
						return 1
					else
						if didrewind != 0
							return 1
						endif
						exec rewcmd
						let didrewind = 1
						" And now we have to check again...
						exec testbuf
						exec testorigbuf
						if samebuf || sameorigbuf
							return 1
						endif
					endif
				endif
				" Move the cursor to the top of the buffer
				1
				norm 0
			endif
		endwhile
	endfun
