#!/bin/sh
(
	echo 'digraph {'
	echo 'rankdir=LR;'
	grep -H '#include *"' lua-5.3.6/src/*.h | sed '
		/lua\.h\|luaconf\.h\|lauxlib\.h\|lualib\.h\|lprefix\.h/d
		s!lua-5.3.6/src/!"!
		s/:#include */" -> /
	'
	echo '}'
) | dot -Tpng > depgraph-5.3.png
