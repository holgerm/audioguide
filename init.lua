audionode = {}

soundblocks = 0
soundblocks_onoff = 0

function audionode.get_fileslist() 
    local files = minetest.get_dir_list(minetest.get_modpath("audionode") .. '/sounds', false)
    local filestable = {}
    local first_file = true
    for i = 1, #files do
        if files[i]:sub(-4) == ".ogg" then
            if not first_file then
                table.insert(filestable, ",")
            end
            table.insert(filestable, files[i])
            first_file = false
        end
    end

    return table.concat(filestable, "")
end


function audionode.get_formspec()
    local formspec = {
        "formspec_version[4]",
        "size[8,6]",
        "label[0.55,0.5;", minetest.formspec_escape("Pick an audiofile for this node:"), "]",
        "textlist[0.5,0.75;7,4;mydir_list;", audionode.get_fileslist(), ";0;false]",
        "button_exit[0.5,5;2,0.5;adioCanceled;Cancel]",
        "button_exit[6.5,5;1,0.5;audioSelected;Ok]"
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
        local formspec =  audionode.get_formspec()
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