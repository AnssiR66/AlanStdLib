# Diagrams: Dia Sources

![dia version info][dia badge]

Source projects files to generate diagrams using [Dia].

    /_assets/images/dia/


-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Folder Contents](#folder-contents)
- [Build Process](#build-process)
- [System Requirements](#system-requirements)
    - [Dia Diagram Editor](#dia-diagram-editor)
    - [SVGO](#svgo)
    - [Fonts](#fonts)

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
3. Deploy them to [`../../../_assets/images/`][_assets/images/], where the diagrams become available to AsciiDoc sources.

Since all the genrated images are copied to `_assets/images/`, all `*.svg` files in this folder are ignored by Git.

# System Requirements

## Dia Diagram Editor

In order to edit the diagram's source projects, or to run the conversion script, you'll need to install [Dia Diagram Editor], a free and open source cross platform tool for editing diagrams.

To build the SVG files, you'll need __Dia v0.97__.
For more info and instructions, refer to our Wiki:

- https://github.com/alan-if/alan-docs/wiki/Dia-Diagrams

## SVGO

- https://www.npmjs.com/package/svgo

To build the diagrams via [`build-svg.sh`](./build-svg.sh), you'll also need to install [SVGO], a command line SVG optimizer.

In order to install SVGO you'll need to install [Node.js] on your system.

Windows users can install [Node.js] via the [Node JS Chocolatey package] using the [Chocolatey GUI], which simplifies keeping Node always up to date.

## Fonts

In order to build the diagrams, you'll also need to install the following fonts on your machine:

- _[Open Sans]_ — by Steve Matteson, [Apache License 2.0].

Ensure you download the fonts in TTF, and that you install their basic styles (Regular, Bold, Italic, Bold+Italic).

<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

[Apache License 2.0]: https://www.apache.org/licenses/LICENSE-2.0 "View the Apache License version 2.0"

[_assets/images/]: ../../../_assets/images/ "Naviate to folder"

<!-- Dia -->

[Dia]: http://dia-installer.de/ "Visit Dia's website"
[Dia Diagram Editor]: http://dia-installer.de/ "Visit Dia's website"
[dia badge]: https://img.shields.io/badge/Dia-0.97-brightgreen

<!-- SVGO -->

[SVGO]: https://www.npmjs.com/package/svgo "SVGO homepage at NPM"
[Node.js]: https://nodejs.org/ "Visit Node.js website"
[Node JS Chocolatey package]: https://community.chocolatey.org/packages/nodejs "Node.js package at Chocolatey"

[Chocolatey GUI]: https://community.chocolatey.org/packages/ChocolateyGUI "Chocolatey GUI package at Chocolatey"
[Chocolatey]: https://chocolatey.org "Visit Chocolatey website"


<!-- 3rd Party Tools -->

[ColorImpact 4]: https://tigercolor.com/ "Visit ColorImpact website"

<!-- Fonts -->

[Open Sans]: https://fonts.google.com/specimen/Open+Sans


<!-- EOF -->
