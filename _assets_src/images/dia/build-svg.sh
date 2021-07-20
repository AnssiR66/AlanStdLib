#!/bin/bash

# "build-svg.sh"                                 v2.0.0 | 2021/07/20 | Dia v0.97
# ------------------------------------------------------------------------------
# Written by Tristano Ajmone, released into the public domain via Unlicense:
#    http://unlicense.org/
# ------------------------------------------------------------------------------
# In order to run this script you'll need to install Dia Diagram Editor:
#    http://dia-installer.de
# ------------------------------------------------------------------------------
source ../../../_assets/sh/init-env.sh  # Initialize work environment

printBanner "Build and Deploy SVG Diagrams"
# ------------------------------------------------------------------------------
printHeading1 "Converting Dia Diagrams to SVG"

for diaSrc in ./*.dia ; do
	dia -n -t cairo-svg $diaSrc
done
# ------------------------------------------------------------------------------
printHeading1 "Optimizing SVG Diagrams"

svgo -f ./
# ------------------------------------------------------------------------------
printHeading1 "Deploying SVG Diagrams to Images Directory"

for diaSVG in ./*.svg ; do
	cp $diaSVG $ImagesDir/$diaSVG
done

printFinished
