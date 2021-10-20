#!/bin/bash
# ===========================================================================
# Fetches latest version of Rouge assets for Asciidoctor from ALAN Docs repo.
# ===========================================================================

echo -e "\nFetching latest Rouge assets from ALAN-Docs repository...\n\n"

upstream=https://raw.githubusercontent.com/alan-if/alan-docs/master/_assets/rouge

curl \
	-O "$upstream/alan3.rb" \
	-O "$upstream/custom-rouge-adapter.rb" \
	-O "$upstream/docinfo.html"

if [[ $(uname -s) == MINGW* ]];then
	unix2dos docinfo.html
fi
