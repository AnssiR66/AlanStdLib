# Rake Helper Modules

Some custom Ruby modules for automating ALAN projects and repositories via Rake.

Taken from the [alan-i18n] repository.

-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Folder Contents](#folder-contents)
- [About](#about)
    - [Usage Instructions](#usage-instructions)
    - [Updating](#updating)
    - [Editing](#editing)
- [License](#license)

<!-- /MarkdownTOC -->

-----

# Folder Contents

- [`alan.rb`][alan.rb] — ALAN helpers.
- [`asciidoc.rb`][asciidoc.rb] — Asciidoctor helpers.
- [`globals.rb`][globals.rb] — Rake helpers.
- [`fetch-latest.sh`][fetch-latest.sh] — download latest Rake modules from ALAN-i18n via cURL.
- [`LICENSE`][LICENSE] — MIT License.


# About

These modules are shared by various ALAN repositories and projects, they are not specific to the StdLib repository.
Their upstream version is hosted at the [alan-i18n] repository.

## Usage Instructions

For more info on these modules and their usage, see their README file at the upstream [alan-i18n] repository.

## Updating

To update the modules, execute the [`fetch-latest.sh`][fetch-latest.sh] script in Bash (requires cURL), which will fetch their latest version from the upstream repository (`main` branch).

The script was tested under Windows 10 using Git's Bash and Windows' native cURL binary.

## Editing

These Rake modules must always be copies of those found on the upstream [alan-i18n] repository.

Don't update these modules without first notifying the maintainers of [alan-i18n], to coordinate changes in a way that works for all other repositories using these modules, especially in case of breaking changes that would require updating the `Rakefile` of all ALAN projects that depend on these modules.

Furthermore, before editing the modules you should run [`fetch-latest.sh`][fetch-latest.sh] to ensure you're editing the latest versions.
After changes are accepted in this repository, they must be uploaded to the upstream repository in order to keep them synchronized.


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

<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

[alan-i18n]: https://github.com/alan-if/alan-i18n/tree/main/_assets/rake "View upstream files at the ALAN Internationalization repository"

<!-- project files -->

[alan.rb]: ./alan.rb "View Ruby module"
[asciidoc.rb]: ./asciidoc.rb "View Ruby module"
[globals.rb]: ./globals.rb "View Ruby module"
[fetch-latest.sh]: ./fetch-latest.sh "View source script"
[LICENSE]: ./LICENSE "View MIT License"

<!-- EOF -->
