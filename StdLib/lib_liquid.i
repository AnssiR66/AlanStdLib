-- lib_liquid.i               | ALAN Standard Library v2.2.0-WIP | ALAN 3.0beta7
--+============================================================================+
--|\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////////|
--++--------------------------------------------------------------------------++
--||                                                                          ||
--||                    L I Q U I D S   &   V E S S E L S                     ||
--||                                                                          ||
--++--------------------------------------------------------------------------++
--|//////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\|
--+============================================================================+

-- This library module implements the `liquid` class, the verbs for handling
-- liquids and their vessels, and the relative code.

-- A `liquid` instance has the following features:
--
--  * It can only be taken if it's in a container.
--  * You can fill something with it, and you can pour it somewhere.
--  * A liquid is by default NOT drinkable.

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                                V E S S E L S
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- Every liquid is associated to a containing vessel via the `vessel` reference
-- attribute; if no vessel is specified, the default `null_vessel` will be used:

THE null_vessel ISA OBJECT
  CONTAINER
END THE.

-- A liquid with a `null_vessel` is a liquid without a container, e.g. a lake, a
-- river, etc. When the player pours a liquid on the ground, the library will
-- automatically set its `vessel` to a `null_vessel`.

-- Authors are free to implement a liquid's vessel according to need, as long as
-- it's a container. It can be small and transportable (e.g. a bottle, a vial,
-- or a jerrycan) or big and fixed in place (e.g. a pit, a swimming pool, or a
-- water tank). It can be `openable` and `lockable`, use any of the predefined
-- library attributes (e.g. `distant`, `not reachable`) or classes (e.g. being a
-- `listed_container`).

-- Due to their nature, liquids need to be handled using containers; the player
-- can't take a liquid with bare hands, and will need adequate containers to
-- carry it. This also applies to any actions requiring implicit taking.

-- In order to store a liquid into a container, the liquid must be referenced in
-- its `allowed` attribute (set type), or have been in that container when the
-- game started (when the game begins, the library automatically adds every
-- liquid which is inside a container to its `allowed` set, to ensure that it
-- can be put back in after removal). The `allowed` attribute approach, enforced
-- by the library on all its containers, replaces usage of the TAKING keyword,
-- which is the native way to handle allowed contents in ALAN; this was done in
-- order to provide a more dynamic way to control which objects can be inserted
-- into containers, and to let the library handle behind the scenes containers
-- initialization at game start.

-- Various verbs are designed to carry out an action directed at a liquid on its
-- vessel instead (e.g. "take wine" will actually take the wine bottle, or the
-- glass of wine, whichever is the current vessel of the wine). This was done in
-- order to mimic how language is used in real life, in order to provide a more
-- natural game feel and an intuitive commands interface for the player.

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                       T H E   L I Q U I D   C L A S S
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- In 'lib_verbs.i', `ISA LIQUID` expressions are used in the syntax definitions
-- of the following verbs: dive_in, drink, sip, swim_in.

--------------------------------------------------------------------------------

EVERY liquid ISA OBJECT

  HAS vessel null_vessel. -- The liquid is not in a container.

    -- The `vessel` attribute ensures that if a liquid is inside a container,
    -- the verb `take` will automatically take the container instead (if the
    -- container is `takeable`).
    -- Trying to take a liquid that is in a fixed-in-place container, or outside
    -- any container, will yield:
    --
    --    You can't carry [the liquid] around in your bare hands.
    --
    -- The default value `null_vessel` informs the library that the liquid is
    -- not inside any container (e.g. a pool, a lake, the sea, etc.).
    -- The `null_vessel` is a dummy-object default that can be ignored.

  CONTAINER
    HEADER "In" SAY THE THIS. "you see"
    ELSE "There is nothing in" SAY THE THIS. "."

    -- We declare this class a container to enable player commands such as
    -- 'throw sack into water', 'look into water' and 'take pearl from water'.
    -- Also cases such as 'pour red potion into blue potion' require that this
    -- class behaves like a container.

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


  -- If you need a liquid in a container in your game,
  -- you should declare the liquid instance thus:

  -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  -- The juice IsA LIQUID in bottle
  -- End the juice.
  -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  -- The verb `pour`, as defined in this library, also works for the container
  -- of a liquid; i.e. if there is some juice in a bottle, "pour bottle" and
  -- "pour juice" will work equally well. Note, however, that the verb `empty`
  -- is not a synonym for `pour`; `empty` only works for container objects.

  SCHEDULE check_vessel AT THIS AFTER 0. -- This event is defined further below.

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                          L I Q U I D S   V E R B S
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- Because of the special nature of liquids, and their relation to vessels, we
-- need to override some verbs on the `liquid` class in order to customize their
-- behavior and outcome: ask_for, drop, 'empty', examine, give, look_in, pour,
-- pour_in, pour_on, put_in, put_on, take, take_from.

  VERB examine
    DOES ONLY
      IF vessel OF THIS <> null_vessel
        THEN
          IF vessel OF THIS IS open
            THEN
              IF ex OF THIS <> "" -- honor the custom description, if present:
                THEN SAY ex OF THIS.
                ELSE "You notice nothing unusual about" SAY THE THIS.
              END IF.
            ELSE -- Prevent examining a liquid in a closed container:
              "You can't see what's inside" SAY THE vessel OF THIS. "$$, since"
              IF THIS IS NOT plural
                THEN "it's"
                ELSE "they are"
              END IF. "closed."
          END IF.
        ELSE -- i.e. the liquid doesn't have a vessel:
          IF ex OF THIS <> "" -- honor the custom description, if present:
            THEN SAY ex OF THIS.
            ELSE "You notice nothing unusual about" SAY THE THIS.
          END IF.
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
            ELSE "(taking" SAY THE vessel OF THIS. "of" SAY THIS. "first)$n"
              LOCATE vessel OF THIS IN hero.
          END IF.
      END IF.
      -- <<< implicit take <<<

      -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      -- NOTE: If the implicit-take action failed due to an EXTRACT clause,
      --       the verb would simply abort, and this code never be executed.
      -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      IF THIS IN hero THEN
        -- i.e. if the liquid wasn't vessel-less, or its vessel not takeable.
        "You give" SAY THE vessel OF THIS. "of" SAY THIS.
        "to" SAY THE recipient. "."
        LOCATE vessel OF THIS IN recipient.
      END IF.

      -- NOTE: There's no ELSE statement in this last IF clause, because the
      --       previous `IF THIS NOT IN hero` clause already took care of the
      --       possible alternatives.
  END VERB give.



  VERB pour
    DOES ONLY
      -- >>> implicit take >>>
      IF THIS NOT IN hero
        THEN
          IF vessel OF THIS = null_vessel OR vessel OF THIS IS NOT takeable
            THEN "You can't pour" SAY THE THIS.
              "anywhere since you are not carrying"
              IF THIS IS NOT plural
                THEN "it."
                ELSE "them."
              END IF.
          ELSE "(taking" SAY THE vessel OF THIS. "of" SAY THIS. "first)$n"
               LOCATE vessel OF THIS IN hero.
          END IF.
      END IF.
      -- <<< implicit take <<<

      -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      -- NOTE: If the implicit-take action failed due to an EXTRACT clause,
      --       the verb would simply abort, and this code never be executed.
      -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      IF THIS IN hero
        -- i.e. if the liquid wasn't vessel-less, or its vessel not takeable.
        THEN LOCATE THIS AT hero.
          SET vessel OF THIS TO null_vessel.
          "You pour" SAY THE THIS. "on the"
          IF floor HERE
            THEN "floor."
            ELSE "ground."
          END IF.
      END IF.
  END VERB pour.



  VERB pour_in
    WHEN obj
      CHECK obj NOT DIRECTLY IN cont
        AND obj NOT IN cont
          ELSE
            IF cont ISA SUPPORTER
              THEN SAY check_cont_not_supporter OF my_game.
              ELSE
                IF obj IS NOT plural
                  THEN SAY check_obj_not_in_cont_sg OF my_game.
                  ELSE SAY check_obj_not_in_cont_pl OF my_game.
                END IF.
            END IF.

      DOES ONLY
        -- >>> implicit take >>>
        IF THIS NOT IN hero
          THEN
            IF vessel OF THIS = null_vessel
              THEN "You can't carry" SAY THE THIS. "around in your bare hands."
            ELSIF vessel OF THIS IS NOT takeable
              THEN "You don't have" SAY THE vessel OF THIS. "of" SAY THIS. "."
            ELSE "(taking" SAY THE vessel OF THIS. "of" SAY THIS. "first)$n"
              LOCATE vessel OF THIS IN hero.
            END IF.
        END IF.
        -- <<< implicit take <<<

        -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        -- NOTE: If the implicit-take action failed due to an EXTRACT clause,
        --       the verb would simply abort, and this code never be executed.
        -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        IF THIS IN hero THEN
          -- i.e. if the liquid wasn't vessel-less, or its vessel not takeable.
          LOCATE THIS IN cont.
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
            ELSE "(taking" SAY THE vessel OF THIS. "of" SAY THIS. "first)$n"
              LOCATE vessel OF THIS IN hero.
            END IF.
        END IF.
        -- <<< implicit take <<<

        -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        -- NOTE: If the implicit-take action failed due to an EXTRACT clause,
        --       the verb would simply abort, and this code never be executed.
        -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        IF THIS IN hero THEN
          -- i.e. if the liquid wasn't vessel-less, or its vessel not takeable.
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
    WHEN obj DOES ONLY
      IF vessel OF THIS = null_vessel
        THEN "You can't carry" SAY THE THIS. "around in your bare hands."
        ELSE
          IF vessel OF THIS IS takeable
            THEN
              -- >>> implicit take >>>
              IF THIS NOT IN hero THEN
                "(taking" SAY THE vessel OF THIS. "of" SAY THIS. "first)$n"
                LOCATE vessel OF THIS IN hero.
              END IF.
              -- <<< implicit take <<<

              -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
              -- NOTE: If the implicit-take action failed due to an EXTRACT
              --       clause, the verb would simply abort, and this code
              --       never be executed.
              -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
              LOCATE vessel OF THIS IN cont.
              "You put" SAY THE vessel OF THIS. "of" SAY THIS.
              "into" SAY THE cont. "."

            ELSE -- If the liquid's vessel is not takeable:
              "You don't have" SAY THE vessel OF THIS. "of" SAY THIS. "."
          END IF.
      END IF.

    WHEN cont DOES ONLY
      IF vessel OF THIS = null_vessel
        THEN
          "Putting" SAY THE obj. "into" SAY THE THIS. "would be senseless."
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
    WHEN obj DOES ONLY
      -- >>> implicit take >>>
      IF THIS NOT IN hero
        THEN
          IF vessel OF THIS = null_vessel
            THEN "You can't carry" SAY THE THIS. "around in your bare hands."
            ELSIF vessel OF THIS IS NOT takeable
              THEN "You don't have" SAY THE vessel OF THIS. "of" SAY THIS. "."
              ELSE "(taking" SAY THE vessel OF THIS. "of" SAY THIS. "first)$n"
                LOCATE vessel OF THIS IN hero.
          END IF.
      END IF.
      -- <<< implicit take <<<

      -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      -- NOTE: If the implicit-take action failed due to an EXTRACT clause,
      --       the verb would simply abort, and this code never be executed.
      -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      IF THIS IN hero THEN
        -- i.e. if the liquid wasn't vessel-less, or its vessel not takeable.
        "You put" SAY THE vessel OF THIS. "of" SAY THIS.
        "onto" SAY THE surface. "."
        LOCATE vessel OF THIS IN surface.
      END IF.

    WHEN surface DOES ONLY
      "It is not possible to $v" SAY obj. "onto" SAY THE THIS. "."
  END VERB put_on.

--==============================================================================
--------------------------------------------------------------------------------
-- Disabled Verbs
--------------------------------------------------------------------------------
--==============================================================================

  -- The verbs `'empty'`, `empty_in` and `empty_on` are disabled on liquids,
  -- because grammatically incorrect:

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

END EVERY liquid.

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                         L I Q U I D S   E V E N T S
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- This recurrent event uprated at every turn the state of liquids and vessels,
-- ensuring their status integrity:
--
--   * If a liquid is outside a container, set its `vessel` to `null_vessel`.
--   * If a `LISTED_CONTAINER` directly contains a liquid, set the former as
--     the `vessel` of the latter.

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

-- end of file.
