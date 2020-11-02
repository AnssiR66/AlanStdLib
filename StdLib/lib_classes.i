-- lib_classes.i              | ALAN Standard Library v2.2.0-WIP | ALAN 3.0beta7
--+============================================================================+
--|\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////////|
--++--------------------------------------------------------------------------++
--||                                                                          ||
--||                      L I B R A R Y   C L A S S E S                       ||
--||                                                                          ||
--++--------------------------------------------------------------------------++
--|//////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\|
--+============================================================================+

-- This library module defines various classes that enable authors to create
-- complex game objects that mimic their real-life counterparts in a realistic
-- manner, thanks to dedicated attributes and event, and their class-based verbs
-- variants that enforce behavior consistency.

-- Many of these classes are frequently referenced inside the verb definitions
-- of 'lib_verbs.i', so they should be edited or removed with caution. However,
-- to ease things up, the opening comments of every class mention if and where
-- the class is cross-referenced in the other library modules.

-- More library classes definitions can be found in the following modules:

--   * lib_actors.i
--   * lib_clothing.i
--   * lib_liquid.i
--   * lib_locations.i

--------------------------------------------------------------------------------
--                                .: CONTENTS :.
--------------------------------------------------------------------------------

-- The following table presents all the classes defined in this module, with a
-- brief overview of their features and attributes.

--+----------------------------------------------------------------------------+
--| DEVICE                                                                     |
--+----------------------------------------------------------------------------+
--| * A machine or electronic device than can be turned/switched ON and OFF,   |
--|   unless it's broken. E.g. a stove, a TV.                                  |
--| * Attributes: NOT on, NOT broken.                                          |
--| * When described, the library mentions whether it's on or off.             |
--+----------------------------------------------------------------------------+
--| DOOR                                                                       |
--+----------------------------------------------------------------------------+
--| * Doors can be opened and closed, and (optionally) locked and unlocked.    |
--| * Defaults to: NOT open, NOT lockable.                                     |
--| * Attributes: openable, NOT open, NOT lockable, NOT locked, NOT takeable.  |
--| * When described, the library mentions whether it's open or closed.        |
--+----------------------------------------------------------------------------+
--| LIGHTSOURCE                                                                |
--+----------------------------------------------------------------------------+
--| * A light source can be either `natural` or `NOT natural`.                 |
--|   (e.g. natural: match, candle, campfire; NOT natural: flashlight).        |
--| * It can be turned ON and OFF, lighted and extinguished (= put out) unless |
--|   it's broken. A natural light source cannot be turned on or off, it can   |
--|   only be lighted and extinguished (= put out).                            |
--| * When described, the library mentions whether it's providing light or not.|
--+----------------------------------------------------------------------------+
--| LISTED_CONTAINER                                                           |
--+----------------------------------------------------------------------------+
--| * It's a container object whose contents will be listed both after 'look'  |
--|   (i.e. in the room description), 'look in' and 'examine', if it's open,   |
--|   otherwise the library will mention that it's not possible to see what's  |
--|   inside it because it's closed.                                           |
--|   Contents of a normal container objects are not listed after 'examine',   |
--|   but only after 'look' and 'look in'.                                     |
--+----------------------------------------------------------------------------+
--| SOUND                                                                      |
--+----------------------------------------------------------------------------+
--| * Can be listened to but not examined, searched, smelled or manipulated.   |
--| * Can be optionally turned ON and OFF, if required.                        |
--+----------------------------------------------------------------------------+
--| SUPPORTER                                                                  |
--+----------------------------------------------------------------------------+
--| * Supporters are flat surfaces capable of holding objects (e.g. a table).  |
--| * You can put things on it, and even stand on it.                          |
--| * It's declared as a container, so you can take things from it, as well.   |
--| * Its contents are listed in room descriptions and upon examination.       |
--+----------------------------------------------------------------------------+
--| WEAPON                                                                     |
--+----------------------------------------------------------------------------+
--| * Weapons can be either `fireable` (e.g. guns) or `NOT fireable` (e.g. a   |
--|   baseball bat, knives, swords).                                           |
--| * Defaults to: NOT fireable.                                     |
--+----------------------------------------------------------------------------+
--| WINDOW                                                                     |
--+----------------------------------------------------------------------------+
--| * Windows can be opened, closed, looked through and out of.                |
--| * When described, the library mentions whether it's open or closed.        |
--+----------------------------------------------------------------------------+

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                                 D E V I C E
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- This class is not cross-referenced elsewhere in this file nor in any other
-- library module.

--------------------------------------------------------------------------------

EVERY device ISA OBJECT

  VERB examine
    DOES AFTER
      IF THIS IS NOT plural
        THEN "It is"
        ELSE "They are"
      END IF.

      IF THIS IS on
        THEN "currently on."
        ELSE "currently off."
      END IF.
  END VERB examine.



  VERB turn_on
    CHECK THIS IS NOT on
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
      MAKE THIS on.
  END VERB turn_on.



  VERB turn_off
    CHECK THIS IS on
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
      MAKE THIS NOT on.
  END VERB turn_off.



  -- The following verb switches a device OFF if it's ON, and vice versa.

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
      IF THIS IS on
        THEN "You switch off" SAY THE THIS. "."
          MAKE THIS NOT on.
        ELSE "You switch on" SAY THE THIS. "."
          MAKE THIS on.
      END IF.
  END VERB switch.

END EVERY.

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                                   D O O R
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- This class is not cross-referenced elsewhere in this file nor in any other
-- library module.

--------------------------------------------------------------------------------

-- tag::default-attributes-door[]
EVERY door ISA OBJECT
  IS openable.
  IS NOT open.
  IS NOT lockable.
  IS NOT locked.
  IS NOT takeable.

  HAS otherside null_door.  -- matching door in the other room.

    -- The `null_door` is a just the default dummy-object placeholder (ignore).

    -- The the other side of the door in the next room will be automatically
    -- taken care of by the library, so that its status is updated to match its
    -- counterpart, as if they were a single object.
-- end::default-attributes-door[]

  INITIALIZE

    -- Ensure that the author didn't forget to declare a locked door as closed
    -- (= NOT open) as well. This is just double-checking, as any door is by
    -- default `NOT open` at the start of the game:

    IF THIS IS locked
      THEN
        IF THIS IS open
          THEN MAKE THIS NOT open.
        END IF.
    END IF.

    -- If a door was given an `otherside` door, ensure that the latter points to
    -- the former in its `otherside` attribute in return:

    IF otherside OF THIS <> null_door
      THEN
        SET otherside OF otherside OF THIS TO THIS.

      -- Next, ensure that the attributes of the `otherside` door have mirroring
      -- setting to its counterpart. Only some non-default cases need to be
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


    -- Make the same matching_key open both sides of a door:

    IF otherside OF THIS <> null_door
    AND matching_key OF THIS <> null_key
      THEN SET matching_key OF otherside OF THIS TO matching_key OF THIS.
    END IF.


  -- If a door is lockable/locked, you should state in its instance declaration
  -- which object will unlock it, via the `matching_key attribute`. E.g.:

  -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  -- The attic_door IsA door
  --   Has matching_key brass_key.
  --   ...
  -- End the.
  --
  -- The brass_key IsA object at basement
  -- End the.
  -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--==============================================================================
--------------------------------------------------------------------------------
--                             D O O R   V E R B S
--------------------------------------------------------------------------------
--==============================================================================

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
        THEN "You cannot look behind the"
          IF THIS IS NOT plural
            THEN "door - it is closed."
            ELSE "doors - they are closed."
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
          "is so narrow that you can't see anything
           of what lies on the other side."
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

END EVERY door.


-- A dummy placeholder used internally for default settings (ignore):

THE null_door ISA DOOR
END THE.

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                            L I G H T S O U R C E
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- In 'lib_locations.i', `ISA LIGHTSOURCE` expressions are used to define the
-- behavior of the DARK_LOCATION class.

--------------------------------------------------------------------------------


-- tag::default-attributes-lightsource[]
EVERY lightsource ISA OBJECT
  IS NOT lit.
  IS natural. -- A natural light source, e.g. a candle, a match or a torch.
              -- A `NOT natural` light source is, e.g., a flashlight or a lamp.
              -- You cannot switch on or off a natural light source.
-- end::default-attributes-lightsource[]

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


  -- The `switch` verb toggles the current state of a NOT natural lightsource
  -- (i.e. turns it ON if it was OFF, and vice-versa). It's a lazy variant,
  -- intended for when the player forgets, or doesn't bother, to type 'on' or
  -- 'off' after the 'switch' command.

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

END EVERY lightsource.

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                       L I S T E D   C O N T A I N E R
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- In 'lib_verbs.i', this class is cross-referenced in the DOES body of the
-- take_from verb.

--------------------------------------------------------------------------------

EVERY LISTED_CONTAINER ISA OBJECT
  CONTAINER

    --  (ACTORS are separately defined to be containers further below.)

  INITIALIZE

  -- Every object that's inside a LISTED_CONTAINER at the beginning of the game
  -- will be allowed back in that container, by default, after being taken out:

    FOR EACH lc ISA LISTED_CONTAINER
      DO
        FOR EACH o ISA OBJECT, DIRECTLY IN lc
          DO
            INCLUDE o IN allowed OF lc.
        END FOR.
    END FOR.



  VERB examine
    DOES ONLY
      IF ex OF THIS <> "" -- honor the custom description, if present:
        THEN SAY ex OF THIS.
      END IF.
      IF THIS IS NOT OPAQUE
        THEN LIST THIS.
        ELSE "You can't see what's inside" SAY THE THIS. "$$, since"
          IF THIS IS NOT plural
            THEN "it's"
            ELSE "they are"
          END IF. "closed."
      END IF.
  END VERB examine.


  VERB look_in
    DOES ONLY
      IF THIS IS NOT OPAQUE
        THEN LIST THIS.
        ELSE "You can't see what's inside" SAY THE THIS. "$$, since"
          IF THIS IS NOT plural
            THEN "it's"
            ELSE "they are"
          END IF. "closed."
      END IF.
  END VERB look_in.


  VERB search
    DOES ONLY
      IF THIS IS NOT OPAQUE
        THEN LIST THIS.
        ELSE "You can't see what's inside" SAY THE THIS. "$$, since"
          IF THIS IS NOT plural
            THEN "it's"
            ELSE "they are"
          END IF. "closed."
      END IF.
  END VERB search.



-- Note that a closed LISTED_CONTAINER is OPAQUE by default,
-- it becomes NOT OPAQUE when opened.

-- In order to support this behavior also on lockable LISTED_CONTAINERs, before
-- changing the opaqueness state we need to check that the container is actually
-- in the expected open/close state --- e.g., if the player tries to open a
-- locked LISTED_CONTAINER for which he doesn't have the matching_key, then the
-- 'open' action will have failed. Similarly, to be on the safe side, we'll also
-- implement this behavior on other verbs that could potentially affect the
-- open/close state of a LISTED_CONTAINER (i.e. if an author implements them on
-- some class or instance).


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

END EVERY LISTED_CONTAINER.

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                                  S O U N D
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- This class is not cross-referenced elsewhere in this file nor in any other
-- library module.

--------------------------------------------------------------------------------

-- tag::default-attributes-sound[]
EVERY sound ISA OBJECT
  IS NOT examinable.
  IS NOT takeable.
  IS NOT reachable.
  IS NOT movable.
-- end::default-attributes-sound[]

  VERB smell
    DOES ONLY
      IF THIS IS NOT plural
        THEN "That's not"
        ELSE "Those are not"
      END IF.
      "something you can smell."
  END VERB smell.

END EVERY sound.

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                              S U P P O R T E R
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- In 'lib_verbs.i', this class is referenced in the syntax definitions, verb
-- checks and/or definitions of the following verbs: climb_on, get_off, jump_on,
-- lie_on, put_in, put_on, sit_on, stand_on, take_from.

--------------------------------------------------------------------------------

EVERY supporter ISA OBJECT

  CONTAINER
    HEADER "On" SAY THE THIS. "you see"
    ELSE "There's nothing on" SAY THE THIS. "."



  VERB examine
    DOES
      LIST THIS.
  END VERB examine.


  -- In the following, we disable some verbs that are defined to work with
  -- normal containers:


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

END EVERY supporter.

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                                 W E A P O N
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- In 'lib_verbs.i', this class is referenced in the syntax definitions, verb
-- checks and/or definitions of the following verbs: attack_with, fire, fire_at,
-- fire_at_error, kill_with, shoot_with.

--------------------------------------------------------------------------------


-- tag::default-attributes-weapon[]
EVERY weapon ISA OBJECT
  IS NOT fireable.
END EVERY.
-- end::default-attributes-weapon[]

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                                 W I N D O W
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- This class is not cross-referenced elsewhere in this file nor in any other
-- library module.


-- You can look out of and through a window.
-- When examined, a window is described as being either open or closed.

--------------------------------------------------------------------------------


-- tag::default-attributes-window[]
EVERY window ISA OBJECT
  IS openable.
  IS NOT open.
  IS NOT takeable.
-- end::default-attributes-window[]


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

END EVERY window.


-- end of file.
