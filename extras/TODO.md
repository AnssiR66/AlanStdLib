# Extras Contents TODOs

Pending tasks for the `extras/` folder (as seen by end users).

> NOTE — Some of these tasks might actually involve editing the sources in `extras_src/`, but since they affect the contents of this folder these TODOs are managed here.


-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Tutorials](#tutorials)
    - [Clothing Guide](#clothing-guide)
- [ALAN Standard Library User's Manual](#alan-standard-library-users-manual)

<!-- /MarkdownTOC -->

-----

# Tutorials

- [`/tutorials/`][tutorials]

## Clothing Guide

- [`/tutorials/Clothing_Guide.html`][Clothing HTML] ([Live Preview][Clothing LIVE])

The Clothing Class commented instructions from `lib_classes.i` have been removed, and the _Clothing Guide_ tutorial document becomes the new reference for using the `clothing` class.

- [ ] Update the guide to mirror the new system.
    + [ ] Try to reuse contents from the [`CLOTHING_NEW.md`][CLOTHING_NEW] document.
- [ ] Add example adventures and transcripts to illustrate:
    * [x] __Basic clothing__ — a single clothing item is available, no coverage attributes, i.e. the Hero is either naked or dressed.
    * [ ] __Intermediate clothing__ — clothing items implemented in layered order, with underware being implemented too.
    * [ ] __Advanced clothing__ — demonstrate how to implement skirts, coats and bikinis special clothes.

# ALAN Standard Library User's Manual

- [`/manual/`][manual]
    + [`StdLibMan.html`][Man HTML] ([Live Preview][Man LIVE])

The whole book is being ported to AsciiDoc and its contents updated to mirror the current state of the library.

For more info on its progress status, see:

- [`../extras_src/manual/README.md`](../extras_src/manual/README.md)

<!-----------------------------------------------------------------------------
                               REFERENCE LINKS                                
------------------------------------------------------------------------------>


<!-- proj folders -->

[manual]: ./manual/ "Navigate to folder"
[tutorials]: ./tutorials/ "Navigate to folder"

<!-- proj files -->

[Clothing HTML]: ./tutorials/Clothing_Guide.html "View document"
[Clothing LIVE]: http://htmlpreview.github.io/?https://github.com/AnssiR66/AlanStdLib/blob/dev-2.2.0-docs/extras/tutorials/Clothing_Guide.html "HTML Live Preview"

[Man HTML]: ./manual/StdLibMan.html  "View document"
[Man LIVE]: http://htmlpreview.github.io/?https://github.com/AnssiR66/AlanStdLib/blob/dev-2.2.0-docs/extras/manual/StdLibMan.html  "HTML Live Preview"

<!-- EOF -->