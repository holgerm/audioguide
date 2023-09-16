local audionode = {}

local soundblocks = 0
local soundblocks_onoff = 0

function table.tostring(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. table.tostring(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end
 

function audionode.get_filestable() 
    local files = minetest.get_dir_list(minetest.get_modpath("audionode") .. '/sounds', false)
    local filestable = {}
    for i = 1, #files do
        if files[i]:sub(-4) == ".ogg" then
            table.insert(filestable, files[i])
        end
    end

    return filestable
end


function audionode.get_formspec()
    local filesListText = table.concat(audionode.get_filestable(), ",")
    local formspec = {
        "formspec_version[4]",
        "size[8,6]",
        "label[0.55,0.5;", minetest.formspec_escape("Pick an audiofile for this node:"), "]",
        "textlist[0.5,0.75;7,4;audionodeFilesList;", filesListText, ";0;false]",
        "button_exit[0.5,5;1.5,0.5;audioCanceled;Cancel]",
        "button_exit[3.375,5;1.5,0.5;audioStop;Stop]",
        "button_exit[6,5;1.5,0.5;audioSelected;Set]"
    }

    return table.concat(formspec, "")
end

audionode.state = {}

function audionode.pos2key(pos)
    return pos.x .. "-" .. pos.y .. "-" .. pos.z
end

-- we store for each audionode:
--      with the position key (x-y-z):
--          audiofile: the filename of the .ogg file
--          on: 1 running, 0 stopped
--          sound: the result of the sound_play() call which can be used to stop playback

function audionode.playSound(pos)
    local posString = tostring(pos)
    if audionode.state[posString] then
        if audionode.state[posString].on == 0 then
            audionode.state[posString].on = 1

            local audiofilewithoutsuffix = string.sub(audionode.state[posString].audiofile, 1, -5)
            audionode.state[posString].sound = minetest.sound_play(audiofilewithoutsuffix, {
                pos = pos, --pos where sound comes from
                gain = 1.0,
                max_hear_distance = 32,
                loop = true,})
        else
            minetest.sound_stop(audionode.state[posString].sound)
            audionode.state[posString].on = 0
        end
    end
end


minetest.register_node("audionode:audio_blue", {
    description = "Audionode Block",
    tiles = {"audio_blue.png"},
    groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
        local formspec =  audionode.get_formspec()
        if not audionode.playerPos then
            audionode.playerPos = {}
        end
        audionode.playerPos[tostring(player)] = pos 

        minetest.show_formspec(
            player:get_player_name(),
            "audionode:selection",
            formspec)
    end
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "audionode:selection" then
        return
    end

    if not audionode.playerPos[tostring(player)] or not fields.audionodeFilesList then
        return
    end


    local pos = audionode.playerPos[tostring(player)]
    local curState = {}
    curState.audiofile =
        audionode.get_filestable()[0+string.sub (fields.audionodeFilesList, 5)]
    curState.on = 0
    audionode.state[tostring(pos)] = curState
    audionode.playSound(pos)
end)