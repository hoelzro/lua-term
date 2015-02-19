    local term   = require 'term.init'
    local colors = term.colors -- or require 'term.colors'

    print(term.isatty(io.stdout)) -- true if standard output goes to the terminal

    print(colors.red 'hello')
    print(colors.red .. 'hello' .. colors.reset)
    print(colors.red, 'hello', colors.reset)

    -- The following functions take an optional IO handle (like io.stdout);
    -- io.stdout is the default if you don't specify one
    term.clear()    -- clears the screen
    term.cleareol() -- clears from the cursor to the end of the line
    --term.cursor.goto(1, 1) -- It will fail in Lua >= 5.2 because goto is a reserved word.
    term.cursor['goto'](1, 1) -- This will work on Lua >= 5.2, please use jump instead
    term.cursor.jump(1, 1) -- jump is just an alias for goto
    term.cursor.jump(io.stdout, 1, 1)
    term.cursor.goup(1)
    term.cursor.godown(1)
    term.cursor.goright(1)
    term.cursor.goleft(1)
    term.cursor.save()    -- save position
    term.cursor.restore() -- restore position
