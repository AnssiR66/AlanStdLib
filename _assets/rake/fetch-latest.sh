#!/bin/bash
# ==========================================================================
# Fetches latest version of Rake assets for Asciidoctor from ALAN-i18n repo.
# ==========================================================================

echo -e "\nFetching latest Rake assets from ALAN-i18n repository...\n\n"

upstream=https://raw.githubusercontent.com/alan-if/alan-i18n/main/_assets/rake
curl \
	-O "$upstream/alan.rb" \
	-O "$upstream/asciidoc.rb" \
	-O "$upstream/globals.rb"
