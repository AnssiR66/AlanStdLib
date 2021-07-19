#!/bin/bash

# _build-funcs.sh         v3.0.0 | 2021/07/19 | by Tristano Ajmone, MIT License.
################################################################################
#                                                                              #
#                        DOCUMENTATION BUILD FUNCTIONS                         #
#                                                                              #
################################################################################
# Defines build and conversion settings and functions shared by all scripts.

# +--------------------+---------------+---------------------------------+
# | function name      | params        | description                     |
# +--------------------+---------------+---------------------------------+
# | normalizeEOL       | file          | Enforce CRLF EOL on Windows OS. |
# | compile            | file, options | Compile an Alan adventure.      |
# | runCommandsScripts | storyfile     | Run ".a3s" files -> ".a3t".     |
# | a3logSanitize      | file          | Reformat ".a3t" to AsciiDoc     |
# | adoc2html          | file          | Conv AsciiDoc -> HTML.          |
# | deployAlan         | file          | Strip and deploy ".alan" files. |
# +--------------------+---------------+---------------------------------+

# ** IMPORTANT! **
# You need to "source ./init-env.sh" before loading this scirpt, becasue some
# functions herein defined depend on environment vars defined by the former.

# If ALAN env is not initialized, abort:
if ! [[ -v AlanEnv ]] && [[ $invoker != "init-env.sh" ]]; then
	echo -e "\e[31;1m~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo -e "\e[31;1m*** ERROR *** You must source \"init-env.sh\""
	echo -e "\e[31;1mto use the \"_build-funcs.sh\" script."
	echo -e "\e[31;1m~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\e[0m"
	return 1
fi


################################################################################
#                                   SETTINGS                                   #
################################################################################
# NOTE: All paths are relative to the folder of this script.

shopt -s nullglob # Set nullglob to avoid patterns matching null files

# Base Paths for Source & Destination
srcBasePath="."
outBasePath="../extras"

# This script expects the following settings env-vars to be defined elsewhere:
#
# - $AlanCompileOpts -> Alan compiler options
# - $ADocDir         -> path to Asciidoctor assets
# - $HamlDir         -> path to Haml templates

# ******************************************************************************
# *                                                                            *
# *                              GENERAL PURPOSE                               *
# *                                                                            *
# ******************************************************************************

function normalizeEOL {
	# ============================================================================
	# if OS is Windows normalize EOL to CRLF (because sed uses LF)
	# ----------------------------------------------------------------------------
	# Parameters:
	# - $1: the file to normalize.
	# ============================================================================
	if [[ $(uname -s) == MINGW* ]];then
		echo -e "\e[90mUNIX2DOS: \e[94m$1"
		unix2dos -q $1
	fi
}

# ******************************************************************************
# *                                                                            *
# *                                 ALAN TASKS                                 *
# *                                                                            *
# ******************************************************************************

function compile {
	# ============================================================================
	# Compile an Alan adventure
	# ----------------------------------------------------------------------------
	# Parameters and Env Vars:
	# - $1: the source adventure to compile.
	# - $AlanCompileOpts: compiler options.
	# ============================================================================
	printSeparator
	echo -e "\e[90mCOMPILING: \e[93m$srcDir/$1"
	alan $AlanCompileOpts $1 > /dev/null 2>&1 || (
		echo -e "\n\e[91m*** COMPILER ERROR!!! ********************************************************"
		alan $AlanCompileOpts $1
		echo -e "\e[91m$AsterisksLine\e[97m"
		cmd_failed="true"
		return 1
	)
}

function runCommandsScripts {
	# ============================================================================
	# Given a target Alan adventure "<advname>.a3c", execute it against every
	# command script in the folder with a filename matching "<advname>*.a3s" and
	# save the game transcript to "<advname>*.a3t".
	# ----------------------------------------------------------------------------
	# Parameters:
	# - $1: the target Alan adventure (".a3c").
	# ============================================================================
	scriptsPattern="${1%.*}*.a3s"
	printSeparator
	echo -e "\e[90mADVENTURE: \e[93m$1"
	for script in $scriptsPattern ; do
		transcript="${script%.*}.a3t"
		echo -e "\e[90mPLAY WITH: \e[94m$script"
		arun.exe -r $1 < $script > $transcript
	done
}

# ******************************************************************************
# *                                                                            *
# *                                ASCIIDOCTOR                                 *
# *                                                                            *
# ******************************************************************************

function a3logSanitize {
	# ============================================================================
	# Take a game transcript input file $1 "<filename>.a3t" and pass it to a
	# SED filter that applies substitutions to turn it into a well formatted
	# AsciiDoc example block.
	# ----------------------------------------------------------------------------
	# Parameters:
	# - $1: the target transcript file.
	# Required scripts:
	# - ./sanitize_a3log.sed
	# ============================================================================
	printSeparator
	echo -e "\e[90mSANITIZE: \e[93m$1"
	sed -i -E --file=$ScriptsDir/sanitize_a3log.sed $1
	normalizeEOL $1
}

function adoc2html {
	# ============================================================================
	# Convert file $1 from AsciiDoc to HTML via Asciidoctor. Requires Highlight
	# for syntax highlighting code. Custom CSS via docinfo file.
	# ----------------------------------------------------------------------------
	# Parameters:
	# - $1: the input AsciiDOc file to convert.
	# Required Env Vars:
	# - $outDir: path of output directory.
	# - $HamlDir: path to Haml templates.
	# - $ADocDir: path to Asciidoctor custom extensions.
	# ============================================================================
	printSeparator
	echo -e "\e[90mCONVERTING: \e[93m$1"
	asciidoctor \
		--verbose \
		--safe-mode unsafe \
		--destination-dir $outDir \
		--template-dir $HamlDir \
		--require $ADocDir/highlight-treeprocessor_mod.rb \
		-a imagesdir=$ImagesDir \
		-a source-highlighter=highlight \
		-a docinfodir=$ADocDir \
		-a docinfo@=shared-head \
		-a data-uri \
			$1
}

function deployAlan {
	# ============================================================================
	# Takes the Alan source file of $1, and creates in $outDir a copy stripped of
	# all region-tag comment lines.
	# ----------------------------------------------------------------------------
	# Parameters:
	# - $1: the input Alan source adventure file to deploy.
	# Required Env Vars:
	# - $outDir: path of output directory.
	# ============================================================================
	outfile="$outDir/$(basename $1)"
	printSeparator
	echo -e "\e[90mSOURCE FILE: \e[93m$1"
	echo -e "\e[90mDESTINATION: \e[94m$outfile"
	sed -r '/^ *-- *(tag|end)::/ d' $1 > $outfile
	normalizeEOL $outfile
}

# EOF #
