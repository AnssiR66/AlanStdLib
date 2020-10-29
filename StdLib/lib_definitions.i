-- lib_definitions.i          | ALAN Standard Library v2.2.0-WIP | ALAN 3.0beta7
--+============================================================================+
--|\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////////|
--++--------------------------------------------------------------------------++
--||                                                                          ||
--||                     C O R E   D E F I N I T I O N S                      ||
--||                                                                          ||
--++--------------------------------------------------------------------------++
--|//////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\|
--+============================================================================+

-- This library module defines:
--
--   * General attributes.
--   * Some article declarations.
--   * Common synonyms.
--   * The definition_block class.
--   * Attributes for the start section.
--   * The banner instance (for the start section).

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                     G E N E R A L   A T T R I B U T E S
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- We define general attributes for every thing (object and actor):


-- tag::default-attributes-thing[]
ADD TO EVERY THING

  IS examinable.  -- The library declares SOUNDs as not examinable.
     inanimate.   -- Actors are NOT inanimate.
     movable.     -- To allow pushing, pulling, lifting, etc.
     open.        -- = not closed.
     reachable.   -- See also `distant` below
     takeable.    -- You'll have to define which objects are NOT takeable.
                  -- By default, the floor, walls, ceiling, ground and sky
                  -- objects are not takeable. The same goes for all doors,
                  -- windows, sounds, liquids without a vessel, and actors.

  HAS allowed {null_object}.
    -- Container objects only take what is allowed for them to take;
    -- this applies to verbs empty_in, pour_in, put_in and throw_in.
    -- `null_object` is a default dummy-object that can be ignored.

  HAS ex "".  -- An alternative way of providing responses to ">x [thing]",
              -- instead of `VERB examine DOES ONLY...`
              -- See the library manual for more info.

  HAS matching_key null_key.
    -- All lockable doors need a matching key to lock/unlock them.
    -- This attribute is being added to every thing, instead of just to doors,
    -- to enable matching keys to be implemented on other lockable objects too,
    -- e.g. for treasure chests, etc.
    -- `null_key` is a default dummy-object that can be ignored.

  HAS text "".

  NOT broken.
  NOT distant.
    -- Usage: you can talk to `not reachable` actors, but not to `distant` ones.
    -- You can also throw things in, to or at `not reachable` targets but not to
    -- `distant` ones.
    -- Default response for `not reachable` things:
    --    The [thing] is out of your reach.
    -- Default response for `distant` things:
    --    The [thing] is too far away.

  NOT drinkable.
  NOT edible.
  NOT fireable. -- Can (not) be used as a firearm.
  NOT lockable.
  NOT locked.
  NOT on.
  NOT openable.
  NOT readable.
  NOT scenery.  -- A scenery has special responses for 'examine' and 'take',
                -- behaves like a normal object otherwise.
  NOT wearable.
  NOT writeable.

  CAN NOT talk.

  IS NOT worn.  -- (for `clothing` instances) it's not worn by any actor.
    -- -------------------------------------------------------------------------
    -- NOTE: Authors can also use this attribute to implement wearables other
    --       than clothing (eg. devices, like headphones, a VR headset, etc.).
    --       The library ensures that any verbs which could remove a thing from
    --       an actor also set the thing as `NOT worn`, in case authors are
    --       using this attribute outside of the `clothing` class context.
    -- -------------------------------------------------------------------------
-- end::default-attributes-thing[]

  INDEFINITE ARTICLE

    -- Plural nouns must be preceded by "some" (and not by "a" or "an"):

    IF THIS IS NOT plural
      THEN "a"
      ELSE "some"
    END IF.

END ADD TO THING.


-- NOTE: If you need to use "an" instead, you should declare it directly on the
--       instance, e.g.:
--
--       ~~~~~~~~~~~~~~~~~~~~~~~~~~
--       THE owl ISA ACTOR AT woods
--         INDEFINITE ARTICLE "an"
--       END THE.
--       ~~~~~~~~~~~~~~~~~~~~~~~~~~


-- We add the 'plural' attribute to the 'entity' class, because it doesn't apply
-- just to things but also (e.g.) to parameters in syntax statements; ignore.

ADD TO EVERY ENTITY
  IS NOT plural.
END ADD TO.



-- Some null defaults defined that have been mentioned above:


THE null_object ISA OBJECT
END THE.


THE null_key ISA OBJECT
END THE.


--==============================================================================
--------------------------------------------------------------------------------
-- Preset Weight Values
--------------------------------------------------------------------------------
--==============================================================================

-- Some default weight settings for things, mostly used to check if something is
-- movable.


ADD TO EVERY THING
  HAS weight 0.
END ADD TO THING.


ADD TO EVERY ACTOR
  HAS weight 50.
END ADD TO ACTOR.


ADD TO EVERY OBJECT
  HAS weight 5.
END ADD TO OBJECT.

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                        C O M M O N   S Y N O N Y M S
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- Next, we declare synonyms for some common words so that it will be possible
-- for the player to type both "put ball in box" and "put ball into box", etc.

SYNONYMS
  into, inside = 'in'.
  onto = on.
  thru = through.
  using = 'with'.

  -- Some synonyms for the player character:

  me, myself, yourself, self = hero.


--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--           T H E   M Y _ G A M E   D E F I N I T I O N   B L O C K
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- @TODO: Add intro text.

-- Here we create the "definition_block" class, to group various definitions.
-- In the game source file, the author should declare an instance 'my_game'
-- which belongs to this class.

--------------------------------------------------------------------------------


-- An attribute for keeping track of nested locations;
-- used internally in the library (ignore).

ADD TO EVERY LOCATION
  HAS nested {nowhere}.
END ADD TO.


--==============================================================================
--------------------------------------------------------------------------------
-- my_game Attributes
--------------------------------------------------------------------------------
--==============================================================================


EVERY definition_block ISA LOCATION

  -- These three attributes, as well as the SCHEDULE statement following them,
  -- are needed for the 'notify' command ('lib_verbs.i'); ignore.

  HAS oldscore 0.
      -- Records previous score so 'checkscore' event
      -- can compare with the current score
  IS notify_turned_on.
      -- Set by 'notify' verb, records whether
      -- player wants to see score messages or not.
  IS NOT seen_notify.
      -- Records whether player has seen the notify verb
      -- instructions yet.

  -- --------------------
  -- Temporary Attributes
  -- --------------------
  -- The following attributes are used internally by the Library to temporarily
  -- store values of attributes which need to be changed and then restored; ignore.
  HAS temp_compliant.


--==============================================================================
--------------------------------------------------------------------------------
-- my_game Initialization
--------------------------------------------------------------------------------
--==============================================================================

  INITIALIZE
    SCHEDULE check_score AFTER 0.
    SCHEDULE check_restriction AFTER 0.
    SCHEDULE check_darkness AFTER 0.

  -- ===========================================================================
  -- Nest Every Location into my_game
  -- ===========================================================================

  -- The following code ensures that every location in the adventure (except for
  -- `my_game` itself and the special `nowhere` location) will become nested
  -- into the `my_game` location.

  -- Thanks to this, any verb defined on `my_game` will be globally available,
  -- which is what makes it possible to override a predefined library verb by
  -- re-defining it on the `my_game` instance --- since `my_game` is always the
  -- outermost nester of any location, all verbs defined on it will always be in
  -- scope, anywhere.


    FOR EACH l ISA LOCATION
      DO
        EXCLUDE nowhere FROM nested OF l.
        IF COUNT ISA LOCATION, AT l > 0
          THEN
            FOR EACH x ISA LOCATION, AT l
              DO
                INCLUDE x IN nested OF l.
            END FOR.
        END IF.
    END FOR.

    FOR EACH l ISA LOCATION
      DO
        IF l <> my_game AND l <> nowhere
          THEN LOCATE l AT my_game.
        END IF.
    END FOR.

    FOR EACH r1 ISA ROOM
      DO
        LOCATE r1 AT indoor.
    END FOR.

    FOR EACH s1 ISA SITE
      DO
        LOCATE s1 AT outdoor.
    END FOR.

    FOR EACH l ISA LOCATION
      DO
        IF nested OF l <> {} AND l <> my_game AND l <> nowhere
        THEN
          FOR EACH x ISA LOCATION, IN nested OF l
            DO
              IF l <> my_game AND x <> my_game
                THEN LOCATE x AT l.
              END IF.
          END FOR.
        END IF.
    END FOR.

  -- ===========================================================================
  -- Start Location `visited` and `described`
  -- ===========================================================================

  -- We ensure that the `visited` and `described` attributes of the starting
  -- location are correct at the start of the game:

  SET visited OF location OF hero TO 1.
  SET described OF location OF hero TO 1.

END EVERY definition_block.

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--                        T H E   G A M E   B A N N E R
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- The Game Banner is an optional library feature for printing information about
-- the adventure when the game starts. To enable the Banner, you need to add the
-- `DESCRIBE banner` statement after the `START AT [location]` statement, e.g.:

--    START AT initial_location.
--    DESCRIBE banner.

-- The information shown in the Banner is controlled via specific attributes
-- defined on `definition_block`, which authors can override directly inside the
-- mandatory `my_game` instance declaration. E.g.:

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- The my_game IsA definition_block
--   Has
--     title    "Beyond the Aleph".
--     subtitle "A kabbalistic adventure.".
--     author   "Isaac Luria Ha'ARI".
--     year     1560.
--     version  "1".
--     AlanV    "v3.0 beta7".
-- End the.
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- will produce the following Banner:

--     Beyond the Aleph
--     A kabbalistic adventure.
--     Version 1.
--     (C) 1560 by Isaac Luria Ha'ARI.
--     Programmed with the ALAN Interactive Fiction Language v3.0 beta7.
--     Standard Library v2.2.0.
--     All rights reserved.

-- Omitted attributes will fall back on their default values, defined by the
-- library. Attributes with null values (empty string or 0, depending on the
-- type) will suppress their related entry from the Banner altogether.

--==============================================================================
--------------------------------------------------------------------------------
-- Banner Presets
--------------------------------------------------------------------------------
--==============================================================================

-- These are the predefined values for the Game Banner attributes:

ADD TO EVERY definition_block
  HAS    title  "My New Game".
  HAS subtitle  "".
  HAS  version  "1".
  HAS     year  2020.
  HAS   author  "An ALAN Author".
  HAS    AlanV  "v3.0 beta7".
END ADD TO definition_block.

-- The predefined value of `AlanV` is that of the latest Alan release at the
-- time the library was last updated. Authors are free to override this with a
-- more recent Alan version (or a different one, e.g. a developer snapshot)
-- without having to modify the library sources.

--==============================================================================
--------------------------------------------------------------------------------
-- Banner Definition
--------------------------------------------------------------------------------
--==============================================================================

THE banner ISA LOCATION

  DESCRIPTION

    -- Adventure Title:
    IF my_game:title <> ""
      THEN "$p" STYLE alert. SAY my_game:title. STYLE normal.
    END IF.

    -- Adventure Subtitle:
    IF my_game:subtitle <> ""
      THEN "$n" SAY my_game:subtitle.
    END IF.

    -- Game Version:
    IF my_game:version <> "0"
      THEN "$nVersion" SAY my_game:version. "."
    END IF.

    -- Year and Author:
    "$n(C)"
    IF my_game:year <> 0
      THEN SAY my_game:year.
    END IF.
    IF my_game:author <> ""
      THEN "by" SAY my_game:author.
    END IF. "."

    -- ALAN Info:
    "$nProgrammed with the ALAN Interactive Fiction Language"
    IF my_game:AlanV <> ""
      THEN SAY my_game:AlanV.
    END IF. "."

    -- StdLib Info:
    "$nStandard Library v2.2.0."


    "$nAll rights reserved."

END THE banner.


-- end of file.
