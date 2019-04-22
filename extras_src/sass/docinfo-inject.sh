#!/bin/bash
version="v1.0.0" ; revdate="2019/04/22"     # by Tristano Ajmone, public domain.
# ------------------------------------------------------------------------------
# This script requires Dart Sass to be installed on the system:
#      https://github.com/sass/dart-sass
#
# You can use Chocolatey to install Dart Sass and keep it updated:
#      https://chocolatey.org/packages/sass
# ------------------------------------------------------------------------------

################################################################################
#                              ENV-VARS SETTINGS                               #
################################################################################
# Load setting from commonly shared file:
. _shared-settings.sh

# where the following settings env-vars are defined:
# 
#   $srcSCSS = SCSS input source file. 
#   $destCSS = path to CSS output file. 
#   $docinfo = path to docinfo output file.

################################################################################
#                            FUNCTIONS DEFINITIONS                             #
################################################################################
function Heading1 {
  # ----------------------------------------------------------------------------
  # Print a yellow frame around text of $1, and center it.
  # ----------------------------------------------------------------------------
  echo -e "\e[93m******************************************************************************"
  printf  "\e[94m%*s\n" $(((${#1}+78)/2)) "$1"
  echo -e "\e[93m******************************************************************************\e[97m"
}

function Heading2 {
  # ----------------------------------------------------------------------------
  # Print a blue frame around text of $1.
  # ----------------------------------------------------------------------------
  echo -e "\e[94m=============================================================================="
  echo -e "\e[95m$1"
  echo -e "\e[94m==============================================================================\e[97m" 
}

################################################################################
#                                  MAIN CODE                                   #
################################################################################

Heading1 "Build Sass and Inject CSS into docinfo File"
echo -e "\e[97mby Tristano Ajmone, public domain.                         $version | $revdate"

# ------------------------------------------------------------------------------

Heading2 "Build CSS stylesheet from SCSS"
echo -e "\e[90mSOURCE: \e[93m$srcSCSS"
echo -e "\e[90mOUTPUT: \e[93m$destCSS\e[0m"
sass $srcSCSS $destCSS

# ------------------------------------------------------------------------------

Heading2 "Inject CSS stylesheet in docinfo File"
echo -e "\e[90mDOCINFO: \e[93m$docinfo\e[0m"

echo "<style>"   > $docinfo
cat $destCSS    >> $docinfo
echo "</style>" >> $docinfo

# ------------------------------------------------------------------------------
# if OS is Windows normalize EOL to CRLF (because bash uses LF)
# ------------------------------------------------------------------------------

if [[ $(uname -s) == MINGW* ]];then
  Heading2 "Normalize EOL to CRLF"
  echo "Because OS is Windows, normalize EOL to CRLF in docinfo file."
  echo -e "\e[90mUNIX2DOS: \e[93m$docinfo"
  unix2dos -q $docinfo
fi

# EOF #
