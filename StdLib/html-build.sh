#!/bin/bash

# StdLib/html-build.sh    v0.0.2 | 2020/09/27 | by Tristano Ajmone, MIT License.
################################################################################
#                                                                              #
#                            BUILD STDLIB HTML DOCS                            #
#                                                                              #
################################################################################
# Convert frin AsciiDoc to HTML the various documents in "StdLib/" folder.

# NOTE: This is a temporary script that needs to be improved when the toolachin
# 		scripts will be revisited and optimized.

################################################################################
#                               SETUP & SETTINGS                               #
################################################################################
if ! [[ -v AlanEnv ]]; then # If ALAN env is not already initialized:
	source ../assets/sh/init-env.sh  # Initialize the work environment
fi

export invoker="manual/html-build.sh"   # Used by some external scripts
################################################################################
#                                BANNER & INTRO                                #
################################################################################
printBanner "Build Misc. StdLib Docs to HTML"

outDir=./
adocDir="../extras_src/adoc"
hamlDir="$adocDir/haml"
utfDir="utf8/manual"

for sourcefile in ./*.asciidoc ; do
adoc2html $sourcefile
if [ $? -ne 0 ] ; then
	printAborting ; exit 1
fi
done

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
