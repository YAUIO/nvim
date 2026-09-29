# Nano-like Neovim Cheat Sheet

## Nano-style editing

| Key     | Action       |
| ------- | ------------ |
| Ctrl+O  | Save         |
| Ctrl+X  | Exit         |
| Ctrl+K  | Cut line     |
| Ctrl+U  | Paste        |
| Ctrl+W  | Search       |
| Alt+U   | Undo         |
| Alt+E   | Redo         |
| Ctrl+G  | Help         |
| Ctrl+\_ | Comment line |

## Basic Neovim

| Key    | Action              |
| ------ | ------------------- |
| i      | Insert mode         |
| Esc    | Normal mode         |
| a      | Insert after cursor |
| o      | New line below      |
| O      | New line above      |
| x      | Delete character    |
| dd     | Delete/cut line     |
| yy     | Copy line           |
| p      | Paste               |
| u      | Undo                |
| Ctrl+R | Redo                |
| gg     | Top of file         |
| G      | Bottom of file      |
| 0      | Start of line       |
| $      | End of line         |

## Navigation

| Key    | Action         |
| ------ | -------------- |
| h      | Left           |
| j      | Down           |
| k      | Up             |
| l      | Right          |
| Ctrl+D | Half page down |
| Ctrl+U | Half page up   |
| Ctrl+F | Page down      |
| Ctrl+B | Page up        |

## File manager / Oil

| Key    | Action                    |
| ------ | ------------------------- |
| -      | Open Oil                  |
| Enter  | Open file/directory       |
| -      | Parent directory          |
| \_     | Current working directory |
| q      | Close Oil                 |
| g?     | Oil help                  |
| Ctrl+S | Save Oil changes          |

## Telescope

| Key      | Action       |
| -------- | ------------ |
| Space+ff | Find files   |
| Space+fg | Search text  |
| Space+fb | Find buffers |
| Space+fh | Search help  |

## Formatting

| Key     | Action                |
| ------- | --------------------- |
| Space+f | Format file/selection |

## LSP

| Command                               | Action                  |
| ------------------------------------- | ----------------------- |
| :checkhealth vim.lsp                  | LSP diagnostics         |
| :lua vim.print(vim.lsp.get_clients()) | Show active LSP clients |
| gd                                    | Go to definition        |
| K                                     | Show documentation      |
| gr                                    | Find references         |
| Ctrl+K                                | Signature help          |

## Useful commands

```text
:n file
:e file
:w
:q
:wq
:q!
:vs
:sp
:set number
:set relativenumber
:checkhealth
:Lazy
:TSUpdate
```
