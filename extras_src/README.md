# ALAN StdLib Extras: Sources & Assets

This folder ("`extras_src/`") contains the source files and assets required to build the documents inside the "`../extras/`" folder.


-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Directory Contents](#directory-contents)
- [Introduction](#introduction)
    - [About the Toolchain](#about-the-toolchain)
    - [Automation Benefits](#automation-benefits)
- [System Requirements](#system-requirements)
    - [Installing Ruby on Windows](#installing-ruby-on-windows)
    - [Installing Asciidoctor](#installing-asciidoctor)

<!-- /MarkdownTOC -->

-----


# Directory Contents

- [`/alan/`][alan] — Alan source adventures and command scripts.
    + [`/utf8/`][utf8] (_ignored folder_) — UTF-8 converted Alan files (`*.alan`, `*.a3sol`, `*.a3log`).
- [`/adoc/`][adoc] — Asciidoctor assets:
    + [`/haml/`][haml] — customized Haml templates.
    + [`docinfo.html`][docinfo] — commonly shared docinfo file.
    + [`highlight-treeprocessor_mod.rb`][rb] — extension for Highlight integration.
- [`/sass/`][sass] — Sass/SCSS stylesheets source files.
- [`update.sh`](update.sh) — the script to update contents of "`../extras/`".

# Introduction

This directory tree was conceived to keep the "`../extras/`" folder uncluttered from all the source files, assets and intermediate work files generated during the conversion process from AsciiDoc to HTML5.

By running the [`update.sh`](update.sh) script inside this folder, all the contents of "`../extras/`" will be automatically updated.

## About the Toolchain

The `update.sh` script carries out quite a number of tasks:

1. __Compile Adventures__ — Compile every adventure inside `alan/` folder.
2. __Generate Transcripts__ — Run every compiled adventure against one or more `.a3sol` command scripts whose name contains the adventure name (i.e. `<adv-name>*.a3sol`) and save the transcript as an `.a3log` file.
3. __Sanitize Files Encoding__ — Create inside the `alan/utf8/` folder (ignored by Git) an UTF-8 converted copy of every ISO-8859-1 Alan source (`*.alan`) and transcript (`*.a3log`) in `alan/`, so that they might be directly includable in AsciiDoc ([Asciidoctor doesn't support ISO-8859-1 files]).
4. __Sanitize & Style Transcipts__ — Convert every `.a3log` file inside `alan/utf8/` to `.a3ADocLog`, converting the verbatim transcript into a well-formatted AsciiDoc example block:
    - Convert special characters (that could be interpreted as formating) into its [predefined Asciidoctor attribute for replacement] equivalent (or its HTML entity equivalent, if no attribute is available).
    - Preserve hard line-breaks by adding ` +` at end-of-line, where required.
    - Style player input in emphasis.
    - Style comments in player input (`;`) via `#[comment]`..`#`.
    - Hyde region tags in player input via ADoc comments.
5. __Build HTML Docs__ — Convert every `*.asciidoc` document inside this folder into a standalone HTML file inside "`../extras/`".
6. __Sanitize Alan Sources__ — Create in "`../extras/`" a copy of every Alan source from "`alan/`", but stripped of all [AsciiDoc region-tag comment lines].

[Asciidoctor doesn't support ISO-8859-1 files]: https://github.com/asciidoctor/asciidoctor/issues/3248 "Read Issue #3248 for more info on this"
[AsciiDoc region-tag comment lines]: https://asciidoctor.org/docs/user-manual/#by-tagged-regions "Read about tagged regions in Asciidoctor documentation"
[predefined Asciidoctor attribute for replacement]: https://asciidoctor.org/docs/user-manual/#charref-attributes  "Read Asciidoctor documentation on 'Predefined Attributes for Character Replacements'"

## Automation Benefits

Being able to use tagged regions comments in Alan sources and transcripts facilitates selectively including parts of the code and transcripts, without having to worry about if line positions shift around in them.

The automation toolchain help maintaining always up to date the code and transcript shown in the documentation, for it will always mirror the actual code found in the examples sources, and the output of a real game session, since the transcripts are regenerated from a freshly compiled adventure each time.

So, even if the Library code changes, these changes will always be reflected into the documentation, without manual efforts. This is definitely worth the effort of setting up a slightly complex toolchain.


# System Requirements

To build the document from AsciiDoc to HTML you'll need to install the following tools:

- Bash for Windows
- [Highlight]
- [Ruby] + [Asciidoctor]

## Installing Ruby on Windows

If you're using Windows, you should install Ruby via [RubyInstaller], which is also available as a [Chocolatey package][Choco Ruby] (see [Chocolatey] and [Chocolatey GUI]).

## Installing Asciidoctor

Once Ruby is installed on your system, open a shell and type:

    gem install asciidoctor



<!-----------------------------------------------------------------------------
                               REFERENCE LINKS                                
------------------------------------------------------------------------------>

<!-- proj folders -->

[adoc]: ./adoc "Navigate to the Asciidoctor assets folder"
[haml]: ./adoc/haml "Navigate to folder"
[alan]: ./alan/ "Navigate to folder"
[utf8]: ./alan/utf8/ "Navigate to folder"
[sass]: ./sass/ "Navigate to folder"

<!-- proj files -->

[docinfo]: ./adoc/docinfo.html
[rb]: ./adoc/highlight-treeprocessor_mod.rb


<!-- dependencies -->

[Chocolatey GUI]: https://chocolatey.org/packages/ChocolateyGUI
[Chocolatey]: https://chocolatey.org

[Ruby]: https://www.ruby-lang.org
[RubyInstaller]: https://rubyinstaller.org/downloads/
[Choco Ruby]: https://chocolatey.org/packages/ruby

[Asciidoctor]: https://github.com/asciidoctor/asciidoctor#installation
[Highlight]: http://www.andre-simon.de/zip/download.php


<!-- EOF -->