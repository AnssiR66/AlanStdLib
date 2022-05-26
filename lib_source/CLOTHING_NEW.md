# The New Clothing System

This temporary document describes the new clothing system and the reasons for its adoption.

***DELETE BEFORE MERGING INTO `master`!!!***

> __WIP NOTE__ — The document is still an incomplete draft.

-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [About This Document](#about-this-document)
- [The New Clothing System](#the-new-clothing-system)
    - [Clothing and Wearability](#clothing-and-wearability)
    - [Extensibility of Wearables to Non-Clothing](#extensibility-of-wearables-to-non-clothing)
    - [Working With Clothes in Adventures](#working-with-clothes-in-adventures)
    - [Layered Clothing](#layered-clothing)
        - [Non Exponential Layers Numbering](#non-exponential-layers-numbering)
        - [New Face Zone](#new-face-zone)
        - [New Attributes for Special Clothing](#new-attributes-for-special-clothing)

<!-- /MarkdownTOC -->

-----

# About This Document

During development work, I'll add to this document a description of how the new clothing system works. It's easier to do this step by step, while working on the single changes, instead of writing it all after the work is done.

Ultimately, these contents can be reused to document the new system (either in the sources or in a separate document), with only slight adaptations being required.

During the development stages (before merging into `master`) this document provides an important reference for checking that everything is fine with new system, especially for asking end-users opinions on these changes.

# The New Clothing System

Here's how the new clothing system works, with some notes on how it differs from the original approach.

## Clothing and Wearability

The worn status of any wearable item is controlled by the `worn` (boolean) and `wearer` (reference) attributes (both defined on the `thing` class).

The criteria to distinguish between worn and unworn items is simple:

- Any `clothing IS worn DIRECLY IN` an actor is a worn item.
- Any `clothing INDIRECLY IN` an actor _can not be_ a worn item.
- Any  `clothing DIRECLY IN` an actor might be a worn item or not, depending on the value of its `worn` attribute.

The `worn` attribute is used to ascertain the worn status, whereas the `wearer` attribute is mainly used to gain a quick reference to the wearer, e.g. in verb failure responses, although it might also be exploited as a mean to verify in a single step if a given actor is the wearer of an object.

Therefore, in the new system it's sufficient to ensure that any verb (or event or script) that _might_ dislocate clothing items outside an actor also sets the dislocated item as being `NOT worn` and `HAS wearer nobody` — if the item is not a wearable type it doesn't matter, for non-clothing items always have the `NOT worn` and `HAS wearer nobody` status in the library anyhow.

It's important to notice here that, although the library only offers wearables of `clothing` type, the new system introduces a general concept of 'wearability', which extends also to other types of wearables which authors might implement.

The library redefines many verbs on the `clothing` class to ensure that clothing is handled as expected by the vanilla library, which also includes additional CHECKs to prevent most verbs from dislocating worn items.


## Extensibility of Wearables to Non-Clothing

> See Issues [#119] and [#101].

The new system allows authors to easily implement wearables which are not of the `clothing` class. For example, authors might wish to extend the `device` class to implement wearable gadgets (eg, VR googles, headphones) or other types of wearables.

The `worn` attribute is defined on the `thing` class instead of the `clothing` class because:

1. It allows implementing CHECKS on any verb.
2. Authors might implement non-clothing wearable object in their adventures.

In view of possible author-defined wearables, the Library also ensures that any of its built-in verbs that move around objects always set them to `NOT worn` and `HAS wearer nobody`. This means that authors implementing custom wearables won't have to worry about library verbs mishandling worn objects status.

Obviously, when adding custom wearable types to their adventures authors are better off implementing them via some new class and then override on the new class many of the base library verbs, just like the library does with `clothing`.

## Working With Clothes in Adventures

With the new system, to create items worn at games start authors only need to locate the clothing instance directly in the wearing actor and set it to `worn`:

```alan
THE shoes IsA clothing IN hero.
  IS worn.
```

The library will automatically take care of making the `wearer` attribute of every worn object (clothing or otherwise) point to its wearer during the initialization of the ACTOR class. This feature was added to make it easier for authors to handle wearables in the default game world state.

As for any programmatic changes to wearables objects after the game has started, authors will have to remember to also correctly adjust the `wearer` attribute whenever wearable items are moved around in custom code (verbs, rules, events, scripts, etc.).


## Layered Clothing

The new system only checks that clothing items with coverage values other than zero are worn/removed in the correct order, but it no longer hard-codes special cases handling for skirts, coats and teddies — these are still implementable, via some new optional attributes on clothing items, but there are no specially assigned layers for them.

### Non Exponential Layers Numbering

The new system doesn't impose exponential layer numbering (2, 4, 8, 16, 32, 64). Authors are free to organize layers how they see fit. This allows a more intuitive layering system in final adventures, where arbitrary ranges can be employed without restrictions.

### New Face Zone

The new system also adds a new `facecover` attribute to allow better handling of facewear like goggles, fake beards, masks, etc., without relying on `headcover`.


### New Attributes for Special Clothing

Now to create a skirt or coat like clothing, the library provides some new (optional) attributes that can be used to define special clothing types.

Any clothing item is considered to block wearing/removing items occupying the same body area in lower layers. To allow simulating skirts and coats, which don't prevent wearing/removing leg-only garments in the lower layers, there's a new `blockslegs` attribute, which can be set to false:

```alan
THE skirt IsA clothing
  HAS botcover 5.
  IS NOT blockslegs.
```

During the wear/remove checks, the library will discount items which are `NOT blockslegs` from the list of worn items preventing the action, as long as the item being worn/removed has `topcover = 0` (ie. it's not like a teddy).

Sometimes authors might wish to treat two separate clothing item as if it was a single item, e.g. a bikini, so that it can be worn/removed in a single action. In such cases, we must tell the library that the item is composed of two independent pieces so that (although it has a `topcover <> 0` value) it should be wearable while wearing a skirt:

```alan
THE bikini IsA clothing
  HAS topcover 1.
  HAS botcover 1.
  IS twopieces.
```



<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

[#119]: https://github.com/AnssiR66/AlanStdLib/issues/119 "Issue #119 — Actors' Possessions Lists: Mention Non-Clothing Wearables"
[#101]: https://github.com/AnssiR66/AlanStdLib/issues/101 "Issue #101 — Tweak WEAR and REMOVE to Allow Custom Wearables"

<!-- EOF -->
