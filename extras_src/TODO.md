# Extras Source Folder TODOs

List of pending tasks for `extras_src/`.


-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Before Release 2.2](#before-release-22)
    - [Asciidoctor Toolchain](#asciidoctor-toolchain)
    - [Sass/CSS](#sasscss)
    - [GitHub Export Rules](#github-export-rules)

<!-- /MarkdownTOC -->

-----

# Before Release 2.2

These tasks need to be solved before the upcoming StdLib 2.2 release.

## Asciidoctor Toolchain

- [x] Update __HighlightTreprocessor__ v1.3.0.


## Sass/CSS

- [ ] To make all tutorials full standalone, inject the CSS directly into the `docinfo.html` file.
- [x] Provide different Alan syntax themes for Library and tutorial code, to visually distinguish them.
- [x] __Transcript Styles__:
    + [x] add basic styles for transcripts,
    + [x] add styles for `#[comment]` elements.

## GitHub Export Rules

- [ ] __Define `export-ignore` rules__ in `.gitattributes` to exclude some files from the downloadable Zip archives of the repository (possibly also affects release):
    + [ ] Exclude `extras_src/`.

<!-----------------------------------------------------------------------------
                               REFERENCE LINKS                                
------------------------------------------------------------------------------>



<!-- EOF -->