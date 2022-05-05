-- lib_clothing.i             | ALAN Standard Library v2.2.0-WIP | ALAN 3.0beta8
--+============================================================================+
--|\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////////|
--++--------------------------------------------------------------------------++
--||                                                                          ||
--||                  T H E   C L O T H I N G   S Y S T E M                   ||
--||                                                                          ||
--++--------------------------------------------------------------------------++
--|//////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\|
--+============================================================================+

-- This library module contains all the code implementing the clothing system.

--  * Clothing items behave according to Alan Bampton's 'xwear.i' extension:
--    * The extension has been fully assimilated into the Standard Library.
--    * Clothing items are mapped to specific areas of the body, in order to
--      determine their coverage, and each area is mapped to a wearing layer,
--      to determine the order in which items need to be worn and removed.
--    * It prevents wearning clothes in an illogical order, e.g. the hero can't
--      put on a shirt while wearing a jacket, and so on.
--    * This only applies to the hero; NPCs can't wear clothing in layers.
--  * The verbs `wear`, `remove` and `undress` are re-defined on the `clothing`
--    class, to provide class-specific behavior.

-- For instructions on using this class, see the documentation comments after
-- its code.

-- This class is based on Alan Bampton's 'xwear.i' extension, originally written
-- for ALAN v2, hereby adapted to ALAN v3 and integrated with the rest of the
-- library. The original clothing system of StdLib v2.x was entirely revised in
-- v2.2.0 of the library, by Tristano Ajmone, in order to make it easier to use,
-- more flexible, and to solve some issues relating to tracking the state of
-- worn clothing items and preventing verbs from dislocating them while being
-- worn by actors.

-- Thanks to Alan Bampton for having granted permission to use his code here.

--------------------------------------------------------------------------------

-- The default dummy clothing object, used internally by the library. (Ignore!)

THE null_clothing IsA CLOTHING
END THE.


--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                    C L O T H I N G   A T T R I B U T E S
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================


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

EVERY clothing IsA OBJECT

  IS wearable.

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
    -- For items covering legs + torso ('topcover' & 'botcover' <> 0) that
    -- should be treated as a single piece (e.g. a one-piece swimming suite).
    -- Items which are 'twopieces' (eg. a bikini) can be worn/removed while
    -- wearing a skirt for, although handled as a single clothing item, they
    -- cover legs and torso via two separate pieces.

  IS sex 0. -- If not zero, restricts wearing to actors with same 'sex' value.

-- --------------------------------
-- Actors & Clothes `sex` Attribute
-- --------------------------------

-- The `sex` attribute can be used to bind clothing items to specific genders,
-- e.g. male and female clothes. Since its values are arbitrary choices, it can
-- be used to associate clothes to any group of actors, e.g. children vs adults,
-- humans vs aliens, or the different races of creatures that populate a fantasy
-- world (elves, orcs, trolls, giants, etc.).

-- The `wear` verb will always check if a clothing item has a `sex` attribute
-- with non-zero value, in which case it will prevent the action if the hero
-- doesn't match the same `sex` value. By default, the `sex` attribute of all
-- actors and clothing items are set to value zero, which disables gender checks
-- in the `wear` verb. In order to enable this feature, authors must assign a
-- non-zero `sex` value to the hero and to all clothing items that the hero can
-- wear.

-- The identifier `sex` was originally picked to indicate the possiblity of
-- distinguishing male and female clothing, since this attribute is only used by
-- the library in conjunction with wearing clothes, so it was kept mainly for
-- hystorical reasons and to preserve backward compatibility.
-- In hindsight, `gender` would have probably been a better choice.

-- Bear in mind that this was mostly an experimental feature that was never
-- developed into a full-fledged gender support feature across the library.


  INITIALIZE

    -- Any objects inside a clothing item (e.g. a wallet in a jacket) will be
    -- allowed to be put back into its original containing clothing once taken
    -- out from it:

    FOR EACH o IsA OBJECT, DIRECTLY IN THIS
      DO INCLUDE o IN allowed OF THIS.
    END FOR.


  CONTAINER
  -- To allow for example a wallet to be put into a jacket.

  -- If the clothing item contains something, e.g. a jacket contains a wallet,
  -- the wallet will be mentioned by default when the jacket is examined:

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                         C L O T H I N G   V E R B S
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

  VERB examine
    DOES AFTER
      IF THIS IS NOT OPAQUE
        THEN
          IF COUNT IsA OBJECT, DIRECTLY IN THIS > 0
            THEN LIST THIS.
          END IF.
      END IF.
  END VERB examine.

--==============================================================================
--------------------------------------------------------------------------------
-- Block verbs that could dislocate worn clothing items
--------------------------------------------------------------------------------
--==============================================================================

-- The following verbs are extended on the 'clothing' class with additional
-- CHECKs to prevent displacing worn clothing items from their wearer:

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
            THEN SAY my_game:check_obj_not_worn_by_hero3.
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
            THEN SAY my_game:check_obj_not_worn_by_hero3.
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


  VERB put_on --> put (obj) on (surface)
    WHEN obj
      CHECK obj IS NOT worn
        ELSE
          IF obj IN hero
            THEN SAY my_game:check_obj_not_worn_by_hero3.
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
          THEN SAY my_game:check_obj_not_worn_by_hero3.
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
            THEN SAY my_game:check_obj_not_worn_by_hero3.
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
            THEN SAY my_game:check_obj_not_worn_by_hero3.
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
            THEN SAY my_game:check_obj_not_worn_by_hero3.
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
            THEN SAY my_game:check_obj_not_worn_by_hero3.
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


--==============================================================================
--------------------------------------------------------------------------------
-- WEAR & REMOVE
--------------------------------------------------------------------------------
--==============================================================================

-- The `wear` and `remove` verbs contain all the code that enforces the layered
-- clothing system, which is the central feature of the `clothing` class.

--==============================================================================
  VERB wear
--==============================================================================
    CHECK sex OF THIS = sex OF hero OR sex OF THIS = 0
      ELSE SAY my_game:check_clothing_sex.
    AND THIS IS NOT worn
      ELSE
        IF THIS IN hero
          --      "You are already wearing $+1."
          THEN SAY my_game:check_obj_not_worn_by_hero1.
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

--==============================================================================
  VERB remove
--==============================================================================
    CHECK THIS DIRECTLY IN hero AND THIS IS worn
      ELSE SAY my_game:check_obj_worn_by_hero.
    AND CURRENT LOCATION IS lit
      ELSE SAY my_game:check_current_loc_lit.

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

-- end of file.
