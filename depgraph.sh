#!/bin/sh
: "${LUAVER:=5.4}"
(
	echo 'digraph {'
	echo 'rankdir=LR;'
	grep -H '#include *"' lua-"$(./patchlevel "$LUAVER")"/src/*.h | sed '
		/lua\.h\|luaconf\.h\|lauxlib\.h\|lualib\.h\|lprefix\.h/d
		s!lua-'"$(./patchlevel "$LUAVER")"'/src/!"!
		s/:#include */" -> /
	'
	echo '}'
) | dot -Tpng > depgraph-"$LUAVER".png
