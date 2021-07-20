-- lib_actors.i               | ALAN Standard Library v2.2.0-WIP | ALAN 3.0beta7
--+============================================================================+
--|\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////////|
--++--------------------------------------------------------------------------++
--||                                                                          ||
--||                       A C T O R S   C L A S S E S                        ||
--||                                                                          ||
--++--------------------------------------------------------------------------++
--|//////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\|
--+============================================================================+

-- This library module contains the code that defines the standard behavior of
-- actors, as well as some specialized actor sub-classes:

--               +----------------------------------------------+
--               | PERSON                                       |
--               +----------------------------------------------+
--               | * is able to talk (= 'CAN talk').            |
--               +----------------------------------------------+
--               | FEMALE                                       |
--               +----------------------------------------------+
--               | * A subclass of person (= is able to talk).  |
--               | * Can be referred to with the pronoun 'her'. |
--               +----------------------------------------------+
--               | MALE                                         |
--               +----------------------------------------------+
--               | * A subclass of person (= is able to talk).  |
--               | * Can be referred to with the pronoun 'him'. |
--               +----------------------------------------------+

-- ACTORS are defined to be `NOT inanimate` CONTAINERS (so that they can, for
-- example, receive and carry objects).

-- Actors are usually preceded by an article in-game, for example:
--
--   You see a man here.
--   There is nothing special about the dog.
--
-- unless they are declared as `named`, in which case they are mentioned using
-- their proper name, for example:
--
--   You see Janet here.


--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                  C O M M O N   A C T O R S '   T R A I T S
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================


-- First, we declare some common characteristics for all actors:

ADD TO EVERY ACTOR
  IS NOT inanimate.
  IS NOT following.
  IS NOT sitting.
  IS NOT lying_down.
  IS NOT named. -- The NPC's name is unknown or not his primary NAME.

    -- The definite article will precede a `NOT named` actor's NAME whenever
    -- mentioned (e.g. "the professor") because the NPC's name is either unknown
    -- or it's defined as a secondary NAME (i.e. it's recognized in the player
    -- input but it's not used when mentioning the actor).

  IS NOT compliant. -- Won't let the hero take his possession.

    -- NPCs will only give up their possessions if in a compliant mood, or when
    -- asked for them. Attempting to take objects from a non compliant NPC will
    -- fail; this applies also to implicit taking (e.g. throwing an object held
    -- by an actor).
    -- By default, asking a NPC for his possessions always succeeds, regardless
    -- of his compliance state. To change this, the author needs to override the
    -- `ask_for` verb according to needs.

  IS NOT takeable.
  IS sex 0. -- Optional value to enforce gender.

    -- Currently the `sex` attribute is only used by the library for the `wear`
    -- verb on the `clothing` class: if a clothing item has a non-zero `sex`
    -- value, the hero won't be able to wear it unless he/she has the same `sex`
    -- value.

    -- The library doesn't provide any further gender related features for NPCs,
    -- so it will be up to the author to implement the extra code to handle the
    -- `sex` attribute on NPCs (e.g. different verb outcomes based on gender,
    -- etc.).

    -- Authors are free to use any arbitrary values to enforce different genders
    -- here. The term `sex` is misleading, for this attribute could be used not
    -- only to differentiate between male and female actors and clothing, but
    -- also between children and adults; humans and aliens; the various races
    -- that populate a fantasy world; etc. Since no word was to found that could
    -- represent all its possible uses, the term `sex` was kept for its brevity
    -- and intuitiveness.

    -- This was mostly an experimental attribute that was never developed into a
    -- full-fledged gender support feature across the library. Nevertheless,
    -- authors are encouraged to exploit this attribute in those adventures that
    -- require different verbs outcomes and clothes-matching for different
    -- genders, ages, or creatures races.


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

  -- If you need "an", you must declare it within the actor instance.


  CONTAINER -- So that actors can receive and carry objects.
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
        ELSE "That seems to belong to" SAY THE THIS. "."
        -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        -- NOTE: The above CHECK will interrupt the execution of any verb that
        --       attempts dislocating an item from a non-compliant actor. When
        --       the LOCATE statement fails, the verb simply aborts. The above
        --       message from the ELSE clause will be printed, just before the
        --       verb aborts executing.
        -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



  INITIALIZE

    MAKE hero compliant. -- So the hero can give, drop, etc. carried objects.

    -- All NPC actors will obey this script from the start of the game:
    IF THIS <> hero
      THEN USE SCRIPT following_hero FOR THIS.
    END IF.



  SCRIPT following_hero
    -- ------------------------------------------------
    -- This code will make any NPC follow the hero,
    -- if the actor is given the attribute `following`.
    -- ------------------------------------------------
    STEP WAIT UNTIL hero NOT HERE
    IF THIS IS following
      THEN
        LOCATE THIS AT hero.
        "$p" SAY THE THIS. "follow"
        IF THIS IS NOT plural
          THEN "$$s"
        END IF. "you."
    END IF.
    USE SCRIPT following_hero FOR THIS.
    -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    -- WARNING: If you assign a custom script to an NPC, it will automatically
    --          stop executing the `following_hero` script. This means that:
    --
    --          1. The `following` attribute of that actor won't be honored by
    --             the library while the actor is using your script(s).
    --          2. Once the custom script terminates, you'll need to manually
    --             make the actor `USE following_hero` again, if you wish that
    --             the library will track its `following` status correctly.
    -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



  DESCRIPTION
    IF THIS IS scenery
      THEN "$$"
    ELSIF THIS IS NOT named
      THEN "There"
        IF THIS IS NOT plural
          THEN "is" SAY AN THIS.
          ELSE "are" SAY THIS.
        END IF. "here."
      ELSE SAY THIS.
        IF THIS IS NOT plural
          THEN "is"
          ELSE "are"
        END IF. "here."
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
              FOR EACH carried_item IsA object, IS NOT worn, DIRECTLY IN THIS
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


--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                                 P E R S O N
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- A `person` actor exhibits the following human features:
--
--   * The ability to talk (`CAN talk.`).
--   * When not carrying anything, is reported as being "empty handed".

-- This class is not cross-referenced elsewhere in this file nor in any other
-- library module.

--------------------------------------------------------------------------------

EVERY person IsA ACTOR
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

END EVERY person.

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                          F E M A L E   &   M A L E
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- MALE and FEMALE are both subclasses of PERSON, so they share the ability to
-- talk, and all the other human traits of the PERSON class.

-- The library only adds the appropriate pronouns for the gender to these two
-- sub-classes; but authors could extend them to allow gender-specific verb
-- results, for example.

-- These two classes are not cross-referenced elsewhere in this file nor in any
-- other library module.

--------------------------------------------------------------------------------

EVERY female IsA PERSON
  PRONOUN her
END EVERY.


EVERY male IsA PERSON
  PRONOUN him
END EVERY.


-- end of file.
