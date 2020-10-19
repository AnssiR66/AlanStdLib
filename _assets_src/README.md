# Assets Source Folder

This directory contains the source files to build some of the resources in the [`../_assets/`][_assets/] folder, needed by the build toolchain.

|       source dir      |          dest build dir          |                    description                     |
|-----------------------|----------------------------------|----------------------------------------------------|
| [`images/`][images/]  | [`../_assets/images/`][dest imgs] |                                                    |
| [`images/dia/`][dia/] | [`../_assets/images/`][dest imgs] | [Dia] projects for SVG diagrams                    |
| [`sass/`][sass/]      | [`../_assets/adoc/`][adoc/]       | [Sass] sources for CSS injection in `docinfo.html` |

<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

<!-- source directories -->

[images/]: ./images/ "Navigate to folder"
[dia/]: ./images/dia/ "Navigate to folder"
[sass/]: ./sass/ "Navigate to folder"

<!-- destinatrion build directories -->

[_assets/]: ../_assets/ "Navigate to '_assets/' folder"
[dest imgs]: ../_assets/images/ "Navigate to images assets build folder"
[adoc/]:  ../_assets/adoc/ "Navigate to AsciiDoctor assets build folder"

<!-- 3rd Party Tools -->

[Dia]: http://dia-installer.de "Visit Dia (Diagrams Editor) website"
[Sass]: https://sass-lang.com "Visit Sass website"

<!-- EOF -->
