:: "BUILD.bat" v1.0.0 (2018/12/16) by Tristano Ajmone
:: -----------------------------------------------------------------------------
:: REQUIREMENTS -- To run this script you'll need to install:
:: - Asciidoctor (Ruby):
::   https://asciidoctor.org/
:: - Highlight >= 3.45:
::   http://www.andre-simon.de/
:: -----------------------------------------------------------------------------
@ECHO OFF
ECHO.

ECHO ===========================
ECHO Building ALAN StdLib Extras
ECHO ===========================
ECHO Converting documents from AsciiDoc to HTML:
FOR %%i IN (*.asciidoc) DO (
	CALL :conv2html %%i
)

EXIT /B

:: ==============================================================================
:: func                           Convert to HTML                                
:: ==============================================================================
:conv2html

ECHO - "%1"
CALL asciidoctor^
	--verbose^
	--safe-mode unsafe^
	--template-dir ./_assets/erb^
	--require ./_assets/highlight-treeprocessor_mod.rb^
	 -a docinfodir=./_assets^
	 -a docinfo=shared-head^
	  %1
EXIT /B
