soundblocks = 0
soundblocks_onoff = 0


function get_formspec()
    local text = "Pick an audiofile for this node:"

    local files = minetest.get_dir_list(minetest.get_modpath("audionode") .. '/sounds', false)
    local filestext = ""
    local first_file = true
    for i = 1, #files do
        if files[i]:sub(-4) == ".ogg" then
            if not first_file then
                filestext = filestext .. ","
            end
            filestext = filestext .. files[i]
            first_file = false
        end
    end


    local formspec = {
        "formspec_version[4]",
        "size[8,5]",
        "label[0.375,0.5;", minetest.formspec_escape(text), "]",
        "textlist[0.375,0.75;7,4;mydir_list;", filestext, ";0;false]"
    }

    return table.concat(formspec, "")
end


minetest.register_node("audionode:audio_blue", {
    description = "Audionode Block",
    tiles = {"audio_blue.png"},
    groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
    --oggEnding = ".ogg"
    --mp3Ending = ".mp3"
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
        local formspec =  get_formspec()
        print(formspec)

        minetest.show_formspec(
            player:get_player_name(), 
            "audionode:files", 
            formspec)

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

 


 
 
-- minetest.register_node("audionode:audio_red", {
--     description = "audionode Block Red",
--     tiles = {"audio_red.png"},
--     groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
--         on_rightclick = function(pos, node, player, itemstack, pointed_thing)
--             if soundblocks_onoff == 0 then
--                 soundblocks_onoff = 1
--                 soundblocks = minetest.sound_play("audio_red", { --name of sound, file name extension is .ogg
--                     pos = pos, --pos where sound comes from
--                     gain = 1.0,
--                     max_hear_distance = 32,
--                     loop = true,}) --sound gets lower the farer you get away from the jukebox
--             else
--                 minetest.sound_stop(soundblocks)
--                 soundblocks_onoff=0
--             end
-- end})