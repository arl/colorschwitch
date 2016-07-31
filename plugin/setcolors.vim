" Change the color scheme from a list of color scheme names.
" Version 2010-09-12 from http://vim.wikia.com/wiki/VimTip341
" Version 2016-08-01 from http://github.com/aurelien-rainone/colorschwitch
"
" Define, in your .vimrc, the list of `switchable` color schemes, example:
" let g:colorschwitch_schemes = ['slate', 'torte', 'elflord', 'morning', 'koehler']
"
" Press key:
"   F7          next scheme
"   F6          previous scheme
"   Shift-F7    random scheme
" 
" Or use :SetColors as follows:
" Set the list of color schemes used by the above (default is 'all'):
"   :SetColors all              (all $VIMRUNTIME/colors/*.vim)
"   :SetColors my               (names built into script)
"   :SetColors blue slate ron   (these schemes)
"   :SetColors                  (display current scheme names)
" Set the current color scheme based on time of day:
"   :SetColors now

if v:version < 700 || exists('loaded_setcolors') || &cp
  finish
endif

let loaded_setcolors = 1

if !exists("g:colorschwitch_schemes")
    " empty list to loop through all installed colorschemes
    let g:colorschwitch_schemes = []
endif

" Set list of color scheme names that we will use, except
" argument 'now' actually changes the current color scheme.
function! s:SetColors(args)
  if len(a:args) == 0
    echo 'Current color scheme names:'
    let i = 0
    while i < len(g:colorschwitch_schemes)
      echo '  '.join(map(g:colorschwitch_schemes[i : i+4], 'printf("%-14s", v:val)'))
      let i += 5
    endwhile
  elseif a:args == 'all'
    let paths = split(globpath(&runtimepath, 'colors/*.vim'), "\n")
    let g:colorschwitch_schemes = map(paths, 'fnamemodify(v:val, ":t:r")')
    echo 'List of colors set from all installed color schemes'
  elseif a:args == 'my'
    let c1 = 'default elflord peachpuff desert256 breeze morning'
    let c2 = 'darkblue gothic aqua earth black_angus relaxedgreen'
    let c3 = 'darkblack freya motus impact less chocolateliquor'
    let g:colorschwitch_schemes = split(c1.' '.c2.' '.c3)
    echo 'List of colors set from built-in names'
  elseif a:args == 'now'
    call s:HourColor()
  else
    let g:colorschwitch_schemes = split(a:args)
    echo 'List of colors set from argument (space-separated names)'
  endif
endfunction

command! -nargs=* SetColors call s:SetColors('<args>')

" Set next/previous/random (how = 1/-1/0) color from our list of colors.
" The 'random' index is actually set from the current time in seconds.
" Global (no 's:') so can easily call from command line.
function! NextColor(how)
  call s:NextColor(a:how, 1)
endfunction

" Helper function for NextColor(), allows echoing of the color name to be
" disabled.
function! s:NextColor(how, echo_color)
  if len(g:colorschwitch_schemes) == 0
    call s:SetColors('all')
  endif
  if exists('g:colors_name')
    let current = index(g:colorschwitch_schemes, g:colors_name)
  else
    let current = -1
  endif
  let missing = []
  let how = a:how
  for i in range(len(g:colorschwitch_schemes))
    if how == 0
      let current = localtime() % len(g:colorschwitch_schemes)
      let how = 1  " in case random color does not exist
    else
      let current += how
      if !(0 <= current && current < len(g:colorschwitch_schemes))
        let current = (how>0 ? 0 : len(g:colorschwitch_schemes)-1)
      endif
    endif
    try
      execute 'colorscheme '.g:colorschwitch_schemes[current]
      break
    catch /E185:/
      call add(missing, g:colorschwitch_schemes[current])
    endtry
  endfor
  redraw
  if len(missing) > 0
    echo 'Error: colorscheme not found:' join(missing)
  endif
  if (a:echo_color)
    echo g:colors_name
  endif
endfunction

nnoremap <F7> :call NextColor(1)<CR>
nnoremap <F6> :call NextColor(-1)<CR>
nnoremap <S-F7> :call NextColor(0)<CR>

" Set color scheme according to current time of day.
function! s:HourColor()
  let hr = str2nr(strftime('%H'))
  if hr <= 3
    let i = 0
  elseif hr <= 7
    let i = 1
  elseif hr <= 14
    let i = 2
  elseif hr <= 18
    let i = 3
  else
    let i = 4
  endif
  let nowcolors = 'elflord morning desert evening pablo'
  execute 'colorscheme '.split(nowcolors)[i]
  redraw
  echo g:colors_name
endfunction
