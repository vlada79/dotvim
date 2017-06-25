" Language:	Genesis map file


" Function:     GmapLeaveMarkInJumplist
" Description:  leave entry in jumplist for given position
" Argument:     a:pos - position to mark
function! GmapLeaveMarkInJumplist(pos)
  let l:newpos = getpos('.')
  call setpos('.', a:pos)
  execute 'normal m'''
  call setpos('.', l:newpos)
endfunction

" Function:     GmapCurrentSection
" Description:  identify current section in map file
" Returns:      name of current section
"               ie 'gmapRoomSection' or 'gmapAsciiSection'
function! GmapCurrentSection()
  let l:synids = synstack(line('.'), col('.'))

  if len(l:synids) > 0
    return synIDattr(l:synids[1], 'name')
  else
    return ''
  end
endfunction

" Function:     GmapSyntaxItem
" Description:  identify current syntax item 
"               (top of the syntax stack)
" Returns:      name of current element ie 'gmapRoomName'
function! GmapSyntaxItem()
  let l:synids = synstack(line('.'), col('.'))

  if len(l:synids) > 0
    return synIDattr(l:synids[-1], 'name')
  else
    return ''
  endif
endfunction


" Function:     GmapToAscii
" Description:  move from room section to room on ascii map
" Return:       0/1 - if movement was successful
function! GmapToAscii()
  if GmapCurrentSection() != 'gmapRoomSection'
    return 0
  endif

  let l:words = split(getline('.'), ' ')
  if ( len(l:words) < 3 )
    return
  endif

  let l:pos = getpos('.')
  let l:file = l:words[0]
  let l:col = l:words[1]
  let l:row = l:words[2]

  if l:row == 0 || l:col == 0
    return 0
  end
  
  call search('^::MAPDATA')

  execute 'normal ' . (l:row + 1) . 'j'
  execute 'normal ' . (l:col + 0) . 'l'
  call GmapLeaveMarkInJumplist(l:pos)
  
  return 1
endfunction

" Function:     GmapToRoom
" Description:  move from ascii map to entry in room section
" Return:       0/1 - if movement was successful
function! GmapToRoom()
  if GmapCurrentSection() != 'gmapAsciiSection'
    return 0
  endif

  let l:pos = getpos('.')

  let l:row = line('.')
  let l:col = col('.')
  let l:line = search('^::MAPDATA::', 'bn')
  let l:row = l:row - l:line - 1
  let l:col = l:col - 1

  let l:coord_pattern = '^\f\+\s\+' . l:col . '\s\+' . l:row . '\>'
  let l:res = searchpair('^::MAPDATA::', l:coord_pattern, '^::MAPDATA::', 'bn')
  let l:moved = search(l:coord_pattern)

  if l:moved
    " Move to coord section
    execute 'normal f l' 
    call GmapLeaveMarkInJumplist(l:pos)
  endif
  
  return (l:moved != 0)
endfunction

" Function:     GmapToSubMap
" Description:  jump to submap under cursor
" Return:       1/0 - jump was successful or not
function! GmapToSubMap()
  if GmapSyntaxItem() != 'gmapMapRef'
    return 0
  endif

  let l:pos = getpos('.')

  let l:subMap = '^' . expand('<cword>') . '\s*$'
  let l:moved = search(l:subMap)

  if l:moved
    call GmapLeaveMarkInJumplist(l:pos)
  endif
  
  return l:moved != 0
endfunction



" Function:     GmapAddRoom
" Description:  add room entry for given position in ascii map
" Return:       0/1 - if new entry was successfuly created
function! GmapAddRoom()
  if GmapCurrentSection() != 'gmapAsciiSection'
    return 0
  endif

  let l:row = line('.')
  let l:col = col('.')
  let l:line = search('^::MAPDATA::', 'bn')

  if ( l:line <= 0 )
    return 0
  endif

  let l:row = l:row - l:line - 1
  let l:col = l:col - 1

  let l:text = 'newroom ' . l:col . ' ' . l:row
  call search('^::MAPDATA::', 'b')
  execute 'normal O' . l:text
  execute 'normal ^'
  return 1
endfunction

" Function:     GmapOpenRoomSourceFile
" Description:  open a file in room section list
" Return:       1/0 - file has been opened or not
function! GmapOpenRoomSourceFile()
  let l:pos = getpos('.')
  if GmapToRoom()
    execute 'normal ^'
  endif

  if GmapSyntaxItem() != 'gmapRoomName'
    return 0
  endif

  let l:room = expand('<cword>')
  let l:dir = expand('%:p:h')
  let l:path = l:dir . '/' . fnameescape(l:room) . '.c'

  call setpos('.', l:pos)
  execute 'normal m'''
  execute 'edit ' . l:path
  return 1
endfunction

function! GmapCompareCoords(a, b)
  if a:a[1] != a:b[1]
    return a:b[1] - a:a[1]
  else
    return a:b[0] - a:a[0]
  end
endfunction

function! GmapGetRoomCoords()
  if GmapCurrentSection() != 'gmapAsciiSection'
    return 0
  endif

  let l:pos = getpos('.')
  let l:section_end = search('^::MAPDATA::$', 'b')
  let l:section_start = search('^::MAPDATA::$', 'b')

  let l:lines = getline(l:section_start+1, l:section_end-1)

  let l:coords = []
  for l:line in l:lines
    let l:words = split(l:line)
    if len(l:words) >= 3
      let l:coords += [ [l:words[1] + 1, l:words[2] + l:section_end + 1] ]
    endif
  endfor

  call setpos('.', l:pos)

  call sort(l:coords, 'GmapCompareCoords')

  return l:coords
endfunction

function! GmapNextRoom()
  if GmapCurrentSection() != 'gmapAsciiSection'
    return 0
  endif

  let l:row = line('.')
  let l:col = col('.')

  let l:coords = GmapGetRoomCoords()
  let l:i = len(l:coords) - 1

  while l:i >= 0 &&
        \ ( l:row >  l:coords[i][1] ||
        \   ( l:row == l:coords[i][1] && 
        \     l:col >= l:coords[i][0] )
        \ )
    let l:i -= 1
  endwhile

  if l:i == -1
    let l:i = len(l:coords) - 1
  endif

  execute 'normal ' . l:coords[i][1] . 'G' . l:coords[i][0] . '|'
endfunction

function! GmapPrevRoom()
  if GmapCurrentSection() != 'gmapAsciiSection'
    return 0
  endif

  let l:row = line('.')
  let l:col = col('.')

  let l:coords = GmapGetRoomCoords()
  let l:i = 0

  while l:i < len(l:coords) && 
        \ ( l:row <  l:coords[i][1] ||
        \   ( l:row == l:coords[i][1] && 
        \     l:col <= l:coords[i][0] )
        \ )

    let l:i += 1
  endwhile

  if len(l:coords) == l:i
    let l:i = 0
  endif

  execute 'normal ' . l:coords[i][1] . 'G' . l:coords[i][0] . '|'
endfunction

" Function:     GmapJump
" Description:  smart jump, does different things based on context
" Return:       1/0 - jump was performed or not
function! GmapJump()
  let l:item = GmapSyntaxItem()
  let l:section = GmapCurrentSection()

  if l:item == 'gmapRoomName'
    return GmapOpenRoomSourceFile()
  elseif l:item == 'gmapMapRef'
    return GmapToSubMap()
  elseif l:section == 'gmapRoomSection'
    return GmapToAscii()
  elseif l:section == 'gmapAsciiSection'
    return GmapToRoom()
  endif

  return 0
endfunction

" Key remaps
nnoremap <silent> <buffer> <leader>j :call GmapJump()<CR>
nnoremap <silent> <buffer> <leader>l :call GmapToRoom()<CR>
nnoremap <silent> <buffer> <leader>a :call GmapToAscii()<CR>
nnoremap <silent> <buffer> <leader>n :call GmapAddRoom()<CR>
nnoremap <silent> <buffer> gf :call GmapOpenRoomSourceFile()<CR>

nnoremap <silent> <buffer> <leader>t :call GmapGetRoomList()<CR>
nnoremap <silent> <buffer> <Tab> :call GmapNextRoom()<CR>
nnoremap <silent> <buffer> <S-Tab> :call GmapPrevRoom()<CR>

setlocal foldmethod=syntax
setlocal foldlevel=0
