soundblocks_lk1 = 0
soundblocks_lk1_onoff = 0
 
minetest.register_node("audioguide:audioguideblocklk1", {
    description = "Audioguide Block Lk1",
    tiles = {"audioguide_lk1z.png"},
    groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
        on_rightclick = function(pos, node, player, itemstack, pointed_thing)
            if soundblocks_lk1_onoff == 0 then
                soundblocks_lk1_onoff = 1
                soundblocks_lk1 = minetest.sound_play("audioguide_lk1zacharias", { --name of sound, file name extension is .ogg
                    pos = pos, --pos where sound comes from
                    gain = 1.0,
                    max_hear_distance = 32}) --sound gets lower the farer you get away from the jukebox
            else
                minetest.sound_stop(soundblocks_lk1)
                soundblocks_lk1_onoff=0
            end
end})
