# Clothing Development Notes

This temporary document annotates the development stages to fix the current problems with library clothing.

***DELETE BEFORE MERGING INTO `master`!!!***

For a detailed description of the new clothing system and its differences from the original, see:

- [`CLOTHING_NEW.md`][CLOTHING_NEW]


-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3,4,5" -->

- [Before Merging into Master](#before-merging-into-master)
- [Pre-Squash Dev Chores and Clean-Up](#pre-squash-dev-chores-and-clean-up)
    - [Move Post-Merge Deferable Tasks to Other TODOs](#move-post-merge-deferable-tasks-to-other-todos)
    - [Library Sources Cleanup](#library-sources-cleanup)
    - [Clothing Guide Tutorial](#clothing-guide-tutorial)
    - [`extras_src` Folder](#extras_src-folder)
        - [Move Assets from Extras to Extras_src](#move-assets-from-extras-to-extras_src)
        - [Automation Toolchain](#automation-toolchain)
    - [Cleanup Test Suite](#cleanup-test-suite)
        - [Transcripts Update](#transcripts-update)
        - [Update Commands Scripts](#update-commands-scripts)
- [Implementation Steps](#implementation-steps)
    - [Tests](#tests)
        - [Debug Module](#debug-module)
    - [Clothing Attributes](#clothing-attributes)
    - [Dispose of `worn` and `wearing`](#dispose-of-worn-and-wearing)
        - [Rename `donned` to `worn`](#rename-donned-to-worn)
    - [Adapt Verbs](#adapt-verbs)
        - [New Verb Messages](#new-verb-messages)
        - [`wear` and `remove`](#wear-and-remove)
        - [Inventory and Examine Actor](#inventory-and-examine-actor)
        - [Verbs Referencing `worn`](#verbs-referencing-worn)
    - [Handling Worn Items](#handling-worn-items)
        - [Block Verbs on `clothing`](#block-verbs-on-clothing)
        - [Verbs That Could Dislocate Worn Items](#verbs-that-could-dislocate-worn-items)
    - [Implicit Taking](#implicit-taking)
        - [List of Verbs With Implicit Take](#list-of-verbs-with-implicit-take)
        - [Suppress Implicit Taking](#suppress-implicit-taking)

<!-- /MarkdownTOC -->

-----

This document must be deleted before merging [`dev-2.2.0` branch][branch220] into `master` for the upcoming release 2.0. It will be preserved during development as a memo of all the changes during the implementation of the new clothing system.

Also, the following section contains a list of clothing related pending tasks that must taken care of before merging into `master`.


# Before Merging into Master

The following tasks relating to the new clothing system must be dealt with before commiting changes to `master` branch for the 2.2 release.

After the new system is in place, the old code, tests and documents need to be adapated accordingly.

- [ ] __DOCUMENTS__ — READMEs and documentation files must also be revised to reflect library changes.
    + [ ] __WHAT'S NEW DOC__ — Adapt and rename [`CLOTHING_NEW.md`][CLOTHING_NEW] so it becomes a document introducing library users to the changes in the new clothing system, simplifying migration to new system.
- [ ] __CLOTHING GUIDE__ (see [`extras/TODO.md`](extras/TODO.md))
    - [ ] Update the guide to mirror the new system.
    + [ ] Add example adventures and transcripts.
- [ ] __CLOTHING RULES & AUTHORS' GUIDELINES__
    + [ ]  Establish some rules on how the library should handle verbs that might interact with a worn clothing item (including implicit taking), then enforce them in the library verbs.
    + [ ]  Provide clear guidelines for authors so that they might create custom verbs that comply to these guidelines and won't interfere with worn clothing.


-------------------------------------------------------------------------------

# Pre-Squash Dev Chores and Clean-Up

These were the final polishing tasks before squashing `dev-clothing` into [`dev-2.2.0` branch][branch220] — the baseline development branch until the StdLib 2.2 release is ready to go in `master`.

- [x] Switch to __[developer snapshot 1880]__:
    + [x] Fix `AlanV` in `DEFINITION_BLOCK` of all sources to mirror latest Alan SDK.
        * [x] Run test suite to update transcripts.
    + [x] Update references to __SDK 1875__ in all documents:
        * [x] `tests/README.md`

The new system needs to be documented for this merge introduces significant changes in the StdLib. Also, there are still some minor development tasks pending which should be addressed.

- [x] __TESTS__ — Command scripts of the original tests will need to be tweaked to mirror the new changes, some tests might no longer be needed and can be deleted.
- [x] __COMMENTED DOCUMENTATION__ — Comments in the library sources documenting its usage need to be revised so they mirror the new system:
    + [x] __REMOVE CLOTHING INSTRUCTIONS__ — The whole commented section on Clothing Instructions is now obsolete and will be removed from `lib_classes.i` and replaced by the _Clothing Guide_ document ([See comments in #65]).

## Move Post-Merge Deferable Tasks to Other TODOs

Some of these pending tasks can be addressed after merging into the [`dev-2.2.0` branch][branch220], for they are not directly related to the Library sources (eg. the _Clothing Tutorial_, test suite improvements, documentation, etc.). These tasks should be removed from this document and placed in a dedicated TODO document for the specific topic/area.

- [x] Move deferable pending tasks to a dedicated TODO document:
    + [x] __Test Suite__ — move to `tests/TODO.md`.
    + [x] __Extras Sources__ — move to `extras_src/TODO.md`.
    + [x] _**Clothing Guide**_ — move to `extras/TODO.md`.

## Library Sources Cleanup

Before squashing into `dev-2.2.0` branch, all commented dev annotations in the sources should be removed, and temporary documents and files too.

- [x] Remove old dev-annotation comments:
    + [x] all `-- >>> dev-clothing` notes.
    + [x] all `-- >>> original code >>>` commented out code.
- [x] Annotate pre-merge TODO/FIXME tasks that must be addressed before merging.
- [x] Then resolve them and delete the comments:
    + [x] all `-- >>> dev-clothing: FIXME >>>`
    + [x] all `-- >>> dev-clothing: TODO >>>`


During the cleanup stage, I'll also take the chance to cleanup formatting/indentation of both code and documentation comments.

Library modules status:

- [x] `lib_classes.i`
- [x] `lib_definitions.i`
- [x] `lib_locations.i`
- [x] `lib_messages.i`
- [x] `lib_verbs.i`


## Clothing Guide Tutorial

The Clothing Class commented instructions from `lib_classes.i` will be removed, and the _Clothing Guide_ tutorial document will become the new reference for using the `clothing` class.


## `extras_src` Folder

With the introduction of examples adventures for the _Clothing Guide_, we need to improve the automation system of the "`extras/`" folder to allow integration into the tutorials of snippets from the examples code, as well as game transcripts.

We can use Asciidoctor `include::` directive to do so, from both Alan sources as well as autogenerated transcripts, but all files must first be converted to UTF-8 because Asciidoctor doesn't support ISO-8859-1 (see [#3248 on asciidoctor](https://github.com/asciidoctor/asciidoctor/issues/3248)).

### Move Assets from Extras to Extras_src

But to reduce clutter in the "`extras/`" folder, we should move source and intermediate files not required by end users to another folder ("`extras_src/`"), and only keep the HTML docs (+ CSS) and example adventures inside "`extras/`":

- [x] Create `extras_src/` folder (in proj. root) and:
    + [x] move to `extras_src/` the follwoing files:
        * [x] contents of the `_assets/` folder (don't keep `_assets/`, only the contents).
        * [x] AsciiDoc documents (in its root)
- [x] Create `extras_src/alan/` folder and:
    + [x] Move there Alan sources (because they contain region tags, we'll created a copy without them in `extras/`, via sed).
    + [x] Move there commands scripts (`.a3sol`).
    + [x] ignore `.a3log` files (no need to version control them).
- [x] Create `extras_src/alan/utf8/` folder (ignored) to host all converted files.
- [x] Adapt build scripts to work accordingly.

### Automation Toolchain

Now to update the contents of `extras/` we'll need to run `extras_src/update.sh`, which is now adjusted to produce user files into `extras/`. Here are the details of the new toolchain.

- [x] __AsciiDoc Toolchain__:
    + [x] __Bash Script__ — `extras_src/update.sh` to update the contents of `extras/` folder; we need to switch to a shell script (because we need the iconv tool) that will:
        * [x] Compile all adventures
        * [x] Run all commands scripts (`*.a3sol`) and save the transcripts (`*.a3log`).
        * [x] Convert all ISO-8859-1 files to UTF8 in a temporary ignored folder: `extras_src/alan/utf8/`.
        * [x] Convert all docs to HTML5.
        * [x] __Process with SED__:
            - [x]  __`*.alan` files__ — strip away AsciiDoc region-tag comment lines in copy of sources inside `extras/`.
            - [x]  __`*.a3log` files__ —  to create a version suitable for `example` blocks (instead of verbatim):
                + [x]  Add ` +` at end of non-orphan lines.
                + [x]  Subst. occurences of special chars with their ADoc attribute or HTML entiry equivalent — e.g. `*` with `{asterisk}` or `&ast;`.
                + [x]  Player input lines:
                    * [x]  change `>` into `&gt;`
                    * [x]  wrap player commands in `_`
                    * [x]  wrap input comments in `#[comment]`..`#`
                        - [x]  make it work also when comments follow commands (eg: `inventory ; some comment`).
                + [x]  Preserve region tags in input lines and convert them to ADoc comments (so they are not shown in final doc). 

We should also make sure that every HTML document inside `extras/` is fully standalone, by embedding all images and custom CSS; because users should be free to move a tutorial file around without breaking it.


## Cleanup Test Suite

During the clothing development stage the test suite hasn't been run and updated, just a subset of the clothing tests where being run. To bring the test suite en par with the new changes, a multi-step approach is required:

- [x] 1. Update transcripts
- [x] 2. Update sources/solutions

### Transcripts Update

Some of the changes to the library code will affect the output of various tests (eg. `examine`, `inv`), and the new features might require tweaking the tests sources and/or commands scripts. The goal of this step is to restore all the test suite solutions and transcripts to their original status, by adapting them accordingly.

- [x] __UPDATE TRANSCRIPTS__ — Rerun all tests and update the transcript logs of all the tests were the output varies but there is no need to change the source or the solution file:
    + [x] `/tests/clothing/`:
    + [x] `/tests/house/`
    + [x] `/tests/misc/`

### Update Commands Scripts

Some of the new features might require tweaking the tests sources and/or commands scripts in order to restore the test suite to its original status.

- [x] __UPDATE SOLUTIONS__ — Update the commands scripts and/or adventure sources that need to be adapted to the library changes:
    + [x] `/tests/clothing/`
        * [x] Update and adapt old solutions that were affected by code changes.
        * [x] Delete obsolete tests for bugs that are now fixed.
        * [x] Remove `DEV.bat` and rename the `DEV*.*` tests to integrate them in the main test suite:
            - [x] Eliminate redundant tests from either the old tests or the newer `DEV*.*` files, keeping whichever one is better, or merging their contents into a new test.

Once the original status of the test suite is restored, we can safely implement any new changes and improvements we need.


-------------------------------------------------------------------------------

# Implementation Steps

The following list resumes the overall steps for the implementation of the new system. The details of each step are covered in the Tasks Lists sections below.

- [x] Dispose of the `worn` entity and the `wearing` set, and use instead just the `donned` boolean attribute.
- [x] Renamed the `donned` attribute to `worn`.
- [x] Ensure that nested clothes are never considered as being worn.
- [x] List separately carried and worn items by actors, for both Hero (via 'inventory') and NPCs (via 'examine actor').
- [x] When the verbs `wear`/`remove` fail, report only the blocking items (instead of the full list of worn items).
- [x] Remove hard-coded handling of special clothes like coats and skirts, and allow authors to implement those via some new (optional) clothing attributes: `blockslegs` and `twopiecess`.
- [x] Allow authors to free number clothing layers, instead of imposing exponential layering (2, 4, 8, 16, 32, 64).
- [x] Add new clothing attribute `facecover` to allow handling goggles, beards, masks, etc., independently from `headcover`.

Here are the various tasks list for shifting to the new clothing system, largely based on the same work done for the Italian version of the StdLib.

## Tests

- [x] Create `tests/clothing/DEV.bat` script to run tests only with solution files with name pattern `DEV_*.a3sol`.
- [x] Add tests to track tweaked clothing features.
- [x] __EGA__ — Tweak `ega.alan` test adventure to reflect changes in the library code and/or provide better testing material:
    + [x] __DBG VERB__ — Tweak it to work with the new clothing system and attributes (verb now moved to `tests/inc_debug.i`):
        * [x] `facecover`
        * [x] `blockslegs`
        * [x] `twopieces`
        * [x] Don't show `worn` and `wearing` info.
    + [x] __UNDRESS VERB__ — Tweak it to work with new system (no use of `worn` or `wearing`).
    + [x] __WORN CLOTHES__ — Adapt code relating to worn items:
        * [x] __HERO__: Locate item `IN hero` instead of `worn`.
        * [x] __ALL ACTORS__: Set item as `worn`.
    + [x] __FIX SPECIAL CLOTHES__ — Use new `blockslegs`, `twopieces` and `facecover` attributes in existing clothes:
        * [x] skirt (`NOT blockslegs`)
        * [x] dress (`NOT blockslegs`)
        * [x] balaclava (use `facecover` + `headcover`)
        * [x] sky goggles (use `facecover`)
    + [x] __NEW CLOTHES__ — Add more clothing items for testing:
        * [x] coat
        * [x] bikini
        * [x] shirts: black and red
        * [x] ski helmet
- [x] Add a new `TEST_FOLDER.bat` script in every test folder to allow quickly running all tests of that folder independently from the others:
    + [x] `tests/clothing/` (single source, multiple tests)
    + [x] `tests/house/` (single source, multiple tests)
    + [x] `tests/misc/` (multiple sources, one ore more tests each)

### Debug Module

Create a separate debugging module `tests/inc_debug.i` that can be used by all test adventures and move there the custom debug verbs from EGA (and other adventures):

- [x] Create `tests/inc_debug.i`:
    + [x] Move here `DBG` verb from EGA and rename it `DBG_CLOTHES`
        * [x] Change use of `DBG` verb into `DBG_CLOTHES` in all commands scripts
      inside `tests/clothing/` folder.
    + [x] Add new debug verbs:
        * [x] `DBG_INV <ACTOR>` to list all objects carried/worn by an actor (via `LIST` command).
        * [x] `DBG_COMP <ACTOR>` — to show compliance status of actors.
        * [x] Verb `subjugate` to toggle actors compliance.


## Clothing Attributes

Add new attributes on `clothing` class:

- [x] `IS blockslegs` — i.e. prevents wearing/removing legsware from layers below. Skirts and coats are `NOT blockslegs`, for they don't prevent wearing/removing underware or other legswear which doesn't form a single-piece clothing with the torso (eg. a teddy, which would be blocked).
- [x] `IS NOT twopieces` — used for skirts/coats-like checks, if the item being worn/removed `IS twopieces` (eg. a bikini) it will be allowable to do so. Useful when implementing a two-pieces item as a single clothing, eg. a bikin which is worn/removed in a single action.
- [x] `facecover` — to allow wearing masks, beards, goggles without using up `headcover`.


## Dispose of `worn` and `wearing`

Before actually removing the `worn` entity and the `wearing` set from the library code, and use instead just the `worn` boolean attribute (which will be renamed to `worn`) any references to them (in VERBs, EVENTs, etc.) must be subsituted with the new system. This will require a gradual approach, starting with the `clothing` class initialization and the `wear` and `remove` verbs, and then dealing with the `i` (inventory) verb, and then adapting every other verb that references `worn` and `wearing`.

- [x] __MOVE `donned` ON `thing`__ — The `donned` attribute (now `worn`) must be made available on the `thing` class, not just on `clothing`, fro two reasons:
    1. Allow to carry out checks in syntaxes of verbs that might affect worn items.
    1. Enable authors to implement non-clothing wearables (eg. wearable `device`s like VR goggles).
- [x] __CLOTHING INITIALIZATION__ — Tweak initialization of `clothing`:
    + [x] Comment out the code that iterates every ACTOR to see if the clothing instance is in its `wearing` set in order to make it `donned` and, in case of the Hero, move it to `worn`. None of this is any longer necessary, for a clothing items only needs to be DIRECTLY IN an ACTOR and `IS worn` for it to be worn by the actor.
    + [x] Suppress scheduling the `worn_clothing_check` EVENT. That's no longer required.
- [x] __EVENT `worn_clothing_check`__:
    + [x] Commented out the whole event for it's no longer strictly required.

### Rename `donned` to `worn`

When no more references are left to the `worn` entity in the library code, we should rename the `donned` attribute to `worn`.

- [x] Rename all occurences of `donned` to `worn` in:
    + [x] __LIBRARY SOURCES__.
    + [x] __TEST ADVENTURE SOURCES__.
    + [x] __DEBUG MODULE__.


## Adapt Verbs

Many verbs need to be adapted to work with the new system, for various reasons. Some verbs will appear in multiple tasks lists in this section, because each list tracks a specific set of tweaks, which might be independent of other types of changes.

### New Verb Messages

The new system required the introduction of some new `my_game` string attributes for verb responses.

|            attribute            |             string            |
|---------------------------------|-------------------------------|
| `check_obj1_not_worn_by_NPC_sg` | `"Currently $+1 is worn by"`  |
| `check_obj1_not_worn_by_NPC_pl` | `"Currently $+1 are worn by"` |


### `wear` and `remove`

Obviously, changes to the `wear` and `remove` verbs in `lib_classes.i` are central to the new clothings system, so we'll assign to them a task list of its own.

- [x] __TEMP ATTRIBUTES__ — add new attributes on `definition_block`, for internal usage:
    + [x] `temp_cnt` (integer), used for listing carried/worn items.
    + [x] `temp_clothes { clothing }` used to track clothes preventing wear/remove actions.
    + [x] Delete `ACTOR:wear_flag` (no longer needed).
    + [x] Delete `ACTOR:tempcovered` (no longer needed).
- [x] __VERB `wear`__:
    + [x] __NON EXPONENTIAL LAYERS__ — Allow free arbitrary assignment of layers values.
    + [x] __FACE COVER VALUE__ — introduce checks for `facecover`.
    + [x] __SKIRT & COATS__ — no longer hardcoded layers, use `blockslegs` and `twopiece` instead.
    + [x] __FAILURE REPORT__ — list only blocking items.
- [x] __VERB `remove`__:
    + [x] __NON EXPONENTIAL LAYERS__ — Allow free arbitrary assignment of layers values.
    + [x] __FACE COVER VALUE__ — introduce checks for `facecover`.
    + [x] __SKIRT & COATS__ — no longer hardcoded layers, use `blockslegs` and `twopiece` instead.
    + [x] __FAILURE REPORT__ — list only blocking items.


### Inventory and Examine Actor

When taking inventory or examining actors, the library should produce two separate lists for carried and worn items. Also, these verbs should produce a "not wearing anything" message for it adds verbosity and would be intrusive in adventures that don't employ clothing. When examining NPCs, the "empty handed" message should not be produced either, to reduce verbosity (it's implicit) and prevent complications in adventures that don't implement NPCs carrying possesions.

- [x] `lib_verbs.i`:
    + [x] `i` (inventory)
        * [x] Produce separate lists of carried/worn via custom loops.
        * [x] Don't report that Hero is not wearing anything.
- [x] `lib_classes.i`:
    + [x] `examine` (on `actor`)
        * [x] Produce separate lists of carried/worn via custom loops.
        * [x] Don't report that actor is empty handed.
        * [x] Don't report that actor is not wearing anything.

The various library-defined runtime MESSAGES must also be tweaked now that the `worn` entity will be removed:

- [x] `lib_messages.i` — fix references to `worn` entity:
    + [x] `CONTAINS_COMMA`
    + [x] `CONTAINS_AND`
    + [x] `CONTAINS_END`


### Verbs Referencing `worn`

These general verbs must also be adapted for they contain references to the `worn` entity.

- [x] `lib_verbs.i`:
    + [x] `attack`:
        * removed CHECK `target NOT IN hero` and tweaked CHECK `target NOT IN hero` to distinguish between carried and worn.
    + [x] `attack_with`:
        * removed CHECK `target NOT IN hero` and tweaked CHECK `target NOT IN hero` to distinguish between carried and worn.
    + [x] `drop`:
        * removed from CHECK the `IF obj IN worn` part.
        * added CHECK `AND obj IS NOT worn` for non-clothing wearables.
    + [x] `i` (inventory):
        * removed reference to `worn` entity.
        * implemented custom loops to list carried and worn items.
    + [x] `kick`:
        * removed CHECK `target NOT IN hero` and tweaked CHECK `target NOT IN hero` to distinguish between carried and worn.
    + [x] `shoot`
    + [x] `shoot_with`
    + [x] `take`
    + [x] `wear`

Although may of these verbs are going to be prevented by reimplementing them on `clothing` class and add CHECKs that block them if the items is worn, we still want to keep the CHECKs in the main verbs so that non-clothing wearables are treated correctly too.

These will usally be handled by changing code like:

```alan
    AND target NOT IN hero
      ELSE SAY check_obj_not_in_hero1 OF my_game.
    AND target NOT IN worn
      ELSE SAY check_obj_not_in_worn2 OF my_game.
```

into a single CHECK that distinguished between carried and worn items:

```alan
    AND target NOT IN hero
      ELSE
        IF target IS NOT worn
          THEN SAY my_game:check_obj_not_in_hero1.
          ELSE SAY my_game:check_obj_not_in_worn2.
        END IF.
```



## Handling Worn Items

All verbs which can dislocate an object (clothing or otherwise) from an actor should always set the dislocated object to `NOT worn`.

The logic behind this is that, although such verbs will be prevented to act on `clothing` instances via CHECKS for the same verbs on the `clothing` class, we must still cater for non-clothing wearables (eg. wearable devices) which might be implement by authors in their adventures.

Setting to `NOT worn` an object which has been moved around is always a safe action, for the item couldn't be possibly be worn after the action. If the object is not a wearable, then no harm is done (as non-wearable should always be `NOT worn` anywhow).

We need also to take into account any implicit taking action which might affect worn items.

### Block Verbs on `clothing`

The following verbs have been implemented on `clothing` class to allow CHECKS that prevent their execution with `worn` clothing items.

- [x] `put_in` (container)
- [x] `put_on` (supporter)
- [x] `give`
- [x] `throw`
- [x] `throw_at`
- [x] `throw_to`
- [x] `throw_in`
- [x] `tie_to`

### Verbs That Could Dislocate Worn Items

In `lib_verbs.i`, if the action succeeds for the following verbs we must still set the dislocated item as `NOT worn` (even though the CHECKS on `clothing` for the same verbs prevent the action with worn `clothing` items) because authors might implement non-clothing wearables:

- [x] `ask_for`
- [x] `give`
- [x] `put_in` (container)
- [x] `put_on` (supporter)
- [x] `throw`

## Implicit Taking

Every verb that can/does carry out implicit taking must be examined to ensure it will handle properly worn items (`clothing` or otherwise).

To simplify work, every implicit take code in the library should be enclosed within special comments markers, so they can quickly be found via editor Search functionality:

```
-- >>> implicit take >>>
-- <<< implicit take <<<
```

- [x] Mark with comments all implicit take occurences in the library sources.

### List of Verbs With Implicit Take

This is the list of all verbs which contain implicit taking:

- `lib_classes.i`:
    + `clothing` class:
        * `wear`
    + `liquid` class:
        * `give`
        * `pour`
        * `pour_in`
        * `pour_on`
        * `put_in`
        * `put_on`
- `lib_verbs.i`:
    + `bite`
    + `drink`
    + `eat`
    + `empty`
    + `empty_in`
    + `empty_on`
    + `give`
    + `put_on`
    + `sip`
    + `throw`
    + `throw_at`
    + `throw_to`
    + `throw_in`
    + `tie_to`

### Suppress Implicit Taking

In the following verbs, which are more like placeholders for authors, because they don't complete the action by default, implicit taking was commented out. The reason being that since the action is prevented, it doesn't make much sense to carry out the implicit taking either.

Since authors will have to override such verbs in their own adventures (via `DOES ONLY`, on classes or instances) in order for them to do something meaningful, they'll have to handle implicit taking anyhow, as well as setting to `NOT worn` any object dislocated by them.

- [x] `throw_to`
- [x] `throw_in`
- [x] `tie_to`

In these verbs the action either is always carried out or it's carried out in some conditions, either way the implicit taking must be honored and the moved object set to `NOT worn`:

- [x] `throw`
- [x] `throw_at`


<!-----------------------------------------------------------------------------
                               REFERENCE LINKS                                
------------------------------------------------------------------------------>

[branch220]: https://github.com/AnssiR66/AlanStdLib/tree/dev-2.2.0 "View branch on GitHub"

[CLOTHING_NEW]: ./CLOTHING_NEW.md

[See comments in #65]: https://github.com/AnssiR66/AlanStdLib/issues/65#issuecomment-478430401

<!-- tests files -->

[testsclothing]: ./tests/clothing/ "Navigate to folder"
[ega.alan]: ./tests/clothing/ega.alan "View source"
[DEV.bat]: ./tests/clothing/DEV.bat "View source"
[DEV_init.a3log]: ./tests/clothing/DEV_init.a3log "View source"
[DEV_init.a3sol]: ./tests/clothing/DEV_init.a3sol "View source"
[DEV_skirts.a3log]: ./tests/clothing/DEV_skirts.a3log "View source"
[DEV_skirts.a3sol]: ./tests/clothing/DEV_skirts.a3sol "View source"
[DEV_wear_remove.a3log]: ./tests/clothing/DEV_wear_remove.a3log "View source"
[DEV_wear_remove.a3sol]: ./tests/clothing/DEV_wear_remove.a3sol "View source"
[DEV_inventory.a3log]: ./tests/clothing/DEV_inventory.a3log "View source"
[DEV_inventory.a3sol]: ./tests/clothing/DEV_inventory.a3sol "View source"
[DEV_manipulation.a3log]: ./tests/clothing/DEV_manipulation.a3log "View source"
[DEV_manipulation.a3sol]: ./tests/clothing/DEV_manipulation.a3sol "View source"

<!-- Alan Builds -->

[developer snapshot 1870]: https://www.alanif.se/download-alan-v3/development-snapshots/development-snapshots/build1870
[developer snapshot 1875]: https://www.alanif.se/download-alan-v3/development-snapshots/development-snapshots/build1875
[developer snapshot 1880]: https://www.alanif.se/download-alan-v3/development-snapshots/development-snapshots/build1880

<!-- EOF -->