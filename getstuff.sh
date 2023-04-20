#!/bin/sh
curl -LSso noparser4.c https://www.lua.org/extras/5.4/noparser.c
curl -LSso one4.c https://www.lua.org/extras/5.4/one.c
curl -LSso noparser3.c https://www.lua.org/extras/5.3/noparser.c
curl -LSs https://www.lua.org/extras/5.3/one.tar.gz | tar -xzO one/one.c >one3.c
curl -LSso noparser2.c https://www.lua.org/extras/5.2/noparser.c
curl -LSso one2.c https://www.lua.org/extras/5.2/one.c
