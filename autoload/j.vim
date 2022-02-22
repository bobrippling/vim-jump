" use 'switchbuf' to jump to an open buffer

function! j#j(bang, buf)
	let save = &switchbuf

	if a:bang
		set switchbuf=useopen,usetab
	else
		set switchbuf=useopen
	endif

	try
		execute 'sbuffer' a:buf
	finally
		let &switchbuf = save
	endtry
endfunction

function! j#complete(arglead, cmdline, cursorpos)
	let bang = 0
	for i in range(a:cursorpos - 1, 0, -1)
		let ch = a:cmdline[i]
		if ch ==# '!'
			let bang = 1
			break
		elseif stridx(':|', ch) >= 0
			break
		endif
	endfor

	if bang
		" all bufs
		let bufs = []
		for i in range(tabpagenr('$'))
			call extend(bufs, tabpagebuflist(i + 1))
		endfor
	else
		let bufs = tabpagebuflist()
	endif

	call map(bufs, { i, v -> bufname(v) })

	" rough emulation of the buffer matching that :b does
	let pat = glob2regpat('*' . a:arglead . '*')
	call filter(bufs, { i, v -> v =~ pat })

	return bufs
endfunction
