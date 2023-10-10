extends Node

# this file holds enum's for various states used for various levels of game flow logic
# this script is used in AutoLoad to have these constants available to all scripts
# References: https://docs.godotengine.org/en/3.0/getting_started/step_by_step/singletons_autoload.html

# used in MainScene for game, round, and turn
enum game {CONFIG, SETUP, PLAYING, END}
enum puzzle_round {START, PLAYING, END}
enum turn {START, SPIN, GUESS, SOLVE, CORRECT, END}

# used in Puzzle for creating and managing the puzzle board
enum puzzle {STATE_EMPTY, STATE_PLAYING, STATE_SOLVE, STATE_GAMEOVER}

# used in Tile for managing tile state behavior
enum tile {STATE_EMPTY, STATE_HIDDEN, STATE_HIGHLIGHT, STATE_SHOW, STATE_BKGD}
