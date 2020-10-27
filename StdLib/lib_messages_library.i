-- lib_messages_library.i     | ALAN Standard Library v2.2.0-WIP | ALAN 3.0beta7
--+============================================================================+
--|\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////////|
--++--------------------------------------------------------------------------++
--||                                                                          ||
--||                     L I B R A R Y   M E S S A G E S                      ||
--||                                                                          ||
--++--------------------------------------------------------------------------++
--|//////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\|
--+============================================================================+

-- This library module defines various library default messages and responses:
--
--  * Messages for the hero.
--  * Messages for dark locations.
--  * Response for restricted actions.
--  * Illegal parameter messages, used in SYNTAX definitions of verbs.
--  * Verb check messages.
--  * Implicit taking message.

--------------------------------------------------------------------------------


ADD TO EVERY definition_block

  -- HERO RELATED MESSAGES:
  -- ======================

  -- The hero instance is not defined by the library; game authors are free to
  -- define the hero as they see fit. However, the library does define some
  -- basic hero-related messages, which can be easily overridden. Two of these
  -- messages are defined right below, the rest are defined in the verb checks
  -- messages further on.

  HAS hero_worn_header "You are wearing".
  HAS hero_worn_else   "You are not wearing anything.".


  -- DARK LOCATIONS DESCRIPTIONS:
  -- ============================

  HAS dark_loc_desc "It is pitch black. You can't see anything at all.".
    -- Message shown in a dark location when the player tries to LOOK,
    -- or attempts any other action requiring a light source.

  HAS light_goes_off "It is now pitch black.".
    -- Message shown when a light goes off and the location becomes dark.


  -- RESTRICTED ACTIONS RESPONSE:
  -- ============================

  HAS restricted_response "You can't do that.".
    -- Message shown when the player uses a verb that has been restricted by the
    -- "CAN NOT [verb]" attribute. (see 'lib_verbs_restrictions.i').


  -- ILLEGAL PARAMETER MESSAGES:
  -- ===========================

  -- Messages triggered by an illegal parameter are usually found in the ELSE
  -- parts of SYNTAX definitions. The first two generic messages defined below
  -- are the most commonly used one.


  -- Generic message for an unsuitable parameter:
  -----------------------------------------------

  HAS illegal_parameter_sg "That's not something you can $v.".
  HAS illegal_parameter_pl "Those are not something you can $v.".


  -- Generic unsuitable parameter messages for verbs requiring a preposition:
  ---------------------------------------------------------------------------

  HAS illegal_parameter_about_sg "That's not something you can $v about.".
  HAS illegal_parameter_about_pl "Those are not something you can $v about.".
  HAS illegal_parameter_at       "You can't $v anything at $+2.".
  HAS illegal_parameter_for_sg   "That's not something you can $v for.".
  HAS illegal_parameter_for_pl   "Those are not something you can $v for.".
  HAS illegal_parameter2_from_sg "That's not something you can take things from.".
  HAS illegal_parameter2_from_pl "Those are not something you can take things from.".
  HAS illegal_parameter_in_sg    "That's not something you can $v in.".
  HAS illegal_parameter_in_pl    "Those are not something you can $v in.".
  HAS illegal_parameter_on_sg    "That's not something you can $v on.".
  HAS illegal_parameter_on_pl    "Those are not something you can $v on.".
  HAS illegal_parameter_off_sg   "That's not something you can $v off.".
  HAS illegal_parameter_off_pl   "Those are not something you can $v off.".
  HAS illegal_parameter_to_sg    "That's not something you can $v to.".
  HAS illegal_parameter_to_pl    "Those are not something you can $v to.".
  HAS illegal_parameter2_to_sg   "That's not something you can $v things to.".
  HAS illegal_parameter2_to_pl   "Those are not something you can $v things to.".
  HAS illegal_parameter_with_sg  "That's not something you can $v with.".
  HAS illegal_parameter_with_pl  "Those are not something you can $v with.".
  HAS illegal_parameter2_with_sg "That's not something you can $v things with.".
  HAS illegal_parameter2_with_pl "Those are not something you can $v things with.".


  -- Other illegal parameter messages:
  ------------------------------------

  HAS illegal_parameter_act "That doesn't make sense.".

  HAS illegal_parameter_consult_sg "That's not something you can find information about.".
  HAS illegal_parameter_consult_pl "Those are not something you can find information about.".

  HAS illegal_parameter_examine_sg "That's not something you can examine.".
  HAS illegal_parameter_examine_pl "Those are not something you can examine.".

  HAS illegal_parameter_go "You can't go there.".

  HAS illegal_parameter_look_out_sg  "That's not something you can look out of.".
  HAS illegal_parameter_look_out_pl  "Those are not something you can look out of.".
  HAS illegal_parameter_look_through "You can't look through $+1.".

  HAS illegal_parameter_obj "You can only $v objects.".

  HAS illegal_parameter_string "Please state inside double quotes ("""") what you want to $v.".

  HAS illegal_parameter_talk_sg "That's not something you can talk to.".
  HAS illegal_parameter_talk_pl "Those are not something you can talk to.".

  HAS illegal_parameter_there  "It's not possible to look there.".
  HAS illegal_parameter2_there "It's not possible to $v anything there.".

  HAS illegal_parameter_what_sg "That's not something I know about.".
  HAS illegal_parameter_what_pl "Those are not something I know about.".
  HAS illegal_parameter_who_sg  "That's not somebody I know about.".
  HAS illegal_parameter_who_pl  "Those are not somebody I know about.".


  -- FAILED CHECK MESSAGES:
  -- ======================

  -- Verb check messages, found before the DOES section of verbs definitions,
  -- and used mainly in 'lib_verbs.i'.


  -- a) Attributes Checks
  -- --------------------


  -- The generic check message for when an instance can't be used with the verb:
  -- ---------------------------------------------------------------------------

  HAS check_obj_suitable_sg "That's not something you can $v.".
  HAS check_obj_suitable_pl "Those are not something you can $v.".


  -- Generic check messages for verbs requiring a preposition:
  -- ---------------------------------------------------------

  HAS check_obj_suitable_at       "You can't $v anything at $+2.".
  HAS check_obj2_suitable_for_sg  "That's not something you can $v for.".
  HAS check_obj2_suitable_for_pl  "Those are not something you can $v for.".
  HAS check_obj_suitable_off_sg   "That's not something you can $v off.".
  HAS check_obj_suitable_off_pl   "Those are not something you can $v off.".
  HAS check_obj_suitable_on_sg    "That's not something you can $v on.".
  HAS check_obj_suitable_on_pl    "Those are not something you can $v on." .
  HAS check_obj_suitable_with_sg  "That's not something you can $v with.".
  HAS check_obj_suitable_with_pl  "Those are not something you can $v with.".
  HAS check_obj2_suitable_with_sg "That's not something you can $v things with.".
  HAS check_obj2_suitable_with_pl "Those are not something you can $v things with.".

  HAS check_obj_suitable_examine_sg "That's not something you can examine.".
  HAS check_obj_suitable_examine_pl "Those are not something you can examine.".

  HAS check_obj_suitable_look_out_sg  "That's not something you can look out of.".
  HAS check_obj_suitable_look_out_pl  "Those are not something you can look out of.".
  HAS check_obj_suitable_look_through "You can't look through $+1.".


  -- Checks for open, closed and locked objects:
  -- -------------------------------------------

  HAS check_obj_not_open_sg   "$+1 is already open.".
  HAS check_obj_not_open_pl   "$+1 are already open.".
  HAS check_obj_open1_sg      "$+1 is already closed.".
  HAS check_obj_open1_pl      "$+1 are already closed.".
  HAS check_obj_open2_sg      "You can't, since $+1 is closed.".
  HAS check_obj_open2_pl      "You can't, since $+1 are closed.".
  HAS check_obj2_open_sg      "You can't, since $+2 is closed.".
  HAS check_obj2_open_pl      "You can't, since $+2 are closed.".
  HAS check_obj_locked_sg     "$+1 is already unlocked.".
  HAS check_obj_locked_pl     "$+1 are already unlocked.".
  HAS check_obj_not_locked_sg "$+1 is already locked.".
  HAS check_obj_not_locked_pl "$+1 are already locked.".



  -- Checks for 'not reachable' and 'distant' objects:
  ----------------------------------------------------

  HAS check_obj_reachable_sg    "$+1 is out of your reach.".
  HAS check_obj_reachable_pl    "$+1 are out of your reach.".
  HAS check_obj2_reachable_sg   "$+2 is out of your reach.".
  HAS check_obj2_reachable_pl   "$+2 are out of your reach.".
  HAS check_obj_reachable_ask   "$+1 can't reach $+2.".
  HAS check_obj_not_distant_sg  "$+1 is too far away.".
  HAS check_obj_not_distant_pl  "$+1 are too far away.".
  HAS check_obj2_not_distant_sg "$+2 is too far away.".
  HAS check_obj2_not_distant_pl "$+2 are too far away.".


  -- Checks for the hero sitting or lying_down:
  ---------------------------------------------

  HAS check_hero_not_sitting1    "It is difficult to $v while sitting down.".
  HAS check_hero_not_sitting2    "It is difficult to $v anything while sitting down.".
  HAS check_hero_not_sitting3    "It is difficult to $v anywhere while sitting down.".
  HAS check_hero_not_sitting4    "You're sitting down already.".
  HAS check_hero_not_lying_down1 "It is difficult to $v while lying down.".
  HAS check_hero_not_lying_down2 "It is difficult to $v anything while lying down.".
  HAS check_hero_not_lying_down3 "It is difficult to $v anywhere while lying down.".
  HAS check_hero_not_lying_down4 "You're lying down already.".


  -- Other attributes checks:
  ---------------------------

  HAS check_act_can_talk_sg "That's not something you can talk to.".
  HAS check_act_can_talk_pl "Those are not something you can talk to.".

  HAS check_obj_allowed_in_sg "$+1 doesn't belong in $+2.".
  HAS check_obj_allowed_in_pl "$+1 don't belong in $+2.".

  HAS check_obj_broken_sg "That doesn't need fixing.".
  HAS check_obj_broken_pl "Those don't need fixing.".

  HAS check_obj_inanimate1 "$+1 wouldn't probably appreciate that.".
  HAS check_obj_inanimate2 "You are not sure whether $+1 would appreciate that.".

  HAS check_obj_movable "It's not possible to $v $+1.".

  HAS check_obj_not_scenery_sg  "$+1 is not important.".
  HAS check_obj_not_scenery_pl  "$+1 are not important.".
  HAS check_obj2_not_scenery_sg "$+2 is not important.".
  HAS check_obj2_not_scenery_pl "$+2 are not important.".

  HAS check_obj_suitable_there  "It's not possible to $v there.".
  HAS check_obj2_suitable_there "It's not possible to $v anything there.".

  HAS check_obj_takeable   "You don't have $+1.".
  HAS check_obj2_takeable1 "You don't have $+2.".
  HAS check_obj2_takeable2 "You can't have $+2.".

  HAS check_obj_weight_sg "$+1 is too heavy to $v.".
  HAS check_obj_weight_pl "$+1 are too heavy to $v.".

  HAS check_obj_writeable "Nothing can be written there.".


  -- b) Location and Containment Checks for Actors and Objects:
  -- ----------------------------------------------------------


  -- Containment checks for actors other than the hero:
  -- --------------------------------------------------

  HAS check_act_near_hero "You don't quite know where $+1 went.
                           You should state a direction where you want to go.".

  HAS check_obj_in_act_sg     "$+2 doesn't have $+1.".
  HAS check_obj_in_act_pl     "$+2 don't have $+1.".
  HAS check_obj_not_in_act_sg "$+2 already has $+1.".
  HAS check_obj_not_in_act_pl "$+2 already have $+1.".


  -- Location and containment checks for the hero:
  ------------------------------------------------

  HAS check_count_weapon_in_hero "You are not carrying any firearms.".

  HAS check_obj_not_at_hero_sg "$+1 is right here.".
  HAS check_obj_not_at_hero_pl "$+1 are right here.".
  HAS check_obj_in_hero        "You don't have $+1.".
  HAS check_obj2_in_hero       "You don't have $+2.".
  HAS check_obj_not_in_hero1   "It doesn't make sense to $v something you're holding.".
  HAS check_obj_not_in_hero2   "You already have $+1.".
  HAS check_obj2_not_in_hero1  "You are carrying $+2.".
  HAS check_obj2_not_in_hero2  "That would be futile.".
  HAS check_obj2_not_in_hero3  "You already have $+2.".


  -- Checking whether an object is in a container or not:
  -- ----------------------------------------------------

  HAS check_cont_not_in_obj    "That doesn't make sense.".
  HAS check_obj_in_cont_sg     "$+1 is not in $+2.".
  HAS check_obj_in_cont_pl     "$+1 are not in $+2.".
  HAS check_obj_not_in_cont_sg "$+1 is already in $+2.".
  HAS check_obj_not_in_cont_pl "$+1 are already in $+2.".
  HAS check_obj_not_in_cont2   "$+1 is already full of $+2.".


  -- Checking whether an object is on a surface or not:
  -- --------------------------------------------------

  HAS check_obj_on_surface_sg     "$+1 is not on $+2.".
  HAS check_obj_on_surface_pl     "$+1 are not on $+2.".
  HAS check_obj_not_on_surface_sg "$+1 is already on $+2.".
  HAS check_obj_not_on_surface_pl "$+1 are already on $+2.".


  -- Checking whether an object is worn or not:
  -- ------------------------------------------

  HAS check_obj_in_worn      "You are not wearing $+1.".
  HAS check_obj_not_in_worn1 "You are already wearing $+1.".
  HAS check_obj_not_in_worn2 "It doesn't make sense to $v something you're wearing.".
  HAS check_obj_not_in_worn3 "You'll have to take off $+1 first.".

  HAS check_obj1_not_worn_by_NPC_sg "Currently $+1 is worn by".
  HAS check_obj1_not_worn_by_NPC_pl "Currently $+1 are worn by".


  -- c) Checking Location States:
  -- ----------------------------

  HAS check_current_loc_lit "It is too dark to see.".


  -- d) Checks against Self-Directed Actions:
  -- ----------------------------------------

  HAS check_obj_not_hero1  "It doesn't make sense to $v yourself.".
  HAS check_obj_not_hero2  "There is no need to be that desperate.".
  HAS check_obj_not_hero3  "That wouldn't accomplish anything.".
  HAS check_obj_not_hero4  "You're right here.".
  HAS check_obj_not_hero5  "You don't need to be freed.".
  HAS check_obj_not_hero6  "There is no time for that now.".
  HAS check_obj_not_hero7  "Turning your head, you notice nothing unusual behind yourself.".
  HAS check_obj_not_hero8  "You notice nothing unusual under yourself.".
  HAS check_obj2_not_hero1 "That doesn't make sense.".
  HAS check_obj2_not_hero2 "That would be futile.".
  HAS check_obj2_not_hero3 "You can't $v things to yourself.".


  -- e) Checks against Using an Object on Itself:
  -- --------------------------------------------

  HAS check_obj_not_obj2_at   "It doesn't make sense to $v something at itself.".
  HAS check_obj_not_obj2_from "It doesn't make sense to $v something from itself.".
  HAS check_obj_not_obj2_in   "It doesn't make sense to $v something into itself.".
  HAS check_obj_not_obj2_on   "It doesn't make sense to $v something onto itself.".
  HAS check_obj_not_obj2_to   "It doesn't make sense to $v something to itself.".
  HAS check_obj_not_obj2_with "It doesn't make sense to $v something with itself.".
  HAS check_obj_not_obj2_put  "That doesn't make sense." .


  -- f) Additional Checks for Classes:
  -- ---------------------------------

  HAS check_clothing_sex "On second thoughts you decide $+1 won't really suit you.".

  HAS check_cont_not_supporter "You can't put $+1 inside $+2.".

  HAS check_device_on_sg     "$+1 is already off.".
  HAS check_device_on_pl     "$+1 are already off.".
  HAS check_device_not_on_sg "$+1 is already on.".
  HAS check_device_not_on_pl "$+1 are already on.".

  HAS check_door_matching_key "You can't use $+2 to $v $+1.".

  HAS check_lightsource_lit_sg        "But $+1 is not lit.".
  HAS check_lightsource_lit_pl        "But $+1 are not lit.".
  HAS check_lightsource_not_lit_sg    "$+1 is already lit.".
  HAS check_lightsource_not_lit_pl    "$+1 are already lit.".
  HAS check_lightsource_switchable_sg "That's not something you can switch on and off." .
  HAS check_lightsource_switchable_pl "Those are not something you can switch on and off.".

  HAS check_liquid_vessel_not_cont "You can't carry $+1 around in your bare hands.".

  HAS check_obj_not_broken "Nothing happens.".


  -- IMPLICIT TAKING MESSAGES:
  -- =========================

  HAS implicit_taking_message "(taking $+1 first)$n".

  -- The following verbs are preceded by implicit taking:
  --    bite, drink, eat, empty, empty_in, empty_on, give, pour, pour_in,
  --    pour_on, put_in, put_on, throw, throw_at, throw_in, throw_to, tie_to.

  -- In ditransitive verbs, only the first parameter (the direct object) is
  -- taken implicitly. For example:
  --    >push door with pole
  -- won't work if the hero is not carrying the pole.

END ADD TO definition_block.

-- end of file.
