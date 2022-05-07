# ALAN StdLib Extras: Sources & Assets

This directory contains the source files and assets required to build the documents inside the [`../extras/`][extras/] folder.

-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Directory Contents](#directory-contents)
- [Introduction](#introduction)
- [The Documentation Toolchain](#the-documentation-toolchain)
    - [Folders Organization](#folders-organization)
    - [Toolchain Details](#toolchain-details)
    - [Automation Benefits](#automation-benefits)
- [System Requirements](#system-requirements)

<!-- /MarkdownTOC -->

-----

# Directory Contents

- [`/manual/`][manual/] — Sources for [`../extras/manual/`][extras/manual/] (_Standard Library User's Manual_).
- [`/tutorials/`][tutorials/] — Sources for [`../extras/tutorials/`][extras/tutorials/] (_The Clothing Guide_).
- [`_shared-attributes.adoc`][_shared-attributes.adoc] — attributes definitions for links, paths and assets, shared by all docs in this directory tree.


# Introduction

This directory tree was conceived to keep the "`../extras/`" folder uncluttered from all the source files, assets and intermediate work files generated during the conversion process from AsciiDoc to HTML5.

To update all the contents of "`../extras/`" open the terminal and type:

    rake docs

To forcefully rebuild the entire documentation:

    rake docs -B


# The Documentation Toolchain

The Asciidoctor toolchain to build the HTML documents is a bit complex, so we need to explain how it works.

## Folders Organization

The build process supports multiple documentation folders in a symmetrical manner where each source folder in `extras_src/` is mirrored by a same-named destination folder in `extras/`:

|             source folder             |               build folder               |                     description                      |
|---------------------------------------|------------------------------------------|------------------------------------------------------|
| [`extras_src/tutorials/`][tutorials/] | [`extras/tutorials/`][extras/tutorials/] | _The Clothing Guide_ and other standalone tutorials. |
| [`extras_src/manual/`][manual/]       | [`extras/manual/`][extras/manual/]       | _Alan Standard Library User's Manual_.               |

Soon, the _Alan Cookbook_ will also be added to the project.

Working with symmetrical source/destination folders greatly simplifies reusability of build scripts.

## Toolchain Details

The `Rakefile` carries out multiple tasks.
For every source documentation folder `<foldername>` (defined in `$foldersList`):

1. __Compile Adventures__ — Compile every adventure inside the source folder.
2. __Generate AsciiDoc Transcripts__ — Run every compiled adventure against one or more `.a3s` command scripts whose name contains the adventure name (i.e. `<adv-name>*.a3s`) and save the transcript as an `.a3t-adoc` file (ignored by Git) after processing it via a custom Ruby module that converts the verbatim transcript into a well-formatted AsciiDoc example block:
    - Convert special characters (that could be interpreted as formatting) into its [predefined Asciidoctor attribute for replacement] equivalent (or its HTML entity equivalent, if no attribute is available).
    - Preserve hard line-breaks by adding a space and `+` at end-of-line, where required.
    - Style player input in emphasis.
    - Style comments in player input (`;`) via `[.comment]#`..`#`.
    - Hide region tags in player input via ADoc comments.
3. __Build HTML Docs__ — Convert every `*.asciidoc` document inside the source folder into a standalone HTML file in the destination folder `../extras/<foldername>/`.
4. __Sanitize Alan Sources__ — Take every Alan source adventure whose name doesn't start with underscore (i.e. `$srcDir/[^_]*.alan`), strip away all [AsciiDoc region-tag comment lines], and copy it to the destination folder. In other words, underscored adventures are for internal documentation use _only_, while the others are (_also_) real examples for end users.

For more info, see the _[Dynamic Examples]_ article on the ALAN Docs Wiki.

## Automation Benefits

Being able to use tagged regions comments in Alan sources and transcripts facilitates selectively including parts of the code and transcripts, without having to worry about if line positions shift around in them.

The automation toolchain help maintaining always up to date the code and transcript shown in the documentation, for it will always mirror the actual code found in the examples sources, and the output of a real game session, since the transcripts are regenerated from a freshly compiled adventure each time.

So, even if the Library code changes, these changes will always be reflected into the documentation, without manual efforts. This is definitely worth the effort of setting up a slightly complex toolchain.

We call this technique "[Dynamic Examples]".

# System Requirements

To build the document from AsciiDoc to HTML you'll need to install the following tools:

- Bash for Windows
- [Ruby] + [Asciidoctor] + [Rouge]

For details on how to install the above dependencies, see the main README file.

<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

<!-- project files & folders -->

[extras/]: ../extras/ "Navigate to folder"

[tutorials/]: ./tutorials/ "Navigate to folder"
[extras/tutorials/]: ../extras/tutorials/ "Navigate to folder"

[manual/]: ./manual/ "Navigate to folder"
[extras/manual/]: ../extras/manual/ "Navigate to folder"

[_shared-attributes.adoc]: ./_shared-attributes.adoc "View source file"

<!-- dependencies -->

[Chocolatey GUI]: https://chocolatey.org/packages/ChocolateyGUI
[Chocolatey]: https://chocolatey.org

[Ruby]: https://www.ruby-lang.org
[RubyInstaller]: https://rubyinstaller.org/downloads/
[Choco Ruby]: https://chocolatey.org/packages/ruby

[Asciidoctor]: https://github.com/asciidoctor/asciidoctor#installation
[Rouge]: https://github.com/rouge-ruby/rouge "Visit Rouge repository"

<!-- Asciidoctor -->

[AsciiDoc region-tag comment lines]: https://asciidoctor.org/docs/user-manual/#by-tagged-regions "Read about tagged regions in Asciidoctor documentation"
[predefined Asciidoctor attribute for replacement]: https://asciidoctor.org/docs/user-manual/#charref-attributes  "Read Asciidoctor documentation on 'Predefined Attributes for Character Replacements'"

<!-- Wiki -->

[Dynamic Examples]: https://github.com/alan-if/alan-docs/wiki/Dynamic-Examples "Wiki Page: Dynamic Examples"

<!-- EOF -->
