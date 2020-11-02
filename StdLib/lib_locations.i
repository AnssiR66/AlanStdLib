-- lib_locations.i            | ALAN Standard Library v2.2.0-WIP | ALAN 3.0beta7
--+============================================================================+
--|\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////////|
--++--------------------------------------------------------------------------++
--||                                                                          ||
--||                            L O C A T I O N S                             ||
--||                                                                          ||
--++--------------------------------------------------------------------------++
--|//////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\|
--+============================================================================+

-- This library module defines the standard directions (exits) and the `nowhere`
-- location, a useful place to locate things that you want to remove from the
-- game stage.
--
-- It also defines some specialized location subclasses:
--
--   * ROOM -- an indoor location.
--   * SITE -- an outdoor location.
--   * DARK_LOCATION -- requiring light sources to be lit.
--   * DARK_ROOM -- an indoor dark_location.
--   * DARK_SITE -- an outdoor dark_location.
--
-- Finally, it defines the `visited` and `described` attributes, which keep
-- track of how many times each location has been visited by the hero and
-- described to him.
--
-- You can easily modify this file to adapt it to your own needs.

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                            T H E   N O W H E R E
--
--                A N D   S T A N D A R D   D I R E C T I O N S
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- The `nowhere` location servers a dual purpose:

--   1) Provide authors with a place where they can locate things that need to
--      be removed from the game stage.
--   2) Define all the standard directions for traversing EXITs.

-- The ALAN language doesn't provide any predefined directions; it's the job of
-- the compiler to build a list of all the available directions, by analyzing
-- the EXIT declarations in the adventure's source code. By declaring all the
-- default directions on the `nowhere` location, the library ensures that these
-- will be available in every adventure, no matter how small --- i.e. even if
-- the adventure doesn't contain any location connected by a given direction
-- (e.g. north), that direction will still be understood by the parser, since
-- it's defined at least on the `nowhere` location.

--------------------------------------------------------------------------------

-- Since the `nowhere` location will never be visited by the hero, it's safe to
-- define all the default directions on a single EXIT, leading to the `nowhere`
-- location itself. This EXIT serves the sole purpose of informing the compiler
-- on all the available directions, and it's not intended to be really traversed
-- by the hero.

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

--------------------------------------------------------------------------------
-- Usage Notes and Tips
--------------------------------------------------------------------------------

-- 1) The directions defined above (and their synonyms) are not predefined nor
--    hardwired in the interpreter, so you can replace them altogether or add
--    new ones to be used alongside with them.

-- 2) When you want to remove things from play, you can
--
--      LOCATE [object] AT nowhere.
--
--    for example:
--
--    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--    The pamphlet IsA object
--       Verb tear
--         Does only
--           "You tear the pamphlet to shreds."
--           Locate pamphlet at nowhere.
--       End verb.
--    End the.
--    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                           R O O M   &   S I T E
--
--                       I N D O O R   &   O U T D O O R
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- ROOM and SITE are optional location subclasses to quickly implement indoor
-- and outdoor locations:

--  * All ROOMS have a floor, walls and a ceiling.
--  * All SITES have a ground and a sky.

-- This enables you to define for example:

--    The kitchen IsA ROOM

-- and it will automatically have a floor, walls and a ceiling,

-- or:

--    The meadow IsA SITE

-- and the ground and the sky are automatically present in that location.

-- Of course, you're still able to define locations in the usual way:

--    The kitchen IsA LOCATION

-- etc., but the floor, walls and ceiling won't be automatically included there.

-- The library also sets some attributes on the various ROOM- and SITE-objects:

--   * The walls, floor, ceiling, ground and sky object are `NOT takeable` and
--     `NOT movable`.
--   * The sky is `distant` and the ceiling is `NOT reachable`, to prevent the
--     hero from touching them or manipulating them in other ways.

--------------------------------------------------------------------------------

-- We'll exploit nested locations in various classes definitions, in order to
-- ensure that their instances will be automatically located at indoor/outdoor.

THE outdoor ISA LOCATION
END THE outdoor.


THE indoor ISA LOCATION
END THE indoor.

EVERY room ISA LOCATION AT indoor
END EVERY.


EVERY site ISA LOCATION AT outdoor
END EVERY.

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                    R O O M   &   S I T E   O B J E C T S
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- The library adopts a smart trick to implement ROOM- and SITE-objects: there's
-- only a single instance of each ROOM- and SITE-object, located at the `indoor`
-- or `outdoor`, respectively. Since every ROOM is nested inside `indoor`, and
-- every SITE is nested inside `outdoor`, their respective objects will always
-- be in scope. Every ROOM shares the same `ceiling` instance; every SITE shares
-- the same `sky` instance; and so on with every other ROOM- and SITE-object.

-- In order to allow authors to override the default description of ROOM- and
-- SITE-objects, the attributes for their custom description are not defined on
-- the ROOM- and SITE-objects themselves, but on EVERY location instead.

-- The library then redefines the `examine` verb on every ROOM- and SITE-object,
-- so that when the hero examines it, its associated description attribute on
-- the CURRENT LOCATION will be printed, unless it's an empty string, in which
-- case the default description will be printed.

--==============================================================================
--------------------------------------------------------------------------------
--                           R O O M   O B J E C T S
--------------------------------------------------------------------------------
--==============================================================================

-- Every ROOM and DARK_ROOM instance has a floor, walls and a ceiling.

EVERY room_object ISA OBJECT AT indoor
END EVERY.

--------------------------------------------------------------------------------
-- Customizing Room Objects' Description
--------------------------------------------------------------------------------

-- Each ROOM-object has a dedicated string attribute (on the CURRENT LOCATION)
-- which can be used to override the default description displayed by `examine`
-- ("You notice nothing unusual about the [object].").

-- These attributes are similar to the `ex` attribute, except that they have
-- unique identifiers to associate them to their specific ROOM-object
-- counterparts.

ADD TO EVERY location
  HAS floor_desc "".
  HAS walls_desc "".
  HAS ceiling_desc "".
END ADD TO location.

--------------------------------------------------------------------------------
-- Verbs Disabled on All ROOM-Objects
--------------------------------------------------------------------------------

-- The following actions must be prevented on every room object: look_behind,
-- look_through, look_under, put_against, put_behind, put_near, put_under.

-- The only exception is when `put_against` is used on `wall`, which is not
-- blocked by the verb checks, to allow actions like 'put ladder against wall'.

ADD TO EVERY room_object

  VERB put_against
    WHEN bulk
      CHECK THIS <> ceiling
      AND   THIS <> floor
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

--==============================================================================
-- FLOOR
--==============================================================================

THE floor ISA room_object
  IS NOT takeable.
  IS NOT movable.
  CONTAINER -- To allow 'empty/pour/put something on floor'.
  DESCRIPTION ""


  VERB examine
    -- Honor a user-defined `floor_desc`, if present:
    CHECK floor_desc OF CURRENT LOCATION = ""
      ELSE SAY floor_desc OF CURRENT LOCATION.
  END VERB examine.

  -- ----------------------------------
  -- Disable Container Actions on Floor
  -- ----------------------------------
  -- Since we've declared the floor a container, we need to disable
  -- some verbs that are designed to work with containers:

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

--==============================================================================
-- WALLS
--==============================================================================

THE wall ISA room_object
  NAME wall NAME walls
  IS NOT takeable.
  IS NOT movable.
  DESCRIPTION ""

  VERB examine
    -- Honor a user-defined `walls_desc`, if present:
    CHECK walls_desc OF CURRENT LOCATION = ""
      ELSE SAY walls_desc OF CURRENT LOCATION.
  END VERB examine.
END THE.

--==============================================================================
-- CEILING
--==============================================================================

THE ceiling ISA room_object
  IS NOT takeable.
  IS NOT reachable.
  DESCRIPTION ""

  VERB examine
    -- Honor a user-defined `ceiling_desc`, if present:
    CHECK ceiling_desc OF CURRENT LOCATION = ""
      ELSE SAY ceiling_desc OF CURRENT LOCATION.
  END VERB examine.
END THE.

--==============================================================================
--------------------------------------------------------------------------------
--                           S I T E   O B J E C T S
--------------------------------------------------------------------------------
--==============================================================================

-- Every SITE and DARK_SITE instance has a ground and sky.

EVERY site_object ISA OBJECT AT outdoor
END EVERY.

-- Each SITE-object has a dedicated string attribute (on the CURRENT LOCATION)
-- which can be used to override the default description displayed by `examine`
-- ("You notice nothing unusual about the [object].").

-- These attributes are similar to the `ex` attribute, except that they have
-- unique identifiers to associate them to their specific SITE-object
-- counterparts.

ADD TO EVERY location
  HAS ground_desc "".
  HAS sky_desc "".
END ADD TO location.

--------------------------------------------------------------------------------
-- Verbs Disabled on All SITE-Objects
--------------------------------------------------------------------------------

-- The following actions must be prevented on every site object: look_behind,
-- look_through, look_under, put_against, put_behind, put_near, put_under.

ADD TO EVERY site_object

  VERB put_against, put_behind, put_near, put_under
    WHEN bulk
      DOES ONLY "That's not possible."
  END VERB put_against.

  VERB look_behind, look_through, look_under
    DOES ONLY "That's not possible."
  END VERB look_behind.

END ADD TO.

--==============================================================================
-- GROUND
--==============================================================================

THE ground ISA site_object
  IS NOT takeable.
  IS NOT movable.
  CONTAINER -- To allow 'empty/pour something on ground'.
  DESCRIPTION ""


  VERB examine
    -- Honor a user-defined `ground_desc`, if present:
    CHECK ground_desc OF CURRENT LOCATION = ""
      ELSE SAY ground_desc OF CURRENT LOCATION.
  END VERB examine.

  -- -----------------------------------
  -- Disable Container Actions on Ground
  -- -----------------------------------
  -- Since we've declared the ground a container, we need to disable
  -- some verbs that are designed to work with containers:

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

--==============================================================================
-- SKY
--==============================================================================

THE sky ISA site_object
  IS NOT takeable.
  IS distant.
  DESCRIPTION ""

  VERB examine
    -- Honor a user-defined 'sky_desc', if present:
    CHECK sky_desc OF CURRENT LOCATION = ""
      ELSE SAY sky_desc OF CURRENT LOCATION.
  END VERB examine.
END THE.

--==============================================================================
--------------------------------------------------------------------------------
-- ROOM and SITE-Objects Tips & Tricks
--------------------------------------------------------------------------------
--==============================================================================

-- Sometimes it might be better or necessary to override the `examine` verb for
-- specific ROOM- and SITE-objects --- e.g. to keep all descriptions in the same
-- code block, for practical reasons; or because examining a ROOM/SITE-object
-- should execute some complex code that goes beyond just printing a description
-- message. Here is an example of how this could be done for the `wall` object:

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- The my_game IsA DEFINITION_BLOCK
--   ...
--   VErb examine
--     Check obj <> wall
--       Else
--         If hero at kitchen
--           Then "The walls are lined with shelves."
--           ElsIf hero AT living_room
--             Then "The wallpaper has a nice flower pattern."
--           ElsIf...
--         End if.
--     ...
--   End verb examine.
-- End the my_game.
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                         D A R K   L O C A T I O N S
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
-- `lightsource` in the location, and turn dark when there aren't any, except
-- when their `forced_lit` attribute is enabled, in which case they will behave
-- like normal lit locations (the `forced_lit` attribute was introduced to
-- support day and night cycles in DARK_LOCATIONs).

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

  IS NOT forced_lit. -- (used for DARK_LOCATION)

    -- Since the library enforces darkness and illumination on `dark_location`
    -- instances, the `forced_lit` attribute is useful when a `dark_location` is
    -- subject to day an night cycle, to ensure that it won't become dark during
    -- the day. E.g. a forest should always be lit during the day, and dark at
    -- night if there are no lit light sources present.
    -- When a location `IS forced_lit`, the library will not make it dark, so an
    -- author can set this attribute during the day and unset it at night.

    -- Of course, authors could also exploit this attribute in custom defined
    -- verbs acting on normal locations, if needed.

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
--                  D A R K _ R O O M   &   D A R K _ S I T E
--------------------------------------------------------------------------------
--==============================================================================

-- The `DARK_ROOM` and `DARK_SITE` classes are the dark locations' equivalents
-- of the `ROOM` and `SITE` classes. Like their counterparts, all dark room
-- instances will automatically have a floor, ceiling and walls; and dark sites
-- will have a ground and sky.

EVERY dark_room ISA dark_location AT indoor.
END EVERY.

EVERY dark_site ISA dark_location AT outdoor.
END EVERY.

--==============================================================================
--------------------------------------------------------------------------------
--       D A R K   L O C A T I O N S '   R U L E S   A N D   E V E N T S
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
  AND location OF hero IS NOT forced_lit
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
  FOR EACH dl ISA dark_location, IS lit, IS NOT forced_lit
  DO
    IF COUNT ISA LIGHTSOURCE, AT dl = 0
      THEN MAKE dl NOT lit.
    END IF.
  END FOR.
  SCHEDULE check_darkness AFTER 1.
END EVENT.


--==============================================================================
--------------------------------------------------------------------------------
-- Dark Locations' How To
--------------------------------------------------------------------------------
--==============================================================================

-- To create a dark location, just define it as an instance of `DARK_LOCATION`,
-- `DARK_ROOM` or `DARK_SITE`, according to need. Example:

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~
-- The basement IsA dark_room
--   Exit up to kitchen.
--   ...
-- End the.
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~


-- Any unlit dark location will automatically be described as:
--
--    It is pitch black. You can't see anything at all.
--
-- To modify this default message, edit the `dark_loc_desc` attribute in your
-- adventure source code according to need, e.g.:
--
--    Set dark_loc_desc of my_game to "Total darkness.".


-- If you add a description to a dark location, this description will be shown
-- only if/when the location is lit by any means:
--
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- The basement IsA dark_room
--   Description
--     "You can only see Cobwebs and junk here."
--   Exit up to kitchen.
-- End the.
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                    V I S I T E D   &   D E S C R I B E D
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- A location has the value 'visited 0' until the hero visits it for the first
-- time, then the value increases on every subsequent visit. This helps when you
-- need to control if or how many times a location was visited, and if you want
-- the location description to change after the first visit, or after any number
-- of visits.

-- A location has the value 'described 0' before the first location description,
-- then the value increases every time its description is shown.

-- This distinction between the two is handy when you want the first-time
-- description of a location to be different from its subsequent ones (even if
-- the hero is still in the location for the first time).

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- WARNING: The `described` attribute will be increased at each description of
--          the location, regardless of whether the actual description was shown
--          or prevented due to the location being unlit. Therefore, authors are
--          advised to be cautious in their reliance on the `described` counter
--          for locations that can become dark during the game.

--          We're planning to enforce a more consistent behavior of this feature
--          in relation to dark locations, in future editions of the library.
--          For more info, see Issue #100 on the StdLib repository.
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
