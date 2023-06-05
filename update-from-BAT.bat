@Echo OFF

REM     I actually do all my development for this in my personal live command line environment,
REM     so for me, these files actually "live" in "c:\bat\" and just need to be refreshed to my 
REM     local GIT repo beore doing anything significant.  Or really, before doing anything ever.


rem CONFIGURATION:
        SET MANIFEST_FILES=fixUnicodeFilenames.py




call update-from-BAT-via-manifest.bat



