Overview
--------

lua-term is a Lua module for manipulating a terminal.

Installation
------------

lua-term is available on Luarocks.

Usage
-----

```lua
    local term   = require 'term'
    local colors = term.colors -- or require 'term.colors'

    print(term.isatty(io.stdout)) -- true if standard output goes to the terminal

    print(color.red 'hello')
    print(color.red .. 'hello' .. color.reset)
    print(color.red, 'hello', color.reset)
```
