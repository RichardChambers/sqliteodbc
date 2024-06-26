# VC++ 6 Makefile
# uses the SQLite3 amalgamation source which must
# be unpacked below in the same folder as this makefile

CC=		cl
LN=		link
RC=		rc

!IF "$(DEBUG)" == "1"
LDEBUG=		/DEBUG
CDEBUG=		-Zi
!ELSE
LDEBUG=		/RELEASE
!ENDIF

# see SO post
#   https://stackoverflow.com/questions/69492118/unresolved-external-symbol-vsnwprintf-s-compiling-odbc-driver-with-nmake-vs-20
#
# 2021-10-07 RC: -GX flag is deprecated.
#                Use -EHsc for exception handling behavior
# 2021-10-07 RC: add libraries vcruntime.lib ucrt.lib to DLLLFLAGS
#                see https://devblogs.microsoft.com/cppblog/introducing-the-universal-crt/
# 2021-10-07 RC: add libraries legacy_stdio_definitions.lib legacy_stdio_wide_specifiers.lib
#                to correct link error LNK2019: unresolved external with odbccp32.lib
#                error LNK2019: unresolved external symbol __vsnwprintf_s referenced in function _StringCchPrintfW
#                added new definition EXELIBS
CFLAGS=		-I. -Gs -EHsc -D_WIN32 -D_DLL -nologo $(CDEBUG) \
		-DHAVE_SQLITE3COLUMNTABLENAME=1 \
		-DHAVE_SQLITE3PREPAREV2=1 \
		-DHAVE_SQLITE3VFS=1 \
		-DHAVE_SQLITE3LOADEXTENSION=1 \
		-DSQLITE_ENABLE_COLUMN_METADATA=1 \
		-DWITHOUT_SHELL=1
CFLAGSEXE=	-I. -Gs -EHsc -D_WIN32 -nologo $(CDEBUG)
DLLLFLAGS=	/NODEFAULTLIB $(LDEBUG) /NOLOGO /MACHINE:IX86 \
		/SUBSYSTEM:WINDOWS /DLL
DLLLIBS=	ucrt.lib vcruntime.lib msvcrt.lib odbccp32.lib kernel32.lib \
		user32.lib comdlg32.lib legacy_stdio_definitions.lib legacy_stdio_wide_specifiers.lib
EXELIBS=    odbc32.lib odbccp32.lib kernel32.lib user32.lib \
        legacy_stdio_definitions.lib legacy_stdio_wide_specifiers.lib
DRVDLL=		sqlite3odbc.dll

OBJECTS=	sqlite3odbc.obj sqlite3.obj

.c.obj:
		$(CC) $(CFLAGS) /c $<

all:		$(DRVDLL) inst.exe uninst.exe adddsn.exe remdsn.exe \
		addsysdsn.exe remsysdsn.exe SQLiteODBCInstaller.exe

clean:
		del *.obj
		del *.res
		del *.exp
		del *.ilk
		del *.pdb
		del *.res
		del resource3.h
		del *.exe
		cd ..

uninst.exe:	inst.exe
		copy inst.exe uninst.exe

inst.exe:	inst.c
		$(CC) $(CFLAGSEXE) inst.c $(EXELIBS)

remdsn.exe:	adddsn.exe
		copy adddsn.exe remdsn.exe

adddsn.exe:	adddsn.c
		$(CC) $(CFLAGSEXE) adddsn.c $(EXELIBS)

remsysdsn.exe:	adddsn.exe
		copy adddsn.exe remsysdsn.exe

addsysdsn.exe:	adddsn.exe
		copy adddsn.exe addsysdsn.exe

fixup.exe:	fixup.c
		$(CC) $(CFLAGSEXE) fixup.c

mkopc3.exe:	mkopc3.c
		$(CC) $(CFLAGSEXE) mkopc3.c

SQLiteODBCInstaller.exe:	SQLiteODBCInstaller.c
		$(CC) $(CFLAGSEXE) SQLiteODBCInstaller.c \
		kernel32.lib user32.lib

sqlite3odbc.c:	resource3.h

sqlite3odbc.res:	sqlite3odbc.rc resource3.h
		$(RC) -I. -fo sqlite3odbc.res -r sqlite3odbc.rc

sqlite3odbc.dll:	$(OBJECTS) sqlite3odbc.res
		$(LN) $(DLLLFLAGS) $(OBJECTS) sqlite3odbc.res \
		-def:sqlite3odbc.def -out:$@ $(DLLLIBS)

VERSION_C:	fixup.exe VERSION
		.\fixup < VERSION > VERSION_C . ,

resource3.h:	resource.h.in VERSION_C fixup.exe
		.\fixup < resource.h.in > resource3.h \
		    --VERS-- @VERSION \
		    --VERS_C-- @VERSION_C
