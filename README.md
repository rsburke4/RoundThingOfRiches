# Wheel of Fortune

Class group project for "Foundations of Software Engineering" course.

Gameplay is based on the Wheel of Fortune TV game show; specific rules are below.

The game is intended to be played on a single computer, with all elements managed by a moderator.  This makes it useful for in-person settings, such as a classroom with the teacher as the moderator, or virtual meetings, such as an ice breaker activity for remote teams.  See below on how to launch and manage the game.

NOTE: outline based off assignment requirements.  TBD indicates where updates are needed as the project progresses (i.e., add credits once code using it has been approved so as not to lose track).  Text in **bold** is tentative and should be updated to reflect implementation, when finalized.  Formatting may be changed/polished as part of creating the final draft.

# Game objective and rules

(Game rules have been adopted from the TV game show rules, which are summarized [here](https://roulettedoc.com/wof-rules).)

## Objective

Accumulate money during a round by making correct guesses of letters in a phrase.  The round ends when a player/team solves the puzzle; only the winning player/team is awarded their earned money at the end of the round.

After the specified number of rounds, the player/team which has was the highest amount of money wins!

## Rules

After selecting the number of players/teams participating, **and the number of rounds**, the game will **randomly select** a player to go first in the first round.

### Round play

1. Starting player spins the wheel.
2. Based on the space it lands on:
	* Dollar value: player may guess a consonant for the dollar amount shown on the wheel; play continues if the consonant appears and passes to next player if it does not
	* Bankrupt: player loses all money; play passes to next player
	* Lose a turn: no penalty for current player; play passes to next player
	* **Free play**: player may guess a consonant for $500 or a vowel for free; player's turn continues, even if wrong
3. A player that correctly guesses a consonant that appears in the puzzle:
	* Earns money for each consonant (e.g. if on $500 and guess "T" for a puzzle that contains 2 T's, they earn $1000 toward their total score for the round)
	* May opt to buy any number of vowels for $250 per guess; this costs $250 no matter how many of each guess appear (e.g. it will cost $250 if the puzzle contains 1 "A" or multiple.
	* Can try to solve the puzzle
	* May spin the wheel again to make another guess (step 2)
4. The player's turn ends by an incorrect guess or landing on the "Bankrupt" or "Lose a turn" spaces
5. Play continues by rotating through players until the puzzle is solved (steps 1-3)
6. The player who solves the puzzle wins the money they have earned.  All other players get $0 for the round.

Play continues until all rounds have been completed.  The player with the highest score is the winner.

### Other rules

1. Each puzzle will be accompanied by a category that gives a clue or hint about the solution
2. Players will not be allowed to buy a vowel if the puzzle no longer contains vowels
3. Players can only buy vowels once all consonants in the puzzle have been guessed
4. Puzzles may only be solved after guessing a correct letter (that is, a player cannot solve the puzzle without either spinning the wheel and making a (correct) guess or buying a (correct) vowel
5. Minimum round winning is $1000 (e.g., if the player who solves the puzzle has $750, they are awarded $1000 for the round)
6. Letters which have already been guessed are displayed on the game dashboard.  A player who guesses a letter that has already been guessed (whether it is in the puzzle or not) loses their turn.

# Technology stack used

Game created using [Godot game engine](https://godotengine.org/).

# Setup and deployment

1. TBD (website and other setup steps, if necessary)
2. TBD (steps for host to moderate game)

# Credits

## 3rd-party Assets

* Wheel Answers Come from [DataGrabber's previous scrape of a Wheel of Fortune Facebook game](
https://www.datagrabber.org/wheel-of-fortune-facebook-game/wheel-of-fortune-cheat-answer/)

A truncated version of the HTML containing the table is saved in res://WebScraper/

## Code snippets

* [Using AutoLoad for constants](https://docs.godotengine.org/en/3.0/getting_started/step_by_step/singletons_autoload.html)
* [Setting styles for components](https://www.reddit.com/r/godot/comments/12zh2qq/godot_40_why_wont_my_ui_panel_stylebox_overwrite/)
  ```
  var stylebox_active = get_theme_stylebox("normal").duplicate()
  style.<property> = <new value>
  add_theme_stylebox_override("normal", stylebox_active)
  ```
* [Translating between ASCII code and character (used in GuessTracker)](https://ask.godotengine.org/106152/convert-an-character-to-ascii-value)
  ```
  var ascii = <string>.unicode_at(0)  # ASCII code for first character of <string>
  button_i.text = char(start_ascii + i)  # convert ASCII code to character
  ```
* [Parsing JSON file (used in PuzzleBoard)](https://docs.godotengine.org/en/stable/classes/class_json.html)
  ```
  var json = JSON.new()
  var raw_data = FileAccess.get_file_as_string(<filename>)
  var all_answers = json.parse_string(raw_data)
  ```

# Reflection: Design and development process

(Challenges, what worked/didn't work, lessons learned --> 500 words)
