#!/bin/bash

# build-docinfo.sh        v1.0.1 | 2020/10/19 | by Tristano Ajmone, MIT License.
################################################################################
#                                                                              #
#                BUILD CUSTOM CSS AND INJECT IT IN DOCINFO FILE                #
#                                                                              #
################################################################################
# This script will build from Sass sources our custom CSS for syntax coloring
# ALAN code blocks, then inject the CSS in the `docinfo.html` file inside the
# `../../_assets/adoc/` folder, shared by all AsciiDoc generated HTML docs.
# ------------------------------------------------------------------------------
# This script requires Dart Sass to be installed on the system:
#      https://github.com/sass/dart-sass
#
# You can use Chocolatey to install Dart Sass and keep it updated:
#      https://chocolatey.org/packages/sass
# ------------------------------------------------------------------------------

################################################################################
#                               SETUP & SETTINGS                               #
################################################################################
if ! [[ -v AlanEnv ]]; then # If ALAN env is not already initialized:
	source ../../_assets/sh/init-env.sh  # Initialize the work environment
fi

srcSCSS="./styles.scss"           # SCSS input source file.
destCSS="./styles.css"            # path to CSS output file.
docinfo="$ADocDir/docinfo.html"   # path to docinfo output file.
################################################################################
#                                BANNER & INTRO                                #
################################################################################
printBanner "Build Custom CSS from Sass and Inject It into Docinfo File"
################################################################################
#                           COMPILE SASS/SCSS TO CSS                           #
################################################################################
printHeading1 "Build CSS Stylesheet from SCSS"
printSeparator
echo -e "\e[90mSOURCE: \e[93m$srcSCSS"
echo -e "\e[90mOUTPUT: \e[93m$destCSS"
printSeparator
sass $srcSCSS $destCSS
################################################################################
#                              BUIL DOCINFO FILE                               #
################################################################################
printHeading1 "Inject CSS Stylesheet into Docinfo File"
echo -e "\e[90mDOCINFO: \e[93m$docinfo\e[0m"

echo "<style>"   > $docinfo
cat $destCSS    >> $docinfo
echo "</style>" >> $docinfo
# ------------------------------------------------------------------------------
# if OS is Windows normalize EOL to CRLF (because bash uses LF)
# ------------------------------------------------------------------------------
if [[ $(uname -s) == MINGW* ]];then
	printHeading2 "Normalize EOL to CRLF"
	echo "Because OS is Windows, normalize EOL to CRLF in docinfo file."
	normalizeEOL "$docinfo"
fi

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
