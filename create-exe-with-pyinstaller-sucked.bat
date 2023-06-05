@Echo on

call  grab.bat
set FILE1=fix_unicode_filenames.py
set FILE2=fix_unicode_filenames.spec
:pyinstaller --exclude hook-cryptography,hook-llvmlite,hook-matplotlib,hook-numba,hook-numpy,hook-pandas,hook-pickle,hook-rapidfuzz,hook-scipy,hook-sqlite3,hook-jsonschema %FILE1%
 

 if not exist %FILE2% (pyi-makespec --onefile fix_unicode_filenames.py)
 if     exist %FILE2% (set FILE_TO_USE=%FILE2%)

REM or try auto-py-to-exe for a gui version!  pip it then run the exe of same name! it opens gui!


  pyinstaller  %FILE_TO_USE%


