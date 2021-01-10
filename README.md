# TicTacToe App

TicTacToe is a simple TicTacToe App written in FreePascal and meant to be compiled using Lazarus IDE.

## v1

The v1 of TicTacToe allows a player to challenge the computer in a fierce TicTacToe game

### Features
- Launching the TicTacToe executable shall allow a player to play a TicTacToe game against the computer
- The first player (can be changed by selecting the first player to be X or O) will start the game
- Each player can select a non-occupied cell to play his turn
- The game ends when one player can align three symbols (player wins), or when the board is filled with no winner (draw)
- The app keeps track of the score, based on the result of the games, as long as the players do not reset the score or close the app
- Players can start a new game whenever they want

### Tests
Tests are run via FPCunit tests

- In continuous integration with travis for "master" branch, is only tested :
  - correct compilation of app in each platform
  
- In branch "local_test" are tested (only locally run since the use of MessageBox in the game require user interaction) :
  - correct behavior of Gameplay function when three identical symbols are aligned (row, column, or diagonal)
  - correct behavior when first player is changed
  - correct behavior when selecting already occupied cell
  - correct behavior when new game is selected
  - correct behavior when the score is reset
  - ~~right outcomes of simulated games~~ simulated games approach dismissed since autoplay is integrated to v1