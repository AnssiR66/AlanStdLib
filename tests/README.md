# Alan StdLib Test Suite

> Required **Alan SDK**: [Alan v3.0 beta6 build 1880][SDK]

[SDK]: https://www.alanif.se/download-alan-v3/development-snapshots/development-snapshots/build1880 "Go to the download page of this specific Alan SDK release"

This directory tree contains test adventures and automated game commands scripts for testing the Library verbs, messages and features. The purpose of these tests is to check that all library messages are displayed correctly, to detect unexpected edge cases and to track the global impact of code changes on library messages.

Contributed by [Tristano Ajmone] to the Alan Standard Library.

> __WIP NOTE__ — The test suite is still work in progress, it will take some time to create enough adventures and scripts to test all the StdLib features.

-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Contents](#contents)
    - [Extra Modules](#extra-modules)
    - [Type1 Tests: Single Adventure, Multiple Tests](#type1-tests-single-adventure-multiple-tests)
        - [Files Naming Convention](#files-naming-convention)
        - [Tests Features](#tests-features)
    - [Type2 Tests: Multiple Adventures, One or More Tests](#type2-tests-multiple-adventures-one-or-more-tests)
        - [Files Naming Convention](#files-naming-convention-1)
        - [Tests Features](#tests-features-1)
- [Setup and System Requirements](#setup-and-system-requirements)
    - [Scripts Encoding](#scripts-encoding)
- [How to Run the Tests](#how-to-run-the-tests)
- [How Tests Work](#how-tests-work)
- [Licenses](#licenses)
    - [Alan Sources and Commands Scripts](#alan-sources-and-commands-scripts)
        - [The Unlicense](#the-unlicense)
    - [The Batch Scripts](#the-batch-scripts)
        - [The MIT License](#the-mit-license)

<!-- /MarkdownTOC -->

-----


# Contents

Tests are organized in groups, each group is confined in a subfolder of its own, and each belonging to one of two different types of tests:

|        subfolder         |                   type of test                   |
|--------------------------|--------------------------------------------------|
| [`/house/`][house]       | Single adventure, multiple tests.                |
| [`/clothing/`][clothing] | Multiple adventures, one or more tests for each. |
| [`/misc/`][misc]         | Single adventure, multiple tests.                |

Execution of all tests is controlled by a single batch script:

- [`RUNTESTS.bat`][RUNTESTS]

Inside each tests folder there's also a `TEST_FOLDER.bat` script for running all tests therein independently from the other tests folders. Theses scripts are intended only as an aid to speed up development work, and they are not a replacement fro the main `RUNTESTS.bat` script, which should always be used before commiting changes because it provides better errors reports.

## Extra Modules

This folder also contains some extra modules that the test adventures can include for shared functionality:

- [`inc_debug.i`][inc_debug] — some "debugging verbs" and helpers.

For more information, see [`DEBUG_MODULE.md`][DEBUG_MODULE].

## Type1 Tests: Single Adventure, Multiple Tests

|        subfolder         |         adventure          |
|--------------------------|----------------------------|
| [`/house/`][house]       | [`house.alan`][house.alan] |
| [`/clothing/`][clothing] | [`ega.alan`][ega.alan]     |

Inside the [`/house/`][house] and [`/clothing/`][clothing] subfolders a single adventure is employed to carry out multiple tests.

### Files Naming Convention

Since there is only one adventure to run tests against, script tests and log files have no naming constraints, which allows more freedom in organizing them into categories by employing meaningful prefixes.

Although the [`/house/`][house] and [`/clothing/`][clothing] subfolders differ in tests scope, a draft convention of prefixes usage in these folder could the following:

|    prefix   |                       description                       |
|-------------|---------------------------------------------------------|
| `actions_*` | Tests a specific group of actions (unrelated verbs).    |
| `bug_*`     | Tests dealing with Alan bugs.                           |
| `class_*`   | Tests targetting a specific class.                      |
| `test_*`    | Tests the adventure (not the library) to check it's OK. |
| `verbs_*`   | Tests for a specific verb, or group of similar verbs.   |


### Tests Features

The advantages offered by this approach are management simplicity and richness of the test environment, because using the same adventure for multiple tests allows creating a bigger game world, with added complexity.

Each test script targets specific features in the adventure (a group of verbs/actions, some specific functionality, interactions between actors, etc.), and the source adventure was crafted to provide a setting that facilitates all the various tests.

Each single adventure in these subfolders contains a moltitude of locations, actors, furniture and props, devices, etc. They offer a large-scale test environment, which resembles the simulation of a real adventure game. And because there is a single source file to administer in the course of time, more energy can be invested to polish the adventure. 

> __NOTE__ — Currently the [`RUNTESTS.bat`][RUNTESTS] script supports an unlimited number of test folders of this type. A new folder can be added by editing the batch script.

## Type2 Tests: Multiple Adventures, One or More Tests

- [`/misc/`][misc] 

The tests in this folder consist in many small adventures which are usually associated to a single test script, although in some cases there might be more than one test for the same adventure. 

### Files Naming Convention

To allow multiple adventures to share the same folder, and to associate each test script and log file to a specific adventure, some constraints are imposed on adventures and scripts filenames.

The pattern "`<filename>*.a3sol`" allows to associate multiple commands scripts to each adventure, so that different tests can be carried out on a single adventure. In case of a single test file, it should be simply named "`<filename>.a3sol`", to keep associations simple.

Here is an example of how multiple test files work:

|         input file         |        output file         |
|----------------------------|----------------------------|
| `actors.alan`              | `actors.a3c`               |
| `actors.a3sol`             | `actors.a3log`             |
| `actors_advanced.a3sol`    | `actors_advanced.a3log`    |
| `actors_compliance.a3sol`  | `actors_compliance.a3log`  |
| `actors_named.a3sol`       | `actors_named.a3log`       |
| `restricted-actions.alan`  | `restricted-actions.a3c`   |
| `restricted-actions.a3sol` | `restricted-actions.a3log` |


Beware that you should not create adventures whose name is the initial part of another adventure's name (e.g. "`actors.alan`" and "`actors_two.alan`) for the commands scripts of the latter would be executed also for the former, because they would match the partern `actors*.a3sol`.


### Tests Features

These adventures were created _ad hoc_ to target testing specific features in an isolated context.

Specifically, these adventures allow testing alternative scenarios from those offered from the single adventure tests in the other folders, where some base settings in the adventure (whic can't be modified) prevent testing alternative configurations (e.g. a female gendered Hero, etc.).

Some of these smaller adventures are aimed to test edge cases, including purposefully introduced errors in the adventure source code, in order to test that the library is handling correctly the messages for these errors, or to cause a crash with a known Alan bug — none of which could be done in the other type of test folders.

For these reasons, as well as some other more practical ones, it was deemed useful to split the library tests into two separate group types.

Due to scarce reusability of the tests in the `misc/` subfolder (which usually serve a single test), the time dedicated to polish and beautify them is reduced to the minimal required.

> __NOTE__ — Currently the [`RUNTESTS.bat`][RUNTESTS] script only supports a single folders of this type of test (i.e. `misc/`).
> 
> Since at the present stage there is no need to separate this kind of tests into different folders, it's unlikely that the batch script will be changed to allow multiple folders of this type.
> 
> But if in the future the number of such tests grows beyond manageabilty, adaptments might be made to accomodate further subfoldering.


# Setup and System Requirements

All scripts are designed for MS Windows.

In order to use these scripts, make sure that the correct version of the __Alan compiler__ (`alan.exe`) and __Arun interpreter__ (`arun.exe`) are available on your system PATH.

> __IMPORTANT!__ — The Alan SDK version required to run these tests is the one indicated at the very beginning of this document. Using different version (older releases, or developer snapshots) might produce unexpected results.
> 
> Tests transcripts obtained with different versions of the Alan SDK should not be commmited to the project, as they might not reflect the correct status of results.

<!-- sep -->

> __NOTE__ — Just copying the  "`alan.exe`" and "`arun.exe`" executables into this folder wouldn't work because the batch script that runs the tests switches working the directory every time it runs tests in one of the tests subfolders.
> 
> A viable workaround to using the system PATH would require you to create symlinks to "`alan.exe`" and "`arun.exe`" in every tests subfoler, making them point to the correct version of the binaries they represent. This would be better than having to add multiple copies (three) of these binaries in every subfolder. You could then place the required binaries inside this folder, and have symlinks in the subfolders point to them, so whenever you override the binaries real the symlinks will reflect the new versions.


Both "`alan.exe`" and "`arun.exe`" can be found inside the Alan SDK (Development Kit). Make sure that you are download the appropriate SDK version required by the test suite from Alan website:

- https://www.alanif.se/download-alan-v3/development-kits

> __NOTE__ — The automated test scripts require that you use __ARun__ (the command line interpreter) and they will not work with __WinArun__ or __Gargoyle__, which are GUI-based interpreters.

## Scripts Encoding

In order to display correctly non Ascii characters, the following file extensions should be associated with ISO-8859-1 encoding in your editor:

- "`.a3sol`" — "solution" files (aka "commands scripts).
- "`.a3log`" — game transcripts.

These extensions where arbitrarily chosen in order to allow associating them to [ISO-8859-1] encoding without affecting common extensions like "`.log`" or "`.sol`", which are used in other contexts. The "`.a3`" prefix is intended to provide an intuitive association with Alan, and at the same time make hese extensions unique to this context.

For more information, see the [Sublime-Alan documentation] on how these extensions are implemented in the [Alan package] for Sublime-Text, which adds syntax support for them along with some useful features.


# How to Run the Tests

- [`./RUNTESTS.bat`][RUNTESTS]

Just launch the "[`RUNTESTS.bat`][RUNTESTS]" script and it will recompile all the adventures and run all the tests scripts.

You can launch either via CMD it or from File Explorer.

# How Tests Work

The test suite system is simple. For every "`*.alan`" file found in the subfolders of this directory, the "[`RUNTESTS.bat`][RUNTESTS]" batch script will:

1. Compile "`<filename>.alan`" to "`<filename>.a3c`".
2. Play the compiled adventure against all the commands scripts (`*.a3sol`) associated to it (according to the tests type of its folder).
3. Save the play session transcript to "`<commandscript>.a3log`" (i.e. same name as the used command script, but with `.a3log` extension).
4. Print a statistics and errors report on the terminal screen.

The final report is very useful for it informs about the total number of adventures found, compiled and tested, and the total number of test scripts found and executed.

Error reports indicate that something went wrong during an operation, but the script isn't able to acquire specific details about the nature of the error, therefore errors should be manually verified.

For example, some tests are intended to fail because they are causing an Alan bug to trigger (these tests will also detect when the bug is fixed with new Alan version). In such cases, the report might state that no transcript was created, while it might as well be that the crash just prevented finishing the whole test, but the incomplete transcript is there.

At the current stage of development, it's acceptable to have failing tests as long as they are expected to fail. In all other cases, failure is an indication that the source adventures need fixing.

# Licenses

The contents of this folder fall under different license terms, as explained below.

## Alan Sources and Commands Scripts

- [`./UNLICENSE`][Unlicense]

All the Alan source files ("`*.alan`" and "`*.i`") and test script files ("`*.a3sol`") contributed by [Tristano Ajmone] to this folder are released into the public domain via the Unlicense.

For both practical and aesthetical reasons, I avoided adding author and license to the test script files ("`*.a3sol`"); the above statement shall suffice to declare them public domain.

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


## The Batch Scripts

- [`./RUNTESTS.bat`][RUNTESTS]

The batch file "[`RUNTESTS.bat`][RUNTESTS]" is releases under the MIT License terms (full license text also found inside the script).

### The MIT License

```
MIT License

Copyright (c) 2018 Tristano Ajmone, https://github.com/tajmone

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```


<!-----------------------------------------------------------------------------
                               REFERENCE LINKS                                
------------------------------------------------------------------------------>


[Tristano Ajmone]: https://github.com/tajmone "Visit Tristano Ajmone's profile on GitHub"

[ISO-8859-1]: https://en.wikipedia.org/wiki/ISO/IEC_8859-1 "Read Wikipedia's page on ISO-8859-1"

<!-- PROJECT FILES -->

[DEBUG_MODULE]: ./DEBUG_MODULE.md  "Read document"

[RUNTESTS]: ./RUNTESTS.bat  "View the batch file source"

[house]: ./house/ "Go to folder"
[clothing]: ./clothing/ "Go to folder"
[misc]: ./misc/ "Go to folder"

[house.alan]: ./house/house.alan "View adventure source code"
[ega.alan]:   ./clothing/ega.alan "View adventure source code"
[inc_debug]: ./inc_debug.i "View module source code"


[Unlicense]: ./UNLICENSE    "View the full text of the Unlicense terms"


<!-- Sublime-Alan -->

[Sublime-Alan documentation]: https://github.com/tajmone/sublime-alan#transcipt-and-solution-syntaxes "Go to Sublime-Alan documentation on Alan Solution and Transcript files"
[Alan package]: https://github.com/tajmone/sublime-alan "Go to the Sublime-Alan project, a package that adds Alan syntax support to Sublime Text"


<!-- EOF -->
