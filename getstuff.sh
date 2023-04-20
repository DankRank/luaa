curl -LSso lua-5.4.4.tar.gz https://www.lua.org/ftp/lua-5.4.4.tar.gz
curl -LSso noparser.c https://www.lua.org/extras/5.4/noparser.c
curl -LSso one.c https://www.lua.org/extras/5.4/one.c
curl -LSso lua-5.3.6.tar.gz https://www.lua.org/ftp/lua-5.3.6.tar.gz
curl -LSso noparser3.c https://www.lua.org/extras/5.3/noparser.c
curl -LSs https://www.lua.org/extras/5.3/one.tar.gz | tar -xzO one/one.c >one3.c
