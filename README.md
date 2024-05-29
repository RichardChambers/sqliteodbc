# sqliteodbc
a copy of the SQLIte ODBC driver sqliteodbc copyrighted by Christian Werner

The original can be found at URL: http://www.ch-werner.de/sqliteodbc/

## Repository purpose

The goal of this repository is to provide a way to track changes while using this copy of the source code
to learn an example of an ODBC driver.

## Source code version

The source of this repository is from the gzipped tar file sqliteodbc-0.99991.tar.gz which was the latest as of May 28, 2024.

The last update tag of the page shows "Last update 2023-10-23"

The original source had several different README type files. I've created this README.md file as the place for my notes and
explanation of my work. The notes that I found thus far indicate the last built version using a Visual Studio IDE was using
Visual Studio 6.0 which is several decades old. It appears that most development is using the mingw compiler and tool chain.

In addition to the source code, since I'm using GitHub I've created several additional files.
 - README.md 
 - .gitignore

### SQLite 3 amalgamation

The source code for SQLITE 3 is at URL: https://sqlite.org/download.html

You will need to download the amalgamation zip file which contains the two files you
will need: sqlite3.c and sqlite3.h. These files contain the SQLite 3 source code in
a single file which makes building with SQLite 3 source easier.

## Tool chain

### 05/28/2020

I'm using the Visual Studio 2019 Community Edition compiler and Visual Code editor with nmake. The make file is `sqlite3odbc.mak`
to build a Windows 32 bit SQLite3 ODBC driver using Visual Studio 2019 Community Edition. This requires a Windows command or .bat
file that is run go create a command line terminal window which uses the standard Visual Studio script to set up the various
environment variables such as PATH so that nmake.exe and the compiler and libraries are available in the command line terminal window.

# Changes

## Visual Studio 2019 Community Edition notes

See Stackoverflow post for a problem with a link error.

https://stackoverflow.com/questions/69492118/unresolved-external-symbol-vsnwprintf-s-compiling-odbc-driver-with-nmake-vs-20

 -  -GX flag is deprecated. Use -EHsc for exception handling behavior
 - add libraries vcruntime.lib ucrt.lib to DLLLFLAGS 
   see https://devblogs.microsoft.com/cppblog/introducing-the-universal-crt/
 -  add libraries legacy_stdio_definitions.lib legacy_stdio_wide_specifiers.lib
    to correct link error LNK2019: unresolved external with odbccp32.lib
    error LNK2019: unresolved external symbol __vsnwprintf_s referenced in function _StringCchPrintfW
 - added new definition EXELIBS
