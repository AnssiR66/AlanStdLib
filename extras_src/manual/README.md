# Standard Library User's Manual

Porting the _Alan Standard Library v2.1 User's Manual_ from PDF to AsciiDoc, and updating its contents to the upcoming `v2.2.0` of the Library.

- [`../../ALAN Library2.1 manual.pdf`][Man PDF]

-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Folder Contents](#folder-contents)
    - [Examples and Transcripts](#examples-and-transcripts)
    - [Internal Examples](#internal-examples)
- [Document Status](#document-status)

<!-- /MarkdownTOC -->

-----


# Folder Contents

The entire original PDF was ported to AsciiDoc, split into one file per chapter, and currently being re-organized in a new book structure divided into parts.

Currently the AsciiDoc sources are organized in the following way, but will be changing often during the final editing stages:

- [`StdLibMan.asciidoc`][man] — main document that imports all other sources of the Manual:
    + [`StdLibMan-inc_attributes.adoc`][inc_attr] — custom attributes definitions.
    + [`StdLibMan0_intro.adoc`][man0] — _Introduction_
    + [`StdLibMan1.adoc`][man1] — PART I — __Getting Started__
        * [`StdLibMan1_01.adoc`][man1_1] — _Importing the Library_
        * [`StdLibMan1_02.adoc`][man1_2] — _Library Overview_
        * [`StdLibMan1_03.adoc`][man1_3] — _The Game Banner_
        * [`StdLibMan1_04.adoc`][man1_4] — _Adding Synonyms_
        * [`StdLibMan1_05.adoc`][man1_5] — _Default Library Attributes_
    + [`StdLibMan3.adoc`][man3] — PART II — __Library Attributes__
        * [`StdLibMan2_01.adoc`][man2_1] — _Introduction_
        * [`StdLibMan2_02.adoc`][man2_2] — _Custom Descriptions_
        * [`StdLibMan2_03.adoc`][man2_3] — (Additional THINGs Attributes)
    + [`StdLibMan3.adoc`][man3] — PART III — __Library Classes__
        * [`StdLibMan3_01.adoc`][man3_1] — _Introduction_
        * [`StdLibMan3_02.adoc`][man3_2] — _Locations_
        * [`StdLibMan3_03.adoc`][man3_3] — _Actors_
        * [`StdLibMan3_04.adoc`][man3_4] — _Special Objects_
        * [`StdLibMan3_05.adoc`][man3_5] — _Working With Classes_
    + [`StdLibMan4.adoc`][man4] — PART IV — __Library Verbs__
        * [`StdLibMan4_01.adoc`][man4_1] — _Introduction_
        * [`StdLibMan4_02.adoc`][man4_2] — _Verbs List_
            - [`StdLibMan-inc_table_verbs.dsv`][inc_verbs] — DSV (delimiter-separated values) data table of library defined verbs.
        * [`StdLibMan4_03.adoc`][man4_3] — _Verbs and Things_
        * [`StdLibMan4_04.adoc`][man4_4] — _Working with Verbs_
        * [`StdLibMan4_05.adoc`][man4_5] — _Restricted Actions_
    + [`StdLibMan5.adoc`][man5] — PART V — __Library Messages__
        * [`StdLibMan5_01.adoc`][man5_1] — _Runtime Messages_
        * [`StdLibMan5_02.adoc`][man5_2] — _Library Messages_
    + [`StdLibManA.adoc`][manA] — __Appendices__
        * [`StdLibManA_01.adoc`][manA_1] — _Translating to Other Languages_
        * [`StdLibManA_02.adoc`][manA_2] — _Short Examples_


> **NOTE** — The above list might not always reflect the latest status of the actual library sources, because the book is undergoing rapid transformations in view of the upcoming `v2.2.0` release, and I won't be able to update the above list until I've completed reorganizing the various chapters and sections, and their titles.


## Examples and Transcripts

In order to ensure that the code and transcript examples in the Manual always represent the current state of the library, real source adventures and game transcripts are employed — which the toolchain compiles and runs against solution files (i.e. commands scripts).

We try to keep the number of source adventures and transcripts down to the minimum, packing together as many examples as possible into the same adventure — by creating multiple locations, and making a smart use of Asciidoctor tagged regions in both Alan sources and transcripts.

During conversion, these source adventures will be stripped of all the comment lines for AsciiDoc tag regions and then copied to the `extras/manual/` folder, so that end users can access the source code of the Manual examples — except for adventures with filenames starting with `_` (see below).

Because the Manual often illustrates multiple ways to do the same thing, separate files are required to host these variations (otherwise the Alan compiler will complain about instances being defined multiple times).
Therefore, some adventures will have variations in the form `<adventure1>.alan`,  `<adventure2>.alan`, etc. (for as many variations as required), along with their associated `<adventureX>.a3log` files.

## Internal Examples

Adventures sources starting with underscore (`_*.alan`, `_*.i`) _will not_ be deployed (copied) to `extras/manual/` for end-users consumption, but only used internally for building the documentation.

These internal-use-only adventures contain all those code snippets that don't need to be included in the distributed code examples — e.g. hypothetical code alternatives that end users are not supposed to use, like the alternative verbose code that would be required if there wasn't a given library feature, and other similar code _minutiae_ or trivia provided for information purposes only.

The reason why we're externalizing these code snippets to real adventure files, instead of just keeping them as text inside a `[source]` block, is to ensure that these code snippets are valid code — just like all other examples, they'll be compiled and tested against solution files. As time passes and both ALAN and the StdLib evolve, it's easy to forget about loose code snippets in the Manual, which might have become outdated and incompatible in the meantime.

We want to ensure that _every single line of code_ provided in the documentation is valid code that would compile with the current ALAN and StdLib versions, and there's no better way to achieve this than using real ALAN code which gets processed each time the Manual is rebuilt.

# Document Status

Currently the document is WIP draft, the original PDF document was converted to AsciiDoc but all styles were lost in the process, and paragraphs and code need to be reformatted properly.

It must be manually fixed, element by element, using the original PDF as a visual reference for missing styles.

<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

[Man PDF]: ../../ALAN%20Library2.1%20manual.pdf "View the original PDF Manual"

<!-- Manual ADoc sources -->

[man]: ./StdLibMan.asciidoc
[man0]: ./StdLibMan0_intro.adoc

[man1]: ./StdLibMan1.adoc
[man1_1]: ./StdLibMan1_01.adoc
[man1_2]: ./StdLibMan1_02.adoc
[man1_3]: ./StdLibMan1_03.adoc
[man1_4]: ./StdLibMan1_04.adoc
[man1_5]: ./StdLibMan1_05.adoc

[man2]: ./StdLibMan2.adoc
[man2_1]: ./StdLibMan2_01.adoc
[man2_2]: ./StdLibMan2_02.adoc
[man2_3]: ./StdLibMan2_03.adoc

[man3]: ./StdLibMan3.adoc
[man3_1]: ./StdLibMan3_01.adoc
[man3_2]: ./StdLibMan3_02.adoc
[man3_3]: ./StdLibMan3_03.adoc
[man3_4]: ./StdLibMan3_04.adoc
[man3_5]: ./StdLibMan3_05.adoc

[man4]: ./StdLibMan4.adoc
[man4_1]: ./StdLibMan4_01.adoc
[man4_2]: ./StdLibMan4_02.adoc
[man4_3]: ./StdLibMan4_03.adoc
[man4_4]: ./StdLibMan4_04.adoc
[man4_5]: ./StdLibMan4_05.adoc

[man5]: ./StdLibMan5.adoc
[man5_1]: ./StdLibMan5_01.adoc
[man5_2]: ./StdLibMan5_02.adoc

[manA]: ./StdLibManA.adoc
[manA_1]: ./StdLibManA_01.adoc
[manA_2]: ./StdLibManA_02.adoc

[inc_attr]: ./StdLibMan-inc_attributes.adoc "View the source file with custom attributes definitions"

[inc_verbs]: ./StdLibMan-inc_table_verbs.dsv "View the DSV data table of the StdLib verbs"

<!-- EOF -->
