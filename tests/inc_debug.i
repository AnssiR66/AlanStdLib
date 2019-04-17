
--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                    T H E   D E B U G G I N G   M O D U L E
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- This modules adds to adventures some extra verbs and functionalities which
-- are helpful to provide quick "debug" information about the state of various
-- library classes, as well as some special verbs to alter their state.

--------------------------------------------------------------------------------
-- Debugging Verbs
--------------------------------------------------------------------------------

-- These are the debugging verbs added to any adventure by this module:

-- +-----------------------+-------------------------------------------------+
-- |         syntax        |                   description                   |
-- |-----------------------|-------------------------------------------------|
-- | `dbg_clothes (obj)*!` | Shows info about a clothing item.               |
-- | `dbg_comp (act)*!`    | Shows compliance state of actors.               |
-- | `dbg_inv (act)*!`     | Show contents of an actor using `LIST` command. |
-- +-----------------------+-------------------------------------------------+

--------------------------------------------------------------------------------
-- Helper Verbs
--------------------------------------------------------------------------------

-- These are the helper verbs added to any adventure by the debug module:

-- +-----------------------+------------------------------------------+
-- |         syntax        |               description                |
-- |-----------------------|------------------------------------------|
-- | `subjugate (act)*`    | Toggles the compliancy state of an actor |
-- +-----------------------+------------------------------------------+


--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
-- DEBUGGING VERBS
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================


--==============================================================================
--------------------------------------------------------------------------------
-- DBG_CLOTHES <CLOTHING>
--------------------------------------------------------------------------------
--==============================================================================
-- DEBUGS CLOTHING VALUES
--
-- A helper verb to check the coverage values of individual clothing items.

SYNTAX dbg_clothes = dbg_clothes (obj)*!
  WHERE obj IsA clothing
    ELSE "This command can only be used on clothing items."

ADD TO EVERY clothing
  VERB dbg_clothes
    DOES
      ---------------------------------------
      -- Show coverage values (non-zero only)
      ---------------------------------------
      "'$1' VALUES:"
      IF obj:headcover = 0 AND obj:facecover = 0 AND obj:topcover = 0
      AND obj:botcover = 0 AND obj:feetcover = 0 AND obj:handscover = 0
        THEN
          "(none)"
        ELSE
          IF obj:headcover > 0
            THEN "| headcover:" SAY obj:headcover.
          END IF.
          IF obj:facecover > 0
            THEN "| facecover:" SAY obj:facecover.
          END IF.
          IF obj:topcover > 0
            THEN "| topcover:" SAY obj:topcover.
          END IF.
          IF obj:botcover > 0
            THEN "| botcover:" SAY obj:botcover.
          END IF.
          IF obj:feetcover > 0
            THEN "| feetcover:" SAY obj:feetcover.
          END IF.
          IF obj:handscover > 0
            THEN "| handscover:" SAY obj:handscover.
          END IF.
          IF obj IS NOT blockslegs
            THEN "| NOT blockslegs"
          END IF.
          IF obj IS twopieces
            THEN "| IS twopieces"
          END IF.
          "|"
      END IF.
      ---------------------------
      -- Show if it's worn or not
      ---------------------------
      "$nWORN:"
      IF obj IS NOT worn
        THEN "No"
        ELSE "Yes"
          -------------------------------
          -- Show who's the wearing actor
          -------------------------------
          FOR EACH ac IsA ACTOR
            DO
              IF obj IN ac
                THEN "($$by" SAY ac. "$$)"
              END IF.
          END FOR.
      END IF.
  END VERB dbg_clothes.
END ADD TO clothing.


--==============================================================================
--------------------------------------------------------------------------------
-- DBG_COMP <ACTOR>
--------------------------------------------------------------------------------
--==============================================================================
-- The verb 'DBG_COMP <ACTOR>' will show the compliance state of an actor.

SYNTAX dbg_comp = dbg_comp (act)*!
  WHERE act IsA actor
    ELSE "This command can only be used on actors."

ADD TO EVERY actor
  VERB dbg_comp
    DOES
      "| $+1 | COMPLIANT:"
      IF THIS IS compliant
        THEN "Yes"
        ELSE "No"
      END IF. "|"
  END VERB dbg_comp.
END ADD TO actor.


--==============================================================================
--------------------------------------------------------------------------------
-- DBG_INV <ACTOR>
--------------------------------------------------------------------------------
--==============================================================================
-- The verb 'DBG_INV <ACTOR>' will print out the inventory of an actor by using
-- the LIST instruction. Useful to check how worn items are handled by LIST,
-- since authors might use LIST in their own adventures.

SYNTAX dbg_inv = dbg_inv (act)*!
  WHERE act IsA actor
    ELSE "This command can only be used on actors."

ADD TO EVERY actor
  VERB dbg_inv
    DOES LIST THIS.
  END VERB dbg_inv.
END ADD TO actor.


--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
-- HELPER VERBS
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================


--==============================================================================
--------------------------------------------------------------------------------
-- SUBJUGATE <ACTOR>
--------------------------------------------------------------------------------
--==============================================================================
-- The verb 'SUBJUGATE <ACTOR>' will toggle the compliancy state of an actor.

SYNTAX subjugate = subjugate (act)*
  WHERE act IsA actor
    ELSE "This command can only be used on actors."

ADD TO EVERY actor
  VERB subjugate
    DOES
      "Using your mental powers you"
      IF THIS IS compliant
        THEN
          "free $+1 from the state of enforced compliancy."
          MAKE THIS NOT compliant.
        ELSE
          "force $+1 to become compliant."
          MAKE THIS compliant.
      END IF.
  END VERB subjugate.
END ADD TO actor.

--/// EOF ///--
