#!/bin/bash
version="v1.0.0" ; revdate="2019/04/22"     # by Tristano Ajmone, public domain.
# ------------------------------------------------------------------------------
# This script requires Dart Sass to be installed on the system:
#      https://github.com/sass/dart-sass
#
# You can use Chocolatey to install Dart Sass and keep it updated:
#      https://chocolatey.org/packages/sass
# ------------------------------------------------------------------------------
echo -e "\e[94m=============================="
echo -e "\e[93mBuild CSS Stylesheet from SCSS"
echo -e "\e[94m==============================\e[97m"
echo -e "$version \e[90m   | by Tristano Ajmone"

. _shared-settings.sh
echo -e "\e[90m------------------------------"
echo -e "\e[90mSOURCE: \e[93m$srcSCSS"
echo -e "\e[90mOUTPUT: \e[93m$destCSS"
echo -e "\e[90m------------------------------\e[0m"
sass $srcSCSS $destCSS

# EOF #
