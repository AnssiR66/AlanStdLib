This is the Alan Standard Library v2.1

Alan is an easy-to-use adventure text authoring tool, and this library
makes using it even easier.

The library consists of one top level file (library.i) which in turn
imports the five files:

- lib_classes.i
- lib_definitions.i
- lib_locations.i
- lib_messages.i
- lib_verbs.i

Other files in this distribution package are:

- ALAN Library 2.1 manual (a PDF file)
- Changelog (a txt file)
- Copying (a txt file about copyright issues)
- mygame_import.i: use this file to easily edit all verb outcomes,
    verb check messages and illegal parameter messages
- newgame.alan: a basic, barebone game source file which you can use as a
    starting point for a new game
- newgame.a3c: the compiled game file based on the above
- QuickRef (a text file listing briefly the various things possible to
    accomplish with the library)
- readme.txt (this file)
- testgame.alan (a short sample game source file)
- testgame.a3c (the compiled testgame, to test various features of the library)


Acknowledgements: Thanks to Thomas Nilsson and Göran Forslund for
ALAN. Also thanks to Thomas for continous and patient support and
encouragement throughout the project. Thanks to Steve Griffiths 
for the Score notification code snippet. Thanks to Alan Bampton for the
'xwear.i' extension which has been assimilated in this library.



General features:

- the library consists of five files: lib_classes.i, lib_definitions.i, lib_locations.i,
  lib_messages.i and lib_verbs.i.

- lib_classes.i defines various object and actor classes

- lib_definitions.i defines default illegal parameter messages and verb check messages 
  together with some other basic messages

- lib_locations.i defines the default directions (exits) and also various
  location classes and attributes

- lib_messages.i lists all the standard runtime messages in the ALAN
  system, for easy editing

- lib_verbs.i lists all the default verbs needed in gameplay. Also commands other than verbs are
  here, such as 'inventory' and 'about'

- in labeling parameters in syntax statements, tailored (mnemonic)
  parameters are used as much as possible to ease up code-reading and
  for clearer intention-revealing: e.g. eat (food), kill (victim) with
  (weapon), push (obj) with (instr)  

- objects are implicitly taken if they are not carried already and
  if they pass all the usual checks: e.g. 'eat apple' -> (taking the
  apple first) You eat the apple.

- Alan Bamptons 'xwear' extension has been assimilated, disallowing
  clothes to be put on or taken off in an improper oder, e.g. you
  can't put on a shirt if you are wearing a jacket, etc.

- Steve Griffiths's score notification code has been assimilated. You
  can disable score change messages through the 'notify' command

- liquid handling should now be quite thorough:

- taking a liquid will take the container of the liquid
  automatically. Both 'take juice' and 'take bottle' have the same
  effect.

    > take juice
    (the bottle of juice) Taken.

  In the same way, 'pour' (but not 'empty') works for both liquids and
  containers ('empty' only works for containers):

    > pour bottle on floor
    You pour the contents of the bottle onto the floor.

    > pour juice on floor
    You pour the juice on the floor.

    > empty juice on floor
    You can only empty containers.

- also it is possible make mixtures: commands like 'pour blue potion
  in red potion' are possible

- actors have postures standing (the default), sitting and lying_down,
  with checks disabling many actions when sitting or lying_down.

- in a dark_location, actions requiring seeing are disabled.

- distant and not reachable objects cannot be manipulated (through the attributes
  '(NOT) reachable' and 'distant'. It is still possible to talk with a not reachable person
   and throw something in/at a not reachable target, plus certain other cases

- NPCs will automatically follow the hero if they are given the
  attribute 'following'.

- some verbs accept new syntax: it is possible to say both 'look at
  object' and 'look object', and the verb 'switch' (without 'on' or
  'off') will switch an object on if it is off, and vice versa.

- plural handling is implemented throughout the library (e.g. 'You
  see nothing special about the door(s). It is (They are) currently
  closed' etc.)

- optional classes for indoor and outdoor locations: all indoor
  locations (rooms) automatically have floor, walls and ceiling, and
  all outdoor locations have ground and sky.

- several object classes: lightsource, supporter, weapon, sound, door, window...

+ lots more. See for yourself and have fun!


Comments and questions, any kind of feedback is welcome, even crucial for further improvements.


Send your feedback to the e-mail address given at the www.alanif.se website, or to

anssir66@hotmail.com
