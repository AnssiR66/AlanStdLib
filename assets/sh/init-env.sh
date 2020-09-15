#!/bin/bash
# ==============================================================================
# "assets/sh/init-env.sh" v1.0.1 | 2020/09/15 | by Tristano Ajmone
# Released into the Public Domain (https://unlicense.org)
# ------------------------------------------------------------------------------
# RUN ME WITH:
#   . ./init-env.sh
# OR WITH:
#   source ./init-env.sh
# ------------------------------------------------------------------------------

# This script prepends to $PATH the "./assets/sh/" folder in order to make the
# all the shell scripts and assets of that folder available to all scripts in
# the repository.
#
# This script was designed for (and tested under) Bash for Windows OS.
# ==============================================================================

# Get Absolute Path of "assets/sh/"
# =================================
# This will work even if this script is being sourced:
shAbsPath="$(dirname $(realpath ${BASH_SOURCE[0]}))"

if [[ -v AlanEnv ]] # Check if ALAN env was already initialized...
then
	echo -e "\e[30;1m----------------------------------------------------"
	echo -e "\e[30;1mALAN StdLib working environment already initialized!"
	echo -e "\e[30;1m----------------------------------------------------\e[0m"
else
	# Check that script is being sourced:
	if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
	then
		echo -e "\e[31;1m~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
		echo -e "\e[31;1m*** ERROR *** This script must be sourced!"
		echo -e "\e[31;1mInvoke it with: \e[33;3msource ./init-env.sh"
		echo -e "\e[31;1m~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\e[0m"
		exit 1
	fi
	echo -e "\e[32;1m------------------------------------------------"
	echo -e "\e[32;1mInitializing ALAN StdLib working environment ...\n"
	export PATH=$shAbsPath:$PATH
	export AlanEnv="Initialized"
	export ScriptsDir=$shAbsPath
	echo -e "\e[37;1mNow the scripts in the '/assets/sh/' folder will"
	echo -e "\e[37;1mbe available to all scripts."
	echo -e "\e[32;1m------------------------------------------------\e[0m"
fi
