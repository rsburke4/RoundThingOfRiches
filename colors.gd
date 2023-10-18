extends Node

# This file contains color definitions that can be referenced throughout the 
# component code, so that any changes to the pallette can be made in one place
# (here) and propagate throughout the code

# Puzzle and tile colors
var COLOR_PUZZLE_BKGD = Color(0.2, 0.41, 0.41, 1)  # background for the puzzle board
var COLOR_PUZZLE_BKGD_WRONG_GUESS = Color(0.81, 0.29, 0.41, 1)  # background to flash when a guess is wrong

var COLOR_CATEGORY_TEXT = Color(0.6, 0.79, 0.45, 1)
var COLOR_CATEGORY_TEXT_OUTLINE = Color(0.44, 0.67, 0.68, 1)

var COLOR_TILE_LIT = Color(0.9, 0.9, 0.9, 1)  # indicates letters in the puzzle
var COLOR_TILE_HILITE = Color(0.81, 0.92, 0.68, 1)  # temporary color change before revealing letter
var COLOR_TILE_EMPTY = Color(0.13, 0.71, 0.57, 1)  # default tile color

# Guess tracker button colors: for states "active," "disabled," and "hovered
var COLOR_BUTTON_ACTiVE_BKGD = Color(0.31, 0.55, 0.49, 1)
var COLOR_BUTTON_ACTIVE_BORDER = Color(0.64, 0.82, 0.75, 1)
var COLOR_BUTTON_ACTIVE_TEXT = Color(0.96, 0.8, 0.34)

var COLOR_BUTTON_DISABLED_BKGD = Color(0.64, 0.82, 0.75, 1)
var COLOR_BUTTON_DISABLED_BORDER = Color(0.38, 0.81, 0.64, 1)
var COLOR_BUTTON_DISABLED_TEXT = Color(0.95, 0.81, 0.48, 1)

var COLOR_BUTTON_HOVERED_BKGD = Color(0.02, 0.67, 0.6, 1)
var COLOR_BUTTON_HOVERED_BORDER = Color(0.75, 0.83, 0.66, 1)
var COLOR_BUTTON_HOVERED_TEXT = Color(0.96, 0.49, 0.01)

# use different colors for the submit button (same states)
var COLOR_SOLVE_BTN_ACTiVE_BKGD = Color(0.61, 0.44, 0.62, 1)
var COLOR_SOLVE_BTN_ACTIVE_BORDER = Color(0.4, 0.73, 0.76, 1)
var COLOR_SOLVE_BTN_ACTIVE_TEXT = Color(0.89, 0.97, 0.75, 1)

# pressed state is used in place of disabled since this button can toggle
var COLOR_SOLVE_BTN_PRESSED_BKGD = Color(0.2, 0.35, 0.43, 1)
var COLOR_SOLVE_BTN_PRESSED_BORDER = Color(0.6, 0.77, 0.79, 1)
var COLOR_SOLVE_BTN_PRESSED_TEXT = Color(0.98, 0.68, 0.64, 1)

var COLOR_SOLVE_BTN_HOVERED_BKGD = Color(0.85, 0.81, 0.95, 1)
var COLOR_SOLVE_BTN_HOVERED_BORDER = Color(0.66, 0.75, 0.7, 1)
var COLOR_SOLVE_BTN_HOVERED_TEXT = Color(0.4, 0.65, 0.64, 1)

# score colors
var COLOR_SCORE_BKGD_ACTIVE_PLAYER1 = Color(0.73, 0.19, 0.43, 1)
var COLOR_SCORE_BKGD_ACTIVE_PLAYER2 = Color(0.62, 0.73, 0.49, 1)
var COLOR_SCORE_BKGD_ACTIVE_PLAYER3 = Color(0.17, 0.62, 0.62, 1)

var COLOR_SCORE_BKGD_INACTIVE_PLAYER1 = Color(0.5, 0.5, 0.5, 1)
var COLOR_SCORE_BKGD_INACTIVE_PLAYER2 = Color(0.5, 0.5, 0.5, 1)
var COLOR_SCORE_BKGD_INACTIVE_PLAYER3 = Color(0.5, 0.5, 0.5, 1)

var COLOR_SCORE_TEXT_PLAYER1 = Color(0, 0, 0, 1)
var COLOR_SCORE_TEXT_PLAYER2 = Color(0, 0, 0, 1)
var COLOR_SCORE_TEXT_PLAYER3 = Color(0, 0, 0, 1)

# general colors
var COLOR_HIDDEN = Color(1,1,1,0)  # this can be used for elements that are needed for alignment but should not be visible (transparent)
