# The Debug Module

Description of the "debugging" module available for inclusion in the test adventures.


-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Introduction](#introduction)
- [Added Verbs](#added-verbs)
    - [Debugging Verbs](#debugging-verbs)
        - [DBG_CLOTHES](#dbg_clothes)
        - [DBG_COMP](#dbg_comp)
        - [DBG_INV](#dbg_inv)
    - [Helper Verbs](#helper-verbs)
        - [SUBJUGATE](#subjugate)

<!-- /MarkdownTOC -->

-----

# Introduction

- [`inc_debug.i`][inc_debug]
 
This module offers some "debugging verbs" and helpers which are useful both in automated tests as well as playing the test adventures while working on library features. Needless to say, it can also be useful to authors during the creation stages of their own adventures.

This document will present the additional verbs and features introuced by the debug module.

# Added Verbs

This module adds two types of verbs:

- __Debugging Verbs__, which provide useful info about instances and their internal attributes states.
-  __Helper Verbs__, which provide useful functionality to alter the state of the adventure world in some way.

Verbs from both categories are intended as aiding tools in testing the library and development of adventures.


## Debugging Verbs

These are the debugging verbs added to any adventure by the debug module:

|         syntax        |                   description                   |
|-----------------------|-------------------------------------------------|
| `dbg_clothes (obj)*!` | Shows info about a clothing item.               |
| `dbg_comp (act)*!`    | Shows compliance state of actors.               |
| `dbg_inv (act)*!`     | Show contents of an actor using `LIST` command. |

<!-- 
| `xxxx`                | xxx                                      |
-->


### DBG_CLOTHES

The verb `DBG_CLOTHES <CLOTHING>` will print crucial information about clothing items: coverage values, special attributes, if it's donned and by who.

It allows multi-paramenters and it's omnipotent.

Useful to track the status of clothing items and check that the library is handling all clothing as expected, and that verbs which move around objects are not dislocating worn clothes without setting them to `NOT donned`.

### DBG_COMP

The verb `DBG_COMP <ACTOR>` will show the compliance state of an actor.

### DBG_INV

The verb `DBG_INV <ACTOR>` will print out the inventory of an actor by using the `LIST` instruction.

Useful to check how worn items are handled by `LIST`, since authors might use `LIST` in their own adventures.


## Helper Verbs

These are the helper verbs added to any adventure by the debug module:

|         syntax        |               description                |
|-----------------------|------------------------------------------|
| `subjugate (act)*`    | Toggles the compliancy state of an actor |

<!-- 
| `xxxx`                | xxx                                      |
-->

### SUBJUGATE

The verb `SUBJUGATE <ACTOR>` will toggle the compliancy state of an actor.

A useful shortcut to alter compliancy of actors and test how verbs that depend on actors' compliancy behave in different compliancy contexts.

<!-----------------------------------------------------------------------------
                               REFERENCE LINKS                                
------------------------------------------------------------------------------>

<!-- PROJECT FILES -->

[inc_debug]: ./inc_debug.i "View module source code"


<!-- EOF -->