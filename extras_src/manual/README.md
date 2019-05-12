# Standard Library User's Manual

Porting the _Alan Standard Library v2.1 User's Manual_ from PDF to AsciiDoc, and updating its contents to the upcoming v2.2 of the Library.

- [`../../ALAN Library2.1 manual.pdf`][Man PDF]

-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Folder Contents](#folder-contents)
- [Document Status](#document-status)

<!-- /MarkdownTOC -->

-----


# Folder Contents

This file contains the unprocessed text from the automatically converted document:

- [`_unprocessed.adoc`](./_unprocessed.adoc)
 
One section at the time, its contents are added to the ported document and roughly restructured in order to obtain a working document:

- [`StdLibMan.asciidoc`](./StdLibMan.asciidoc) — main document that imports all the chapters of the Manual:
    + [`StdLibMan_01.adoc`](./StdLibMan_01.adoc) — 1. _Introduction_
    + [`StdLibMan_02.adoc`](./StdLibMan_02.adoc) — 2. _What is different in v2.x?_
    + [`StdLibMan_03.adoc`](./StdLibMan_03.adoc) — 3. _Locations_
    + [`StdLibMan_04.adoc`](./StdLibMan_04.adoc) — 4. _Things_
    + [`StdLibMan_05.adoc`](./StdLibMan_05.adoc) — 5. _Actors_
    + [`StdLibMan_06.adoc`](./StdLibMan_06.adoc) — 6. _Objects_
    + [`StdLibMan_07.adoc`](./StdLibMan_07.adoc) — 7. _Additional attributes for THINGs: (NOT) distant, (NOT) reachable, scenery_
    + [`StdLibMan_08.adoc`](./StdLibMan_08.adoc) — 8. _Using verbs and commands_

# Document Status

Currently the document is WIP draft, the original PDF document was converted to AsciiDoc but most paragraphs are broken, some text was lost during conversion, and all styles were lost in the process.

It must be manually fixed, paragraph by paragraph, using the original PDF as a reference to copying-&-paste broken paragraphs and visually inspect missing styles.

| ch. |                                     title                                      |  status |
|-----|--------------------------------------------------------------------------------|---------|
|   1 | _Introduction_                                                                 | DRAFT   |
|   2 | _What is different in v2.x?_                                                   | DRAFT   |
|   3 | _Locations_                                                                    | DRAFT   |
|   4 | _Things_                                                                       | DRAFT   |
|   5 | _Actors_                                                                       | DRAFT   |
|   6 | _Objects_                                                                      | DRAFT   |
|   7 | _Additional attributes for THINGs: (NOT) distant, (NOT) reachable, scenery_    | pending |
|   8 | _Using verbs and commands_                                                     | pending |
|   9 | _Adding synonyms for existing library words (verbs, object and actor classes)_ | pending |
|  10 | _The `my_game` instance and its attributes_                                    | pending |
|  11 | _Have the game banner show at the start_                                       | pending |
|  12 | _Runtime messages_                                                             | pending |
|  13 | _Default attributes used in the standard library_                              | pending |
|  14 | _Translating to other languages_                                               | pending |
|  15 | _Short examples_                                                               | pending |


<!-----------------------------------------------------------------------------
                               REFERENCE LINKS                                
------------------------------------------------------------------------------>

[Man PDF]: ../../ALAN%20Library2.1%20manual.pdf "View the original PDF Manual"


<!-- EOF -->