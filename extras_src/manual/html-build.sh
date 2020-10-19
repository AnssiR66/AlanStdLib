#!/bin/bash

# manual/html-build.sh    v0.0.4 | 2020/10/19 | by Tristano Ajmone, MIT License.
################################################################################
#                                                                              #
#                           BUILD STDLIB MANUAL HTML                           #
#                                                                              #
################################################################################
# Rebuild the StdLib Man (HTML) from AsciiDoc, without rebuilding the examples.

# NOTE: This is a temporary script, it was setup quickly and in a rather hackish
#       way just to be able to quickly update the HTML document without having
# 		to run "../update.sh", which compiles all the ALAN adventures at each
# 		run and takes ages. It will soon be replaced with a better script, as
# 		all the scripts will be, in due time ...

################################################################################
#                               SETUP & SETTINGS                               #
################################################################################
source ../../_assets/sh/init-env.sh  # Initialize work environment

export invoker="manual/html-build.sh"   # Used by some external scripts
################################################################################
#                                BANNER & INTRO                                #
################################################################################
printBanner "Build StdLib Manual HTML"

outDir=../../extras/manual
utfDir="$utfBasePath/manual"

for sourcefile in ./*.asciidoc ; do
adoc2html $sourcefile
if [ $? -ne 0 ] ; then
	printAborting ; exit 1
fi
done

printFinished

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
