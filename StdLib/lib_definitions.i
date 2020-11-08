-- lib_definitions.i           | ALAN Standard Library v2.2.0-RC | ALAN 3.0beta7
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
--   * Indefinite articles.
--   * Weight attribute presets.
--   * Scenery objects (suppressing their description).
--   * Common synonyms.
--   * The DEFINITION_BLOCK class.
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

-- We need to define the `plural` attribute on the `entity` class, because it
-- must also be usable on verb parameters, whose syntax definitions might not be
-- restricted to things only:

ADD TO EVERY ENTITY
  IS NOT plural.
END ADD TO.


-- We define general attributes for every thing (object and actor).
-- For convenience, related attributes are grouped together:

ADD TO EVERY THING

  CAN NOT talk. -- Only PERSON actors (MALE/FEMALE) can talk by default.
  IS inanimate. -- Only actors are NOT inanimate.

  NOT on.      -- Some classes can be ON/OFF (device, lightsource).
  NOT broken.  -- Some actions are prevented on broken items.
  NOT scenery. -- Sceneries are mere props (see dedicated section further down).

  NOT edible.    -- Verb `eat` only works on a edible object.
  NOT drinkable. -- Verb `drink` only works on a drinkable `liquid`.

  NOT fireable.  -- A `weapon` instance might be a firearm.

  IS examinable. -- The library declares SOUNDs as not examinable.
  HAS ex "".     -- An alternative way of providing `examine` responses,
                 -- instead of `VERB examine DOES ONLY...`

  IS movable.  -- To allow pushing, pulling, lifting, etc.
  IS takeable. -- You'll have to define which objects are NOT takeable.

    -- By default, the floor, walls, ceiling, ground and sky objects are not
    -- takeable. The same goes for all actors, doors, windows, sounds, and
    -- liquids without a vessel.

  IS reachable. -- You can talk to `not reachable` actors, but not to `distant`
  NOT distant.  -- ones. You can also throw things in, to or at `not reachable`
                -- targets but not to `distant` ones.

    -- Default response for `not reachable` things:
    --    The [thing] is out of your reach.
    -- Default response for `distant` things:
    --    The [thing] is too far away.

  HAS allowed {null_object}. -- Set of instances allowed in container.

    -- Container objects only take what is allowed for them to take;
    -- this applies to verbs empty_in, pour_in, put_in and throw_in.
    -- The `null_object` is a default dummy placeholder (ignore).

  IS open.      -- i.e. not closed.
  NOT locked.
  NOT openable. -- Can't be opened/closed.
  NOT lockable. -- Can't be locked/unlocked.
  HAS matching_key null_key. -- i.e. doesn't have an associated key, by default.

    -- All lockable doors need a matching key to lock/unlock them.
    -- This attribute is being added to every thing, instead of just to doors,
    -- to enable matching keys to be implemented on other lockable objects too,
    -- e.g. a treasure chests, a detonator key switch, etc.
    -- The `null_key` is a default dummy placeholder (ignore).

  NOT readable.  -- Anything can be made readable and writable.
  NOT writeable. -- The `write` verbs only works on `writable` things.
  HAS text "".   -- Holds the readable text; null by default.

  NOT wearable. -- Only `clothing` instances are wearable, by default.
  NOT worn.     -- (for `clothing` instances) it's not worn by any actor.
    -- ------------------------------------------------------------------------
    -- NOTE: Authors can also use this attribute to implement wearables other
    --       than clothing (e.g. devices, like headphones, a VR headset, etc.).
    --       The library ensures that any verbs which could remove a thing from
    --       an actor also set the thing as `NOT worn`, in case authors are
    --       using this attribute outside of the `clothing` class context.
    -- ------------------------------------------------------------------------

--==============================================================================
--------------------------------------------------------------------------------
  INDEFINITE ARTICLE
--------------------------------------------------------------------------------
--==============================================================================

-- The default indefinite article for singular nouns is "a"; plural nouns will
-- be preceded by "some".

-- E.g. "There is bottle." and "There are some coins.".

    IF THIS IS NOT plural
      THEN "a"
      ELSE "some"
    END IF.

END ADD TO THING.

-- If you need to use "an", for a singular noun, instead of "a", you'll need to
-- declare it directly on the instance. E.g.:

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~
-- The owl IsA actor at woods
--   Indefinite article "an"
-- End the.
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~

-- Likewise, if you need a different word instead of "some", you'll have to
-- provide a custom definition on the instance. E.g.:

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- The scissors IsA object in desk_drawer
--   Indefinite article "a pair of"
-- End the.
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- in order to produce:

--    The desk drawer contains a pair of scissors.

--==============================================================================
--------------------------------------------------------------------------------
-- Weight Presets
--------------------------------------------------------------------------------
--==============================================================================

-- Some default weight settings for things, used by the library to check if
-- something is movable.

-- The library-defined threshold is 50: the verbs `take`, `take_from` and `lift`
-- will not work on objects heavier than 49.

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
--                        S C E N E R Y   O B J E C T S
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- Any object can be turned into a scenery prop via the `IS scenery` attribute
-- (previously defined in this module).

-- Sceneries are mainly used to implement those objects which are mentioned in
-- hand-crafted descriptions of rooms or other objects, for the sake of realism,
-- or to provide atmosphere, and have a mere scenic purpose. Therefore, scenery
-- objects don't need a description of their own.

-- The description of scenery objects is suppressed by default:

ADD TO EVERY OBJECT
  DESCRIPTION
    CHECK THIS IS NOT scenery
      ELSE SAY "".
END ADD.

-- For example, a room description might mention the presence of cobwebs and
-- other ornamental details whose sole purpose is to add to the room's mood and
-- atmosphere. Since the player might try to examine these objects, the author
-- needs to implement them, to prevent a parser response like:

-- For example, a room description might mention the presence of cobwebs, for
-- the sole purpose of creating a spooky atmosphere. Since the player might try
-- to examine the cobwebs, the author needs to implement them, to prevent parser
-- responses like:

--    I don't know the word 'cobwebs'.

-- which would be inconsistent with the room description, and thus break up the
-- narrative illusion of a coherent world, reminding the player that it's just
-- a software simulation.

-- The default `examine` response for scenery objects will be:

--    The [object] is not important.

-- unless the author provided a custom description in its `ex` attribute, which
-- will always be honored by the library. Custom descriptions of sceneries can
-- be used to further contribute to the room's mood and atmosphere.

-- Furthermore, all actions are prevented on sceneries, producing the above
-- mentioned message as a result. This way, the player will immediately realize
-- that it's just a scenic prop, and won't be misled into attempting further
-- actions on the object (e.g. thinking that he/she's dealing with a 'find the
-- verb' situation). Every library verb either contains a CHECK blocking the
-- action on objects that are `scenery`, or an IF statement in the DOES part to
-- alter its outcome accordingly.

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--             D U M M Y   L I B R A R Y   P L A C E H O L D E R S
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- Some dummy placeholder objects used as null defaults in various definitions:

THE null_object ISA OBJECT
END THE.


THE null_key ISA OBJECT
END THE.

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

-- Here we define the `definition_block`, a special singleton class which every
-- adventure must instantiate as the `my_game` meta-instance. The library needs
-- the `my_game` instance because it's specifically referenced by the library
-- code for various purposes:

--   * Library messages attributes (defined in 'lib_messages_library.i').
--   * Actions restrictions attributes (defined in 'lib_verbs_restrictions.i').
--   * Attributes for library settings, game info, and temporary variables.

-- The `definition_block` class is further extended by other library modules,
-- which add more attributes, required for other features. In order to keep the
-- various library features in independent modules, the definition of this class
-- was spread across different source files.

-- Authors are able to override on `my_game` the library defaults defined on the
-- `definition_block`. Furthermore, the `my_game` is a location that, during
-- initialization, becomes the nesting location of every other game location
-- (see INITIALIZE, below), which allows authors to override library verbs with
-- any VERB defined on `my_game`, since it will always be in scope.

-- There should only be a single `definition_block` instance in an adventure,
-- and it must be named `my_game`. Without the `my_game` instance, the adventure
-- won't compile. Multiple `definition_block` instances could compromise the
-- code integrity of an adventure, because the `definition_block` initialization
-- is designed to target the `my_game` instance specifically.

--------------------------------------------------------------------------------

-- An attribute for keeping track of nested locations during initialization;
-- used internally by the library (ignore).

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
      -- Records previous score so `checkscore` event
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
  -- store values of attributes which need to be changed and then restored.

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
