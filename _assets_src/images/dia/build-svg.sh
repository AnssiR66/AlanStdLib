#!/bin/bash

# "build-svg.sh"                               v1.0.1 | 2020/10/19 | Dia v0.97.2
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
	dia -n -t svg $diaSrc
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
