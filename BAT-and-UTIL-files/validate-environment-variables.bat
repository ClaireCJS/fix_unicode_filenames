@Echo OFF

    
REM old, called the bat file repeatedly which created overhead
        REM for %ee in (%*) do (call c:\bat\validate-environment-variable %ee)

REM new, relies on the VALIDATE_MULTIPLE flag to do the loop internally in validate-environment-variable.bat to reduce overhead
        set  VALIDATE_MULTIPLE=1
        call validate-environment-variable %*
        set  VALIDATE_MULTIPLE=0
