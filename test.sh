#!/bin/sh
mkdir -p test
{
	all=""
	flags="-lm -DLUA_USE_LINUX -ldl -Wall -Wno-unused-function"
	for x in 'gcc -x c' 'g++ -x c++'; do
		for m in \
			'lualib.o:-DMAKE_LIB -c' \
			'lua:-DMAKE_LUA' \
			'luac:-DMAKE_LUA' \
			'luaa:-DMAKE_LUA -DMAKE_LUAC'
		do
			for np in D U; do for nu in D U; do for nd in D U; do
				out=test_${x%% *}$np$nu$nd${m%%:*}
				all="$all $out"
				cat <<EOF
$out: ../luaa.c
	$x -o $out ${m#*:} -${np}NOPARSER -${nu}NOUNDUMP -${nd}NODUMP ../luaa.c $flags
EOF
			done; done; done
		done
	done
	cat <<EOF
.DEFAULT_GOAL := all
.PHONY: all clean
all: $all
clean:
	\$(RM) $all
EOF
} > test/Makefile
make -C test clean
make -C test all
