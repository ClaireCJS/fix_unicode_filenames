@Echo OFF

for %ee in (%*) do (
    call c:\bat\validate-environment-variable %ee
)
