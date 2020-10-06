-- ALAN Standard Library v2.2.0-WIP | ALAN 3.0beta7
-- Locations (file name: 'lib_locations.i')
--------------------------------------------------------------------------------

-- This library file defines the default directions (exits) and the location
-- `nowhere`, a useful place to locate things when you want to remove them from
-- play. This file also defines four specific location classes: rooms (= indoor
-- locations), sites (= outdoor locations) dark_locations and areas.
-- Finally, the attributes `visited` and `described` are defined.

-- You may modify this file in any way that suits your purposes.

--------------------------------------------------------------------------------



--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
-- § 1. The `nowhere` Location and the Predefined Directions
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

THE nowhere ISA LOCATION
  EXIT
    north,
    south,
    east,
    west,
    northeast,
    southeast,
    northwest,
    southwest,
    up,
    down,
    'in',
    out

    TO nowhere.
END THE nowhere.


SYNONYMS
    n  = north.
    s  = south.
    e  = east.
    w  = west.
    ne = northeast.
    se = southeast.
    nw = northwest.
    sw = southwest.
    u  = up.
    d  = down.


-- Note:


-- 1) The directions defined above (and their synonyms) are not predefined nor
--    hardwired in the interpreter, so you can replace them altogether or add
--    new ones to be used alongside with them.

-- 2) When you want to remove things from play, you can
--
--      LOCATE [object] AT nowhere.
--
--    for example:
--
--    -------------------------------------------------------
--    THE piece_of_paper ISA OBJECT
--      ...
--       VERB tear
--         DOES ONLY "You tear the piece of paper to shreds."
--           LOCATE piece_of_paper AT nowhere.
--       END VERB tear.
--    END THE piece_of_paper.
--    -------------------------------------------------------


--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
-- § 2. Location classes ROOM and SITE for indoor and outdoor locations
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- ROOM and SITE are optional location classes you can use to ease up coding:
--
--  * All ROOMS have a floor, walls and a ceiling.
--  * All SITES have a ground and a sky.
--
-- Thus, you will be able to define for example
--
--    THE kitchen ISA ROOM
--
-- and it will automatically have a floor, walls and a ceiling,
--
-- or:
--
--    THE meadow ISA SITE
--
-- and the ground and the sky are automatically found in that location.
--
--
-- Of course, you're still able to define locations in the usual way:
--
--    THE kitchen ISA LOCATION
--
-- etc., but the floor, walls and ceiling won't be automatically included there.
-- The walls, floor, ceiling, ground and sky are not takeable or movable.
-- This library file also defines the sky to be distant and the ceiling to be
-- out of reach, so that they can't be touched, for example.


-- (We use ALAN's nested locations feature in the following definitions:)

THE outdoor ISA LOCATION
END THE outdoor.


THE indoor ISA LOCATION
END THE indoor.


ADD TO EVERY LOCATION
  -- ==========================================
  -- Used internally for 'room' instances only:
  -- ==========================================
  HAS floor_desc "".    --| These can set on any room for custom descriptions of
  HAS walls_desc "".    --| its walls, floor or ceiling, instead of the default
  HAS ceiling_desc "".  --| "You notice nothing unusual about the [object]."
  -- ==========================================
  -- Used internally for 'site' instances only:
  -- ==========================================
  HAS ground_desc "".   --| As above, but for descriptions of ground and sky in
  HAS sky_desc "".      --| sites instances.
END ADD TO location.


EVERY room ISA LOCATION AT indoor
END EVERY.


EVERY site ISA LOCATION AT outdoor
END EVERY.


EVERY room_object ISA OBJECT AT indoor
END EVERY.


EVERY site_object ISA OBJECT AT outdoor
END EVERY.


THE floor ISA room_object
  IS NOT takeable.
  IS NOT movable.
  CONTAINER
    -- to allow 'empty/pour/put something on floor'
  DESCRIPTION ""


  -- Honor a user-defined `floor_desc`, if present:
  VERB examine
    CHECK floor_desc OF CURRENT LOCATION = ""
      ELSE SAY floor_desc OF CURRENT LOCATION.
  END VERB examine.


  -- As we have declared the floor a container, we will disable some verbs
  -- defined to work with containers:


  VERB empty_in, pour_in
    WHEN cont
      DOES ONLY "That's not something you can $v things into."
  END VERB empty_in.


  VERB look_in
    DOES ONLY "That's not possible."
  END VERB look_in.


  VERB put_in
    WHEN cont
      DOES ONLY "That's not something you can $v things into."
  END VERB put_in.


  VERB take_from
    WHEN holder
      DOES ONLY "If you want to pick up something, just TAKE it."
  END VERB take_from.


  VERB throw_in
    WHEN cont
      DOES ONLY "That's not something you can $v things into."
  END VERB throw_in.
END THE floor.


THE wall ISA room_object
  NAME wall NAME walls
  IS NOT takeable.
  IS NOT movable.
  DESCRIPTION ""

  -- Honor a user-defined `walls_desc`, if present:
  VERB examine
    CHECK walls_desc OF CURRENT LOCATION = ""
      ELSE SAY walls_desc OF CURRENT LOCATION.
  END VERB examine.
END THE.



THE ceiling ISA room_object
  IS NOT takeable.
  IS NOT reachable.
  DESCRIPTION ""

  -- Honor a user-defined `ceiling_desc`, if present:
  VERB examine
    CHECK ceiling_desc OF CURRENT LOCATION = ""
      ELSE SAY ceiling_desc OF CURRENT LOCATION.
  END VERB examine.
END THE.



THE ground ISA site_object
  IS NOT takeable.
  IS NOT movable.
  CONTAINER
    -- to allow 'empty/pour something on ground'
  DESCRIPTION ""


  -- Honor a user-defined `ground_desc`, if present:
  VERB examine
    CHECK ground_desc OF CURRENT LOCATION = ""
      ELSE SAY ground_desc OF CURRENT LOCATION.
  END VERB examine.


  -- Since we have declared the ground to be a container,
  -- we'll disable some verbs defined to work with containers:

  VERB empty_in, pour_in
    WHEN cont
      DOES ONLY "That's not something you can $v things into."
  END VERB empty_in.


  VERB look_in
    DOES ONLY "That's not possible."
  END VERB look_in.


  VERB put_in
    WHEN cont
      DOES ONLY "That's not something you can $v things into."
  END VERB put_in.


  VERB take_from
    WHEN holder
      DOES ONLY "If you want to pick up something, just TAKE it."
  END VERB take_from.


  VERB throw_in
    WHEN cont
      DOES ONLY "That's not something you can $v things into."
  END VERB throw_in.
END THE ground.



THE sky ISA site_object
  IS NOT takeable.
  IS distant.
  DESCRIPTION ""

  -- Honor a user-defined 'sky_desc', if present:
  VERB examine
    CHECK sky_desc OF CURRENT LOCATION = ""
      ELSE SAY sky_desc OF CURRENT LOCATION.
  END VERB examine.
END THE.



-- We still declare some shared behavior for all indoor and outdoor objects:

ADD TO EVERY room_object

  VERB put_against
    WHEN bulk
      CHECK THIS = ceiling
        ELSE "That's not possible."
  END VERB put_against.

  VERB put_behind, put_near, put_under
    WHEN bulk
      DOES ONLY "That's not possible."
  END VERB put_behind.

  VERB look_behind, look_through, look_under
    DOES ONLY "That's not possible."
  END VERB look_behind.

END ADD TO.


ADD TO EVERY site_object

  VERB put_against, put_behind, put_near, put_under
    WHEN bulk
      DOES ONLY "That's not possible."
  END VERB put_against.

  VERB look_behind, look_through, look_under
    DOES ONLY "That's not possible."
  END VERB look_behind.

END ADD TO.


-- NOTE: It's often a good idea to modify the 'examine' verb for the above
--       objects. Here is an example for 'wall':

--       -----------------------------------------------------------
--       THE my_game ISA DEFINITION_BLOCK
--         ...
--         VERB examine
--           CHECK obj <> wall
--             ELSE
--               IF hero AT kitchen
--                 THEN "The walls are lined with shelves."
--                 ELSIF hero AT livingroom
--                   THEN "The wallpaper has a nice flower pattern."
--                 ELSIF...
--               END IF.
--            ...
--         END VERB examine.
--       END THE my_game.
--       -----------------------------------------------------------



--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
-- § 3. Dark Locations
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- The library offers two ways to implement dark locations:

-- 1) Setting a location to `NOT lit`.
-- 2) Using the `DARK_LOCATION` class.

-- Both approaches share the following similarities:
--  * In any type of `NOT lit` location:
--    * Verbs that require the presence of light are blocked.
--    * Instead of its description, the `dark_loc_desc` message is printed.

-- Instances of `DARK_LOCATION` will automatically become lit when there's a lit
-- `lightsource` in the location, and turn dark when there aren't any.

-- The library takes care of detecting illumination changes and correctly
-- setting and clearing the `lit` attribute of DARK_LOCATIONs, and will execute
-- a LOOK statement when the location is lit, and print the `light_goes_off`
-- message when it becomes dark.

-- For "normal" locations, management of their `lit` attribute is left entirely
-- to the author, and the library doesn't provide any special features beside
-- those mentioned above.

-- Also, "normal" locations are lit by default, whereas DARK_LOCATIONs are unlit
-- by default.

--------------------------------------------------------------------------------

ADD TO EVERY LOCATION
  IS lit.

  DESCRIPTION
    CHECK THIS IS lit
      ELSE SAY dark_loc_desc OF my_game.
END ADD TO.

-- The `lit` attribute is defined on LOCATION, and authors can use it to create
-- dark locations that are not instances of `DARK_LOCATION`, by manipulating it
-- via custom VERBs, EVENTs or RULEs. The library will not track nor manage the
-- illumination state of non-DARK_LOCATION instances, nor execute an automatic
-- LOOK when they becomes lit, or print the the `light_goes_off` message when
-- they turn dark.

-- The library will however block any verbs that require light, and show the
-- `dark_loc_desc` message instead of describing the location, if it's unlit.


EVERY dark_location ISA LOCATION
  IS NOT lit.

  -- These ENTERED statements take care of the dark location being correctly lit
  -- or not lit at entrance; the WHEN rules further down below take care of
  -- those change when the hero is already in the location.

  ENTERED

    IF COUNT ISA LIGHTSOURCE, IS lit, HERE > 0
    AND THIS IS NOT lit
      THEN MAKE THIS lit.
        IF CURRENT ACTOR <> hero
          THEN LOOK.
        END IF.
    END IF.

    IF COUNT ISA LIGHTSOURCE, IS lit, HERE = 0
      THEN MAKE THIS NOT lit.
    END IF.



  DESCRIPTION
    CHECK THIS IS lit
      ELSE SAY dark_loc_desc OF my_game.

END EVERY dark_location.


--==============================================================================
--------------------------------------------------------------------------------
-- Dark Location Rules and Events
--------------------------------------------------------------------------------
--==============================================================================

-- ------------------------------------------------------
-- Ensure a DARK_LOCATION is lit if there's light_source:
-- ------------------------------------------------------
WHEN  location OF hero ISA dark_location
  AND location OF hero IS NOT lit
  AND COUNT ISA lightsource, IS lit, AT hero > 0
THEN MAKE location OF hero lit.
  SCHEDULE light_on AT hero AFTER 0.


EVENT light_on
  LOOK.
END EVENT.


-- --------------------------------------------------------------
-- Ensure a DARK_LOCATION is unlit if there are no light_sources:
-- --------------------------------------------------------------
WHEN location OF hero ISA dark_location
  AND location OF hero IS lit
  AND COUNT ISA lightsource, IS lit, AT hero = 0
THEN MAKE location OF hero NOT lit.
  SCHEDULE light_off AT hero AFTER 0.


EVENT light_off
  SAY light_goes_off OF my_game.
END EVENT.

-- -----------------------------------------------------------
-- Ensure that a dark_locations becomes dark again after
-- the hero leaves, if he took the only light source with him:
-- -----------------------------------------------------------
-- This event is scheduled in the INITIALIZE section of the
-- `definition_block` instance ("lib_definitions.i").

EVENT check_darkness
  FOR EACH dl ISA dark_location, IS lit
  DO
    IF COUNT ISA LIGHTSOURCE, AT dl = 0
      THEN MAKE dl NOT lit.
    END IF.
  END FOR.
  SCHEDULE check_darkness AFTER 1.
END EVENT.




-- To define a dark location, use a formulation like the following:

-- ------------------------------
-- THE basement ISA dark_location
--   EXIT up TO kitchen.
--   ...
-- END THE.
-- ------------------------------


-- The description of a dark_location will automatically be:
--    "It is pitch black. -- You can't see anything at all."
-- (Edit the dark_loc_desc in 'definitions.i' to change this.)


-- If you add a description to a dark_location, this description will be shown
-- only if/when the location is lit by any means:
--
-- -----------------------------------------------------------------------
-- THE basement ISA dark_location
--   DESCRIPTION "Cobwebs and old junk are the only things you see here."
--   EXIT up TO kitchen.
-- END THE.
-- -----------------------------------------------------------------------



--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
-- § 4. The `visited` and `described` Attributes
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- A location has the value 'visited 0' until the hero visits it for the first
-- time, and the value increases on every subsequent visit. This helps when you
-- need to control if or how many times a location has been visited, and also if
-- you want the location description to be different after the first visit.

-- A location has the value 'described 0' before the first location description,
-- and the value increases every time its description is shown.

-- This distinction between the two is handy when you want the first-time
-- description of a location to be different from the subsequent ones (even if
-- the hero is still in the location for the first time).


ADD TO EVERY LOCATION
  HAS visited 0.
  HAS described 0.

  ENTERED
    IF CURRENT ACTOR = hero
      THEN
        INCREASE visited OF THIS.
        INCREASE described OF THIS.
        -- `described` is also increased by the LOOK verb (see 'lib_verbs.i').
    END IF.
END ADD TO.


-- end of file.
