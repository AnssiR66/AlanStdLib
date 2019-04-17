# The New Clothing System

This temporary document describres the new clothing system.

> __WIP NOTE__ — The document is still a draft.

-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Introduction](#introduction)
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

# Introduction

During development work, I'll add to this document a description of how the new clothing system works. It's easier to do this step by step, while working on the single changes, instead of writing it all after the work is done.

Ultimately, the contents of this document can be used to document the new system (either in the sources or in a separate document), with only slight adaptations being required.

During the development stages, and before merging into `master`, this document provides an important reference for checking that everything is fine with new system, especially for asking end-users opinions on these changes.

# The New Clothing System

Here's how the new clothing system works, with some notes on how it differs from the original approach.

## Clothing and Wearability

The worn status of any wearable item is controlled by the `worn` boolean attribute only (available on `thing` class).

The criteria to distinguish between worn and not-worn items is simple:

- Any `clothing IS worn DIRECLY IN` an actor is a worn item.
- Any `clothing INDIRECLY IN` an actor _can not be_ a worn item.
- Any  `clothing DIRECLY IN` an actor might be a worn item or not, depending on the value of its `worn` attribute.

Therefore, in the new system is sufficient to ensure that any verb (or event or script) that _might_ dislocate clothing items outside an actor also sets the dislocated item as `NOT worn` — if the item is not of a wearable type it doesn't matter, for non clothing items should be set to `NOT worn` anyhow.

It's important to notice here that, although the library only offers werables of `clothing` type, the new system introduces a general concept of 'wearability', which extends also to other types of wearables which authors might implement. 

The library redefines many verbs on the `clothing` class to ensure that clothing is handled as expected by the vanilla library, which also includes additional CHECKs to prevent most verbs from dislocating worn items.

## Extensibility of Wearables to Non-Clothing

The new system allows authors to easily implement wearables which are not of the `clothing` class. For example, authors might wish to extend the `device` class to implement wearable gadgets (eg, VR googles, headphones) or other types of wearables.

The `worn` attribute is defined on the `thing` class instead of the `clothing` class because:

1. It allows implementing CHECKS on any verb.
2. Authors might implement non-clothing wearable object in their adventures.

In view of possible author-defined wearables, the Library also ensures that any of its built-in verbs that move around objects always set them to `NOT worn`. This means that authors implementing custom wearables won't have to worry about library verbs mishandling worn objects status.

Obviously, when implement custom wearable types, authors are better off implementing some new class for them and override on the new class many of the base library verbs, just like the library does with `clothing`. 

## Working With Clothes in Adventures

Now, to create worn items in an adventure, authors only need to locate the clothing instance directly in the wearing actor and set it to `worn`:

```alan
THE shoes IsA clothing IN hero.
  IS worn.
```

## Layered Clothing

The new system only checks that clothing items with coverage values other than zero are worn/removed in the correct order, but it no longer hard-codes special cases handling for skirts, coats and teddies — these are still implementable, via some new optional attributes on clothing items, but there are no specially assigned layers for them.

### Non Exponential Layers Numbering

The new system doesn't impose exponential layer numbering (2, 4, 8, 16, 32, 64). Authors are free to organize layers how they see fit. This allows a more intuitive layering system in final adventures, where arbitraty ranges can be employed without restrcitions.

### New Face Zone

The new system also adds a new `facecover` attribute to allow better handling of facewear like goggles, fake beards, masks, etc., without relying on `headcover`.


### New Attributes for Special Clothing

Now to create a skirt or coat like clothing, the library provides some new (optional) attributes that can be used to define special clothing types.

Any clothing item is considered to block wearing/removing items occupying the same body area in lower layers. To allow simulating skirts and coats, which don't prevent wearing/removing leg-only garnments in the lower layers, there's a new `blockslegs` attribute, which can be set to false:

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



<!-- EOF -->