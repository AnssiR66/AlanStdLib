# Alan StdLib Assets: Shell Scripts

This folder contains shared scripts required by the project and its toolchain.

    /_assets/sh/

-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Folder Contents](#folder-contents)
- [About the Scripts](#about-the-scripts)

<!-- /MarkdownTOC -->

-----

# Folder Contents

The Bash scripts contained in this folder:

- [`_build-funcs.sh`][buildF] — ornamental print functions.
- [`_print-funcs.sh`][printF] — documentation build functions.
- [`init-env.sh`][init] — working environment initializer.
- [`sanitize_a3log.sed`][san_a3log] — convert an Alan transcript into a well-formed ADoc example bloc

# About the Scripts

These scripts were all written and tested under/for the Bash for Windows that ships with Git.
Some of them might need to slightly adjusted in order to work under the native Shell/Bash that ships with other OSs (feel free to create an Issue if you encounter a problem, or create a PR if you wish to contribute fixes).


-------------------------------------------------------------------------------


<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

<!-- files -->

[buildF]: ./_build-funcs.sh "View script source"
[printF]: ./_print-funcs.sh "View script source"
[init]: ./init-env.sh "View script source"
[san_a3log]: ./sanitize_a3log.sed "View script source"

<!-- EOF -->
