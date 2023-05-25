#define _POSIX_C_SOURCE 200112L

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#ifndef _MSC_VER
# include <unistd.h>
#endif

#ifdef _WIN32
# include <windows.h>
#endif

static int
lua_isatty(lua_State *L)
{
    FILE **fp = (FILE **) luaL_checkudata(L, 1, LUA_FILEHANDLE);

    lua_pushboolean(L, isatty(fileno(*fp)));
    return 1;
}

#ifdef _WIN32

// Turns the virtual terminal mode on or off
// Returns if setting the console mode was successfull
// Lua synopsis: fun win32turnvt(on_off: boolean): boolean
static int
lua_turnvt(lua_State *L)
{
    // This is a c-closure, we expect the upavlues to be set!
    int on_off = lua_toboolean(L, 1);
    HANDLE console_handle = (HANDLE) lua_touserdata(L, lua_upvalueindex(1));
    DWORD prev_console_mode = *(DWORD*) lua_touserdata(L, lua_upvalueindex(2));

    int success = SetConsoleMode(console_handle, (prev_console_mode & ~ENABLE_VIRTUAL_TERMINAL_PROCESSING) | (on_off ? ENABLE_VIRTUAL_TERMINAL_PROCESSING : 0)) != 0;

    lua_pushboolean(L, success);
    return 1;
}

#endif

int
luaopen_term_core(lua_State *L)
{
    lua_newtable(L);
    lua_pushcfunction(L, lua_isatty);
    lua_setfield(L, -2, "isatty");

#ifdef _WIN32
    { // Setting up win32turnvt
        // Code is basically a line by line rewrite of https://stackoverflow.com/questions/64919350/enable-ansi-sequences-in-windows-terminal

        HANDLE console_handle = GetStdHandle(STD_OUTPUT_HANDLE);
        if(console_handle == INVALID_HANDLE_VALUE)
            goto skip_win32_turnvt;

        DWORD prev_console_mode;
        if(GetConsoleMode(console_handle, &prev_console_mode) == 0)
            goto skip_win32_turnvt;

        // We are in the correct console

        // Set up the c closure
        lua_pushlightuserdata(L, (void*) console_handle);
        DWORD* prev_console_mode_storage = (DWORD*) lua_newuserdata(L, sizeof(DWORD));
        *prev_console_mode_storage = prev_console_mode;
        lua_pushcclosure(L, lua_turnvt, 2);
        lua_setfield(L, -2, "win32turnvt");

        // If his library is required, per default, enable virtual terminal
        lua_getfield(L, -1, "win32turnvt");
        lua_pushboolean(L, 1);
        lua_call(L, 1, 0);
    } skip_win32_turnvt: // Enabling the virtual terminal failed
#endif

    return 1;
}
