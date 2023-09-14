soundblocks = 0
soundblocks_onoff = 0


function get_formspec()
    local text = "Pick an audiofile for this node:"

    local formspec = {
        "formspec_version[4]",
        "size[6,3.476]",
        "label[0.375,0.5;", minetest.formspec_escape(text), "]",
        "field[0.375,1.25;5.25,0.8;number;Number;]",
        "button[1.5,2.3;3,0.8;guess;Guess]"
    }

    return table.concat(formspec, "")
end


minetest.register_node("audioguide:audio_blue", {
    description = "Audioguide Block Blue",
    tiles = {"audio_blue.png"},
    groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
    --oggEnding = ".ogg"
    --mp3Ending = ".mp3"
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
        local formspec = "textlist[0,0;7,5;mydir_list;"
        local files = minetest.get_dir_list(minetest.get_modpath("audioguide") .. '/sounds', false)
        local empty = true
        for i = 1, #files do
            if files[i]:sub(-4) == ".ogg" then
                if not empty then
                    formspec = formspec .. ","
                end
                formspec = formspec .. files[i]
                empty = false
            end
        end
        formspec = formspec .. ";0;false]"
        print("n: " .. player:get_player_name() .. ", f: " .. formspec)

        minetest.show_formspec(player:get_player_name(), "audioguide:files", "textlist[0,0;7,5;noname;'eins','zwei','drei';1;false")

        if soundblocks_onoff == 0 then
            soundblocks_onoff = 1
            soundblocks = minetest.sound_play("audio_blue", { --name of sound, file name extension is .ogg
                pos = pos, --pos where sound comes from
                gain = 1.0,
                max_hear_distance = 32,
                loop = false,}) --sound gets lower the farer you get away from the jukebox
        else
            minetest.sound_stop(soundblocks)
            soundblocks_onoff=0
        end
    end
})

 
minetest.register_node("audioguide:audio_brown", {
    description = "Audioguide Block Brown",
    tiles = {"audio_brown.png"},

    groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
        on_rightclick = function(pos, node, player, itemstack, pointed_thing)
            local formspec = get_formspec()
            minetest.show_formspec(player:get_player_name(), "audioguide:files", formspec)

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