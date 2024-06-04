# Visual Studio 2019 Makefile
# uses the SQLite3 amalgamation source which must
# be unpacked below in the same folder as this makefile
#
# see the SO post following for a discussion on link library order for ODBC
# to prevent SQL_INVALID_HANDLE result code.
#   https://stackoverflow.com/questions/52506758/microsoft-odbc-cannot-create-valid-handle


CC=		cl
LN=		link
RC=		rc

!IF "$(DEBUG)" == "1"
LDEBUG=		/DEBUG
CDEBUG=		-Zi
!ELSE
LDEBUG=		/RELEASE
!ENDIF


CFLAGS=		-I. -Gs -EHsc -D_WIN32 -D_DLL -nologo $(CDEBUG) \
		-DHAVE_SQLITE3COLUMNTABLENAME=1 \
		-DHAVE_SQLITE3PREPAREV2=1 \
		-DHAVE_SQLITE3VFS=1 \
		-DHAVE_SQLITE3LOADEXTENSION=1 \
		-DSQLITE_ENABLE_COLUMN_METADATA=1 \
		-DWITHOUT_SHELL=1
CFLAGSEXE=	-I. -I.. -Gs -EHsc -D_WIN32 -nologo $(CDEBUG)

DLLLFLAGS=	/NODEFAULTLIB $(LDEBUG) /NOLOGO /MACHINE:IX86 \
		/SUBSYSTEM:WINDOWS /DLL

DLLLIBS=	ucrt.lib vcruntime.lib msvcrt.lib odbccp32.lib kernel32.lib \
		user32.lib comdlg32.lib legacy_stdio_definitions.lib legacy_stdio_wide_specifiers.lib

EXELIBS=    odbccp32.lib odbc32.lib sqlite3odbc.lib ucrt.lib vcruntime.lib msvcrt.lib kernel32.lib user32.lib 

DRVDLL=		sqlite3odbc.dll

.c.obj:
		$(CC) $(CFLAGS) /c $<

all:		obench.exe sbench.exe

clean:
		del *.obj
		del *.res
		del *.exp
		del *.ilk
		del *.pdb
		del *.res
		del *.exe

Obench.exe:	obench.c
		$(CC) $(CFLAGSEXE) obench.c $(EXELIBS)

sbench.exe:	sbench.c
		$(CC) $(CFLAGSEXE) sbench.c ../sqlite3.obj $(EXELIBS) 

