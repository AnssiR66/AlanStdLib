# Alan StdLib Test Suite

> Requires **Alan SDK**: [Alan v3.0 beta8][SDK]

[SDK]: https://www.alanif.se/download-alan-v3/development-kits/development-kits-3-0beta8 "Go to the download page of this specific Alan SDK release"

This directory tree contains test adventures and automated game commands scripts for testing the Library verbs, messages and features. The purpose of these tests is to check that all library messages are displayed correctly, to detect unexpected edge cases and to track the global impact of code changes on library messages.

Contributed by [Tristano Ajmone] to the Alan Standard Library.

> __WIP NOTE__ — The test suite is still work in progress, it will take some time to create enough adventures and scripts to test all the StdLib features.

-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Contents](#contents)
    - [Extra Modules](#extra-modules)
- [Test Types](#test-types)
    - [Type1 Tests: Single Adventure, Multiple Tests](#type1-tests-single-adventure-multiple-tests)
        - [Files Naming Convention](#files-naming-convention)
        - [Tests Features](#tests-features)
    - [Type2 Tests: Multiple Adventures, One or More Tests](#type2-tests-multiple-adventures-one-or-more-tests)
        - [Files Naming Convention](#files-naming-convention-1)
        - [Tests Features](#tests-features-1)
- [Setup and System Requirements](#setup-and-system-requirements)
- [How to Run the Tests](#how-to-run-the-tests)
- [How Tests Work](#how-tests-work)
- [Adding New Tests](#adding-new-tests)
- [Licenses](#licenses)
    - [Alan Sources and Commands Scripts](#alan-sources-and-commands-scripts)
        - [The Unlicense](#the-unlicense)

<!-- /MarkdownTOC -->

-----


# Contents

Tests are organized in groups, each group is confined in a subfolder of its own, and each belonging to one of two different types of tests:

|         subfolder          |                    test type                     |                     purpose                      |
|----------------------------|--------------------------------------------------|--------------------------------------------------|
| [`/clothing/`][clothing]   | Multiple adventures, one or more tests for each. | Test the clothing system.                        |
| [`/house/`][house]         | Single adventure, multiple tests.                | General purpose tests in a full-fledged context. |
| [`/integrity/`][integrity] | Multiple adventures, one or more tests for each. | Library integrity checks.                        |
| [`/liquids/`][liquids]     | Single adventure, multiple tests.                | Test the `liquid` class.                         |
| [`/misc/`][misc]           | Single adventure, multiple tests.                | Feature-specific tests.                          |

Execution of all tests is controlled via Rake; just type in the CDM or Shell:

    rake tests


## Extra Modules

This folder also contains some extra modules that the test adventures can include for shared functionality:

- [`inc_debug.i`][inc_debug] — some "debugging verbs" and helpers.

For more information, see [`DEBUG_MODULE.md`][DEBUG_MODULE].

# Test Types

Test folders fall in two different categories:

1. Single adventure with multiple tests.
2. Multiple adventures, each with one or more tests.

Depending on the tests type, the naming convention for the test scripts (solution files and transcripts) differ — the former type allows freely naming test scripts, whereas the latter enforces naming constraints in order to distinguish which scripts belongs to each test adventure.

The test type of each folder is determined at run time, by the number of ALAN adventures it contains — Rake will count the `*.alan` files, and determine the test typology accordingly, on the fly.


## Type1 Tests: Single Adventure, Multiple Tests

|        subfolder         |           adventure            |
|--------------------------|--------------------------------|
| [`/clothing/`][clothing] | [`ega.alan`][ega.alan]         |
| [`/house/`][house]       | [`house.alan`][house.alan]     |
| [`/liquids/`][liquids]   | [`liquids.alan`][liquids.alan] |

Inside all the above listed subfolders, a single adventure is employed to carry out multiple tests.


### Files Naming Convention

Since there is only one adventure to run tests against, solution and transcript files have no naming constraints, which allows more freedom in organizing them into categories by employing meaningful prefixes.

Although these subfolders differ in their tests scope, a draft of the conventional prefixes employed in these folders could the following:

|    prefix   |                       description                       |
|-------------|---------------------------------------------------------|
| `actions_*` | Tests a specific group of actions (unrelated verbs).    |
| `bug_*`     | Tests dealing with Alan bugs.                           |
| `class_*`   | Tests targetting a specific class.                      |
| `test_*`    | Tests the adventure (not the library) to check it's OK. |
| `verbs_*`   | Tests for a specific verb, or group of similar verbs.   |


### Tests Features

The advantages offered by this approach are management simplicity and richness of the test environment, because using the same adventure for multiple tests allows creating a bigger game world, with added complexity.

Each test script targets specific features in the adventure (a group of verbs/actions, some specific functionality, interactions between actors, etc.), and the source adventure is crafted to provide a setting that facilitates all the various tests.

Each single adventure in these subfolders contains a multitude of locations, actors, furniture and props, devices, etc. They offer a large-scale test environment, which resembles the simulation of a real adventure game.
And because there is a single source file to administer in the course of time, more energy can be invested to polish the adventure.


## Type2 Tests: Multiple Adventures, One or More Tests

- [`/integrity/`][integrity]
- [`/misc/`][misc]

The tests in these folders consist in many small adventures, each associated to one or more commands scripts — usually a single solution file per adventure, although in some cases there might be more than one test for the same adventure.


### Files Naming Convention

To allow multiple adventures to share the same folder, and to associate each solution and transcript files to a specific adventure, some constraints are imposed on adventures and scripts filenames.

The pattern "`<filename>*.a3s`" allows to associate multiple commands scripts to each adventure, so that different tests can be carried out on a single adventure.
In case of a single commands script file, it should be simply named "`<filename>.a3s`", to keep associations simple.

Here is an example of how multiple test files work:

|         input file        |       output file        |
|---------------------------|--------------------------|
| `actors.alan`             | `actors.a3c`             |
| `actors.a3s`              | `actors.a3t`             |
| `actors_advanced.a3s`     | `actors_advanced.a3t`    |
| `actors_compliance.a3s`   | `actors_compliance.a3t`  |
| `actors_named.a3s`        | `actors_named.a3t`       |
| `restricted-actions.alan` | `restricted-actions.a3c` |
| `restricted-actions.a3s`  | `restricted-actions.a3t` |


> **IMPORTANT!** — Beware that you should not create adventures whose name is the initial part of another adventure's name (e.g. "`actors.alan`" and "`actors_two.alan`) because the commands scripts of the latter would be executed also on the former, since they would match the pattern `actors*.a3s`.


### Tests Features

These adventures are usually created _ad hoc_ to target testing specific features in an isolated context.

Specifically, these adventures allow testing alternative scenarios from those offered from the single adventure tests in the other folders, where some base settings in the adventure (which can't be modified) prevent testing alternative configurations (e.g. a female gendered Hero, etc.).

Some of these smaller adventures are aimed to test edge cases, including purposefully introduced errors in the adventure source code, in order to test that the library is handling correctly the messages for these errors, or to cause a crash with a known Alan bug — none of which could be done in the other type of test folders.

For these reasons, as well as some other more practical ones, it was deemed useful to split the library tests into two separate group types.

Due to scarce reusability of the tests in the `misc/` subfolder (which usually serve a single test), the time dedicated to polish and beautify them is reduced to the minimal required.


# Setup and System Requirements

The test suite is OS agnostic — as long as Ruby, Rake and the ALAN SDK are available in your system, the test suite should be usable.

Just make sure that the correct version of the __Alan compiler__ (`alan.exe`) and __Arun interpreter__ (`arun.exe`) are available on your system PATH.

> __IMPORTANT!__ — The Alan SDK version required to run these tests is the one indicated at the very beginning of this document. Using different version (older releases, or developer snapshots) might produce unexpected results.
>
> Tests transcripts obtained with different versions of the Alan SDK should not be committed to the project, as they might not reflect the correct status of results.

<!-- sep -->

> __NOTE__ — Just copying the  "`alan.exe`" and "`arun.exe`" executables into this folder wouldn't work because the Rake task that runs the tests switches working the directory every time it runs tests in one of the tests subfolders.
>
> A viable workaround to using the system PATH would require you to create symlinks or shortcuts to "`alan.exe`" and "`arun.exe`" in every tests subfoler, making them point to the correct version of the binaries they represent. This would be better than having to add multiple copies (three) of these binaries in every subfolder. You could then place the required binaries inside this folder, and have symlinks in the subfolders point to them, so whenever you override the binaries real the symlinks will reflect the new versions.


Both "`alan.exe`" and "`arun.exe`" can be found inside the Alan SDK (Development Kit). Make sure that you are download the appropriate SDK version required by the test suite from Alan website:

- https://www.alanif.se/download-alan-v3/development-kits

> __NOTE__ — The automated test scripts require that you use __ARun__ (the command line interpreter) and they will not work with __WinArun__ or __Gargoyle__, which are GUI-based interpreters.


# How to Run the Tests

The test suite is automated via [Rake], which you can invoke via the command line by typing `rake`.

To run/update only the tests (i.e. without updating the documentation), type in your terminal:

    rake tests

Rake will only run those tests which are outdated — i.e. it tracks their dependencies, so a transcript will only be rebuilt if it's corresponding solution file or source adventure have changed, or if the StdLib sources were updated, etc.

To forcefully run the entire test suite, type:

    rake tests -B

You can type these commands from any project folder, as long as its part of the repository.
You don't need to `cd` to the actual `tests/` subfolder you're working on — Rake always runs its tasks as if invoked from the root directory of the project.


# How Tests Work

The test suite system is simple. For every "`*.alan`" file found in the subfolders of this directory, Rake will:

1. Compile "`<filename>.alan`" to "`<filename>.a3c`".
2. Play the compiled adventure against all the commands scripts (`*.a3s`) associated to it (according to the tests type of its folder).
3. Save the generated game-session transcript to "`<commandscript>.a3t`" (i.e. same name as the command script, but with `.a3t` extension).


# Adding New Tests

To add new tests to the existing folders, simply add the source adventure and its solution file(s), Rake will automatically detect them and include them in the test suite execution.
Just make sure you follow the correct naming conventions of the folder's test type.

If you need to add a new test folder, you'll need to edit the [`Rakefile`][Rakefile] in the repository root, in order to add it to the list of test folders managed by Rake.


# Licenses

The contents of this folder fall under different license terms, as explained below.


## Alan Sources and Commands Scripts

- [`./UNLICENSE`][Unlicense]

All the Alan source files ("`*.alan`" and "`*.i`") and test script files ("`*.a3s`") contributed by [Tristano Ajmone] to this folder are released into the public domain via the Unlicense.

For both practical and aesthetical reasons, I avoided adding author and license to the test script files ("`*.a3s`"); the above statement shall suffice to declare them public domain.

### The Unlicense

- http://unlicense.org/

```
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>
```

<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

[Tristano Ajmone]: https://github.com/tajmone "Visit Tristano Ajmone's profile on GitHub"

[Rake]: https://ruby.github.io/rake/ "Visit Rake website"

<!-- project files -->

[Rakefile]: ../Rakefile "View source Rakefile (Rake project configuration)"

[DEBUG_MODULE]: ./DEBUG_MODULE.md  "Read document"

[clothing]: ./clothing/ "Go to folder"
[house]: ./house/ "Go to folder"
[integrity]: ./integrity/ "Go to folder"
[liquids]: ./liquids/ "Go to folder"
[misc]: ./misc/ "Go to folder"

[ega.alan]:   ./clothing/ega.alan "View adventure source code"
[house.alan]: ./house/house.alan "View adventure source code"
[inc_debug]: ./inc_debug.i "View module source code"
[liquids.alan]: ./liquids/liquids.alan "View adventure source code"

[Unlicense]: ./UNLICENSE    "View the full text of the Unlicense terms"

<!-- EOF -->
