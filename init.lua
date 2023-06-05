soundblocks = 0
soundblocks_onoff = 0
 
minetest.register_node("audioguide:audioblock", {
    description = "Audioguide Block",
    tiles = {"audioblock.png"},
    groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
        on_rightclick = function(pos, node, player, itemstack, pointed_thing)
            if soundblocks_onoff == 0 then
                soundblocks_onoff = 1
                soundblocks = minetest.sound_play("audio", { --name of sound, file name extension is .ogg
                    pos = pos, --pos where sound comes from
                    gain = 1.0,
                    max_hear_distance = 32,
                    loop = true,}) --sound gets lower the farer you get away from the jukebox
            else
                minetest.sound_stop(soundblocks)
                soundblocks_onoff=0
            end
end})
