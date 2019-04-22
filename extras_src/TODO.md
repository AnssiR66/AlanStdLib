# Extras Source Folder TODOs

List of pending tasks for `extras_src/`.


-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Before Release 2.2](#before-release-22)
    - [Subfolder ADoc Assets](#subfolder-adoc-assets)
    - [Group Docs by Folders](#group-docs-by-folders)
    - [Asciidoctor Toolchain](#asciidoctor-toolchain)
    - [Sass/CSS](#sasscss)
        - [Standalone Docs via Embedded CSS](#standalone-docs-via-embedded-css)
    - [GitHub Export Rules](#github-export-rules)

<!-- /MarkdownTOC -->

-----

# Before Release 2.2

These tasks need to be solved before the upcoming StdLib 2.2 release.

## Subfolder ADoc Assets

To keep the directory more organized, move all Asciidoctor assets into `adoc/`:

- [x] `adoc/docinfo.html`
- [x] `adoc/haml/`
- [x] `adoc/highlight-treeprocessor_mod.rb`
- [x] Update `update.sh` accordingly.
- [x] Update `README.md`.

## Group Docs by Folders

Because we'll be also converting the _StdLib Manual_ and the _Alan Cookbook_ to AsciiDoc, we need to organize documents sources and output into individual subfolders.

For example:

|     doc name    |              sources              |          output          |
|-----------------|-----------------------------------|--------------------------|
| tutorials       | `/extras_src/docs/tutorials/`     | `/extras/tutorials/`     |
| _StdLib Manual_ | `/extras_src/docs/StdLib-Manual/` | `/extras/StdLib-Manual/` |
| _Alan Cookbook_ | `/extras_src/docs/Cookbook/`      | `/extras/Cookbook/`      |

Where the `/tutorials/` folder will host _The Clothing Guide_ and its examples, and any other future tutorials.

We also need to mirror the above structure in the temporary folders for Alan sources and their intermediate UTF-8 versions:

- `utf8/tutorials/`
- `utf8/StdLib-Manual/`
- `utf8/Cookbook/`

The current `update.sh` script need to be broken into a common script with all the functions and helpers to build any document folder, and the actual files to build each folder:

|           file          |                       description                        |
|-------------------------|----------------------------------------------------------|
| `_shared-docs-funcs.sh` | Importable script with common custom funcs and base vars |
| `build_tutorials.sh`    | Builds the `tutorials/` folder only                      |
| `build_libmanual.sh`    | Builds the `StdLib-Manual/` folder only                  |
| `build_cookbook.sh`     | Builds the `Cookbook/` folder only                       |

The `_shared-docs-funcs.sh` will define some vars to determine the base paths for all build operations, making it easy to realign the scripts with renamed projects folders by tweaking a single shell variable (used to build the path vars used by the various convert and deploy functions).

- [ ] Update `extras_src/.gitignore` accordingly.

## Asciidoctor Toolchain

- [x] Update __HighlightTreprocessor__ v1.3.0.


## Sass/CSS

- [x] Provide different Alan syntax themes for Library and tutorial code, to visually distinguish them.
- [x] __Transcript Styles__:
    + [x] add basic styles for transcripts,
    + [x] add styles for `#[comment]` elements.

### Standalone Docs via Embedded CSS

- [x] To make all tutorials full standalone, inject the CSS directly into the `docinfo.html` file.
- [ ] Add a test document that uses the external CSS file to allow testing live editing of Sass sources.

If on the one hand this makes all docs portable, it also hinders maintainance — for when editing the Sass sources you need to rebuild all the docs, even to just preview changes, which makes using Sass watch functionality pretty useless.

Because of this, we need to add in the `sass/` folder a test document that uses the external CSS file, so we can test the Sass tweaks live when editing them. 

## GitHub Export Rules

- [x] __Define `export-ignore` rules__ in `.gitattributes` to exclude some files from the downloadable Zip archives of the repository (possibly also affects release):
    + [x] Exclude `extras_src/`.

<!-----------------------------------------------------------------------------
                               REFERENCE LINKS                                
------------------------------------------------------------------------------>



<!-- EOF -->