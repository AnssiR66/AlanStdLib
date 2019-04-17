# Sass Source Files

This folder contains the Sass sources to build the custom CSS stylesheets for code blocks highligthed with Highlight.


-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Folder Contents](#folder-contents)
- [System Requirements](#system-requirements)
    - [Installing Dart Sass](#installing-dart-sass)
- [Credits](#credits)
    - [Base16 Color Schemes](#base16-color-schemes)
    - [Base16 Sass](#base16-sass)
    - [Sass Boilerplate](#sass-boilerplate)

<!-- /MarkdownTOC -->

-----

# Folder Contents

Sass sources:

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

Scripts:

- [`BUILD_SASS.bat`][BUILD] 
- [`WATCH_SASS.bat`][WATCH] 

Builds to [`../css/styles.css`][styles.css].

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

[BUILD]: ./BUILD_SASS.bat
[WATCH]: ./WATCH_SASS.bat

<!-- SCSS/CSS files -->

[styles]: ./styles.scss "View SCSS source"
[styles.css]: ../css/styles.css "View source file"

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
