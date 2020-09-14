-- ALAN Standard Library v2.2.0-WIP | ALAN 3.0beta7
-- Definitions (file name: 'lib_definitions.i')
--------------------------------------------------------------------------------

-- Included in this file:
  -- general attributes
  -- some article declarations
  -- common synonyms
  -- the definition_block class
    -- attributes for the start section
  -- the banner instance (for the start section)

--------------------------------------------------------------------------------


-- ==================
-- General attributes
-- ==================

-- We define general attributes for every thing ( = object or actor):


ADD TO EVERY THING

  IS examinable.
    -- the library declares SOUNDs as not examinable.
     inanimate.
    -- actors are NOT inanimate.
     movable.
    -- to allow pushing, pulling, lifting, etc.
     open.
    -- = not closed.
     reachable.
    -- See also 'distant' below
     takeable.
    -- you'll have to separately define which objects are NOT takeable.
    -- By default, the floor, walls, ceiling, ground and sky objects
    -- are not takeable. The same goes for all doors, windows, sounds, liquids
    -- that are not in containers, and actors.

  HAS allowed {null_object}.
    -- container objects only take what is allowed for them to take;
    -- this applies to verbs empty_in, pour_in, put_in and throw_in.
    -- "null_object" is a default dummy that can be ignored.

  HAS ex "".            -- an alternative way of giving responses to >x [thing],
          -- instead of 'VERB examine DOES ONLY..."
          -- See the library manual for more info.

  HAS matching_key null_key.
    -- All lockable doors need a matching key to lock/unlock them.
    -- "null_key" is a default dummy that can be ignored. This attribute
    -- is here added to every thing instead of just doors, to enable
    -- matching keys to be programmed for other locked objects, too, like for
    -- example treasure chests etc.

  HAS text "".

  NOT broken.
  NOT distant.
    -- Usage: you can for example talk to a "not reachable" actor but not to a "distant" one.
    -- You can also throw things in, to or at a not reachable target but not to a distant one.
    -- Default response for not reachable things: "The [thing] is out of your reach."
    -- Default response for distant things: "The [thing] is too far away."
  NOT drinkable.
  NOT edible.
  NOT fireable.
    -- can (not) be used as a firearm
  NOT lockable.
  NOT locked.
  NOT 'on'.
  NOT openable.
  NOT readable.
  NOT scenery.
    -- scenery has special responses for 'examine' and 'take', behaves like a normal object otherwise.
  NOT wearable.
  NOT writeable.

  CAN NOT talk.

  IS NOT worn.
    -- (for 'clothing' instances) it's not worn by any actor.
    -- -------------------------------------------------------------------------
    -- NOTE: Authors can also use this attribute to implement wearables other
    --       than clothing (eg. devices, like headphones, a VR headset, etc.).
    --       The library ensures that any verbs which could remove a thing from
    --       an actor also set the thing as 'NOT worn', in case authors are
    --       using this attribute outside of the 'clothing' class context.
    -- -------------------------------------------------------------------------

-- We still define that plural nouns are preceded by "some" (and not by "a" or "an"):

INDEFINITE ARTICLE

  IF THIS IS NOT plural
    THEN "a"
    ELSE "some"
  END IF.

END ADD TO.


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



-- Some weight attributes for things:


ADD TO EVERY THING
  HAS weight 0.
END ADD TO THING.


ADD TO EVERY ACTOR
  HAS weight 50.
END ADD TO ACTOR.


ADD TO EVERY OBJECT
  HAS weight 5.
END ADD TO OBJECT.


-- These attributes are mostly used to check if something is movable.



-- An attribute for keeping track of nested locations;
-- used internally in the library (ignore).

ADD TO EVERY LOCATION
  HAS nested {nowhere}.
END ADD TO.




-- Common synonyms
-- ===============


-- Next, we declare synonyms for some common words so that it will be possible
-- for the player to type commands such as both "put ball in box" and
-- "put ball into box", etc:


SYNONYMS

  into, inside = 'in'.
  onto = on.
  thru = through.
  using = 'with'.

  -- Here are some synonyms for the player character:

  me, myself, yourself, self = hero.




-- Attributes for the my_game definition block
-- ===========================================

-- Here we create the "definition_block" class, to group various definitions.
-- In the game source file, the author should declare an instance 'my_game'
-- which belongs to this class.



EVERY definition_block ISA LOCATION

  -- attributes for the start section (banner):
  -- ==========================================

  -- These will be shown at the start of the game if you add
  --    DESCRIBE banner.
  -- after START AT [location].

  HAS    title  "My New Game".
  HAS subtitle  "".
  HAS   author  "An ALAN Author".
  HAS     year  2020.
  HAS  version  "1".
  HAS    AlanV  "v3.0 beta7".

  -- The predefined AlanV value is that of the latest Alan release at the time
  -- the library was last updated. Authors are free to override this with a more
  -- recent Alan version (or a different one, e.g. a developer snapshot) without
  -- having to modify the library sources.

  -- ===========================================================================

  -- These three attributes, as well as the 'schedule' statement following them,
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


  INITIALIZE
    SCHEDULE check_score AFTER 0.
    SCHEDULE check_restriction AFTER 0.

  -- ===========================================================================


  -- The my_game instance defined as a meta-location (ignore):

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



-- We ensure that the 'visited' and 'described' attributes of the starting location
-- are correct at the start of the game:

    SET visited OF location OF hero TO 1.
    SET described OF location OF hero TO 1.

END EVERY definition_block.


-- ===========
-- The Banner:
-- ===========

THE banner ISA LOCATION

  DESCRIPTION

    "$p" STYLE alert. SAY title OF my_game. STYLE normal.

    IF subtitle OF my_game <> ""
      THEN "$n" SAY subtitle OF my_game.
    END IF.

    "$n(C)" SAY year OF my_game. "by" SAY author OF my_game.

    "$nProgrammed with the ALAN Interactive Fiction Language" SAY my_game:AlanV.
    ".$nStandard Library v2.2.0"

    IF version OF my_game <> "0"
      THEN "$nVersion" SAY version OF my_game.
    END IF.

    "$nAll rights reserved."

END THE banner.


-- end of file.
