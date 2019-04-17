-- ALAN Standard Library v2.1
-- Classes (file name: 'lib_classes.i')


-- This library file defines various object and actor classes.
-- Many of these classes are frequently used in verb definitions in 'lib_verbs.i'
-- so they should be edited or removed with caution. However, to ease things up,
-- it is mentioned at the beginning of every class below if and where the class
-- is cross-referenced in the other library files.


---- First, we define the default description for scenery objects
--   = no description at all


ADD TO EVERY OBJECT

  DESCRIPTION
    CHECK THIS IS NOT scenery
    ELSE SAY "".

END ADD.


--------------------------------------------------------------------------------
--                                .: CONTENTS :.
--------------------------------------------------------------------------------

-- 1. OBJECT CLASSES
-- =================

--+-----------------------------------------------------------------------------
--| CLOTHING
--+-----------------------------------------------------------------------------
--| * Is a piece of clothing that behaves according to Alan Bampton's 'xwear.i'
--|   extension.
--| * The said extension has been fully assimilated to this library.
--| * This extension prevents clothes from being worn in an illogical order,
--|   for example you cannot put on a shirt if you are already wearing a jacket,
--|   and so forth.
--| * This only applies to the hero; NPCs can't wear clothing in layers.
--| * Also the verbs 'wear', 'remove' and 'undress' are defined here.
--+-----------------------------------------------------------------------------
--| DEVICE
--+-----------------------------------------------------------------------------
--| * Is a machine or an electronic device, for example a TV. Can be turned
--|   (= switched) on and off, unless it's broken.
--| * Attributes: 'on' and 'NOT on', 'NOT broken'.
--| * Is described by default as being either on or off when examined.
--+-----------------------------------------------------------------------------
--| DOOR
--+-----------------------------------------------------------------------------
--| * Can be opened, closed, and optionally locked and unlocked.
--| * Is by default 'NOT open', 'NOT lockable'.
--| * All default attributes:
--|   openable, NOT open, NOT lockable, NOT locked; NOT takeable.
--| * Is described by default as being either open or closed when examined.
--+-----------------------------------------------------------------------------
--| LIQUID
--+-----------------------------------------------------------------------------
--| * Can only be taken if it's in a container.
--| * You can fill something with it, and you can pour it somewhere.
--| * A liquid is by default NOT drinkable.
--+-----------------------------------------------------------------------------
--| LIGHTSOURCE
--+-----------------------------------------------------------------------------
--| * IS natural or NOT natural
--|   (a natural lightsource is for example a match or a torch).
--| * Can be turned on and off, lighted and extinguished (= put out) unless it's
--|   broken. A natural lightsource cannot be turned on or off, it can only be
--|   lighted and extinguished (= put out).
--| * When examined, a lightsource is automatically supplied with a description
--|   of whether it is providing light or not.
--+-----------------------------------------------------------------------------
--| LISTED_CONTAINER
--+-----------------------------------------------------------------------------
--| * Is a container object.
--| * The contents of a listed_container will be listed both after 'look' (= in
--|   the room description), 'look in' and 'examine' (if the container is open).
--|   (The contents of a normal container object are not listed after 'examine'
--|   by default, but only after 'look' (= room description) and 'look in').
--+-----------------------------------------------------------------------------
--| SOUND
--+-----------------------------------------------------------------------------
--| * Can be listened to but not examined, searched, smelled or manipulated.
--| * (Can be turned on and off if desirable.)
--+-----------------------------------------------------------------------------
--| SUPPORTER
--+-----------------------------------------------------------------------------
--| * You can put things on this and you can stand on this.
--| * It's declared a container, so you can take things from it, as well.
--| * Contents of a supporter are listed by default in the room description and
--|   after 'examine'.
--+-----------------------------------------------------------------------------
--| WEAPON
--+-----------------------------------------------------------------------------
--| * IS fireable (e.g. a cannon) or NOT fireable (e.g. a baseball bat).
--+-----------------------------------------------------------------------------
--| WINDOW
--+-----------------------------------------------------------------------------
--| * Can be opened, closed, looked through and out of.
--| * Will be by default described as being either open or closed when examined.
--+-----------------------------------------------------------------------------



-- 2. ACTOR CLASSES
-- ================

-- ACTORS are defined to be NOT inanimate CONTAINERS (so that they can for
-- example receive and carry things).
--
-- Actors are usually preceded by an article in-game, for example:
--   | You see a man here.
--   | There is nothing special about the dog.
-- unless they are declared as 'named'.
--
-- The following classes for actors are defined in this library:

--+-----------------------------------------------------------------------------
--| PERSON
--+-----------------------------------------------------------------------------
--| * is able to talk (= 'CAN talk').
--+-----------------------------------------------------------------------------
--| FEMALE
--+-----------------------------------------------------------------------------
--| * A subclass of person (= is able to talk)-
--| * Can be referred to with the pronoun 'her'-
--+-----------------------------------------------------------------------------
--| MALE
--+-----------------------------------------------------------------------------
--| * A subclass of person (= is able to talk)-
--| * Can be referred to with the pronoun 'him'-
--+-----------------------------------------------------------------------------

-- The contents end here.



-- =============================================================

-- =============================================================
--
-- 1. Object classes
--
-- =============================================================

-- =============================================================






-- ==============================================================


----- CLOTHING


-- ==============================================================

-- To use this class, see the documentation text right after the
-- code below.

-- This class makes use of Alan Bampton's 'xwear.i' extension
-- written originally for ALAN V2, converted here to V3 and
-- assimilated fully to the present library. Thanks to Alan Bampton
-- for the permission to use the code here.


-----------------------------------------------------------------
-- Define attributes used internally by the library for clothing.
-----------------------------------------------------------------

ADD TO EVERY definition_block
  HAS temp_cnt 0.
  -- Internal counter used by the library when listing clothing items,
  -- in order to identify the second-last item and use "and" instead of
  -- the comma separator.

  HAS temp_clothes { clothing }.
  -- Temporary set used by the library to track clothes preventing
  -- wear/remove, in order to list them in the verb response message.
END ADD TO definition_block.


-------------------------------------------------------------------
-- Now, we define some common attributes for clothing as well as
-- how the verbs 'remove', 'undress' and 'wear' (and their synonyms)
-- behave with this class.
-------------------------------------------------------------------

-- NOTE: The 'worn' attribute is defined on the 'thing' class, in module
--       'lib_definitions.i'. This was done for two reasons:
--
-- 1. It allows more flexible syntax and verb checks.
--
-- 2. Authors might want to implement non-clothing wearables (e.g. devices like
--    headphones, VR headsets, etc.), therefore the 'worn' state should not be
--    exclusive to the clothing class.

EVERY clothing ISA OBJECT

  IS wearable.

  IS sex 0. -- If not zero, restricts wearing to actors with same 'sex' value.

  -- Body coverage layered-values, by area:
  IS headcover  0.  -- Head.
  IS facecover  0.  -- Face.
  IS handscover 0.  -- Hands.
  IS feetcover  0.  -- Feet.
  IS topcover   0.  -- Chest and arms.
  IS botcover   0.  -- Pelvis and legs.

  -- Attributes for special clothing (skirts, coats, bikinis, etc.):

  IS blockslegs.
  -- i.e. the item prevents wearing/removing legsware from the layers below
  -- (skirts and coats are 'NOT blockslegs').

  IS NOT twopieces.
  -- For items covering legs + torso ('topcover' & 'botcover' <> 0) that should
  -- be treated as a single piece (e.g. a one-piece swimming suite).
  -- Items which are 'twopieces' (eg. a bikini) can be worn/removed while
  -- wearing a skirt for, although handled as a single clothing item, they cover
  -- legs and torso via two separate pieces.
  
  INITIALIZE

    -- Any objects inside a clothing item (e.g. a wallet in a jacket) will be
    -- allowed to be put back into its original containing clothing once taken
    -- out from it:

    FOR EACH o ISA OBJECT, DIRECTLY IN THIS
      DO INCLUDE o IN allowed OF THIS.
    END FOR.


  CONTAINER
  -- To allow for example a wallet to be put into a jacket.

  -- If the clothing item contains something, e.g. a jacket contains a wallet,
  -- the wallet will be mentioned by default when the jacket is examined:

  VERB examine
    DOES AFTER
      IF THIS IS NOT OPAQUE
        THEN
          IF COUNT ISA OBJECT, DIRECTLY IN THIS > 0
            THEN LIST THIS.
          END IF.
      END IF.
  END VERB examine.

  -- ===========================================================================
  -- Block verbs that could dislocate worn clothing items
  -- ===========================================================================

  -- The following verbs are extended on the 'clothing' class with additional
  -- CHECKs to prevent displacing worn clothing items from their wearer:
  --
  --   * give
  --   * put_in
  --   * put_on
  --   * throw
  --   * throw_at
  --   * throw_in
  --   * throw_to
  --   * tie_to

  -- +----------------------------------------------------------------------+
  -- | If you want to prevent NPCs from giving their clothes when asked to, |
  -- | either uncomment the following code or add it to your adventure:     |
  -- +----------------------------------------------------------------------+
  -- VERB ask_for --> ask (act) 'for' (obj)
  --   WHEN obj
  --     CHECK obj IS NOT worn
  --       ELSE
  --         IF obj IN hero
  --           THEN SAY my_game:check_obj2_not_in_hero3.
  --           ELSE
  --             FOR EACH ac IsA actor DO
  --               IF THIS IN ac
  --                 THEN SAY THE ac. "is wearing $+2."
  --               END IF.
  --             END FOR.
  --         END IF.
  -- END VERB ask_for.
  -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  VERB give --> 'give' (obj) 'to' (recipient)
    WHEN obj
      CHECK obj IS NOT worn
        ELSE
          IF obj IN hero
            THEN SAY my_game:check_obj_not_in_worn3.
            ELSE
              IF obj IS NOT plural
                --       "Currently $+1 [is/are] worn by"
                THEN SAY my_game:check_obj1_not_worn_by_NPC_sg.
                ELSE SAY my_game:check_obj1_not_worn_by_NPC_pl.
              END IF.
              FOR EACH ac IsA actor DO
                IF obj IN ac
                  THEN SAY THE ac. "."
                END IF.
              END FOR.
          END IF.
  END VERB give.


  VERB put_in --> put (obj) 'in' (cont)
    WHEN obj
      CHECK obj IS NOT worn
        ELSE
          IF obj IN hero
            THEN SAY my_game:check_obj_not_in_worn3.
            ELSE
              IF obj IS NOT plural
                --       "Currently $+1 [is/are] worn by"
                THEN SAY my_game:check_obj1_not_worn_by_NPC_sg.
                ELSE SAY my_game:check_obj1_not_worn_by_NPC_pl.
              END IF.
              FOR EACH ac IsA actor DO
                IF obj IN ac
                  THEN SAY THE ac. "."
                END IF.
              END FOR.
          END IF.
  END VERB put_in.


  VERB put_on --> put (obj) 'on' (surface)
    WHEN obj
      CHECK obj IS NOT worn
        ELSE
          IF obj IN hero
            THEN SAY my_game:check_obj_not_in_worn3.
            ELSE
              IF obj IS NOT plural
                --       "Currently $+1 [is/are] worn by"
                THEN SAY my_game:check_obj1_not_worn_by_NPC_sg.
                ELSE SAY my_game:check_obj1_not_worn_by_NPC_pl.
              END IF.
              FOR EACH ac IsA actor DO
                IF obj IN ac
                  THEN SAY THE ac. "."
                END IF.
              END FOR.
          END IF.
  END VERB put_on.


  VERB throw --> throw (projectile)
    CHECK projectile IS NOT worn
      ELSE
        IF projectile IN hero
          THEN SAY my_game:check_obj_not_in_worn3.
          ELSE
            IF projectile IS NOT plural
              --       "Currently $+1 [is/are] worn by"
              THEN SAY my_game:check_obj1_not_worn_by_NPC_sg.
              ELSE SAY my_game:check_obj1_not_worn_by_NPC_pl.
            END IF.
            FOR EACH ac IsA actor DO
              IF projectile IN ac
                THEN SAY THE ac. "."
              END IF.
            END FOR.
        END IF.
  END VERB throw.


  VERB throw_at --> throw (projectile) 'at' (target)
    WHEN projectile
      CHECK projectile IS NOT worn
        ELSE
          IF projectile IN hero
            THEN SAY my_game:check_obj_not_in_worn3.
            ELSE
              IF projectile IS NOT plural
                --       "Currently $+1 [is/are] worn by"
                THEN SAY my_game:check_obj1_not_worn_by_NPC_sg.
                ELSE SAY my_game:check_obj1_not_worn_by_NPC_pl.
              END IF.
              FOR EACH ac IsA actor DO
                IF projectile IN ac
                  THEN SAY THE ac. "."
                END IF.
              END FOR.
          END IF.
  END VERB throw_at.


  VERB throw_in --> throw (projectile) 'in' (cont)
    WHEN projectile
      CHECK projectile IS NOT worn
        ELSE
          IF projectile IN hero
            THEN SAY my_game:check_obj_not_in_worn3.
            ELSE
              IF projectile IS NOT plural
                --       "Currently $+1 [is/are] worn by"
                THEN SAY my_game:check_obj1_not_worn_by_NPC_sg.
                ELSE SAY my_game:check_obj1_not_worn_by_NPC_pl.
              END IF.
              FOR EACH ac IsA actor DO
                IF projectile IN ac
                  THEN SAY THE ac. "."
                END IF.
              END FOR.
          END IF.
  END VERB throw_in.


  VERB throw_to --> throw (projectile) 'to' (recipient)
    WHEN projectile
      CHECK projectile IS NOT worn
        ELSE
          IF projectile IN hero
            THEN SAY my_game:check_obj_not_in_worn3.
            ELSE
              IF projectile IS NOT plural
                --       "Currently $+1 [is/are] worn by"
                THEN SAY my_game:check_obj1_not_worn_by_NPC_sg.
                ELSE SAY my_game:check_obj1_not_worn_by_NPC_pl.
              END IF.
              FOR EACH ac IsA actor DO
                IF projectile IN ac
                  THEN SAY THE ac. "."
                END IF.
              END FOR.
          END IF.
  END VERB throw_to.


  VERB tie_to --> tie (obj) 'to' (target)
    WHEN obj
      CHECK obj IS NOT worn
        ELSE
          IF obj IN hero
            THEN SAY my_game:check_obj_not_in_worn3.
            ELSE
              IF obj IS NOT plural
                --       "Currently $+1 [is/are] worn by"
                THEN SAY my_game:check_obj1_not_worn_by_NPC_sg.
                ELSE SAY my_game:check_obj1_not_worn_by_NPC_pl.
              END IF.
              FOR EACH ac IsA actor DO
                IF obj IN ac
                  THEN SAY THE ac. "."
                END IF.
              END FOR.
          END IF.
  END VERB tie_to.

  ------------------------------------------------------------------------------
  VERB wear
  ------------------------------------------------------------------------------
    CHECK sex OF THIS = sex OF hero OR sex OF THIS = 0
      ELSE SAY check_clothing_sex OF my_game.
    AND THIS IS NOT worn
      ELSE
        IF THIS IN hero
          --      "You are already wearing $+1."
          THEN SAY my_game:check_obj_not_in_worn1.
          ELSE
            IF THIS IS NOT plural
              --      "Currently $+1 [is/are] worn by""
              THEN SAY my_game:check_obj1_not_worn_by_NPC_sg.
              ELSE SAY my_game:check_obj1_not_worn_by_NPC_pl.
            END IF.
            FOR EACH ac IsA actor DO
              IF THIS IN ac
                THEN SAY THE ac. "."
              END IF.
            END FOR.
        END IF.

    DOES ONLY
      --------------------------------------------------------------------
      -- Clothes which prevent the action are stored in a temporary set in
      -- order to list all blocking items in the verb failure response.
      --------------------------------------------------------------------
      -- Empty the temporary set:
      -- ------------------------
      SET my_game:temp_clothes TO {}.
      -- -----------------------------------------------------------------------
      -- Check if the item being worn is subjected to ordered layering
      -- -----------------------------------------------------------------------
      IF  THIS:headcover
        + THIS:facecover
        + THIS:topcover
        + THIS:botcover
        + THIS:feetcover
        + THIS:handscover <> 0
        THEN
          -- -------------------------------------------------------------------
          -- Every worn clothing with a layer value equal or greater than the
          -- value of the item we're trying to wear is a blocking item which
          -- prevents the action.
          -- -------------------------------------------------------------------
          FOR EACH item IsA clothing, DIRECTLY IN hero, IS worn
            DO
              IF THIS:headcover  <> 0 AND THIS:headcover  <= item:headcover
                THEN INCLUDE item IN my_game:temp_clothes.
              END IF.
              IF THIS:facecover  <> 0 AND THIS:facecover  <= item:facecover
                THEN INCLUDE item IN my_game:temp_clothes.
              END IF.
              IF THIS:topcover   <> 0 AND THIS:topcover   <= item:topcover
                THEN INCLUDE item IN my_game:temp_clothes.
             END IF.
              IF THIS:botcover   <> 0 AND THIS:botcover   <= item:botcover
                THEN
                  -- -----------------------------------------------------------
                  -- Carry out special checks for 'NOT blockslegs'
                  -- -----------------------------------------------------------
                  -- If the item standing in the way is a leg-blocker, prevent:
                  IF item:blockslegs
                    THEN INCLUDE item IN my_game:temp_clothes.
                  -- Otherwise, it must be a skirt or a coat.
                  -- Check that the handled item is not a single-piece clothing
                  -- covering both legs and torso:
                  ELSIF THIS:topcover <> 0 AND THIS IS NOT twopieces
                    THEN INCLUDE item IN my_game:temp_clothes.
                  END IF.
              END IF.
              IF THIS:feetcover  <> 0 AND THIS:feetcover  <= item:feetcover
                THEN INCLUDE item IN my_game:temp_clothes.
              END IF.
              IF THIS:handscover <> 0 AND THIS:handscover <= item:handscover
                THEN INCLUDE item IN my_game:temp_clothes.
              END IF.
          END FOR.
      END IF.

      --========================================================================
      -- Outcome of the wear action...
      --========================================================================

      SET my_game:temp_cnt TO COUNT IsA clothing, IN my_game:temp_clothes.
      IF my_game:temp_cnt <> 0
        THEN
          -- ----------------------------------
          -- It's not possible to wear the item
          -- ----------------------------------
          -- We'll just take it (if not already possessed).

          -- >>> implicit take >>>
          IF THIS NOT IN hero
            THEN "You pick up $+1."
          END IF.
          LOCATE THIS IN hero.
          -- <<< implicit take <<<
          -- -------------------------------------
          -- List worn items preventing the action
          -- -------------------------------------
          "In order to wear $+1 you should first take off"
          FOR EACH blocking_item IsA clothing, IN my_game:temp_clothes
            DO
              SAY THE blocking_item.
              DECREASE my_game:temp_cnt.
              DEPENDING ON my_game:temp_cnt
                = 1 THEN "and"
                = 0 THEN "."
                ELSE ","
              END DEPEND.
          END FOR.
        ELSE
          -- ------------------------------
          -- It's possible to wear the item
          -- ------------------------------
          IF THIS NOT IN hero
            THEN
              -- ------------------------------
              -- The item is picked up and worn
              -- ------------------------------
            "You pick up $+1 and put"
            IF THIS IS NOT plural
              THEN  "it"
              ELSE  "them"
            END IF. "on."
            ELSE
              -- -----------------------
              -- The item is simply worn
              -- -----------------------
              "You put on $+1."
          END IF.
          LOCATE THIS IN hero.
          MAKE THIS worn.
      END IF.
  END VERB wear.

  ------------------------------------------------------------------------------
  VERB remove
  ------------------------------------------------------------------------------
    CHECK THIS DIRECTLY IN hero AND THIS IS worn
      ELSE SAY my_game:check_obj_in_worn.
    AND CURRENT LOCATION IS lit
      ELSE SAY check_current_loc_lit OF my_game.

    DOES ONLY
      --------------------------------------------------------------------
      -- Clothes which prevent the action are stored in a temporary set in
      -- order to list all blocking items in the verb failure response.
      --------------------------------------------------------------------
      -- Empty the temporary set:
      -- ------------------------
      SET my_game:temp_clothes TO {}.
      -- -----------------------------------------------------------------------
      -- Check if the item being removed is subjected to ordered layering
      -- -----------------------------------------------------------------------
      IF  THIS:headcover
        + THIS:facecover
        + THIS:topcover
        + THIS:botcover
        + THIS:feetcover
        + THIS:handscover <> 0
        THEN
          -- -------------------------------------------------------------------
          -- Every worn clothing with a layer value equal or greater than the
          -- value of the item we're trying to remove is a blocking item which
          -- prevents the action.
          -- -------------------------------------------------------------------
          FOR EACH item IsA clothing, DIRECTLY IN hero, IS worn
            DO
              IF THIS:headcover  <> 0 AND THIS:headcover  < item:headcover
                THEN INCLUDE item IN my_game:temp_clothes.
              END IF.
              IF THIS:facecover  <> 0 AND THIS:facecover  < item:facecover
                THEN INCLUDE item IN my_game:temp_clothes.
              END IF.
              IF THIS:topcover   <> 0 AND THIS:topcover   < item:topcover
                THEN INCLUDE item IN my_game:temp_clothes.
             END IF.
              IF THIS:botcover   <> 0 AND THIS:botcover   < item:botcover
                THEN
                  -- -----------------------------------------------------------
                  -- Carry out special checks for 'NOT blockslegs'
                  -- -----------------------------------------------------------
                  -- If the item standing in the way is a leg-blocker, prevent:
                  IF item:blockslegs
                    THEN INCLUDE item IN my_game:temp_clothes.
                  -- Otherwise, it must be a skirt or a coat.
                  -- Check that the handled item is not a single-piece clothing
                  -- covering both legs and torso:
                  ELSIF THIS:topcover <> 0 AND THIS IS NOT twopieces
                    THEN INCLUDE item IN my_game:temp_clothes.
                  END IF.
              END IF.
              IF THIS:feetcover  <> 0 AND THIS:feetcover  < item:feetcover
                THEN INCLUDE item IN my_game:temp_clothes.
              END IF.
              IF THIS:handscover <> 0 AND THIS:handscover < item:handscover
                THEN INCLUDE item IN my_game:temp_clothes.
              END IF.
          END FOR.
      END IF.

      --========================================================================
      -- Outcome of the remove action...
      --========================================================================

      SET my_game:temp_cnt TO COUNT IsA clothing, IN my_game:temp_clothes.
      IF my_game:temp_cnt <> 0
        THEN
          -- ------------------------------------
          -- It's not possible to remove the item
          -- ------------------------------------
          "In order to remove $+1 you should first take off"
          FOR EACH blocking_item IsA clothing, IN my_game:temp_clothes
            DO
              SAY THE blocking_item.
              DECREASE my_game:temp_cnt.
              DEPENDING ON my_game:temp_cnt
                = 1 THEN "and"
                = 0 THEN "."
                ELSE ","
              END DEPEND.
          END FOR.
        ELSE
          -- --------------------------------
          -- It's possible to remove the item
          -- --------------------------------
          "You take off $+1."
          LOCATE THIS IN hero.
          MAKE THIS NOT worn.
      END IF.
  END VERB remove.
END EVERY.


--------------------------------------------------------------------
-- These attributes are used internally in the library - ignore!
--------------------------------------------------------------------

ADD TO EVERY ACTOR
  IS sex 0.
END ADD TO.




-- =============================================================


----- DEVICE


-- =============================================================


-- (This class is not cross-referenced elsewhere in this or any other library file.)


EVERY device ISA OBJECT


  VERB examine
    DOES AFTER
      IF THIS IS NOT plural
        THEN "It is"
        ELSE "They are"
      END IF.

      IF THIS IS 'on'
        THEN "currently on."
        ELSE "currently off."
      END IF.
  END VERB examine.


  VERB turn_on
    CHECK THIS IS NOT 'on'
      ELSE
        IF THIS IS NOT plural
          THEN SAY check_device_not_on_sg OF my_game.
          ELSE SAY check_device_not_on_pl OF my_game.
        END IF.
    AND CURRENT LOCATION IS lit
      ELSE SAY check_current_loc_lit OF my_game.
    AND THIS IS reachable AND THIS IS NOT distant
      ELSE
        IF THIS IS NOT reachable
          THEN
            IF THIS IS NOT plural
              THEN SAY check_obj_reachable_sg OF my_game.
              ELSE SAY check_obj_reachable_pl OF my_game.
            END IF.
        ELSIF THIS IS distant
          THEN
            IF THIS IS NOT plural
              THEN SAY check_obj_not_distant_sg OF my_game.
              ELSE SAY check_obj_not_distant_pl OF my_game.
            END IF.
        END IF.
    AND THIS IS NOT broken
      ELSE SAY check_obj_not_broken OF my_game.
    DOES ONLY
      "You turn on" SAY THE THIS. "."
      MAKE THIS 'on'.
  END VERB turn_on.


  VERB turn_off
    CHECK THIS IS 'on'
      ELSE
         IF THIS IS NOT plural
          THEN SAY check_device_on_sg OF my_game.
          ELSE SAY check_device_on_pl OF my_game.
         END IF.
    AND CURRENT LOCATION IS lit
      ELSE SAY check_current_loc_lit OF my_game.
    AND THIS IS reachable AND THIS IS NOT distant
      ELSE
        IF THIS IS NOT reachable
          THEN
            IF THIS IS NOT plural
              THEN SAY check_obj_reachable_sg OF my_game.
              ELSE SAY check_obj_reachable_pl OF my_game.
            END IF.
        ELSIF THIS IS distant
          THEN
            IF THIS IS NOT plural
              THEN SAY check_obj_not_distant_sg OF my_game.
              ELSE SAY check_obj_not_distant_pl OF my_game.
            END IF.
        END IF.
    DOES ONLY
      "You turn off" SAY THE THIS. "."
      MAKE THIS NOT 'on'.
  END VERB turn_off.


-- The following verb switches a device off if the device is on, and vice versa.


  VERB switch
    CHECK CURRENT LOCATION IS lit
      ELSE SAY check_current_loc_lit OF my_game.
    AND THIS IS reachable AND THIS IS NOT distant
      ELSE
        IF THIS IS NOT reachable
          THEN
            IF THIS IS NOT plural
              THEN SAY check_obj_reachable_sg OF my_game.
              ELSE SAY check_obj_reachable_pl OF my_game.
            END IF.
        ELSIF THIS IS distant
          THEN
            IF THIS IS NOT plural
              THEN SAY check_obj_not_distant_sg OF my_game.
              ELSE SAY check_obj_not_distant_pl OF my_game.
            END IF.
        END IF.
    AND THIS IS NOT broken
      ELSE SAY check_obj_not_broken OF my_game.
    DOES ONLY
      IF THIS IS 'on'
        THEN "You switch off" SAY THE THIS. "."
          MAKE THIS NOT 'on'.
        ELSE "You switch on" SAY THE THIS. "."
          MAKE THIS 'on'.
      END IF.
  END VERB switch.

END EVERY.



-- =============================================================


----- DOOR


-- =============================================================


-- (This class is not cross-referenced elsewhere in this or any other library file.)


EVERY door ISA OBJECT
  IS openable.
  IS NOT open.
  IS NOT lockable.
  IS NOT locked.
  IS NOT takeable.


  HAS otherside null_door.
  -- The other side of the door in the next room will be automatically taken care
  -- of so that it shows correctly in any room or object descriptions.
  -- 'null_door' is a dummy default that can be ignored.



  INITIALIZE

    -- ensuring that the author didn't forget to declare a locked door closed
    -- (= NOT open), as well. This is just double-checking, as any door is by
    -- default closed (= "NOT open") at the start of the game:

    IF THIS IS locked
      THEN
        IF THIS IS open
          THEN MAKE THIS NOT open.
        END IF.
    END IF.

    -- ensuring that if a door has an otherside attribute declared, this
    -- otherside will have the original door as its otherside in turn:

    IF otherside OF THIS <> null_door
      THEN
        SET otherside OF otherside OF THIS TO THIS.


      -- next, ensuring that some attributes are correctly assigned to the
      -- otherside of the door, as well. Only some non-default cases need to be
      -- addressed here:

        IF THIS IS NOT openable
          THEN MAKE otherside OF THIS NOT openable.
        END IF.

        IF THIS IS open
          THEN MAKE otherside OF THIS open.
        END IF.

        IF THIS IS lockable
          THEN MAKE otherside OF THIS lockable.
        END IF.

        IF THIS IS locked
          THEN MAKE otherside OF THIS locked.
        END IF.

    END IF.


    -- making the same matching_key open both sides of a door:

    IF otherside OF THIS <> null_door AND matching_key OF THIS <> null_key
      THEN SET matching_key OF otherside OF THIS TO matching_key OF THIS.
    END IF.


  -- If a door is lockable/locked, you should state at the door instance which
  -- object will unlock it, with the matching_key attribute. For example:

  -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  -- THE attic_door ISA DOOR
  --   HAS matching_key brass_key.
  --   ...
  -- END THE.
  --
  -- THE brass_key ISA OBJECT AT basement
  -- END THE.
  -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  -- (null_key is a default dummy object that can be ignored.)



  VERB examine
    DOES AFTER
      IF THIS IS NOT plural
        THEN "It is"
        ELSE "They are"
      END IF.
      "currently"
      IF THIS IS NOT open
        THEN "closed."
        ELSE "open."
      END IF.
  END VERB examine.



  VERB knock
    DOES ONLY
      IF THIS IS NOT open
        THEN "You knock on" SAY THE THIS. "$$. There is no reply."
        ELSE "You don't find it purposeful to knock on the open door"
          IF THIS IS NOT plural
            THEN "."
            ELSE "$$s."
          END IF.
      END IF.
  END VERB knock.



  VERB look_behind
    DOES ONLY
      IF THIS IS NOT open
        THEN "You cannot look behind"
          IF THIS IS NOT plural
            THEN "the door - it is closed."
            ELSE "the doors - they are closed."
          END IF.
        ELSE "You notice nothing special behind the door"
          IF THIS IS NOT plural
            THEN "."
            ELSE "$$s."
          END IF.
      END IF.
  END VERB look_behind.



  VERB look_under
    DOES ONLY
      IF THIS IS NOT open
        THEN "The gap under the closed door"
          IF THIS IS plural
            THEN "$$s"
          END IF.
          "is so narrow that you can't
          see anything of what lies on the other side."
        ELSE "You notice nothing special under the door"
          IF THIS IS plural
            THEN "$$s."
            ELSE "."
          END IF.
      END IF.
  END VERB look_under.



  VERB close
    DOES
      IF otherside OF THIS <> null_door
        THEN MAKE otherside OF THIS NOT open.
      END IF.
  END VERB close.


  VERB lock
    DOES
      IF otherside OF THIS <> null_door
        THEN MAKE otherside OF THIS NOT open.
          MAKE otherside OF THIS locked.
      END IF.
  END VERB lock.


  VERB open
    DOES
      IF otherside OF THIS <> null_door
        THEN MAKE otherside OF THIS open.
          MAKE otherside OF THIS NOT locked.
      END IF.
  END VERB open.


  VERB unlock
    DOES
      IF otherside OF THIS <> null_door
        THEN MAKE otherside OF THIS NOT locked.
      END IF.
  END VERB unlock.


END EVERY.


-- a default dummy, ignore:

THE null_door ISA DOOR
END THE.



-- =============================================================


----- LIGHTSOURCE


-- =============================================================


-- (In the file 'lib_verbs.i', ISA LIGHTSOURCE is used in the syntax definition of the verb 'light'.
-- Also, in 'lib_locations.i', LIGHTSOURCE is used in defining the behavior of the class DARK_LOCATION.)



EVERY lightsource ISA OBJECT
  IS NOT lit.
  IS natural.   -- A natural lightsource is for example a candle, a match or a torch.
        -- A NOT natural lightsource is for example a flashlight or a lamp.
        -- You cannot switch on or off a natural lightsource.


  VERB examine
    DOES AFTER
      IF THIS IS lit
        THEN
          IF THIS IS natural
            THEN
              IF THIS IS NOT plural
                THEN "It is"
                ELSE "They are"
              END IF.
              "currently lit."
            ELSE
              IF THIS IS NOT plural
                THEN "It is"
                ELSE "They are"
              END IF.
              "currently on."
          END IF.
        ELSE
          IF THIS IS natural
            THEN
              IF THIS IS NOT plural
                THEN "It is"
                ELSE "They are"
              END IF.
              "currently not lit."
            ELSE
              IF THIS IS NOT plural
                THEN "It is"
                ELSE "They are"
              END IF.
              "currently off."
          END IF.
      END IF.
  END VERB examine.


  VERB light
    CHECK THIS IS NOT lit
      ELSE
        IF THIS IS NOT plural
          THEN SAY check_lightsource_not_lit_sg OF my_game.
          ELSE SAY check_lightsource_not_lit_pl OF my_game.
        END IF.
    AND THIS IS NOT broken
      ELSE SAY check_obj_not_broken OF my_game.
    DOES ONLY
      IF THIS IS natural
        THEN "You light" SAY THE THIS. "."
          MAKE THIS lit.
        ELSE "You turn on" SAY THE THIS. "."
          MAKE THIS lit.
      END IF.
  END VERB light.


  VERB extinguish
    CHECK THIS IS lit
      ELSE
        IF THIS IS NOT plural
          THEN SAY check_lightsource_lit_sg OF my_game.
          ELSE SAY check_lightsource_lit_pl OF my_game.
        END IF.
    DOES ONLY "You extinguish" SAY THE THIS. "."
      MAKE THIS NOT lit.
  END VERB extinguish.


  VERB turn_on
    CHECK THIS IS NOT natural
      ELSE
        IF THIS IS NOT plural
          THEN SAY check_obj_suitable_on_sg OF my_game.
          ELSE SAY check_obj_suitable_on_pl OF my_game.
        END IF.
    AND THIS IS NOT lit
      ELSE
        IF THIS IS NOT plural
          THEN SAY check_lightsource_not_lit_sg OF my_game.
          ELSE SAY check_lightsource_not_lit_pl OF my_game.
        END IF.
    AND THIS IS NOT broken
      ELSE SAY check_obj_not_broken OF my_game.
    DOES ONLY
      "You turn on" SAY THE THIS. "."
      MAKE THIS lit.

  END VERB turn_on.


  VERB turn_off
    CHECK THIS IS NOT natural
      ELSE
        IF THIS IS NOT plural
          THEN SAY check_obj_suitable_off_sg OF my_game.
          ELSE SAY check_obj_suitable_off_pl OF my_game.
        END IF.
    AND THIS IS lit
      ELSE
        IF THIS IS NOT plural
          THEN SAY check_lightsource_lit_sg OF my_game.
          ELSE SAY check_lightsource_lit_sg OF my_game.
        END IF.

    DOES ONLY
      "You turn off" SAY THE THIS. "."
      MAKE THIS NOT lit.

  END VERB turn_off.


-- The following verb switches a NOT natural lightsource on if it is off, and vice versa
-- (when the player forgets, or doesn't bother, to type 'on' or 'off' after 'switch').


  VERB switch
    CHECK THIS IS NOT natural
      ELSE
        IF THIS IS NOT plural
          THEN SAY check_lightsource_switchable_sg OF my_game.
          ELSE SAY check_lightsource_switchable_pl OF my_game.
        END IF.
    AND THIS IS reachable
      ELSE
        IF THIS IS NOT plural
          THEN SAY check_obj_reachable_sg OF my_game.
          ELSE SAY check_obj_reachable_pl OF my_game.
        END IF.
    AND THIS IS NOT broken
      ELSE SAY check_obj_not_broken OF my_game.
    DOES ONLY
      IF THIS IS lit
        THEN "You switch off" SAY THE THIS. "."
          MAKE THIS NOT lit.
        ELSE "You switch on" SAY THE THIS. "."
          MAKE THIS lit.
      END IF.
  END VERB switch.


END EVERY.



-- ==============================================================


----- LIQUID


-- ==============================================================


-- (In the file 'lib_verbs.i', ISA LIQUID is used in the syntax definitions of the verbs 'drink' and 'sip'.)


EVERY liquid ISA OBJECT

  CONTAINER
    HEADER "In" SAY THE THIS. "you see"
    ELSE "There is nothing in" SAY THE THIS. "."

    -- We declare this class a container to enable player commands such as
    -- 'throw sack into water', 'look into water' and 'take pearl from water'.
    -- Also cases such as 'pour red potion into blue potion' require that this
    -- class behaves like a container.


  HAS vessel null_vessel.

    -- The 'vessel' attribute takes care that if a liquid is
    -- in a container, the verb 'take' will automatically take the
    -- container instead (if the container is takeable). Trying
    -- take a liquid that is in a fixed-in-place container, as well
    -- as trying to take a liquid outside any container, will yield
    -- "You can't carry [the liquid] around in your bare hands."
    -- The default value 'null_vessel' tells the compiler that the liquid
    -- is not in any container. 'null_vessel' is a dummy default that can be
    -- ignored.


  INITIALIZE

  -- Every object found in a liquid, for example a fish in a pond of water,
  -- will be allowed back in that liquid once taken out of there:

    FOR EACH liq ISA LIQUID
      DO
        FOR EACH o ISA OBJECT, DIRECTLY IN liq
          DO
            INCLUDE o IN allowed OF liq.
        END FOR.
    END FOR.


  -- Every liquid in a container at the start of the game
  -- will have that container as its vessel:

    FOR EACH lc ISA LISTED_CONTAINER
      DO
        FOR EACH lq ISA LIQUID, DIRECTLY IN lc
          DO
            SET vessel OF lq TO lc.
        END FOR.
    END FOR.


  -- If you have some liquid in a container in your game, you should declare the
  -- liquid instance thus:

  -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  -- THE juice ISA LIQUID IN bottle
  -- END THE juice.
  -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  -- The verb 'pour', as defined in this library, also works for the container
  -- of a liquid; i.e. if there is some juice in a bottle, 'pour bottle' and
  -- 'pour juice' will work equally well. Note, however, that the verb 'empty'
  -- is not a synonym for 'pour'; 'empty' only works for container objects.



    SCHEDULE check_vessel AT THIS AFTER 0.    -- this event is defined further below


  VERB examine
    DOES ONLY
      IF vessel OF THIS <> null_vessel
        THEN
          IF vessel OF THIS IS open
            THEN "You notice nothing unusual about" SAY THE THIS.
            ELSE "You can't, since" SAY THE vessel OF THIS.
              IF THIS IS NOT plural
                THEN "is"
                ELSE "are"
              END IF.
              "closed."
              -- Here we prohibit the player from examining
              -- a liquid when the liquid is in a closed container.
          END IF.
        ELSE "You notice nothing unusual about" SAY THE THIS. "."
      END IF.
  END VERB examine.


  VERB look_in
    DOES ONLY
      IF vessel OF THIS <> null_vessel
        THEN
          IF vessel OF THIS IS open
            THEN "You see nothing special in" SAY THE THIS. "."
            ELSE "You can't, since" SAY THE vessel OF THIS.
              IF THIS IS NOT plural
                THEN "is"
                ELSE "are"
              END IF.
              "closed."
              -- Here we prohibit the player from looking into
              -- a liquid when the liquid is in a closed container.
          END IF.
        ELSE "You see nothing special in" SAY THE THIS. "."
      END IF.
  END VERB look_in.


  VERB take
    CHECK vessel OF THIS NOT IN hero
      ELSE SAY check_obj_not_in_hero2 OF my_game.
    DOES ONLY
      IF vessel OF THIS = null_vessel OR vessel OF THIS IS NOT takeable
        THEN "You can't carry" SAY THE THIS. "around in your bare hands."
        ELSE LOCATE vessel OF THIS IN hero.
          "($$" SAY THE vessel OF THIS. "of" SAY THIS. "$$)$nTaken."
      END IF.
  END VERB take.


  VERB take_from
     WHEN obj
    CHECK holder <> vessel OF THIS
      ELSE SAY check_liquid_vessel_not_cont OF my_game.
      -- the above is triggered when the player types for example
      -- >take juice from bottle   -- (when the juice is in the bottle)
    DOES ONLY
      IF vessel OF THIS = null_vessel OR vessel OF THIS IS NOT takeable
        THEN "You can't carry" SAY THE THIS. "around in your bare hands."
        ELSE LOCATE vessel OF THIS IN hero.
          "($$" SAY THE vessel OF THIS. "of" SAY THIS. "$$)$nTaken."
      END IF.
  END VERB take_from.


  VERB drop
    DOES ONLY
      LOCATE vessel OF THIS AT hero.
      "($$" SAY THE vessel OF THIS. "of" SAY THIS. "$$)$nDropped."

  END VERB drop.


  VERB ask_for
    DOES ONLY
      -- Let's preserve the current state of compliance of act:
      IF act IS compliant
        THEN MAKE my_game temp_compliant.
        ELSE MAKE my_game NOT temp_compliant.
      END IF.
      MAKE act compliant.
      -- It is only possible to get something from an NPC
      -- if the NPC is 'compliant'.
      LOCATE vessel OF THIS IN hero.
      SAY THE act. "gives" SAY THE vessel OF THIS. "of" SAY THIS. "to you."
      -- Now let's restore act to its original state of compliacne:
      IF my_game IS NOT temp_compliant
        THEN MAKE act NOT compliant.
      END IF.
  END VERB ask_for.


  VERB give
    WHEN obj
    DOES ONLY
      -- >>> implicit take >>>
      IF THIS NOT IN hero
        THEN
          IF vessel OF THIS = null_vessel OR vessel OF THIS IS NOT takeable
            THEN "You can't carry" SAY THE THIS. "around in your bare hands."
            ELSE LOCATE vessel OF THIS IN hero.
              "(taking" SAY THE vessel OF THIS. "of" SAY THIS. "first)$n"
          END IF.
      END IF.
      -- <<< implicit take <<<

      IF THIS IN hero
        -- i.e. if the implicit taking was successful
        THEN
          "You give" SAY THE vessel OF THIS. "of" SAY THIS. "to" SAY THE recipient. "."
          LOCATE vessel OF THIS IN recipient.
      END IF.

      -- there is no 'ELSE' statement in this last IF -clause, as the 'IF THIS NOT
      -- IN hero' clause above it takes care of the 'ELSE' alternative.

  END VERB give.


  VERB pour
    DOES ONLY
      -- >>> implicit take >>>
      IF THIS NOT IN hero
        THEN
          IF vessel OF THIS = null_vessel OR vessel OF THIS IS NOT takeable
            THEN "You can't pour" SAY THE THIS. "anywhere since you are not
                  carrying"
              IF THIS IS NOT plural
                THEN "it."
                ELSE "them."
              END IF.
          ELSE LOCATE vessel OF THIS IN hero.
            "(taking" SAY THE vessel OF THIS. "of" SAY THIS. "first)$n"
          END IF.
      END IF.
      -- <<< implicit take <<<

      IF THIS IN hero
        THEN LOCATE THIS AT hero.
          SET vessel OF THIS TO null_vessel.
          "You pour" SAY THE THIS.
          IF floor HERE
            THEN "on the floor."
            ELSE "on the ground."
          END IF.
      END IF.

  END VERB pour.


  VERB pour_in
    WHEN obj
      DOES ONLY
        -- >>> implicit take >>>
        IF THIS NOT IN hero
          THEN
            IF vessel OF THIS = null_vessel
              THEN "You can't carry" SAY THE THIS. "around in your bare hands."
            ELSIF vessel OF THIS IS NOT takeable
              THEN "You don't have" SAY THE vessel OF THIS. "of" SAY THIS. "."
            ELSE LOCATE vessel OF THIS IN hero.
              "(taking" SAY THE vessel OF THIS. "of" SAY THIS. "first)$n"
            END IF.
        END IF.
        -- <<< implicit take <<<

        IF THIS IN hero   --i.e. if the implicit taking was successful
          THEN LOCATE THIS IN cont.
            SET vessel OF THIS TO cont.
            "You pour" SAY THE THIS. "into" SAY THE cont. "."
        END IF.
    WHEN cont
      DOES ONLY
        IF vessel OF THIS = null_vessel
          THEN
            "There's not much sense pouring" SAY THE obj. "into" SAY THE THIS. "."
          ELSE
            IF vessel OF THIS IS open
              THEN "It wouldn't accomplish anything trying to pour" SAY THE obj.
                "into" SAY THE THIS. "."
              ELSE "You can't, since" SAY THE vessel OF THIS.
                IF THIS IS NOT plural
                  THEN "is"
                  ELSE "are"
                END IF.
                "closed."
            END IF.
        END IF.
  END VERB pour_in.


  VERB pour_on
    WHEN obj
      DOES ONLY
        -- >>> implicit take >>>
        IF THIS NOT IN hero
          THEN
            IF vessel OF THIS = null_vessel
              THEN "You can't carry" SAY THE THIS. "around in your bare hands."
            ELSIF vessel OF THIS IS NOT takeable
              THEN "You don't have" SAY THE vessel OF THIS. "of" SAY THIS. "."
            ELSE LOCATE vessel OF THIS IN hero.
              "(taking" SAY THE vessel OF THIS. "of" SAY THIS. "first)$n"
            END IF.
        END IF.
        -- <<< implicit take <<<

        IF THIS IN hero
          -- i.e. if the implicit taking was successful
          THEN
            IF surface = floor OR surface = ground
              THEN LOCATE THIS AT hero.
                "You pour" SAY THE THIS. "on" SAY THE surface. "."
                SET vessel OF THIS TO null_vessel.
              ELSIF surface ISA SUPPORTER
                THEN LOCATE THIS IN surface.
                  "You pour" SAY THE THIS. "on" SAY THE surface. "."
                  SET vessel OF THIS TO null_vessel.
              ELSE "It wouldn't be sensible to pour anything on" SAY THE surface.
            END IF.
        END IF.
  END VERB pour_on.


  VERB put_in
    WHEN obj
      DOES ONLY
        IF vessel OF THIS = null_vessel
          THEN "You can't carry" SAY THE THIS. "around in your bare hands."
          ELSE
            IF vessel OF THIS IS takeable
              THEN
                -- >>> implicit take >>>
                IF THIS NOT IN hero
                  THEN
                    IF vessel OF THIS = null_vessel
                      THEN "You can't carry" SAY THE THIS. "around in your bare hands."
                    ELSE LOCATE vessel OF THIS IN hero.
                      "(taking" SAY THE vessel OF THIS. "of" SAY THIS. "first)$n"
                    END IF.
                END IF.
                -- <<< implicit take <<<

                LOCATE vessel OF THIS IN cont.
                    "You put" SAY THE vessel OF THIS. "of" SAY THIS. "into" SAY THE cont. "."

              ELSE "You don't have" SAY THE vessel OF THIS. "of" SAY THIS. "."
            END IF.
        END IF.
        WHEN cont
      DOES ONLY
      IF vessel OF THIS = null_vessel
        THEN
          "There's not much sense putting" SAY THE obj. "into" SAY THE THIS. "."
        ELSE
          IF vessel OF THIS IS open
            THEN
              IF obj = vessel OF THIS
                THEN "That doesn't make sense."
                ELSE "It wouldn't accomplish anything trying to put" SAY THE obj.
                  "into" SAY THE vessel OF THIS. "of" SAY THIS. "."
              END IF.
            ELSE "You can't, since" SAY THE vessel OF THIS. "of" SAY THIS.
              IF THIS IS NOT plural
                THEN "is"
                ELSE "are"
              END IF.
            "closed."
          END IF.
      END IF.
  END VERB put_in.


  VERB put_on
    WHEN obj
      DOES ONLY
        -- >>> implicit take >>>
        IF THIS NOT IN hero
          THEN
            IF vessel OF THIS = null_vessel
              THEN "You can't carry" SAY THE THIS. "around in your bare hands."
              ELSIF vessel OF THIS IS NOT takeable
                THEN "You don't have" SAY THE vessel OF THIS. "of" SAY THIS. "."
                ELSE LOCATE vessel OF THIS IN hero.
                  "(taking" SAY THE vessel OF THIS. "of" SAY THIS. "first)$n"
            END IF.
        END IF.
        -- <<< implicit take <<<

        IF THIS IN hero
          -- i.e. if the implicit taking was successful
          THEN
            "You put" SAY THE vessel OF THIS. "of" SAY THIS. "onto" SAY THE surface. "."
            LOCATE vessel OF THIS IN surface.
        END IF.
    WHEN surface
      DOES ONLY "It is not possible to $v" SAY obj. "onto" SAY THE THIS. "."
  END VERB put_on.





  -- The verbs 'empty', 'empty_in' and 'empty_on' will be disabled as ungrammatical with liquids:

  VERB 'empty'
    WHEN obj
    DOES ONLY "You can only empty containers."
  END VERB 'empty'.

  VERB empty_in
    WHEN obj
    DOES ONLY "You can only empty containers."
  END VERB empty_in.

  VERB empty_on
    WHEN obj
    DOES ONLY "You can only empty containers."
  END VERB empty_on.


END EVERY.



-- Here is the default vessel for liquids; if the vessel of a liquid is
-- 'null_vessel', it means that the liquid is not in any container; ignore.


THE null_vessel ISA OBJECT
  CONTAINER
END THE.



-- This event checks that if a liquid is outside a container, its container will
-- be 'null_vessel'; ignore:


EVENT check_vessel
  FOR EACH liq ISA LIQUID, DIRECTLY AT CURRENT LOCATION DO
    SET vessel OF liq TO null_vessel.
  END FOR.
  SCHEDULE check_vessel AFTER 1.

  FOR EACH lc ISA LISTED_CONTAINER DO
    FOR EACH liq ISA LIQUID, DIRECTLY IN lc
      DO SET vessel OF liq TO lc.
    END FOR.
  END FOR.

  SCHEDULE check_vessel AFTER 1.
END EVENT.



-- =============================================================


----- LISTED_CONTAINER


-- =============================================================


-- (This class is not cross-referenced elsewhere in this or any other library file.)


EVERY LISTED_CONTAINER ISA OBJECT
  CONTAINER

    --  (ACTORS are separately defined to be containers further below.)

  INITIALIZE

  -- Every object in a container will be allowed back in that container by default if it's taken out:

    FOR EACH lc ISA LISTED_CONTAINER
      DO
        FOR EACH o ISA OBJECT, DIRECTLY IN lc
          DO
            INCLUDE o IN allowed OF lc.
        END FOR.
    END FOR.





  VERB examine
    DOES ONLY
      IF THIS IS NOT OPAQUE
        THEN LIST THIS.
        ELSE "You can't see inside" SAY THE THIS. "."
      END IF.
  END VERB examine.


  VERB look_in
    DOES ONLY
      IF THIS IS NOT OPAQUE
        THEN LIST THIS.
        ELSE "You can't see inside" SAY THE THIS. "."
      END IF.
  END VERB look_in.


  VERB search
    DOES ONLY
      IF THIS IS NOT OPAQUE
        THEN LIST THIS.
        ELSE "You can't see inside" SAY THE THIS. "."
      END IF.
  END VERB search.



-- Note that closed listed_containers are by default opaque and they become "not opaque" when
-- they are opened.

-- In order to support this behavior also on lockable listed_containers,
-- before changing the opaqueness state we need to check that the cointainer is
-- actually in the expected open/close state --- eg, if the player tries to open
-- a locked listed_container for which he doesn't have the matching_key, then
-- the 'open' action will have failed. Similarly, to be on the safe side, we'll
-- also implement this behavior on other verbs that could potentially affect
-- the open/close state of a listed_container (ie, if an author implements
-- them on some class or instance).


  VERB open
    DOES
      IF THIS IS open
        THEN
          MAKE THIS NOT OPAQUE.
          LIST THIS.
      END IF.
  END VERB open.


  VERB open_with
    WHEN obj DOES
      IF THIS IS open
        THEN
          MAKE THIS NOT OPAQUE.
          LIST THIS.
      END IF.
  END VERB open_with.


  VERB close, lock
    DOES
      IF THIS IS NOT open
        THEN
          MAKE THIS OPAQUE.
      END IF.
  END VERB close.


  VERB close_with
    WHEN obj DOES
      IF THIS IS NOT open
        THEN
          MAKE THIS OPAQUE.
      END IF.
  END VERB close_with.


  VERB lock_with
    WHEN obj DOES
      IF THIS IS NOT open
        THEN
          MAKE THIS OPAQUE.
      END IF.
  END VERB lock_with.


END EVERY.





-- ===============================================================


----- SOUND


-- ===============================================================


-- (This class is not cross-referenced in this or any other library file.)


EVERY sound ISA OBJECT
  IS NOT examinable.
  IS NOT takeable.
  IS NOT reachable.
  IS NOT movable.

  VERB smell
    DOES ONLY
      IF THIS IS NOT plural
        THEN "That's not"
        ELSE "Those are not"
      END IF.
      "something you can smell."
  END VERB smell.


END EVERY.



-- ==============================================================


----- SUPPORTER


-- ==============================================================


-- (See the file 'verbs.i', verbs 'climb_on', 'empty_on', 'get_off', 'jump_on',
-- 'lie_on', 'pour_on', 'put_in', 'put_on', 'sit_on', 'stand_on', and 'take_from'
-- where SUPPORTER is used in either syntax definitions, verb checks
-- or verb definitions.)


EVERY supporter ISA OBJECT


  CONTAINER
    HEADER "On" SAY THE THIS. "you see"
    ELSE "There's nothing on" SAY THE THIS. "."


  VERB examine
    DOES
      LIST THIS.
  END VERB examine.


  -- in the following, we disable some verbs that are defined to work with normal containers:


  VERB look_in
    DOES ONLY
      IF THIS IS NOT plural
        THEN "That's not"
        ELSE "Those are not"
      END IF.
      "something you can look into."
  END VERB look_in.


  VERB empty_in, pour_in
     WHEN cont
    DOES ONLY
       IF THIS IS NOT plural
        THEN "That's not"
        ELSE "Those are not"
      END IF.
      "something you can pour things into."
  END VERB empty_in.


  VERB put_in
    WHEN cont
    DOES ONLY "You can't put anything inside" SAY THE THIS. "."
  END VERB put_in.


  VERB throw_in
    WHEN cont
    DOES ONLY "You can't put anything inside" SAY THE THIS. "."
  END VERB throw_in.


END EVERY.







-- ==============================================================


----- WEAPON


-- ==============================================================


-- (See the file 'lib_verbs.i', verbs 'attack_with', 'fire',
-- 'fire_with', 'kill_with', 'shoot' and 'shoot_with' where WEAPON is used
-- either in the syntax definitions or verb checks.)


EVERY weapon ISA OBJECT
  IS NOT fireable.
END EVERY.




-- ==============================================================


----- WINDOW


-- ==============================================================


-- (This class is not cross-referenced elsewhere in this or any other library file.)


-- You can look out of and through a window.
-- When examined, a window is by default described as being either open or closed.


EVERY window ISA OBJECT
  IS openable.
  IS NOT open.
  IS NOT takeable.

  VERB examine
    DOES
      IF THIS IS NOT plural
        THEN "It is"
        ELSE "They are"
      END IF.
      "currently"
      IF THIS IS NOT open
        THEN "closed."
        ELSE "open."
      END IF.
  END VERB examine.


  VERB look_behind
    DOES ONLY
      "That's not possible."
  END VERB look_behind.


  VERB look_out_of
    DOES ONLY "You see nothing special looking out of the"
      IF THIS IS NOT plural
        THEN "window."
        ELSE "windows."
      END IF.
  END VERB look_out_of.


  VERB look_through
    DOES ONLY "You see nothing special looking through the"
      IF THIS IS NOT plural
        THEN "window."
        ELSE "windows."
      END IF.
  END VERB look_through.


END EVERY.



-- ===============================================================

-- ===============================================================
--
-- 2. Actors
--
-- ===============================================================

-- ===============================================================


-- First, we declare some common characteristics for all actors:


ADD TO EVERY ACTOR
  IS NOT inanimate.
  IS NOT following.
  IS NOT sitting.
  IS NOT lying_down.
  IS NOT named.
  -- = the actor's name is not known to the player.
  IS NOT compliant.
  -- an actor only gives something to the hero if it is in a compliant mood.
  -- In practice, this happens by default when the hero asks the actor for anything.
  -- For example, implicit taking of objects is not successful if the object happens
  -- to be held by an NPC who is not compliant.
  IS NOT takeable.


  DEFINITE ARTICLE
  IF THIS IS NOT named
    THEN "the"
    ELSE ""
  END IF.


  INDEFINITE ARTICLE
  IF THIS IS NOT named
    THEN
      IF THIS IS NOT plural
        THEN "a"
        ELSE "some"
      END IF.
    ELSE ""
  END IF.

  -- if you need "an", you must declare it separately at the actor instance


  CONTAINER
  -- so that actors can receive and carry objects
  HEADER
    IF THIS = hero
      THEN "You are carrying"
      ELSE
        SAY THE THIS.
        IF THIS IS NOT plural
          THEN "is"
          ELSE "are"
        END IF. "carrying"
    END IF.

  ELSE
    IF THIS = hero
      THEN "You are empty-handed."
      ELSE
        SAY THE THIS.
        IF THIS IS NOT plural
          THEN "is"
          ELSE "are"
        END IF. "not carrying anything."

    END IF.

  EXTRACT
    CHECK THIS IS compliant
      ELSE
        "That seems to belong to"
        SAY THE THIS. "."



  INITIALIZE

  MAKE hero compliant.
  -- so that the hero can give, drop, etc. carried objects.

  -- all actors will obey this script from the start of the game:

  IF THIS <> hero
    THEN USE SCRIPT following_hero FOR THIS.
  END IF.



  SCRIPT following_hero
    -- this code will make any actor follow the hero
    -- if the actor is given the attribute 'following'.

    STEP WAIT UNTIL hero NOT HERE

      IF THIS IS following
        THEN
          LOCATE THIS AT hero.
          "$p" SAY THE THIS.
            IF THIS IS NOT plural
              THEN "follows you."
              ELSE "follow you."
            END IF.
      END IF.

    USE SCRIPT following_hero FOR THIS.



  DESCRIPTION
    IF THIS IS scenery
      THEN "$$"
    ELSIF THIS IS NOT named
      THEN
        IF THIS IS NOT plural
          THEN "There is" SAY AN THIS. "here."
          ELSE "There are" SAY THIS. "here."
        END IF.
      ELSE SAY THIS.
        IF THIS IS NOT plural
          THEN "is here."
          ELSE "are here."
        END IF.
    END IF.


  VERB examine
    DOES AFTER
      IF THIS <> hero
        THEN
          -- ------------------
          -- List carried items
          -- ------------------
          -- Don't say anything if the actor is not carrying anything.
          SET my_game:temp_cnt TO COUNT IsA object, IS NOT worn, DIRECTLY IN THIS.
          IF  my_game:temp_cnt <> 0
            THEN "$+1"
              IF THIS IS NOT plural
                THEN "is"
                ELSE "are"
              END IF. "carrying"
              FOR EACH carried_item ISA object, IS NOT worn, DIRECTLY IN THIS
                DO
                  SAY AN carried_item.
                  DECREASE my_game:temp_cnt.
                  DEPENDING ON my_game:temp_cnt
                    = 1 THEN "and"
                    = 0 THEN "."
                    ELSE ","
                  END DEPEND.
              END FOR.
          END IF.
          -- ------------------------
          -- List worn clothing items
          -- ------------------------
          -- Don't say anything if the actor is not wearing anything.
          SET my_game:temp_cnt TO COUNT IsA clothing, DIRECTLY IN THIS, IS worn.
          IF  my_game:temp_cnt <> 0
            THEN "$+1"
              IF THIS IS NOT plural
                THEN "is"
                ELSE "are"
              END IF. "wearing"
              FOR EACH worn_item IsA clothing, DIRECTLY IN THIS, IS worn
                DO
                  SAY AN worn_item.
                  DECREASE my_game:temp_cnt.
                  DEPENDING ON my_game:temp_cnt
                    = 1 THEN "and"
                    = 0 THEN "."
                    ELSE ","
                  END DEPEND.
              END FOR.
          END IF.
      END IF.
  END VERB examine.
END ADD TO ACTOR.


-- the default dummy clothing object; ignore

THE null_clothing ISA CLOTHING
END THE.





-- ================================================================


----- PERSON      -- CAN talk


-- ================================================================


EVERY person ISA ACTOR
      CAN talk.

  CONTAINER
    HEADER
      SAY THE THIS.
      IF THIS IS NOT plural
        THEN "is"
        ELSE "are"
      END IF. "carrying"
    ELSE

      SAY THE THIS.
      IF THIS IS NOT plural
        THEN "is"
        ELSE "are"
      END IF. "empty-handed."

    EXTRACT
      CHECK THIS IS compliant
        ELSE "That seems to belong to"
        SAY THE THIS. "."

END EVERY.





-- ================================================================


----- FEMALE and MALE


-- ================================================================


-- MALE and FEMALE are actually subclasses of PERSON, so they both
-- have the ability to talk.


EVERY female ISA PERSON
  PRONOUN her
END EVERY.


EVERY male ISA PERSON
  PRONOUN him
END EVERY.




-- end of file.


