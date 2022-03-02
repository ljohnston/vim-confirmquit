
if exists("g:loaded_confirmquit") || &cp || v:version < 700
  finish
endif
let g:loaded_confirmquit = 1

let s:gui      = get(g:, 'confirmquit_gui', 1)
let s:terminal = get(g:, 'confirmquit_terminal', 0)

if !s:gui && !s:terminal
    finish
elseif has("gui_running") && !s:gui
    finish
elseif !has("gui_running") && !s:terminal
    finish
endif

function! ConfirmQuit(writeFile)

    if (a:writeFile)
        if (expand("%")=="")
            echo "Can't save a file with no name."
            return
        endif
        write
    endif

    " Completely quiting means quiting the last open window.
    if (winnr('$') > 1 || tabpagenr('$') > 1)
        quit
    elseif (confirm("Are you sure you want to quit?", "&Yes\n&No", 2)==1)
        quit
    endif
endfun

if get(g:, 'confirmquit_no_cabbrevs', 0)
    finish
endif

if has("gui_running")
    cabbrev q  <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'silent call ConfirmQuit(0)' : 'q')<cr>
    cabbrev wq <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'silent call ConfirmQuit(1)' : 'wq')<cr>
    cabbrev x  <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'silent call ConfirmQuit(1)' : 'x')<cr>
else
    cabbrev q  <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'call ConfirmQuit(0)' : 'q')<cr>
    cabbrev wq <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'call ConfirmQuit(1)' : 'wq')<cr>
    cabbrev x  <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'call ConfirmQuit(1)' : 'x')<cr>
endif
