#!/bin/sh
rminc() {
	sed '/#include *"/s!.*!/*&*/!;/LUAI_DATA/d' "$@"
}
noconflict() {
	cat <<-EOF
		#ifdef $2
		#	define main $3_main
		#	define progname $3_progname
		#	define writer $3_writer
		#	define pmain $3_pmain
		#	define Smain $3_Smain
		#endif
	EOF
	rminc "$1"
	cat <<-EOF
		#ifdef $2
		#	undef main
		#	undef progname
		#	undef writer
		#	undef pmain
		#	undef Smain
		#endif
	EOF
}
exec >luaa.c 3>luaa.h
cd lua-5.1.5/src || exit
{
	rminc luaconf.h lua.h lualib.h lauxlib.h | sed '/define LUA_USE_READLINE/d'
} >&3

cat <<-EOF
	/* default is to build the full interpreter */
	#ifndef MAKE_LIB
	#ifndef MAKE_LUAC
	#ifndef MAKE_LUA
	#define MAKE_LUA
	#endif
	#endif
	#endif
EOF
for i in \
	assert.h ctype.h errno.h float.h limits.h locale.h math.h setjmp.h \
	signal.h stdarg.h stddef.h stdio.h stdlib.h string.h time.h
do echo "#include <$i>"
done
cat <<-EOF
	/* setup for luaconf.h */
	#define LUA_CORE
	#define LUA_LIB
	#define ltable_c
	#define lvm_c
	#define luaall_c
	#include "luaa.h"

EOF
# headers
rminc llimits.h
rminc lmem.h lopcodes.h
rminc lobject.h lzio.h
rminc lapi.h lfunc.h llex.h lparser.h ltable.h ltm.h lundump.h
rminc lcode.h lgc.h lstate.h
rminc ldebug.h ldo.h lstring.h
rminc lvm.h

# core -- used by all
rminc lzio.c
rminc lopcodes.c
rminc lmem.c

cat <<EOF
#if NOUNDUMP
LUAI_FUNC Proto* luaU_undump (lua_State* L, ZIO* Z, Mbuffer* buff, const char* name) {
  UNUSED(Z);
  UNUSED(buff);
  UNUSED(name);
  lua_pushliteral(L,"binary loader not available");
  lua_error(L);
  return NULL;
}
#else
EOF
rminc lundump.c
echo '#endif'

cat <<EOF
#if NODUMP
LUAI_FUNC int luaU_dump (lua_State* L, const Proto* f, lua_Writer w, void* data, int strip) {
  UNUSED(f);
  UNUSED(w);
  UNUSED(data);
  UNUSED(strip);
  lua_pushliteral(L,"dumper not available");
  lua_error(L);
  return 0;
}
#else
#if NOUNDUMP
EOF
rminc lundump.c | sed -n '/^void luaU_header/,$p'
echo '#endif'
rminc ldump.c
echo '#endif'

rminc lobject.c
rminc lstate.c
rminc lgc.c

cat <<EOF
#ifdef NOPARSER
LUAI_FUNC void luaX_init (lua_State *L) {
  UNUSED(L);
}

LUAI_FUNC Proto *luaY_parser (lua_State *L, ZIO *z, Mbuffer *buff, const char *name) {
  UNUSED(z);
  UNUSED(buff);
  UNUSED(name);
  lua_pushliteral(L,"parser not available");
  lua_error(L);
  return NULL;
}
#else
EOF
rminc llex.c
rminc lcode.c
rminc lparser.c
echo '#endif'

rminc ltm.c
rminc ldebug.c
rminc lfunc.c
rminc lstring.c
rminc ltable.c
rminc ldo.c
rminc lvm.c
rminc lapi.c
# auxiliary library -- used by all
rminc lauxlib.c
# standard library  -- not used by luac
echo '#if defined(MAKE_LUA) || defined(MAKE_LIB)'
rminc lbaselib.c
rminc ldblib.c
rminc liolib.c
rminc lmathlib.c
rminc loadlib.c
rminc loslib.c
rminc lstrlib.c
rminc ltablib.c
rminc linit.c
echo '#endif'

# lua 
echo '#ifdef MAKE_LUA'
noconflict lua.c MAKE_LUAC lua
echo '#endif'

# luac
echo '#ifdef MAKE_LUAC'
rminc print.c
noconflict luac.c MAKE_LUA luac
echo '#endif'

cat <<EOF
#if defined(MAKE_LUA) && defined(MAKE_LUAC)
int main(int argc, char **argv) {
	if (argv[0]) {
		const char *base = strrchr(argv[0], '/');
		if (strstr(base ? base : argv[0], "luac"))
			return luac_main(argc, argv);
	}
	return lua_main(argc, argv);
}
#endif
EOF
