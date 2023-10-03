# Purpose of AudioNode Minetest Mod

Allows you to set audio blocks in your minetest world and set on each of them one audiofile to be played.

## Audiofiles

You can only use #.ogg" files. They must be available in the directory "sounds" within the mods directory when the server is started.

## Setting Audio Files

1. You need the audionode privilege to set or delete  audiofiles on audionode blocks.
1. Place an audionode in your world.
1. Left-Click the audionode block => the shown window pops up.
1. Select the file you want to play on this block.
1. Use the
   1. Set button to set the audio file to this audio node.
   1. Listen button to just listen to the asociated audio file for this block.
   1. Delete button to remove the audio file from this node.
   1. Esc key to not change anything.

![Window to select audio file in minetest](readme_images/audioNodeScreen.png)

## Listeing to Audio on audionode Blocks

Most users will not have the audionode privilege. They simply have to right-click on the audionode to start the audio file associated to that block.