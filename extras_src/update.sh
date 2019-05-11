#!/bin/bash

# update.sh               v1.3.0 | 2019/05/05 | by Tristano Ajmone, MIT License.
################################################################################
#                                                                              #
#                          BUILD STDLIB EXTRAS FOLDER                          #
#                                                                              #
################################################################################
# Build and deploy the contents of the following "/extras/" subfolders:

foldersList="manual tutorials"

# The script will build, compile, convert and/or process the following type of
# contents in the source folders "extras_src/<foldername>/":
#
#  -- Alan example adventures
#  -- Adventures command scripts
#  -- Adventures transcripts
#  -- AsciiDoc documents

# Then it will deploy to the output folders "extras/<foldername>/":
#
#  -- HTML converted documents
#  -- Alan example adventures (stripped of Asciidoctor region tags)

################################################################################
#                                   SETTINGS                                   #
################################################################################
source _print-funcs.sh   # Ornamental print functions
source _build-funcs.sh   # Build and deploy functions

################################################################################
#                                BANNER & INTRO                                #
################################################################################
printBanner "Build StdLib Extras Folders"

# Calculate how many folders will be processed in total, and check that all the
# source folders in $foldersList actually exist.

counter=0
echo -e "The following folders will be processed:\n\e[93m"
for dirName in $foldersList; do
  (( counter = counter + 1 ))
  echo -e "  \e[90m$counter. \e[93m$dirName"
  if [ ! -d "$dirName" ]; then
    printErrMsg "Subfolder \"$dirName\" doesn't exist!"
    printAborting
    exit 1
  fi
done
foldersTot=$counter

################################################################################
#                           FOLDERS-PROCESSING LOOP                            #
################################################################################

counter=0
for dirName in $foldersList; do
  (( counter = counter + 1 ))

  # Define Source & Destination folders:
  outDir="$outBasePath/$dirName" # destination folder for HTML docs and examples
  srcDir="$srcBasePath/$dirName" # path of AsciiDoc sources and Alan examples
  utfDir="$utfBasePath/$dirName" # path of UTF-8 converted Alan files
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  printHeading1 "Processing Folder $counter/$foldersTot: \"$dirName\""

  # ============================================================================
  printHeading2 "Process Alan Adventures"
  # ============================================================================

  # ----------------------------------------------------------------------------
  printHeading3 "Compile Adventures"
  # ----------------------------------------------------------------------------
  for sourcefile in $srcDir/*.alan ; do
    compile $sourcefile
    if [ $? -ne 0 ] ; then
      printAborting ; exit 1
    fi
  done

  # ----------------------------------------------------------------------------
  printHeading3 "Run Commands Scripts"
  # ----------------------------------------------------------------------------

  for adventure in $srcDir/*.a3c ; do
    runCommandsScripts $adventure
  done

  # ----------------------------------------------------------------------------
  printHeading3 "Deploy Alan Source Files"
  # ----------------------------------------------------------------------------
  echo -e "Copy to target folder every Alan source, but stripped of all lines containing"
  echo -e "AsciiDoc region-tag comments."

  for file in $srcDir/*.alan ; do
    deployAlan $file
  done

  # ============================================================================
  printHeading2 "Build AsciiDoc Documentation"
  # ============================================================================

  # ----------------------------------------------------------------------------
  printHeading3 "Create UTF-8 Version of Alan Sources and Transcripts"
  # ----------------------------------------------------------------------------

  echo -e "Because Asciidoctor can't handle inclusion of external files in ISO-8859-1"
  echo -e "econding, we need to create UTF-8 versions of them."

  # rm -r $utfDir/*.{alan,a3log,a3ADocLog}
  rm -rf $utfDir
  mkdir  $utfDir
  touch  $utfDir/.gitkeep

  for sourcefile in $srcDir/*.{alan,i,a3log} ; do
    alan2utf8 $sourcefile
    if [ $? -ne 0 ] ; then
      printAborting ; exit 1
    fi
  done

  # ----------------------------------------------------------------------------
  printHeading3 "Sanitize Game Transcripts"
  # ----------------------------------------------------------------------------

  echo -e "Reformat game transcripts from verbatim to AsciiDoc example blocks."

  for transcript in $utfDir/*.a3log ; do
    a3logSanitize $transcript
    if [ $? -ne 0 ] ; then
      printAborting ; exit 1
    fi
  done

  # ----------------------------------------------------------------------------
  printHeading3 "Convert Docs to HTML"
  # ----------------------------------------------------------------------------
  for sourcefile in $srcDir/*.asciidoc ; do
    adoc2html $sourcefile
    if [ $? -ne 0 ] ; then
      printAborting ; exit 1
    fi
  done
done

# ------------------------------------------------------------------------------

printFinished
exit

# ------------------------------------------------------------------------------
# The MIT License
#
# Copyright (c) 2019 Tristano Ajmone: <tajmone@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ------------------------------------------------------------------------------
# EOF #
