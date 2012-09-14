package = 'lua-term'
version = '0.2-1'

source = {
  url = 'https://github.com/downloads/hoelzro/lua-term/lua-term-0.2.tar.gz',
}

description = {
  summary  = 'Terminal functions for Lua',
  homepage = 'https://github.com/hoelzro/lua-term',
  license  = "MIT/X11",
}

build = {
  modules = {
    ['term']        = 'term/init.lua',
    ['term.colors'] = 'term/colors.lua',
    ['term.core']   = 'core.c',
  },
  type = 'builtin',
}
