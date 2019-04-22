# Sass Source Files

The Sass sources to build the custom CSS stylesheets for Alan StdLib documentation.

- Output CSS stylesheet: [`./styles.css`][styles.css].
- Output docinfo file: [`../adoc/docinfo.html`][docinfo file]


-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Folder Contents](#folder-contents)
    - [Sass Sources](#sass-sources)
    - [Build Scripts](#build-scripts)
- [Output Files](#output-files)
- [Usage Instructions](#usage-instructions)
    - [Production Work](#production-work)
    - [Sass Editing Work](#sass-editing-work)
- [System Requirements](#system-requirements)
    - [Installing Dart Sass](#installing-dart-sass)
- [Credits](#credits)
    - [Base16 Color Schemes](#base16-color-schemes)
    - [Base16 Sass](#base16-sass)
    - [Sass Boilerplate](#sass-boilerplate)

<!-- /MarkdownTOC -->

-----

# Folder Contents

- [`styles.css`][styles.css] — compiled stylesheet.

## Sass Sources

- [`styles.scss`][styles]
    + [`_base16-eighties.scss`][b16 80s]
    + [`_base16-google-dark.scss`][b16 Google]
    + [`_color-schemes.scss`][color-schemes]
    + [`_common.scss`][common]
    + [`_fonts-ligatures.scss`][ligatures]
    + [`_fonts.scss`][fonts]
    + [`_helpers.scss`][helpers]
    + [`_hl-adoc-template.scss`][hl adoc template]
    + [`_hl-reset.scss`][hl reset]
    + [`_hl-template-alan.scss`][hl template alan]
    + [`_hl-theme_alan-lib.scss`][hl alan lib]
    + [`_hl-theme_alan-tutorial.scss`][hl alan tut]

## Build Scripts

- [`_shared-settings.sh`][_shared-settings.sh] — defines env-vars common to all scripts.
- [`css-build.sh`][css-build.sh] — Builds the CSS stylesheet.
- [`docinfo-inject.sh`][docinfo-inject.sh] — Builds the CSS stylesheet and injects it into the [docinfo file].
- [`watch-sass.sh`][watch-sass.sh] — Watch and build Sass sources.

# Output Files

- [`./styles.css`][styles.css] — compiled stylesheet form SCSS sources.
- [`../adoc/docinfo.html`][docinfo file] — docinfo file with CSS injected into  `<head>` section.

# Usage Instructions

These are the Sass/SCSS sources for building the custom CSS stylesheets used in the Alan StdLib documentation, providing the required styles for code blocks highligthed with Highlight, as well as custom styles for game transcripts, and other custom elements.

The generated CSS file ([`./styles.css`][styles.css]) is injected into the docinfo file ([`../adoc/docinfo.html`][docinfo file]) so that every HTML document will be fully standalone.

This also means that updating the CSS and docinfo files won't affect the appearance of the HTML documents until they are converted again, for they no longer rely on an external stylesheet — the custom CSS is now in the document `<head>` section. 

## Production Work

To update the CSS stylesheets and propagate changes into the HTML documentation:

1. Execute [`docinfo-inject.sh`][docinfo-inject.sh].
2. Execute the scripts to rebuild the whole documentation.

## Sass Editing Work

To work on the Sass/SCSS sources and test the results, use either:

- [`css-build.sh`][css-build.sh]
- [`watch-sass.sh`][watch-sass.sh]

And to preview the resulting CSS changes, use the local test document (which relies on the external [`./styles.css`][styles.css] file).

> __TDB!__ — Currently there isn't a test document to test the CSS with. Will be added soon.

# System Requirements

Since March 14, 2019 this project has switched from using [Ruby Sass] to the newest [Dart Sass] because starting from March 26, 2019 Ruby Sass will no longer be maintained.

Since Dart Sass behavior is slightly different from Ruby Sass, anyone working on the repository Sass sources must ensure to switch to Dart Sass to avoid creating divergent CSS stylesheets.

## Installing Dart Sass

The easiest way to install Dart Sass on Windows, and keep it always updated, is to install it via Chocolatey:

- https://chocolatey.org/packages/sass


# Credits

## Base16 Color Schemes

The Sass/CSS themes use the following Base16 color schemes:

- _Base16 Eighties_ — by [Chris Kempson].
- _Base16 Google Dark_ — by [Seth Wright].

The *Base16* project was created by Chris Kempson:

- http://chriskempson.com/projects/base16/

## Base16 Sass

The following Base16 SCSS files:

- [`_base16-eighties.scss`][b16 80s]
- [`_base16-google-dark.scss`][b16 Google]

were taken from the *Base16 Sass* project by Tristano Ajmone:

- https://github.com/tajmone/Base16-Sass

released under MIT License.


```
MIT License

Copyright (c) 2019 Tristano Ajmone <tajmone@gmail.com>
https://github.com/tajmone/Base16-Sass

Copyright (c) 2012 Chris Kempson (http://chriskempson.com)
https://github.com/chriskempson/base16-builder

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


## Sass Boilerplate

- [`_helpers.scss`][helpers]

The `fontFace` Mixin was adapted from Sass Boilerplate project's "[`fontface.scss`][fontface]", Copyright (c) 2013 Peter Mescalchin, MIT License:
 
-  https://github.com/magnetikonline/sass-boilerplate

<!--  -->

    The MIT License (MIT)

    Copyright (c) 2013 Peter Mescalchin

    Permission is hereby granted, free of charge, to any person obtaining a copy of
    this software and associated documentation files (the "Software"), to deal in
    the Software without restriction, including without limitation the rights to
    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
    the Software, and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

<!-----------------------------------------------------------------------------
                               REFERENCE LINKS                                
------------------------------------------------------------------------------>

[_shared-settings.sh]: ./_shared-settings.sh "View script source"
[css-build.sh]: ./css-build.sh "View script source"
[docinfo-inject.sh]: ./docinfo-inject.sh "View script source"
[watch-sass.sh]: ./watch-sass.sh "View script source"

[docinfo file]: ../adoc/docinfo.html "View the target docinfo file"

<!-- SCSS/CSS files -->

[styles]: ./styles.scss "View SCSS source"
[styles.css]: ./styles.css "View source file"

[b16 80s]: ./_base16-eighties.scss "View SCSS source"
[b16 Google]: ./_base16-google-dark.scss "View SCSS source"
[color-schemes]: ./_color-schemes.scss "View SCSS file"
[common]: ./_common.scss "View SCSS file"
[fonts]: ./_fonts.scss "View SCSS file"
[helpers]: ./_helpers.scss "View SCSS file"
[hl adoc template]: ./_hl-adoc-template.scss "View SCSS source"
[hl alan lib]: ./_hl-theme_alan-lib.scss "View SCSS source"
[hl alan tut]: ./_hl-theme_alan-tutorial.scss "View SCSS source"
[hl reset]: ./_hl-reset.scss "View SCSS file"
[hl template alan]: ./_hl-template-alan.scss "View SCSS source"
[ligatures]: ./_fonts-ligatures.scss "View SCSS file"

<!-- dependencies -->

[Sass]: https://sass-lang.com "Visit Sass website"
[Ruby Sass]: https://github.com/sass/ruby-sass
[Dart Sass]: https://github.com/sass/dart-sass
[Choco Sass]: https://chocolatey.org/packages/sass

[Ruby]: https://www.ruby-lang.org
[RubyInstaller]: https://rubyinstaller.org/downloads/
[Choco Ruby]: https://chocolatey.org/packages/ruby

[Node.js]: https://nodejs.org/en/ "Visit Node.js downloads page"
[Choco Node]: https://chocolatey.org/packages/nodejs
[Choco Node LTS]: https://chocolatey.org/packages/nodejs-lts

[Chocolatey GUI]: https://chocolatey.org/packages/ChocolateyGUI
[Chocolatey]: https://chocolatey.org

<!-- external links -->

[fontface]: https://github.com/magnetikonline/sass-boilerplate/blob/702d924/fontface.scss "View upstream source file"

[base16-builder]: https://github.com/chriskempson/base16-builder

[Base16 Eighties]: https://github.com/chriskempson/base16-builder/blob/master/schemes/eighties.yml "View upstream source file"
[Base16 Google]: https://github.com/chriskempson/base16-builder/blob/master/schemes/google.yml "View upstream source file"

<!-- people -->

[Chris Kempson]: http://chriskempson.com "Visit Chris Kempson's website"
[Seth Wright]:   http://sethawright.com  "Visit Seth Wright's website"

<!-- EOF -->
