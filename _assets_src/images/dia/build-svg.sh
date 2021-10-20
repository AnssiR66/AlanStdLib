#!/bin/bash

# "build-svg.sh"                                 v2.0.1 | 2021/10/27 | Dia v0.97
# ------------------------------------------------------------------------------
# Written by Tristano Ajmone, released into the public domain via Unlicense:
#    http://unlicense.org/
# ------------------------------------------------------------------------------
# In order to run this script you'll need to install Dia Diagram Editor:
#    http://dia-installer.de
# ------------------------------------------------------------------------------

ImagesDir="../../../_assets/images"

echo -e "#####################################"
echo -e "##  Build and Deploy SVG Diagrams  ##"
echo -e "#####################################\n"

echo -e "## Converting Dia Diagrams to SVG"
echo -e "#################################"

for diaSrc in ./*.dia ; do
	dia -n -t cairo-svg $diaSrc
done

echo -e "\n## Optimizing SVG Diagrams"
echo -e   "##########################"

svgo -f ./

echo -e "\n## Deploying SVG Diagrams to Images Directory"
echo -e   "#############################################"

for diaSVG in ./*.svg ; do
	cp $diaSVG $ImagesDir/$diaSVG
done

echo -e "\n/// Done ///"
