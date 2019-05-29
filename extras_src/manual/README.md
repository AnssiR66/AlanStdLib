# Standard Library User's Manual

Porting the _Alan Standard Library v2.1 User's Manual_ from PDF to AsciiDoc, and updating its contents to the upcoming v2.2 of the Library.

- [`../../ALAN Library2.1 manual.pdf`][Man PDF]

-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Folder Contents](#folder-contents)
    - [Examples and Transcripts](#examples-and-transcripts)
- [Document Status](#document-status)

<!-- /MarkdownTOC -->

-----


# Folder Contents

The entire original PDF was ported to AsciiDoc and split into one file per chapter:

- [`StdLibMan.asciidoc`](./StdLibMan.asciidoc) — main document that imports all the chapters of the Manual:
    + [`StdLibMan_01.adoc`](./StdLibMan_01.adoc) — 1. _Introduction_
    + [`StdLibMan_02.adoc`](./StdLibMan_02.adoc) — 2. _What is different in v2.x?_
    + [`StdLibMan_03.adoc`](./StdLibMan_03.adoc) — 3. _Locations_
    + [`StdLibMan_04.adoc`](./StdLibMan_04.adoc) — 4. _Things_
    + [`StdLibMan_05.adoc`](./StdLibMan_05.adoc) — 5. _Actors_
    + [`StdLibMan_06.adoc`](./StdLibMan_06.adoc) — 6. _Objects_
    + [`StdLibMan_07.adoc`](./StdLibMan_07.adoc) — 7. _Additional attributes for THINGs: (NOT) distant, (NOT) reachable, scenery_
    + [`StdLibMan_08.adoc`](./StdLibMan_08.adoc) — 8. _Using verbs and commands_
    + [`StdLibMan_09.adoc`](./StdLibMan_09.adoc) — 9. _Adding synonyms for existing library words (verbs, object and actor classes)_
    + [`StdLibMan_10.adoc`](./StdLibMan_10.adoc) — 10. _The `my_game` instance and its attributes_
    + [`StdLibMan_11.adoc`](./StdLibMan_11.adoc) — 11. _Have the game banner show at the start_
    + [`StdLibMan_12.adoc`](./StdLibMan_12.adoc) — 12. _Runtime messages_
    + [`StdLibMan_13.adoc`](./StdLibMan_13.adoc) — 13. _Default attributes used in the standard library_
    + [`StdLibMan_14.adoc`](./StdLibMan_14.adoc) — 14. _Translating to other languages_
    + [`StdLibMan_15.adoc`](./StdLibMan_15.adoc) — 15. _Short examples_

## Examples and Transcripts

In order to ensure that the code and transcript examples in the Manual always represent the current state of the library, real source adventures and game transcripts are employed — which the toolchain compiles and runs against solution files (i.e. commands scripts).

Adventures sources (`*.alan`, `*.i`), solution files (`*.a3sol`) and transcripts  (`*.a3log`) starting with underscore will not be deployed (copied) to the output folder, but only used internally for building the documentation.

We try to keep the number of source adventures and transcripts down to the minimum, by packing together as many examples as possible into the same adventure — by creating multiple locations, and making a smart use of Asciidoctor tagged regions in both Alan sources and transcripts.

Because the Manual often illustrates multiple ways to do the same thing, separate files are required to host these variations (otherwise the Alan compiler will complain about instances being defined multiple times).

Examples showing one way to implement something:

- [`_variations1.alan`](./_variations1.alan)
- [`_variations1.a3sol`](./_variations1.a3sol)
- [`_variations1.a3log`](./_variations1.a3log) (ignored by Git)

Examples showing another way to implement the same thing:

- [`_variations2.alan`](./_variations2.alan)
- [`_variations2.a3sol`](./_variations2.a3sol)
- [`_variations2.a3log`](./_variations2.a3log) (ignored by Git)



# Document Status

Currently the document is WIP draft, the original PDF document was converted to AsciiDoc but all styles were lost in the process, and paragraphs and code need to be reformatted properly.

It must be manually fixed, element by element, using the original PDF as a visual reference for missing styles.

| ch. |                                     title                                      | status |
|-----|--------------------------------------------------------------------------------|--------|
|   1 | _Introduction_                                                                 | DRAFT  |
|   2 | _What is different in v2.x?_                                                   | DRAFT  |
|   3 | _Locations_                                                                    | DRAFT  |
|   4 | _Things_                                                                       | DRAFT  |
|   5 | _Actors_                                                                       | DRAFT  |
|   6 | _Objects_                                                                      | DRAFT  |
|   7 | _Additional attributes for THINGs: (NOT) distant, (NOT) reachable, scenery_    | DRAFT  |
|   8 | _Using verbs and commands_                                                     | DRAFT  |
|   9 | _Adding synonyms for existing library words (verbs, object and actor classes)_ | DRAFT  |
|  10 | _The `my_game` instance and its attributes_                                    | DRAFT  |
|  11 | _Have the game banner show at the start_                                       | DRAFT  |
|  12 | _Runtime messages_                                                             | DRAFT  |
|  13 | _Default attributes used in the standard library_                              | DRAFT  |
|  14 | _Translating to other languages_                                               | DRAFT  |
|  15 | _Short examples_                                                               | DRAFT  |


<!-----------------------------------------------------------------------------
                               REFERENCE LINKS                                
------------------------------------------------------------------------------>

[Man PDF]: ../../ALAN%20Library2.1%20manual.pdf "View the original PDF Manual"


<!-- EOF -->