# Diagrams: Dia Sources

Source projects files to generate diagrams using [Dia].

-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Folder Contents](#folder-contents)
- [Build Process](#build-process)
- [System Requirements](#system-requirements)

<!-- /MarkdownTOC -->

-----


# Folder Contents

- [`build-svg.sh`](./build-svg.sh) — Build and depoly SVG imagess from Dia sources.
- `library-classes.dia` — StdLib classes diagram.
- `classes-diagram-palette.cifc` — Diagram colors palette ([ColorImpact 4]).


# Build Process

The `build-svg.sh` script will:

1. Invoke [Dia] to convert to SVG images all `*.dia` projects in this folder.
2. Optimize the generated SVGs, using the [SVGO] tool (Node.js).
3. Deploy them to [`../../../assets/images/`][assets/images/], where the diagrams become available to AsciiDoc sources.

Since all the genrated images are copied to `assets/images/`, all `*.svg` files in this folder are ignored by Git.

# System Requirements

In order to edit the diagram's sourcefile, or to run the scripts in this folder, you'll need to install [Dia Diagram Editor], a free and open source cross platform tool for editing diagrams:

- http://dia-installer.de

In order for the script to optimize the generated SVG images, you'll also need to install [SVGO]  (Node.js):

- https://www.npmjs.com/package/svgo

<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

[assets/images/]: ../../../assets/images/ "Naviate to folder"

<!-- 3rd Party Tools -->

[Dia]: http://dia-installer.de/ "Visit Dia's website"
[Dia Diagram Editor]: http://dia-installer.de/ "Visit Dia's website"

[SVGO]: https://www.npmjs.com/package/svgo "Visit SVGO page at NPM"

[ColorImpact 4]: https://tigercolor.com/ "Visit ColorImpact website"

<!-- EOF -->
