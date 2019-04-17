# Test Suite TODOs

Pending tasks to improve the test suite.


-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Test Suite](#test-suite)
    - [`AlanV` in Test Adventures](#alanv-in-test-adventures)
    - [Debug Module](#debug-module)
- [EGA Clothing](#ega-clothing)
- [House](#house)
- [Misc Folder](#misc-folder)

<!-- /MarkdownTOC -->

-----

# Test Suite

Changes affecting the whole test suite.

## `AlanV` in Test Adventures

I need to consider if it's worth keeping in the adventures source the header line that overrides the Alan version (`AlanV` of `DEFINITION_BLOCK`).

This adds the extra burden of having to change `AlanV` in every test adventure when we bump up Alan SDK version. But on the other hand it provides an accurate reference of the version used. ... Not sure if it should be kept or dropped.


## Debug Module

- [`inc_debug.i`][inc_debug]
- [`DEBUG_MODULE.md`][DEBUG_MODULE]

The new debug module adds useful verbs exploitable in any commands script.

- [ ] Include the new debug module in all test adventures:
    + [x] `tests/clothing/ega.alan`
    + [ ] `tests/house/house.alan`
    + [ ] ... more ...

<!---------------------------------------------------------------------------->

# EGA Clothing

- [`/clothing/`][clothing]

Changes concerning the __EGA__ (Emporium Giorgio Alani) test adventure in [`/clothing/`][clothing].


- [ ] __REDEFINE LAYERS__ — redesign the clothing layers numbering, dropping the old exponential system based on the Clothing Table, and adopt a new arbitrary system based on the needs of EGA.

<!---------------------------------------------------------------------------->

# House

- [`/house/`][house]

Changes concerning the __House__ test adventure in [`/house/`][house].

<!---------------------------------------------------------------------------->

# Misc Folder

- [`/misc/`][misc]

Changes concerning the miscellanea tests in [`/misc/`][misc] folder (multiple adventures).

<!-----------------------------------------------------------------------------
                               REFERENCE LINKS                                
------------------------------------------------------------------------------>

[clothing]: ./clothing/ "Navigate folder"
[house]: ./house/ "Navigate folder"
[misc]: ./misc/ "Navigate folder"

[inc_debug]: ./inc_debug.i "View source file"

[DEBUG_MODULE]: ./DEBUG_MODULE.md "Read document"

<!-- EOF -->