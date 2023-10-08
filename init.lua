local audionode = {
    playerPos = {},
    playing = {}
}

minetest.register_privilege("audionode", {
	description = "Can edit audionodes",
	give_to_singleplayer = false
})

function audionode.tabletostring(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then
            k = '"'..k..'"'
          else
            k = '"'..tostring(k)..'"'
          end
          s = s .. '['..k..'] = ' .. audionode.tabletostring(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
end

function audionode.getPlayKey(pos, player)
    return tostring(pos) .. "-" .. player:get_player_name()
end

local storage = minetest.get_mod_storage()

function audionode.play(pos, player)
    local audiostring = storage:get_string(tostring(pos))
    if not audiostring or audiostring == '' then
        minetest.chat_send_player(
            player:get_player_name(),
            "There is no audiofile at this position.")
        return
    end

    local audio = minetest.deserialize(audiostring)
    if not audio.file then
        minetest.chat_send_player(
            player:get_player_name(),
            "There is a problem with the audiofile at this position.")
        return
    end

    local sound = minetest.sound_play(
        audio.file,
        {
            pos = pos,
            gain = 1.0,
            max_hear_distance = 32,
            loop = false,
            to_player = player:get_player_name(),
        }
    )
    audionode.playing[audionode.getPlayKey(pos, player)] = sound
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


function audionode.get_formspec(indexOfFile)
    local filesListText = table.concat(audionode.get_filestable(), ",")
    local formspec = {
        "formspec_version[4]",
        "size[8,6]",
        "label[0.55,0.5;", minetest.formspec_escape("Pick an audiofile for this node:"), "]",
        "textlist[0.5,0.75;7,4;audionodeFilesList;", filesListText, ";", tostring(indexOfFile), ";false]",
        "button_exit[0.5,5;1.5,0.5;audioDelete;Delete]",
        "button[3.375,5;1.5,0.5;audioListen;Listen]",
        "button_exit[6,5;1.5,0.5;audioSet;Set]"
    }

    return table.concat(formspec, "")
end

minetest.register_node("audionode:audio_blue", {
    description = "Audionode Block",
    tiles = {"audio_blue.png"},
    groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
        -- check player priv for audionode editing:
        if minetest.check_player_privs(player, {audionode=true}) then
            local indexOfFile = 0
            local audiostring = storage:get_string(tostring(pos))
            if audiostring then
                local audio = minetest.deserialize(audiostring)
                if audio then
                    local files = audionode.get_filestable()
                        --minetest.get_dir_list(minetest.get_modpath("audionode") .. '/sounds', false)
                    for i = 1, #files do
                        if files[i]:sub(1,-5) == audio.file then
                            indexOfFile = i
                            break
                        end
                    end
                end
            end

            local formspec =  audionode.get_formspec(indexOfFile)
            if audionode.playerPos == nil then audionode.playerPos = {} end
            audionode.playerPos[tostring(player)] = pos
            minetest.show_formspec(
                player:get_player_name(),
                "audionode:selection",
                formspec)
        else
            local sound = audionode.playing[audionode.getPlayKey(pos, player)]
            if sound then
                print("SOUND STOP: " .. sound)
                minetest.sound_stop(sound)
                audionode.playing[audionode.getPlayKey(pos, player)] = nil
            else
                print("SOUND PLAY: ")
                audionode.play(pos, player)
            end
        end
    end
})

--[[ 
    How it is supposed to work:
    
    When the user clicks on an audio block, the form will be shown. The users position is stored temporarily in
    audionode.playerPos[<playername>]. We use the raw data string as we get it as argument from the on_rightclick 
    callback.

    Next the user selects an audio file within the form. Now we store the name of the selected file in 
    audionode.selectedfile[pos], i.e. we temporarily save the filename under the pos as key. In case multiple users
    make different selections for the same node, the last selection overwrites all previous. (Maybe later we could 
    show that somehow to the users, or even block the form if someone is already editing the sound at a node.)

    When the user clicks on the Cancel button, the form is closed and nothing is changed in permanent store.

    When the user clicks on the Set button (and an audio files is selected), the selected audio file starts to play
    and is saved permanently as the following data structure in the database:

    {
        pos // the position of the audionode
        file // the filename without extension
    }

 ]]


minetest.register_on_player_receive_fields(
    function(player, formname, fields)
        if formname ~= "audionode:selection" then
            return
        end

        local pos = audionode.playerPos[tostring(player)]

        if not pos then
            minetest.chat_send_player(
                player:get_player_name(), 
                "Error on audionode mod: Pplayer position was not stored. Contact the developer please.")
            return
        end

        if fields.audionodeFilesList then
            -- audio file in list selected: we store the file name at this positons metadata:
            if audionode.selectedfile == nil then audionode.selectedfile = {} end
            local i = 0 + string.sub (fields.audionodeFilesList, 5)
            audionode.selectedfile[tostring(pos)] =
                string.sub(audionode.get_filestable()[i], 1, -5)
        end

        if fields.audioSet then
            if not audionode.selectedfile or not audionode.selectedfile[tostring(pos)] then
                minetest.chat_send_player(
                    player:get_player_name(), 
                    "You need to select an audio file in order to set it at this audionode!")
                return
            end

            local audioValue = {}
            audioValue.pos = pos
            audioValue.file = audionode.selectedfile[tostring(pos)]
            local valueString = minetest.serialize(audioValue)
            storage:set_string(tostring(pos), valueString)
            minetest.chat_send_player(
                player:get_player_name(), 
                "Audiofile '" .. audioValue.file .. "' set for play at this audionode.")
        end

        if fields.audioDelete then
            storage:set_string(tostring(pos), nil)
        end

        if fields.audioListen then
            audionode.play(pos, player)
        end
    end
)
