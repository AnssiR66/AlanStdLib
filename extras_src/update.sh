#!/bin/bash

# extras_src/update.sh    v2.2.1 | 2020/12/28 | by Tristano Ajmone, MIT License.
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
#                               SETUP & SETTINGS                               #
################################################################################
if ! [[ -v AlanEnv ]]; then # If ALAN env is not already initialized:
	source ../_assets/sh/init-env.sh  # Initialize the work environment
fi

export invoker="extras_src/update.sh"   # Used by some external scripts
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
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	printHeading1 "Processing Folder $counter/$foldersTot: \"$dirName\""

	# ============================================================================
	printHeading2 "Process Alan Adventures"
	# ============================================================================

	# ----------------------------------------------------------------------------
	printHeading3 "Compile Adventures"
	# ----------------------------------------------------------------------------
	pushd "$srcDir" > /dev/null
	rm -f *.a3c *.a3log
	for sourcefile in *.alan ; do
		compile $sourcefile
		if [ $? -ne 0 ] ; then
			printAborting ; exit 1
		fi
	done
	popd > /dev/null

	# ----------------------------------------------------------------------------
	printHeading3 "Run Commands Scripts"
	# ----------------------------------------------------------------------------

	for adventure in $srcDir/*.a3c ; do
		runCommandsScripts $adventure
	done

	# ----------------------------------------------------------------------------
	printHeading3 "Deploy Alan Source Files"
	# ----------------------------------------------------------------------------
	echo -e "Take every \".alan\" source file whose name doesn't start with an underscore,"
	echo -e "strip away AsciiDoc region-tag comments, and copy it to the destination folder."

	for file in $srcDir/[^_]*.alan ; do
		deployAlan $file
	done

	# ============================================================================
	printHeading2 "Build AsciiDoc Documentation"
	# ============================================================================

	# ----------------------------------------------------------------------------
	printHeading3 "Sanitize Game Transcripts"
	# ----------------------------------------------------------------------------

	echo -e "Reformat game transcripts from verbatim to AsciiDoc example blocks."

	for transcript in $srcDir/*.a3log ; do
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
