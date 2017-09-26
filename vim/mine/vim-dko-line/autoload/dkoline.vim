" autoload/dkoline.vim
scriptencoding utf-8

" let g:dkoline#refresh = 0
" let g:dkoline#trefresh = 0
" let g:dkoline#srefresh = 0

function! dkoline#GetTabline() abort
  "let g:dkoline#trefresh += 1
  let l:tabnr = tabpagenr()
  let l:winnr = tabpagewinnr(l:tabnr)
  let l:bufnr = winbufnr(l:winnr)
  let l:ww    = &columns
  let l:cwd   = has('nvim') ? getcwd(l:winnr) : getcwd()

  let l:x = {
        \   'bufnr': l:bufnr,
        \   'ww': 9999,
        \ }

  let l:contents = '%#StatusLine#'

  " ==========================================================================
  " Left side
  " ==========================================================================

  " Search context
  let l:contents .= dkoline#Format(dkoline#Anzu(),
        \ '%#Pmenu# ? %#PmenuSel#%#Search#')

  " ==========================================================================
  " Right side
  " ==========================================================================

  let l:contents .= '%#StatusLine# %= '

  let l:project_root = dko#ShortenPath(dkoproject#GetRoot(), 0)
  let l:maxwidth = float2nr(&columns / 2) - 5 - 6 - len(l:project_root)

  let l:contents .= dkoline#Format(
        \   dkoline#ShortPath(l:bufnr, l:cwd, 0),
        \   '%#Pmenu# ʟᴄᴅ %#PmenuSel#%0.' . l:maxwidth . '(',
        \   '%)'
        \ )

  let l:contents .= dkoline#Format(
        \ l:project_root,
        \ '%#Pmenu# ᴘʀᴏᴊ %#PmenuSel#')

  let l:contents .= dkoline#Format(
        \ dkoline#GitBranch(l:bufnr),
        \ '%#Pmenu# ʙʀᴀɴᴄʜ %#PmenuSel#')

  " ==========================================================================

  return l:contents
endfunction

" a:winnr from dkoline#Refresh() or 0 on set statusline
function! dkoline#GetStatusline(winnr) abort
  if empty(a:winnr) | return | endif
  " let g:dkoline#srefresh += 1

  let l:winnr = a:winnr > winnr('$') ? 1 : a:winnr
  let l:bufnr = winbufnr(l:winnr)
  let l:ww    = winwidth(l:winnr)
  let l:cwd   = has('nvim') ? getcwd(l:winnr) : getcwd()

  let l:x = {
        \   'bufnr': l:bufnr,
        \   'ww': l:ww,
        \ }

  let l:contents = ''

  " ==========================================================================
  " Left side
  " ==========================================================================

  let l:contents .= '%#TabLine# ' . dkoline#Mode(l:winnr)

  " Filebased
  let l:contents .= dkoline#Format(dkoline#Filetype(l:bufnr), '%#StatusLine#')
  let l:contents .= dkoline#Format(dkoline#Filename(l:bufnr, l:cwd), '%#PmenuSel#')
  let l:contents .= dkoline#Format(dkoline#Dirty(l:bufnr), '%#DiffAdded#')

  " Toggleable
  if !has('nvim')
    let l:contents .= dkoline#Format(dkoline#Paste(), '%#DiffText#')
  endif

  let l:contents .= dkoline#Format(dkoline#Readonly(l:bufnr), '%#Error#')

  " Function
  if get(g:, 'dkoline_enabled_functioninfo', 0)
    let l:contents .= dkoline#Format(
          \ dkoline#If({
          \   'winnr': l:winnr,
          \   'ww': 80,
          \ }, l:x) ? dkoline#FunctionInfo() : '',
          \ '%#PMenu# ғᴜɴᴄ %#PmenuSel#')
  endif

  " ==========================================================================
  " Right side
  " ==========================================================================

  let l:contents .= '%*%='

  " Tagging
  let l:contents .= dkoline#Format(
        \ dkoline#If({ 'winnr': l:winnr }, l:x) ? dkoline#GutentagsStatus() : '',
        \ '%#TermCursor#')

  " Linting
  let l:contents .= dkoline#Format(
        \ dkoline#Neomake('E', dkoline#NeomakeCounts(l:bufnr)),
        \ '%#NeomakeErrorSign#')

  let l:contents .= dkoline#Format(
        \ dkoline#Neomake('W', dkoline#NeomakeCounts(l:bufnr)),
        \ '%#NeomakeWarningSign#')

  let l:contents .= dkoline#Format(
        \ dkoline#If({ 'winnr': l:winnr }, l:x) ? dkoline#NeomakeRunning(l:bufnr) : '',
        \ '%#DiffText#')

  let l:contents .= '%<'

  let l:contents .= dkoline#Format(
        \ dkoline#If({ 'winnr': l:winnr }, l:x) ? dkoline#Ruler() : '',
        \ '%#TabLine#')

  return l:contents
endfunction

" ============================================================================
" Output functions
" ============================================================================

" @param {String} content
" @param {String} [before]
" @param {String} [after]
" @return {String}
function! dkoline#Format(...) abort
  let l:content = get(a:, 1, '')
  let l:before = get(a:, 2, '')
  let l:after = get(a:, 3, '')
  return empty(l:content) ? '' : l:before . l:content . l:after
endfunction

function! dkoline#If(conditions, values) abort
  if has_key(a:conditions, 'winnr')
    if winnr() != a:conditions.winnr | return 0 | endif
  endif

  if has_key(a:conditions, 'ww')
    if a:values.ww < a:conditions.ww | return 0 | endif
  endif

  return 1
endfunction

" @return {String}
function! dkoline#Mode(winnr) abort
  " blacklist
  let l:modecolor = '%#TabLine#'

  let l:modeflag = mode()
  if a:winnr != winnr()
    let l:modeflag = ' '
  elseif l:modeflag ==# 'i'
    let l:modecolor = '%#PmenuSel#'
  elseif l:modeflag ==# 'R'
    let l:modecolor = '%#DiffDelete#'
  elseif l:modeflag =~? 'v'
    let l:modecolor = '%#Cursor#'
  elseif l:modeflag ==? "\<C-v>"
    let l:modecolor = '%#Cursor#'
    let l:modeflag = 'B'
  endif
  return  l:modecolor . ' ' . l:modeflag . ' '
endfunction

" @return {String}
function! dkoline#Paste() abort
  return empty(&paste)
        \ ? ''
        \ : ' ᴘ '
endfunction

" @param {String} key
" @param {Dict} counts
" @return {String}
function! dkoline#Neomake(key, counts) abort
  let l:e = get(a:counts, a:key, 0)
  return l:e ? ' ⚑' . l:e . ' ' : ''
endfunction

" @param {Int} bufnr
" @return {String}
function! dkoline#NeomakeCounts(bufnr) abort
  return !exists('*neomake#statusline#LoclistCounts')
        \ ? {}
        \ : neomake#statusline#LoclistCounts(a:bufnr)
endfunction

" @param {Int} bufnr
" @return {String}
function! dkoline#NeomakeRunning(bufnr) abort
  return !dko#IsLoaded('neomake')
        \ || !exists('*neomake#GetJobs')
        \ || empty(neomake#GetJobs())
        \ ? ''
        \ : ' ᴍᴀᴋᴇ:' . dkoline#NeomakeRunningJobs(a:bufnr) . ' '
endfunction

" @param {Int} bufnr
" @return {String} comma-delimited running job names
function! dkoline#NeomakeRunningJobs(bufnr) abort
  let l:running_jobs = filter(copy(neomake#GetJobs()),
        \ "v:val.bufnr == a:bufnr && !get(v:val, 'canceled', 0)")
  let l:names = map(l:running_jobs, 'v:val.name')
  return join(l:names, ', ')
endfunction

" @param {Int} bufnr
" @return {String}
function! dkoline#Readonly(bufnr) abort
  return getbufvar(a:bufnr, '&readonly') ? ' ʀ ' : ''
endfunction

" @param {Int} bufnr
" @return {String}
function! dkoline#Filetype(bufnr) abort
  let l:ft = getbufvar(a:bufnr, '&filetype')
  return empty(l:ft)
        \ ? ''
        \ : ' ' . l:ft . ' '
endfunction

" Filename of buffer relative to the path, or just the helpfile name if it is
" a help file
"
" @param {Int} bufnr
" @param {String} path
" @return {String}
function! dkoline#Filename(bufnr, path) abort
  if dko#IsNonFile(a:bufnr)
    return ''
  endif

  let l:filename = bufname(a:bufnr)
  if empty(l:filename)
    let l:contents = '[No Name]'
  else
    let l:contents = dko#IsHelp(a:bufnr)
          \ ? '%t'
          \ : fnamemodify(substitute(l:filename, a:path, '.', ''), ':~:.')
  endif

  return ' ' . l:contents . ' '
endfunction

" @param {Int} bufnr
" @return {String}
function! dkoline#Dirty(bufnr) abort
  return getbufvar(a:bufnr, '&modified') ? ' + ' : ''
endfunction

" @return {String}
function! dkoline#Anzu() abort
  if !exists('*anzu#search_status')
    return ''
  endif

  let l:anzu = anzu#search_status()
  return empty(l:anzu)
        \ ? ''
        \ : ' %{anzu#search_status()} '
endfunction

" Use dko#ShortenPath conditionally
"
" @param {Int} bufnr
" @param {String} path
" @param {Int} max
" @return {String}
function! dkoline#ShortPath(bufnr, path, max) abort
  if dko#IsNonFile(a:bufnr) || dko#IsHelp(a:bufnr)
    return ''
  endif
  let l:path = dko#ShortenPath(a:path, a:max)
  return empty(l:path)
        \ ? ''
        \ : l:path
endfunction

" Uses fugitive or gita to get cached branch name
"
" @param {Int} bufnr
" @return {String}
function! dkoline#GitBranch(bufnr) abort
  return dko#IsNonFile(a:bufnr)
        \ || dko#IsHelp(a:bufnr)
        \ ? ''
        \ : exists('*fugitive#head')
        \   ? ' ' . fugitive#head(7) . ' '
        \   : exists('g:gita#debug')
        \     ? gita#statusline#format('%lb')
        \     : ''
endfunction

" @return {String}
function! dkoline#FunctionInfo() abort
  let l:funcinfo = dkocode#GetFunctionInfo()
  return empty(l:funcinfo.name)
        \ ? ''
        \ : ' ' . l:funcinfo.name . ' '
endfunction

" @return {String}
function! dkoline#GutentagsStatus() abort
  if !exists('g:loaded_gutentags')
    return ''
  endif

  let l:tagger = substitute(gutentags#statusline(''), '\[\(.*\)\]', '\1', '')
  return empty(l:tagger)
        \ ? ''
        \ : ' ᴛᴀɢ:' . l:tagger . ' '
endfunction

" @return {String}
function! dkoline#Ruler() abort
  return ' %5.(%c%) '
endfunction

" ============================================================================
" Utility
" ============================================================================

function! dkoline#Init() abort
  set statusline=%!dkoline#GetStatusline(1)

  call dkoline#RefreshTabline()
  set showtabline=2

  let l:refresh_hooks = [
        \   'BufEnter',
        \ ]
        " \   'BufWinEnter',
        " \   'SessionLoadPost',
        " \   'TabEnter',
        " \   'VimResized',
        " \   'WinEnter',
        " \   'FileType',
        " \   'FileWritePost',
        " \   'FileReadPost',
        " \   'BufEnter' for different buffer
        " \   'CursorMoved' is for updating anzu search status accurately,
        "     using Plug mapping instead.

  let l:user_refresh_hooks = [
        \   'GutentagsUpdated',
        \   'NeomakeFinished',
        \ ]
  " 'NeomakeCountsChanged',

  if !empty(l:refresh_hooks)
    execute 'autocmd plugin-dkoline ' . join(l:refresh_hooks, ',') . ' *'
          \ . ' call dkoline#RefreshStatus()'
  endif
  if !empty(l:user_refresh_hooks)
    execute 'autocmd plugin-dkoline User ' . join(l:user_refresh_hooks, ',')
          \ . ' call dkoline#RefreshStatus()'
  endif
endfunction

function! dkoline#RefreshStatus() abort
  " let g:dkoline#refresh += 1
  for l:winnr in range(1, winnr('$'))
    let l:fn = '%!dkoline#GetStatusline(' . l:winnr . ')'
    call setwinvar(l:winnr, '&statusline', l:fn)
  endfor
endfunction

function! dkoline#RefreshTabline() abort
  set tabline=%!dkoline#GetTabline()
endfunction

" bound to <F11> - see ../plugin/mappings.vim
function! dkoline#ToggleTabline() abort
  let &showtabline = &showtabline ? 0 : 2
endfunction