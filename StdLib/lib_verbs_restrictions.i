-- lib_verbs_restrictions.i   | ALAN Standard Library v2.2.0-WIP | ALAN 3.0beta8
--+============================================================================+
--|\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////////|
--++--------------------------------------------------------------------------++
--||                                                                          ||
--||                 A C T I O N S   R E S T R I C T I O N S                  ||
--||                                                                          ||
--++--------------------------------------------------------------------------++
--|//////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\|
--+============================================================================+

-- This library module implements the actions-restrictions feature, which allows
-- authors to enable or disable specific groups of verbs, all verbs, or even
-- selected verbs:

--   * Attributes for restricted actions.
--   * A restricted actions event (`check_restriction`).

-- When the player attempt a disabled action, the verb will fail to execute and
-- the `restricted_response` message will be printed ("You can't do that.").
-- The default restricted-actions message can be changed at any time (including
-- mid-game) by changing the `restricted_response OF my_game` attribute (defined
-- in 'lib_messages_library.i').

-- Authors can enable or disable entire groups of verbs by changing the value of
-- the `restricted_level OF my_game` attribute according to the following table:

--    +---+-----------------------------------------------------------------+
--    | 0 | All verbs enabled, without restrictions.                        |
--    +---+-----------------------------------------------------------------+
--    | 1 | All communication verbs are disabled.                           |
--    +---+-----------------------------------------------------------------+
--    | 2 | All in-game actions are disabled except mental and sensory acts |
--    |   | which don't involve physical interaction with the environment.  |
--    |   | It doesn't affect out-of-game actions (gameplay meta verbs).    |
--    +---+-----------------------------------------------------------------+
--    | 3 | All in-game actions are disabled; only out-of-game action are   |
--    |   | allowed (gameplay meta verbs like save, restore, score, etc.).  |
--    +---+-----------------------------------------------------------------+
--    | 4 | All verbs are disabled, no action whatsoever is possible.       |
--    +---+-----------------------------------------------------------------+
--    | 5 | The player can only answer YES or NO.                           |
--    +---+-----------------------------------------------------------------+

-- Restriction levels are incremental, each level restricts an additional group
-- of actions compared to the previous one, along a continuum with levels 0 and
-- 4 at its extremes; at level 0 all actions are enabled, at level 4 they're all
-- blocked.

-- Level 5 is a special level created for YES/NO answers. Only the verbs `yes`
-- and `'no'` can be used at Level 5. Also, the restricted-actions message is
-- set to "Please answer YES or NO." for the whole duration of this level, and
-- then restored to its previous value when switching to another level. This
-- level is not part of the 0-4 continuum described above; it's an independent
-- restriction level of its own kind.

-- Level 0 is the default restriction level of the library.

-- The library constantly monitors the `restricted_level` attribute via the
-- `check_restriction` event, and whenever it detects a change in its value it
-- will disable and enable the various groups of verbs according to the new
-- restriction level encountered.

-- Authors can also enable or disable specific verbs via actions-restrictions
-- attributes. Each library verb has a corresponding same-named attribute on the
-- `my_gmae` instance, by changing its boolean value to `CAN` or `CAN NOT` it's
-- possible to enable or disable any verb. For example:

--    Make my_game NOT shout. -- disable shouting.
--    Make my_game 'save'.    -- enable saving the game.

-- Beware that changes to the value of the `restricted_level` attribute  will
-- become effective *after* all the adventure code of the current turn has run
-- (but before the next turn starts), because the library monitors it within an
-- EVENT, and events are executed after adventure code. This means that code
-- like the following:

--    Set my_game:restricted_level to 4. -- Block all verbs.
--    Make my_game 'look'.               -- Enable looking.

-- won't work as expected: all verbs will be blocked at the next turn, including
-- LOOK. This happens because the change in restriction level will be detected
-- *after* the above code from the adventure has executed, so the library will
-- block all verbs, including LOOK --- i.e. the attempt to preserve the LOOK
-- verb via the second line of the example is futile, because that line will be
-- executed immediately, whereas execution of the previous line is postponed to
-- when EVENTs are processed by the interpreter, which will cancel its effect.

-- In order to switch to a given restriction level and enable/disable specific
-- actions in the same turn, you'll need to create and SCHEDULE a dedicated
-- EVENT to handle the specific verbs, so that it gets queued in the events
-- processing queue of the interpreter, and will execute *after* the library
-- event `check_restriction`.

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--          R E S T R I C T E D   A C T I O N S   A T T R I B U T E S
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- The actions-restrictions feature uses boolean attributes to track which verbs
-- are enabled or disabled. For each library verb, a same-named attribute is
-- defined on the `definition_block` class, so that during the game each verb
-- can be enabled or disabled by setting or clearing its attribute counterpart
-- on the `my_game` instance.

-- The library uses two `my_game` attributes for managing restricted actions:

--   * `restricted_level`
--   * `previous_restricted_level` (used internally by the library)

-- The former is used by authors to change the restrictions level mid-game, by
-- assigning to the attribute a new value (0-5). The latter is used internally
-- by the library, in the `check_restriction` EVENT, to detect at every turn if
-- the value of `restricted_level` has changed, compared to its previous value
-- stored in `previous_restricted_level` (see the `check_restriction` EVENT code
-- below).

ADD TO EVERY definition_block
  HAS
    restricted_level 0.          -- Default value: no verbs are restricted.
    previous_restricted_level 0. -- Used to detect restriction level changes.
    restricted_response_bak "".  -- Used to store copy of `restricted_response`
                                 -- at Level 5, which changes the message.

  CAN about.
  CAN again.
  CAN answer.      -- (+ reply)
  CAN ask.         -- (+ enquire, inquire, interrogate)
  CAN ask_for.
  CAN attack.      -- (+ beat, fight, hit, punch)
  CAN attack_with.
  CAN bite.        -- (+ chew)
  CAN break.       -- (+ destroy)
  CAN break_with.
  CAN burn.
  CAN burn_with.
  CAN buy.         -- (+ purchase)
  CAN catch.
  CAN clean.       -- (+ polish, wipe)
  CAN climb.
  CAN climb_on.
  CAN climb_through.
  CAN close.       -- (+ shut)
  CAN close_with.
  CAN consult.
  CAN credits.     -- (+ acknowledgments, author, copyright)
  CAN cut.
  CAN cut_with.
  CAN dance.
  CAN dig.
  CAN dive.
  CAN dive_in.
  CAN drink.
  CAN drive.
  CAN drop.        -- (+ discard, dump, reject)
  CAN eat.
  CAN 'empty'.
  CAN empty_in.
  CAN empty_on.
  CAN enter.
  CAN examine.     -- (+ check, inspect, observe, x)
  CAN 'exit'.
  CAN extinguish.  -- (+ put out, quench)
  CAN fill.
  CAN fill_with.
  CAN find.        -- (+ locate)
  CAN fire.
  CAN fire_at.
  CAN fix.         -- (+ mend, repair)
  CAN follow.
  CAN free.        -- (+ release)
  CAN get_up.
  CAN get_off.
  CAN give.
  CAN go_to.
  CAN hint.        -- (+ hints)
  CAN i.           -- (+ inv, inventory)
  CAN jump.
  CAN jump_in.
  CAN jump_on.
  CAN kick.
  CAN kill.        -- (+ murder)
  CAN kill_with.
  CAN kiss.        -- (+ hug, embrace)
  CAN knock.
  CAN lie_down.
  CAN lie_in.
  CAN lie_on.
  CAN lift.
  CAN light.       -- (+ lit)
  CAN listen0.
  CAN listen.
  CAN lock.
  CAN lock_with.
  CAN 'look'.      -- (+ gaze, peek)
  CAN look_behind.
  CAN look_in.
  CAN look_out_of.
  CAN look_through.
  CAN look_under.
  CAN look_up.
  CAN 'no'.
  CAN notify.
  CAN notify_on.
  CAN notify_off.
  CAN open.
  CAN open_with.
  CAN 'play'.
  CAN play_with.
  CAN pour.
  CAN pour_in.
  CAN pour_on.
  CAN pray.
  CAN pry.
  CAN pry_with.
  CAN pull.
  CAN push.
  CAN push_with.
  CAN put.         -- (+ lay, place)
  CAN put_against.
  CAN put_behind.
  CAN put_in.      -- (+ insert)
  CAN put_near.
  CAN put_on.
  CAN put_under.
  CAN 'quit'.
  CAN read.
  CAN remove.
  CAN 'restart'.
  CAN 'restore'.
  CAN rub.
  CAN 'save'.
  CAN 'say'.
  CAN say_to.
  CAN 'score'.
  CAN scratch.
  CAN 'script'.
  CAN script_on.
  CAN script_off.
  CAN search.
  CAN sell.
  CAN shake.
  CAN shoot.
  CAN shoot_with.
  CAN shout.       -- (+ scream, yell)
  CAN 'show'.      -- (+ reveal)
  CAN sing.
  CAN sip.
  CAN sit.
  CAN sit_on.
  CAN sleep.       -- (+ rest)
  CAN smell0.
  CAN smell.
  CAN squeeze.
  CAN stand.
  CAN stand_on.
  CAN swim.
  CAN swim_in.
  CAN switch.
  CAN switch_on.
  CAN switch_off.
  CAN take.        -- (+ carry, get, grab, hold, obtain)
  CAN take_from.   -- (+ remove from)
  CAN talk.
  CAN talk_to.     -- (+ speak)
  CAN taste.       -- (+ lick)
  CAN tear.        -- (+ rip)
  CAN tell.        -- (+ enlighten, inform)
  CAN think.
  CAN think_about.
  CAN throw.
  CAN throw_at.
  CAN throw_in.
  CAN throw_to.
  CAN tie.
  CAN tie_to.
  CAN touch.       -- (+ feel)
  CAN touch_with.
  CAN turn.        -- (+ rotate)
  CAN turn_on.
  CAN turn_off.
  CAN undress.
  CAN unlock.
  CAN unlock_with.
  CAN 'use'.
  CAN use_with.
  CAN 'wait'.      -- (+ z)
  CAN wear.
  CAN what_am_i.
  CAN what_is.
  CAN where_am_i.
  CAN where_is.
  CAN who_am_i.
  CAN who_is.
  CAN write.
  CAN yes.
END ADD TO definition_block.

--==============================================================================
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------------------------------------------------
--
--               R E S T R I C T E D   A C T I O N S   E V E N T
--
--------------------------------------------------------------------------------
--* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--==============================================================================

-- This event will run at every turn, since the start of the game.

EVENT check_restriction
  -- ---------------------------------------------------------------------------
  -- RESTRICTION LEVEL SAFETY CHECK: Prevent out of range values.
  -- ---------------------------------------------------------------------------
  IF my_game:restricted_level > 5 THEN
    SET my_game:restricted_level TO 5.
  END IF.
  -- ---------------------------------------------------------------------------
  -- To optimize performance, we compare the current restriction value with the
  -- last value encountered, and if no changes are detected we won't change any
  -- actions-restrictions attributes.
  -- ---------------------------------------------------------------------------
  IF my_game:restricted_level <> my_game:previous_restricted_level
    THEN
      -- A change in restriction level was detected.

      -- Since restriction levels are built on top of each other, in a
      -- progressively restricting manner, like layers, we first apply all the
      -- unrestricted attributes of Level 0, and then conditionally apply the
      -- required constraints layers.

      -- ===================
      -- RESTRICTION LEVEL 0
      -- ===================
      -- All verbs work normally, without restriction.

      MAKE my_game about.
      MAKE my_game again.
      MAKE my_game answer.
      MAKE my_game ask.
      MAKE my_game ask_for.
      MAKE my_game attack.
      MAKE my_game attack_with.
      MAKE my_game bite.
      MAKE my_game break.
      MAKE my_game break_with.
      MAKE my_game burn.
      MAKE my_game burn_with.
      MAKE my_game buy.
      MAKE my_game catch.
      MAKE my_game clean.
      MAKE my_game climb.
      MAKE my_game climb_on.
      MAKE my_game climb_through.
      MAKE my_game close.
      MAKE my_game close_with.
      MAKE my_game consult.
      MAKE my_game credits.
      MAKE my_game cut.
      MAKE my_game cut_with.
      MAKE my_game dance.
      MAKE my_game dig.
      MAKE my_game dive.
      MAKE my_game dive_in.
      MAKE my_game drink.
      MAKE my_game drive.
      MAKE my_game drop.
      MAKE my_game eat.
      MAKE my_game 'empty'.
      MAKE my_game empty_in.
      MAKE my_game empty_on.
      MAKE my_game enter.
      MAKE my_game examine.
      MAKE my_game 'exit'.
      MAKE my_game extinguish.
      MAKE my_game fill.
      MAKE my_game fill_with.
      MAKE my_game find.
      MAKE my_game fire.
      MAKE my_game fire_at.
      MAKE my_game fix.
      MAKE my_game follow.
      MAKE my_game free.
      MAKE my_game get_up.
      MAKE my_game get_off.
      MAKE my_game give.
      MAKE my_game go_to.
      MAKE my_game hint.
      MAKE my_game i.
      MAKE my_game jump.
      MAKE my_game jump_in.
      MAKE my_game jump_on.
      MAKE my_game kick.
      MAKE my_game kill.
      MAKE my_game kill_with.
      MAKE my_game kiss.
      MAKE my_game knock.
      MAKE my_game lie_down.
      MAKE my_game lie_in.
      MAKE my_game lie_on.
      MAKE my_game lift.
      MAKE my_game light.
      MAKE my_game listen0.
      MAKE my_game listen.
      MAKE my_game lock.
      MAKE my_game lock_with.
      MAKE my_game 'look'.
      MAKE my_game look_behind.
      MAKE my_game look_in.
      MAKE my_game look_out_of.
      MAKE my_game look_through.
      MAKE my_game look_under.
      MAKE my_game look_up.
      MAKE my_game 'no'.
      MAKE my_game notify.
      MAKE my_game notify_on.
      MAKE my_game notify_off.
      MAKE my_game open.
      MAKE my_game open_with.
      MAKE my_game 'play'.
      MAKE my_game play_with.
      MAKE my_game pour.
      MAKE my_game pour_in.
      MAKE my_game pour_on.
      MAKE my_game pray.
      MAKE my_game pry.
      MAKE my_game pry_with.
      MAKE my_game pull.
      MAKE my_game push.
      MAKE my_game push_with.
      MAKE my_game put.
      MAKE my_game put_against.
      MAKE my_game put_behind.
      MAKE my_game put_in.
      MAKE my_game put_near.
      MAKE my_game put_on.
      MAKE my_game put_under.
      MAKE my_game 'quit'.
      MAKE my_game read.
      MAKE my_game remove.
      MAKE my_game 'restart'.
      MAKE my_game 'restore'.
      MAKE my_game rub.
      MAKE my_game 'save'.
      MAKE my_game 'say'.
      MAKE my_game say_to.
      MAKE my_game 'score'.
      MAKE my_game scratch.
      MAKE my_game 'script'.
      MAKE my_game script_on.
      MAKE my_game script_off.
      MAKE my_game search.
      MAKE my_game sell.
      MAKE my_game shake.
      MAKE my_game shoot.
      MAKE my_game shoot_with.
      MAKE my_game shout.
      MAKE my_game 'show'.
      MAKE my_game sing.
      MAKE my_game sip.
      MAKE my_game sit.
      MAKE my_game sit_on.
      MAKE my_game sleep.
      MAKE my_game smell0.
      MAKE my_game smell.
      MAKE my_game squeeze.
      MAKE my_game stand.
      MAKE my_game stand_on.
      MAKE my_game swim.
      MAKE my_game swim_in.
      MAKE my_game switch.
      MAKE my_game switch_on.
      MAKE my_game switch_off.
      MAKE my_game take.
      MAKE my_game take_from.
      MAKE my_game talk.
      MAKE my_game talk_to.
      MAKE my_game taste.
      MAKE my_game tear.
      MAKE my_game tell.
      MAKE my_game think.
      MAKE my_game think_about.
      MAKE my_game throw.
      MAKE my_game throw_at.
      MAKE my_game throw_in.
      MAKE my_game throw_to.
      MAKE my_game tie.
      MAKE my_game tie_to.
      MAKE my_game touch.
      MAKE my_game touch_with.
      MAKE my_game turn.
      MAKE my_game turn_on.
      MAKE my_game turn_off.
      MAKE my_game undress.
      MAKE my_game unlock.
      MAKE my_game unlock_with.
      MAKE my_game 'use'.
      MAKE my_game use_with.
      MAKE my_game 'wait'.
      MAKE my_game wear.
      MAKE my_game what_am_i.
      MAKE my_game what_is.
      MAKE my_game where_am_i.
      MAKE my_game where_is.
      MAKE my_game who_am_i.
      MAKE my_game who_is.
      MAKE my_game write.
      MAKE my_game yes.

      -- ===================
      -- RESTRICTION LEVEL 1
      -- ===================
      -- This level restricts all communication verbs.

      IF my_game:restricted_level >= 1
        THEN
          MAKE my_game NOT 'say'.
          MAKE my_game NOT answer.
          MAKE my_game NOT ask.
          MAKE my_game NOT ask_for.
          MAKE my_game NOT say_to.
          MAKE my_game NOT shout.
          MAKE my_game NOT sing.
          MAKE my_game NOT talk.
          MAKE my_game NOT talk_to.
          MAKE my_game NOT tell.
      END IF.

      -- ===================
      -- RESTRICTION LEVEL 2
      -- ===================

      -- This level further restricts all in-game actions, except for mental and
      -- sensory actions which don't involve physical interactions with the
      -- environment.
      -- It doesn't affect out-of-game verbs (i.e. meta verbs, or  extradiegetic
      -- actions, like saving, restoring, etc.).

      IF my_game:restricted_level >= 2
        THEN
          MAKE my_game NOT attack.
          MAKE my_game NOT attack_with.
          MAKE my_game NOT bite.
          MAKE my_game NOT break.
          MAKE my_game NOT break_with.
          MAKE my_game NOT burn.
          MAKE my_game NOT burn_with.
          MAKE my_game NOT buy.
          MAKE my_game NOT catch.
          MAKE my_game NOT clean.
          MAKE my_game NOT climb.
          MAKE my_game NOT climb_on.
          MAKE my_game NOT climb_through.
          MAKE my_game NOT close.
          MAKE my_game NOT close_with.
          MAKE my_game NOT consult.
          MAKE my_game NOT cut.
          MAKE my_game NOT cut_with.
          MAKE my_game NOT dance.
          MAKE my_game NOT dig.
          MAKE my_game NOT dive.
          MAKE my_game NOT dive_in.
          MAKE my_game NOT drink.
          MAKE my_game NOT drive.
          MAKE my_game NOT drop.
          MAKE my_game NOT eat.
          MAKE my_game NOT 'empty'.
          MAKE my_game NOT empty_in.
          MAKE my_game NOT empty_on.
          MAKE my_game NOT enter.
          MAKE my_game NOT 'exit'.
          MAKE my_game NOT extinguish.
          MAKE my_game NOT fill.
          MAKE my_game NOT fill_with.
          MAKE my_game NOT find.
          MAKE my_game NOT fire.
          MAKE my_game NOT fire_at.
          MAKE my_game NOT fix.
          MAKE my_game NOT follow.
          MAKE my_game NOT free.
          MAKE my_game NOT get_up.
          MAKE my_game NOT get_off.
          MAKE my_game NOT give.
          MAKE my_game NOT go_to.
          MAKE my_game NOT jump.
          MAKE my_game NOT jump_in.
          MAKE my_game NOT jump_on.
          MAKE my_game NOT kick.
          MAKE my_game NOT kill.
          MAKE my_game NOT kill_with.
          MAKE my_game NOT kiss.
          MAKE my_game NOT knock.
          MAKE my_game NOT lie_down.
          MAKE my_game NOT lie_in.
          MAKE my_game NOT lie_on.
          MAKE my_game NOT lift.
          MAKE my_game NOT light.
          MAKE my_game NOT lock.
          MAKE my_game NOT lock_with.
          MAKE my_game NOT open.
          MAKE my_game NOT open_with.
          MAKE my_game NOT 'play'.
          MAKE my_game NOT play_with.
          MAKE my_game NOT pour.
          MAKE my_game NOT pour_in.
          MAKE my_game NOT pour_on.
          MAKE my_game NOT pry.
          MAKE my_game NOT pry_with.
          MAKE my_game NOT pull.
          MAKE my_game NOT push.
          MAKE my_game NOT push_with.
          MAKE my_game NOT put.
          MAKE my_game NOT put_against.
          MAKE my_game NOT put_behind.
          MAKE my_game NOT put_in.
          MAKE my_game NOT put_near.
          MAKE my_game NOT put_on.
          MAKE my_game NOT put_under.
          MAKE my_game NOT read.
          MAKE my_game NOT remove.
          MAKE my_game NOT rub.
          MAKE my_game NOT scratch.
          MAKE my_game NOT search.
          MAKE my_game NOT sell.
          MAKE my_game NOT shake.
          MAKE my_game NOT shoot.
          MAKE my_game NOT shoot_with.
          MAKE my_game NOT 'show'.
          MAKE my_game NOT sip.
          MAKE my_game NOT sit.
          MAKE my_game NOT sit_on.
          MAKE my_game NOT sleep.
          MAKE my_game NOT squeeze.
          MAKE my_game NOT stand.
          MAKE my_game NOT stand_on.
          MAKE my_game NOT swim.
          MAKE my_game NOT swim_in.
          MAKE my_game NOT switch.
          MAKE my_game NOT switch_on.
          MAKE my_game NOT switch_off.
          MAKE my_game NOT take.
          MAKE my_game NOT take_from.
          MAKE my_game NOT taste.
          MAKE my_game NOT tear.
          MAKE my_game NOT throw.
          MAKE my_game NOT throw_at.
          MAKE my_game NOT throw_in.
          MAKE my_game NOT throw_to.
          MAKE my_game NOT tie.
          MAKE my_game NOT tie_to.
          MAKE my_game NOT touch.
          MAKE my_game NOT touch_with.
          MAKE my_game NOT turn.
          MAKE my_game NOT turn_on.
          MAKE my_game NOT turn_off.
          MAKE my_game NOT undress.
          MAKE my_game NOT unlock.
          MAKE my_game NOT unlock_with.
          MAKE my_game NOT 'use'.
          MAKE my_game NOT use_with.
          MAKE my_game NOT wear.
          MAKE my_game NOT write.
      END IF.

      -- ===================
      -- RESTRICTION LEVEL 3
      -- ===================
      -- This level further restricts any verb which isn't an out-of-game action.

      IF my_game:restricted_level >= 3
        THEN
          MAKE my_game NOT examine.
          MAKE my_game NOT i.
          MAKE my_game NOT listen0.
          MAKE my_game NOT listen.
          MAKE my_game NOT 'look'.
          MAKE my_game NOT look_behind.
          MAKE my_game NOT look_in.
          MAKE my_game NOT look_out_of.
          MAKE my_game NOT look_through.
          MAKE my_game NOT look_under.
          MAKE my_game NOT look_up.
          MAKE my_game NOT pray.
          MAKE my_game NOT smell0.
          MAKE my_game NOT smell.
          MAKE my_game NOT think.
          MAKE my_game NOT think_about.
          MAKE my_game NOT 'wait'.
          MAKE my_game NOT what_am_i.
          MAKE my_game NOT what_is.
          MAKE my_game NOT where_am_i.
          MAKE my_game NOT where_is.
          MAKE my_game NOT who_am_i.
          MAKE my_game NOT who_is.
      END IF.

      -- ===================
      -- RESTRICTION LEVEL 4
      -- ===================
      -- This last level further restricts out-of-game actions (extradiegetic).
      -- All verbs are disabled at this level, no action whatsoever is possible.

      IF my_game:restricted_level >= 4
        THEN
          MAKE my_game NOT about.
          MAKE my_game NOT again.
          MAKE my_game NOT credits.
          MAKE my_game NOT hint.
          MAKE my_game NOT 'no'.
          MAKE my_game NOT notify.
          MAKE my_game NOT notify_on.
          MAKE my_game NOT notify_off.
          MAKE my_game NOT 'quit'.
          MAKE my_game NOT 'restart'.
          MAKE my_game NOT 'restore'.
          MAKE my_game NOT 'save'.
          MAKE my_game NOT 'score'.
          MAKE my_game NOT 'script'.
          MAKE my_game NOT script_on.
          MAKE my_game NOT script_off.
          MAKE my_game NOT yes.
      END IF.

      -- ===================
      -- RESTRICTION LEVEL 5
      -- ===================
      -- This is a special restriction level where the player can only answer
      -- YES or NO. It's kept independent of the other level because it also
      -- changes the `restricted_response` message to "Please answer YES or NO."
      -- for the whole duration of the restriction level.

      IF my_game:restricted_level = 5 THEN
        -- Store a copy of the current restricted actions message:
        SET my_game:restricted_response_bak
         TO my_game:restricted_response.
        -- Change restricted actions message:
        SET my_game:restricted_response TO "Please answer YES or NO.".
        -- Enable only the YES and NO verbs:
        MAKE my_game 'no'.
        MAKE my_game yes.
      ELSIF my_game:previous_restricted_level = 5 THEN
        -- If we're switching from Level 5 to another level, then
        -- restore original restricted actions message:
        SET my_game:restricted_response
         TO my_game:restricted_response_bak.
      END IF.

      -- Update attribute for tracking restrictions-changes:
      SET my_game:previous_restricted_level
       TO my_game:restricted_level.

    END IF.


  -- Always reschedule this event:
  SCHEDULE check_restriction AFTER 1.

END EVENT.


-- end of file.
