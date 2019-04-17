:: "tests/misc/TEST_FOLDER.bat"         v1.0.0 | 2019/02/26 | by Tristano Ajmone
:: -----------------------------------------------------------------------------
:: MULTIPLE ADVENTURES -- Run all tests in the folder.
:: -----------------------------------------------------------------------------
@ECHO OFF & CLS
:: Code Page 28591 = ISO 8859-1 Latin 1; Western European (ISO)
CHCP 28591 > nul

FOR %%i IN (*.alan) DO (
  ECHO =====================================================
  ECHO COMPILE:   %%i
  CALL :CompileTest %%i
)

EXIT /B

:CompileTest
CALL alan.exe -import ..\..\ %1  > nul 2>&1 ^
  && (
    FOR %%i IN (%~n1*.a3sol) DO CALL :ExecTest %~n1.a3c %%i
  ) || (
    ECHO ^*^* COMPILATION FAILED ^*^*
  )
EXIT /B

:ExecTest
ECHO TEST WITH: %2
CALL arun.exe -r %~n1.a3c < %2 > %~n2.a3log
EXIT /B
