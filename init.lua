soundblocks = 0
soundblocks_onoff = 0
 
minetest.register_node("audioguide:audio_blue", {
    description = "Audioguide Block Blue",
    tiles = {"audio_blue.png"},
    groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
        on_rightclick = function(pos, node, player, itemstack, pointed_thing)
            if soundblocks_onoff == 0 then
                soundblocks_onoff = 1
                soundblocks = minetest.sound_play("audio_blue", { --name of sound, file name extension is .ogg
                    pos = pos, --pos where sound comes from
                    gain = 1.0,
                    max_hear_distance = 32,
                    loop = true,}) --sound gets lower the farer you get away from the jukebox
            else
                minetest.sound_stop(soundblocks)
                soundblocks_onoff=0
            end
end})

 
minetest.register_node("audioguide:audio_brown", {
    description = "Audioguide Block Brown",
    tiles = {"audio_brown.png"},
    groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
        on_rightclick = function(pos, node, player, itemstack, pointed_thing)
            if soundblocks_onoff == 0 then
                soundblocks_onoff = 1
                soundblocks = minetest.sound_play("audio_brown", { --name of sound, file name extension is .ogg
                    pos = pos, --pos where sound comes from
                    gain = 1.0,
                    max_hear_distance = 32,
                    loop = true,}) --sound gets lower the farer you get away from the jukebox
            else
                minetest.sound_stop(soundblocks)
                soundblocks_onoff=0
            end
end})


 
minetest.register_node("audioguide:audio_pink", {
    description = "Audioguide Block Pink",
    tiles = {"audio_pink.png"},
    groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
        on_rightclick = function(pos, node, player, itemstack, pointed_thing)
            if soundblocks_onoff == 0 then
                soundblocks_onoff = 1
                soundblocks = minetest.sound_play("audio_pink", { --name of sound, file name extension is .ogg
                    pos = pos, --pos where sound comes from
                    gain = 1.0,
                    max_hear_distance = 32,
                    loop = true,}) --sound gets lower the farer you get away from the jukebox
            else
                minetest.sound_stop(soundblocks)
                soundblocks_onoff=0
            end
end})


 
minetest.register_node("audioguide:audio_red", {
    description = "Audioguide Block Red",
    tiles = {"audio_red.png"},
    groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
        on_rightclick = function(pos, node, player, itemstack, pointed_thing)
            if soundblocks_onoff == 0 then
                soundblocks_onoff = 1
                soundblocks = minetest.sound_play("audio_red", { --name of sound, file name extension is .ogg
                    pos = pos, --pos where sound comes from
                    gain = 1.0,
                    max_hear_distance = 32,
                    loop = true,}) --sound gets lower the farer you get away from the jukebox
            else
                minetest.sound_stop(soundblocks)
                soundblocks_onoff=0
            end
end})
