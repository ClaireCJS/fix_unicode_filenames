@echo off
call .\grab.bat
c:\programdata\anaconda3\scripts\pylint fixUnicodeFilenames.py
call ep c:\bat\fixUnicodeFilenames.py