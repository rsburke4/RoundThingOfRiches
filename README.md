# Round Thing of Riches

Class group project for "Foundations of Software Engineering" course.

Gameplay is based on the Wheel of Fortune TV game show; specific rules are below.

The game is intended to be played on a single computer, with all elements managed by a moderator.  This makes it useful for in-person settings, such as a classroom with the teacher as the moderator, or virtual meetings, such as an ice breaker activity for remote teams.  See below on how to launch and manage the game.

# Game objective and rules

(Game rules have been adopted from the TV game show rules, which are summarized [here](https://roulettedoc.com/wof-rules).)

## Objective

Accumulate money during a round by making correct guesses of letters in a phrase.  The round ends when a player/team solves the puzzle; only the winning player/team is awarded their earned money at the end of the round.

After the specified number of rounds, the player/team which has was the highest amount of money wins!

## Rules

After selecting the number of players/teams participating and the number of rounds, the game will start the first round with player 1, the second round with player 2, etc.

### Round play

1. Starting player spins the wheel.
2. Based on the space it lands on:
	* Dollar value: player may guess a consonant for the dollar amount shown on the wheel; play continues if the consonant appears and passes to next player if it does not
	* Bankrupt: player loses all money; play passes to next player
	* Lose a turn: no penalty for current player; play passes to next player
	* Free play: player may guess a consonant for $500, a vowel for free, or try to solve the puzzle; player's turn continues, even if wrong
3. A player that correctly guesses a consonant that appears in the puzzle:
	* Earns money for each of the guessed consonant that appears in the puzzle (e.g. if on $500 and guess "T" for a puzzle that contains 2 T's, they earn $1000 toward their total score for the round)
	* May then opt to buy any number of vowels for $250 per guess (e.g. it will cost $250 if the puzzle contains 1 "A" or multiple)
	* Can try to solve the puzzle after making a correct letter guess
	* May spin the wheel again to make another guess (step 2)
4. The player's turn ends by an incorrect guess (letter or solution) or landing on the "Bankrupt" or "Lose a turn" spaces
5. Play continues by rotating through players until the puzzle is solved (steps 1-3)
6. The player who solves the puzzle wins the money they have earned.  All other players get $0 for the round.

Play continues until all rounds have been completed.  The player with the highest score at the end of the game is the winner.  See below for note on tie breaker scenario.

### Other rules

1. Each puzzle will be accompanied by a category that gives a clue or hint about the solution
2. Players will not be allowed to buy a vowel if the puzzle no longer contains vowels
3. Players will be allowed to only buy vowels once all consonants in the puzzle have been guessed
4. Puzzles may only be solved after guessing a correct letter (that is, a player cannot solve the puzzle without either spinning the wheel and making a (correct) guess or buying a (correct) vowel
5. Minimum round winning is $1000 (e.g., if the player who solves the puzzle has $750, they are awarded $1000 for the round)
6. Letters which have already been guessed will be unavailble on the game dashboard so it is not possible to re-guess a letter
7. When only vowels are left in the puzzle, players do not have to spin the wheel.  They may guess a vowel (if they have >$250) or try to solve.
8. When a tie occurs, the two players who tie will take part in a one-round tie breaker game.  The winner of this round wins the game.

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

* Font: [Lilita One](https://fonts.google.com/specimen/Lilita+One?classification=Display&stroke=Sans+Serif&sort=popularity&preview.text=ABCDEFGHIJK&preview.text_type=custom) (Google Fonts)

* Tools for deployment to GitHub pages:
  - [Guide for deployment](https://www.reddit.com/r/godot/comments/10buva4/github_action_to_deploy_a_godot_4_game/?rdt=39430)
  - [Tool for deployment](https://gist.github.com/Dams4K/0485cbc874a04030eac8cf0e40c730ac)
  - [Tool for deployment](https://github.com/gzuidhof/coi-serviceworker)

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

The biggest challenges we faced during this project were related to inexperience with the tech stack and tools we opted to use.  Most members of the team had limited prior experience with Git and Godot and had to ramp-up knowledge to be able to use these effectively in implementing the game.  Similarly, the effectiveness of using Teams for collaboration in a remote setting was reduced due to a prior lack of experience of most team members in such an environment.  There was also a lack of experience across the team in using GitHub Pages for deploying the game.  Although these are identified as challenges, we were able to successfully overcome all of them and produce a game that met all of our stated objectives.

As a team, we identified several things that helped us work better together, and a handful of things that detracted from our teamwork.  Performing planning of the game upfront, and creating a weekly schedule for implementation, helped us see the game from a higher level and break down each part to manageable pieces.  Holding weekly update meetings were helpful for tracking progress and making adjustments to the development plan.  Furthermore, the team agreed on an approach for using GitHub for version control by creating feature branches and merging to the main branch on completion, which reduced the number of merge conflicts we encountered.  Despite creating a product following the original plan, we ran into some problems from not adapting appropriate tools for project tracking.  It was easy to forget about the weekly meetings because there was no calendar event created for the meeting, and it was easy to lose track of assigned tasks as we did not use a project board or other means for tracking progress on the assignment.  Furthermore, we ran into problems by assigning tasks without taking prior experience or pace of working of developers as individuals.

We summarized the above observations into three lessons learned from this experiences.  First, the time and effort put into planning the game up front, and holding weekly progress meetings, helped us complete the majority of the game before the due date.  Next, including a scoping activity during the planning stage helped us identify what to place the highest priority on during implementation.  Finally, it is beneficial to discuss with each developer their prior experience with the tech stack to avoid assigning too many tasks to developers who are still ramping up on it.
