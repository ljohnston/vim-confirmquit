# confirmquit.vim

Present the user with a confirmation prompt when quitting the last open Vim
window. This is particularly useful when running a GUI Vim, but can be
configured for terminal Vim as well.

I wrote this plugin because I oftentimes find myself bouncing back and forth
between terminal and GUI Vim sessions. When I've been in the terminal for a
while, doing a number of `:q`'s to quit Vim, that muscle memory seems to carry
over when I go back to my GUI vim, resulting in an unintended `:q` that quits
my GUI session where I may still have had many things in flight.

The core of the plugin is a function called `ConfirmQuit()` which is made
available to plugin users (i.e. it's not script scoped) who wish to add or
modify key assignments. `ConfirmQuit()` takes one parameter indicating whether
or not a write operation should be performed before quiting.

## Key Assignments

There are no key mappings created by the plugin. Rather, the plugin creates
`cabbrev`'s for the following keys by default:

- `q` - ConfirmQuit hook into `:q`
- `wq` - ConfirmQuit hook into `:wq`
- `x` - ConfirmQuit hook into `:x`

### Why `cabbrev` instead of key mappings?

Keys could be mappend via `c[nore]map`. This has a couple of drawbacks,
however:

- Possibly introducing a key delay on the mapped keys when used in a
  command.
- Taking effect in a non-Ex command mode. For example, if we mapped the
  following:

  ```
  cnoremap <silent> q<cr>  :call ConfirmQuit(0)<cr>
  ```
  ... searching for a string that ended in `q` (followed by a carriage
  return) would result in a search for the literal string 'call
  ConfirmQuit(0)', which is obviously an undesired side affect.

Using `cabbrev` as follows, solves both of these problems quite niceley.

    cabbrev q <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'silent call ConfirmQuit(0)' : 'q')<cr>

Note that `silent` in the above is not used for terminal Vim configuration as
the prompt would not appear.

## Configuration

The following configuration settings are provided:
```
" Enable confirmation prompting for GUI Vim (defaults to 1):
let g:confirmquit_gui = 1

" Enable confirmation prompting for terminal Vim (defaults to 0):
let g:confirmquit_gui = 1

" Do not create default cabbrev's for 'q', 'wq', and 'x'.
let g:confirmquit_no_cabbrevs = 1
```
