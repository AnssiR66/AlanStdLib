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
-- variants that enforce behavior consistency:

--   * DEVICE
--   * DOOR
--   * LIGHTSOURCE
--   * LISTED_CONTAINER
--   * SOUND
--   * SUPPORTER
--   * WEAPON
--   * WINDOW

-- Many of these classes are frequently referenced inside the verb definitions
-- of 'lib_verbs.i', so they should be edited or removed with caution. However,
-- to ease things up, the opening comments of every class mention if and where
-- the class is cross-referenced in the other library modules.

-- More library classes definitions can be found in the following modules:

--   * lib_actors.i
--   * lib_clothing.i
--   * lib_liquid.i
--   * lib_locations.i

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

-- ATTRIBUTES DEFAULTS: NOT on, NOT broken.

-- A `device` is a machine or an electronic device than can be turned/switched
-- ON and OFF, unless it's broken. E.g. a stove, a TV.

-- After examining a device, the library will additionally mention its current
-- ON/OFF status ("[It is|They are] currently [on|off].").


-- This class is not cross-referenced elsewhere in this file nor in any other
-- library module.

--------------------------------------------------------------------------------

EVERY device ISA OBJECT

--------------------------------------------------------------------------------
-- EXAMINE DEVICE
--------------------------------------------------------------------------------

  VERB examine
    DOES AFTER
      IF THIS IS NOT plural
        THEN "It is"
        ELSE "They are"
      END IF.
      "currently"
      IF THIS IS on
        THEN "on"
        ELSE "off"
      END IF. "."
  END VERB examine.

--------------------------------------------------------------------------------
-- TURN ON DEVICE
--------------------------------------------------------------------------------

  VERB turn_on --> [turn|switch] on (app) | [turn|switch] (app) on
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

--------------------------------------------------------------------------------
-- TURN OFF DEVICE
--------------------------------------------------------------------------------

  VERB turn_off --> [turn|switch] off (app) | [turn|switch] (app) off
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

--------------------------------------------------------------------------------
-- SWITCH DEVICE
--------------------------------------------------------------------------------

-- The following verb toggles the device state; i.e. switches it OFF if it's ON,
-- and vice versa. It was added to provide a "lazy alternative," and to catch
-- cases where the player forgot to add 'on' or 'off' after the 'switch'
-- command.

  VERB switch --> switch (app)
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

END EVERY device.

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

-- ATTRIBUTES DEFAULTS: NOT openable, NOT open, NOT lockable, NOT locked.

-- Doors can be opened and closed, and (optionally) locked and unlocked.

-- After examining a door, the library will additionally mention its current
-- status ("[It is|They are] currently [open|closed].").


-- Authors have two options to implement a door across two locations:

--  1) Create a single door that is moved between its two belonging locations,
--     via the ENTERED clauses of each location.
--  2) Create two door objects, one in each connected location, and link them
--     together via their `otherside` attribute.

-- The former approach provides the illusion of a door standing between two
-- locations by making the door follow the hero when he moves across them; what
-- seems a two-sided door is in reality the same object.

-- The latter solution provides a truly two-sided door, built from two doors
-- whose attributes are automatically synchronized by the library --- when the
-- hero locks/unlocks or opens/closes one door, its matching counterpart on the
-- other side is automatically updated too.

-- The single-door approach can be more practical when both sides of the door
-- share identical descriptions and/or have custom verbs defining additional
-- behaviors, because authors would be dealing with a single instance.

-- The`otherside` dual-door approach is a better choice when the two sides of
-- the door are asymmetrical, having different descriptions and behaviors (e.g.
-- a door which can only be opened/closed and locked/unlocked from one side),
-- because authors can customize each side's behavior independently, since each
-- side is an instance of its own.


-- This class is not cross-referenced elsewhere in this file nor in any other
-- library module.

--------------------------------------------------------------------------------

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

-- ATTRIBUTES DEFAULTS: natural, NOT lit, NOT broken.

-- The `lightsource` class is designed to provides the means to illuminate dark
-- locations which are `DARK_LOCATION`, `DARK_ROOM` or `DARK_SITE` instances
-- (defined in 'lib_lications.i').

-- After examining a light source, the library will additionally mention its
-- status ("[It is|They are] currently [on|off|lit|unlit].").

-- A light source can be either `natural` or artificial (`NOT natural`); a
-- distinction affecting which verbs the player can use to control them:

--   * Natural light sources can be lighted and extinguished/put out.
--     (but not turned/switched ON/OFF)
--   * Artificial light sources can be turned/switched ON/OFF and lighted.
--     (but not extinguished/put out)

-- When a light source is `broken`, it can't be turned on or lighted.

-- Natural light sources Examples: a match, a candle, a campfire.
-- Artificial light sources Examples: a flashlight, a light bulb, a table lamp.


-- In 'lib_locations.i', `ISA LIGHTSOURCE` expressions are used to define the
-- behavior of the DARK_LOCATION class.

--------------------------------------------------------------------------------


EVERY lightsource ISA OBJECT
  IS NOT lit.
  IS natural.

--------------------------------------------------------------------------------
-- EXAMINE LIGHTSOURCE
--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------
-- LIGHT LIGHTSOURCE
--------------------------------------------------------------------------------

-- Any type of unbroken light source can be lighted.

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
        THEN "You light"
        ELSE "You turn on"
      END IF.
      SAY THE THIS. "."
      MAKE THIS lit.
  END VERB light.

--------------------------------------------------------------------------------
-- EXTINGUISH LIGHTSOURCE
--------------------------------------------------------------------------------

-- Only natural light sources can be extinguished.
-- If it's lit, it can't be broken; so the `IS NOT broken` CHECK is not needed.

  VERB extinguish --> [extinguish|put out] (obj) | put (obj) out
    CHECK THIS IS natural
      ELSE
        IF THIS IS NOT plural
          THEN "That's"
          ELSE "Those are"
        END IF.
        "not something you can extinguish."
    AND THIS IS lit
      ELSE
        IF THIS IS NOT plural
          THEN SAY check_lightsource_lit_sg OF my_game.
          ELSE SAY check_lightsource_lit_pl OF my_game.
        END IF.

    DOES ONLY
      "You extinguish" SAY THE THIS. "."
      MAKE THIS NOT lit.
  END VERB extinguish.

--------------------------------------------------------------------------------
-- TURN ON LIGHTSOURCE
--------------------------------------------------------------------------------

-- Only unbroken artificial light sources can be turned on.

  VERB turn_on --> [turn|switch] on (app) | [turn|switch] (app) on
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

--------------------------------------------------------------------------------
-- TURN OFF LIGHTSOURCE
--------------------------------------------------------------------------------

-- Only artificial light sources can be turned off.
-- If it's ON, it can't be broken; so the `IS NOT broken` CHECK is not needed.

  VERB turn_off --> [turn|switch] off (app) | [turn|switch] (app) off
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

--------------------------------------------------------------------------------
-- SWITCH LIGHTSOURCE
--------------------------------------------------------------------------------

-- Only unbroken artificial light sources can be switched.

-- The following verb toggles the state of an artificial light source; i.e.
-- switches it OFF if it's ON, and vice versa. It was added to provide a "lazy
-- alternative," and to catch cases where the player forgot to add 'on' or 'off'
-- after the 'switch' command.

  VERB switch --> switch (app)
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
      "You switch"
      IF THIS IS lit
        THEN "off" SAY THE THIS. "."
          MAKE THIS NOT lit.
        ELSE "on" SAY THE THIS. "."
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

-- A LISTED_CONTAINER is a container object whose contents will be listed both
-- after 'look' (i.e. in the room description), 'look in' and 'examine', if it's
-- open, otherwise the library will mention that it's not possible to see what's
-- inside it because it's closed.

-- Contents of a normal container objects are not listed after 'examine', but
-- only after 'look' and 'look in'.


-- In 'lib_verbs.i', this class is cross-referenced in the DOES body of the
-- take_from verb.

--------------------------------------------------------------------------------

EVERY LISTED_CONTAINER ISA OBJECT
  CONTAINER

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

--------------------------------------------------------------------------------
-- EXAMINE LISTED_CONTAINER
--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------
-- LOOK IN LISTED_CONTAINER
--------------------------------------------------------------------------------

  VERB look_in --> 'look' 'in' (cont)
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

--------------------------------------------------------------------------------
-- SEARCH LISTED_CONTAINER
--------------------------------------------------------------------------------

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

--==============================================================================
--------------------------------------------------------------------------------
-- Opening and Closing LISTED_CONTAINERs
--------------------------------------------------------------------------------
--==============================================================================

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

--------------------------------------------------------------------------------
-- OPEN LISTED_CONTAINER
--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------
-- CLOSE/LOCK LISTED_CONTAINER
--------------------------------------------------------------------------------

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

-- Sound instances can be listened to, but not examined, searched, smelled or
-- manipulated in any way.


-- This class is not cross-referenced elsewhere in this file nor in any other
-- library module.

--------------------------------------------------------------------------------

EVERY sound ISA OBJECT
  IS NOT examinable.
  IS NOT takeable.
  IS NOT reachable.
  IS NOT movable.

--------------------------------------------------------------------------------
-- SMELL SOUND
--------------------------------------------------------------------------------

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

-- A supporters is a flat surface capable of holding objects (e.g. a table):

--   * You can put things on it, and even stand on it.
--   * It's declared as a container, so you can take things from it, as well.
--   * Its contents are listed in room descriptions and upon examination.


-- In 'lib_verbs.i', this class is referenced in the syntax definitions, verb
-- checks and/or definitions of the following verbs: climb_on, get_off, jump_on,
-- lie_on, put_in, put_on, sit_on, stand_on, take_from.

--------------------------------------------------------------------------------

EVERY supporter ISA OBJECT

  CONTAINER
    HEADER "On" SAY THE THIS. "you see"
    ELSE "There's nothing on" SAY THE THIS. "."

--------------------------------------------------------------------------------
-- EXAMINE SUPPORTER
--------------------------------------------------------------------------------

  VERB examine
    DOES
      LIST THIS.
  END VERB examine.

--==============================================================================
--------------------------------------------------------------------------------
-- Disabled Verbs
--------------------------------------------------------------------------------
--==============================================================================

-- Since supporters are flat surfaces, we need to disable some verbs designed to
-- act on normal containers:


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

-- ATTRIBUTES DEFAULTS: NOT fireable.

-- Weapons can be either `fireable` (e.g. guns) or `NOT fireable` (e.g. knives,
-- swords, sticks, or batons).

-- The verbs applying to weapons are defined in 'lib_verbs.i':

--   * Verbs for fireable weapons only:
--     * `fire`
--     * `fire_at`
--     * `shoot_with`
--   * Verbs for all weapons types:
--     * `attack_with`
--     * `kill_with`


-- In 'lib_verbs.i', this class is referenced in the syntax definitions, verb
-- checks and/or definitions of the following verbs: attack_with, fire, fire_at,
-- fire_at_error, kill_with, shoot_with.

--------------------------------------------------------------------------------


EVERY weapon ISA OBJECT
  IS NOT fireable.
END EVERY.

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

-- ATTRIBUTES DEFAULTS: openable, NOT open, NOT takeable.

-- Windows can be opened, closed, looked through and out of.
-- When examined, a window is described as being either open or closed.


-- This class is not cross-referenced elsewhere in this file nor in any other
-- library module.

--------------------------------------------------------------------------------

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

END EVERY window.


-- end of file.
