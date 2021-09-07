@rem Script to build Lua with MSVC.
@echo off

@if not defined INCLUDE goto :FAIL
@setlocal
 
@if "%1"=="clean" goto :CLEAN
 
@set CC=cl
@set LD=link
@set AR=lib
@set RC=rc
@set CP=copy
 
@set DBG_CFLAGS=/nologo /c /Zi /Od /Ob0 /RTC1
@set CFLAGS=/nologo /c /O2 /W3
@set CFLAGS_MD=/MD
@set CFLAGS_MDD=/MDd
@set CFLAGS_MT=/MT
@set CFLAGS_MTD=/MTd
@set LDFLAGS=
 
@set LUA_CFLAGS=/DNDEBUG /D_WINDOWS /DWIN32 /DWINNT
     
@set LUA_SRC=lapi.c lauxlib.c lbaselib.c lcode.c lcorolib.c lctype.c ldblib.c ldebug.c^
			 ldo.c ldump.c lfunc.c lgc.c linit.c liolib.c llex.c lmathlib.c lmem.c loadlib.c lobject.c^
			 lopcodes.c loslib.c lparser.c lstate.c lstring.c lstrlib.c ltable.c ltablib.c ltm.c lundump.c^
			 lutf8lib.c lvm.c lzio.c 

@set DEP_LIB=

cd src
@rem clean
del *.lib *.obj *.manifest *.exp *.dll *.exe

@rem Multithreaded, dynamic link
%CC% %CFLAGS_MDD% %DBG_CFLAGS% %LUA_CFLAGS% %LUA_SRC%
%AR% /OUT:lua54-mdd.lib *.obj
%LD% /DLL /OUT:lua54-mdd.dll *.obj
del *.obj *.manifest

%CC% %CFLAGS_MD% %CFLAGS% %LUA_CFLAGS% %LUA_SRC%
%AR% /OUT:lua54-md.lib *.obj
%LD% /DLL /OUT:lua54-md.dll *.obj
del *.obj *.manifest
 
@rem Multithreaded, static link
%CC% %CFLAGS_MTD% %DBG_CFLAGS% %LUA_CFLAGS% %LUA_SRC%
%AR% /OUT:lua54-mtd.lib *.obj
%LD% /DLL /OUT:lua54-mtd.dll *.obj
del *.obj *.manifest

%CC% %CFLAGS_MT% %CFLAGS% %LUA_CFLAGS% %LUA_SRC%
%AR% /OUT:lua54-mt.lib *.obj
%LD% /DLL /OUT:lua54-mt.dll *.obj
del *.obj *.manifest
 
@rem Multithreaded, dynamic lua.exe
%CC% %CFLAGS_MT% %CFLAGS% %LUA_CFLAGS% lua.c
%LD% /OUT:lua.exe lua.obj lua54-mt.lib %DEP_LIB%
del *.obj *.manifest *.exp

@rem Multithreaded, dynamic luac.exe
%CC% %CFLAGS_MT% %CFLAGS% %LUA_CFLAGS% luac.c
%LD% /OUT:luac.exe luac.obj lua54-mt.lib %DEP_LIB%
del *.obj *.manifest *.exp
 
@goto :COPY

:COPY
xcopy *.exe ..\out\bin\ /s /e /y
xcopy *.lib ..\out\lib\ /s /e /y
xcopy *.dll ..\out\lib\ /s /e /y
md ..\out\include
copy lua.h ..\out\include\ /y
copy lua.hpp ..\out\include\ /y
copy luaconf.h ..\out\include\ /y
copy lualib.h ..\out\include\ /y
copy lauxlib.h ..\out\include\ /y
@goto :CLEAN
 
:CLEAN
del *.lib *.obj *.manifest *.exp *.dll *.exe
@goto :END

:FAIL
@echo You must open a "Visual Studio Command Prompt" to run this script
@goto :END

:END
PAUSE