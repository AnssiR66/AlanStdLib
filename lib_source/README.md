# ALAN StdLib Sources

This directory contains the source files and assets required to build the final distribution files of the [`../lib_distro/`][lib_distro/] folder.

-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Directory Contents](#directory-contents)
- [Introduction](#introduction)
- [The Packaging Toolchain](#the-packaging-toolchain)
    - [Folders Organization](#folders-organization)
    - [Documentation Toolchain Details](#documentation-toolchain-details)
    - [Automation Benefits](#automation-benefits)
- [System Requirements](#system-requirements)

<!-- /MarkdownTOC -->

-----

# Directory Contents

- [`/docs/`][docs/] — library documentation sources:
    + [`/LibManual/`][LibManual/] — Sources for [`../lib_distro/docs/LibManual/`][lib_distro/docs/LibManual/]: _Standard Library User's Manual_ + examples.
    + [`/ClothingGuide/`][ClothingGuide/] — Sources for [`../lib_distro/docs/ClothingGuide/`][lib_distro/docs/ClothingGuide/]: _The Clothing Guide_ + examples.
- [`/StdLib/`][StdLib/] — Sources for [`../lib_distro/StdLib/`][lib_distro/StdLib/]: sanitized Standard Library files.
- [`_shared-attributes.adoc`][_shared-attributes.adoc] — attributes definitions for links, paths and assets, shared by multiple docs in this directory tree.
- [`CLOTHING_DEV.md`][CLOTHING_DEV.md] — new clothing system: temporary dev notes.
- [`CLOTHING_NEW.md`][CLOTHING_NEW.md] — new clothing system: draft presentation.


# Introduction

This directory tree was conceived to keep the package distribution folder (`../lib_distro/`) uncluttered from all the source files, assets and intermediate work files generated during the conversion process from AsciiDoc to HTML5, and to allow maintaining a "developer version" of ALAN source files (for the library, demos, etc.) containing special comments which are then stripped away in the final "end-user sanitized version".

To update all the contents of "`../lib_distro/`" open the terminal and type:

    rake docs library

To forcefully rebuild the entire documentation:

    rake docs library -B


# The Packaging Toolchain

The Asciidoctor toolchain to build the HTML documents and sanitize ALAN sources in the final distribution package is a bit complex, so we need to explain how it works.

## Folders Organization

The build process supports multiple folders in a symmetrical manner where each source folder in `lib_source/` is mirrored by a same-named destination folder in `lib_distro/`:

|                   source folder                    |                            build folder                            |                 description                  |
|----------------------------------------------------|--------------------------------------------------------------------|----------------------------------------------|
| [`lib_source/docs/ClothingGuide/`][ClothingGuide/] | [`lib_distro/docs/ClothingGuide/`][lib_distro/docs/ClothingGuide/] | _The Clothing Guide_  + examples.            |
| [`lib_source/docs/LibManual/`][LibManual/]         | [`lib_distro/docs/LibManual/`][lib_distro/docs/LibManual/]         | _Standard Library User's Manual_ + examples. |
| [`lib_source/StdLib/`][StdLib/]                    | [`lib_distro/StdLib/`][lib_distro/StdLib/]                         | Standard Library modules + license.          |


> **NOTE** — The _Alan Cookbook_ will also be added to the project at some point.


Any source assets residing in the root of `lib_source/` will be built into the root of `lib_distro/`.

Working with symmetrical source/destination folders greatly simplifies reusability of build scripts.


## Documentation Toolchain Details

The `Rakefile` carries out multiple tasks.
For a source folder `<foldername>` containing the AsciiDoc sources of a document, with relative ALAN examples and solution files:

1. __Compile Adventures__ — Compile every adventure inside the source folder.
2. __Generate AsciiDoc Transcripts__ — Run every compiled adventure against one or more `.a3s` command scripts whose name contains the adventure name (i.e. `<adv-name>*.a3s`) and save the transcript as an `.a3t-adoc` file (ignored by Git) after processing it via a custom Ruby module that converts the verbatim transcript into a well-formatted AsciiDoc example block:
    - Convert special characters (that could be interpreted as formatting) into its [predefined Asciidoctor attribute for replacement] equivalent (or its HTML entity equivalent, if no attribute is available).
    - Preserve hard line-breaks by adding a space and `+` at end-of-line, where required.
    - Style player input in emphasis.
    - Style comments in player input (`;`) via `[.comment]#`..`#`.
    - Hide region tags in player input via ADoc comments.
3. __Build HTML Docs__ — Convert every `*.asciidoc` document inside the source folder into a standalone HTML file in the destination folder `../lib_distro/<foldername>/`.
4. __Sanitize Alan Sources__ — Take every Alan source adventure whose name doesn't start with underscore (i.e. `[^_]*.alan`), strip away all [AsciiDoc region-tag comment lines], and copy it to the destination folder. In other words, underscored adventures are for internal documentation use _only_, while the others are (_also_) real examples for end users.

Not every folder requires all of the above tasks — some might contain only documentation sources, or only ALAN sources which need to be sanitized — but the above list describes the full potential of how the toolchain can handle a project folder.

For the `StdLib/` folder, the Rake task only sanitizes the library source modules by removing all comments containing AsciiDoc region-tags and other developer comments, so that the final library sources shipped to end users are free from any cluttering comments.

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

[lib_distro/]: ../lib_distro/ "Navigate to folder"

[docs/]: ./docs/ "Navigate to documentation source folder"

[ClothingGuide/]: ./docs/ClothingGuide/ "Navigate to folder"
[lib_distro/docs/ClothingGuide/]: ../lib_distro/docs/ClothingGuide/ "Navigate to folder"

[LibManual/]: ./docs/LibManual/ "Navigate to folder"
[lib_distro/docs/LibManual/]: ../lib_distro/docs/LibManual/ "Navigate to folder"

[StdLib/]: ./StdLib/ "Navigate to folder"
[lib_distro/StdLib/]: ../lib_distro/StdLib/ "Navigate to folder"

[_shared-attributes.adoc]: ./_shared-attributes.adoc "View source file"
[CLOTHING_DEV.md]: ./CLOTHING_DEV.md "View document"
[CLOTHING_NEW.md]: ./CLOTHING_NEW.md "View document"

<!-- dependencies -->

[Chocolatey GUI]: https://chocolatey.org/packages/ChocolateyGUI
[Chocolatey]: https://chocolatey.org

[Ruby]: https://www.ruby-lang.org
[RubyInstaller]: https://rubyinstaller.org/downloads/
[Choco Ruby]: https://chocolatey.org/packages/ruby

[Asciidoctor]: https://github.com/asciidoctor/asciidoctor#installation
[Rouge]: https://github.com/rouge-ruby/rouge "Visit Rouge repository"

<!-- Asciidoctor -->

[AsciiDoc region-tag comment lines]: https://asciidoctor.org/docs/user-LibManual/#by-tagged-regions "Read about tagged regions in Asciidoctor documentation"
[predefined Asciidoctor attribute for replacement]: https://asciidoctor.org/docs/user-LibManual/#charref-attributes  "Read Asciidoctor documentation on 'Predefined Attributes for Character Replacements'"

<!-- Wiki -->

[Dynamic Examples]: https://github.com/alan-if/alan-docs/wiki/Dynamic-Examples "Wiki Page: Dynamic Examples"

<!-- EOF -->
