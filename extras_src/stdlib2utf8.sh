#!/bin/bash

# stdlib2utf8.sh          v1.0.0 | 2020/09/15 | by Tristano Ajmone, MIT License.
################################################################################
#                                                                              #
#                       CONVERT LIBRARY SOURCE TO UTF-8                        #
#                                                                              #
################################################################################

source ../assets/sh/init-env.sh  # Initialize work environment
source _print-funcs.sh   # Ornamental print functions
source _build-funcs.sh   # Build and deploy functions

printHeading1 "Create UTF-8 Version of StdLib Sources"
echo -e "Because Asciidoctor can't handle inclusion of external files in ISO-8859-1"
echo -e "econding, we need to create UTF-8 versions of them."

# Define Source & Destination Folders
# -----------------------------------
srcDir="../StdLib" # path of AsciiDoc sources and Alan examples
utfDir="$utfBasePath/StdLib" # path of UTF-8 converted Alan files


# Delete Previously Converted Files
# ---------------------------------
rm -rf $utfDir
mkdir  $utfDir
touch  $utfDir/.gitkeep

# Convert Library Sources to UTF-8
# --------------------------------
for sourcefile in $srcDir/*.{alan,i} ; do
	alan2utf8 $sourcefile
	if [ $? -ne 0 ] ; then
		printAborting ; exit 1
	fi
done
# ------------------------------------------------------------------------------
# Don't print finish message if invoked by another script:
if ! [[ -v invoker ]]
	then printFinished
fi
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
