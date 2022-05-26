# Library Integrity Tests

This test suite folder is dedicated exclusively to testing the integrity of the Standard Library, to ensure that changes to the library sources don't break up the library consistency of some of its core features.

Unlike other folders of the test suite — whose aim is testing how the various features play out in the broader contexts, in order to catch unexpected behaviors resulting from classes interactions, edge cases, and other types of uncovered behaviors brought to attention via stress-testing — the tests in this folder focus on core aspects of the library, such as:

- Ensuring that default attributes values are correctly in place when the game starts.
- Verifying that library EVENTs and SCRIPTs are running correctly, and not interrupted by ordinary usage of the library in sample adventures.
- Ensuring that core library features are not disrupted by common adventures operations.
- Ensuring that the library is capable of handling safety checks to prevent breaking up features due to common authors omission or mistakes which the library should be capable of handling in its `INITIALIZE` statements.
- Verifying that library promised features are correctly honored — e.g.:
    + That custom `ex` descriptions are always honored, by all verbs on all classes.
    + That the `described` counter is correctly handled when locations' descriptions are suppressed due to darkness (see [Issue #100]).
    + That overriding library verbs on the `my_game` instance works as expected.

and other similar integrity checks.

<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

[Issue #100]: https://github.com/AnssiR66/AlanStdLib/issues/100

<!-- EOF -->
