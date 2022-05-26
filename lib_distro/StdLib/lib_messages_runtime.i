-- lib_messages_runtime.i     | ALAN Standard Library v2.2.0-WIP | ALAN 3.0beta8
--+============================================================================+
--|\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////////|
--++--------------------------------------------------------------------------++
--||                                                                          ||
--||                    R U N - T I M E   M E S S A G E S                     ||
--||                                                                          ||
--++--------------------------------------------------------------------------++
--|//////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\|
--+============================================================================+

-- This library module contains all of the ALAN runtime messages, either adapted
-- to the library needs, or in their original form. This simplifies the task of
-- customizing the messages to meet the demands of any adventure: to do so, just
-- edit this file according to needs.

-- To simplify lookup, message definitions have been grouped by category.

--------------------------------------------------------------------------------

MESSAGE

  MORE: "<More>"

-- =============================================================================

-- DESCRIBING LOCATIONS

-- =============================================================================

  AGAIN: ""

  SEE_START:
    IF parameter1 IS NOT plural
      THEN "There is $01"
      ELSE "There are $01"
    END IF.
  SEE_COMMA: ", $01"
  SEE_AND: "and $01"
  SEE_END: "here."

-- =============================================================================

-- LISTING CONTAINERS' CONTENTS

-- =============================================================================

-- These messages are used when listing the contents of containers, which can be
-- either container objects or actors.

  CARRIES:
    IF parameter1 IS NOT plural
      THEN "$+1 is carrying"
      ELSE "$+1 are carrying"
    END IF.

  CONTAINS:
    IF parameter1 IS NOT plural
      THEN "$+1 contains"
      ELSE "$+1 contain"
    END IF.

  -- The IF blocks in the following group of messages adds "(being worn)" after
  -- every item worn by an actor, when using `LIST actor`. The library uses the
  -- `worn` attribute only for clothing instances, but authors are free to
  -- create custom wearable items (e.g. headphones, VR headset devices, etc.).

  CONTAINS_COMMA: "$01"
    IF parameter1 IsA thing THEN
      IF parameter1 IS worn
        THEN "(being worn)"
      END IF.
    END IF.
    "$$,"
  CONTAINS_AND: "$01"
    IF parameter1 IsA thing THEN
      IF parameter1 IS worn
        THEN "(being worn)"
      END IF.
    END IF.  "and"
  CONTAINS_END: "$01"
    IF parameter1 IsA thing THEN
      IF parameter1 IS worn
        THEN "(being worn)"
      END IF.
    END IF. "."

  IS_EMPTY:
    IF parameter1 IS NOT plural
      THEN "$+1 is empty."
      ELSE "$+1 are empty."
    END IF.

  EMPTY_HANDED:
    IF parameter1 IS NOT plural
      THEN "$+1 is empty-handed."
      ELSE "$+1 are empty-handed."
    END IF.

-- =============================================================================

-- GAMEPLAY META-COMMANDS MESSAGES

-- =============================================================================

  HAVE_SCORED: "You have scored $1 points out of $2."
  NOT_A_SAVEFILE: "That file does not seem to be an Alan game save file."
  NO_UNDO: "No further undo available."
  QUIT_ACTION: "Do you want to RESTART, RESTORE, QUIT or UNDO? "
    -- NB These four choices are hardwired into the interpreter and can't be
    -- changed. Therefore, the QUIT_ACTION message should always mention these
    -- four commands as they are.
  REALLY: "Are you sure (press ENTER to confirm)?"
  RESTORE_FROM: "Enter file name to restore from"
  SAVE_FAILED: "Sorry, save failed."
  SAVE_MISSING: "Sorry, could not open the save file."
  SAVE_NAME: "Sorry, the save file did not contain a save for this adventure."
  SAVE_OVERWRITE: "That file already exists, overwrite (y)?"
  SAVE_VERSION: "Sorry, the save file was created by a different version."
  SAVE_WHERE: "Enter file name to save in"
  UNDONE: "'$1' undone."

-- =============================================================================

-- MALFORMED PLAYER INPUT ERROR MESSAGES

-- =============================================================================

-- The following messages deal with responses to malformed player commands.

  AFTER_BUT: "You must give at least one object after '$1'."
  BUT_ALL: "You can only use '$1' AFTER '$2'."
  IMPOSSIBLE_WITH: "That's impossible with $+1."
  MULTIPLE: "You can't refer to multiple objects with '$v'."
  NOT_MUCH: "That doesn't leave much to $v!"
  NOUN: "You must supply a noun."
  UNKNOWN_WORD: "I don't know the word '$1'."
  WHAT: "That was not understood."
  WHAT_WORD: "It is not clear what you mean by '$1'."

-- =============================================================================

-- PLAYER INPUT DISAMBIGUATION MESSAGES

-- =============================================================================

  WHICH_PRONOUN_START: "It is not clear if you by '$1'"
  WHICH_PRONOUN_FIRST: "mean $+1"

  WHICH_START: "It is not clear if you mean $+1"

  WHICH_COMMA: ", $+1"
  WHICH_OR: "or $+1."

-- =============================================================================

-- IMPOSSIBLE ACTIONS RESPONSES

-- =============================================================================

  CANT0: "You can't do that."  -- NB The last char is a zero, not an 'o'.
  NO_SUCH: "You can't see any $1 here."
  NO_WAY: "You can't go that way."

  CAN_NOT_CONTAIN: "$+1 can not contain $+2."
  CONTAINMENT_LOOP:
    "Putting $+1 in"
      IF parameter1 IS NOT plural
        THEN "itself"
        ELSE "themselves"
      END IF.
    "is impossible."
  CONTAINMENT_LOOP2: "Putting $+1 in $+2 is impossible since $+2"
    IF parameter2 IS NOT plural
      THEN "is"
      ELSE "are"
    END IF.
    "already inside $+1."


-- end of file.
