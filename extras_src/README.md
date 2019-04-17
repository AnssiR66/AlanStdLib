# ALAN StdLib Extras: Sources & Assets

This folder ("`extras_src/`") contains the source files and assets required to build the documents inside the "`../extras/`" folder.


-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Introduction](#introduction)
    - [About the Toolchain](#about-the-toolchain)
    - [Automation Benefits](#automation-benefits)
- [Folder Contents](#folder-contents)
- [System Requirements](#system-requirements)
    - [Installing Ruby on Windows](#installing-ruby-on-windows)
    - [Installing Asciidoctor](#installing-asciidoctor)
- [Credits](#credits)
    - [Highlight Extension](#highlight-extension)
    - [Haml Templates](#haml-templates)

<!-- /MarkdownTOC -->

-----


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


# Folder Contents

- [`/alan/`][alan] — Alan source adventures and command scripts.
    + [`/utf8/`][utf8] (_ignored folder_) — UTF-8 converted Alan files (`*.alan`, `*.a3sol`, `*.a3log`).
- [`/haml/`][haml] — customized Haml templates.
- [`/sass/`][sass] — Sass/SCSS stylesheets source files.
- [`docinfo.html`][docinfo] — document docinfo file.
- [`highlight-treeprocessor_mod.rb`][rb] — extension for Highlight integration.
- [`update.sh`](update.sh) — the script to update contents of "`../extras/`".

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


# Credits

## Highlight Extension

The [`highlight-treeprocessor_mod.rb`][rb] file was adapted by Tristano Ajmone from the original file [`highlight-treeprocessor.rb`][rb upstream] taken from the [Asciidoctor Extensions Lab] (commit 18bdf62), Copyright (C) 2014-2016
The Asciidoctor Project, released under MIT License:

    The MIT License

    Copyright (C) 2018 Tristano Ajmone.
    Copyright (C) 2014-2016 The Asciidoctor Project

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.

## Haml Templates

The files inside the [`/haml/`][haml] folder were adapted by Tristano Ajmone from the original [Haml HTML5 templates] taken from the
[Asciidoctor Backends] project, Copyright (C) 2012-2016 Dan Allen and the Asciidoctor Project, released under MIT License:

    The MIT License
    
    Copyright (C) 2018 Tristano Ajmone.
    Copyright (C) 2012-2016 Dan Allen and the Asciidoctor Project

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.


<!-----------------------------------------------------------------------------
                               REFERENCE LINKS                                
------------------------------------------------------------------------------>

<!-- proj files -->

[haml]: ./haml "Navigate to folder"
[alan]: ./alan/ "Navigate to folder"
[utf8]: ./alan/utf8/ "Navigate to folder"
[sass]: ./sass/ "Navigate to folder"
[docinfo]: ./docinfo.html
[rb]: ./highlight-treeprocessor_mod.rb


<!-- dependencies -->

[Chocolatey GUI]: https://chocolatey.org/packages/ChocolateyGUI
[Chocolatey]: https://chocolatey.org

[Ruby]: https://www.ruby-lang.org
[RubyInstaller]: https://rubyinstaller.org/downloads/
[Choco Ruby]: https://chocolatey.org/packages/ruby

[Asciidoctor]: https://github.com/asciidoctor/asciidoctor#installation
[Highlight]: http://www.andre-simon.de/zip/download.php


<!-- third party -->

[rb upstream]: https://github.com/asciidoctor/asciidoctor-extensions-lab/blob/18bdf62/lib/highlight-treeprocessor.rb
[Asciidoctor Extensions Lab]: https://github.com/asciidoctor/asciidoctor-extensions-lab/ "Visit the Asciidoctor Extensions Lab project"

[Asciidoctor Backends]: https://github.com/asciidoctor/asciidoctor-backends "Visit the Asciidoctor Backends project"
[Haml HTML5 templates]: https://github.com/asciidoctor/asciidoctor-backends/tree/master/haml/html5

<!-- EOF -->
