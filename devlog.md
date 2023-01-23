# Devlog

## Are devlogs important?
### 2023.01.20

Idk if it's important to collect my thoughts, but here they are for now
* I started this project a few days ago, I like the concept of a simple RPG to help me understand how those mechanics might work in Godot
* I want to try to build classes with appropriate inheritance and composition, and make decent structural decisions that might be scalable
* I thought a low res rpg about a dot might be cool, screen resolution 64x36
* I'm going to double the res to make it easier to use the godot controls (mostly buttons) since then hopefully I can make it so that they don't overlap

### 2023.01.21
* things are looking better with new buttons
* I got a battle screen semi-functional
* I got a stats and level up screen kinda working
* I need to set up enemies fighting back
* I need to set up the level up system (exp? number of enemies?)
* I need to fix up the theme for the link buttons on the pause menu (or turn them into buttons)
* I need to set a better control for the stat menu
* I need to make the enemies move around the map
* I need to make more enemies
* I need to make the enemies spawn in and spawn out
* I need to be able to win, lose, and restart

### 2023.01.22
* changed the link buttons on pause menu to regular buttons
* added enemy turns after hero takes turn
* added a gameover / restart screen

### 2023.01.23
-[ ] itch.io page
-[ ] update github actions to deploy to itch
-[x] create enemy spawner
    -[ ] add limit to enemy spawner
    -[ ] make enemies despawn after a bit
-[ ] create more types of enemies
-[ ] create win condition
-[ ] first balance pass to make the game winnable
-[ ] update spawner to progressively spawn harder enemies
-[ ] customize enemy attacks
-[ ] customize enemy pathing on map
-[ ] add signifier to battle screen to show what the enemy does