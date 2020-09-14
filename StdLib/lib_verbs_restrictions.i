-- ALAN Standard Library v2.2.0-WIP | ALAN 3.0beta7
-- Actions Restrictions (file name: 'lib_verbs_restrictions.i')
--------------------------------------------------------------------------------

-- Included in this file:
  -- attributes for restricted actions
  -- events for restricted actions

--------------------------------------------------------------------------------

-- =============================
-- Restricted Actions Attributes
-- =============================
ADD TO EVERY definition_block

-- For restricted actions, we implement the following attributes, corresponding
-- to the library verbs. If you change any of these to CAN NOT..., for example
-- "CAN NOT attack.", that verb, together with its synonyms, becomes disabled in
-- the game. The 'restricted_response' of the 'my_game' instance  will be shown
-- instead ("You can't do that."). The 'restriced_response' attribute is defined
-- in 'lib_messages_library.i'.

  CAN about.
  CAN 'again'.
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
  CAN fix.      -- (+ mend, repair)
  CAN follow.
  CAN free.        -- (+ release)
  CAN get_up.
  CAN get_off.
  CAN give.
  CAN go_to.
  CAN hint.        -- (+ hints)
  CAN i.       -- (+ inv, inventory)
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
  CAN 'look'.        -- (+ gaze, peek)
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
  CAN shoot. -- (at)
  CAN shoot_with.
  CAN shout.       -- (+ scream, yell)
  CAN 'show'.      -- (+ reveal)
  CAN sing.
  CAN sip.
  CAN sit. -- (down)
  CAN sit_on.
  CAN sleep.       -- (+ rest)
  CAN smell0.
  CAN smell.
  CAN squeeze.
  CAN stand. -- (up)
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
  CAN 'wait'.        -- (+ z)
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

-- ========================
-- Restricted Actions Event
-- ========================
-- This event runs every turn from the start of the game:

EVENT check_restriction
  -- To optimize performance, we compare the current value of restriction with
  -- last value encountered, and if no changes are detected we don't change
  -- any action restrictions attributes.
  IF restricted_level OF my_game <> previous_restricted_level OF my_game
    THEN
      -- A change in restriction level was detected. Since restriction levels
      -- are built on top of each other, in a progressively restricting manner,
      -- like layers, we first apply all the unrestricted attributes of Level 0,
      -- and then conditionally apply the requried constraints layers ...
      ----------------------
      -- Restriction Level 0
      ----------------------
      -- All verbs work normally, without restriction.

      MAKE my_game about.
      MAKE my_game 'again'.
      MAKE my_game answer.      -- (+ reply)
      MAKE my_game ask.         -- (+ enquire, inquire, interrogate)
      MAKE my_game ask_for.
      MAKE my_game attack.      -- (+ beat, fight, hit, punch)
      MAKE my_game attack_with.
      MAKE my_game bite.        -- (+ chew)
      MAKE my_game break.       -- (+ destroy)
      MAKE my_game break_with.
      MAKE my_game burn.
      MAKE my_game burn_with.
      MAKE my_game buy.         -- (+ purchase)
      MAKE my_game catch.
      MAKE my_game clean.       -- (+ polish, wipe)
      MAKE my_game climb.
      MAKE my_game climb_on.
      MAKE my_game climb_through.
      MAKE my_game close.       -- (+ shut)
      MAKE my_game close_with.
      MAKE my_game consult.
      MAKE my_game credits.     -- (+ acknowledgments, author, copyright)
      MAKE my_game cut.
      MAKE my_game cut_with.
      MAKE my_game dance.
      MAKE my_game dig.
      MAKE my_game dive.
      MAKE my_game dive_in.
      MAKE my_game drink.
      MAKE my_game drive.
      MAKE my_game drop.        -- (+ discard, dump, reject)
      MAKE my_game eat.
      MAKE my_game 'empty'.
      MAKE my_game empty_in.
      MAKE my_game empty_on.
      MAKE my_game enter.
      MAKE my_game examine.     -- (+ check, inspect, observe, x)
      MAKE my_game 'exit'.
      MAKE my_game extinguish.  -- (+ put out, quench)
      MAKE my_game fill.
      MAKE my_game fill_with.
      MAKE my_game find.        -- (+ locate)
      MAKE my_game fire.
      MAKE my_game fire_at.
      MAKE my_game fix.     -- (+ mend, repair)
      MAKE my_game follow.
      MAKE my_game free.        -- (+ release)
      MAKE my_game get_up.
      MAKE my_game get_off.
      MAKE my_game give.
      MAKE my_game go_to.
      MAKE my_game hint.        -- (+ hints)
      MAKE my_game i.        -- (+ inv, inventory)
      MAKE my_game jump.
      MAKE my_game jump_in.
      MAKE my_game jump_on.
      MAKE my_game kick.
      MAKE my_game kill.        -- (+ murder)
      MAKE my_game kill_with.
      MAKE my_game kiss.        -- (+ hug, embrace)
      MAKE my_game knock.
      MAKE my_game lie_down.
      MAKE my_game lie_in.
      MAKE my_game lie_on.
      MAKE my_game lift.
      MAKE my_game light.       -- (+ lit)
      MAKE my_game listen0.
      MAKE my_game listen.
      MAKE my_game lock.
      MAKE my_game lock_with.
      MAKE my_game 'look'.        -- (+ gaze, peek)
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
      MAKE my_game put.         -- (+ lay, place)
      MAKE my_game put_against.
      MAKE my_game put_behind.
      MAKE my_game put_in.      -- (+ insert)
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
      MAKE my_game shoot. -- (at)
      MAKE my_game shoot_with.
      MAKE my_game shout.       -- (+ scream, yell)
      MAKE my_game 'show'.      -- (+ reveal)
      MAKE my_game sing.
      MAKE my_game sip.
      MAKE my_game sit. -- (down)
      MAKE my_game sit_on.
      MAKE my_game sleep.       -- (+ rest)
      MAKE my_game smell0.
      MAKE my_game smell.
      MAKE my_game squeeze.
      MAKE my_game stand. -- (up)
      MAKE my_game stand_on.
      MAKE my_game swim.
      MAKE my_game swim_in.
      MAKE my_game switch.
      MAKE my_game switch_on.
      MAKE my_game switch_off.
      MAKE my_game take.        -- (+ carry, get, grab, hold, obtain)
      MAKE my_game take_from.   -- (+ remove from)
      MAKE my_game talk.
      MAKE my_game talk_to.     -- (+ speak)
      MAKE my_game taste.       -- (+ lick)
      MAKE my_game tear.        -- (+ rip)
      MAKE my_game tell.        -- (+ enlighten, inform)
      MAKE my_game think.
      MAKE my_game think_about.
      MAKE my_game throw.
      MAKE my_game throw_at.
      MAKE my_game throw_in.
      MAKE my_game throw_to.
      MAKE my_game tie.
      MAKE my_game tie_to.
      MAKE my_game touch.       -- (+ feel)
      MAKE my_game touch_with.
      MAKE my_game turn.        -- (+ rotate)
      MAKE my_game turn_on.
      MAKE my_game turn_off.
      MAKE my_game undress.
      MAKE my_game unlock.
      MAKE my_game unlock_with.
      MAKE my_game 'use'.
      MAKE my_game use_with.
      MAKE my_game 'wait'.        -- (+ z)
      MAKE my_game wear.
      MAKE my_game what_am_i.
      MAKE my_game what_is.
      MAKE my_game where_am_i.
      MAKE my_game where_is.
      MAKE my_game who_am_i.
      MAKE my_game who_is.
      MAKE my_game write.
      MAKE my_game yes.
      ----------------------
      -- Restriction Level 1
      ----------------------
      -- This level restricts communication verbs.

      IF restricted_level OF my_game >= 1
        THEN
          MAKE my_game NOT 'say'.
          MAKE my_game NOT answer.
          MAKE my_game NOT ask.
          MAKE my_game NOT ask_for.
          MAKE my_game NOT say_to.
          MAKE my_game NOT shout.
          MAKE my_game NOT sing.
          MAKE my_game NOT talk.
          MAKE my_game NOT talk_to.     -- (+ speak)
          MAKE my_game NOT tell.
     END IF.
      ----------------------
      -- Restriction Level 2
      ----------------------
      -- This level further restricts all in-game actions except mental and
      -- sensory acts which don't involve physical interaction with the
      -- environment.
      -- It doesn't affect out-of-game verbs (extradiegetic actions).

      IF restricted_level OF my_game >= 2
        THEN
          MAKE my_game NOT attack.      -- (+ beat, fight, hit, punch)
          MAKE my_game NOT attack_with.
          MAKE my_game NOT bite.        -- (+ chew)
          MAKE my_game NOT break.       -- (+ destroy)
          MAKE my_game NOT break_with.
          MAKE my_game NOT burn.
          MAKE my_game NOT burn_with.
          MAKE my_game NOT buy.         -- (+ purchase)
          MAKE my_game NOT catch.
          MAKE my_game NOT clean.       -- (+ polish, wipe)
          MAKE my_game NOT climb.
          MAKE my_game NOT climb_on.
          MAKE my_game NOT climb_through.
          MAKE my_game NOT close.       -- (+ shut)
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
          MAKE my_game NOT drop.        -- (+ discard, dump, reject)
          MAKE my_game NOT eat.
          MAKE my_game NOT 'empty'.
          MAKE my_game NOT empty_in.
          MAKE my_game NOT empty_on.
          MAKE my_game NOT enter.
          MAKE my_game NOT 'exit'.
          MAKE my_game NOT extinguish.  -- (+ put out, quench)
          MAKE my_game NOT fill.
          MAKE my_game NOT fill_with.
          MAKE my_game NOT find.        -- (+ locate)
          MAKE my_game NOT fire.
          MAKE my_game NOT fire_at.
          MAKE my_game NOT fix.     -- (+ mend, repair)
          MAKE my_game NOT follow.
          MAKE my_game NOT free.        -- (+ release)
          MAKE my_game NOT get_up.
          MAKE my_game NOT get_off.
          MAKE my_game NOT give.
          MAKE my_game NOT go_to.
          MAKE my_game NOT jump.
          MAKE my_game NOT jump_in.
          MAKE my_game NOT jump_on.
          MAKE my_game NOT kick.
          MAKE my_game NOT kill.        -- (+ murder)
          MAKE my_game NOT kill_with.
          MAKE my_game NOT kiss.        -- (+ hug, embrace)
          MAKE my_game NOT knock.
          MAKE my_game NOT lie_down.
          MAKE my_game NOT lie_in.
          MAKE my_game NOT lie_on.
          MAKE my_game NOT lift.
          MAKE my_game NOT light.       -- (+ lit)
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
          MAKE my_game NOT put.         -- (+ lay, place)
          MAKE my_game NOT put_against.
          MAKE my_game NOT put_behind.
          MAKE my_game NOT put_in.      -- (+ insert)
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
          MAKE my_game NOT shoot. -- (at)
          MAKE my_game NOT shoot_with.
          MAKE my_game NOT 'show'.      -- (+ reveal)
          MAKE my_game NOT sip.
          MAKE my_game NOT sit. -- (down)
          MAKE my_game NOT sit_on.
          MAKE my_game NOT sleep.       -- (+ rest)
          MAKE my_game NOT squeeze.
          MAKE my_game NOT stand. -- (up)
          MAKE my_game NOT stand_on.
          MAKE my_game NOT swim.
          MAKE my_game NOT swim_in.
          MAKE my_game NOT switch.
          MAKE my_game NOT switch_on.
          MAKE my_game NOT switch_off.
          MAKE my_game NOT take.        -- (+ carry, get, grab, hold, obtain)
          MAKE my_game NOT take_from.   -- (+ remove from)
          MAKE my_game NOT taste.       -- (+ lick)
          MAKE my_game NOT tear.        -- (+ rip)
          MAKE my_game NOT throw.
          MAKE my_game NOT throw_at.
          MAKE my_game NOT throw_in.
          MAKE my_game NOT throw_to.
          MAKE my_game NOT tie.
          MAKE my_game NOT tie_to.
          MAKE my_game NOT touch.       -- (+ feel)
          MAKE my_game NOT touch_with.
          MAKE my_game NOT turn.        -- (+ rotate)
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
      ----------------------
      -- Restriction Level 3
      ----------------------
      -- This level further restricts any verb which isn't an out-of-game action.
      IF restricted_level OF my_game >= 3
        THEN
          MAKE my_game NOT examine.     -- (+ check, inspect, observe, x)
          MAKE my_game NOT i.        -- (+ inv, inventory)
          MAKE my_game NOT listen0.
          MAKE my_game NOT listen.
          MAKE my_game NOT 'look'.        -- (+ gaze, peek)
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
          MAKE my_game NOT 'wait'.        -- (+ z)
          MAKE my_game NOT what_am_i.
          MAKE my_game NOT what_is.
          MAKE my_game NOT where_am_i.
          MAKE my_game NOT where_is.
          MAKE my_game NOT who_am_i.
          MAKE my_game NOT who_is.
      END IF.
      ----------------------
      -- Restriction Level 4
      ----------------------
      -- This last level further restricts out-of-game actions (extradiegetic).
      IF restricted_level OF my_game >= 4
        THEN
          MAKE my_game NOT about.
          MAKE my_game NOT 'again'.
          MAKE my_game NOT credits.     -- (+ acknowledgments, author, copyright)
          MAKE my_game NOT hint.        -- (+ hints)
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

      -- Update attribute for tracking restrictions-changes:
      SET previous_restricted_level OF my_game TO restricted_level OF my_game.

    END IF.

  -- Reschedule this event:
  SCHEDULE check_restriction AFTER 1.

END EVENT.


-- end of file.
