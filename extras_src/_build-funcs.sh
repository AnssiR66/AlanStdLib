#!/bin/bash

# _build-funcs.sh         v1.0.0 | 2019/05/05 | by Tristano Ajmone, MIT License.
################################################################################
#                                                                              #
#                        DOCUMENTATION BUILD FUNCTIONS                         #
#                                                                              #
################################################################################
# Defines build and conversion settings and functions shared by all scripts.

# +--------------------+---------------+---------------------------------+
# | function name      | params        | description                     |
# +--------------------+---------------+---------------------------------+
# | normalizeEOL       | file          | Enforce CRLF EOL on Windows OS. |
# | compile            | file, options | Compile an Alan adventure.      |
# | runCommandsScripts | storyfile     | Run ".a3sol" files -> ".a3log". |
# | alan2utf8          | file          | Create UTF-8 from ISO-8859-1.   |
# | a3logSanitize      | file          | ".a3log" -> ".a3ADocLog".       |
# | adoc2html          | file          | Conv AsciiDoc -> HTML.          |
# | deployAlan         | file          | Strip and deploy ".alan" files. |
# +--------------------+---------------+---------------------------------+

################################################################################
#                                   SETTINGS                                   #
################################################################################
# NOTE: All paths are relative to the folder of this script.

shopt -s nullglob # Set nullglob to avoid patterns matching null files

# Alan compiler options:
AlanOpts="-import ../StdLib/"

# Asciidoctor options:
adocDir="./adoc"
hamlDir="$adocDir/haml"

# Base Paths for Source & Destination
srcBasePath="."
outBasePath="../extras"
utfBasePath="./utf8"

# ******************************************************************************
# *                                                                            *
# *                              GENERAL PURPOSE                               *
# *                                                                            *
# ******************************************************************************

function normalizeEOL {
  # ============================================================================
  # if OS is Windows normalize EOL to CRLF (because sed uses LF)
  # ----------------------------------------------------------------------------
  # Parameters:
  # - $1: the file to normalize.
  # ============================================================================
  if [[ $(uname -s) == MINGW* ]];then
    echo -e "\e[90mUNIX2DOS: \e[94m$1"
    unix2dos -q $1
  fi
}

# ******************************************************************************
# *                                                                            *
# *                                 ALAN TASKS                                 *
# *                                                                            *
# ******************************************************************************

function compile {
  # ============================================================================
  # Compile an Alan adventure
  # ----------------------------------------------------------------------------
  # Parameters and Env Vars:
  # - $1: the source adventure to compile.
  # - $AlanOpts: compiler options.
  # ============================================================================
  printSeparator
  echo -e "\e[90mCOMPILING: \e[93m$1"
  alan $AlanOpts $1 > /dev/null 2>&1 || (
    echo -e "\n\e[91m*** COMPILER ERROR!!! ********************************************************"
    alan $AlanOpts $1
    echo -e "******************************************************************************\e[97m"
    cmd_failed="true"
    return 1
  )
}

function runCommandsScripts {
  # ============================================================================
  # Given a target Alan adventure "<advname>.a3c", execute it against every
  # command script in the folder with a filename matching "<advname>*.a3sol" and
  # save the game transcript to "<advname>*.a3log".
  # ----------------------------------------------------------------------------
  # Parameters:
  # - $1: the target Alan adventure (".a3c").
  # ============================================================================
  scriptsPattern="${1%.*}*.a3sol"
  printSeparator
  echo -e "\e[90mADVENTURE: \e[93m$1"
  for script in $scriptsPattern ; do
    transcript="${script%.*}.a3log"
    echo -e "\e[90mPLAY WITH: \e[94m$script"
    arun.exe -r $1 < $script > $transcript
  done
}

# ******************************************************************************
# *                                                                            *
# *                                ASCIIDOCTOR                                 *
# *                                                                            *
# ******************************************************************************

function alan2utf8 {
  # ============================================================================
  # Create an UTF-8 coverted copy of an ISO-8859-1 Alan file (adventure,
  # commands script or transcript) inside $utfDir, to allow its inclusion in
  # AsciiDoc documents, because Asciidoctor won't handle ISO-8859-1 files. See:
  #
  #  https://github.com/asciidoctor/asciidoctor/issues/3248
  # ----------------------------------------------------------------------------
  # Parameters:
  # - $1: the input ISO-8859-1 file to convert.
  # Required Env Vars:
  # - $utfDir: path to the base folder for all UTF-8 converted files.
  # ============================================================================
  outfile="$utfDir/$(basename $1)"
  printSeparator
  echo -e "\e[90mSOURCE FILE: \e[93m$1"
  echo -e "\e[90mDESTINATION: \e[34m$outfile"
  iconv -f ISO-8859-1 -t UTF-8 $1 > $outfile
}

function a3logSanitize {
  # ============================================================================
  # Takes a game transcript input file $1 "<filename>.a3log" and converts it to
  # "<filename>.a3ADocLog", a well formatted AsciiDoc example block.
  # ----------------------------------------------------------------------------
  # Parameters:
  # - $1: the input transcript file.
  # Required scripts:
  # - ./sanitize_a3log.sed
  # ============================================================================
  outfile="${1%.*}.a3ADocLog"
  printSeparator
  echo -e "\e[90mSOURCE FILE: \e[93m$1"
  echo -e "\e[90mDESTINATION: \e[34m$outfile"
  sed -E --file=sanitize_a3log.sed $1 > $outfile
  normalizeEOL $outfile
}

function adoc2html {
  # ============================================================================
  # Convert file $1 from AsciiDoc to HTML via Asciidoctor. Requires Highlight
  # for syntax highlighting code. Custom CSS via docinfo file.
  # ----------------------------------------------------------------------------
  # Parameters:
  # - $1: the input AsciiDOc file to convert.
  # Required Env Vars:
  # - $outDir: path of output directory.
  # - $hamlDir: path to Haml templates.
  # - $adocDir: path to Asciidoctor custom extensions.
  # ============================================================================
  printSeparator
  echo -e "\e[90mCONVERTING: \e[93m$1"
  asciidoctor \
    --verbose \
    --safe-mode unsafe \
    --base-dir ./ \
    --destination-dir $outDir \
    --template-dir $hamlDir \
    --require $adocDir/highlight-treeprocessor_mod.rb \
     -a docinfodir@=$adocDir \
     -a docinfo@=shared-head \
     -a utf8dir=$utfDir \
      $1
}

function deployAlan {
  # ============================================================================
  # Takes the Alan source file of $1, and creates in $outDir a copy stripped of
  # all region-tag comment lines.
  # ----------------------------------------------------------------------------
  # Parameters:
  # - $1: the input Alan source adventure file to deploy.
  # Required Env Vars:
  # - $outDir: path of output directory.
  # ============================================================================
  outfile="$outDir/$(basename $1)"
  printSeparator
  echo -e "\e[90mSOURCE FILE: \e[93m$1"
  echo -e "\e[90mDESTINATION: \e[94m$outfile"
  sed -r '/^ *-- *(tag|end)::\w+\[/ d' $1 > $outfile
  normalizeEOL $outfile
}

# EOF #
