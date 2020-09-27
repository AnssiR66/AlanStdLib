#!/bin/bash
# ==============================================================================
# "assets/sh/init-env.sh" v1.0.3 | 2020/09/27 | by Tristano Ajmone
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

if [[ -v AlanEnv ]]; then # Check if ALAN env was already initialized...
	echo -e "\e[30;1m----------------------------------------------------"
	echo -e "\e[30;1mALAN StdLib working environment already initialized!"
	echo -e "\e[30;1m----------------------------------------------------\e[0m"
	return 0
else
	# Check that script is being sourced:
	if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
		echo -e "\e[31;1m~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
		echo -e "\e[31;1m*** ERROR *** This script must be sourced!"
		echo -e "\e[31;1mInvoke it with: \e[33;3msource ./init-env.sh"
		echo -e "\e[31;1m~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\e[0m"
		exit 1
	fi
fi
# ==============================================================================
#                          INITIALIZE WORK ENVIRONMENT
# ==============================================================================
echo -e "\e[32;1m=============================================================================="
echo -e "\e[32;1mInitializing ALAN StdLib working environment ..."
echo -e "\e[32;1m------------------------------------------------------------------------------"
export invoker="init-env.sh"   # Used by some external scripts
# ==============================================================================
# Source Functions Scripts
# ==============================================================================
# Render our custom shell functions available to all other scripts.
# ------------------------------------------------------------------------------
# We must first obtain the path to the folder of `init-env.sh`, even if it's
# being sourced by other scripts:
ScriptsDir="$(dirname $(realpath ${BASH_SOURCE[0]}))"
# Now we can safely source other scripts in this folder:
source $ScriptsDir/_print-funcs.sh 	# Ornamental print functions
source $ScriptsDir/_build-funcs.sh 	# Build and deploy functions

## PRINT REPORT
echo -e "\e[32;1mThe following scripts were sourced:"
echo -e "\e[33;1m   _print-funcs.sh"
echo -e "\e[33;1m   _build-funcs.sh"
echo -e "\e[32;1m$HyphensLine"
# ==============================================================================
# Export Env-Vars with Absolute Paths to Special Directories
# ==============================================================================
# We need to provide the various scripts in the repository with env-vars that
# point to the absolute path of some often-used special directories.
#
# The following methods will work even if this script is being sourced and the
# current working directory is unknown.
# ------------------------------------------------------------------------------

# /assets/sh/ -> $ScriptsDir
# ==========================
export ScriptsDir # (already defined above)

# / -> $RepoRoot
# ==============
export RepoRoot=$(git rev-parse --show-toplevel)
if [[ $(uname -s) == MINGW* ]];then # Amend Obtained Path:
	# --------------------------------------------------------------------------
	# Under Windows we must fix the path returned by Git, which has a different
	# format for the drive unit compared to Bash (e.g. "D:/" vs "/d/")
	# --------------------------------------------------------------------------
	RepoRoot="${RepoRoot/:/}"	# Remove the ":"
	RepoRoot="/${RepoRoot,}"	# Drive unit to lowercase
fi

## PRINT REPORT
###############
arr="\e[32;1m->\e[34;1m"
echo -e "\e[32;1mThese variables point to absolute repo paths (short paths shown here):"
echo -e "\e[33;1m   \$RepoRoot   $arr /"
echo -e "\e[33;1m   \$ScriptsDir $arr ${ScriptsDir#$RepoRoot}/"
echo -e "\e[32;1m$HyphensLine"
# ==============================================================================
# Prepend to PATH Special Directories
# ==============================================================================
export PATH=$ScriptsDir:$PATH

## PRINT REPORT
###############
# We'll be showing the added paths relatively to repo's root, by subtracting
# $RepoRoot from the full absolute paths of each added directory...
echo -e "\e[32;1mThese repo directories were prepended to the PATH:"
echo -e "\e[33;1m   ${ScriptsDir#$RepoRoot}/"

export AlanEnv="Initialized"
echo -e "\e[32;1m$EqualsLine\e[0m"
return 0
