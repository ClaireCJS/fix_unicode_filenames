@Echo OFF

REM     I actually do all my development for this in my personal live command line environment,
REM     so for me, these files actually "live" in "c:\bat\" and just need to be refreshed to my 
REM     local GIT repo beore doing anything significant.  Or really, before doing anything ever.


rem CONFIGURATION:
        SET MANIFEST_FILES=fix_unicode_filenames.py fix_unicode_filenames_every_char.py fix-unicode-filenames.bat

        set SECONDARY_BAT_FILES=%MANIFEST_FILES% validate-in-path.bat validate-environment-variables.bat validate-environment-variable.bat white-noise.bat askyn.bat unimportant.bat print-message.bat randcolor.bat colors.bat colortool.bat settmpfile.bat important.bat fatalerror.bat fatal_error.bat car.bat nocar.bat errorlevel.bat print-if-debug.bat advice.bat colortool.bat  change-escape-character-to-tilde.bat change-escape-character-to-carrot.bat
        
        REM could include colortool.exe as it's used by colors.bat to display a color table but it's really not critical

call update-from-BAT-via-manifest.bat



