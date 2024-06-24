-- Copyright (c) 2009 Rob Hoelz <rob@hoelzro.net>
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

do -- set console to utf-8 and enable ANSI escape sequences on Windows
  local ok, sys = pcall(require, "system")
  if ok and sys.setconsoleflags and sys.windows then
    sys.setconsoleoutputcp(sys.CODEPAGE_UTF8)
    if sys.isatty(io.stdout) then
      sys.setconsoleflags(io.stdout, sys.getconsoleflags(io.stdout) + sys.COF_VIRTUAL_TERMINAL_PROCESSING)
    end
    if sys.isatty(io.stderr) then
      sys.setconsoleflags(io.stderr, sys.getconsoleflags(io.stderr) + sys.COF_VIRTUAL_TERMINAL_PROCESSING)
    end
  end
end

local term    = require 'term.core'
local sformat = string.format
local iotype  = io.type
local stdout  = io.stdout

function term.maketermfunc(sequence_fmt)
  sequence_fmt = '\027[' .. sequence_fmt

  local func

  func = function(handle, ...)
    if iotype(handle) ~= 'file' then
      return func(stdout, handle, ...)
    end

    return handle:write(sformat(sequence_fmt, ...))
  end

  return func
end

term.colors = require 'term.colors'
term.cursor = require 'term.cursor'

term.clear    = term.maketermfunc '2J'
term.cleareol = term.maketermfunc 'K'
term.clearend = term.maketermfunc 'J'

term.maketermfunc = nil

return term
