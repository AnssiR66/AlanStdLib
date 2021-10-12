# Rake Helper Modules

Some custom Ruby modules for automating ALAN projects and repositories via Rake.

-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Folder Contents](#folder-contents)
- [About](#about)
- [Modules Usage](#modules-usage)
- [Modules Info](#modules-info)
    - [The Global Module](#the-global-module)
    - [The ALAN Module](#the-alan-module)
    - [The AsciiDoc Module](#the-asciidoc-module)
- [License](#license)
- [Reference Links](#reference-links)

<!-- /MarkdownTOC -->

-----

# Folder Contents

- [`alan.rb`][alan.rb] — ALAN helpers.
- [`asciidoc.rb`][asciidoc.rb] — Asciidoctor helpers.
- [`globals.rb`][globals.rb] — Rake helpers.
- [`LICENSE`][LICENSE] — MIT License.

# About

These modules are designed to simplify automating ALAN repositories via Rake.
They are still pretty much WIP and will be subject to frequent changes.

The final goal is to create a set of Rake modules that can be shared across all our ALAN repositories, covering all their needs with common interfaces, and then find a way to centralize these modules and share them with all the projects that need them, thus avoiding redundant maintenance work.

How and where these modules will be centralized and updated is still to be decided (Git submodule? Ruby Gem?), for the time being this repository will be their reference repository, since it was the first repository to adopt Rake.

# Modules Usage

To use these modules in other projects you'll need to `require` them in your `Rakefile`, in the following order:

```ruby
require './_assets/rake/globals.rb'
require './_assets/rake/alan.rb'
require './_assets/rake/asciidoc.rb'
```

# Modules Info

Summary info about the modules, their rationale, goals and methods.

For detailed info, please refer to their source files, the following descriptions are mostly intended to expand upon topics that are too lengthy to be mentioned in source comments.

## The Global Module

- [`globals.rb`][globals.rb]

> **TBD!**


## The ALAN Module

- [`alan.rb`][alan.rb]

---

`CreateTranscript(storyfile, solution)`

This method generates a transcript with the same base filename as the solution file, in a single step, like the shell command:

    arun -r adventure.a3c < testfile.a3s > testfile.a3t

By stripping the BOM from the `.a3s` file before piping it to ARun, it solves a problem that was afflicting the creation of transcripts in UTF-8, where the BOM from the solution file would end up in final transcript, before the first input command (see [alan-if/alan#32]).


## The AsciiDoc Module

- [`asciidoc.rb`][asciidoc.rb]

> **TBD!**


# License

The Ruby modules in this folder were created by Tristano Ajmone and released under the MIT License.

```
MIT License

Copyright (c) 2021 Tristano Ajmone

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

-----

# Reference Links

- [Rake website][Rake]
    + [Rakefile Format]
- [github.com/ruby/rake]
- [Wikipedia » Rake]

<!-- MarkdownTOC:excluded -->
## Ruby API

- [Ruby 3.0 API » FileUtils]
- [Ruby Std-lib 3.0.2 » Rake]
- [Ruby Std-lib 3.0.2 » Rake » FileUtils]

<!-- MarkdownTOC:excluded -->
## Rake Articles

- _[Using the Rake Build Language]_ — Martin Fowler.
- [FIELD NOTES: Using Rake to Automate Tasks] — by Stuart Ellis.
- _[The coolness that is Rake]_ — Joe White.
- _[Building with Rake]_ — slideshow by [Jim Weirich] (2003).


<!-- MarkdownTOC:excluded -->
## Rake Tutorials

[Jim Weirich]'s [Rake tutorials (2005)] (CC BY-NC 1.0) from [onestepback.org] via Wayback Machine:

- _[Getting Started]_
- _[Handling Common Actions]_
- _[Another C Example]_


[Avdi Grimm]'s Rake Tutorials:

1. [Files and Rules][Avdi Files and Rules]
1. [File Lists][Avdi File Lists]
1. [Rules][Avdi Rules]
1. [Pathmap][Avdi Pathmap]
1. [File Operations][Avdi File Operations]
1. [Clean and Clobber][Avdi Clean and Clobber]
1. [MultiTask][Avdi MultiTask]

<!-- MarkdownTOC:excluded -->
## Rake Video Tutorials

- _[Basic Rake]_ (31 min) — by [Jim Weirich].
- _[Goruco 2012 Power Rake]_ (46 min) — by [Jim Weirich].

<!-- MarkdownTOC:excluded -->
## Rake Books

- _[Rake Task Management Essentials]_ — by Andrey Koleshko, 2014.

<!-- MarkdownTOC:excluded -->
## ALAN Repos

- [Alan Docs » Discussions » `rake` label][AlanDocs Disc rake]


<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

<!-- project files -->

[alan.rb]: ./alan.rb "View Ruby module"
[asciidoc.rb]: ./asciidoc.rb "View Ruby module"
[globals.rb]: ./globals.rb "View Ruby module"
[LICENSE]: ./LICENSE "View MIT License"

<!-- ALAN Manual -->

[arun switches]: https://alan-if.github.io/alan-docs/manual-beta/manual.html#_interpreter_switches "ALAN Manual » §A.4. Interpreter Switches"

<!-- Rake -->

[Rake]: https://ruby.github.io/rake/ "Rake (Ruby Make) website"
[Rakefile Format]: https://ruby.github.io/rake/doc/rakefile_rdoc.html
[github.com/ruby/rake]: https://github.com/ruby/rake "Rake repository at GitHub"

[Wikipedia » Rake]: https://en.wikipedia.org/wiki/Rake_(software) "Wikipedia page on Rake"

[onestepback.org]: https://onestepback.org

<!-- Ruby API -->

[Ruby Std-lib 3.0.2 » Rake]:https://ruby-doc.org/stdlib-3.0.2/libdoc/rake/rdoc/
[Ruby Std-lib 3.0.2 » Rake » FileUtils]: https://ruby-doc.org/stdlib-3.0.2/libdoc/rake/rdoc/FileUtils.html
[Ruby 3.0 API » FileUtils]: https://rubyapi.org/3.0/o/fileutils

<!-- Rake articles -->

[FIELD NOTES: Using Rake to Automate Tasks]: https://www.stuartellis.name/articles/rake/
[Using the Rake Build Language]: https://martinfowler.com/articles/rake.html
[The coolness that is Rake]: https://blog.excastle.com/2006/09/05/the-coolness-that-is-rake/
[Building with Rake]: https://web.archive.org/web/20140220214827/http://www.onestepback.org/articles/buildingwithrake/index.html

<!-- Jim Weirich Tutorials -->

[Rake tutorials (2005)]: https://web.archive.org/web/20140220214314/https://www.onestepback.org/index.cgi/Tech/Rake/Tutorial
[Getting Started]: https://web.archive.org/web/20140220202215/http://onestepback.org/index.cgi/Tech/Rake/Tutorial/RakeTutorialIntroduction.rdoc
[Handling Common Actions]: https://web.archive.org/web/20140220202125/http://onestepback.org/index.cgi/Tech/Rake/Tutorial/RakeTutorialRules.red
[Another C Example]: https://web.archive.org/web/20140220202128/http://onestepback.org/index.cgi/Tech/Rake/Tutorial/RakeTutorialAnotherCExample.red

<!-- Avdi Tutorials -->

[Avdi Files and Rules]: https://avdi.codes/rake-part-1-basics/
[Avdi File Lists]: https://avdi.codes/rake-part-2-file-lists-2/
[Avdi Rules]: https://avdi.codes/rake-part-3-rules/
[Avdi Pathmap]: https://avdi.codes/rake-part-4-pathmap/
[Avdi File Operations]: https://avdi.codes/rake-part-5-file-operations/
[Avdi Clean and Clobber]: https://avdi.codes/rake-part-6-clean-and-clobber/
[Avdi MultiTask]: https://avdi.codes/rake-part-7-multitask/

<!-- Video Tutorials -->

[Basic Rake]: https://amara.org/en/videos/wg3cI6Nxjuxg/info/basic-rake-by-jim-weirich/
[Goruco 2012 Power Rake]: https://amara.org/en/videos/GxlygXn6h8SB/info/goruco-2012-power-rake-by-jim-weirich/

<!-- Rake Books -->

[Rake Task Management Essentials]: https://www.packtpub.com/product/rake-task-management-essentials/9781783280773

<!-- ALAN Repos -->

[AlanDocs Disc rake]: https://github.com/alan-if/alan-docs/discussions?discussions_q=label%3A%22%3Ahammer%3A+Rake%22 "All Alan-Docs discussions labelled 'rake'"

<!-- Issues/Discussion -->

[alan-if/alan#32]: https://github.com/alan-if/alan/issues/32 "Issue #32 — BUG: ARun w/ UTF-8 BOM Solution Files"

<!-- people -->

[Avdi Grimm]: https://github.com/avdi "View Avdi Grimm's GitHub profile"
[Jim Weirich]: https://en.wikipedia.org/wiki/Jim_Weirich "Wikipedia » Jim Weirich"

<!-- EOF -->
