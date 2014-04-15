#this file builds lua-term \o/

LUA_VER		:= 5.1
LUA_DIR		:= /usr
LUA_LIBDIR	:= $(LUA_DIR)/lib/lua/$(LUA_VER)/term
LUA_INC		:= $(LUA_DIR)/include/lua$(LUA_VER)
LUA_SHARE	:= $(LUA_DIR)/share/lua/$(LUA_VER)/term
CWARNS          := -Wall -pedantic 
CFLAGS 		:= $(CWARNS) -ansi -O3 -I$(LUA_INC) -fPIC
LIB_OPTION	:= -shared

SONAME   	:= core.so
SONAMEV  	:= $(SONAME).1
LIBRARY  	:= $(SONAMEV).0.1
SRC      	:= core.c
OBJ      	:= $(patsubst %.c, %.o, $(SRC))

FILES		:= term/init.lua term/cursor.lua term/colors.lua

all: $(LIBRARY) $(SONAMEV) $(SONAME)

$(SONAMEV):
	ln -s $(LIBRARY) $@

$(SONAME):
	ln -s $(SONAMEV) $@

$(LIBRARY): $(OBJ)
	$(CC) $(CFLAGS) $(LIB_OPTION) -o $(LIBRARY) $(OBJ) -lc
		
install:
	mkdir -p $(LUA_LIBDIR)
	cp $(SONAME) $(LUA_LIBDIR)
	mkdir -p $(LUA_SHARE)
	cp $(FILES) $(LUA_SHARE)

clean:
	$(RM) $(LIBRARY) $(SONAMEV) $(SONAME) *.o

