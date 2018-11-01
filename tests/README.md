# Alan StdLib Test Suite

This folder contains test adventures and automated game commands scripts for testing the Library verbs and messages. The purpose of these tests is to check that all library messages are displayed correctly, to detect unexpected edge cases and to track the global impact of code changes on library messages.

Contributed by [Tristano Ajmone] to the Alan Standard Library.

> __WIP NOTE__ — The test suite is still pretty much work in progress, and it will take some time to create adventures and scripts to test all the StdLib features.

-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Setup and System Requirements](#setup-and-system-requirements)
    - [Scripts Encoding](#scripts-encoding)
- [How to Run the Tests](#how-to-run-the-tests)
- [How Tests Work](#how-tests-work)
    - [Files Naming Conventions](#files-naming-conventions)
- [Licenses](#licenses)
    - [Alan Sources and Commands Scripts](#alan-sources-and-commands-scripts)
        - [The Unlicense](#the-unlicense)
    - [The Batch Scripts](#the-batch-scripts)
        - [The MIT License](#the-mit-license)

<!-- /MarkdownTOC -->

-----

# Setup and System Requirements

All scripts are designed for MS Windows.

In order to use these scripts, make sure that the __Alan compiler__ (`alan.exe`) and __Arun interpreter__ (`arun.exe`) are either available on your system PATH or inside this folder. 

You can safely copy the "`alan.exe`" and "`arun.exe`" executables into this folder, as the repository is configured so that Git will ignore them. Adding a copy of these binaries into the folder has the advantage that you can control which specific version of the executables the scripts should be run with (even if other versions are available on the system PATH); this might be useful if you wish to run the tests using prerelease versions of the compiler and interpreter.

Both "`alan.exe`" and "`arun.exe`" can be found inside the Alan SDK (Development Kit). Make sure that you are using the latest releases, as found on Alan website:

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

The test system is simple. For every "`*.alan`" file found in this folder, the "[`RUNTESTS.bat`][RUNTESTS]" batch script will:

1. Compile "`<filename>.alan`" to "`<filename>.a3c`".
2. Play the compiled adventure against one or more associated commands scripts named as "`<filename>*.a3sol`".
3. Save the play session transcript to "`<commandscript>.a3log`" (i.e. same name as the used command script, but with `.a3log` extension).
4. Print a statistics and errors report on the terminal screen.

## Files Naming Conventions

The pattern "`<filename>*.a3sol`" allows to associate multiple commands scripts to each adventure, so that different tests can be carried out on a single adventure. In case of a single test file, it should be simply named "`<filename>.a3sol`", to keep associations simple.

Here is an example of how multiple test files work:

|         input file        |        output file        |
|---------------------------|---------------------------|
| `actors.alan`             | `actors.a3c`              |
| `actors.a3sol`            | `actors.a3log`            |
| `actors_advanced.a3sol`   | `actors_advanced.a3log`   |
| `actors_compliance.a3sol` | `actors_compliance.a3log` |
| `actors_named.a3sol`      | `actors_named.a3log`      |


Beware that you should not create adventures whose name is the initial part of another adventure's name (e.g. "`actors.alan`" and "`actors_two.alan`) for the commands scripts of the latter would be executed also for the former, because they would match the partern `actors*.a3sol`.

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

<!-- PORJECT FILES -->

[RUNTESTS]: ./RUNTESTS.bat  "View the batch file source"
[Unlicense]: ./UNLICENSE    "View the full text of the Unlicense terms"


<!-- Sublime-Alan -->

[Sublime-Alan documentation]: https://github.com/tajmone/sublime-alan#transcipt-and-solution-syntaxes "Go to Sublime-Alan documentation on Alan Solution and Transcript files"
[Alan package]: https://github.com/tajmone/sublime-alan "Go to the Sublime-Alan project, a package that adds Alan syntax support to Sublime Text"


<!-- EOF -->
