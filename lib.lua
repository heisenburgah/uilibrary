pcall(function()
    if getconnections then
        for _,v in pairs(getconnections(game:GetService('ScriptContext').Error)) do
            v:Disable();
        end
    end
end)

loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();

loadstring([[
    function LPH_ENCSTR(f) return f end;
]])();

loadstring([[
    LPH_OBFUSCATED = false;
]])();

local Required = {
	"hookfunction",
	"getconnections",
	"hookmetamethod",
	"bit32",
	"getgenv",
	"setmetatable",
    "clonefunction",
    "cloneref"
}

local Kick = clonefunction and clonefunction(game:GetService("Players").LocalPlayer.Kick) or game:GetService("Players").LocalPlayer.Kick

for i = 1, #Required do
	local v = Required[i]
	if not getgenv()[v] then
        Kick(game:GetService("Players").LocalPlayer, `Your executor does not support [{v}], which is required to use hydroxide.sol @ Rogue Lineage.`)
	end
end

local function process_string(str, salt)
    salt = salt or 27
    if not bit32 or not bit32.bxor then
        warn("bit32.bxor not available")
        return str
    end
    local chars = {}
    for i = 1, #str do
        local char = string.byte(str, i)
        local processedChar = bit32.bxor(char, salt + (i % 7))
        chars[i] = string.char(processedChar)
    end
    return table.concat(chars)
end

local function encode(str, salt) return process_string(str, salt) end
local function decode(str, salt) return process_string(str, salt) end

local function generate_key()
    local p = game.PlaceId
    local j = game.JobId
    local u = game:GetService("Players").LocalPlayer.UserId
    return encode(p.."_"..j:sub(1,5).."_"..tostring(u):sub(-4))
end

local key = generate_key()
if game.PlaceId == 3541987450 or game.PlaceId == 5208655184 or game.PlaceId == 109732117428502 then
    if getgenv()[key] and type(getgenv()[key]) == "table" then return end
    getgenv()[key] = setmetatable({}, { __tostring = function() return "nil" end })

    do -- Anti Cheat Hooks
        old_destroy = hookfunction(workspace.Destroy, function(Self) -- Character Handler Destructor
            if not checkcaller() then
                if tostring(Self) == "CharacterHandler" then 
                    return
                end
            end
            
            return old_destroy(Self)
        end)
        
        task.spawn(function()
            local cw
            local lockThreads = {}
            cw = hookfunction(coroutine.wrap, newcclosure(function(f,...)
                if typeof(f) == "function" and islclosure(f) then
                    local consts,upvals = getconstants(f),getupvalues(f)
                    local g3 = getfenv(3)
                    
                    if typeof(upvals[2]) == "Instance" and upvals[2]:IsA("AnimationTrack") and upvals[1] == upvals[2].Play then
                        warn("DETECTION__1")
                        lockThreads[g3] = true
                    end
                          
                    if consts[1] == "scr" and consts[2] == "Parent" then
                        warn("DETECTION__2")
                        lockThreads[g3] = true
                    end
                    
                    if consts[1] == "coroutine" and consts[2] == "create" and table.find(consts,"dead") then
                        warn("DETECTION__3")
                        lockThreads[g3] = true
                    end
            
                    if g3 and lockThreads[g3] then
                        while true do
                            game:GetService("Players").LocalPlayer:Kick("Ban Attempt")
                            task.wait()
                        end    
                    end        
                end

                if lockThreads[getfenv(3)] then
                    return function() end
                end
                return cw(f,...)
            end))
        end)         
    end

    local start = os.clock()
    do
        makefolder("roguehake")
        makefolder("roguehake\\configs")
        if not isfile("roguehake\\webhooks.txt") then
            writefile("roguehake\\webhooks.txt","nil")
        end
        if not isfile("roguehake\\ui.txt") then
            writefile("roguehake\\ui.txt","255,0,0")
        end
        for i = 1, 3 do
            if not isfile("roguehake\\configs\\slot"..tostring(i)..".sex") then
                writefile("roguehake\\configs\\slot"..tostring(i)..".sex", "")
            end
        end
    end

    local webhook_file = "roguehake\\webhooks.txt"
    local webhook = ""

    if isfile(webhook_file) then
        webhook = readfile(webhook_file):gsub("%s+", "")
        
        if webhook == "nil" then
            webhook = ""
        elseif not webhook:match("^https://discord.com/api/webhooks/%d+/%S+$") then
            warn("⚠️ invalid discord webhook URL in 'roguehake\\webhooks.txt'.")
            webhook = ""
        end
    else
        warn("⚠️ webhook file not found; make sure 'roguehake\\webhooks.txt' exists.")
    end

    local cloneref = cloneref or function(...) return ... end
    local uis = cloneref(game:GetService("UserInputService"))
    local toggleKey = Enum.KeyCode.Home
    local platform = uis:GetPlatform()

    if platform == Enum.Platform.OSX then
        toggleKey = Enum.KeyCode.LeftControl
    elseif platform == Enum.Platform.Windows then
        toggleKey = Enum.KeyCode.Home
    end

    -- Services
    local cas  = cloneref(game:GetService("ContextActionService"))
    local vim  = cloneref(game:GetService("VirtualInputManager"))
    local mem  = cloneref(game:GetService("MemStorageService"))
    local rps  = cloneref(game:GetService("ReplicatedStorage"))
    local cs   = cloneref(game:GetService("CollectionService"))
    local tps  = cloneref(game:GetService("TeleportService"))
    local ts   = cloneref(game:GetService("TweenService"))
    local sui  = cloneref(game:GetService("StarterGui"))
    local rs   = cloneref(game:GetService("RunService"))
    local lit  = cloneref(game:GetService("Lighting"))
    local plrs = cloneref(game:GetService("Players"))
    local ws   = cloneref(game:GetService("Workspace"))
    local deb  = cloneref(game:GetService("Debris"))
    local cg   = cloneref(game:GetService("CoreGui"))

    -- Local
    local plr = plrs.LocalPlayer
    local mouse = plr:GetMouse()
    
    local flagged_chats = {'clipped','exploiter','banned','blacklisted','clip','hacker'}
    local hidden_folder = Instance.new("Folder", cg);hidden_folder.Name="HXSOL"
    local area_markers = ws:WaitForChild("AreaMarkers")
    local area_data = require(rps:WaitForChild("Info"):WaitForChild("AreaData"))
    local get_mouse_remote = rps:WaitForChild("Requests"):WaitForChild("GetMouse")
    local join_server = rps:WaitForChild("Requests"):WaitForChild("JoinPublicServer")
    local live_folder = ws:WaitForChild("Live")
    local headers = {["content-type"] = "application/json"}
    
    local is_gaia = game.PlaceId == 5208655184;
    local is_khei = game.PlaceId == 3541987450;

    local updatePlayerLabel, getPlayerColor
    local last_area_restore = nil
    local ingredient_folder = nil
    local active_observe = nil
    local auto_pot_active = false
    local auto_craft_active = false
    local was_noclip_enabled = false
    local no_need = false
    local mana_overlay = {}
    local transparent_parts = {}
    local original_names = {}
    local dialogue_remote = nil
    local old_hastag = nil
    local old_newindex = nil
    local old_find_first_child = nil
    local old_destroy = nil
    local watched_guis = {}
    local hooked_connections = {}
    local playerLabels = {}
    
    -- Global Tables
    local game_client = {}
    local library = {}
    local utility = {}
    local shared = {
        drawing_containers = {
            menu = {},
            notification = {},
            esp = {},
            status = {},
        },
        connections = {},
        hidden_connections = {},
        blatant_features = {"flight", "auto_ingredient", "auto_trinket", "no_fall", "no_killbrick", "auto_bag", "no_stun", "perflora_teleport", "parry_ignore_visibility"},
        blatant_toggles = {},
        pointers = {},
        theme = {
            inline = Color3.fromRGB(3, 3, 3),
            dark = Color3.fromRGB(24, 24, 24),
            text = Color3.fromRGB(155, 155, 155),
            section = Color3.fromRGB(60, 60, 60),
            accent = Color3.fromRGB(255,0,0),
        },
        accents = {},
        moveKeys = {
            ["Movement"] = {
                ["Up"] = "Up",
                ["Down"] = "Down"
            },
            ["Action"] = {
                ["Left"] = "Left",
                ["Right"] = "Right"
            }
        },
        allowedKeyCodes = {"Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","Z","X","C","V","B","N","M","One","Two","Three","Four","Five","Six","Seveen","Eight","Nine","0","Insert","Tab","Home","End","LeftAlt","LeftControl","LeftShift","RightAlt","RightControl","RightShift","CapsLock","Return","Up","Down","Left","Right"},
        allowedInputTypes = {"MouseButton1","MouseButton2","MouseButton3"},
        shortenedInputs = {
            -- Control Keys
            ["LeftControl"] = 'left control',
            ["RightControl"] = 'right control',
            ["LeftShift"] = 'left shift',
            ["RightShift"] = 'right shift',
    
            -- Numberbar
            ["Backquote"] = "grave",
            ["Tilde"] = "~",
            ["At"] = "@",
            ["Hash"] = "#",
            ["Dollar"] = "$",
            ["Percent"] = "%",
            ["Caret"] = "^",
            ["Ampersand"] = "&",
            ["Asterisk"] = "*",
            ["LeftParenthesis"] = "(",
            ["RightParenthesis"] = ")",
    
            ["Underscore"] = '_',
            ["Minus"] = '-',
            ["Plus"] = '+',
            ["Period"] = '.',
            ["Slash"] = '/',
            ["BackSlash"] = '\\',
            ["Question"] = '?',
    
            -- Super
            ["PageUp"] = "pgup",
            ["PageDown"] = "pgdwn",
    
            -- Keyboard
            ["Comma"] = ",",
            ["Period"] = ".",
            ["Semicolon"] = ",",
            ["Colon"] = ":",
            ["GreaterThan"] = ">",
            ["LessThan"] = "<",
            ["LeftBracket"] = "[",
            ["RightBracket"] = "]",
            ["LeftCurly"] = "{",
            ["RightCurly"] = "}",
            ["Pipe"] = "|",
    
            -- Numberpad
            ["NumLock"] = "num lock",
            ["KeypadNine"] = "num 9",
            ["KeypadEight"] = "num 8",
            ["KeypadSeven"] = "num 7",
            ["KeypadSix"] = "num 6",
            ["KeypadFive"] = "num 5",
            ["KeypadFour"] = "num 4",
            ["KeypadThree"] = "num 3",
            ["KeypadTwo"] = "num 2",
            ["KeypadOne"] = "num 1",
            ["KeypadZero"] = "num 0",
            
            ["KeypadMultiply"] = "num multiply",
            ["KeypadDivide"] = "num divide",
            ["KeypadPeriod"] = "num decimal",
            ["KeypadPlus"] = "num plus",
            ["KeypadMinus"] = "num sub",
            ["KeypadEnter"] = "num enter",
            ["KeypadEquals"] = "num equals",
            
            -- Mouse
            ["MouseButton1"] = 'mouse1',
            ["MouseButton2"] = 'mouse2',
            ["MouseButton3"] = 'mouse3',
        },   
        colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 100, 0), Color3.fromRGB(255, 200, 0), Color3.fromRGB(210, 255, 0), Color3.fromRGB(110, 255, 0), Color3.fromRGB(10, 255, 0), Color3.fromRGB(0, 255, 90), Color3.fromRGB(0, 255, 190), Color3.fromRGB(0, 220, 255), Color3.fromRGB(0, 120, 255), Color3.fromRGB(0, 20, 255), Color3.fromRGB(80, 0, 255), Color3.fromRGB(180, 0, 255), Color3.fromRGB(255, 0, 230), Color3.fromRGB(255, 0, 130), Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0)},
        toggleKey = {toggleKey, true},
        unloadKey = {Enum.KeyCode.End, true},
        saveKey = {Enum.KeyCode.PageUp, true},
        loadKey = {Enum.KeyCode.PageDown, true},
        windowActive = true,
        notifications = {},
    }
    local cheat_client = {
        config = {
            perflora_teleport = false, -- Combat Chunk
            no_stun = false,
            anti_confusion = false,

            parry_viribus = false,
            parry_owlslash = false,
            parry_shadowrush = false,
            parry_verdien = false,

            parry_ping_adjust = true,
            parry_custom_delay = false,
            custom_delay = 0,
            parry_fov_angle = 180,
            parry_disable_when_unfocused = true,
            parry_ignore_visibility = false,

            silent_aim = false,
            fov = 80,
            aimbot_hitboxes = 1,
            ignore_fov = false,
    
            player_esp = true, -- Visual Chunk
            player_box = true,
            player_health = true,
            player_name = true,
            player_tags = true,
            player_intent = true,
            player_mana = true,
            player_mana_text = false,
            player_hover_details = true,
            player_observe = false,
            player_racial = true,
            player_range = 2000,
            
            player_chams = false,
            player_friendly_chams = false,
            player_low_health = false,
            player_aimbot_chams = false,
            player_chams_fill = false,
            player_chams_pulse = false,
            player_chams_occluded = false,
            --player_chams_color = Color3.fromRGB(0,255,255),

            player_healthview = false,
            legit_intent = false,
    
            trinket_esp = true,
            trinket_show_area = true,
            trinket_range = 1000,
            
            shrieker_chams = false,
            fallion_esp = false,
            npc_esp = false,
    
            ore_esp = false,
            mythril_esp = false,
            copper_esp = false,
            iron_esp = false,
            tin_esp = false,
            ore_range = 12000,
            
            ingredient_esp = false,
            ingredient_range = 500,
    
            no_fog = false,
            no_blindness = false,
            no_blur = false,
            no_sanity = false,
            leaderboard_colors = true,
            fullbright = false,
            change_time = false,
            clock_time = 12,

            mana_overlay = false,
    
            no_insane = false, -- Exploits Chunk
            instant_mine = false,
            bard_stack = false,
            observe = true,

            invis_cam = false,
            max_zoom = false,
    
            flight = false, -- Movement Chunk
            --flight_keybind = nil,
            noclip = false,
            flight_speed = 100,
    
            
            auto_dialogue = false, -- Automation Chunk
            auto_bard = false,
            hide_bard = false,
            anti_afk = false,
            auto_trinket = false,
            auto_ingredient = false,
            auto_weapon = false,
            auto_resurrection = false,
            auto_chair = false,
            better_pickup = false,
            auto_bag = false,
            bag_range = 100,
            
            
            -- World Chunk
            temperature_lock = false,
            no_fall = false,
            no_killbrick = false,
            freecam = false,
    
            -- Misc Chunk
            double_jump = false,
            the_soul = false,
            ignore_danger = false,
            roblox_chat = false,
            unhide_players = false,
            gate_anti_backfire = false,
            streamer_mode = false,

            -- UI Chunk
            notifications = true,
            ignore_friendly = false,
            blatant_mode = true,
        },
        stuns = { -- Some of these don't need to be here, but only here cause of zyu
            ManaStop = true,
            Sprinting = true,
            Action = true,
            NoJump = true,
            HeavyAttack = true,
            LightAttack = true,
            NoJump = true,
            ForwardDash = true,
            RecentDash = true,
            ClimbCoolDown = true,
            NoDam = true,
            NoDash = true,
            Casting = true,
            BeingExecuted = true,
            IsClimbing = true,
            Blocking = true,
            NoControl = true,
            MustSprint = true,
            AttackExcept = true,
            Poisoned = true,
            BarrierCD = true,
            TimeStop = true,
            TimeStopped = true,
            JumpCool = true,
            Danger = true,
        },
        mental_injuries = {
            Hallucinations = true,
            PsychoInjury = true,
            AttackExcept = true,
            Whispering = true,
            Quivering = true,
            NoControl = true,
            Careless = true,
            Maniacal = true,
            Fearful = true
        },
        physical_injuries = { -- Removed Knocked, Unconscious because if you spoof it; it will brick ur client
            BrokenLeg = false,
            BrokenRib = false,
            BrokenArm = false,
        },
        valid_projectiles = {
            'FlowerProjectile',
        },
        last_names = {
            "Binary", "Rosine", "Tsuyi", "Ceos",
            "Famous", "Mudock", "Billbert", "Revenge", "Legate",
            "Emperor", "King", "Duke", "Warden", "33", "Blunt",
            "Baba", "Bazaar", "Rango", "Otf", "Topuria", "Bodyslam",
            "Hawktuah", "Azelf", "Nightraven", "Gallica",
            "Joyuri", "Female", "Democracy", "Kikihub"
        },
        --[[
        class_identifiers = { -- This ESP recalculates this every frame which is annoying and probably takes away from frames
            ["[oni]"] = {"Demon Step","Axe Kick","Demon Flip"},
            ["[dsage]"] = {"Lightning Drop", "Lightning Elbow"},
            ["[illu]"] = {"Dominus","Intermissum","Globus","Claritum","Custos","Observe"},
            ["[druid]"] = {"Verdien","Fon Vitae","Perflora","Floresco","Life Sense", "Poison Soul"},
            ["[necro]"] = {"Inferi","Reditus","Ligans","Furantur","Secare","Command Monsters","Howler"} ,
            ["[spy]"] = {"The Wraith","The Shadow","The Soul","Elegant Slash", "Needle's Eye", "Interrogation", "Acrobat", "RapierTraining"},
            ["[bard]"] = {"Joyous Dance","Sweet Soothing","Song of Lethargy"},
            ["[faceless]"] = {"Shadow Fan","Ethereal Strike"},
            ["[shinobi]"] = {"Grapple","Shadowrush","Resurrection"},
            ["[slayer]"] = {"Wing Soar","Thunder Spear Crash","Dragon Awakening"},
            ["[fisher]"] = {"Harpoon","Skewer","Hunter's Focus"},
            ["[deep]"] = {"Deep Sacrifice","Leviathan Plunge","Chain Pull", "PrinceBlessing"},
            ["[sigil]"] = {"Charged Blow","Hyper Body","White Flame Charge"},
            ["[wraith]"] = {"Dark Flame Burst","Dark Eruption"},
            ["[smith]"] = {"Remote Smithing","Grindstone"},
            ["[ronin]"] = {"Calm Mind","Swallow Reversal","Triple Slash","Blade Flash","Flowing Counter"},
            ["[abyss]"] = {"Abyssal Scream","Wrathful Leap"},
        },
        --]]
        spell_cost = {
            ["Armis"] = {{40, 60}, {70, 80}},
            ["Trickstus"] = {{30, 70}, {30, 50}},
            ["Scrupus"] = {{30, 100}, {30, 100}},
            ["Celeritas"] = {{70, 90}, {70, 80}},
            ["Ignis"] = {{80, 95}, {53, 57}},
            ["Gelidus"] = {{80, 95}, {85, 100}},
            ["Viribus"] = {{25, 35}, {60, 70}},
            ["Sagitta Sol"] = {{50, 65}, {40, 60}},
            ["Tenebris"] = {{90, 100}, {40, 60}},
            ["Nocere"] = {{70, 85}, {70, 85}},
            ["Hystericus"] = {{75, 90}, {15, 35}},
            ["Shrieker"] = {{30, 50}, {30, 50}},
            ["Verdien"] = {{75, 100}, {75, 85}},
            ["Contrarium"] = {{80, 95}, {70, 90}},
            ["Floresco"] = {{90, 100}, {80, 95}},
            ["Perflora"] = {{70, 90}, {30, 50}},
            ["Manus Dei"] = {{90, 95}, {50, 60}},
            ["Fons Vitae"] = {{75, 100}, {75, 100}},
            ["Trahere"] = {{75, 85}, {75, 85}},
            ["Furantur"] = {{60, 80}, {60, 80}},
            ["Inferi"] = {{10, 30}, {10, 30}},
            ["Howler"] = {{60, 80}, {60, 80}},
            ["Secare"] = {{90, 95}, {90, 95}},
            ["Ligans"] = {{63, 80}, {63, 80}},
            ["Reditus"] = {{50, 100}, {50, 100}},
            ["Fimbulvetr"] = {{86, 90}, {70, 80}},
            ["Gate"] = {{75, 83}, {75, 83}},
            ["Snarvindur"] = {{60, 75}, {20, 30}},
            ["Hoppa"] = {{40, 60}, {50, 60}},
            ["Percutiens"] = {{60, 70}, {70, 80}},
            ["Dominus"] = {{50, 100}, {50, 100}},
            ["Custos"] = {{45, 65}, {45, 65}},
            ["Claritum"] = {{90, 100}, {90, 100}},
            ["Globus"] = {{70, 100}, {70, 100}},
            ["Intermissum"] = {{70, 100}, {70, 100}},
            ["Sraunus"] = {{1, 50}, {1, 50}},
            ["Nosferatus"] = {{95, 100}, {95, 100}},
            ["Gourdus"] = {{80, 90}, {80, 90}},
            ["Telorum"] = {{80, 90}, {75, 85}},
            ["Velo"] = {{0, 100}, {50, 60}}
        },
        trinket_colors = {
            none = {ZIndex = 1,Color = Color3.fromRGB(40, 40, 40)}, -- Gray
            common = {ZIndex = 2,Color = Color3.fromRGB(189, 97, 29)}, -- Brown
            rare = {ZIndex = 3,Color = Color3.fromRGB(60, 150, 150)}, -- Blue
            artifact = {ZIndex = 4,Color = Color3.fromRGB(160, 100, 160)}, -- Purple
            mythic = {ZIndex = 5,Color = Color3.fromRGB(255, 0, 80)}, -- Red
        },
        custom_flight_functions = {
            ["IsKeyDown"] = uis.IsKeyDown,
            ["GetFocusedTextBox"] = uis.GetFocusedTextBox,
        },
        ingredient_identifiers = {
            ["3293218896"] = "Desert Mist",
            ["2773353559"] = "Blood Thorn",
            ["2960178471"] = "Snowscroom",
            ["2577691737"] = "Lava Flower",
            ["2618765559"] = "Glow Scroom",
            ["2575167210"] = "Moss Plant",
            ["2620905234"] = "Scroom",
            ["2766925289"] = "Trote",
            ["2766925320"] = "Polar Plant",
            ["2766802713"] = "Periashroom",
            ["2766802766"] = "Strange Tentacle",
            ["2766925228"] = "Tellbloom",
            ["2766802731"] = "Dire Flower",   
            ["2573998175"] = "Freeleaf",
            ["2766925214"] = "Crown Flower",
            ["3215371492"] = "Potato",
            ["2766925304"] = "Vile Seed",
            ["3049345298"] = "Zombie Scroom",
            ["2766802752"] = "Orcher Leaf",
            ["2766925267"] = "Creely",
            ["2889328388"] = "Ice Jar",
            ["3049928758"] = "Canewood",
            ["3049556532"] = "Acorn Light",
            ["2766925245"] = "Uncanny Tentacle",
            ["9858299042"] = "Evoflower",
        },
        must_touch = {
            [BrickColor.new("Reddish brown").Number] = true, -- idk
            [BrickColor.new("Copper").Number] = true,
            [BrickColor.new("Magenta").Number] = true,
        },
        safe_bricks = {
            Fire = true,
            OrderField = true,
            SolanBall = true,
            SolansGate = true,
            BaalField = true,
            Elevator = true,
            MageField = true,
            TeleportIn = true,
            TeleportOut = true,
        },
        blacklisted_ingredients = {
            [Vector3.new(1987.31, 177.64, 1080.92)] = true,
            [Vector3.new(2511.75, 198.985, -442.45)] = true,
            [Vector3.new(2510.07, 199.709, -518.071)] = true,
            [Vector3.new(2512.57, 199.709, -518.321)] = true,
            [Vector3.new(2511.57, 199.709, -517.071)] = true,
            [Vector3.new(2438.07, 199.709, -466.071)] = true,
            [Vector3.new(2439.07, 199.709, -467.321)] = true,
            [Vector3.new(2439.57, 199.709, -465.071)] = true,
        },
        artifacts = {"Rift Gem", "Lannis's Amulet", "Amulet of the White King", "Scroll of Fimbulvetr", "Scroll of Percutiens", "Scroll of Hoppa", "Scroll of Snarvindur", "Scroll of Manus Dei", "Spider Cloak", "Night Stone", "Philosophers Stone", "Howler Friend", "Phoenix Down", "Azael Horn","Mysterious Artifact","Fairfrozen"},
        mod_list = {
            117075515, -- // epotomy
            117092117, -- // zv_l
            218915876, -- // fun135090
            147287757, -- // sethpremecy
            1992980412, -- // DrDokieHead
            2352320475, -- // DrDSage
            1923314177, -- // DrTableHead
            1315267418, -- // Morqam
            1929945985, -- // DrDokieFace
            29656, -- // mam
            3408465701, -- // cantostyle
            272525488, -- // BurningDumpsterFire
            360905811, -- // aaRoks1234
            309149657, -- // Ra_ymond
            2758900605, -- // radicalpipelayer
            2052324682, -- // pentchann
            1220344444, -- // BlueRedGreenBRG
            1099784, -- // Doctor5
            1090716399, -- // Rindyrsil
            1754748220, -- // BlenzSr
            78504910, -- // shadoworth101
            364994040, -- // Grimiore
            96218539, -- // AvailableEnergetic
            434535742, -- // Masmixel
            19044993, -- // FrazoraX
            411595307, -- // ReEvolu
            1490237662, -- // detestdoot
            1255256325, -- // Grand_Archives
            1306981979, -- // kylenuts
            20469570, -- // vezplaw
            71662791, -- // thiari
            77196836, -- // XeroNavy
            28177302, -- // Midnight_zz
            8835343, -- // blutreefrog
            88193330, -- // sabyism
            83785067, -- // killer67564564643
            2542030529, -- // Brathruzas
            274304909, -- // redemtions
            2441088083, -- // cornagedotxyz
            177436599, -- // tommychongthe2nd
            64992045, -- // bluetetraninja
            1866587913, -- // WipeMePleaseOk
            1586650903, -- // stummycapalot
            1085890137, -- // babymouthy
            143241422, -- // Noblesman
            1014826936, -- // p0vd
            1657035, -- // lucman27
            2259720861, -- // HateBored
            338544906, -- // drypth
            399618581, -- // Almedris
            73062, -- // Adonis
            167825083, -- // melonbeard
            110153256, -- // Gizen_K
            266800563, -- // Lazureos
            1216700054, -- // KittyTheYeeter
            3314396480, -- // HugeEcuadorianMan
            3292692379, -- // cookiesoda221
            1427798376, -- // Agamatsu
            1626803537, -- // Shadiphx
            1311587059, -- // RagoozersLeftSock
            988461535, -- // mime_keep
            3006409955, -- // Bismuullah
            2485656647, -- // z_rolled
            1255256325, -- // panchikorox
            2228891194, -- // Rivai_Ackermann
            2243463821, -- // Rivaihuh
            2252396915, -- // magicverdien
            1989789343 -- // tayissecy
        },
        aimbot = {
            aimkey_translation = {
                ["mouse1"] = Enum.UserInputType.MouseButton1,
                ["mouse2"] = Enum.UserInputType.MouseButton2,
            },
            silent_vector = nil,
            current_target = nil,
        },
        friends = {},

        connections = {},
        window_active = true,
    }

    local cpu = {
        services = {
            uis = game:GetService('UserInputService'),
            vs = game:GetService("VirtualUser"),
            rs = game:GetService("RunService"),
            ugs = UserSettings():GetService('UserGameSettings'),
            plrs = game:GetService("Players"),
                
            ms = UserSettings():GetService('UserGameSettings').MasterVolume,
            ql = settings().Rendering.QualityLevel,
        },
        status = {
            active = false,
            hd_mode = false,
            focused = false,
        }
    }

    local ui_file = "roguehake\\ui.txt"
    if isfile(ui_file) then
        local color_str = readfile(ui_file):gsub("%s+", "")
        local r, g, b = color_str:match("(%d+),(%d+),(%d+)")
        
        if r and g and b then
            r, g, b = tonumber(r), tonumber(g), tonumber(b)
            
            if r and g and b and r >= 0 and r <= 255 and g >= 0 and g <= 255 and b >= 0 and b <= 255 then
                shared.theme.accent = Color3.fromRGB(r, g, b)
            else
                warn("⚠️ invalid color format in 'roguehake\\ui.txt', using default color.")
            end
        else
            warn("⚠️ failed to read color from 'roguehake\\ui.txt', using default color.")
        end
    else
        warn("⚠️ ui file not found; make sure 'roguehake\\ui.txt' exists.")
    end
    
    -- Encrypt Module
    do
        local BitBuffer
    
        do -- Bit Buffer Module
            BitBuffer = {}
    
            local NumberToBase64; local Base64ToNumber; do
                NumberToBase64 = {}
                Base64ToNumber = {}
                local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
                for i = 1, #chars do
                    local ch = chars:sub(i, i)
                    NumberToBase64[i-1] = ch
                    Base64ToNumber[ch] = i-1
                end
            end
    
            local PowerOfTwo; do
                PowerOfTwo = {}
                for i = 0, 64 do
                    PowerOfTwo[i] = 2^i
                end
            end
    
            local BrickColorToNumber; local NumberToBrickColor; do
                BrickColorToNumber = {}
                NumberToBrickColor = {}
                for i = 0, 63 do
                    local color = BrickColor.palette(i)
                    BrickColorToNumber[color.Number] = i
                    NumberToBrickColor[i] = color
                end
            end
    
            local floor,insert = math.floor, table.insert
            local abs, sqrt, random = math.abs, math.sqrt, math.random
            local max, min, ceil = math.max, math.min, math.ceil
            
            function fast_remove(tbl, value)
                for i = #tbl, 1, -1 do
                    if tbl[i] == value then
                        tbl[i] = tbl[#tbl]
                        tbl[#tbl] = nil
                        return true
                    end
                end
                return false
            end
            function ToBase(n, b)
                n = floor(n)
                if not b or b == 10 then return tostring(n) end
                local digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                local t = {}
                local sign = ""
                if n < 0 then
                    sign = "-"
                    n = -n
                end
                repeat
                    local d = (n % b) + 1
                    n = floor(n / b)
                    insert(t, 1, digits:sub(d, d))
                until n == 0
                return sign..table.concat(t, "")
            end
    
            function BitBuffer.Create()
                local this = {}
    
                -- Tracking
                local mBitPtr = 0
                local mBitBuffer = {}
    
                function this:ResetPtr()
                    mBitPtr = 0
                end
                function this:Reset()
                    mBitBuffer = {}
                    mBitPtr = 0
                end
    
                -- Set debugging on
                local mDebug = false
                function this:SetDebug(state)
                    mDebug = state
                end
    
                -- Read / Write to a string
                function this:FromString(str)
                    this:Reset()
                    for i = 1, #str do
                        local ch = str:sub(i, i):byte()
                        for i = 1, 8 do
                            mBitPtr = mBitPtr + 1
                            mBitBuffer[mBitPtr] = ch % 2
                            ch = math.floor(ch / 2)
                        end
                    end
                    mBitPtr = 0
                end
                function this:ToString()
                    local chars = {}
                    local charIndex = 1
                    local accum = 0
                    local pow = 0
                    for i = 1, ceil((#mBitBuffer) / 8)*8 do
                        accum = accum + PowerOfTwo[pow]*(mBitBuffer[i] or 0)
                        pow = pow + 1
                        if pow >= 8 then
                            chars[charIndex] = string.char(accum)
                            charIndex = charIndex + 1
                            accum = 0
                            pow = 0
                        end
                    end
                    return table.concat(chars)
                end
    
                -- Read / Write to base64
                function this:FromBase64(str)
                    this:Reset()
                    for i = 1, #str do
                        local ch = Base64ToNumber[str:sub(i, i)]
                        assert(ch, "Bad character: 0x"..ToBase(str:sub(i, i):byte(), 16))
                        for i = 1, 6 do
                            mBitPtr = mBitPtr + 1
                            mBitBuffer[mBitPtr] = ch % 2
                            ch = math.floor(ch / 2)
                        end
                        assert(ch == 0, "Character value 0x"..ToBase(Base64ToNumber[str:sub(i, i)], 16).." too large")
                    end
                    this:ResetPtr()
                end
                function this:ToBase64()
                    local strtab = {}
                    local accum = 0
                    local pow = 0
                    for i = 1, math.ceil((#mBitBuffer) / 6)*6 do
                        accum = accum + PowerOfTwo[pow]*(mBitBuffer[i] or 0)
                        pow = pow + 1
                        if pow >= 6 then
                            strtab[#strtab + 1] = NumberToBase64[accum]
                            accum = 0
                            pow = 0
                        end
                    end
                    return table.concat(strtab)
                end	
    
                -- Dump
                function this:Dump()
                    local str = ""
                    local str2 = ""
                    local accum = 0
                    local pow = 0
                    for i = 1, math.ceil((#mBitBuffer) / 8)*8 do
                        str2 = str2..(mBitBuffer[i] or 0)
                        accum = accum + PowerOfTwo[pow]*(mBitBuffer[i] or 0)
                        --print(pow..": +"..PowerOfTwo[pow].."*["..(mBitBuffer[i] or 0).."] -> "..accum)
                        pow = pow + 1
                        if pow >= 8 then
                            str2 = str2.." "
                            str = str.."0x"..ToBase(accum, 16).." "
                            accum = 0
                            pow = 0
                        end
                    end
                end
    
                -- Read / Write a bit
                local function writeBit(v)
                    mBitPtr = mBitPtr + 1
                    mBitBuffer[mBitPtr] = v
                end
                local function readBit(v)
                    mBitPtr = mBitPtr + 1
                    return mBitBuffer[mBitPtr]
                end
    
                -- Read / Write an unsigned number
                function this:WriteUnsigned(w, value, printoff)
                    assert(w, "Bad arguments to BitBuffer::WriteUnsigned (Missing BitWidth)")
                    assert(value, "Bad arguments to BitBuffer::WriteUnsigned (Missing Value)")
                    assert(value >= 0, "Negative value to BitBuffer::WriteUnsigned")
                    assert(math.floor(value) == value, "Non-integer value to BitBuffer::WriteUnsigned")
                    if mDebug and not printoff then
                        warn("WriteUnsigned["..w.."]:", value)
                    end
                    -- Store LSB first
                    for i = 1, w do
                        writeBit(value % 2)
                        value = math.floor(value / 2)
                    end
                    assert(value == 0, "Value "..tostring(value).." has width greater than "..w.."bits")
                end 
                function this:ReadUnsigned(w, printoff)
                    local value = 0
                    for i = 1, w do
                        value = value + readBit() * PowerOfTwo[i-1]
                    end
                    return value
                end
    
                -- Read / Write a signed number
                function this:WriteSigned(w, value)
                    assert(w and value, "Bad arguments to BitBuffer::WriteSigned (Did you forget a bitWidth?)")
                    assert(math.floor(value) == value, "Non-integer value to BitBuffer::WriteSigned")
                    -- Write sign
                    if value < 0 then
                        writeBit(1)
                        value = -value
                    else
                        writeBit(0)
                    end
                    -- Write value
                    this:WriteUnsigned(w-1, value, true)
                end
                function this:ReadSigned(w)
                    -- Read sign
                    local sign = (-1)^readBit()
                    -- Read value
                    local value = this:ReadUnsigned(w-1, true)
                    if mDebug then
                        warn("ReadSigned["..w.."]:", sign*value)
                    end
                    return sign*value
                end
    
                -- Read / Write a string. May contain embedded nulls (string.char(0))
                function this:WriteString(s)
                    -- First check if it's a 7 or 8 bit width of string
                    local bitWidth = 7
                    for i = 1, #s do
                        if s:sub(i, i):byte() > 127 then
                            bitWidth = 8
                            break
                        end
                    end
    
                    -- Write the bit width flag
                    if bitWidth == 7 then
                        this:WriteBool(false)
                    else
                        this:WriteBool(true) -- wide chars
                    end
    
                    -- Now write out the string, terminated with "0x10, 0b0"
                    -- 0x10 is encoded as "0x10, 0b1"
                    for i = 1, #s do
                        local ch = s:sub(i, i):byte()
                        if ch == 0x10 then
                            this:WriteUnsigned(bitWidth, 0x10)
                            this:WriteBool(true)
                        else
                            this:WriteUnsigned(bitWidth, ch)
                        end
                    end
    
                    -- Write terminator
                    this:WriteUnsigned(bitWidth, 0x10)
                    this:WriteBool(false)
                end
                function this:ReadString()
                    -- Get bit width
                    local bitWidth;
                    if this:ReadBool() then
                        bitWidth = 8
                    else
                        bitWidth = 7
                    end
    
                    -- Loop
                    local str = ""
                    while true do
                        local ch = this:ReadUnsigned(bitWidth)
                        if ch == 0x10 then
                            local flag = this:ReadBool()
                            if flag then
                                str = str..string.char(0x10)
                            else
                                break
                            end
                        else
                            str = str..string.char(ch)
                        end
                    end
                    return str
                end
    
                -- Read / Write a bool
                function this:WriteBool(v)
                    if v then
                        this:WriteUnsigned(1, 1, true)
                    else
                        this:WriteUnsigned(1, 0, true)
                    end
                end
                function this:ReadBool()
                    local v = (this:ReadUnsigned(1, true) == 1)
                    return v
                end
    
                -- Read / Write a floating point number with |wfrac| fraction part
                -- bits, |wexp| exponent part bits, and one sign bit.
                function this:WriteFloat(wfrac, wexp, f)
                    assert(wfrac and wexp and f)
    
                    -- Sign
                    local sign = 1
                    if f < 0 then
                        f = -f
                        sign = -1
                    end
    
                    -- Decompose
                    local mantissa, exponent = math.frexp(f)
                    if exponent == 0 and mantissa == 0 then
                        this:WriteUnsigned(wfrac + wexp + 1, 0)
                        return
                    else
                        mantissa = ((mantissa - 0.5)/0.5 * PowerOfTwo[wfrac])
                    end
    
                    -- Write sign
                    if sign == -1 then
                        this:WriteBool(true)
                    else
                        this:WriteBool(false)
                    end
    
                    -- Write mantissa
                    mantissa = math.floor(mantissa + 0.5) -- Not really correct, should round up/down based on the parity of |wexp|
                    this:WriteUnsigned(wfrac, mantissa)
    
                    -- Write exponent
                    local maxExp = PowerOfTwo[wexp-1]-1
                    if exponent > maxExp then
                        exponent = maxExp
                    end
                    if exponent < -maxExp then
                        exponent = -maxExp
                    end
                    this:WriteSigned(wexp, exponent)	
                end
                function this:ReadFloat(wfrac, wexp)
                    assert(wfrac and wexp)
    
                    -- Read sign
                    local sign = 1
                    if this:ReadBool() then
                        sign = -1
                    end
    
                    -- Read mantissa
                    local mantissa = this:ReadUnsigned(wfrac)
    
                    -- Read exponent
                    local exponent = this:ReadSigned(wexp)
                    if exponent == 0 and mantissa == 0 then
                        return 0
                    end
    
                    -- Convert mantissa
                    mantissa = mantissa / PowerOfTwo[wfrac] * 0.5 + 0.5
    
                    -- Output
                    return sign * math.ldexp(mantissa, exponent)
                end
    
                -- Read / Write single precision floating point
                function this:WriteFloat32(f)
                    this:WriteFloat(23, 8, f)
                end
                function this:ReadFloat32()
                    return this:ReadFloat(23, 8)
                end
    
                -- Read / Write double precision floating point
                function this:WriteFloat64(f)
                    this:WriteFloat(52, 11, f)
                end
                function this:ReadFloat64()
                    return this:ReadFloat(52, 11)
                end
    
                -- Read / Write a BrickColor
                function this:WriteBrickColor(b)
                    local pnum = BrickColorToNumber[b.Number]
                    if not pnum then
                        warn("Attempt to serialize non-pallete BrickColor `"..tostring(b).."` (#"..b.Number.."), using Light Stone Grey instead.")
                        pnum = BrickColorToNumber[BrickColor.new(1032).Number]
                    end
                    this:WriteUnsigned(6, pnum)
                end
                function this:ReadBrickColor()
                    return NumberToBrickColor[this:ReadUnsigned(6)]
                end
    
                -- Read / Write a rotation as a 64bit value.
                local function round(n)
                    return math.floor(n + 0.5)
                end
                function this:WriteRotation(cf)
                    local lookVector = cf.lookVector
                    local azumith = math.atan2(-lookVector.X, -lookVector.Z)
                    local ybase = (lookVector.X^2 + lookVector.Z^2)^0.5
                    local elevation = math.atan2(lookVector.Y, ybase)
                    local withoutRoll = CFrame.new(cf.p) * CFrame.Angles(0, azumith, 0) * CFrame.Angles(elevation, 0, 0)
                    local x, y, z = (withoutRoll:inverse()*cf):toEulerAnglesXYZ()
                    local roll = z
                    -- Atan2 -> in the range [-pi, pi] 
                    azumith   = round((azumith   /  math.pi   ) * (2^21-1))
                    roll      = round((roll      /  math.pi   ) * (2^20-1))
                    elevation = round((elevation / (math.pi/2)) * (2^20-1))
                    --
                    this:WriteSigned(22, azumith)
                    this:WriteSigned(21, roll)
                    this:WriteSigned(21, elevation)
                end
                function this:ReadRotation()
                    local azumith   = this:ReadSigned(22)
                    local roll      = this:ReadSigned(21)
                    local elevation = this:ReadSigned(21)
                    --
                    azumith =    math.pi    * (azumith / (2^21-1))
                    roll =       math.pi    * (roll    / (2^20-1))
                    elevation = (math.pi/2) * (elevation / (2^20-1))
                    --
                    local rot = CFrame.Angles(0, azumith, 0)
                    rot = rot * CFrame.Angles(elevation, 0, 0)
                    rot = rot * CFrame.Angles(0, 0, roll)
                    --
                    return rot
                end
    
                return this
            end
    
        end
    
        local TypeIntegerLength = 3
        local IntegerLength = 10
    
        local function TypeToId(Type)
            if Type == "Integer" then
                return 1
            elseif Type == "NegInteger" then
                return 2
            elseif Type == "Number" then
                return 3
            elseif Type == "String" then
                return 4
            elseif Type == "Boolean" then
                return 5
            elseif Type == "Table" then
                return 6
            end
            return 0
        end
    
        local function IdToType(Type)
            if Type == 1 then
                return "Integer"
            elseif Type == 2 then
                return "NegInteger"
            elseif Type == 3 then
                return "Number"
            elseif Type == 4 then
                return "String"
            elseif Type == 5 then
                return "Boolean"
            elseif Type == 6 then
                return "Table"
            end
        end
    
        local function IsInt(Number)
            local Decimal = string.find(tostring(Number),"%.")
            if Decimal then
                return false
            else
                return true
            end
        end
    
        local function log(Base,Number)
            return math.log(Number)/math.log(Base)
        end
    
        local function GetMaxBitsInt(Table)
            local Max = 0
            for Key,Value in pairs(Table) do
                if type(Value) == "number" then
                    Value = math.abs(Value)
                    if IsInt(Value) and Value > 0 then
                        local Bits = math.ceil(log(2,Value + 1))
                        if Bits > Max then Max = Bits end
                    end
                end
                
                if type(Key) == "number" then
                    Key = math.abs(Key)
                    if IsInt(Key) and Key > 0 then
                        local Bits = math.ceil(log(2,Key + 1))
                        if Bits > Max then Max = Bits end
                    end
                end
            end
            return Max*2
        end
    
        local function GetTableLength(Table)
            local Total = 0
            for _,_ in pairs(Table) do
                Total = Total + 1
            end
            return Total
        end
    
        local function GetType(Key)
            local Type = type(Key) 
            if Type == "number" then
                if IsInt(Key) then
                    if Key < 0 then
                        return "NegInteger"
                    end
                    return "Integer"
                else
                    return "Number"
                end
            else
                return Type
            end
        end
    
        local function GetAllType(Table)
            local Type
            for Key,_ in pairs(Table) do
                if not Type then 
                    Type = GetType(Key)
                end
                if type(Key) ~= Type then
                    local NewType = GetType(Key)
                    if NewType ~= Type then
                        return nil
                    end
                end
            end	
            if Type == "Number" then
                return "Number"
            elseif Type == "Integer" then
                return "Integer"
            elseif Type == "NegInteger" then
                return "NegInteger"
            else
                return "String"
            end
        end
    
        local crypt = {}
        function crypt:encode(Table,UseBase64)
            local AllType = GetAllType(Table)
            local Buffer = BitBuffer.Create()
            if UseBase64 == true then
                Buffer:WriteBool(true)
            else
                Buffer:WriteBool(false)
            end
            Buffer:WriteUnsigned(IntegerLength,GetTableLength(Table))
            
            local function WriteFloat(Number)
                if UseBase64 == true then
                    Buffer:WriteFloat64(Number)
                else
                    Buffer:WriteFloat32(Number)
                end
            end
            Buffer:WriteUnsigned(TypeIntegerLength,TypeToId(AllType))
            local MaxBits = GetMaxBitsInt(Table)
            Buffer:WriteUnsigned(IntegerLength,MaxBits)
            
            local function WriteKey(Key,AllowAllSame)
                if not (AllowAllSame == true and AllType) then
                    Buffer:WriteUnsigned(TypeIntegerLength,Key)
                elseif AllowAllSame == false then
                    Buffer:WriteUnsigned(TypeIntegerLength,Key)
                end
            end
            
            for Key,Value in pairs(Table) do
                if type(Key) == "string" then
                    WriteKey(TypeToId("String"),true)
                    Buffer:WriteString(Key)
                elseif type(Key) == "number" and IsInt(Key) then
                    if Key >= 0 then
                        WriteKey(TypeToId("Integer"),true)
                        Buffer:WriteUnsigned(MaxBits,Key)
                    else
                        WriteKey(TypeToId("NegInteger"),true)
                        Buffer:WriteSigned(MaxBits*2,Key)
                    end
                elseif type(Key) == "number" then
                    WriteKey(TypeToId("Number"),true)
                    WriteFloat(Key)
                end
                
                if type(Value) == "boolean" then
                    WriteKey(TypeToId("Boolean"))
                    Buffer:WriteBool(Value)
                elseif type(Value) == "number" then
                    if IsInt(Value) then
                        if Value < 0 then
                            WriteKey(TypeToId("NegInteger"))
                            Buffer:WriteSigned(MaxBits*2,Value)
                        else
                            WriteKey(TypeToId("Integer"))
                            Buffer:WriteUnsigned(MaxBits,Value)
                        end
                    else
                        WriteKey(TypeToId("Number"))
                        WriteFloat(Value)
                    end
                elseif type(Value) == "table" then
                    WriteKey(TypeToId("Table"))
                    Buffer:WriteString(crypt:encode(Value,UseBase64))
                elseif type(Value) == "string" then
                    WriteKey(TypeToId("String"))
                    Buffer:WriteString(tostring(Value))
                end
            end
            return Buffer:ToBase64()
        end
    
        function crypt:decode(BinaryString)
            local Buffer = BitBuffer.Create()
            Buffer:FromBase64(BinaryString)
            local Table = {}
            local UseBase64 = Buffer:ReadBool()
            local function ReadFloat()
                if UseBase64 == true then
                    return Buffer:ReadFloat64()
                else
                    return Buffer:ReadFloat32()
                end
            end
            local Length = Buffer:ReadUnsigned(IntegerLength)
            local AllType = Buffer:ReadUnsigned(TypeIntegerLength)
            local MaxBits = Buffer:ReadUnsigned(IntegerLength)
            if AllType == 0 then AllType = nil end
            
            for i = 1, Length do
                local KeyType,Key = AllType or Buffer:ReadUnsigned(TypeIntegerLength)
                
                local KeyRealType = IdToType(KeyType)
                if KeyRealType == "Integer" then
                    Key = Buffer:ReadUnsigned(MaxBits)
                elseif KeyRealType == "NegInteger" then
                    Key = Buffer:ReadSigned(MaxBits*2)
                elseif KeyRealType == "Number" then
                    Key = ReadFloat()
                elseif KeyRealType == "String" then
                    Key = Buffer:ReadString()
                end
                
                local ValueType,Value = Buffer:ReadUnsigned(TypeIntegerLength)
                local ValueRealType = IdToType(ValueType)
                if ValueRealType == "String" then
                    Value = Buffer:ReadString()
                elseif ValueRealType == "Boolean" then
                    Value = Buffer:ReadBool()
                elseif ValueRealType == "Number" then
                    Value = ReadFloat()
                elseif ValueRealType == "Integer" then
                    Value = Buffer:ReadUnsigned(MaxBits)
                elseif ValueRealType == "NegInteger" then
                    Value = Buffer:ReadSigned((MaxBits * 2))
                elseif ValueRealType == "Table" then
                    Value = crypt:decode(Buffer:ReadString())
                elseif ValueRealType == "Color3" then
                    Value = Color3.new(ReadFloat(),ReadFloat(),ReadFloat())
                elseif ValueRealType == "CFrame" then
                    Value = CFrame.new(ReadFloat(),ReadFloat(),ReadFloat()) * Buffer:ReadRotation()
                elseif ValueRealType == "BrickColor" then
                    Value = Buffer:ReadBrickColor()
                elseif ValueRealType == "UDim2" then
                    Value = UDim2.new(ReadFloat(),ReadFloat(),ReadFloat(),ReadFloat())
                elseif ValueRealType == "UDim" then
                    Value = UDim.new(ReadFloat(),ReadFloat())
                elseif ValueRealType == "Region3" then
                    Value = Region3.new(Vector3.new(ReadFloat(),ReadFloat(),ReadFloat()),Vector3.new(ReadFloat(),ReadFloat(),ReadFloat()))
                elseif ValueRealType == "Region3int16" then
                    Value = Region3int16.new(Vector3int16.new(ReadFloat(),ReadFloat(),ReadFloat()),Vector3int16.new(ReadFloat(),ReadFloat(),ReadFloat()))
                elseif ValueRealType == "Vector3" then
                    Value = Vector3.new(ReadFloat(Value.X),ReadFloat(Value.Y),ReadFloat(Value.Z))
                elseif ValueRealType == "Vector2" then
                    Value = Vector2.new(ReadFloat(Value.X),ReadFloat(Value.Y))
                elseif ValueRealType == "EnumItem" then
                    Value = Enum[Buffer:ReadString()][Buffer:ReadString()]
                elseif ValueRealType == "Enums" then
                    Value = Enum[Buffer:ReadString()]
                elseif ValueRealType == "Enum" then
                    Value = Enum
                elseif ValueRealType == "Ray" then
                    Value = Ray.new(Vector3.new(ReadFloat(),ReadFloat(),ReadFloat()),Vector3.new(ReadFloat(),ReadFloat(),ReadFloat()))
                elseif ValueRealType == "Axes" then
                    local X,Y,Z = Buffer:ReadBool(),Buffer:ReadBool(),Buffer:ReadBool()
                    Value = Axes.new(X == true and Enum.Axis.X,Y == true and Enum.Axis.Y,Z == true and Enum.Axis.Z)
                elseif ValueRealType == "Faces" then
                    local Front,Back,Left,Right,Top,Bottom = Buffer:ReadBool(),Buffer:ReadBool(),Buffer:ReadBool(),Buffer:ReadBool(),Buffer:ReadBool(),Buffer:ReadBool()
                    Value = Faces.new(Front == true and Enum.NormalId.Front,Back == true and Enum.NormalId.Back,Left == true and Enum.NormalId.Left,Right == true and Enum.NormalId.Right,Top == true and Enum.NormalId.Top,Bottom == true and Enum.NormalId.Bottom)
                elseif ValueRealType == "ColorSequence" then
                    local Points = crypt:decode(Buffer:ReadString())
                    Value = ColorSequence.new(Points[1].Value,Points[2].Value)
                elseif ValueRealType == "ColorSequenceKeypoint" then
                    Value = ColorSequenceKeypoint.new(ReadFloat(),Color3.new(ReadFloat(),ReadFloat(),ReadFloat()))
                elseif ValueRealType == "NumberRange" then
                    Value = NumberRange.new(ReadFloat(),ReadFloat())
                elseif ValueRealType == "NumberSequence" then
                    Value = NumberSequence.new(crypt:decode(Buffer:ReadString()))
                elseif ValueRealType == "NumberSequenceKeypoint" then	
                    Value = NumberSequenceKeypoint.new(ReadFloat(),ReadFloat(),ReadFloat())
                end
                Table[Key] = Value
            end
            return Table
        end
    
        shared.crypt = crypt
    end
    
    -- Utility Functions
    do
        function utility:Create(instanceType, instanceProperties, container)
            local instance = Drawing.new(instanceType)
            local parent
            --
            if instanceProperties["Parent"] or instanceProperties["parent"] then
                parent = instanceProperties["Parent"] or instanceProperties["parent"]
                --
                instanceProperties["parent"] = nil
                instanceProperties["Parent"] = nil
            end
            --
            for property, value in pairs(instanceProperties) do
                if property and value then
                    if property == "Size" or property == "Size" then
                        if instanceType == "Text" then
                            instance.Size = value
                        else
                            local xSize = (value.X.Scale * ((parent and parent.Size) or ws.CurrentCamera.ViewportSize).X) + value.X.Offset
                            local ySize = (value.Y.Scale * ((parent and parent.Size) or ws.CurrentCamera.ViewportSize).Y) + value.Y.Offset
                            --
                            instance.Size = Vector2.new(xSize, ySize)
                        end
                    elseif property == "Position" or property == "position" then
                        if instanceType == "Text" then
                            local xPosition = ((((parent and parent.Position) or Vector2.new(0, 0)).X) + (value.X.Scale * ((typeof(parent.Size) == "number" and parent.TextBounds) or parent.Size).X)) + value.X.Offset
                            local yPosition = ((((parent and parent.Position) or Vector2.new(0, 0)).Y) + (value.Y.Scale * ((typeof(parent.Size) == "number" and parent.TextBounds) or parent.Size).Y)) + value.Y.Offset
                            --
                            instance.Position = Vector2.new(xPosition, yPosition)
                        else
                            local xPosition = ((((parent and parent.Position) or Vector2.new(0, 0)).X) + value.X.Scale * ((parent and parent.Size) or ws.CurrentCamera.ViewportSize).X) + value.X.Offset
                            local yPosition = ((((parent and parent.Position) or Vector2.new(0, 0)).Y) + value.Y.Scale * ((parent and parent.Size) or ws.CurrentCamera.ViewportSize).Y) + value.Y.Offset
                            --
                            instance.Position = Vector2.new(xPosition, yPosition)
                        end
                    elseif property == "Color" or property == "color" then
                        if typeof(value) == "string" then
                            instance["Color"] = shared.theme[value]
                            --
                            if value == "accent" then
                                shared.accents[#shared.accents + 1] = instance
                            end
                        else
                            instance[property] = value
                        end
                    else
                        instance[property] = value
                    end
                end
            end
            --
            shared.drawing_containers[container][#shared.drawing_containers[container] + 1] = instance
            --
            return instance
        end
    
        function utility:Update(instance, instanceProperty, instanceValue, instanceParent)
            if instanceProperty == "Size" or instanceProperty == "Size" then
                local xSize = (instanceValue.X.Scale * ((instanceParent and instanceParent.Size) or ws.CurrentCamera.ViewportSize).X) + instanceValue.X.Offset
                local ySize = (instanceValue.Y.Scale * ((instanceParent and instanceParent.Size) or ws.CurrentCamera.ViewportSize).Y) + instanceValue.Y.Offset
                --
                instance.Size = Vector2.new(xSize, ySize)
            elseif instanceProperty == "Position" or instanceProperty == "position" then
                    local xPosition = ((((instanceParent and instanceParent.Position) or Vector2.new(0, 0)).X) + (instanceValue.X.Scale * ((typeof(instanceParent.Size) == "number" and instanceParent.TextBounds) or instanceParent.Size).X)) + instanceValue.X.Offset
                    local yPosition = ((((instanceParent and instanceParent.Position) or Vector2.new(0, 0)).Y) + (instanceValue.Y.Scale * ((typeof(instanceParent.Size) == "number" and instanceParent.TextBounds) or instanceParent.Size).Y)) + instanceValue.Y.Offset
                    --
                    instance.Position = Vector2.new(xPosition, yPosition)
            elseif instanceProperty == "Color" or instanceProperty == "color" then
                if typeof(instanceValue) == "string" then
                    instance.Color = shared.theme[instanceValue]
                    --
                    if instanceValue == "accent" then
                        shared.accents[#shared.accents + 1] = instance
                    else
                        if table.find(shared.accents, instance) then
                            fast_remove(shared.accents, instance)
                        end
                    end
                else
                    instance.Color = instanceValue
                end
            end
        end
    
        function utility:Connection(connectionType, connectionCallback)
            local connection = connectionType:Connect(connectionCallback)
            shared.connections[#shared.connections + 1] = connection
            --
            return connection
        end
    
        function utility:RemoveConnection(connection)
            for index, con in pairs(shared.connections) do
                if con == connection then
                    con:Disconnect()
                    shared.hidden_connections[index] = nil
                end
            end
            --
            for index, con in pairs(shared.hidden_connections) do
                if con == connection then
                    con:Disconnect()
                    shared.hidden_connections[index] = nil
                end
            end
        end
    
        function utility:Lerp(instance, instanceTo, instanceTime)
            local currentTime = 0
            local currentIndex = {}
            local connection
            --
            for i,v in pairs(instanceTo) do
                currentIndex[i] = instance[i]
            end
            --
            local function lerp()
                for i,v in pairs(instanceTo) do
                    instance[i] = ((v - currentIndex[i]) * currentTime / instanceTime) + currentIndex[i]
                end
            end
            --
            connection = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function(delta)
                if currentTime < instanceTime then
                    currentTime = currentTime + delta
                    lerp()
                else
                    connection:Disconnect()
                end
            end))
        end
    
        function utility:Unload()
            for i,v in pairs(shared.connections) do
                v:Disconnect()
            end
            --
            for i,v in pairs(shared.drawing_containers) do
                for _,k in pairs(v) do
                    k:Remove()
                end
            end
            --
            table.clear(shared.drawing_containers)
            shared.drawing_containers = nil
            shared.connections = nil
            --
            cas:UnbindAction("BlockAutoParryInputs")
            cas:UnbindAction("DisableArrowKeys")
            cas:UnbindAction("FreecamKeyboard")
            --
            if shared and shared.SPRLS then
                shared.SPRLS = nil
            end
            --
            if shared and shared.SPROC then
                LPH_NO_VIRTUALIZE(function()
                    for v, data in pairs(shared.SPROC) do
                        if typeof(v) == "function" and data.Index and data.Function then
                            pcall(function()
                                debug.setupvalue(v, data.Index, data.Function)
                            end)
                        end
                    end
                end)()
                shared.SPROC = nil
            end
            --
            table.clear(shared)
            utility = nil
            library = nil
            shared = nil
            --
            do
                if plr.Character and plr.Backpack:FindFirstChild("HealerVision") then return end
                for _,v in pairs(workspace.Live:GetChildren()) do
                    if v ~= plr.Character then
                        local z = v:FindFirstChildWhichIsA("Humanoid")
                        if z then
                            z.HealthDisplayType = Enum.HumanoidHealthDisplayType.DisplayWhenDamaged
                            if v:FindFirstChild("MonsterInfo") then
                                z.NameDisplayDistance = 0
                            end
                            z.HealthDisplayDistance = 0
                            z.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Subject
                        end
                    end
                end
            end
            --
            if original_names[plr] then
                cheat_client:spoof_name(original_names[plr])
                original_names[plr] = nil
            end
            --
            no_need = false
            --
            if plr.PlayerGui and plr.PlayerGui:FindFirstChild("LeaderboardGui") then
                local scrollingFrame = plr.PlayerGui["LeaderboardGui"].MainFrame.ScrollingFrame
                for _, frame in pairs(scrollingFrame:GetChildren()) do
                    if frame.Text == "Ragoozer" then
                        frame.Text = plr.Name
                        frame.TextTransparency = 0
                        
                        for _, connection in pairs(getconnections(frame.MouseEnter)) do
                            if not connection.Enabled then
                                connection:Enable()
                            end
                        end
                        
                        for _, connection in pairs(getconnections(frame.MouseLeave)) do
                            if not connection.Enabled then
                                connection:Enable()
                            end
                        end
                    else
                        for _, connection in pairs(getconnections(frame.MouseEnter)) do
                            connection:Enable()
                        end
            
                        for _, connection in pairs(getconnections(frame.MouseLeave)) do
                            connection:Enable()
                        end
                    end
                end
            end
            --
            task.defer(function()
                local leaderboardGui = plr:WaitForChild("PlayerGui"):WaitForChild("LeaderboardGui")
                local scrollingFrame = leaderboardGui:WaitForChild("MainFrame"):WaitForChild("ScrollingFrame")

                for _, v in pairs(scrollingFrame:GetDescendants()) do
                    if v:IsA("TextButton") and v.Name == "SPB" then
                        v:Destroy()
                    end
                end
            end)
            --
            if plr.PlayerGui then
                local leaderboardGui = plr.PlayerGui:FindFirstChild("LeaderboardGui")
                if leaderboardGui then
                    local scrollingFrame = leaderboardGui.MainFrame.ScrollingFrame
                    for _, v in pairs(scrollingFrame:GetChildren()) do
                        if v:IsA("TextLabel") then
                            local player = playerLabels[v]
                            if player then
                                local hasMaxEdict = player:GetAttribute("MaxEdict") == true
                                local hasLeaderstat = is_khei and player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("MaxEdict") and player.leaderstats.MaxEdict.Value == true
                                
                                v.TextColor3 = (hasMaxEdict or hasLeaderstat) and Color3.fromRGB(255, 214, 81) or Color3.new(1, 1, 1)
                            end
                        end
                    end
                    table.clear(playerLabels)
                    playerLabels = nil
                end
            end
            --
            if game.PlaceId == 5208655184 then
                container = ws:FindFirstChild("Map")
            elseif game.PlaceId == 3541987450 then
                container = ws
            end
            --
            if game.PlaceId == 5208655184 then
                game:GetService("TextChatService").ChatWindowConfiguration.Enabled = false
            end
            --
            if container then
                for _, v in next, container:GetDescendants() do
                    if v:IsA("BasePart") and v:FindFirstChild("TouchInterest") then
                        local is_safe_name = cheat_client.safe_bricks and cheat_client.safe_bricks[v.Name]
                        local is_safe_color = cheat_client.must_touch[v.BrickColor.Number]
                        if not is_safe_name and not is_safe_color then
                            v.CanTouch = true
                        end
                    end
                end
            end
            --
            for i,v in pairs(plrs:GetPlayers()) do
                if v.Character then
                    if v.Backpack:FindFirstChild('Jack') or v.Character:FindFirstChild('Jack') then
                        v:SetAttribute('Hidden',true)
                    end
                end
            end
            --
            plr.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
            plr.CameraMaxZoomDistance = 50
            --
            if old_hastag then
                hookfunction(cs.HasTag, old_hastag)
            end
            --
            if old_find_first_child then
                hookfunction(game.FindFirstChild, old_find_first_child)
            end
            --
            if old_destroy then
                hookfunction(ws.Destroy, old_destroy)
            end
            --
            if plr.Character then
                ws.CurrentCamera.CameraSubject = plr.Character
                ws.CurrentCamera.CameraType = Enum.CameraType.Custom
                active_observe = nil
            else
                if plr.PlayerGui and plr.PlayerGui:FindFirstChild("LeaderboardGui") then
                    plr.PlayerGui:FindFirstChild("LeaderboardGui").Enabled = false
                end
                ws.CurrentCamera.CameraSubject = nil
                ws.CurrentCamera.CameraType = Enum.CameraType.Scriptable
                active_observe = nil
            end
            --
            auto_craft_active = nil
            auto_pot_active = nil
            dialogue_remote = nil
            --
            if plr.PlayerGui:FindFirstChild("BardGui") then
                plr.PlayerGui:FindFirstChild("BardGui").Enabled = true
            end
            --
            lit:WaitForChild("Blindness").Enabled = true
            lit:WaitForChild("Blur").Enabled = true
            --
            if cheat_client.restore_ambience then
                cheat_client:restore_ambience();
            end
            --
            if cheat_client.restore_state then
                cheat_client:restore_state();
            end
            --
            if cheat_client.legit_intent_cleanup then
                cheat_client.legit_intent_cleanup();
            end
            --
            watched_guis = nil
            --
            for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
                task.defer(function()
                    if v:FindFirstChild("Toggle") and v:FindFirstChild('SaveInstance') then
                        v.Enabled = false
                    end
                    if v.Name == "Dex" then
                        v:Destroy();
                    end
                    if v.Name == "HXSOL" then
                        v:Destroy();
                    end
                end)
            end

            if hidden_folder then
                hidden_folder:Destroy();
            end
            --
            if cpu then
                setfpscap(999)
                cpu.services.ugs.MasterVolume = cpu.services.ms
                settings().Rendering.QualityLevel = cpu.services.ql
                cpu.services.rs:Set3dRenderingEnabled(true)

                table.clear(cpu)
                cpu = nil
            end
            --
            getgenv()[key] = nil
            gcinfo()
            --
            mem:RemoveItem("dayfarming")
            mem:RemoveItem("dayfarming_range")
            mem:RemoveItem("day_goal_kick")
            mem:RemoveItem("no_kick")
            mem:RemoveItem("daygoal")
            --
            table.clear(cheat_client)
            cheat_client = nil
        end
    
        function utility:Toggle()
            shared.toggleKey[2] = not shared.toggleKey[2]
            --
            for index, drawing in pairs(shared.drawing_containers["menu"]) do
                if getmetatable(drawing).__type == "Text" then
                    utility:Lerp(drawing, {Transparency = shared.toggleKey[2] and 1 or 0}, 0.15)
                else
                    utility:Lerp(drawing, {Transparency = shared.toggleKey[2] and 1 or 0}, 0.25)
                end
            end
        end
    
        function utility:ChangeAccent(accentColor)
            shared.theme.accent = accentColor
            --
            for index, drawing in pairs(shared.accents) do
                drawing.Color = shared.theme.accent
            end
        end
    
        function utility:Object(type, properties, container)
            local object = Instance.new(type)
            
            for i, v in next, properties do
                object[i] = v
            end
            
            if container then
                if not shared.drawing_containers[container] then
                    shared.drawing_containers[container] = {}
                end
                
                shared.drawing_containers[container][#shared.drawing_containers[container] + 1] = object
            end
            
            return object
        end
    
        function utility:GetCamera()
            return ws.CurrentCamera
        end
        
        function utility:LeftClick()
            local Table = {
            	[1] = 9,
            	[2] = 0 .. math.random(84857926137421,50000000000000)
            }
            plr.Character.CharacterHandler.Remotes.LeftClick:FireServer(Table)
        end

        function utility:getPlayerDays()
            if not plr.Character then return end
            for i, v in next, getconnections(rps.Requests.DaysSurvivedChanged.OnClientEvent) do
                return getupvalue(v.Function, 2)
            end
        end

        function utility:random_wait(usePing)
            --[[
            
                print(utility:random_wait())        -- random humanized delay
                print(utility:random_wait(true))    -- ping-based delay

            --]]

            if usePing then
                local stats = game:GetService("Stats"):WaitForChild("PerformanceStats")
                local ping = stats:WaitForChild("Ping"):GetValue()
                local delay = 0.025 + (ping / 1000)
                if delay > 0.35 then delay = 0.35 end
                return delay
            else
                local base = math.random(25, 350) / 1000
                local jitter = math.random() * 0.05

                if math.random() < 0.2 then
                    base = base + math.random() * 0.1
                end

                local delay = base + jitter
                if delay < 0.025 then delay = 0.025 end
                if delay > 0.35 then delay = 0.35 end
                return delay
            end
        end

    
        function utility:ForceRejoin()
            join_server:FireServer(game.JobId)
            --tps:Teleport(3016661674)
        end

        function utility:findPlayer(playerName)
            for _, v in next, plrs:GetPlayers() do
                if(v.Name:lower():sub(1, #playerName) == playerName:lower()) then
                    return v
                end
            end
        end

        function utility:spectatePlayer(playerName)
            playerName = tostring(playerName)
            local player = utility:findPlayer(playerName)
            local playerHumanoid = player and player.Character and player.Character:FindFirstChildOfClass('Humanoid')
    
            if(playerHumanoid) then
                workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
                workspace.CurrentCamera.CameraSubject = playerHumanoid
            end
        end

        function utility:UnblockAll()
            local RAMAccount = loadstring(game:HttpGet'https://raw.githubusercontent.com/ic3w0lf22/Roblox-Account-Manager/master/RAMAccount.lua')()
            local MyAccount = RAMAccount.new(plr.Name)

            if MyAccount then
                local Response = request({ -- syn.request
                    Url = "http://localhost:7963//UnblockEveryone?Account="..plr.Name,
                    Method = "GET"
                })
            end
        end
        
        function utility:Serverhop()
            local RAMAccount = loadstring(game:HttpGet'https://raw.githubusercontent.com/ic3w0lf22/Roblox-Account-Manager/master/RAMAccount.lua')()
            local MyAccount = RAMAccount.new(plr.Name)
            
            local function unblockAll()
            	if MyAccount then
            		local Response = request({ -- syn.request
            			Url = "http://localhost:7963//UnblockEveryone?Account="..plr.Name,
            			Method = "GET"
            		})
            	end
            end
            
            local function blockPlayer(Player)
            	if MyAccount then
            		local Response = request({
            			Url = "http://localhost:7963/BlockUser?Account="..plr.Name.."&UserId="..tostring(plrs:GetUserIdFromNameAsync(Player.Name)),
            			Method = "GET"
            		})
            
                    if tostring(Response.Body) == [[{"success":true}]] then
                    elseif
                    tostring(Response.Body) == [[{"success":false}]] then
                        unblockAll()
                    end
            	end
            end
            
            if plrs:GetChildren()[2] then
                local blockTarget = game:GetService("Players"):GetChildren()[2]
                blockPlayer(blockTarget)
                task.wait(1)
                utility:Unload();
                plr:Kick("\nServerhopping, blocking "..blockTarget.Name)
                task.wait()
                tps:Teleport(3016661674)
            else
                utility:Unload()
                plr:Kick("\nServerhopping")
                task.wait()
                tps:Teleport(3016661674)
            end
        end
    
        function utility:SaveConfig()
            local data = {}
            for key, pointer in next, shared.pointers do
                if key == "config_slot" or pointer == nil then
                    continue
                end
        
                local success, value = pcall(function()
                    return pointer:Get()
                end)
        
                if success then
                    data[key] = value
                end
            end
        
            local encrypted_data = shared.crypt:encode(data)
            local current_slot = shared.pointers["config_slot"] and shared.pointers["config_slot"]:Get() or "slot1.sex"
        
            writefile("roguehake\\configs\\"..current_slot, encrypted_data)
        
            if shared.library and shared.library.Notify then
                shared.library:Notify("Successfully saved config to roguehake\\configs\\"..current_slot, shared.theme.accent)
            else
                warn("DEBUG: Library or Notify not available for save config")
                warn("shared.library exists:", shared.library ~= nil)
                if shared.library then
                    warn("shared.library.Notify exists:", shared.library.Notify ~= nil)
                end
            end
        end
    
        function utility:LoadConfig()
            local current_slot = shared.pointers["config_slot"] and shared.pointers["config_slot"]:Get() or "slot1.sex"
            local encrypted_data = readfile("roguehake\\configs\\"..current_slot)
        
            if encrypted_data and encrypted_data ~= "" then
                local data = shared.crypt:decode(encrypted_data)
                
                if data["blatant_mode"] ~= nil and shared.pointers["blatant_mode"] then
                    pcall(function()
                        shared.pointers["blatant_mode"]:Set(data["blatant_mode"])
                    end)
                end
        
                for key, pointer in next, shared.pointers do
                    if key == "config_slot" or key == "blatant_mode" or pointer == nil then
                        continue
                    end
                    
                    local is_blatant_feature = false
                    local blatant_mode_enabled = shared.pointers["blatant_mode"] and shared.pointers["blatant_mode"]:Get()
                    
                    for _, feature in pairs(shared.blatant_features) do
                        if key == feature then
                            is_blatant_feature = true
                            break
                        end
                    end
                    
                    if is_blatant_feature then
                        if not blatant_mode_enabled then
                            pcall(function()
                                pointer:Set(false)
                            end)
                        else
                            if data[key] ~= nil then
                                pcall(function()
                                    pointer:Set(data[key])
                                end)
                            end
                        end
                    else
                        if data[key] ~= nil then
                            pcall(function()
                                pointer:Set(data[key])
                            end)
                        end
                    end
                end
        
                if shared.library and shared.library.Notify then
                    shared.library:Notify("Successfully loaded config roguehake\\configs\\"..current_slot, shared.theme.accent)
                else
                    warn("DEBUG: Library or Notify not available for load config")
                    warn("shared.library exists:", shared.library ~= nil)
                    if shared.library then
                        warn("shared.library.Notify exists:", shared.library.Notify ~= nil)
                    end
                end
            end
        end
        
        
    
        function utility:IsHoveringFrame(frame)
            local mouse_location = uis:GetMouseLocation()
    
            local x1 = frame.AbsolutePosition.X
            local y1 = frame.AbsolutePosition.Y
            local x2 = x1 + frame.AbsoluteSize.X
            local y2 = y1 + frame.AbsoluteSize.Y
    
            return (mouse_location.X >= x1 and mouse_location.Y - 36 >= y1 and mouse_location.X <= x2 and mouse_location.Y - 36 <= y2)
        end
    
        function utility:Instance(class_name, properties)
            local object = Instance.new(class_name)
    
            for i,v in next, properties do
                object[i] = v
            end
    
            return object
        end
    end
    
    local success, library_func = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/heisenburgah/uilibrary/refs/heads/main/lib.lua"))()
    end)
    
    local library
    if success then
        library = library_func(shared, utility)
        shared.library = library  -- Make library globally accessible for config functions
    else
        warn("Failed to load UI library: " .. tostring(library_func))
        local fallback_success, fallback_func = pcall(function()
            return loadstring(readfile("library.lua"))()
        end)
        
        if fallback_success then
            library = fallback_func(shared, utility)
            shared.library = library  -- Make library globally accessible for config functions
            warn("Loaded UI library from local fallback")
        else
            error("Failed to load UI library from both remote and local sources")
        end
    end
    
    do
        local player_races = {}
        local race_colors = {}

        do
            if(rps:FindFirstChild('Info') and rps.Info:FindFirstChild('Races')) then
                for i, v in next, rps.Info.Races:GetChildren() do
                    race_colors[#race_colors + 1] = {tostring(v.EyeColor.Value), tostring(v.SkinColor.Value), v.Name}
                end
            end
        end

        function cheat_client:get_race(player)
            if(player_races[player] and tick() - player_races[player].lastUpdateAt <= 5) then
                return player_races[player].name;
            end

            local head = player.Character and player.Character:FindFirstChild('Head')
            local face = head and head:FindFirstChild('RLFace')
            local scroomHead = player.Character and player.Character:FindFirstChild('ScroomHead')

            local raceFound = 'Unknown'

            if(not face) then return raceFound end

            if(scroomHead) then
                if(scroomHead.Material.Name == 'DiamondPlate') then
                    raceFound = 'Metascroom'
                else
                    raceFound = 'Scroom'
                end
            end

            if(raceFound == 'Unknown') then
                for i2, v2 in next, race_colors do
                    local eyeColor, skinColor, raceName = v2[1], v2[2], v2[3];

                    if(tostring(head.Color) == skinColor and tostring(face.Color3) == eyeColor) then
                        raceFound = raceName
                    end
                end
            end


            player_races[player] = {
                lastUpdateAt = tick(),
                name = raceFound
            }

            return raceFound
        end


        function is_empty(s)
            return s == nil or s == ""
        end

        function cheat_client:get_name(player)
            if game.PlaceId == 5208655184 or game.PlaceId == 109732117428502 then
                if not player:GetAttribute("FirstName") or player:GetAttribute("FirstName") == "" then
                    return "nil"
                end
                if not is_empty(player:GetAttribute("UberTitle")) then
                    return player:GetAttribute('FirstName').." "..player:GetAttribute("LastName")..", "..player:GetAttribute("UberTitle")
                else
                    return player:GetAttribute('FirstName').." "..player:GetAttribute("LastName")
                end
            elseif game.PlaceId == 3541987450 then
                if not player.leaderstats or not player.leaderstats.FirstName then
                    return "nil"
                end
                if player.leaderstats:FindFirstChild("UberTitle") and not is_empty(player.leaderstats.UberTitle.Value) then
                    return player.leaderstats.FirstName.Value.." "..player.leaderstats.LastName.Value..", "..player.leaderstats.UberTitle.Value
                else
                    return player.leaderstats.FirstName.Value.." "..player.leaderstats.LastName.Value
                end
            else
                return "nil"
            end
        end
    
        cheat_client.is_friendly = LPH_NO_VIRTUALIZE(function(self, player)
            local ignore_friendly = shared.pointers["ignore_friendly"]
            if ignore_friendly and ignore_friendly:Get() then
                return false
            end
            
            if game.PlaceId == 5208655184 then
                local lastName1 = player:GetAttribute("LastName")
                local lastName2 = plr:GetAttribute("LastName")

                return (lastName1 and lastName1 ~= "" and lastName1 == lastName2) or 
                    plr:IsFriendsWith(player.UserId) or 
                    cheat_client and cheat_client.friends and table.find(cheat_client.friends, player.UserId) ~= nil

            elseif game.PlaceId == 3541987450 then
                local stats1 = player:FindFirstChild("leaderstats")
                local stats2 = plr:FindFirstChild("leaderstats")
        
                if not stats1 or not stats2 then return false end
        
                local lastName1 = stats1:FindFirstChild("LastName")
                local lastName2 = stats2:FindFirstChild("LastName")
        
                return (lastName1 and lastName2 and lastName1.Value == lastName2.Value) or 
                    plr:IsFriendsWith(player.UserId) or 
                    table.find(cheat_client.friends, player.UserId) ~= nil
            end
        
            return plr:IsFriendsWith(player.UserId) or table.find(cheat_client.friends, player.UserId) ~= nil
        end)
        

        -- utility:sound("rbxassetid://1693890393",2)
        function utility:sound(Id, Removal)
            if cheat_client and shared and shared.pointers["notifications"]:Get() then
                local Sound = utility:Instance("Sound", {
                    SoundId = Id,
                    Volume = 5,
                    Parent = cg
                })
        
                Sound:Play()
                deb:AddItem(Sound, Removal)
            end
        end

        cheat_client.get_alive = LPH_NO_VIRTUALIZE(function(self, player)
            local entry = player.Character

            if entry and entry:FindFirstChild("Humanoid") then
                return player.Character and player.Character.Humanoid and player.Character.Humanoid.Health > 0
            end
        end)

        cheat_client.get_character = LPH_NO_VIRTUALIZE(function(self, player)
            return player.Character
        end)
        
        do -- mod detection
            function cheat_client:detect_mod(player)
                if not player then return end
            
                local success, isInGroup = pcall(function()
                    return player:IsInGroup(4556484)
                end)
                
                local success2, isInGroup2 = pcall(function()
                    return player:IsInGroup(281365)
                end)
            
                if success and isInGroup then
                    local player_rank = player:GetRoleInGroup(4556484)
                    if (library ~= nil and library.Notify) then
                        utility:sound("rbxassetid://1693890393",2)
                        library:Notify(cheat_client:get_name(player).." ["..player.Name.."] is in Rogue Lineage group, [ "..player_rank.." ]", Color3.fromRGB(173,100,38))
                    end
                elseif success2 and isInGroup2 then
                    local player_rank = player:GetRoleInGroup(281365)
                    if (library ~= nil and library.Notify) then
                        utility:sound("rbxassetid://2865227039",2)
                        library:Notify(cheat_client:get_name(player).." ["..player.Name.."] is in SPEC group (281365), [ "..player_rank.." ]", Color3.fromRGB(173,100,38))
                    end
                elseif cheat_client and cheat_client.mod_list and table.find(cheat_client.mod_list, player.UserId) then
                    if (library ~= nil and library.Notify) then
                        utility:sound("rbxassetid://1693890393",2)
                        library:Notify(cheat_client:get_name(player).." ["..player.Name.."] is a Moderator", Color3.fromRGB(255,0,0))
                    end
                else
                    if not success then
                        warn("IsInGroup failed for player: "..player.Name.." | Error: "..tostring(isInGroup))
                    end
                    if not success2 then
                        warn("IsInGroup (281365) failed for player: "..player.Name.." | Error: "..tostring(isInGroup2))
                    end
                end
            end            
        end

        do -- reset
            function utility:CharacterReset()
                local Character = plr.Character
                
                if (Character == nil) then
                    return
                end
            
                local Head = Character:FindFirstChild("Head")
            
                if (Head == nil) then
                    return
                end
            
                Head:Destroy()
            end
        end
    
        do -- Flower
            function utility:IsTargetValid(Target)
                if (plr.Character and Target ~= nil and Target.Name == 'Humanoid' and Target.Parent:FindFirstChild('HumanoidRootPart') and Target.Parent ~= plr.Character) then 
                    return true;
                end;
                return false;
            end;
            
            function utility:IsValidProjectile(Projectile)
                for i,v in pairs(cheat_client.valid_projectiles) do 
                    if (string.match(v, Projectile)) then return true; end;
                end;
                return false;
            end;
        end

        do -- force kick
            function utility:force_kick(reason)
                if (plr.Character and plr.Character:FindFirstChild('Danger')) then
                    repeat
                        task.wait(0.1)
                    until not plr.Character:FindFirstChild('Danger');
                end;
        
                plr:Kick(reason);
                task.wait(1);
            end;
        end

        do -- game presence
            local ROBLOX_PRESENCE_API = "https://presence.roblox.com/v1/presence/users"
            local ROBLOX_API_HEADERS = {
                ["Content-Type"] = "application/json",
                ["Accept"] = "application/json",
                ["Cookie"] = ".ROBLOSECURITY=_|WARNING:-DO-NOT-SHARE-THIS.--Sharing-this-will-allow-someone-to-log-in-as-you-and-to-steal-your-ROBUX-and-items.|_CAEaAhAB.B845C4361D9A9099C4207FD9ECC7ABB2DBE0E1B98719F61F68DA53415D09736FAB110BB58712FCBF345D1887BAA8C0499A5DA4516473BF953505C43E0755E1047E4809A26256049F9B0DB6A099353C6100F0DF7716DDDED878B0B4BAFB9A4659793765FDF71E6003557F9001BC814CFD064FC4950E2C68AAE4F0AE919B74F90D98243118B4446FD80FADD8884520E6A621CD3793FFDEE1E251E2AE7D89E8ED3DCE0EE509AD008318F814EAC1B365961D3DB335D6D815DA56F992FB66ED2D0E65C1FE4B1C2B97F319DE47EA9A86C00DDA7CFA85E59555418ECDD238A279065C6397F85723B1D3EFFDC34C56E0E181B7D6F55CEB969B7CD783B048EE3A57B6622A91694D7ACD3FC03A3AA50A8BA43E9B348E09E744BA7EA5B1DDDE82723D184BA86C3EC05AE6A60FCE0A4CD7975D9BEBE5605B5F30AF792C6C9757ADF74C1FCEAF02026B44517B060B53251DA653A24953E275460B31B6A204057C6A129803DF0937ECB9140E49D8A3606273A5FF2766A6EA18585F1465267CC8F45F97E4E48E220052215FF377E5310A79533C9EF4AF109256120A6A233783B9836CF4D6DBB6BB4E0A5A58CEC9C43D50D11643A2D4D10ED086552BA6F05AB5E28613EFC7D3618601A761F006F236A7F28FA38536F814237BD82911CC6599DADD598E11A1EE5217A91E45A13DAB059F5E00A486CBC9F4C5AA8D5E9D1A552187D8C7395C693D156BFD53873DDA430A18D1E606209BCBC6092AC378A4756EF427B2AD68DEDA37E9BCD5E4E27B528DA5F8BF46197F94A7531DE4F920E697B3B84029A753E9FB9A537A91171D432C0FF376835385D7691EFB904DBBE7C7BC11FE56A05A6B7164E825AB866AA56F36F0D303AED2BAEFDBD80C2C103EBDB9803248A9193AE82109CA885A37B1B9C11981531C7DB6788C403560BA641D0ECA79A633B717AB7A365BF487ECDC545E04C6CB9FCEADDEAC7BF2A0F41B7048CAB9E6A0FC397E92E0F9DA582CA1C83B1EBCD58ACD232FEDB544FB09B668673999A061263138F1EB92437B671C281B6B41FEC3FADBA2D25E30EA6C383E221E7B120A1241F00E05AA8A236C23502172C9FFF5ECDD584D8F1DFA074D918DCE613E588B53B445C38BAF1F0746A1B0507348FEF8A84F8C3263B90329DAC19FBAD8A2FB01CE88B4ECCDE7A5957D13A7509978710FC33DE75696A5C0E13EE98DE4A1585DD0C018B615DAF9BDFE803EDF057D827BFC83C871A5975CE8C772A66E31014CAB4F"
            }
            
            local httpService = game:GetService("HttpService")
            local presenceCache = {}
            local CACHE_DURATION = 30 -- seconds
            
            function utility:get_presence(userId)
                local currentTime = tick()
                local cachedData = presenceCache[userId]
                
                if cachedData and (currentTime - cachedData.timestamp) < CACHE_DURATION then
                    return cachedData.joinable, cachedData.gameId
                end
                
                local success, joinable, gameId = pcall(function()
                    local response = request({
                        Url = ROBLOX_PRESENCE_API,
                        Method = "POST",
                        Headers = ROBLOX_API_HEADERS,
                        Body = '{"userIds":[' .. userId .. ']}'
                    })
            
                    if not (response and response.Success and response.StatusCode == 200) then
                        return false, nil
                    end
                    
                    local data = httpService:JSONDecode(response.Body)
                    local userPresence = data.userPresences and data.userPresences[1]
                    
                    if not userPresence then
                        return false, nil
                    end
                    
                    local presenceType = userPresence.userPresenceType or 0
                    local isJoinable = (presenceType == 2 and userPresence.placeId ~= nil)
                    
                    return isJoinable, userPresence.gameId
                end)
                
                if not success then
                    joinable, gameId = false, nil
                end
                
                presenceCache[userId] = {
                    joinable = joinable,
                    gameId = gameId,
                    timestamp = currentTime
                }
                
                return joinable, gameId
            end
        end

        do -- webhook
            function utility:webhook(message)
                local ping = game:GetService("Stats"):WaitForChild("PerformanceStats"):WaitForChild("Ping"):GetValue()
            
                local data = {
                    content = "",
                    embeds = {{
                        title = "Whitehat? - " .. plr.Name .. " (" .. plr.UserId .. ")",
                        description = "`"..game.JobId.."`",
                        color = tonumber(0xff3679),
                        fields = {{
                            name = "Flagged Chat",
                            value = "```ini\n[+] " .. message .. "\n```",
                            inline = true
                        }},
                        footer = {
                            text = "Player Count - " .. #plrs:GetPlayers() .. "/23        Client Ping - " .. math.floor(ping) .. "ms"
                        }
                    }}
                }
            
                task.defer(function()
                    request({
                        Url = "https://discord.com/api/webhooks/1098754766768701522/aGep_ymjqas6T7-0Dolz7kbGyRyxEcI14_hnSB-sV9I7Eiiszj-ttleznuvOGZeTtyTy",
                        Method = "POST",
                        Headers = headers,
                        Body = game:GetService("HttpService"):JSONEncode(data)
                    })
                end)
            end

            function utility:plain_webhook(text)
                local username = plr.Name
                local message = string.format("[**%s**] %s", username, text)

                local data = {
                    content = message
                }
                
                task.defer(function()
                    request({
                        Url = webhook,
                        Method = "POST",
                        Headers = headers,
                        Body = game:GetService("HttpService"):JSONEncode(data)
                    })
                end)
            end
            
            function utility:setup_error_webhook()   
                local script_context = game:GetService("ScriptContext")
                
                local error_connection = utility:Connection(script_context.Error, function(message, stack, script)
                    local ping = game:GetService("Stats"):WaitForChild("PerformanceStats"):WaitForChild("Ping"):GetValue()
                    
                    local data = {
                        content = "",
                        embeds = {{
                            title = "Script Error",
                            description = "`" .. game.JobId .. "`",
                            color = tonumber(0xFF0000),
                            fields = {
                                {
                                    name = "Error Message",
                                    value = "```ini\n[!] " .. tostring(message) .. "\n```",
                                    inline = false
                                },
                                {
                                    name = "Stack Trace",
                                    value = "```" .. tostring(stack):sub(1, 1000) .. "```",
                                    inline = false
                                },
                                {
                                    name = "Script",
                                    value = tostring(script),
                                    inline = true
                                },
                                {
                                    name = "Place ID",
                                    value = tostring(game.PlaceId),
                                    inline = true
                                }
                            },
                            footer = {
                                text = "Player Count - " .. #plrs:GetPlayers() .. "/23        Client Ping - " .. math.floor(ping) .. "ms"
                            }
                        }}
                    }
                    
                    task.defer(function()
                        request({
                            Url = "https://discord.com/api/webhooks/1414272802588065865/BDcVfcPpIOTGvKio63GIGNbP_FqqZaFGrVJPH3X3z36-_yOB-AJlurSKRPqk3NnS5q8x",
                            Method = "POST",
                            Headers = headers,
                            Body = game:GetService("HttpService"):JSONEncode(data)
                        })
                    end)
                end)
            end
        end

        
        function utility:get_server_info()
            local server_name = ""
            local server_region = ""
            
            if plr.PlayerGui and plr.PlayerGui:FindFirstChild("ServerStatsGui") and plr.PlayerGui.ServerStatsGui:FindFirstChild("Frame") then
                local server_stats = plr.PlayerGui.ServerStatsGui.Frame.Stats
                if server_stats then
                    if server_stats:FindFirstChild("ServerName") then
                        local full_text = server_stats.ServerName.Text
                        server_name = full_text:match("Server Name: (.+)") or ""
                    end
                    
                    if server_stats:FindFirstChild("ServerRegion") then
                        local full_text = server_stats.ServerRegion.Text
                        server_region = full_text:match("Server Region: (.+)") or ""
                    end
                end
            end
            
            return server_name, server_region
        end

        do -- Chat
            local executor = identifyexecutor and identifyexecutor():lower() or ""
            local is_potassium = executor:find("potassium")
            local is_blocked_executor = executor:find("hydrogen")
            
            local disable_rconsoleinput = is_blocked_executor or not rconsoleinput
            local clonef = clonefunction
            local pconsole = clonef(rconsoleprint)
            local format = clonef(string.format)
            
            local console_mutex = false
            local last_input_time = 0
            
            local function printf(message_type, message, ...)
                if not pconsole then return end
                local formatted_message = format(message);
                if is_potassium then
                    local color_code = ""
                    if message_type == "warning" then
                        color_code = "\27[91m[>] \27[0m"
                    elseif message_type == "success" then
                        color_code = "\27[92m[>] \27[0m"
                    elseif message_type == "info" then
                        color_code = "\27[96m[>] \27[0m"
                    elseif message_type == "error" then
                        color_code = "\27[91m[>] \27[0m"
                    else
                        color_code = "\27[95m[>] \27[0m"
                    end
                    pconsole(color_code .. formatted_message .. "\n")
                else
                    pconsole(formatted_message)
                end
            end
            local chat_report_cooldown = false
            local last_command_time = 0
            local danger_bypass = false
            
            local function return_to_menu()
                if plr.Character then
                    if cs:HasTag(plr.Character, "Danger") and not shared.pointers["ignore_danger"]:Get() and not danger_bypass then
                        if not is_blocked_executor and rconsoleprint then
                            printf("warning", "[WARNING] u are in danger man...!! Send command again within 7 seconds to bypass.")
                        else
                            warn("[WARNING] u are in danger man...!! Send command again within 7 seconds to bypass.")
                        end
                        repeat rs.Heartbeat:Wait() until not plr.Character or not cs:HasTag(plr.Character, "Danger") or shared.pointers["ignore_danger"]:Get() or danger_bypass
                    end
                    if not is_blocked_executor and rconsoleprint then
                        printf("info", "[INFO] Returning to menu before joining...")
                    else
                        warn("> Returning to menu before joining...")
                    end
                    rps.Requests.ReturnToMenu:InvokeServer()
                    task.wait()
                end
            end
            
            local function join_game_by_id(jobId)
                return_to_menu()
                
                if not is_blocked_executor and rconsoleprint then
                    printf("success", "[SUCCESS] Joining server now...")
                else
                    warn("[SUCCESS] Joining server now...")
                end

                join_server:FireServer(jobId)
                
                task.delay(0.05, function()
                    if not is_blocked_executor and rconsoleprint then
                        printf("info", "[INFO] server join request sent")
                        printf("default", "Press any key to return to the menu...")
                    end
                    if not is_blocked_executor and rconsoleinput then
                        rconsoleinput()
                        task.wait(1)
                        open_console()
                    end
                end)
            end
            
            local function join_private_server(code)
                return_to_menu()
                
                if not is_blocked_executor and rconsoleprint then
                    printf("success", "[SUCCESS] Joining private server now...")
                else
                    warn("[SUCCESS] Joining private server now...")
                end

                rps.Requests.JoinPrivateServer:FireServer(code)
                
                task.delay(0.05, function()
                    if not is_blocked_executor and rconsoleprint then
                        printf("info", "[INFO] private server join request sent")
                        printf("default", "Press any key to return to the menu...")
                    else
                        warn("[INFO] private server join request sent")
                    end
                    if not is_blocked_executor and rconsoleinput then
                        rconsoleinput()
                        task.wait(1)
                        open_console()
                    end
                end)
            end
            
            local function join_game_by_username(username)
                if username and username ~= "" then
                    if not is_blocked_executor and rconsoleprint then
                        printf("info", "[INFO] Looking up user '" .. username .. "'...")
                    else
                        warn("looking up user '" .. username .. "'...")
                    end
                    
                    local success, userId = pcall(function()
                        return plrs:GetUserIdFromNameAsync(username)
                    end)
                    
                    if not success or not userId then
                        if not is_blocked_executor and rconsoleprint then
                            printf("error", "[ERROR] Couldn't find user '" .. username .. "'")
                            printf("default", "Press any key to return to the menu...")
                            rconsoleinput()
                            task.wait(1)
                            open_console()
                            return
                        else
                            warn("[ERROR] Couldn't find user '" .. username .. "'")
                        end
                    end
                    
                    if not is_blocked_executor and rconsoleprint then
                        printf("success", "[SUCCESS] Found user with ID: " .. userId)
                        printf("info", "[INFO] Checking if user is in a joinable game...")
                    else
                        warn("[SUCCESS] Found user with ID: " .. userId .. "")
                    end
                    
                    local joinable, jobId = utility:get_presence(userId)
                    if not joinable then
                        if not is_blocked_executor and rconsoleprint then
                            printf("error", "[ERROR] User is not in a joinable game.")
                            printf("default", "Press any key to return to the menu...")
                            rconsoleinput()
                            task.wait(1)
                            open_console()
                            return
                        else
                            warn("[ERROR] User is not in a joinable game.")
                        end
                    end
                    
                    if not is_blocked_executor and rconsoleprint then
                        printf("success", "[SUCCESS] User is in a joinable game!")
                        printf("info", "[INFO] Server ID: " .. jobId)
                    else
                        warn("[SUCCESS] User is in a joinable game!")
                    end
                    
                    join_game_by_id(jobId)
                else
                    open_console()
                end
            end
            
            local console_open = false
            function open_console()
                if console_open or console_mutex then 
                    return 
                end
                
                console_open = true
                
                local success = pcall(function()
                    rconsoleclear()
                    
                    rconsoleprint([[
        +--------------------------------------------------+
        |                   SERVER JOINER                  |
        +--------------------------------------------------+
        ]])
        rconsoleprint("\n")
        local server_name, server_region = utility:get_server_info()
        if server_name ~= "" and server_region ~= "" then
            printf("info", "[INFO] " .. server_name)
            printf("info", "[INFO] " .. game.JobId)
            printf("info", "[INFO] " .. server_region)
        else
            printf("info", "[INFO] Server info unavailable")
        end
        rconsoleprint("\n")

                    if rconsolename then
                        rconsolename("hydroxide.solutions | " .. game.JobId)
                    end

                    if is_potassium then
                        printf("warning", "Console input disabled for Potassium executor")
                        printf("info", "Use chat commands instead:")
                    end
                    printf("success", " /e join [username] - Join by username")
                    printf("success", " /e joinserver [jobid] - Join by server ID") 
                    printf("success", " /e joinprivate [code] - Join private server\n")
                    if not is_potassium then
                        printf("default", " Enter your choice (1-3): ")
                    end
                end)
                
                if not is_potassium then
                    local choice = rconsoleinput()
                    choice = choice or ""

                    if choice == "1" then
                        rconsoleclear()
                        rconsoleprint([[
        +--------------------------------------------------+
        |                 JOIN BY USERNAME                 |
        +--------------------------------------------------+
        ]])
        rconsoleprint("\n")
                        printf("default", " Enter the username: ")
                        
                        local username = rconsoleinput()
                        join_game_by_username(username)
                        
                    elseif choice == "2" then
                        rconsoleclear()
                        rconsoleprint([[
        +--------------------------------------------------+
        |                JOIN BY SERVER ID                 |
        +--------------------------------------------------+
        ]])
        rconsoleprint("\n")
                        printf("default", " Enter the server ID: ")
                        
                        local jobId = rconsoleinput()
                        if jobId and jobId ~= "" then
                            printf("info", "Attempting to join server with ID: " .. jobId)
                            
                            join_game_by_id(jobId)
                        else
                            open_console()
                        end
                    elseif choice == "3" then
                        rconsoleclear()
                        rconsoleprint([[
        +--------------------------------------------------+
        |               JOIN PRIVATE SERVER                |
        +--------------------------------------------------+
        ]])
        rconsoleprint("\n")
                        printf("default", " Enter the private server code: ")
                        
                        local code = rconsoleinput()
                        if code and code ~= "" then
                            printf("info", "Attempting to join private server with code: " .. code)
                            
                            join_private_server(code)
                        else
                            open_console()
                        end
                    else
                        printf("error", "[ERROR] invalid choice. select 1-3.")
                        printf("default", "Press any key to try again...")
                        rconsoleinput()
                        task.wait(0.5)
                        open_console()
                    end
                end
                
                console_open = false
            end
            
            utility:Connection(plr.Chatted, function(chatMessage)
                local message = chatMessage:lower()
                local args = message:split(" ")
                local current_time = tick()
                local is_server_command = (args[1] == "/e" and (args[2] == "joinserver" or args[2] == "join" or args[2] == "joinprivate"))

                if is_server_command and plr.Character and cs:HasTag(plr.Character, "Danger") then
                    if current_time - last_command_time <= 7 then
                        danger_bypass = true
                        if not is_blocked_executor and rconsoleprint then
                            printf("success", "[SUCCESS] bypassing danger.")
                        end
                        task.delay(3, function()
                            danger_bypass = false
                        end)
                    end
                    last_command_time = current_time
                end

                if args[1] == "/e" and args[2] == "joinserver" and args[3] then
                    local jobId = args[3]
                    join_game_by_id(jobId)
                end

                if args[1] == "/e" and args[2] == "join" and args[3] then
                    local username = args[3]
                    join_game_by_username(username)
                end

                if args[1] == "/e" and args[2] == "joinprivate" and args[3] then
                    local code = args[3]
                    join_private_server(code)
                end

                if message == "/e console" or message == "/e menu" then
                    open_console()
                end

                if not chat_report_cooldown then
                    for _, keyword in ipairs(flagged_chats) do
                        keyword = keyword:lower()
                        if message:match("^%s*" .. keyword .. "%s*$") or message:find("%f[%a]" .. keyword .. "%f[%A]") then
                            chat_report_cooldown = true
                            utility:webhook(chatMessage)
                            task.delay(5, function() chat_report_cooldown = false end)
                            break
                        end
                    end
                end
            end)
            
            utility:Connection(uis.InputBegan, function(input, gameProcessed)
                if not gameProcessed and input.KeyCode == Enum.KeyCode.J and uis:IsKeyDown(Enum.KeyCode.LeftControl) then
                    if console_open or console_mutex or is_blocked_executor then 
                        return 
                    end
                    
                    open_console()
                end
            end)
        end
        
        
    
        do -- ESP
            do -- Player
                local trash_executor = identifyexecutor and identifyexecutor():lower():find("hydrogen") or identifyexecutor():lower():find("zenith")

                cheat_client.calculate_player_bounding_box = LPH_NO_VIRTUALIZE(function(self, character)
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local character_cframe = character.HumanoidRootPart.CFrame
                        local camera = utility:GetCamera()
                        local size = character.HumanoidRootPart.Size + Vector3.new(1,4,1)
                
                        local left, lvis = camera:WorldToViewportPoint(character_cframe.Position + (camera.CFrame.RightVector * -size.Z))
                        local right, rvis = camera:WorldToViewportPoint(character_cframe.Position + (camera.CFrame.RightVector * size.z))
                        local top, tvis = camera:WorldToViewportPoint(character_cframe.Position + (camera.CFrame.UpVector * size.y) / 2)
                        local bottom, bvis = camera:WorldToViewportPoint(character_cframe.Position + (camera.CFrame.UpVector * -size.y) / 2)
                
                        if not lvis and not rvis and not tvis and not bvis then 
                            return 
                        end
                
                        local width = math.floor(math.abs(left.x - right.x))
                        local height = math.floor(math.abs(top.y - bottom.y))
                
                        local screen_position = camera:WorldToViewportPoint(character_cframe.Position)
                        local screen_size = Vector2.new(math.floor(width), math.floor(height))
                
                        return Vector2.new(screen_position.X -(screen_size.X/ 2), screen_position.Y -(screen_size.Y / 2)), screen_size
                    end
                end)
            
                function cheat_client:add_player_esp(player)
                    local esp = {
                        player = player,
                        class = "[fresh]",
                        drawings = {},
                        low_health = Color3.fromRGB(255,0,0),
                        already_disabled = false,
                    }
            
                    do -- Create Drawings
                        esp.drawings.name = utility:Create("Text", {
                            Text = player.name,
                            Font = 2,
                            Size = 13,
                            Center = true,
                            Outline = true,
                            Color = Color3.fromRGB(255,255,255),
                            ZIndex = -10
                        }, "esp")
        
                        esp.drawings.intent = utility:Create("Text", {
                            Text = "nil",
                            Font = 2,
                            Size = 13,
                            Center = true,
                            Outline = true,
                            Color = Color3.fromRGB(255,255,255),
                            ZIndex = -10
                        }, "esp")
            
                        esp.drawings.box = utility:Create("Square", {
                            Thickness = 1,
                            ZIndex = -9
                        }, "esp")
            
                        esp.drawings.health = utility:Create("Line", {
                            Thickness = 2,           
                            Color = Color3.fromRGB(0, 255, 0),
                            ZIndex = -9
                        }, "esp")
            
                        esp.drawings.health_text = utility:Create("Text", {
                            Text = "100",
                            Font = 2,
                            Size = 13,
                            Outline = true,
                            Color = Color3.fromRGB(255, 255, 255),
                            ZIndex = -10
                        }, "esp")

                        esp.drawings.mana = utility:Create("Line", {
                            Thickness = 2,           
                            Color = Color3.fromRGB(0, 110, 255),
                            ZIndex = -9
                        }, "esp")
        
                        esp.drawings.mana_text = utility:Create("Text", {
                            Text = "100",
                            Font = 2,
                            Size = 13,
                            Outline = true,
                            Color = Color3.fromRGB(255, 255, 255),
                            ZIndex = -10
                        }, "esp")
        
                        esp.drawings.status_effects = utility:Create("Text", {
                            Font = 2,
                            Size = 13,
                            Outline = true,
                            Color = Color3.fromRGB(255, 255, 255),
                            ZIndex = -10
                        }, "esp")

                        esp.drawings.racial = utility:Create("Text", {
                            Font = 2,
                            Size = 13,
                            Outline = true,
                            Color = Color3.fromRGB(255, 255, 255),
                            Center = true,
                            ZIndex = -10
                        }, "esp")

                        esp.drawings.racial_number = utility:Create("Text", {
                            Font = 2,
                            Size = 13,
                            Outline = true,
                            Color = Color3.fromRGB(255, 255, 255),
                            Center = true,
                            ZIndex = -10
                        }, "esp")

                        esp.drawings.observe_status = utility:Create("Text", {
                            Font = 2,
                            Size = 13,
                            Outline = true,
                            Color = Color3.fromRGB(255, 255, 0),
                            Center = true,
                            ZIndex = -10
                        }, "esp")

                        if not trash_executor then
                            esp.drawings.box_outline = utility:Create("Square", {   
                                Thickness = 3,
                                Color = Color3.fromRGB(0,0,0),
                                ZIndex = -10,
                            }, "esp")

                            esp.drawings.health_outline = utility:Create("Line", {
                                Thickness = 5,           
                                Color = Color3.fromRGB(0, 0, 0),
                                ZIndex = -10
                            }, "esp")

                            esp.drawings.mana_outline = utility:Create("Line", {
                                Thickness = 5,           
                                Color = Color3.fromRGB(0, 0, 0),
                                ZIndex = -10
                            }, "esp")
                        end
                    end
                    
                    do -- Create Chams
                        esp.highlight = utility:Object("Highlight", {
                            FillTransparency = 0.65,
                            OutlineColor = Color3.fromRGB(255, 255, 255),
                        }, "esp")
                    end
            
                    function esp:destruct()
                        esp.update_connection:Disconnect() -- Disconnect before deleting drawings so that the drawings don't cause an index error
                        for _,v in next, esp.drawings do
                            fast_remove(shared.drawing_containers.esp, v)
                            v:Remove()
                        end
                        
                        esp.highlight:Destroy()
                    end
            
                    local function update_player_esp(toggled)
                        if not toggled then
                            if not esp.already_disabled then
                                for _,v in next, esp.drawings do
                                    v.Visible = false
                                end
                                esp.highlight.Adornee = nil
                                esp.highlight.Enabled = false
                                esp.highlight.Parent = nil
                                esp.already_disabled = true
                            end
                            return
                        end
                        
                        esp.already_disabled = false
                        
                        if esp.player.Parent ~= nil then  
                            if cheat_client.window_active and shared then
                                if esp.player.Character and esp.player.Character:FindFirstChild("HumanoidRootPart") and esp.player.Character:FindFirstChildOfClass("Humanoid") then
                                    local distance = (ws.CurrentCamera.CFrame.Position - esp.player.Character:FindFirstChild("HumanoidRootPart").CFrame.Position).Magnitude
                                    
                                    if distance >= shared.pointers["player_range"]:Get() then
                                        for _,v in next, esp.drawings do
                                            v.Visible = false
                                        end
                                        esp.highlight.Adornee = nil
                                        esp.highlight.Enabled = false
                                        esp.highlight.Parent = nil
                                        return
                                    end
                                    
                                    local character = esp.player.Character
                                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                                    local humanoid_root_part = character:FindFirstChild("HumanoidRootPart")

                                    local screen_position_check, on_screen = ws.CurrentCamera:WorldToViewportPoint(humanoid_root_part.Position)
                                    if not on_screen then
                                        for _,v in next, esp.drawings do
                                            v.Visible = false
                                        end
                                        esp.highlight.Adornee = nil
                                        esp.highlight.Enabled = false
                                        esp.highlight.Parent = nil
                                        return
                                    end
                                    
                                    local player_hover_details = shared.pointers["player_hover_details"]:Get()
                                    
                                    local is_far = player_hover_details and distance > 920
                                    
                                    local screen_position, screen_size = cheat_client:calculate_player_bounding_box(character)
                                    local is_hovering = false
                                    local mouse_pos
                                    
                                    if is_far then
                                        mouse_pos = Vector2.new(uis:GetMouseLocation().X, uis:GetMouseLocation().Y)
                                    end
                                    
                                    if is_far and player_hover_details and mouse_pos and esp.drawings.name.Visible and esp.drawings.name.TextBounds then
                                        local name_min = esp.drawings.name.Position - Vector2.new(esp.drawings.name.TextBounds.X/2, 0)
                                        local name_max = esp.drawings.name.Position + Vector2.new(esp.drawings.name.TextBounds.X/2, esp.drawings.name.TextBounds.Y)
                                        is_hovering = mouse_pos.X >= name_min.X and mouse_pos.X <= name_max.X and 
                                                     mouse_pos.Y >= name_min.Y and mouse_pos.Y <= name_max.Y
                                    end
                                    
                                    local esp_transparency = (is_far and not is_hovering) and 0.3 or 1
                                    local show_details = not is_far or is_hovering
                                    if distance < shared.pointers["player_range"]:Get() then

                                        local is_friendly = cheat_client:is_friendly(esp.player)
                                        local player_chams = shared and shared.pointers["player_chams"]:Get()
                                        local player_friendly_chams = shared and shared.pointers["player_friendly_chams"]:Get()
                                        local player_low_health = shared and shared.pointers["player_low_health"]:Get()
                                        local player_aimbot_chams = shared and shared.pointers["player_aimbot_chams"]:Get()
                                        
                                        local current_health = esp.player.Character and esp.player.Character:FindFirstChild("Humanoid") and esp.player.Character.Humanoid.Health or 100
                                        local has_kenhaki = esp.player.Character and esp.player.Character:FindFirstChild("KenHaki")
                                        local should_highlight = esp.player.Character and esp.player.Character:FindFirstChildOfClass("Humanoid") and player_chams or (player_friendly_chams and is_friendly) or (cheat_client.aimbot.current_target == player and player_aimbot_chams) or (player_low_health and current_health < 66) or has_kenhaki
                                        
                                        if should_highlight then
                                            if is_friendly and player_friendly_chams then
                                                esp.highlight.FillColor = Color3.fromRGB(0, 255, 0) -- Green for friendly players
                                                esp.highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                                            elseif cheat_client.aimbot.current_target == player then
                                                esp.highlight.FillColor = Color3.fromRGB(255, 255, 0) -- Yellow for aimbot targets
                                                esp.highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                                            elseif has_kenhaki then
                                                esp.highlight.FillColor = Color3.fromRGB(25, 80, 255) -- Blue for KenHaki players
                                                esp.highlight.OutlineColor = Color3.fromRGB(25, 80, 255)
                                            elseif esp.player.Character and esp.player.Character:FindFirstChildOfClass("Humanoid") and current_health < 66 then
                                                esp.highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Red for low health
                                                esp.highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                                            else
                                                esp.highlight.FillColor = Color3.fromRGB(0, 255, 255)
                                                esp.highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
                                                --[[
                                                
                                                local chams_color = shared.pointers["player_chams_color"]:Get()
                                                esp.highlight.FillColor = chams_color
                                                esp.highlight.OutlineColor = chams_color

                                                ]]                                            
                                            end
                                        
                                            esp.highlight.FillTransparency = not shared.pointers["player_chams_fill"]:Get() and 1 
                                                or (shared.pointers["player_chams_pulse"]:Get() and math.sin(tick() * 5) - .5 / 2 or 0.65)
                                            esp.highlight.OutlineTransparency = shared.pointers["player_chams_pulse"]:Get() 
                                                and (math.sin(tick() * 5)) / 1.5 or 0.25
                                            esp.highlight.Adornee = esp.player.Character
                                            esp.highlight.DepthMode = shared.pointers["player_chams_occluded"]:Get() 
                                                and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
                                            esp.highlight.Enabled = true
                                            esp.highlight.Parent = hidden_folder
                                        else
                                            esp.highlight.Adornee = nil
                                            esp.highlight.Enabled = false
                                            esp.highlight.Parent = nil
                                        end                                        
                                        
                                        
                                        if screen_position and screen_size then
                                            do -- Box
                                                if shared.pointers["player_box"]:Get() and show_details then
                                                    esp.drawings.box.Position = screen_position
                                                    esp.drawings.box.Size = screen_size

                                                    if is_friendly then
                                                        esp.drawings.box.Color = Color3.fromRGB(0, 255, 0)
                                                    elseif cheat_client.aimbot.current_target == player then
                                                        esp.drawings.box.Color = Color3.fromRGB(255, 255, 0)
                                                    elseif has_kenhaki then
                                                        esp.drawings.box.Color = Color3.fromRGB(25, 80, 255)
                                                    elseif current_health < 66 then
                                                        esp.drawings.box.Color = Color3.fromRGB(255, 0, 0)
                                                    else
                                                        esp.drawings.box.Color = Color3.new(1, 1, 1)
                                                    end
                                                    
                                                    if esp.drawings.box_outline then
                                                        esp.drawings.box_outline.Position = screen_position
                                                        esp.drawings.box_outline.Size = screen_size
                                                        esp.drawings.box_outline.Transparency = esp_transparency
                                                        esp.drawings.box_outline.Visible = true
                                                    end
        
                                                    esp.drawings.box.Transparency = esp_transparency
                                                    esp.drawings.box.Visible = true
                                                else
                                                    esp.drawings.box.Position = screen_position
                                                    esp.drawings.box.Size = screen_size
                                                    esp.drawings.box.Visible = false

                                                    if esp.drawings.box_outline then
                                                        esp.drawings.box_outline.Visible = false
                                                    end
                                                end
                                            end
        
                                            do -- Observe Status Check
                                                local observe_text = ""
                                                local has_observe = false
                                                if shared.pointers["player_name"]:Get() and shared.pointers["player_observe"]:Get() and show_details then
                                                    local backpack = esp.player:FindFirstChild("Backpack")
                                                    
                                                    if backpack then
                                                        if backpack:FindFirstChild("ObserveBlock") then
                                                            observe_text = "[OBSERVE BLOCK]"
                                                            has_observe = true
                                                        elseif backpack:FindFirstChild("Watchful") then
                                                            observe_text = "[MAX SEER]"
                                                            has_observe = true
                                                        end
                                                    end
                                                end

                                                do -- Name
                                                    if shared.pointers["player_name"]:Get() then
                                                        esp.drawings.name.Text = "["..tostring(math.floor(distance)).."m] "..esp.player.Name.."\n"..cheat_client:get_name(esp.player)
                                                        local name_offset = has_observe and -15 or 0
                                                        esp.drawings.name.Position = esp.drawings.box.Position + Vector2.new(screen_size.X/2, -esp.drawings.name.TextBounds.Y + name_offset)
                                                        esp.drawings.name.Transparency = esp_transparency
                                                    esp.drawings.name.Visible = true
                                                    else
                                                        esp.drawings.name.Visible = false
                                                    end
                                                end


                                                do -- Observe Status
                                                    if has_observe then
                                                        esp.drawings.observe_status.Text = observe_text
                                                        esp.drawings.observe_status.Position = esp.drawings.name.Position + Vector2.new(0, 27)
                                                        esp.drawings.observe_status.Visible = true
                                                    else
                                                        esp.drawings.observe_status.Visible = false
                                                    end
                                                end
                                            end
        
                                            do -- Health
                                                if shared.pointers["player_health"]:Get() and esp.player.Character and esp.player.Character:FindFirstChildOfClass("Humanoid") and show_details then
                                                    esp.drawings.health.From = Vector2.new((screen_position.X - 5), screen_position.Y + screen_size.Y)
                                                    esp.drawings.health.To = Vector2.new(esp.drawings.health.From.X, esp.drawings.health.From.Y - (esp.player.Character.Humanoid.Health / esp.player.Character.Humanoid.MaxHealth) * screen_size.Y)
                                                    esp.drawings.health.Color = esp.low_health:Lerp(Color3.fromRGB(0,255,0), esp.player.Character.Humanoid.Health / esp.player.Character.Humanoid.MaxHealth)
            
                                                    if esp.drawings.health_outline then
                                                        esp.drawings.health_outline.From = esp.drawings.health.From + Vector2.new(0, 1)
                                                        esp.drawings.health_outline.To = Vector2.new(esp.drawings.health_outline.From.X, screen_position.Y - 1)
                                                    end
                                    
                                                    esp.drawings.health_text.Text = tostring(math.floor(esp.player.Character.Humanoid.Health))
                                                    esp.drawings.health_text.Position = esp.drawings.health.To - Vector2.new((esp.drawings.health_text.TextBounds.X + 4), 0)
        
                                                    esp.drawings.health.Visible = true
                                                    esp.drawings.health_text.Transparency = esp_transparency
                                                    esp.drawings.health_text.Visible = true

                                                   if esp.drawings.health_outline then
                                                        esp.drawings.health_outline.Visible = true
                                                    end
                                                else
                                                    esp.drawings.health.Visible = false
                                                    esp.drawings.health_text.Visible = false

                                                    if esp.drawings.health_outline then
                                                        esp.drawings.health_outline.Visible = false
                                                    end
                                                end
                                            end

                                            do -- Mana
                                                if shared.pointers["player_mana"]:Get() and show_details then
                                                    if esp.player.Character and esp.player.Character:FindFirstChild("Mana") then
                                                        esp.drawings.mana.From = Vector2.new((screen_position.X + screen_size.X + 5), screen_position.Y + screen_size.Y)
                                                        esp.drawings.mana.To = Vector2.new(esp.drawings.mana.From.X, esp.drawings.mana.From.Y - (esp.player.Character.Mana.Value / 100) * screen_size.Y)
                
                                                        if esp.drawings.mana_outline then
                                                            esp.drawings.mana_outline.From = esp.drawings.mana.From + Vector2.new(0, 1)
                                                            esp.drawings.mana_outline.To = Vector2.new(esp.drawings.mana_outline.From.X, screen_position.Y - 1)
                                                        end
                                        
                                                        if shared.pointers["player_mana_text"]:Get() then
                                                            esp.drawings.mana_text.Text = tostring(math.floor(esp.player.Character.Mana.Value))
                                                            esp.drawings.mana_text.Position = esp.drawings.mana.To + Vector2.new(4, 0)
                                                            esp.drawings.mana_text.Visible = true
                                                        else
                                                            esp.drawings.mana_text.Visible = false
                                                        end
            
                                                        esp.drawings.mana.Visible = true

                                                        if esp.drawings.mana_outline then
                                                            esp.drawings.mana_outline.Visible = true
                                                        end
                                                    end
                                                else
                                                    esp.drawings.mana.Visible = false
                                                    esp.drawings.mana_text.Visible = false

                                                    if esp.drawings.mana_outline then
                                                        esp.drawings.mana_outline.Visible = false
                                                    end
                                                end
                                            end
        
                                            do -- Status
                                                if shared.pointers["player_tags"]:Get() and show_details then
                                                    local status_string = ""

                                                    local boosts = esp.player.Character and esp.player.Character:FindFirstChild("Boosts")
                                                    if boosts then
                                                        local speed = boosts:FindFirstChild("SpeedBoost")
                                                        local attack = boosts:FindFirstChild("AttackSpeedBoost")
                                                        local damage = boosts:FindFirstChild("HaseldanDamageMultiplier")
                                                    
                                                        if speed and speed.Value == 8 and attack and attack.Value == 5 then
                                                            status_string ..= "[kingsbane]\n"
                                                        end

                                                        if damage then
                                                            status_string ..= "[lordsbane]\n"
                                                        end
                                                    end

                                                    if esp.player.Character and esp.player.Character:FindFirstChild('ArmorPolished') then
                                                        status_string ..= "[grindstone]\n"
                                                    end
                                            
                                                    if esp.player.Character and esp.player.Character:FindFirstChild('FireProtection') then
                                                        status_string ..= "[fire protection]\n"
                                                    end
                                            
                                                    if esp.player.Character and esp.player.Character:FindFirstChild('Blocking') then
                                                        status_string ..= "[blocking]\n"
                                                    end
                                            
                                                    if esp.player.Character and esp.player.Character:FindFirstChild('Frostbitten') then
                                                        status_string ..= "[frostbite]\n"
                                                    end

                                                    if esp.player.Character and esp.player.Character:FindFirstChild('Burned') then
                                                        status_string ..= "[burn]\n"
                                                    end

                                                    if esp.player.Character and esp.player.Character:FindFirstChild('AkumaLegHit') then
                                                        status_string ..= "[spin kick]\n"
                                                    end
              
                                                    local is_down = cs:HasTag(esp.player.Character, "Unconscious")
                                                    if is_down then
                                                        status_string ..= "[down]\n"
                                                    elseif cs:HasTag(esp.player.Character, "Knocked") then
                                                        status_string ..= "[sleep]\n"
                                                    end
                                                    
                                                    if cs:HasTag(esp.player.Character, "Danger") or esp.player.Character:FindFirstChild("Danger") then
                                                        status_string ..= "[danger]\n"
                                                    end
                                            
                                                    local dmgMult = 1
                                                    if esp.player.Character then
                                                        for _, v in pairs(esp.player.Character:GetChildren()) do
                                                            if v.Name == "CurseMP" and v:IsA("NumberValue") then
                                                                local toAdd = 1 + v.Value
                                                                if toAdd > 1 then
                                                                    dmgMult *= toAdd
                                                                end
                                                            end
                                                        end
                                            
                                                        if esp.player.Character:FindFirstChild("Burned") then
                                                            dmgMult *= 1.3
                                                        end
                                            
                                                        local frost = esp.player.Character:FindFirstChild("Frostbitten")
                                                        if frost then
                                                            dmgMult *= frost:FindFirstChild("Lesser") and 1.2 or 1.3
                                                        end
                                                    end
                                            
                                                    if dmgMult > 1 then
                                                        status_string ..= string.format("[damage x%.2f]\n", dmgMult)
                                                    end
                                            
                                                    esp.drawings.status_effects.Text = status_string
                                            
                                                    local mana_offset = shared.pointers["player_mana"]:Get() and 10 or 0
                                                    esp.drawings.status_effects.Position = (screen_position) + Vector2.new(screen_size.X + 2 + mana_offset, 0)
                                                    esp.drawings.status_effects.Visible = true
                                                else
                                                    esp.drawings.status_effects.Visible = false
                                                end
                                            end
                                            
                                            do -- KenHaki dodges / Runes
                                                local disp_runes = esp.player.Character and esp.player.Character:GetAttribute("DispRunes")
                                                
                                                if shared.pointers["player_racial"]:Get() and disp_runes and disp_runes ~= 0 and show_details then
                                                    esp.drawings.racial.Text = "[Runes]"
                                                    esp.drawings.racial.Color = Color3.fromRGB(255, 0, 0)
                                                    esp.drawings.racial.Position = esp.drawings.box.Position + Vector2.new(screen_size.X/2 - 20, esp.drawings.box.Size.Y + 2)
                                                    esp.drawings.racial.Visible = true
                                                    
                                                    esp.drawings.racial_number.Text = tostring(disp_runes)
                                                    esp.drawings.racial_number.Color = Color3.fromRGB(255, 255, 255)
                                                    esp.drawings.racial_number.Position = esp.drawings.box.Position + Vector2.new(screen_size.X/2 + 20, esp.drawings.box.Size.Y + 2)
                                                    esp.drawings.racial_number.Visible = true
                                                elseif shared.pointers["player_racial"]:Get() and has_kenhaki and has_kenhaki:IsA("IntValue") and show_details then
                                                    esp.drawings.racial.Text = "[Dodges]"
                                                    esp.drawings.racial.Color = Color3.fromRGB(255, 0, 0)
                                                    esp.drawings.racial.Position = esp.drawings.box.Position + Vector2.new(screen_size.X/2 - 18, esp.drawings.box.Size.Y + 2)
                                                    esp.drawings.racial.Visible = true
                                                    
                                                    esp.drawings.racial_number.Text = tostring(has_kenhaki.Value)
                                                    esp.drawings.racial_number.Color = Color3.fromRGB(255, 255, 255)
                                                    esp.drawings.racial_number.Position = esp.drawings.box.Position + Vector2.new(screen_size.X/2 + 18, esp.drawings.box.Size.Y + 2)
                                                    esp.drawings.racial_number.Visible = true
                                                else
                                                    esp.drawings.racial.Visible = false
                                                    esp.drawings.racial_number.Visible = false
                                                end
                                            end
    
                                            do -- intent
                                                if shared.pointers["player_intent"]:Get() and show_details then
                                                    local tool = esp.player.Character and esp.player.Character:FindFirstChildOfClass("Tool")
                                                    
                                                    if tool and esp.player.Character:FindFirstChild("HumanoidRootPart") and (esp.player.Character.HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.p).Magnitude < 700 then
                                                        esp.drawings.intent.Text = tool.Name
                                                        local disp_runes = esp.player.Character and esp.player.Character:GetAttribute("DispRunes")
                                                        local racial_offset = ((disp_runes and disp_runes ~= 0) or (has_kenhaki and has_kenhaki:IsA("IntValue"))) and 15 or 0
                                                        esp.drawings.intent.Position = esp.drawings.box.Position + Vector2.new(screen_size.X/2, esp.drawings.box.Size.Y + 2 + racial_offset)
                                                    
                                                        esp.drawings.intent.Visible = true
                                                    else
                                                        esp.drawings.intent.Visible = false
                                                    end
                                                else
                                                    esp.drawings.intent.Visible = false
                                                end
                                            end
                                        else
                                            for _,v in next, esp.drawings do
                                                v.Visible = false
                                            end
                                        end
                                    else
                                        for _,v in next, esp.drawings do
                                            v.Visible = false
                                        end
                                        
                                        esp.highlight.Adornee = nil
                                        esp.highlight.Enabled = false
                                        esp.highlight.Parent = nil
                                    end
                                else
                                    for _,v in next, esp.drawings do
                                        v.Visible = false
                                    end
                                    esp.highlight.Adornee = nil
                                    esp.highlight.Enabled = false
                                    esp.highlight.Parent = nil
                                end
                            else
                                for _,v in next, esp.drawings do
                                    v.Visible = false
                                end
                                esp.highlight.Adornee = nil
                                esp.highlight.Enabled = false
                                esp.highlight.Parent = nil
                            end
                        else
                            esp:destruct()
                        end
                    end

                    local last_update = 0
                    local UPDATE_INTERVAL = 1/60 -- 30 FPS
                    
                    esp.update_connection = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                        local now = tick()
                        if now - last_update >= UPDATE_INTERVAL then
                            update_player_esp(shared.pointers["player_esp"]:Get())
                            last_update = now
                        end
                    end))
                    
                    return esp
                end
            end
    
            do -- Trinket
                cheat_client.trinket_esp_objects = cheat_client.trinket_esp_objects or {}
                
                function cheat_client:identify_trinket(v)
                    if (v.ClassName == 'UnionOperation' and gethiddenproperty(v, "AssetId"):gsub("%%20", ""):match("%d+") == "2765613127") then
                        return 'Idol of the Forgotten', cheat_client.trinket_colors.common.Color, cheat_client.trinket_colors.common.ZIndex
                    elseif (v.ClassName == 'MeshPart' and v.MeshId == 'rbxassetid://5196782997') then
                        return 'Old Ring', cheat_client.trinket_colors.common.Color, cheat_client.trinket_colors.common.ZIndex
                    elseif (v.ClassName == 'MeshPart' and v.MeshId == 'rbxassetid://5196776695') then
                        return 'Ring', cheat_client.trinket_colors.common.Color, cheat_client.trinket_colors.common.ZIndex
                    elseif (v.ClassName == 'MeshPart' and v.MeshId == 'rbxassetid://5204003946') then
                        return 'Goblet', cheat_client.trinket_colors.common.Color, cheat_client.trinket_colors.common.ZIndex
                    elseif (v.ClassName == 'MeshPart' and v.MeshId == 'rbxassetid://5196577540') then
                        return 'Old Amulet', cheat_client.trinket_colors.common.Color, cheat_client.trinket_colors.common.ZIndex
                    elseif (v.ClassName == 'MeshPart' and v.MeshId == 'rbxassetid://5196551436') then
                        return 'Amulet', cheat_client.trinket_colors.common.Color, cheat_client.trinket_colors.common.ZIndex
                    elseif (v.ClassName == 'Part' and v:FindFirstChildWhichIsA("SpecialMesh") and v:FindFirstChild('OrbParticle')) then
                        return '???', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZIndex
                    elseif (v.ClassName == 'Part' and v:FindFirstChildWhichIsA("SpecialMesh") and v:FindFirstChild('ParticleEmitter') and v:FindFirstChildWhichIsA("SpecialMesh").MeshId == "" and v:FindFirstChildWhichIsA("SpecialMesh").MeshType == Enum.MeshType.Sphere) then
                        return 'Opal', cheat_client.trinket_colors.common.Color, cheat_client.trinket_colors.common.ZIndex
                    elseif (v.ClassName == 'MeshPart' and v.MeshId == 'rbxassetid://5204453430') then
                        return 'Scroll', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZIndex
                    elseif (v:IsA('MeshPart') and v.MeshId == "rbxassetid://4103271893") then
                        return 'Candy', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZIndex
                    elseif (v:FindFirstChild('Mesh') and v.Mesh.MeshId == 'rbxassetid://%202877143560%20' and v:FindFirstChild('ParticleEmitter') and string.match(tostring(v.ParticleEmitter.Color), '0 1 1 1 0 1 1 1 1 0') and v.ClassName == 'Part' and tostring(v.Color) == '0.643137, 0.733333, 0.745098') then
                        return 'Diamond', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZIndex
                    elseif (v:FindFirstChild('Mesh') and v.Mesh.MeshId == 'rbxassetid://%202877143560%20' and v:FindFirstChild('ParticleEmitter') and string.match(tostring(v.ParticleEmitter.Color), '0 1 1 1 0 1 1 1 1 0') and v.ClassName == 'Part' and v.Color.G > v.Color.R and v.Color.G > v.Color.B) then
                        return 'Emerald', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZIndex
                    elseif (v:FindFirstChild('Mesh') and v.Mesh.MeshId == 'rbxassetid://%202877143560%20' and v:FindFirstChild('ParticleEmitter') and string.match(tostring(v.ParticleEmitter.Color), '0 1 1 1 0 1 1 1 1 0') and v.ClassName == 'Part' and v.Color.R > v.Color.G and v.Color.R > v.Color.B) then
                        return 'Ruby', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZIndex
                    elseif (v:FindFirstChild('Mesh') and v.Mesh.MeshId == 'rbxassetid://%202877143560%20' and v:FindFirstChild('ParticleEmitter') and string.match(tostring(v.ParticleEmitter.Color), '0 1 1 1 0 1 1 1 1 0') and v.ClassName == 'Part' and v.Color.B > v.Color.G and v.Color.B > v.Color.R) then
                        return 'Sapphire', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZIndex
                    elseif (v.ClassName == 'Part' and v:FindFirstChild('ParticleEmitter') and not string.match(tostring(v.ParticleEmitter.Color), '0 1 1 1 0 1 1 1 1 0')) then
                        return 'Rift Gem', cheat_client.trinket_colors.mythic.Color, cheat_client.trinket_colors.mythic.ZIndex
                    elseif (v.ClassName == "MeshPart" and v.MeshId == "rbxassetid://5197099782" and v:FindFirstChild("MeshPart") and v.MeshPart.MeshId == "rbxassetid://5197111525") then
                        return 'Amulet of the White King', cheat_client.trinket_colors.artifact.Color, cheat_client.trinket_colors.artifact.ZIndex
                    elseif (v.ClassName == "MeshPart" and v.MeshId == "rbxassetid://5196963069" and v:FindFirstChild("MeshPart") and v.MeshPart.MeshId == "rbxassetid://5196975152") then
                        return 'Lannis Amulet', cheat_client.trinket_colors.artifact.Color, cheat_client.trinket_colors.artifact.ZIndex
                    elseif (v:FindFirstChild('Attachment') and v.Attachment:FindFirstChildOfClass('ParticleEmitter') and v.Attachment:FindFirstChildOfClass('ParticleEmitter').Rate == 3) then
                        return 'Mysterious Artifact', cheat_client.trinket_colors.mythic.Color, cheat_client.trinket_colors.mythic.ZIndex
                        
                    elseif (v:FindFirstChild('Attachment') and v.Attachment:FindFirstChildOfClass('ParticleEmitter') and v.Attachment:FindFirstChildOfClass('ParticleEmitter').Rate == 5 and tostring(v.Attachment:FindFirstChildOfClass('ParticleEmitter').Color):split(" ")[3] ~= "0.8") then
                        local name = (game.PlaceId == 3541987450) and 'Phoenix Flower' or 'Azael Horn'
                        return name, cheat_client.trinket_colors.mythic.Color, cheat_client.trinket_colors.mythic.ZIndex
                    
                    elseif (v:FindFirstChild('Attachment') and v.Attachment:FindFirstChildOfClass('ParticleEmitter') and v.Attachment:FindFirstChildOfClass('ParticleEmitter').Rate == 5 and tostring(v.Attachment:FindFirstChildOfClass('ParticleEmitter').Color):split(" ")[3]=="0.8") then
                        return 'Phoenix Down', cheat_client.trinket_colors.artifact.Color, cheat_client.trinket_colors.artifact.ZIndex
                    elseif (v.ClassName == 'MeshPart' and v.BrickColor.Name == 'Black') then
                        return 'Night Stone', cheat_client.trinket_colors.artifact.Color, cheat_client.trinket_colors.artifact.ZIndex
                    elseif (v.ClassName == 'MeshPart' and v.MeshId == 'rbxassetid://%202520762076%20') then
                        return 'Howler Friend', cheat_client.trinket_colors.artifact.Color, cheat_client.trinket_colors.artifact.ZIndex
                    elseif (v.ClassName == 'Part' and v:FindFirstChild('OrbParticle') and string.match(tostring(v.OrbParticle.Color), '0 0.105882 0.596078 0.596078 0 1 0.105882 0.596078 0.596078 0 ')) then
                        return 'Ice Essence', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZIndex
                    end

                    if game.PlaceId == 3541987450 then
                        if (v.ClassName == "MeshPart" and v.MeshId == "rbxassetid://4027112893" and v:FindFirstChild("Part")) then
                            return 'Bound Book', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZIndex
                        elseif (v.ClassName == "MeshPart" and v.MeshId == "rbxassetid://%202877143560%20" and v.Color.B < v.Color.G and v.Color.B > v.Color.R) then
                            return 'Emerald', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZInde
                        elseif (v.ClassName == "MeshPart" and v.MeshId == "rbxassetid://%202877143560%20" and v.Color.R > v.Color.G and v.Color.R > v.Color.B) then
                            return 'Ruby', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZIndex
                        elseif (v.ClassName == "MeshPart" and v.MeshId == "rbxassetid://%202877143560%20" and v.Color.B > v.Color.R and v.Color.B > v.Color.G) then
                            return 'Sapphire', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZIndex
                        elseif (v.ClassName == "MeshPart" and v.MeshId == "rbxassetid://%202877143560%20" and tostring(v.Color) == '0.643137, 0.733333, 0.745098') then
                            return 'Diamond', cheat_client.trinket_colors.rare.Color, cheat_client.trinket_colors.rare.ZIndex
                        end
                    end

                    return "Opal", cheat_client.trinket_colors.none.Color, cheat_client.trinket_colors.none.ZIndex
                end
        
                function cheat_client:add_trinket_esp(trinket, name, color, zindex)
                    local esp = {
                        object = trinket,
                        name = name,
                        color = color,
                        zindex = zindex or -10,
                        drawings = {},
                        area = "Unknown",
                        already_disabled = false,
                    }
                    
                    local function detectTrinketArea()
                        if not ws:FindFirstChild("AreaMarkers") then return "None" end
                        
                        local LocationName = "None"
                        local LocationNumSq = math.huge
                        local Area = ws.AreaMarkers
                        local trinketPos = trinket.Position
                        
                        for i,v in pairs(Area:GetChildren()) do
                            local diff = trinketPos - v.Position
                            local distSq = diff.X * diff.X + diff.Y * diff.Y + diff.Z * diff.Z
                            if distSq < LocationNumSq then
                                LocationName = v.Name
                                LocationNumSq = distSq
                            end
                        end
                        
                        return LocationName
                    end
                    
                    esp.area = detectTrinketArea()
    
                    do -- Create Drawings
                        esp.drawings.main_text = utility:Create("Text", {
                            Center = true,
                            Outline = true,
                            Color = esp.color,
                            Transparency = 1,
                            Text = esp.name,
                            Size = 13,
                            Font = 2,
                            ZIndex = esp.zindex,
                            Visible = false
                        }, "esp")
                    end
    
                    function esp:destruct()
                        esp.update_connection:Disconnect() -- Disconnect before deleting drawings so that the drawings don't cause an index error
                        for _,v in next, esp.drawings do
                            fast_remove(shared.drawing_containers.esp, v)
                            v:Remove()
                        end
                        
                        -- Clean up from tracking table
                        if cheat_client.trinket_esp_objects then
                            cheat_client.trinket_esp_objects[esp.object] = nil
                        end
                    end
    
                    local function update_trinket_esp(toggled)
                        if not toggled then
                            if not esp.already_disabled then
                                esp.drawings.main_text.Visible = false
                                esp.already_disabled = true
                            end
                            return
                        end
                        
                        esp.already_disabled = false
                        if esp.object.Parent ~= nil then
                            if cheat_client.window_active then
                                local camera = ws.CurrentCamera
                                local objectPos = esp.object.CFrame.Position
                                local distance = (camera.CFrame.Position - objectPos).Magnitude
                                
                                -- Early distance culling for non-artifact/mythic trinkets
                                if distance >= shared.pointers["trinket_range"]:Get() and esp.color ~= cheat_client.trinket_colors.artifact.Color and esp.color ~= cheat_client.trinket_colors.mythic.Color then
                                    esp.drawings.main_text.Visible = false
                                    return
                                end
                                
                                if (distance < shared.pointers["trinket_range"]:Get()) or esp.color == cheat_client.trinket_colors.artifact.Color or esp.color == cheat_client.trinket_colors.mythic.Color then
                                    local screen_position, on_screen = camera:WorldToViewportPoint(objectPos)
                                    
                                    -- Frustum culling - skip if not on screen
                                    if not on_screen then
                                        esp.drawings.main_text.Visible = false
                                        return
                                    end
                                    
                                    local area_text = (esp.area ~= "None" and shared.pointers["trinket_show_area"]:Get()) and " ("..esp.area..")" or ""
                                    esp.drawings.main_text.Text = esp.name.."\n["..tostring(math.floor(distance)).."]"..area_text
                                    esp.drawings.main_text.Position = Vector2.new(screen_position.X, screen_position.Y)
                                    esp.drawings.main_text.Visible = true
                                else
                                    esp.drawings.main_text.Visible = false
                                end
                            else
                                esp.drawings.main_text.Visible = false
                            end
                        else
                            esp:destruct()
                        end
                    end

                    local last_update = 0
                    local UPDATE_INTERVAL = 1/60 -- 30 FPS
                    
                    esp.update_connection = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                        local now = tick()
                        if now - last_update >= UPDATE_INTERVAL then
                            update_trinket_esp(shared.pointers["trinket_esp"]:Get())
                            last_update = now
                        end
                    end))                    
                    
                    cheat_client.trinket_esp_objects[trinket] = esp
                    return esp
                end
            end
            
            do -- Fallions
                if game.PlaceId == 5208655184 or game.PlaceId == 109732117428502 then
                    cheat_client.fallion_esp_objects = cheat_client.fallion_esp_objects or {}
                    
                    function cheat_client:add_fallion_esp(npc, name)
                        local esp = {
                            object = npc,
                            name = "[" .. name .. "]",
                            color = Color3.fromRGB(255, 115, 229),
                            drawings = {},
                            already_disabled = false,
                        }
            
                        do -- Create Drawings
                            esp.drawings.main_text = utility:Create("Text", {
                                Center = true,
                                Outline = true,
                                Color = esp.color,
                                Transparency = 1,
                                Text = esp.name,
                                Size = 13,
                                Font = 2,
                                ZIndex = -10,
                                Visible = false
                            }, "esp")
                        end
            
                        function esp:destruct()
                            esp.update_connection:Disconnect()
                            for _, v in next, esp.drawings do
                                fast_remove(shared.drawing_containers.esp, v)
                                v:Remove()
                            end
                            
                            -- Clean up from tracking table
                            if cheat_client.fallion_esp_objects then
                                cheat_client.fallion_esp_objects[esp.object] = nil
                            end
                        end
            
                        local function update_fallion_esp(toggled)
                            if not toggled then
                                if not esp.already_disabled then
                                    esp.drawings.main_text.Visible = false
                                    esp.already_disabled = true
                                end
                                return
                            end
                            
                            esp.already_disabled = false
                            if esp.object.Parent ~= nil then
                                if cheat_client.window_active then
                                    local distance = (ws.CurrentCamera.CFrame.Position - esp.object.HumanoidRootPart.CFrame.Position).Magnitude
                                    local screen_position, on_screen = ws.CurrentCamera:WorldToViewportPoint(esp.object.HumanoidRootPart.CFrame.Position)
                                    
                                    -- Frustum culling - skip if not on screen
                                    if not on_screen then
                                        esp.drawings.main_text.Visible = false
                                        return
                                    end
            
                                    esp.drawings.main_text.Text = esp.name .. "\n[" .. tostring(math.floor(distance)) .. "]"
                                    esp.drawings.main_text.Position = Vector2.new(screen_position.X, screen_position.Y)
                                    esp.drawings.main_text.Visible = true
                                else
                                    esp.drawings.main_text.Visible = false
                                end
                            else
                                esp:destruct()
                            end
                        end

                        local last_update = 0
                        local UPDATE_INTERVAL = 1/60 -- 30 FPS
                        
                        esp.update_connection = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                            local now = tick()
                            if now - last_update >= UPDATE_INTERVAL then
                                update_fallion_esp(shared.pointers["fallion_esp"]:Get())
                                last_update = now
                            end
                        end))
            
                        cheat_client.fallion_esp_objects[npc] = esp
                        return esp
                    end
                end
            end            
            
            do -- NPC ESP
                cheat_client.npc_esp_objects = cheat_client.npc_esp_objects or {}
                
                function cheat_client:add_npc_esp(npc,name)
                     local esp = {
                        object = npc,
                        name = "["..name.."]",
                        color = npc.Torso.Color,
                        drawings = {},
                        already_disabled = false,
                     }
            
                     do -- Create Drawings
                        esp.drawings.main_text = utility:Create("Text", {
                           Center = true,
                           Outline = true,
                           Color = esp.color,
                           Transparency = 1,
                           Text = esp.name,
                           Size = 13,
                           Font = 2,
                           ZIndex = -10,
                           Visible = false
                        }, "esp")
                     end
            
                     function esp:destruct()
                        esp.update_connection:Disconnect()
                        for _,v in next, esp.drawings do
                           fast_remove(shared.drawing_containers.esp, v)
                           v:Remove()
                        end
                        
                        -- Clean up from tracking table
                        if cheat_client.npc_esp_objects then
                            cheat_client.npc_esp_objects[esp.object] = nil
                        end
                     end
            
                    local function update_npc_esp(toggled)
                        if not toggled then
                            if not esp.already_disabled then
                                esp.drawings.main_text.Visible = false
                                esp.already_disabled = true
                            end
                            return
                        end
                        
                        esp.already_disabled = false
                        if esp.object.Parent ~= nil then
                            if cheat_client.window_active then
                                local distance = (ws.CurrentCamera.CFrame.Position - esp.object.HumanoidRootPart.CFrame.Position).Magnitude
                                local screen_position, on_screen = ws.CurrentCamera:WorldToViewportPoint(esp.object.HumanoidRootPart.CFrame.Position)
                                
                                -- Frustum culling - skip if not on screen
                                if not on_screen then
                                    esp.drawings.main_text.Visible = false
                                    return
                                end
                                
                                esp.drawings.main_text.Text = esp.name.."\n["..tostring(math.floor(distance)).."]"
                                esp.drawings.main_text.Position = Vector2.new(screen_position.X, screen_position.Y)
                                esp.drawings.main_text.Visible = true
                            else
                                esp.drawings.main_text.Visible = false
                            end
                        else
                            esp:destruct()
                        end
                    end

                    local last_update = 0
                    local UPDATE_INTERVAL = 1/60 -- 30 FPS
                    
                    esp.update_connection = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                        local now = tick()
                        if now - last_update >= UPDATE_INTERVAL then
                            update_npc_esp(shared.pointers["npc_esp"]:Get())
                            last_update = now
                        end
                    end))
                    
                    cheat_client.npc_esp_objects[npc] = esp
                    return esp
                end
            end
    
            do -- Ingredient
                if game.PlaceId ~= 3541987450 then
                    function cheat_client:identify_ingredient(object)
                        local asset_id = gethiddenproperty(object, "AssetId"):gsub("%%20", ""):match("%d+")
                        local matched_ingredient = cheat_client.ingredient_identifiers[asset_id]
            
                        if matched_ingredient then
                            return matched_ingredient
                        end
                    end
        
                    function cheat_client:add_ingredient_esp(ingredient, name)
                        local esp = {
                            object = ingredient,
                            name = name,
                            color = ingredient.Color,
                            drawings = {},
                            already_disabled = false,
                        }
        
                        do -- Create Drawings
                            esp.drawings.main_text = utility:Create("Text", {
                                Center = true,
                                Outline = true,
                                Color = esp.color,
                                Transparency = 1,
                                Text = esp.name,
                                Size = 13,
                                Font = 2,
                                ZIndex = -10,
                                Visible = false
                            }, "esp")
                        end
        
                        function esp:destruct()
                            esp.update_connection:Disconnect() -- Disconnect before deleting drawings so that the drawings don't cause an index error
                            for _,v in next, esp.drawings do
                                fast_remove(shared.drawing_containers.esp, v)
                                v:Remove()
                            end
                        end
        
                        local function update_ingredient_esp(toggled)
                            if not toggled then
                                if not esp.already_disabled then
                                    esp.drawings.main_text.Visible = false
                                    esp.already_disabled = true
                                end
                                return
                            end
                            
                            esp.already_disabled = false
                            
                            if esp.object.Parent ~= nil then
                                if cheat_client.window_active then
                                    if esp.object.Transparency ~= 1 then
                                        local distance = (ws.CurrentCamera.CFrame.Position - esp.object.CFrame.Position).Magnitude
                                        
                                        -- Early distance culling
                                        if distance >= shared.pointers["ingredient_range"]:Get() then
                                            esp.drawings.main_text.Visible = false
                                            return
                                        end
                                        
                                        if (distance < shared.pointers["ingredient_range"]:Get()) then
                                            local screen_position, on_screen = ws.CurrentCamera:WorldToViewportPoint(esp.object.CFrame.Position)
                                            
                                            -- Frustum culling - skip if not on screen
                                            if not on_screen then
                                                esp.drawings.main_text.Visible = false
                                                return
                                            end
                                            
                                            esp.drawings.main_text.Text = esp.name.."\n["..tostring(math.floor(distance)).."]"
                                            esp.drawings.main_text.Position = Vector2.new(screen_position.X, screen_position.Y)
                                            esp.drawings.main_text.Visible = true
                                        else
                                            esp.drawings.main_text.Visible = false
                                        end
                                    else
                                        esp.drawings.main_text.Visible = false
                                    end
                                else
                                    esp.drawings.main_text.Visible = false
                                end
                            else
                                esp:destruct()
                            end
                        end

                        local last_update = 0
                        local UPDATE_INTERVAL = 1/60 -- 30 FPS
                        
                        esp.update_connection = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                            local now = tick()
                            if now - last_update >= UPDATE_INTERVAL then
                                update_ingredient_esp(shared.pointers["ingredient_esp"]:Get())
                                last_update = now
                            end
                        end))
                        return esp
                    end
                end
            end
    
            do -- Ore
                function cheat_client:add_ore_esp(ore)
                    local esp = {
                        object = ore,
                        name = ore.Name,
                        color = ore.Color,
                        drawings = {},
                        already_disabled = false,
                    }
    
                    do -- Create Drawings
                        esp.drawings.main_text = utility:Create("Text", {
                            Center = true,
                            Outline = true,
                            Color = esp.color,
                            Transparency = 1,
                            Text = esp.name,
                            Size = 13,
                            Font = 2,
                            ZIndex = -10,
                            Visible = false
                        }, "esp")
                    end
    
                    function esp:destruct()
                        esp.update_connection:Disconnect() -- Disconnect before deleting drawings so that the drawings don't cause an index error
                        for _,v in next, esp.drawings do
                            fast_remove(shared.drawing_containers.esp, v)
                            v:Remove()
                        end
                    end
    
                    local function update_ore_esp(toggled)
                        if not toggled or not shared.pointers[esp.name:lower().."_esp"]:Get() then
                            if not esp.already_disabled then
                                esp.drawings.main_text.Visible = false
                                esp.already_disabled = true
                            end
                            return
                        end
                        
                        esp.already_disabled = false
                        
                        if esp.object.Parent ~= nil and esp.object.Transparency ~= 1 then
                            if cheat_client.window_active then
                                local distance = (ws.CurrentCamera.CFrame.Position - esp.object.CFrame.Position).Magnitude
                                
                                -- Early distance culling
                                if distance >= shared.pointers["ore_range"]:Get() then
                                    esp.drawings.main_text.Visible = false
                                    return
                                end
                                
                                if distance < shared.pointers["ore_range"]:Get() then
                                    local screen_position, on_screen = ws.CurrentCamera:WorldToViewportPoint(esp.object.CFrame.Position)
                                    
                                    -- Frustum culling - skip if not on screen
                                    if not on_screen then
                                        esp.drawings.main_text.Visible = false
                                        return
                                    end
                                    
                                    esp.drawings.main_text.Text = esp.name.."\n["..tostring(math.floor(distance)).."]"
                                    esp.drawings.main_text.Position = Vector2.new(screen_position.X, screen_position.Y)
                                    esp.drawings.main_text.Visible = true
                                else
                                    esp.drawings.main_text.Visible = false
                                end
                            else
                                esp.drawings.main_text.Visible = false
                            end                            
                        else
                            esp.drawings.main_text.Visible = false
                        end
                    end

                    local last_update = 0
                    local UPDATE_INTERVAL = 1/60 -- 30 FPS
                    
                    esp.update_connection = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                        local now = tick()
                        if now - last_update >= UPDATE_INTERVAL then
                            update_ore_esp(shared.pointers["ore_esp"]:Get())
                            last_update = now
                        end
                    end))
                    return esp
                end
            end
            
            do -- Shrieker Chams
                function cheat_client:get_shrieker_color(shrieker)
                    if shrieker and shrieker:FindFirstChild('MonsterInfo') then
                        if shrieker.MonsterInfo:FindFirstChild('Master') then
                            if shrieker.MonsterInfo.Master.Value == plr then
                                return Color3.fromRGB(0, 255, 255) -- owned
                            else
                                return Color3.fromRGB(255, 0, 80) -- enemy
                            end
                        end
                    end
                    return Color3.fromRGB(255, 255, 255) -- neutral
                end

                function cheat_client:add_shrieker_chams(shrieker)
                    local chams = {
                        object = shrieker,
                        highlight = nil,
                        already_disabled = false,
                    }

                    chams.highlight = utility:Object("Highlight", {
                        Parent = hidden_folder,
                        Adornee = shrieker,
                        Enabled = true,
                        FillColor = cheat_client:get_shrieker_color(shrieker),
                        FillTransparency = 0.65,
                        OutlineColor = Color3.fromRGB(255, 255, 255),
                        OutlineTransparency = 0.5,
                    }, "esp")

                    function chams:destruct()
                        chams.update_connection:Disconnect()
                        chams.highlight:Destroy()
                    end

                    local function update_shrieker_chams(toggled)
                        if not toggled then
                            if not chams.already_disabled then
                                chams.highlight.Enabled = false
                                chams.already_disabled = true
                            end
                            return
                        end

                        chams.already_disabled = false

                        if not chams.object.Parent then
                            chams:destruct()
                            return
                        end

                        if not cheat_client.window_active then
                            chams.highlight.Enabled = false
                            return
                        end

                        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                        local shriek_hrp = chams.object:FindFirstChild("HumanoidRootPart")
                        if not (hrp and shriek_hrp) then
                            chams.highlight.Enabled = false
                            return
                        end

                        local dist = (hrp.Position - shriek_hrp.Position).Magnitude
                        if dist > 800 then
                            chams.highlight.Enabled = false
                            return
                        end

                        chams.highlight.FillColor = cheat_client:get_shrieker_color(chams.object)
                        chams.highlight.Enabled = true
                    end

                    local last_update = 0
                    local UPDATE_INTERVAL = 1/60 -- 30 FPS
                    
                    chams.update_connection = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                        local now = tick()
                        if now - last_update >= UPDATE_INTERVAL then
                            update_shrieker_chams(shared.pointers["shrieker_chams"]:Get())
                            last_update = now
                        end
                    end))

                    return chams
                end
            end
        end
    
        do -- Environment
            local function set_ambience(area)
                local biome = area_data.biomes[area]
                if biome then
                    local area_color
                    if biome == "desert" or biome == "oasis" then
                        area_color = lit.desertcolor
                    elseif biome == "tundraoutside" then
                        area_color = lit.tundracolor
                    elseif biome == "tundrainside" or biome == "tundracastle" then
                        area_color = lit.tundrainsidecolor
                    elseif biome == "lava" then
                        area_color = lit.lavacolor
                    else
                        area_color = lit.defaultcolor
                    end
                    if area_color ~= nil then
                        lit.areacolor.Brightness = area_color.Brightness
                        lit.areacolor.Contrast = area_color.Contrast
                        lit.areacolor.Saturation = area_color.Saturation
                        lit.areacolor.TintColor = area_color.TintColor
                    end
                    local sun_rays = false
                    if biome ~= "tundrainside" then
                        sun_rays = false
                        if biome ~= "tundraoutside" then
                            sun_rays = biome ~= "tundracastle"
                        end
                    end

                    if biome == "forest_seasonal" then
                        biome = workspace:FindFirstChild("GaiaFallDecor") and "forestfall" or workspace:FindFirstChild("GaiaWinterDecor") and "forestwinter" or "forest";
                    end;

                    lit.SunRays.Enabled = sun_rays
                    local ambience = nil
                    local brightness = nil
                    local outdoor_ambience = nil
                    local fog = nil
                    local fog_color = nil
                    if biome == "forest" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        }
                        brightness = {
                            Value = 1.15
                        }
                        outdoor_ambience = {
                            Value = Color3.fromRGB(163, 181, 177)
                        }
                        fog = {
                            FogStart = 0, 
                            FogEnd = 750
                        }
                        fog_color = {
                            Value = Color3.fromRGB(91, 159, 157)
                        }
                    elseif biome == "darkforest" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        }
                        brightness = {
                            Value = 0.6
                        }
                        outdoor_ambience = {
                            Value = Color3.fromRGB(163, 181, 177)
                        }
                        fog = {
                            FogStart = 0, 
                            FogEnd = 120
                        }
                        fog_color = {
                            Value = Color3.fromRGB(25, 85, 60)
                        }
                    elseif biome == "cave" or biome == "theabyss" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        }
                        brightness = {
                            Value = 0
                        }
                        outdoor_ambience = {
                            Value = Color3.fromRGB(11, 13, 12)
                        }
                        fog = {
                            FogStart = 0, 
                            FogEnd = 80
                        }
                        fog_color = {
                            Value = Color3.fromRGB(25, 44, 43)
                        }
                    elseif biome == "darkcave" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        }
                        brightness = {
                            Value = 0
                        }
                        outdoor_ambience = {
                            Value = Color3.fromRGB(11, 13, 12)
                        }
                        fog = {
                            FogStart = 0, 
                            FogEnd = 50
                        }
                        fog_color = {
                            Value = Color3.fromRGB(17, 17, 17)
                        }
                    elseif biome == "desert" or biome == "oasis" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        }
                        brightness = {
                            Value = 1.25
                        }
                        outdoor_ambience = {
                            Value = Color3.fromRGB(127, 126, 101)
                        }
                        fog = {
                            FogStart = 150, 
                            FogEnd = 2000
                        }
                        fog_color = {
                            Value = Color3.fromRGB(147, 130, 109)
                        }
                    elseif biome == "tundraoutside" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        }
                        brightness = {
                            Value = 1.5
                        }
                        outdoor_ambience = {
                            Value = Color3.fromRGB(136, 136, 136)
                        }
                        fog = {
                            FogStart = 40, 
                            FogEnd = 200
                        }
                        fog_color = {
                            Value = Color3.fromRGB(240, 255, 240)
                        }
                    elseif biome == "tundrainside" or biome == "tundracastle" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        }
                        brightness = {
                            Value = 1.5
                        }
                        outdoor_ambience = {
                            Value = Color3.fromRGB(136, 136, 136)
                        }
                        fog = {
                            FogStart = 100, 
                            FogEnd = 200
                        }
                        fog_color = {
                            Value = Color3.fromRGB(255, 255, 255)
                        }
                    elseif biome == "lava" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        }
                        brightness = {
                            Value = 0.5
                        }
                        outdoor_ambience = {
                            Value = Color3.fromRGB(239, 15, 15)
                        }
                        fog = {
                            FogStart = 100, 
                            FogEnd = 1000
                        }
                        fog_color = {
                            Value = Color3.fromRGB(240, 255, 240)
                        }
                    elseif biome == "spooky" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        }
                        brightness = {
                            Value = 0.5
                        }
                        outdoor_ambience = {
                            Value = Color3.fromRGB(50, 50, 50)
                        }
                        fog = {
                            FogStart = 0, 
                            FogEnd = 400
                        }
                        fog_color = {
                            Value = Color3.fromRGB(200, 125, 50)
                        }
                    elseif v49 == "spookytown" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        };
                        brightness = {
                            Value = 0.5
                        };
                        outdoor_ambience = {
                            Value = Color3.fromRGB(50, 50, 50)
                        };
                        fog = {
                            FogStart = 0, 
                            FogEnd = 180
                        };
                        fog_color = {
                            Value = Color3.fromRGB(171, 105, 43)
                        };
                    elseif v49 == "lightwinter" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        };
                        brightness = {
                            Value = 1
                        };
                        outdoor_ambience = {
                            Value = Color3.fromRGB(200, 190, 190)
                        };
                        fog = {
                            FogStart = 200, 
                            FogEnd = 400
                        };
                        fog_color = {
                            Value = Color3.fromRGB(250, 245, 240)
                        };
                    elseif v49 == "forestfall" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        };
                        brightness = {
                            Value = 1.15
                        };
                        outdoor_ambience = {
                            Value = Color3.fromRGB(211, 163, 163)
                        };
                        fog = {
                            FogStart = 0, 
                            FogEnd = 750
                        };
                        fog_color = {
                            Value = Color3.fromRGB(208, 175, 123)
                        };
                    elseif v49 == "forestwinter" then
                        ambience = {
                            Ambient = Color3.fromRGB(20, 20, 20)
                        };
                        brightness = {
                            Value = 1.15
                        };
                        outdoor_ambience = {
                            Value = Color3.fromRGB(193, 214, 234)
                        };
                        fog = {
                            FogStart = 0, 
                            FogEnd = 750
                        };
                        fog_color = {
                            Value = Color3.fromRGB(159, 212, 227)
                        };
                    end;
        
                    if ambience then
                        lit.Ambient = ambience.Ambient
                    end
        
                    if brightness then
                        lit.Brightness = brightness.Value
                    end
        
                    if outdoor_ambience then
                        lit.OutdoorAmbient = outdoor_ambience.Value
                    end
        
                    if fog then
                        if fog.FogEnd then
                            fog.FogEnd = fog.FogEnd * 1.5
                        end
                        lit.FogStart = fog.FogStart
                        lit.FogEnd = fog.FogEnd
                    end
        
                    if fog_color then
                        lit.FogColor = fog_color.Value
                    end
                end
            end
    
            function cheat_client:restore_ambience()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local ray_result = ws:FindPartOnRayWithWhitelist(Ray.new(plr.Character:FindFirstChild("HumanoidRootPart").Position, Vector3.new(0, 1000, 0)), { area_markers })
                    if ray_result then
                        last_area_restore = ray_result.Name
                        set_ambience(ray_result.Name)
                    else
                        if last_area_restore then
                            set_ambience(last_area_restore)
                        end
                    end
            
                    if lit:FindFirstChild("TimeBrightness") and lit:FindFirstChild("AreaOutdoor") and lit:FindFirstChild("AreaFog")  then
                        local time_brightness = lit.TimeBrightness.Value
                        local area_outdoor = lit.AreaOutdoor.Value
                        local area_fog = lit.AreaFog.Value
                        local color_shift = 0.4 + time_brightness * 0.6
                        lit.Brightness = time_brightness * lit.AreaBrightness.Value
                        lit.OutdoorAmbient = Color3.new(area_outdoor.r * color_shift, area_outdoor.g * color_shift, area_outdoor.b * color_shift)
                        lit.FogColor = Color3.new(area_fog.r * color_shift, area_fog.g * color_shift, area_fog.b * color_shift)
                    end
                end
            end
        end

        do -- Mana Overlay
            function cheat_client:clear_visuals()
                if spellvis then spellvis.Visible = false end
                if snapvis then snapvis.Visible = false end
            end

            function cheat_client:handle_toggle(state)
                if state then
                    if plr and plr.Character then
                        local tool = plr.Character:FindFirstChildOfClass("Tool")
                        if tool then
                            cheat_client:update_visuals(tool)
                        end
                    end
                else
                    cheat_client:clear_visuals()
                end
            end
        end

        do -- spoof
            function cheat_client:spoof_name(name)
                task.wait(0.186)
                local statGui
            
                if plr.Character and plr.PlayerGui:FindFirstChild("StatGui") then
                    statGui = plr.PlayerGui:FindFirstChild("StatGui")
                    local charShadow = statGui:WaitForChild("Container", 2)
                        and statGui.Container:WaitForChild("CharacterName", 2)
                        and statGui.Container.CharacterName:WaitForChild("Shadow", 2)
            
                    if charShadow then
                        charShadow.Text = string.upper(name)
                        charShadow.Parent.Text = string.upper(name)
                    end
                end
            
                local splitString = {}
                local uber_title = nil

                local name_parts = name:split(",")
                if #name_parts > 1 then
                    local name_part = name_parts[1]:match("^%s*(.-)%s*$")
                    local title_part = name_parts[2]:match("^%s*(.-)%s*$")
                    
                    splitString = name_part:split(" ")
                    uber_title = title_part
                else
                    splitString = name:split(" ")
                end

                if #splitString < 2 then return end
            
                if game.PlaceId == 5208655184 or game.PlaceId == 109732117428502 then
                    plr:SetAttribute("FirstName", splitString[1])
                    plr:SetAttribute("LastName", splitString[2])
                    
                    if uber_title then
                        plr:SetAttribute("UberTitle", uber_title)
                    else
                        plr:SetAttribute("UberTitle", "")
                    end
                elseif plr:FindFirstChild("leaderstats") then
                    local leaderstats = plr.leaderstats
                    if leaderstats:FindFirstChild("FirstName") and leaderstats:FindFirstChild("LastName") then
                        leaderstats.FirstName.Value = splitString[1]
                        leaderstats.LastName.Value = splitString[2]
                        
                        if uber_title and leaderstats:FindFirstChild("UberTitle") then
                            leaderstats.UberTitle.Value = uber_title
                        elseif leaderstats:FindFirstChild("UberTitle") then
                            leaderstats.UberTitle.Value = ""
                        end
                    end
                end
            end

            local no_need = false
            function cheat_client:apply_streamer(state)
                if state then
                    if not original_names[plr] then
                        original_names[plr] = cheat_client:get_name(plr)
                    end
                    
                    if cheat_client.last_names and #cheat_client.last_names > 0 then
                        local random_lastname = cheat_client.last_names[math.random(1, #cheat_client.last_names)]
                        cheat_client:spoof_name("Fear " .. random_lastname)
                    end

                    local scrollingFrame = plr.PlayerGui:WaitForChild("LeaderboardGui"):WaitForChild("MainFrame"):WaitForChild("ScrollingFrame")
                    for _, frame in pairs(scrollingFrame:GetChildren()) do
                        for _, connection in pairs(getconnections(frame.MouseEnter)) do
                            connection:Fire()
                        end
                        task.wait()

                        if string.gsub(frame.Text, "%W", "") == plr.Name then
                            for _, connection in pairs(getconnections(frame.MouseEnter)) do
                                connection:Disable()
                            end

                            utility:Connection(frame.MouseEnter, function()
                                frame.Text = "Ragoozer"
                                frame.TextTransparency = 0.3
                            end)

                            for _, connection in pairs(getconnections(frame.MouseLeave)) do
                                connection:Fire()
                            end
                            break
                        end
                    end

                    local function pause()
                        if no_need then return end
                        no_need = true
                        vim:SendKeyEvent(true, Enum.KeyCode.Escape, false, game)
                        task.wait(0.05)
                        vim:SendKeyEvent(true, Enum.KeyCode.Escape, false, game)
                    end

                    local success, err = pcall(function()
                        pause()
                        task.wait(0.05)
                        local settingsShield = cg.RobloxGui:FindFirstChild("SettingsClippingShield")
                        if not settingsShield or not settingsShield:FindFirstChild("SettingsShield") then
                            error("SettingsShield not found")
                        end

                        local players = settingsShield.SettingsShield.MenuContainer.PageViewClipper.PageView.PageViewInnerFrame.Players
                        local playerLabel = players:WaitForChild("PlayerLabel" .. plr.Name, 5)
                        if not playerLabel then
                            error("PlayerLabel for "..plr.Name.." not found")
                        end

                        playerLabel.NameLabel.Text = "@Ragoozer"
                        playerLabel.DisplayNameLabel.Text = "Ragoozer"
                        playerLabel.Icon.Image = "rbxthumb://type=Avatar&id=87261352&w=100&h=100"

                        utility:Connection(playerLabel.NameLabel:GetPropertyChangedSignal("Text"), function()
                            playerLabel.NameLabel.Text = "@Ragoozer"
                        end)

                        utility:Connection(playerLabel.DisplayNameLabel:GetPropertyChangedSignal("Text"), function()
                            playerLabel.DisplayNameLabel.Text = "Ragoozer"
                        end)

                        utility:Connection(playerLabel.Icon:GetPropertyChangedSignal("Image"), function()
                            playerLabel.Icon.Image = "rbxthumb://type=Avatar&id=87261352&w=100&h=100"
                        end)
                    end)

                    if not success then
                        warn("press escape pause menu before using streamer mode")
                    end
                else
                    if original_names[plr] then
                        cheat_client:spoof_name(original_names[plr])
                        original_names[plr] = nil
                    end
                end
            end
        end

        do -- // Auto Potions + Auto Smithing
            local autoCraftUtils = {};

            local potions = {
                ['Health Potion'] = {
                    ['Lava Flower'] = 1;
                    ['Scroom'] = 2;
                },
    
                ['Bone Growth'] = {
                    ['Trote'] = 1,
                    ['Strange Tentacle'] = 1,
                    ['Uncanny Tentacle'] = 1
                },
    
                ['Switch Witch'] = {
                    ['Dire Flower'] = 1,
                    ['Glow Shroom'] = 2
                },
    
                ['Silver Sun'] = {
                    ['Desert Mist'] = 1,
                    ['Free Leaf'] = 1,
                    ['Polar Plant'] = 1
                },
    
                ['Lordsbane'] = {
                    ['Crown Flower'] = 3
                },
    
                ['Liquid Wisdom'] = {
                    ['Desert Mist'] = 1,
                    ['Periashroom'] = 1,
                    ['Crown Flower'] = 1,
                    ['Freeleaf'] = 1
                },
    
                ['Ice Protection'] = {
                    ['Snow Scroom'] = 2,
                    ['Trote'] = 1,
                },
    
                ['Kingsbane'] = {
                    ['Crown Flower'] = 1,
                    ['Vile Seed'] = 2,
                },
    
                ['Feather Feet'] = {
                    ['Creely'] = 1,
                    ['Dire Flower'] = 1,
                    ['Polar Plant'] = 1
                },
    
                ['Fire Protection'] = {
                    ['Trote'] = 1,
                    ['Scroom'] = 2
                },
    
                ['Tespian Elixir'] = {
                    ['Lava Flower'] = 1,
                    ['Scroom'] = 1,
                    ['Moss Plant'] = 2
                },
    
                ['Slateskin'] = {
                    ['Petrii Flower'] = 1,
                    ['Stone Scroom'] = 1,
                    ['Coconut'] = 1
                },
    
                ['Mind Mend'] = {
                    ['Grass Stem'] = 1,
                    ['Crystal Lotus'] = 1,
                    ['Winter Blossom'] = 1
                },
    
                ['Clot Control'] = {
                    ['Coconut'] = 1,
                    ['Grass Stem'] = 1,
                    ['Petri Flower'] = 1
                },
    
                ['Maidensbane'] = {
                    ['Stone Scroom'] = 1,
                    ['Fen Bloom'] = 1,
                    ['Foul Root'] = 1,
                },
    
                ['Sooth Sight'] = {
                    ['Grass Stem'] = 2,
                    ['Crystal Lotus'] = 1
                },
    
                ['Crystal Extract'] = {
                    ['Crystal Root'] = 1,
                    ['Crystal Lotus'] = 1,
                    ['Winter Blossom'] = 1
                },
    
                ['Soothing Frost'] = {
                    ['Winter Blossom'] = 1,
                    ['Snowshroom'] = 2
                },
            };
            
            local swords = {
                ['Bronze Sword'] = {
                    ['Copper Bar'] = 1,
                    ['Tin Bar'] = 2
                },
    
                ['Bronze Dagger'] = {
                    ['Copper Bar'] = 1,
                    ['Tin Bar'] = 1
                },
    
                ['Bronze Spear'] = {
                    ['Tin Bar'] = 1,
                    ['Copper Bar'] = 2
                },
    
                ['Steel Sword'] = {
                    ['Iron Bar'] = 2,
                    ['Copper Bar'] = 1
                },
    
                ['Steel Dagger'] = {
                    ['Iron Bar'] = 1,
                    ['Copper Bar'] = 1
                },
    
                ['Steel Spear'] = {
                    ['Iron Bar'] = 1,
                    ['Copper Bar'] = 2
                },
    
                ['Mythril Sword'] = {
                    ['Copper Bar'] = 1,
                    ['Iron Bar'] = 2,
                    ['Mythril Bar'] = 1
                },
    
                ['Mythril Dagger'] = {
                    ['Copper Bar'] = 1,
                    ['Iron Bar'] = 1,
                    ['Mythril Bar'] = 1
                },
    
                ['Mythril Spear'] = {
                    ['Copper Bar'] = 2,
                    ['Iron Bar'] = 1,
                    ['Mythril Bar'] = 1
                }
            }
    
            local stations = workspace:FindFirstChild("Stations");
    
            local function GrabStation(type)
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    if typeof(type) ~= "string" then
                        return warn(string.format("Expected type string got <%s>",typeof(type)))
                    elseif(not stations) then
                        return warn('[Auto Potion] No Stations');
                    end
        
                    for i,v in next, stations:GetChildren() do
                        if (v.Timer.Position-plr.Character.HumanoidRootPart.Position).Magnitude <= 15 and string.find(v.Name, type) then
                            return v
                        end
                    end
                end
            end
    
            local function hasMaterials(items, item)
                local recipe = items[item];
                local count = setmetatable({}, {__index = function() return 0 end});
    
                assert(recipe);
    
                for i, v in next, plr.Backpack:GetChildren() do
                    if(recipe[v.Name]) then
                        local quantity = v:FindFirstChild('Quantity');
                        quantity = quantity and quantity.Value or 1;
    
                        count[v.Name] = count[v.Name] + quantity;
                    end;
                end;
    
                for i, v in next, recipe do
                    if(count[i] < v) then
                        return false;
                    end;
                end;
    
                return recipe;
            end;
            
    
            autoCraftUtils.hasMaterials = function(craftType, item)
                return hasMaterials(craftType == 'Alchemy' and potions or swords, item);
            end;
            
    
            local function addItemsToStation(items, station, part, partToClick, partToClean)
                if(station.Contents.Value ~= '[]') then
                    repeat
                        fireclickdetector(station[partToClean].ClickEmpty);
                        task.wait(utility:random_wait(true));
                    until station.Contents.Value == '[]';
            
                    task.wait(utility:random_wait(true))
                end;
            
                for name, count in next, items do
                    for i = 1, count do
                        local k = plr.Backpack:FindFirstChild(name);
            
                        if not k then 
                            warn(string.format("[auto stuff] missing ingredient: %s", name)) 
                            return 
                        end 
            
                        if k.Parent == nil then 
                            warn(string.format("[auto stuff] cannot move %s, its parent is NULL", name))
                            return
                        end
            
                        task.wait(utility:random_wait(true))
                        k.Parent = plr.Character;
            
                        if k.Parent ~= plr.Character then
                            warn("[auto stuff] Failed to move " .. name .. " to character")
                            return
                        end
            
                        local remote = k:FindFirstChildWhichIsA('RemoteEvent');
            
                        if(remote) then
                            local content = station.Contents.Value;
            
                            repeat
                                remote:FireServer(station[part].CFrame, station[part]);
                                task.wait(utility:random_wait(true))
                            until station.Contents.Value ~= content;
            
                            if k.Parent then
                                k.Parent = plr.Backpack;
                            end
                            task.wait(0.1);
                        else
                            k:Activate();
            
                            repeat
                                task.wait(utility:random_wait(true))
                            until not k.Parent;
                        end;
                    end;
                end;
            
                repeat
                    fireclickdetector(station[partToClick].ClickConcoct);
                    task.wait(utility:random_wait(true))
                until station.Contents.Value == '[]';
            end;
            
    
            function utility:craft(stationType, itemToCraft)
                if not plr.Character then return end
                if not (auto_pot_active or auto_craft_active) then return end

                local station = GrabStation(stationType);
                local items = hasMaterials(stationType == 'Alchemy' and potions or swords, itemToCraft);
                
                if (library ~= nil and library.Notify) then
                    if(not station) then return library:Notify("You must be near a cauldron/furnace!", Color3.fromRGB(255,0,0)) end;
                    if(not items) then return library:Notify("Some ingredients are missing!", Color3.fromRGB(255,0,0)) end;
                end
    
                if(stationType == 'Smithing') then
                    rps.Requests.GetMouse.OnClientInvoke = function()
                        return {
                            Hit = station.Material.CFrame,
                            Target = station.Material,
                            UnitRay = Mouse.UnitRay,
                            X = Mouse.X,
                            Y = Mouse.Y
                        }
                    end;
                end;
    
                if (stationType == 'Alchemy') then
                    repeat
                        if not auto_pot_active then return end
                        addItemsToStation(items, station, 'Water', 'Ladle', 'Bucket');
                        items = hasMaterials(stationType == 'Alchemy' and potions or swords, itemToCraft);
                        task.wait(utility:random_wait(true))
                    until not items or not auto_pot_active;                    
                elseif (stationType == 'Smithing') then
                    repeat
                        if not auto_craft_active then return end
                        addItemsToStation(items, station, 'Material', 'Hammer', 'Trash');
                        items = hasMaterials(stationType == 'Alchemy' and potions or swords, itemToCraft);
    
                        task.wait(utility:random_wait(true))
                    until not items or not auto_craft_active;      
                end;
    
                task.wait(2);
    
                rps.Requests.GetMouse.OnClientInvoke = function()
                    return {
                        Hit = Mouse.Hit,
                        Target = Mouse.Target,
                        UnitRay = Mouse.UnitRay,
                        X = Mouse.X,
                        Y = Mouse.Y
                    }
                end
            end
        end

        do -- Dayfarm
            local function is_moderator(player)
                if cheat_client and cheat_client.mod_list and table.find(cheat_client.mod_list, player.UserId) then
                    return true
                end

                local success, isInGroup = pcall(function()
                    return player:IsInGroup(4556484)
                end)

                if success and isInGroup then
                    return true
                end
                
                local success2, isInGroup2 = pcall(function()
                    return player:IsInGroup(281365)
                end)

                if success2 and isInGroup2 then
                    return true
                end

                return false
            end

            local function no_kick()
                if shared.pointers["no_kick"]:Get() then
                    return true
                end
                return false
            end

            function cheat_client:day_farm(state)
                for _, connection in next, getconnections(plr.Idled) do
                    if state then 
                        connection:Disable()
                    else 
                        connection:Enable()
                    end
                end
                
                if not shared.deathConnection then
                    shared.deathConnection = nil
                end
                
                if not shared.characterAddedConnection then
                    shared.characterAddedConnection = nil
                end
                
                if state then
                    mem:SetItem('dayfarming', 'true')
                        
                    local ptr = shared.pointers["day_farm_range"]
                    local noKickPtr = shared.pointers["no_kick"]
                    local daygoalKickPtr = shared.pointers["day_goal_kick"]
                    local dayGoalPtr = shared.pointers["day_goal"]

                    if ptr then
                        mem:SetItem('dayfarming_range', tostring(ptr:Get()))
                    else
                        mem:SetItem('dayfarming_range', "500")
                    end

                    if daygoalKickPtr then
                        mem:SetItem('day_goal_kick', daygoalKickPtr:Get() and "true" or "false")
                    else
                        mem:SetItem('day_goal_kick', "false")
                    end

                    if noKickPtr then
                        mem:SetItem('no_kick', noKickPtr:Get() and "true" or "false")
                    else
                        mem:SetItem('no_kick', "false")
                    end

                    if dayGoalPtr then
                        mem:SetItem('daygoal', tostring(dayGoalPtr:Get()))
                    else
                        mem:SetItem('daygoal', "999")
                    end



                    local playerCount = #plrs:GetPlayers()
                    utility:plain_webhook(string.format("Started farming days with %d players", playerCount))

                    cpu.status.active = true
                    
                    if shared.focusConnection then
                        shared.focusConnection:Disconnect()
                    end
                    
                    shared.focusConnection = utility:Connection(uis.WindowFocused, function()
                        cpu.status.focused = true
                        if cpu.status.hd_mode then
                            setfpscap(50)
                        else
                            setfpscap(20)
                        end
                        cpu.services.ugs.MasterVolume = cpu.services.ms
                        settings().Rendering.QualityLevel = cpu.services.ql
                        cpu.services.rs:Set3dRenderingEnabled(true)
                    end)
                    
                    if shared.unfocusConnection then
                        shared.unfocusConnection:Disconnect()
                    end
                    
                    shared.unfocusConnection = utility:Connection(uis.WindowFocusReleased, function()
                        cpu.status.focused = false
                        setfpscap(15)
                        settings().Rendering.QualityLevel = 1
                        cpu.services.rs:Set3dRenderingEnabled(false)
                    end)
                    
                    shared.cpuOptimizationConnection = utility:Connection(uis.InputBegan, function(input, chatting)
                        if not chatting and cpu.status.focused then
                            if input.KeyCode == Enum.KeyCode.RightControl then
                                cpu.status.hd_mode = not cpu.status.hd_mode
                                if cpu.status.hd_mode then
                                    setfpscap(50)
                                else
                                    setfpscap(20)
                                end
                            end
                        end
                    end)

                    local function kickPlayer(message)
                        if cs:HasTag(plr.Character, "Danger") then
                            repeat task.wait(0.1) until not cs:HasTag(plr.Character, "Danger")
                        end

                        utility:plain_webhook(message)
                        rps.Requests.ReturnToMenu:InvokeServer()
                        plr:Kick(message)
                        utility:Unload()
                    end

                    shared.dangerousItemConnection = utility:Connection(ws.Live.DescendantAdded, function(descendant)
                        if not shared.pointers["day_farm"]:Get() then return end
                        if no_kick() then return end
                        
                        if descendant:IsA("Tool") and (descendant.Name == "Perflora" or descendant.Name == "Pebble") then
                            local character = descendant.Parent
                            if character and character:IsA("Model") then
                                local player = plrs:GetPlayerFromCharacter(character)
                                if player and player ~= plr then
                                    --kickPlayer(string.format("%s (%s) has dangerous item: %s", player.Name, player.UserId, descendant.Name))
                                    utility:plain_webhook(string.format("[SERVERHOPPING] %s (%s) has dangerous item: %s", player.Name, player.UserId, descendant.Name))
                                    utility:Serverhop();
                                end
                            end
                        end
                    end)
                    
                    local time_elapsed = 0
                    local server_hop_initiated = false

                    shared.heartbeatConnection = utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(delta_time)
                        if shared.pointers["day_farm"]:Get() and not server_hop_initiated then     
                            time_elapsed += delta_time
                            if time_elapsed >= 1 then
                                time_elapsed = 0

                                if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                                    return
                                end
                                
                                local range = shared.pointers["day_farm_range"]:Get()
                                local myPosition = plr.Character.HumanoidRootPart.Position
                                
                                for _, player in next, plrs:GetPlayers() do
                                    if player == plr then continue end
                                    
                                    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                                        continue
                                    end
                                    
                                    local theirPosition = player.Character.HumanoidRootPart.Position
                                    local distance = (myPosition - theirPosition).Magnitude
                                    
                                    if distance < range and distance > 0.1 then
                                        if cs:HasTag(plr.Character, "Danger") then
                                            repeat
                                                task.wait(0.1)
                                            until not cs:HasTag(plr.Character, "Danger")
                                        end
                                        
                                        --kickPlayer(string.format("%s (%s) came too close (%.2f studs)", player.Name, player.UserId, distance))
                                        server_hop_initiated = true
                                        utility:plain_webhook(string.format("%s (%s) came too close (%.2f studs)", player.Name, player.UserId, distance))
                                        utility:Serverhop();
                                        break
                                    end
                                end
                            end
                        end
                    end))

                    shared.playerAddedConnection = utility:Connection(plrs.PlayerAdded, function(player)
                        if not shared.pointers["day_farm"]:Get() then return end
                        if no_kick() then return end

                        if is_moderator(player) then
                            -- kickPlayer(string.format("kicked because a moderator joined the server, %s (%s)", player.Name, player.UserId))
                            utility:plain_webhook(string.format("kicked because a moderator joined the server, %s (%s)", player.Name, player.UserId))
                            utility:Serverhop();
                        end
                        
                        local characterAddedConnection
                        characterAddedConnection = utility:Connection(player.CharacterAdded, function(character)
                            if not shared.pointers["day_farm"]:Get() then 
                                characterAddedConnection:Disconnect()
                                return 
                            end
                            
                            task.wait(1)
                            
                            if character:FindFirstChild("HumanoidRootPart") and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                                local distance = (plr.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                                if distance < shared.pointers["day_farm_range"]:Get() then
                                    --kickPlayer(string.format("%s (%s) joined and spawned too close (%.2f studs)", player.Name, player.UserId, distance))
                                    utility:plain_webhook(string.format("%s (%s) joined and spawned too close (%.2f studs)", player.Name, player.UserId, distance))
                                    utility:Serverhop();
                                    characterAddedConnection:Disconnect()
                                end
                            end
                        end)
                        
                        if player.Character then 
                            if player.Character:FindFirstChild("HumanoidRootPart") and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                                local distance = (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                                if distance < shared.pointers["day_farm_range"]:Get() then
                                    --kickPlayer(string.format("%s (%s) joined and spawned too close (%.2f studs)", player.Name, player.UserId, distance))
                                    utility:plain_webhook(string.format("%s (%s) joined and spawned too close (%.2f studs)", player.Name, player.UserId, distance))
                                    utility:Serverhop();
                                end
                            end
                        end
                    end)

                    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                        if shared.deathConnection then
                            shared.deathConnection:Disconnect()
                        end
                        
                        shared.deathConnection = utility:Connection(plr.Character.Humanoid.Died, function()
                            if shared.pointers["day_farm"]:Get() then
                                if cs:HasTag(plr.Character, "Danger") then
                                    repeat
                                        task.wait(0.1)
                                    until not cs:HasTag(plr.Character, "Danger")
                                end
                                
                                utility:plain_webhook("player died during day farm??")
                                rps.Requests.ReturnToMenu:InvokeServer()
                                plr:Kick("player died during day farm")
                                utility:Unload()
                            end
                        end)
                    end
                    
                    if shared.characterAddedConnection then
                        shared.characterAddedConnection:Disconnect()
                    end
                    
                    shared.characterAddedConnection = utility:Connection(plr.CharacterAdded, function(character)
                        if not shared.pointers["day_farm"]:Get() then return end
                        
                        if shared.deathConnection then
                            shared.deathConnection:Disconnect()
                        end
                        
                        task.wait(1)
                        
                        if character:FindFirstChild("Humanoid") then
                            shared.deathConnection = utility:Connection(character.Humanoid.Died, function()
                                if shared.pointers["day_farm"]:Get() then
                                    if cs:HasTag(character, "Danger") then
                                        repeat
                                            task.wait(0.1)
                                        until not cs:HasTag(character, "Danger")
                                    end
                                    
                                    utility:plain_webhook("player died during day farm??")
                                    rps.Requests.ReturnToMenu:InvokeServer()
                                    plr:Kick("player died during day farm")
                                    utility:Unload()
                                end
                            end)
                        end
                    end)
                else
                    cpu.status.active = false
                    setfpscap(999)
                    settings().Rendering.QualityLevel = cpu.services.ql
                    cpu.services.rs:Set3dRenderingEnabled(true)

                    if shared.cpuOptimizationConnection then
                        shared.cpuOptimizationConnection:Disconnect()
                        shared.cpuOptimizationConnection = nil
                    end
                    
                    if shared.focusConnection then
                        shared.focusConnection:Disconnect()
                        shared.focusConnection = nil
                    end
                    
                    if shared.unfocusConnection then
                        shared.unfocusConnection:Disconnect()
                        shared.unfocusConnection = nil
                    end
                    
                    if shared.deathConnection then
                        shared.deathConnection:Disconnect()
                        shared.deathConnection = nil
                    end
                    
                    if shared.characterAddedConnection then
                        shared.characterAddedConnection:Disconnect()
                        shared.characterAddedConnection = nil
                    end

                    if shared.dangerousItemConnection then
                        shared.dangerousItemConnection:Disconnect()
                        shared.dangerousItemConnection = nil
                    end
                    
                    if shared.heartbeatConnection then
                        shared.heartbeatConnection:Disconnect()
                        shared.heartbeatConnection = nil
                    end
                    
                    if shared.playerAddedConnection then
                        shared.playerAddedConnection:Disconnect()
                        shared.playerAddedConnection = nil
                    end

                    mem:RemoveItem("dayfarming")
                    mem:RemoveItem("dayfarming_range")
                    mem:RemoveItem("day_goal_kick")
                    mem:RemoveItem("no_kick")
                    mem:RemoveItem("daygoal")
                end
            end
        end
    end
    
    -- UI
    do
        local window = library:Window({name = "hydroxide.solutions"}) -- kiki hub (kiloware)
    
        do -- Combat
            local page_combat = window:Page({name = "combat"})
            local section_settings = page_combat:Section({name = "combat settings"})

            local no_stun_toggle = section_settings:Toggle({name = "no stun", default = cheat_client.config.no_stun, pointer = "no_stun"})
            local anti_hystericus_toggle = section_settings:Toggle({name = "no confusion", default = cheat_client.config.anti_confusion, pointer = "anti_hystericus"})
            local perflora_teleport_toggle = section_settings:Toggle({name = "perflora teleport", default = cheat_client.config.perflora_teleport, pointer = "perflora_teleport"})

            section_settings:Label({name = "--"})

            local auto_parry_viribus = section_settings:Toggle({name = "auto parry viribus", default = cheat_client.config.parry_viribus, pointer = "parry_viribus"})
            local auto_parry_owlslash = section_settings:Toggle({name = "auto parry owlslash", default = cheat_client.config.parry_owlslash, pointer = "parry_owl"})
            local auto_parry_shadowrush = section_settings:Toggle({name = "auto parry shadowrush", default = cheat_client.config.parry_shadowrush, pointer = "parry_shadowrush"})
            local auto_parry_verdien = section_settings:Toggle({name = "auto parry verdien", default = cheat_client.config.parry_verdien, pointer = "parry_verdien"})
            
            section_settings:Label({name = "--"})

            local auto_parry_ping_adjust = section_settings:Toggle({name = "ping adjustment", default = cheat_client.config.parry_ping_adjust, pointer = "parry_ping_adjust"})
            local auto_parry_custom_delay = section_settings:Toggle({name = "use custom delay", default = cheat_client.config.parry_custom_delay, pointer = "parry_custom_delay"})
            local custom_delay_slider = section_settings:Slider({name = "custom delay", default = cheat_client.config.custom_delay, max = 500, min = -500, tick = 10, pointer = "parry_custom_delay_ms"})
            local parry_fov_slider = section_settings:Slider({name = "parry fov angle", default = cheat_client.config.parry_fov_angle, max = 360, min = 0, tick = 20, pointer = "parry_fov_angle"})
            local auto_parry_disable_unfocused = section_settings:Toggle({name = "disable when window unfocused", default = cheat_client.config.parry_disable_when_unfocused, pointer = "parry_disable_when_unfocused"})
            local parry_ignore_visibility = section_settings:Toggle({name = "ignore visibility (blatant)", default = cheat_client.config.parry_ignore_visibility, pointer = "parry_ignore_visibility"})
    
            section_settings:Label({name = "--"})
    
            local silent_aim_toggle = section_settings:Toggle({name = "silent aim", default = cheat_client.config.silent_aim, pointer = "silent_aim"})
            local silent_slider = section_settings:Slider({name = "fov", default = cheat_client.config.fov, max = 200, min = 0, tick = 5, pointer = "fov"})
            local silent_hitboxes = section_settings:MultiList({name = "hitboxes", default = cheat_client.config.aimbot_hitboxes, options = {{"Head", true}, {"Torso", true}}, pointer = "aimbot_hitboxes"})
            local ignore_fov_toggle = section_settings:Toggle({name = "ignore fov", default = cheat_client.config.ignore_fov, pointer = "ignorefov"})
        end
    
        do -- Visuals
            local page_visuals = window:Page({name = "visuals"})
            local section_settings = page_visuals:Section({name = "visual settings"})
    
            do -- Player
                local player_toggle = section_settings:Toggle({name = "player esp", default = cheat_client.config.player_esp, pointer = "player_esp"})
                local player_name_toggle = section_settings:Toggle({name = "name", default = cheat_client.config.player_name, pointer = "player_name"})
                local player_box_toggle = section_settings:Toggle({name = "box", default = cheat_client.config.player_box, pointer = "player_box"})
                local player_health_toggle = section_settings:Toggle({name = "health", default = cheat_client.config.player_health, pointer = "player_health"})
                local player_tags_toggle = section_settings:Toggle({name = "tags", default = cheat_client.config.player_tags, pointer = "player_tags"})
                local player_intent_toggle = section_settings:Toggle({name = "intent", default = cheat_client.config.player_intent, pointer = "player_intent"})
                local player_mana_toggle = section_settings:Toggle({name = "mana", default = cheat_client.config.player_mana, pointer = "player_mana"})
                local player_mana_text_toggle = section_settings:Toggle({name = "mana text", default = cheat_client.config.player_mana_text, pointer = "player_mana_text"})
                local player_racial_toggle = section_settings:Toggle({name = "racial", default = cheat_client.config.player_racial, pointer = "player_racial"})
                local player_observe_toggle = section_settings:Toggle({name = "observe block", default = cheat_client.config.player_observe, pointer = "player_observe"})
                local player_hover_details_toggle = section_settings:Toggle({name = "fade away", default = cheat_client.config.player_hover_details, pointer = "player_hover_details"})
                local player_range_slider = section_settings:Slider({name = "range", default = cheat_client.config.player_range, max = 9000, min = 0, tick = 100, pointer = "player_range"})
                
                section_settings:Label({name = "--"})
                
                -- Chams

                local function color_index(color)
                    for i, v in ipairs(shared.colors) do
                        if v == color then
                            return i
                        end
                    end
                    return 1 -- fallback index
                end

                local player_chams_toggle = section_settings:Toggle({name = "player chams", default = cheat_client.config.player_chams, pointer = "player_chams"})
                local player_friendly_chams_toggle = section_settings:Toggle({name = "friendly chams", default = cheat_client.config.player_friendly_chams, pointer = "player_friendly_chams"})
                local player_low_health_toggle = section_settings:Toggle({name = "low health chams", default = cheat_client.config.player_low_health, pointer = "player_low_health"})
                local player_aimbot_chams_toggle = section_settings:Toggle({name = "player aimbot chams", default = cheat_client.config.player_aimbot_chams, pointer = "player_aimbot_chams"})
                local player_chams_fill_toggle = section_settings:Toggle({name = "chams filled", default = cheat_client.config.player_chams_fill, pointer = "player_chams_fill"})
                local player_chams_pulse_toggle = section_settings:Toggle({name = "chams pulse", default = cheat_client.config.player_chams_pulse, pointer = "player_chams_pulse"})
                local player_chams_occluded_toggle = section_settings:Toggle({name = "chams occluded", default = cheat_client.config.player_chams_occluded, pointer = "player_chams_occluded"})
                --[[
                local player_chams_color = section_settings:ColorList({
                    name = "chams color",
                    default = color_index(cheat_client.config.player_chams_color),
                    pointer = "player_chams_color",
                    callback = function(color)
                        cheat_client.config.player_chams_color = color
                    end
                })
                --]]
                

                section_settings:Label({name = "--"})
                
                do -- player healthview
                    local hv_connection;
                    local player_health_toggle = section_settings:Toggle({name = "player healthview", default = cheat_client.config.player_healthview, pointer = "player_healthview", callback = function(state)
                        if state then
                            for _,v in pairs(ws.Live:GetChildren()) do
                                if v ~= plr.Character then
                                    local z = v:FindFirstChildWhichIsA("Humanoid")
                                    if z then
                                        z.HealthDisplayType = Enum.HumanoidHealthDisplayType.DisplayWhenDamaged
                                        if v:FindFirstChild("MonsterInfo") then
                                            z.NameDisplayDistance = 0
                                        end
                                        z.HealthDisplayDistance = 80
                                        z.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Subject
                                    end
                                end
                            end
                            hv_connection = utility:Connection(ws.Live.ChildAdded, function(ch)
                                if ch ~= plr.Character then
                                    local z = ch:WaitForChild("Humanoid",3)
                                    if z then
                                        z.HealthDisplayType = Enum.HumanoidHealthDisplayType.DisplayWhenDamaged
                                        if ch:FindFirstChild("MonsterInfo") then
                                            z.NameDisplayDistance = 0
                                        end
                                        z.HealthDisplayDistance = 80
                                        z.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Subject
                                    end
                                end
                            end)
                        else
                            if plr.Character and plr.Backpack:FindFirstChild("HealerVision") then return end
                            for _,v in pairs(ws.Live:GetChildren()) do
                                if v ~= plr.Character then
                                    local z = v:FindFirstChildWhichIsA("Humanoid")
                                    if z then
                                        z.HealthDisplayType = Enum.HumanoidHealthDisplayType.DisplayWhenDamaged
                                        if v:FindFirstChild("MonsterInfo") then
                                            z.NameDisplayDistance = 0
                                        end
                                        z.HealthDisplayDistance = 0
                                        z.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Subject
                                    end
                                end
                            end
                            if hv_connection then
                                hv_connection:Disconnect();
                                hv_connection = nil
                            end
                        end
                    end})
                end
                local legit_intent_toggle = section_settings:Toggle({name = "legit intent", default = cheat_client.config.legit_intent, pointer = "legit_intent", callback = function(enabled)
                    if enabled and cheat_client.legit_intent_setup then
                        cheat_client.legit_intent_setup()
                    elseif not enabled and cheat_client.legit_intent_cleanup then
                        cheat_client.legit_intent_cleanup()
                    end
                end})
            end
    
            section_settings:Label({name = "--"})
    
            do -- Trinket
                local trinket_toggle = section_settings:Toggle({name = "trinket esp", default = cheat_client.config.trinket_esp, pointer = "trinket_esp"})
                local trinket_area_toggle = section_settings:Toggle({name = "show area", default = cheat_client.config.trinket_show_area, pointer = "trinket_show_area"})
                local trinket_range_slider = section_settings:Slider({name = "range", default = cheat_client.config.trinket_range, max = 2000, min = 0, tick = 100, pointer = "trinket_range"})
            end
    
            section_settings:Label({name = "--"})
            
            do -- NPC Esp
                local shrieker_chams_toggle = section_settings:Toggle({name = "shrieker chams", default = cheat_client.config.shrieker_chams, pointer = "shrieker_chams"})
                local fallion_toggle = section_settings:Toggle({name = "fallion esp", default = cheat_client.config.fallion_esp, pointer = "fallion_esp", callback = function(toggled)
                    if not toggled then
                        for fallion, esp in pairs(cheat_client.fallion_esp_objects or {}) do
                            esp:destruct()
                        end
                        cheat_client.fallion_esp_objects = {}
                    else
                        if game.PlaceId == 5208655184 or game.PlaceId == 109732117428502 then
                            for _, fallion in next, ws.NPCs:GetChildren() do
                                if fallion.Name == "Fallion" then
                                    cheat_client:add_fallion_esp(fallion, fallion.Name)
                                end
                            end
                        end
                    end
                end})
                local npc_esp_toggle = section_settings:Toggle({name = "npc esp", default = cheat_client.config.npc_esp, pointer = "npc_esp", callback = function(toggled)
                    if not toggled then
                        for npc, esp in pairs(cheat_client.npc_esp_objects or {}) do
                            esp:destruct()
                        end
                        cheat_client.npc_esp_objects = {}
                    else
                        for _,object in next, ws.NPCs:GetChildren() do
                            if object:FindFirstChildOfClass('Pants') and object:FindFirstChild('Humanoid') and object:FindFirstChild('Torso') then
                                cheat_client:add_npc_esp(object,object.Name)
                            end
                        end
                    end
                end})
            end
            
            section_settings:Label({name = "--"})
    
            do -- Ingredient
                local ingredient_toggle = section_settings:Toggle({name = "ingredient esp", default = cheat_client.config.ingredient_esp, pointer = "ingredient_esp"})
                local ingredient_range_slider = section_settings:Slider({name = "range", default = cheat_client.config.ingredient_range, max = 2000, min = 0, tick = 100, pointer = "ingredient_range"})
            end
    
            section_settings:Label({name = "--"})
    
            do -- Ore
                local ore_toggle = section_settings:Toggle({name = "ore esp", default = cheat_client.config.ore_esp, pointer = "ore_esp"})
                local mythril_toggle = section_settings:Toggle({name = "mythril", default = cheat_client.config.mythril_esp, pointer = "mythril_esp"})
                local copper_toggle = section_settings:Toggle({name = "copper", default = cheat_client.config.copper_esp, pointer = "copper_esp"})
                local iron_toggle = section_settings:Toggle({name = "iron", default = cheat_client.config.iron_esp, pointer = "iron_esp"})
                local tin_toggle = section_settings:Toggle({name = "tin", default = cheat_client.config.tin_esp, pointer = "tin_esp"})
                local ore_range_slider = section_settings:Slider({name = "range", default = cheat_client.config.ore_range, max = 12000, min = 0, tick = 1000, pointer = "ore_range"})
            end
    
            section_settings:Label({name = "--"})
    
            do -- Enviroment
                local fullbright_toggle = section_settings:Toggle({name = "fullbright", default = cheat_client.config.fullbright, pointer = "fullbright", callback = function(state)
                    if state then
                        lit.Ambient = Color3.new(.8, .8, .8)
                        lit.OutdoorAmbient = Color3.new(.8, .8, .8)
                        lit.FogColor = Color3.fromRGB(254, 254, 254)
                        lit.FogEnd = 100000
                        lit.FogStart = 50
                    else
                        cheat_client:restore_ambience()
                    end
                end})
                local clock_toggle = section_settings:Toggle({name = "change time", default = cheat_client.config.change_time, pointer = "change_time", callback = function(state)
                    if state then
                        lit.ClockTime = shared.pointers["clock_time"] and shared.pointers["clock_time"]:Get()
                    end
                end})
                local clock_time_slider = section_settings:Slider({name = "time", default = cheat_client.config.clock_time, max = 24, min = 1, tick = 1, pointer = "clock_time"})
                local no_blindness_toggle = section_settings:Toggle({name = "no blindness", default = cheat_client.config.no_blindness, pointer = "no_blindness", callback = function(state)
                    if state then
                        lit:WaitForChild("Blindness").Enabled = false
                    else
                        lit:WaitForChild("Blindness").Enabled = true
                    end
                end})
                local no_blur_toggle = section_settings:Toggle({name = "no blur", default = cheat_client.config.no_blur, pointer = "no_blur", callback = function(state)
                    if state then
                        lit:WaitForChild("Blur").Enabled = false
                    else
                        lit:WaitForChild("Blur").Enabled = true
                    end
                end})
                local no_sanity_toggle = section_settings:Toggle({name = "no sanity", default = cheat_client.config.no_sanity, pointer = "no_sanity", callback = function(state)
                    if state then
                        lit:WaitForChild("Sanity").Enabled = false
                    else
                        lit:WaitForChild("Sanity").Enabled = true
                    end
                end})
            end

            section_settings:Label({name = "--"})

            local mana_overlay_toggle = section_settings:Toggle({
                name = "mana overlay", 
                default = cheat_client.config.mana_overlay, 
                pointer = "mana_overlay", 
                callback = function(state)
                    cheat_client:handle_toggle(state)
                end
            })

           local leaderboard_colors_toggle = section_settings:Toggle({
                name = "leaderboard colors",
                default = cheat_client.config.leaderboard_colors,
                pointer = "leaderboard_colors",
                callback = function(state)
                    if playerLabels then
                        for label, player in pairs(playerLabels) do
                            if label and label:IsA("TextLabel") and player then
                                if state then
                                    local color = getPlayerColor(player)
                                    label.TextColor3 = color
                                else
                                    if player:GetAttribute("MaxEdict") or (is_khei and player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("MaxEdict") and player.leaderstats.MaxEdict.Value) then
                                        label.TextColor3 = Color3.new(255, 214, 81)
                                    else
                                        label.TextColor3 = Color3.new(1, 1, 1)
                                    end
                                end
                            end
                        end
                    end
                end
            })

        end
    
        do -- Exploits 
            local page_exploits = window:Page({name = "exploits"})
            local section_settings = page_exploits:Section({name = "exploits settings"})
    
            do -- character

                local instant_mine_toggle = section_settings:Toggle({name = "instant mine", default = cheat_client.config.instant_mine, pointer = "instant_mine"})
                --local bard_stack_toggle = section_settings:Toggle({name = "bard stack", default = cheat_client.config.bard_stack, pointer = "bard_stack"})
                local no_insane_toggle = section_settings:Toggle({name = "no insane", default = cheat_client.config.no_insane, pointer = "no_insanity", callback = function(state)
                    if state then
                        if plr.Character then
                            for _,v in pairs(plr.Character:GetChildren()) do
                                if cheat_client.mental_injuries[v.Name] then
                                    v:Destroy()
                                end
                            end
                        end
                    end
                end})

                section_settings:Label({name = "--"})  
    
                local reset_button = section_settings:Button({name = "reset", confirm = true, callback = function()
                    if plr.Character then
                        utility:CharacterReset();
                    end
                end})

                local forcefield_con
                local forcefield_toggle = section_settings:Toggle({name = "enter forcefield", default = false, pointer = "forcefield", callback = function(state)
                    if state then
                        if plr.Character then
                            local function ff()
                                join_server:FireServer("hey")
                            end
                            ff()
                            forcefield_con = utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(child)
                                ff()
                            end))
                        end
                    else
                        if forcefield_con then
                            forcefield_con:Disconnect();
                            forcefield_con = nil
                        end
                    end
                end})
            end
    
            section_settings:Label({name = "--"})
    
            do -- observe
                local observe_toggle = section_settings:Toggle({name = "observe", default = cheat_client.config.observe, pointer = "observe", callback = function(state)
                    if not state then
                        if plr.Character then
                            ws.CurrentCamera.CameraSubject = plr.Character
                            active_observe = nil
                        end
                    end
                end})
            end

            local inviscam_toggle = section_settings:Toggle({name = "invis cam", default = cheat_client.config.invis_cam, pointer = "invis_cam", callback = function(state)
                if state then
                    plr.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
                else
                    plr.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
                end
            end})

            local max_zoom_toggle = section_settings:Toggle({name = "max zoom", default = cheat_client.config.max_zoom, pointer = "max_zoom", callback = function(state)
                if state then
                    plr.CameraMaxZoomDistance = 9e9
                else
                    plr.CameraMaxZoomDistance = 50
                end
            end})
        end
    
        do -- Movement
            local page_movement = window:Page({name = "movement"})
            local section_settings = page_movement:Section({name = "movement settings"})
        
            local flight_toggle = section_settings:Toggle({name = "flight", default = false, pointer = "flight"})
            
            --[[
            local flight_keybind = section_settings:Keybind({
                name = "Flight Keybind", 
                default = cheat_client.config.flight_keybind, 
                pointer = "flight_keybind"
            })
            
            utility:Connection(uis.InputBegan, function(input, gameProcessed)
                if gameProcessed then return end
                
                local keybindEnum = shared.pointers.flight_keybind:Get()
                if input.KeyCode == keybindEnum then
                    local current = shared.pointers.flight:Get()
                    shared.pointers.flight:Set(not current)
                end
            end)
            --]]
            
            local noclip_toggle = section_settings:Toggle({name = "noclip", default = cheat_client.config.noclip, pointer = "noclip"})
            local auto_fall_toggle = section_settings:Toggle({name = "auto fall", default = cheat_client.config.auto_fall or false, pointer = "auto_fall"})
            local flight_speed_slider = section_settings:Slider({name = "speed", default = cheat_client.config.flight_speed, max = 145, min = 0, tick = 50, pointer = "flight_speed"})
            -- CERESIAN FLY
        end
    
        do -- Automation 
            local page_automation = window:Page({name = "automation"})
            local section_settings = page_automation:Section({name = "automation settings"})
            
            local auto_dialogue_toggle = section_settings:Toggle({name = "auto dialogue", default = cheat_client.config.auto_dialogue, pointer = "auto_dialogue"})
            local auto_bard_toggle = section_settings:Toggle({name = "auto bard", default = cheat_client.config.auto_bard, pointer = "auto_bard"})
            local hide_bard_toggle = section_settings:Toggle({name = "hide bard", default = cheat_client.config.hide_bard, pointer = "hide_bard"})
    
            section_settings:Label({name = "--"})
    
            local anti_afk_toggle = section_settings:Toggle({name = "anti afk", default = cheat_client.config.anti_afk, pointer = "anti_afk", callback = function(state)
                for _, connection in next, getconnections(plr.Idled) do
                    if state then 
                        connection:Disable()
                    else 
                        connection:Enable()
                    end
                end
            end})

            section_settings:Label({name = "--"})


            local day_farm_toggle = section_settings:Toggle({
                name = "day farm", 
                default = false, 
                pointer = "day_farm", 
                callback = function(state)
                    cheat_client:day_farm(state)
                end
            })

            local day_goal_kick_toggle = section_settings:Toggle({name = "kick on day", default = false, pointer = "day_goal_kick"})
            local no_kick_toggle = section_settings:Toggle({name = "no kick 23 mode", default = false, pointer = "no_kick"})
            local day_farm_range_slider = section_settings:Slider({Name = "range", Min = 100, Max = 2500, default = 500, tick = 100, pointer = "day_farm_range"})
            local day_goal_slider = section_settings:Slider({Name = "target day", Min = utility:getPlayerDays(), Max = 999, default = utility:getPlayerDays(), tick = 1, pointer = "day_goal"})

            section_settings:Label({name = "--"})
            
            local auto_trinket_toggle = section_settings:Toggle({name = "auto trinket", default = cheat_client.config.auto_trinket, pointer = "auto_trinket"})
            local auto_ingredient_toggle = section_settings:Toggle({name = "auto ingredient", default = cheat_client.config.auto_ingredient, pointer = "auto_ingredient"})
            local auto_weapon_toggle = section_settings:Toggle({name = "auto weapon", default = cheat_client.config.auto_weapon, pointer = "auto_weapon"})
            local auto_resurrection_toggle = section_settings:Toggle({name = "auto resurrection", default = cheat_client.config.auto_resurrection, pointer = "auto_resurrection"})
            local auto_chair_toggle = section_settings:Toggle({name = "auto chair", default = cheat_client.config.auto_chair, pointer = "auto_chair"})

            section_settings:Label({name = "--"})

            local auto_bag_toggle = section_settings:Toggle({name = "auto bag", default = cheat_client.config.auto_bag, pointer = "auto_bag"})
            local bag_range_slider = section_settings:Slider({Name = "range", min = 1, max = 100, default = cheat_client.config.bag_range, tick = 20, pointer = "bag_range"})

            section_settings:Label({name = "--"})

            do -- Auto Potion Toggle
                local potions_list = section_settings:List({
                    name = "potions",
                    options = {"Health Potion", "Tespian Elixir", "Feather Feet", "Fire Protection", "Kingsbane", "Lordsbane", "Silver Sun", "Switch Witch"},
                    default = 1,
                    pointer = "potions"
                })

                local weapons_list = section_settings:List({
                    name = "weapons",
                    options = {"Mythril Dagger", "Mythril Sword", "Mythril Spear", "Steel Dagger", "Steel Sword", "Steel Spear", "Bronze Dagger", "Bronze Sword", "Bronze Spear"},
                    default = 1,
                    pointer = "weapons"
                })
            
                local auto_pot_toggle = section_settings:Toggle({
                    name = "auto potion",
                    default = false,
                    callback = function(state)
                        auto_pot_active = state
                        if auto_pot_active then
                            task.spawn(function()
                                while utility and auto_pot_active do
                                    utility:craft('Alchemy', shared.pointers["potions"]:Get())
                                    task.wait(0.25) 
                                end
                            end)
                        else
                            auto_pot_active = false
                        end
                    end
                })                
            end

            do -- Auto Craft Toggle
                local auto_pot_toggle = section_settings:Toggle({
                    name = "auto craft",
                    default = false,
                    callback = function(state)
                        auto_craft_active = state
                        if auto_craft_active then
                            task.spawn(function()
                                while utility and auto_craft_active do
                                    utility:craft('Smithing', shared.pointers["weapons"]:Get())
                                    task.wait(0.25) 
                                end
                            end)
                        else
                            auto_craft_active = false
                        end
                    end
                })                
            end

            section_settings:Label({name = "--"})
            
            local loop_gain_orderly_toggle = section_settings:Toggle({name = "loop gain orderly", default = nil, pointer = "loop_orderly"})
            local auto_train_climb_toggle = section_settings:Toggle({name = "train climb", default = nil, pointer = "train_climb"})
        end
        
        do -- World
            local page_world = window:Page({name = "world"})
            local section_settings = page_world:Section({name = "world settings"})
                
            local freecam_toggle = section_settings:Toggle({name = "freecam", default = false, pointer = "freecam", callback = function(state)
                local camera = utility:GetCamera()
                if plr.character then
                    local humanoid, torso = plr.Character:FindFirstChildOfClass("Humanoid"), plr.Character:FindFirstChild("Torso")
            
                    if humanoid and torso then
                        if state then
                            camera.CameraType = Enum.CameraType.Scriptable
                            StartCapture()
                        else
                            camera.CameraType = Enum.CameraType.Custom
                            StopCapture()
                            camera.CameraSubject = humanoid
                        end
                    end
                end
            end})
            local freecam_speed_slider = section_settings:Slider({name = "freecam speed", default = cheat_client.config.freecam_speed, max = 12, min = 0, tick = 1, pointer = "freecam_speed"})
            
            section_settings:Label({name = "--"})
            
            local function killbrick(state, container)
                for _, v in next, container:GetChildren() do
                    if v:IsA("BasePart") and v:FindFirstChild("TouchInterest") and not (cheat_client.safe_bricks[v.Name] or cheat_client.must_touch[v.BrickColor.Number]) then
                        v.CanTouch = not state
                    end
                end
            end
            
            
            local container
            if game.PlaceId == 5208655184 then
                container = ws:FindFirstChild("Map")
            elseif game.PlaceId == 3541987450 then
                container = ws
            end
            
            if container then
                section_settings:Toggle({
                    name = "no kill bricks",
                    default = cheat_client.config.no_killbrick,
                    pointer = "no_killbrick",
                    callback = function(state)
                        killbrick(state, container)
                    end
                })
            end            
            

            local no_fall_damage_toggle = section_settings:Toggle({name = "no fall damage", default = cheat_client.config.no_fall, pointer = "no_fall"})
            local temperature_lock_toggle = section_settings:Toggle({name = "temperature lock", default = cheat_client.config.temperature_lock, pointer = "temperature_lock"})
        end
        
        do -- Private Server (PS)
            local page_ps = window:Page({name = "private server"})
            local section_settings = page_ps:Section({name = "ps servers"})
        
            local server_ids = {
                "555985b2",
                "3cb81d2e",
                "14f4f6a3",
                "ceadbad3",
                "1967beef",
                "befa757f",
                "ffdc35ae",
                "dead55a2"
            }
        
            local function join_server(server_id)
                if cs:HasTag(plr.Character, "Danger") and not shared.pointers["ignore_danger"]:Get() then
                    repeat
                        rs.Heartbeat:Wait()
                    until not cs:HasTag(plr.Character, "Danger") or shared.pointers["ignore_danger"]:Get()
                end
                rps.Requests.JoinPrivateServer:FireServer(server_id)
            end
        
            for _, server_id in ipairs(server_ids) do
                section_settings:Button({
                    name = server_id,
                    confirm = true,
                    callback = function() join_server(server_id) end
                })
            end
        end
        
        
        do -- Misc
            local page_misc = window:Page({name = "misc"})
            local section_settings = page_misc:Section({name = "misc settings"})
    
            if not LPH_OBFUSCATED then
                local the_soul_toggle = section_settings:Toggle({name = "spoof the soul", default = cheat_client.config.the_soul, pointer = "spoof_the_soul"})
                local double_jump_toggle = section_settings:Toggle({name = "spoof double jump", default = cheat_client.config.double_jump, pointer = "spoof_acrobat"})

                section_settings:Label({name = "--"})
            end
            
            local copy_leaderboard_button = section_settings:Button({
                name = "copy leaderboard",
                callback = function()
                    local result = ""
                    local with_links = {}
                    local without_links = {}
                    
                    local server_name, server_region = utility:get_server_info()
                    if server_name ~= "" and server_region ~= "" then
                        result = server_name .. " " .. game.JobId .. " [" .. server_region .. "]\n\n"
                    end
                    
                    for _, player in ipairs(plrs:GetPlayers()) do
                        if player ~= plr then
                            local displayName = cheat_client:get_name(player)
                            local profileLink = "<https://www.roblox.com/users/" .. tostring(player.UserId) .. "/profile>"
                            
                            local joinable = utility:get_presence(player.UserId)
                            if joinable then
                                with_links[#with_links + 1] = displayName .. " [" .. player.Name .. "] " .. profileLink
                            else
                                without_links[#without_links + 1] = displayName .. " [" .. player.Name .. "]"
                            end
                        end
                    end
                    
                    if #with_links > 0 then
                        result = result .. table.concat(with_links, "\n")
                        
                        if #without_links > 0 then
                            result = result .. "\n"
                        end
                    end
                    
                    if #without_links > 0 then
                        result = result .. table.concat(without_links, "\n")
                    end
                    
                    setclipboard(result)
                end
            })


            local unblock_button = section_settings:Button({name = "unblock all", confirm = true, callback = function()
                utility:UnblockAll()
            end})
            local ignore_danger_toggle = section_settings:Toggle({name = "ignore danger", default = cheat_client.config.ignore_danger, pointer = "ignore_danger"})

            function wait_danger()
                while cs:HasTag(plr.Character, "Danger") and not shared.pointers["ignore_danger"]:Get() do
                    rs.Heartbeat:Wait()
                end
            end

            local log_button = section_settings:Button({
                name = "shutdown client",
                confirm = true,
                callback = function()
                    wait_danger();
                    if rps.Requests and rps.Requests:FindFirstChild("ReturnToMenu") and plr.Character then
                        rps.Requests.ReturnToMenu:InvokeServer()
                    end
                    game:Shutdown();
                end
            })
            
            local reconnect_button = section_settings:Button({
                name = "reconnect",
                confirm = true,
                callback = function()
                    wait_danger();
                    if rps.Requests and rps.Requests:FindFirstChild("ReturnToMenu") and plr.Character then
                        rps.Requests.ReturnToMenu:InvokeServer()
                    end
                    utility:ForceRejoin();
                end
            })
            
            local serverhop_button = section_settings:Button({
                name = "serverhop",
                confirm = true,
                callback = function()
                    wait_danger();
                    if rps.Requests and rps.Requests:FindFirstChild("ReturnToMenu") and plr.Character then
                        rps.Requests.ReturnToMenu:InvokeServer()
                    end
                    utility:Serverhop();
                end
            })
            
            section_settings:Label({name = "--"})
    
            local roblox_chat_toggle = section_settings:Toggle({name = "roblox chat", default = cheat_client.config.roblox_chat, pointer = "roblox_chat", callback = function(state)
                if state then
                    game:GetService("TextChatService").ChatWindowConfiguration.Enabled = true
                else
                    game:GetService("TextChatService").ChatWindowConfiguration.Enabled = false
                end
            end})

            local unhide_connections = {}
            local unhide_player_toggle = section_settings:Toggle({
                name = "unhide players",
                default = cheat_client.config.unhide_players,
                pointer = "unhide_players",
                callback = function(state)
                    if state then
                        for _, v in pairs(plrs:GetPlayers()) do
                            if v:GetAttribute("Hidden") then
                                v:SetAttribute("Hidden", false)
                            end
            
                            unhide_connections[v] = utility:Connection(v.AttributeChanged, function(attribute)
                                if attribute == "Hidden" then
                                    v:SetAttribute("Hidden", false)
                                end
                            end)
                        end
                    else
                        for _, v in pairs(plrs:GetPlayers()) do
                            if v.Character and v.Backpack then
                                if v.Backpack:FindFirstChild("Jack") or v.Character:FindFirstChild("Jack") then
                                    v:SetAttribute("Hidden", true)
                                end
                            end
            
                            if unhide_connections[v] then
                                unhide_connections[v]:Disconnect()
                                unhide_connections[v] = nil
                            end
                        end
                    end
                end
            })
            
            
            local gate_anti_toggle = section_settings:Toggle({name = "gate anti backfire", default = cheat_client.config.gate_anti_backfire, pointer = "gate_anti_backfire"})

            local streamer_mode_toggle = section_settings:Toggle({
                    name = "streamer mode",
                    default = cheat_client.config.streamer_mode,
                    pointer = "streamer_mode",
                    callback = function(state)
                        cheat_client:apply_streamer(state)
                    end
                })
            
            
            section_settings:Label({name = "--"})
    
            local players_value = section_settings:Label({name = "players: "..#plrs:GetPlayers(), pointer = "plrs_server"})
            local inventory_value = section_settings:Label({name = "", pointer = "inventory_value"})

            section_settings:Label({name = "--"})

            if game.PlaceId == 5208655184 then
                local crock_value = section_settings:Label({name = "castle rock: "..math.floor((os.time() - workspace:WaitForChild("MonsterSpawns"):WaitForChild("Triggers"):WaitForChild("CastleRockSnake"):WaitForChild("LastSpawned").Value) / 60).."m", pointer = "cr_last_looted"})
                local deepsunk_value = section_settings:Label({name = "deep sunken: "..math.floor((os.time() - workspace:WaitForChild("MonsterSpawns"):WaitForChild("Triggers"):WaitForChild("evileye2"):WaitForChild("LastSpawned").Value) / 60).."m", pointer = "deep_last_looted"})
            end
        end
    
        do -- ui
            local page_ui = window:Page({name = "ui"})
            local section_settings = page_ui:Section({name = "ui settings"})
    
            local notifications_toggle = section_settings:Toggle({name = "notifications", default = cheat_client.config.notifications, pointer = "notifications", callback = function(state)
                if state then
                    --warn("notifications on!")
                else
                    --warn("notifications turned off")
                end
            end})

            local ignore_friendly_toggle = section_settings:Toggle({name = "ignore friendly", default = cheat_client.config.ignore_friendly, pointer = "ignore_friendly"})

            local blatant_mode_toggle = section_settings:Toggle({name = "blatant mode", default = cheat_client.config.blatant_mode, pointer = "blatant_mode", callback = function(state)
                for _, toggle in pairs(shared.blatant_toggles) do
                    if state then
                        local actual_state = shared.pointers[toggle.pointer] and shared.pointers[toggle.pointer]:Get() or false
                        if actual_state then
                            utility:Update(toggle.text, "Color", "accent")
                        else
                            utility:Update(toggle.text, "Color", "text")
                        end
                    else
                        utility:Update(toggle.text, "Color", Color3.fromRGB(255, 0, 0))
                        if toggle.current and shared.pointers[toggle.pointer] then
                            shared.pointers[toggle.pointer]:Set(false)
                        end
                    end
                end
            end})

            section_settings:Label({name = "--"})

            local status_window = library:StatusWindow({
                name = "status effects",
                position = UDim2.new(0.8, -110, 0.8, -100)
            })
            
            local status_effects_toggle = section_settings:Toggle({name = "status effects", default = false, pointer = "status_effects", callback = function(state)
                if state then
                    if shared.pointers["status_auto_hide"] and shared.pointers["status_auto_hide"]:Get() then
                        local hasEffects = status_window.statusItems and #status_window.statusItems > 0
                        status_window:SetVisible(hasEffects)
                    else
                        status_window:SetVisible(true)
                    end
                else
                    status_window:SetVisible(false)
                end
            end})
            
            local status_auto_hide_toggle = section_settings:Toggle({name = "auto hide when empty", default = true, pointer = "status_auto_hide", callback = function(state)
                if shared.pointers["status_effects"]:Get() then
                    if state then
                        local hasEffects = status_window.statusItems and #status_window.statusItems > 0
                        status_window:SetVisible(hasEffects)
                    else
                        status_window:SetVisible(true)
                    end
                end
            end})
            
            local status_x_slider = section_settings:Slider({
                name = "status effects x position", 
                default = 5, 
                min = 0, 
                max = 100, 
                tick = 1,
                pointer = "status_effects_x",
                callback = function(value)
                    if not status_window or not status_window.UpdatePosition then
                        return
                    end
                    local currentY = shared.pointers["status_effects_y"] and shared.pointers["status_effects_y"]:Get() or 46
                    status_window:UpdatePosition(value, currentY)
                end
            })
            
            local status_y_slider = section_settings:Slider({
                name = "status effects y position", 
                default = 46, 
                min = 0, 
                max = 100, 
                tick = 1,
                pointer = "status_effects_y",
                callback = function(value)
                    if not status_window or not status_window.UpdatePosition then
                        return
                    end
                    local currentX = shared.pointers["status_effects_x"] and shared.pointers["status_effects_x"]:Get() or 5
                    status_window:UpdatePosition(currentX, value)
                end
            })
            
            status_window:SetVisible(false)
            
            local status_colors = {
                parry_cooldown = Color3.fromRGB(255, 255, 0),
                frostbite = Color3.fromRGB(150, 200, 255),
                burned = Color3.fromRGB(255, 100, 0),
                fire_protection = Color3.fromRGB(255, 150, 0),
                grindstone = Color3.fromRGB(150, 150, 255),
                danger = Color3.fromRGB(255, 0, 0),
                unconscious = Color3.fromRGB(150, 0, 0),
                knocked = Color3.fromRGB(200, 100, 0),
                curse = Color3.fromRGB(150, 0, 150),
                kingsbane = Color3.fromRGB(255, 0, 255),
                lordsbane = Color3.fromRGB(255, 0, 255),
                verto = Color3.fromRGB(100, 255, 100),
                spin_kick = Color3.fromRGB(255, 200, 100)
            }
            
            local function update_status()
                local status_pointer = shared.pointers["status_effects"]
                if not status_pointer:Get() then 
                    return 
                end
                
                local character = plr.Character
                if not character then 
                    return 
                end
                
                if status_window then
                    status_window:Clear()
                end
                
                if character:FindFirstChild("ParryCool") then
                    status_window:AddItem("Parry Cooldown", status_colors.parry_cooldown)
                end
                
                local frost = character:FindFirstChild("Frostbitten")
                if frost then
                    local frostType = frost:FindFirstChild("Lesser") and "Frostbite (Lesser)" or "Frostbite"
                    status_window:AddItem(frostType, status_colors.frostbite)
                end
                
                if character:FindFirstChild("Burned") then
                    status_window:AddItem("Burned", status_colors.burned)
                end
                
                if character:FindFirstChild("FireProtection") then
                    status_window:AddItem("Fire Protection", status_colors.fire_protection)
                end
                
                if character:FindFirstChild("ArmorPolished") then
                    status_window:AddItem("Grindstone", status_colors.grindstone)
                end
                
                if cs:HasTag(character, "Danger") or character:FindFirstChild("Danger") then
                    status_window:AddItem("Danger", status_colors.danger)
                end
                
                if cs:HasTag(character, "Unconscious") then
                    status_window:AddItem("Unconscious", status_colors.unconscious)
                elseif cs:HasTag(character, "Knocked") then
                    status_window:AddItem("Knocked", status_colors.knocked)
                end
                
                local curseCount = 0
                local children = character:GetChildren()
                for i = 1, #children do
                    local child = children[i]
                    if child.Name == "CurseMP" and child:IsA("NumberValue") then
                        curseCount = curseCount + 1
                    end
                end
                if curseCount > 0 then
                    local curse_text = ("%d Curse Tag%s"):format(curseCount, curseCount > 1 and "s" or "")
                    status_window:AddItem(curse_text, status_colors.curse)
                end
                
                local boosts = character:FindFirstChild("Boosts")
                if boosts then
                    local speed = boosts:FindFirstChild("SpeedBoost")
                    local attack = boosts:FindFirstChild("AttackSpeedBoost")
                    local damage = boosts:FindFirstChild("HaseldanDamageMultiplier")
                    
                    if speed and speed.Value == 8 and attack and attack.Value == 5 then
                        status_window:AddItem("Kingsbane", status_colors.kingsbane)
                    end
                    
                    if damage then
                        status_window:AddItem("Lordsbane", status_colors.lordsbane)
                    end
                end
                
                if character:FindFirstChild("VertoCooldown") then
                    status_window:AddItem("Verto Cooldown", status_colors.verto)
                end
                
                if character:FindFirstChild("AkumaLegHit") then
                    status_window:AddItem("Spin Kick", status_colors.spin_kick)
                end

                local auto_hide_pointer = shared.pointers["status_auto_hide"]
                if status_pointer:Get() and auto_hide_pointer and auto_hide_pointer:Get() then
                    local hasEffects = status_window.statusItems and #status_window.statusItems > 0
                    local is_visible = status_window.visible
                    if hasEffects ~= is_visible then
                        status_window:SetVisible(hasEffects)
                    end
                end
            end

            local status_update_connection
            local character_connections = {}
            
            local function setup(character)
                for _, conn in pairs(character_connections) do
                    conn:Disconnect()
                end
                character_connections = {}
                character_connections[#character_connections + 1] = utility:Connection(character.ChildAdded, function(child)
                    if shared.pointers["status_effects"]:Get() then
                        task.defer(update_status)
                    end
                end)
                
                character_connections[#character_connections + 1] = utility:Connection(character.ChildRemoved, function(child)
                    if shared.pointers["status_effects"]:Get() then
                        task.defer(update_status)
                    end
                end)
                
                if shared.pointers["status_effects"]:Get() then
                    task.defer(update_status)
                end
            end
            
            local function char_added(character)
                if character then
                    setup(character)
                end
            end
            
            if plr.Character then
                char_added(plr.Character)
            end
            
            local player_connection = utility:Connection(plr.CharacterAdded, char_added)
            local heartbeat_counter = 0
            local heartbeat_interval = 30
            
            status_update_connection = utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
                heartbeat_counter = heartbeat_counter + 1
                if heartbeat_counter >= heartbeat_interval then
                    heartbeat_counter = 0
                    if shared.pointers["status_effects"]:Get() and plr.Character then
                        update_status()
                    end
                end
            end))
        end
        
        do -- Config
            local page_misc = window:Page({name = "config"})
            local section_settings = page_misc:Section({name = "config settings"})
    
            local save_config_button = section_settings:Button({name = "save config", confirm = true, callback = function()
                utility:SaveConfig()
            end})
            local load_config_button = section_settings:Button({name = "load config", callback = function()
                utility:LoadConfig(shared.pointers["config_slot"]:Get())
            end})
            local config_slot_list = section_settings:List({name = "config slot", options = {"slot1.sex", "slot2.sex", "slot3.sex"}, default = 1, pointer = "config_slot"})
            
            section_settings:Label({name = "--"})

            local unload_button = section_settings:Button({name = "unload", callback = function()
                utility:Unload();
            end})
            
            local discord_join_button = section_settings:Button({name = "join discord", callback = function()
                local json = {
                    ["cmd"] = "INVITE_BROWSER",
                    ["args"] = {
                    ["code"] = "tu9JKPqbNR"
                },
                    ["nonce"] = 'a'
                }
                
                local a = request({
                    Url = 'http://127.0.0.1:6463/rpc?v=1',
                    Method = 'POST',
                    Headers = {
                    ['Content-Type'] = 'application/json',
                    ['Origin'] = 'https://discord.com'
                },
                Body = game:GetService('HttpService'):JSONEncode(json)}).Body
            end})
        end
    end
    
    do -- Legit Intent System
        local model_path = "roguehake/watched.rbxm"
        local legit_intent_gui = nil
        local range = 100

        if not isfolder("roguehake") then
            makefolder("roguehake")
        end

        if not isfile(model_path) then
            local success, result = pcall(function()
                return game:HttpGet("https://hydroxide.solutions/watched.rbxm")
            end)

            if success and result then
                writefile(model_path, result)
            else
                warn("failed to download intent model")
            end
        end

        if isfile(model_path) then
            local asset = getcustomasset(model_path)
            local success, model = pcall(function()
                return game:GetObjects(asset)[1]
            end)

            if success and model then
                legit_intent_gui = model
                --print("intent model loaded successfully")
            else
                warn("failed to load intent model:", model)
            end
        end

        local function create_watched_gui(character)
            if not legit_intent_gui or not shared.pointers["legit_intent"]:Get() then 
                return 
            end
            
            if character:FindFirstChild("Watched") then 
                return 
            end
            
            repeat task.wait(0.05) until character:FindFirstChild("HumanoidRootPart")
            local root_part = character:FindFirstChild("HumanoidRootPart")
            if not root_part then 
                return 
            end
            
            local eye = legit_intent_gui:Clone()
            local display = eye:FindFirstChild("Tool")
            if not display then 
                return 
            end
            
            local tool = character:FindFirstChildOfClass("Tool")
            display.Text = tool and tool.Name or ""
            
            eye.Parent = hidden_folder
            eye.Adornee = root_part
            eye.Name = "Watched"
            eye.Active = false
            watched_guis[character] = {gui = eye, display = display}
            
            utility:Connection(character.ChildAdded, function(object)
                if object:IsA("Tool") then
                    display.Text = object.Name
                end
            end)
            
            utility:Connection(character.ChildRemoved, function(object)
                if object:IsA("Tool") then
                    display.Text = ""
                end
            end)
            
            local connection
            connection = utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
                if not character.Parent then
                    connection:Disconnect()
                    return
                end
                
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    eye.Adornee = hrp
                    local camera_pos = ws.CurrentCamera.CFrame.Position
                    local distance = (camera_pos - hrp.Position).Magnitude
                    
                    if distance < range then
                        ts:Create(display, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
                    else
                        ts:Create(display, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
                    end
                else
                    eye:Destroy()
                    watched_guis[character] = nil
                    connection:Disconnect()
                end
            end))
        end

        local function remove_watched_gui(character)
            local watched = watched_guis[character]
            if watched and watched.gui then
                ts:Create(watched.display, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
                task.wait(0.25)
                watched.gui:Destroy()
                watched_guis[character] = nil
            end
        end
        
        cheat_client.legit_intent_cleanup = function()
            for character, watched in pairs(watched_guis) do
                if watched and watched.gui then
                    watched.gui:Destroy()
                    watched_guis[character] = nil
                end
            end
        end

        local function setup()
            if not shared.pointers["legit_intent"]:Get() then 
                return 
            end
            
            for _, player in pairs(plrs:GetPlayers()) do
                if player ~= plr then
                    if player.Character then
                        create_watched_gui(player.Character)
                    end
                    
                    utility:Connection(player.CharacterAdded, function(character)
                        if shared and shared.pointers["legit_intent"]:Get() then
                            create_watched_gui(character)
                        end
                    end)
                    
                    utility:Connection(player.CharacterRemoving, function(character)
                        if watched_guis[character] then
                            remove_watched_gui(character)
                        end
                    end)
                end
            end
            
            utility:Connection(plrs.PlayerAdded, function(player)
                if player ~= plr then
                    utility:Connection(player.CharacterAdded, function(character)
                        if shared and shared.pointers["legit_intent"]:Get() then
                            create_watched_gui(character)
                        end
                    end)
                    
                    utility:Connection(player.CharacterRemoving, function(character)
                        if watched_guis[character] then
                            remove_watched_gui(character)
                        end
                    end)
                end
            end)
            
            utility:Connection(plrs.PlayerRemoving, function(player)
                if player.Character and watched_guis[player.Character] then
                    remove_watched_gui(player.Character)
                end
            end)
        end

        cheat_client.legit_intent_setup = function()
            if legit_intent_gui then
                setup()
            end
        end
        
        if legit_intent_gui and shared.pointers["legit_intent"]:Get() then
            setup()
        end
    end

    -- Hooks // put anti cheat hooks at top 🙏🙏
    do
        do -- Collection Hooks
            old_hastag = hookfunction(cs.HasTag, function(self, object, tag)
                if not checkcaller() then
                    if object == plr.Character then
                        if tag == "Acrobat" and shared and shared.pointers["spoof_acrobat"] and shared.pointers["spoof_acrobat"]:Get() then
                            return true
                        elseif tag == "The Soul" and shared and shared.pointers["spoof_the_soul"] and shared.pointers["spoof_the_soul"]:Get() then
                            return true
                        end
                    end
                end
                return old_hastag(self, object, tag)
            end)
        end

        do -- Get Dialogue Remote
            local active_connections = {}

            local function sensitive(tbl, key)
                for k, _ in pairs(tbl) do
                    if typeof(k) == "string" and k:lower() == key:lower() then
                        return true
                    end
                end
                return false
            end
            
            for _, remote in pairs(rps.Requests:GetChildren()) do
                if remote:IsA("RemoteEvent") then
                    local connection
                    connection = utility:Connection(remote.OnClientEvent, function(data)
                        if typeof(data) == "table" and (sensitive(data, "choices") or sensitive(data, "speaker")) then
                            if not dialogue_remote then
                                warn("found remote:", remote.Name)
                                dialogue_remote = remote
                                
                                -- Set up auto dialogue with its own connection
                                if shared and shared.setupAutoDialogue then
                                    shared.setupAutoDialogue()
                                end
                                
                                for _, conn in pairs(active_connections) do
                                    conn:Disconnect()
                                end
                                active_connections = {}
                                active_connections[#active_connections + 1] = connection
                            end
                        end
                    end)
                    active_connections[#active_connections + 1] = connection
                end
            end
        end
    end
    
    -- Init
    do
        utility:setup_error_webhook();

        do -- Disable Input Keys
            cas:BindActionAtPriority("DisableInputKeys", function()
                return Enum.ContextActionResult.Sink
            end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Left, Enum.KeyCode.Right, Enum.KeyCode.PageUp, Enum.KeyCode.PageDown)
        end

        do -- FOV
            aimbot_fov_circle = utility:Create("Circle", {
                Visible = false,
                Radius = 100,
                Transparency = 1,
                Thickness = 1,
                Color = Color3.fromRGB(255,255,255),
            }, "esp")

            silent_circle = utility:Create("Circle", {
                Visible = false,
                Radius = 5,
                Transparency = 0.7,
                Thickness = 1,
                Color = Color3.fromRGB(255,0,0),
            }, "esp")
        end

        do -- Mana
            spellvis = utility:Create("Square", {
                Visible = false,
                Transparency = 0.45, -- 0.3
                Filled = true,
                ZIndex = 100,
                Color = Color3.fromRGB(255, 0, 0),
            }, "esp")

            snapvis = utility:Create("Square", {
                Visible = false,
                Transparency = 0.45, -- 0.3
                Filled = true,
                ZIndex = 100,
                Color = Color3.fromRGB(0, 0, 255),
            }, "esp")
        end

        do -- Mana Overlay
            local char = plr and plr.Character
            
            local current_spell_instance = nil
            local current_spell = nil
            
            function cheat_client:update_visuals(tool)
                if not plr or not plr.Character then return end
                if not shared.pointers["mana_overlay"]:Get() then
                    cheat_client:clear_visuals()
                    return
                end
                
                if not (plr and plr.PlayerGui and 
                    plr.PlayerGui:FindFirstChild("StatGui") and 
                    plr.PlayerGui.StatGui:FindFirstChild("LeftContainer") and 
                    plr.PlayerGui.StatGui.LeftContainer:FindFirstChild("Mana")) then
                    cheat_client:clear_visuals()
                    return
                end
                
                local manaBar = plr.PlayerGui.StatGui.LeftContainer.Mana
                char = plr.Character
                
                if not tool or not tool:IsDescendantOf(char) then
                    cheat_client:clear_visuals()
                    return
                end

                local spell = cheat_client.spell_cost[tool.Name]
                if not spell or not spell[1] then
                    cheat_client:clear_visuals()
                    return
                end

                local lowerbound = spell[1][1]
                local upperbound = spell[1][2]

                local data = char:FindFirstChild("Artifacts")
                if data and data:FindFirstChild("PhilosophersStone") then
                    lowerbound = 15
                    upperbound = 100
                end

                local scholar_boost = 0
                local boosts = char:FindFirstChild("Boosts")
                if boosts then
                    local scholars = boosts:FindFirstChild("ScholarsBoon")
                    if scholars then
                        scholar_boost = scholar_boost + scholars.Value
                    end
                end

                local backpack = plr:FindFirstChild("Backpack")
                if backpack then
                    if backpack:FindFirstChild("WiseCasting") then
                        scholar_boost = scholar_boost + 2
                    end
                    if backpack:FindFirstChild("RemTraining") then
                        scholar_boost = scholar_boost + 3
                    end
                end

                lowerbound = math.max(0, lowerbound - scholar_boost)
                upperbound = math.min(100, upperbound + scholar_boost)

                local baseX = manaBar.AbsolutePosition.X
                local baseY = manaBar.AbsolutePosition.Y
                local barWidth = manaBar.AbsoluteSize.X
                local barHeight = manaBar.AbsoluteSize.Y
                local topInset = game:GetService("GuiService"):GetGuiInset().Y

                local function getY(percent)
                    return baseY + barHeight * (1 - percent / 100) + topInset
                end

                local spellTop = getY(upperbound)
                local spellBottom = getY(lowerbound)
                spellvis.Position = Vector2.new(baseX, spellTop)
                spellvis.Size = Vector2.new(barWidth, math.abs(spellBottom - spellTop))
                spellvis.Visible = true

                if spell[2] then
                    local snapLower = math.max(0, spell[2][1] - scholar_boost)
                    local snapUpper = math.min(100, spell[2][2] + scholar_boost)

                    local snapTop = getY(snapUpper)
                    local snapBottom = getY(snapLower)
                    snapvis.Position = Vector2.new(baseX, snapTop)
                    snapvis.Size = Vector2.new(barWidth, math.abs(snapBottom - snapTop))
                    snapvis.Visible = true
                else
                    snapvis.Visible = false
                end

            end

            local function setup_character()
                if not plr or not plr.Character then return end
                char = plr.Character
                
                if utility then
                    utility:Connection(char.ChildAdded, function(child)
                        if not shared.pointers["mana_overlay"]:Get() then
                            cheat_client:clear_visuals()
                            return
                        end
                            
                        if not cheat_client.spell_cost[child.Name] then return end

                        if current_spell then
                            current_spell:Disconnect()
                            current_spell = nil
                        end

                        current_spell_instance = child
                        cheat_client:update_visuals(child)

                        current_spell = utility:Connection(child.AncestryChanged, function(_, parent)
                            if parent == plr.Backpack then
                                cheat_client:clear_visuals()
                                current_spell_instance = nil

                                if current_spell then
                                    current_spell:Disconnect()
                                    current_spell = nil
                                end
                            end
                        end)
                    end)
                    
                    if shared.pointers["mana_overlay"]:Get() then
                        cheat_client:update_visuals(char:FindFirstChildOfClass("Tool"))
                    end
                end
            end
            
            if plr and plr.Character then
                setup_character()
            end
            
            if utility and plr then
                utility:Connection(plr.CharacterAdded, function(newChar)
                    char = newChar
                    setup_character()
                end)
            end
        end
        
        do -- No Fall Damage & Anti Gate Backfire
            if game.PlaceId == 5208655184 or game.PlaceId == 3541987450 then
                local o;
                o = hookfunction(Instance.new("RemoteEvent").FireServer, function(Event, ...)
                	local args = {...}
                	if shared and shared.pointers["no_fall"]:Get() and plr.Character and plr.Character:FindFirstChild'CharacterHandler' and plr.Character.CharacterHandler:FindFirstChild('Remotes') and Event.Parent == plr.Character.CharacterHandler.Remotes then
                		if #args == 2 and typeof(args[2]) == "table" then
                			return
                		end
                	end
                	if shared and shared.pointers["gate_anti_backfire"]:Get() and tostring(Event):match("RightClick") then
                        if plr.Character then
                            if plr.Character:FindFirstChild('Gate') then
                                local artifacts_folder = plr.Character:FindFirstChild("Artifacts")
                                if artifacts_folder and artifacts_folder:FindFirstChild("PhilosophersStone") then
                                    return Event:FireServer(...)
                                end
                                
                                local mana_instance = plr.Character:FindFirstChild('Mana')
                                if mana_instance then
                                    local mana_value = mana_instance.Value;
                                    
                                    if (mana_value > 75 and mana_value < 80) or not cs:HasTag(plr.Character,'Danger') and plr.Character:FindFirstChild("AzaelHorn") then
                                        return Event:FireServer(...)
                                    end
                                    
                                    return
                                end
                            end
                        end
                    end

                    if shared and shared.pointers["temperature_lock"]:Get() and rps.Requests and Event.Parent == rps.Requests and Event.Name ~= "ClearTrinket" then
                        if #args == 1 and typeof(args[1]) == "string" then
                            return 'Oresfall';
                        end
                    end

                	return o(Event, ...)
                end)
            end
        end

        do -- Automation
            local function find_tool(names, matching)
                if not plr.Character then return end
                local function checkItem(item)
                    for _, name in ipairs(names) do
                        if matching == "match" then
                            if string.match(item.Name:lower(), name:lower()) then
                                return item
                            end
                        else
                            if item.Name == name then
                                return item
                            end
                        end
                    end
                    return nil
                end

                for _, item in ipairs(plr.Backpack:GetChildren()) do
                    if item:IsA("Tool") then
                        local tool = checkItem(item)
                        if tool then return tool end
                    end
                end

                if plr.Character then
                    for _, item in ipairs(plr.Character:GetChildren()) do
                        if item:IsA("Tool") then
                            local tool = checkItem(item)
                            if tool then return tool end
                        end
                    end
                end

                return nil
            end

            local function use(tool)
                if not (plr.Character and tool) then return end

                local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                if not humanoid then return end

                humanoid:UnequipTools();

                if tool.Parent == plr.Backpack then
                    humanoid:EquipTool(tool)
                end

                if not plr.Character:FindFirstChild(tool.Name) then
                    tool.AncestryChanged:Wait()
                end

                task.wait(0.025) -- utility:random_wait()
                local charTool = plr.Character:FindFirstChild(tool.Name)
                if charTool then
                    charTool:Activate()
                end
            end

            utility:Connection(cs:GetInstanceAddedSignal("Unconscious"), function(instance)
                if plr.Character and instance == plr.Character and shared and shared.pointers["auto_resurrection"]:Get() then
                    task.spawn(function()
                        task.wait(utility:random_wait())
                        local resurrection = find_tool({ "Resurrection", "Dragon Awakening", "Dragon Resurrection" }, "exact")
                        if resurrection then
                            use(resurrection)
                        end
                    end)
                end
            end)

            utility:Connection(cs:GetInstanceRemovedSignal("Knocked"), function(instance)
                if plr.Character and instance == plr.Character and shared and shared.pointers["auto_chair"]:Get() then
                    local shouldUseChair = true
                    if plr.Character:FindFirstChild("HumanoidRootPart") then
                        local bone = plr.Character.HumanoidRootPart:FindFirstChild("Bone")
                        if bone and bone:IsA("BasePart") then
                            shouldUseChair = false
                        end
                    end
                    
                    if shouldUseChair then
                        task.spawn(function()
                            local chair = find_tool({ "chair", "throne" }, "match")
                            if chair then
                                task.wait(0.055)
                                use(chair)
                            end
                        end)
                    end
                end
            end)
        end
        
        do
            local TRANSPARENCY_VALUE = 0.7
            local DETECTION_RADIUS = 25
            
            local function makeNearbyPartsTransparent(character, rootPart)
                for part, originalTransparency in pairs(transparent_parts) do
                    if part and part:IsA("BasePart") then
                        part.Transparency = originalTransparency
                    end
                end
                transparent_parts = {}
                
                local nearbyParts = workspace:GetPartBoundsInRadius(rootPart.Position, DETECTION_RADIUS)
                for _, part in ipairs(nearbyParts) do
                    if not part:IsDescendantOf(character) and part:IsA("BasePart") and part.CanCollide then
                        transparent_parts[part] = part.Transparency
                        part.Transparency = TRANSPARENCY_VALUE
                    end
                end
            end
            
            local function restorePartTransparency()
                for part, originalTransparency in pairs(transparent_parts) do
                    if part and part:IsA("BasePart") then
                        part.Transparency = originalTransparency
                    end
                end
                transparent_parts = {}
            end
            
            function cheat_client:restore_state()
                restorePartTransparency()
                
                if was_noclip_enabled and plr and plr.Character then
                    restorePartTransparency()
                    
                    local character = plr.Character
                    local huma = character:FindFirstChildOfClass("Humanoid")
                    
                    for _, part in ipairs(plr.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            if part.Name == "Head" or part.Name == "Torso" then
                                part.CanCollide = true
                            else
                                part.CanCollide = false
                            end
                        end
                    end
                    
                    if huma then
                        huma:SetStateEnabled(5, true)
                        huma:ChangeState(5)
                    end
                    
                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.Anchored = false
                    end
                    
                    was_noclip_enabled = false
                end
            end
            
            utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                if not (shared and shared.pointers["flight"]:Get()) then
                    if shared.pointers["noclip"] and shared.pointers["noclip"]:Get() then
                        shared.pointers["noclip"]:Set(false)
                    end
                    
                    if was_noclip_enabled then
                        cheat_client:restore_state()
                    end
                    return
                end
                
                local character = plr.Character
                if character then
                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    if rootPart and character:FindFirstChild("FakeHumanoid",true) then
                        local camCFrame = workspace.CurrentCamera.CFrame
                        local huma = character:FindFirstChildOfClass("Humanoid")
                        
                        if true then -- flight is already checked at start
                            local isNoclipEnabled = shared.pointers["noclip"] and shared.pointers["noclip"]:Get()
                            
                            if not shared.pointers["flight"]:Get() and isNoclipEnabled then
                                return
                            end
                            
                            if isNoclipEnabled then
                                makeNearbyPartsTransparent(plr.Character, rootPart)
                                
                                for i,v in next, plr.Character:GetDescendants() do
                                    if v:IsA("BasePart") then
                                        v.CanCollide = false
                                        
                                        if v ~= rootPart then
                                            v.RotVelocity = Vector3.new(0, 0, 0)
                                        end
                                    end
                                end
                                
                                if not was_noclip_enabled and huma then
                                    huma:SetStateEnabled(5, false)
                                    huma:ChangeState(3)
                                end
                                
                                if rootPart then
                                    local lookVector = camCFrame.LookVector
                                    local flatLook = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
                                    
                                    if flatLook.Magnitude > 0.01 then
                                        rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + flatLook)
                                    end
                                end
                            elseif was_noclip_enabled then
                                restorePartTransparency()
                                
                                for _, part in ipairs(plr.Character:GetDescendants()) do
                                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                                        if part.Name == "Head" or part.Name == "Torso" then
                                            part.CanCollide = true
                                        else
                                            part.CanCollide = false
                                        end
                                    end
                                end
                                
                                if huma then
                                    huma:SetStateEnabled(5, true)
                                    huma:ChangeState(5)
                                end
                            end
                            
                            was_noclip_enabled = isNoclipEnabled
                            
                            if not cheat_client.custom_flight_functions["GetFocusedTextBox"](uis) then
                                local eVector = Vector3.new()
                                local rVector, lVector, uVector = camCFrame.RightVector, camCFrame.LookVector, camCFrame.UpVector
            
                                if cheat_client.custom_flight_functions["IsKeyDown"](uis, "W") then eVector += lVector end
                                if cheat_client.custom_flight_functions["IsKeyDown"](uis, "S") then eVector -= lVector end
                                if cheat_client.custom_flight_functions["IsKeyDown"](uis, "D") then eVector += rVector end
                                if cheat_client.custom_flight_functions["IsKeyDown"](uis, "A") then eVector -= rVector end
                                
                                local isHoldingSpace = cheat_client.custom_flight_functions["IsKeyDown"](uis, "Space")
                                if isHoldingSpace then eVector += uVector end
                                if cheat_client.custom_flight_functions["IsKeyDown"](uis, "LeftShift") then eVector -= uVector end
                                
                                local isInAir = huma and huma.FloorMaterial == Enum.Material.Air
                                local isInWater = huma and (huma:GetState() == Enum.HumanoidStateType.Swimming or huma:GetState() == Enum.HumanoidStateType.PlatformStanding and huma.FloorMaterial == Enum.Material.Water)
                                if shared.pointers["auto_fall"]:Get() and isInAir and not isHoldingSpace and not isInWater then
                                    eVector -= uVector
                                end
                                
                                local isMovingDown = cheat_client.custom_flight_functions["IsKeyDown"](uis, "LeftShift") or (shared.pointers["auto_fall"]:Get() and isInAir and not isHoldingSpace and not isInWater)
                                if isNoclipEnabled and not isMovingDown and rootPart.AssemblyLinearVelocity.Y < 0 then
                                    local currentVelocity = rootPart.AssemblyLinearVelocity
                                    rootPart.AssemblyLinearVelocity = Vector3.new(currentVelocity.X, 0, currentVelocity.Z)
                                end
                                
                                if eVector.Unit.X == eVector.Unit.X then
                                    rootPart.AssemblyLinearVelocity = eVector.Unit * shared.pointers["flight_speed"]:Get()
                                else
                                    local currentVel = rootPart.AssemblyLinearVelocity
                                    rootPart.AssemblyLinearVelocity = currentVel * 0.85
                                end
                                
                                local shouldAnchor = eVector == Vector3.new() or rootPart.AssemblyLinearVelocity.Magnitude < 1
                                rootPart.Anchored = shouldAnchor
                            end
                        elseif was_noclip_enabled then
                            restorePartTransparency()
                            
                            for _, part in ipairs(plr.Character:GetDescendants()) do
                                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                                    if part.Name == "Head" or part.Name == "Torso" then
                                        part.CanCollide = true
                                    else
                                        part.CanCollide = false
                                    end
                                end
                            end
                            
                            if huma then
                                huma:SetStateEnabled(5, true)
                                huma:ChangeState(5)
                            end
                            
                            was_noclip_enabled = false
                        end
                    end
                end
            end))
        end

        do -- Init Character
            if plr.Character then
                local boosts = plr.Character:WaitForChild("Boosts")
                -- Anti Hystericus
                if plr.Character:FindFirstChild('Confused') and shared.pointers["anti_hystericus"]:Get() then
                    plr.Character.Confused:Destroy()
                end

                -- Mental Injury
                for _,v in pairs(plr.Character:GetChildren()) do
                    if cheat_client.mental_injuries[v.Name] then
                        if shared.pointers["no_insanity"]:Get() then
                            v:Destroy()
                        end
                    end
                end
        
                utility:Connection(plr.Character.ChildAdded, function(obj)
                    -- Anti Hystericus
                    if obj.Name == 'Confused' and shared.pointers["anti_hystericus"]:Get() then
                        task.defer(obj.Destroy, obj)
                        return
                    end
    
                    -- Mental Injury
                    if cheat_client.mental_injuries[obj.Name] and shared.pointers["no_insanity"]:Get() then
                        task.defer(obj.Destroy, obj)
                        return
                    end
        
                    -- No Stun
                    if cheat_client.stuns[obj.Name] and shared.pointers["no_stun"]:Get() then
                        task.defer(obj.Destroy, obj)
                        return
                    end
                end)
        
                utility:Connection(boosts.ChildAdded, function(obj)
                    if obj.Name == "MusicianBuff" and obj.Value ~= "Symphony of Horses" and obj.Value ~= "Song of Lethargy" then
                        task.defer(obj.Destroy, obj)
                        return
                    end
        
                    if obj.Name == "SpeedBoost" and shared.pointers["no_stun"]:Get()  then
                        task.defer(obj.Destroy, obj)
                        return
                    end
                end)
            end
        end
    
        do -- Init ESP
            do -- Trinket
                for _,object in next, ws:GetChildren() do
                    if object.Name == "Part" and object:FindFirstChild("ID") then
                        local trinket_name, trinket_color, trinket_zindex = cheat_client:identify_trinket(object)
                        cheat_client:add_trinket_esp(object, trinket_name, trinket_color, trinket_zindex)
                    end
                end
            end

            do -- Shrieker ESP
                for _, child in pairs(ws.Live:GetChildren()) do
                    if child:IsA("Model") and string.match(child.Name, ".Shrieker") and child:FindFirstChild("MonsterInfo") then
                        cheat_client:add_shrieker_chams(child)
                    end
                end
            end

            do -- Ingredient
                if game.PlaceId ~= 3541987450 then
                    for index, instance in next, ws:GetChildren() do
                        if ingredient_folder then 
                            break
                        end
            
                        if instance.ClassName == "Folder" then
                            for index, ingredient in next, instance:GetChildren() do
                                if ingredient.ClassName == "UnionOperation" and ingredient:FindFirstChild("ClickDetector") and ingredient:FindFirstChild("Blacklist") then
                                    ingredient_folder = instance
                                    break
                                end
                            end
                        end
                    end
        
                    if ingredient_folder then
                        for _,object in next, ingredient_folder:GetChildren() do
                            local ingredient_name = cheat_client:identify_ingredient(object)
                            cheat_client:add_ingredient_esp(object, ingredient_name)
                        end
                    end
                end
            end
    
            do -- Ore
                for _,object in next, ws.Ores:GetChildren() do
                    cheat_client:add_ore_esp(object)
                end
            end
        end
    
        do -- Init Bard
            if plr.PlayerGui:FindFirstChild("BardGui") then
                utility:Connection(plr.PlayerGui.BardGui.ChildAdded, function(child)
                    if shared and shared.pointers["auto_bard"]:Get() then
                        if child:IsA("ImageButton") and child.Name == "Button" then
                            if shared.pointers["hide_bard"]:Get() then
                                plr.PlayerGui.BardGui.Enabled = false
                            else
                                child.Parent.Enabled = true
                            end
                            task.wait(.9 + ((math.random(3, 11) / 100)))
                            firesignal(child.MouseButton1Click)
                        end
                    end
                end)
            end
        end
    
        do -- Init Illu Checker
            for _, player in next, plrs:GetPlayers() do
                if player.Character and player:FindFirstChild("Backpack") then
    
                    local observe_tool = player.Backpack:FindFirstChild("Observe") or player.Character:FindFirstChild("Observe")
    
                    if observe_tool then 
                        if (library ~= nil and library.Notify) then
                            utility:sound("rbxassetid://2865227039",2)
                            library:Notify(cheat_client:get_name(player).." ["..player.Name.."] is an illusionist", Color3.fromRGB(5,139,252))
                        end
                    else
                        local waiting_connection 
                        waiting_connection = utility:Connection(player.Backpack.ChildAdded, function(child)
                            if child.Name == "Observe" then
                                if (library ~= nil and library.Notify) then
                                    utility:sound("rbxassetid://2865227039",2)
                                    library:Notify(cheat_client:get_name(player).." ["..player.Name.."] is an illusionist", Color3.fromRGB(5,139,252))
                                end
                                if waiting_connection and utility then
                                    waiting_connection:Disconnect();
                                    waiting_connection = nil
                                end
                            end
                        end)
                    end
                end
    
                utility:Connection(player.CharacterAdded, function(character)
                    --task.wait(1) -- maybe i should remove ts
                    local observe_tool = player.Backpack:FindFirstChild("Observe") or character:FindFirstChild("Observe")
    
                    if observe_tool then 
                        if (library ~= nil and library.Notify) then
                            utility:sound("rbxassetid://2865227039",2)
                            library:Notify(cheat_client:get_name(player).." ["..player.Name.."] is an illusionist", Color3.fromRGB(5,139,252))
                        end
                    else
                        local waiting_connection
                        if utility then
                            waiting_connection = utility:Connection(player.Backpack.ChildAdded, function(child)
                                if waiting_connection then
                                    if child.Name == "Observe" then
                                        if (library ~= nil and library.Notify) then
                                            utility:sound("rbxassetid://2865227039",2)
                                            library:Notify(cheat_client:get_name(player).." ["..player.Name.."] is an illusionist", Color3.fromRGB(5,139,252))
                                        end
                                        
                                        if waiting_connection and utility then
                                            waiting_connection:Disconnect();
                                            waiting_connection = nil
                                        end
                                    end
                                end
                            end)
                        end
                    end
                end)
            end
        end
        
        do -- Init Artifact Checker
            for _,player in pairs(plrs:GetPlayers()) do
                if player.Character then
                    if (library ~= nil and library.Notify) then
                        for i,v in pairs(player.Backpack:GetChildren()) do
                            if table.find(cheat_client.artifacts, v.Name) then
                                library:Notify(cheat_client:get_name(player).." ["..player.Name.."] has a "..v.Name, Color3.fromRGB(255,0,179))
                            end
                        end
                        utility:Connection(player.Backpack.ChildAdded, function(child)
                                if table.find(cheat_client.artifacts, child.Name) then
                                    library:Notify(cheat_client:get_name(player).." ["..player.Name.."] has a "..child.Name, Color3.fromRGB(255,0,179))
                                end
                            end)
                        utility:Connection(player.CharacterAdded, function(character)
                            for _,v in pairs(player.Backpack:GetChildren()) do
                                if table.find(cheat_client.artifacts, v.Name) then
                                    library:Notify(cheat_client:get_name(player).." ["..player.Name.."] has a "..v.Name, Color3.fromRGB(255,0,179))
                                end
                            end
                            utility:Connection(player.Backpack.ChildAdded, function(child)
                                if table.find(cheat_client.artifacts, child.Name) then
                                    library:Notify(cheat_client:get_name(player).." ["..player.Name.."] has a "..child.Name, Color3.fromRGB(255,0,179))
                                end
                            end)
                        end)
                    end
                end
            end
        end
    
        do -- Mod detection
            for _,player in next, plrs:GetPlayers() do
                task.spawn(cheat_client.detect_mod, cheat_client, player)
            end
        end
    end
    
    -- Connections
    do
        do -- Player ESP (dynamic) - try implement shared.pointers["player_esp"].Changed or even put this into the toggle callback itself, idk.
            local esp_objects = {}
            local esp_enabled_last = false
            local disable_timer = 0
            local DESTRUCTION_DELAY = 3
            
            utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
                local esp_enabled = shared.pointers and shared.pointers["player_esp"] and shared.pointers["player_esp"]:Get()
                
                if esp_enabled and not esp_enabled_last then
                    for _, player in pairs(plrs:GetPlayers()) do
                        if player ~= plr and not esp_objects[player] then
                            task.spawn(function()
                                esp_objects[player] = cheat_client:add_player_esp(player)
                            end)
                        end
                    end
                    
                elseif not esp_enabled and esp_enabled_last then
                    disable_timer = tick()
                    
                elseif not esp_enabled and esp_objects and next(esp_objects) and (tick() - disable_timer > DESTRUCTION_DELAY) then
                    for player, esp in pairs(esp_objects) do
                        if esp and esp.destruct then
                            esp:destruct()
                        end
                        esp_objects[player] = nil
                    end
                end
                
                esp_enabled_last = esp_enabled
            end))
            
            utility:Connection(plrs.PlayerAdded, function(player)
                if shared.pointers and shared.pointers["player_esp"] and shared.pointers["player_esp"]:Get() and player ~= plr then
                    task.spawn(function()
                        esp_objects[player] = cheat_client:add_player_esp(player)
                    end)
                end
            end)
            
            utility:Connection(plrs.PlayerRemoving, function(player)
                if esp_objects[player] then
                    if esp_objects[player].destruct then
                        esp_objects[player]:destruct()
                    end
                    esp_objects[player] = nil
                end
            end)
        end
    
        do -- Trinket ESP
            utility:Connection(ws.ChildAdded, function(object)
                if object.Name == "Part" and object:FindFirstChild("ID") then
                    local trinket_name, trinket_color, trinket_zindex = cheat_client:identify_trinket(object)
                    cheat_client:add_trinket_esp(object, trinket_name, trinket_color, trinket_zindex)
                end
            end)
        end
    
        do -- Ingredient ESP
            if game.PlaceId ~= 3541987450 then
                if ingredient_folder then
                    utility:Connection(ingredient_folder.ChildAdded, function(object)
                        local ingredient_name = cheat_client:identify_ingredient(object)
                        cheat_client:add_ingredient_esp(object, ingredient_name)
                    end)
                end
            end
        end
    
        do -- Ore ESP
            utility:Connection(ws.Ores.ChildAdded, function(object)
                cheat_client:add_ore_esp(object)
            end)
        end

        do -- Shrieker Chams
            utility:Connection(ws.Live.ChildAdded, function(child)
                if child:IsA("Model") and string.match(child.Name, ".Shrieker") then
                    cheat_client:add_shrieker_chams(child)
                end
            end)
        end

        do -- Character
            utility:Connection(plr.CharacterAdded, function(char)
                local boosts = char:WaitForChild("Boosts")
                
                utility:Connection(plr.Character.ChildAdded, function(obj)
                    -- Anti Hystericus
                    if obj.Name == 'Confused' and shared.pointers["anti_hystericus"]:Get() then
                        task.defer(obj.Destroy, obj)
                        return
                    end
    
                    -- Mental Injury
                    if cheat_client.mental_injuries[obj.Name] and shared.pointers["no_insanity"]:Get() then
                        task.defer(obj.Destroy, obj)
                        return
                    end
        
                    -- No Stun
                    if cheat_client.stuns[obj.Name] and shared.pointers["no_stun"]:Get() then
                        task.defer(obj.Destroy, obj)
                        return
                    end
                end)
        
                utility:Connection(boosts.ChildAdded, function(obj)
                    if obj.Name == "MusicianBuff" and obj.Value ~= "Symphony of Horses" and obj.Value ~= "Song of Lethargy" then
                        task.defer(obj.Destroy, obj)
                        return
                    end

                    if obj.Name == "SpeedBoost" and shared.pointers["no_stun"]:Get()  then
                        task.defer(obj.Destroy, obj)
                        return
                    end
                end)
            end)
        end

        do -- Streamer Mode
            utility:Connection(ws.Live.ChildAdded, function(child)
                if child:IsA("Model") and child.Name == plr.Name and shared and shared.pointers["streamer_mode"]:Get() then
                    task.spawn(function()
                        local statGui
                        repeat
                            task.wait(0.025)
                            statGui = plr.PlayerGui:FindFirstChild("StatGui")
                        until statGui and statGui:FindFirstChild("Container") and statGui.Container:FindFirstChild("CharacterName")
                        repeat task.wait(0.05) until statGui.Container.CharacterName:FindFirstChild("Shadow")
                        repeat task.wait(0.025) until plr.Character and plr.Character:FindFirstChild("FakeHumanoid",true)
                        task.wait(0.025) -- 0.186
                        cheat_client:apply_streamer(true)
                    end)
                end
            end)
        end
    
        do -- Bard
            utility:Connection(plr.PlayerGui.ChildAdded, function(child)
                if child.Name == "BardGui" then
                    utility:Connection(child.ChildAdded, function(child)
                        if shared and shared.pointers["auto_bard"]:Get() then
                            if child:IsA("ImageButton") and child.Name == "Button" then
                                if shared.pointers["hide_bard"]:Get() then
                                    plr.PlayerGui.BardGui.Enabled = false
                                else
                                    child.Parent.Enabled = true
                                end
                                task.wait(.9 + ((math.random(3, 11) / 100)))
                                firesignal(child.MouseButton1Click)
                            end
                        end
                    end)
                end
            end)

            --[[
            local x
            x = hookmetamethod(game, "__index", LPH_NO_VIRTUALIZE(function(self,key)
                if self == plr and key == "Name" and not checkcaller() and shared and shared.pointers["auto_bard"]:Get() and getcallingscript().Parent and getcallingscript().Parent.Name == "BardGui" then
                    return "Melon_Sensei"
                end
                return x(self,key)
            end))
            ]]
        end

        do -- Invis cam
            local x
            x = hookmetamethod(game, "__index", LPH_NO_VIRTUALIZE(function(self,key)
                if self == plr and key == "DevCameraOcclusionMode" and not checkcaller() and shared and shared.pointers["invis_cam"]:Get() and getcallingscript().Name == "Input" then -- This is from Phrax
                    return Enum.DevCameraOcclusionMode.Zoom
                elseif self == plr and key == 'CameraMaxZoomDistance' and getcallingscript().Name == 'Input' then
                    return 50
                end
                return x(self,key)
            end))
        end



        do -- Leaderboard Color System
            local tool_list = {
                "Demon Step", "Axe Kick", "Demon Flip",
                "Lightning Drop", "Lightning Elbow",
                "Floresco",
                "Command Monsters",
                "The Wraith", "The Shadow", "The Soul", "Elegant Slash", "Needle's Eye", "Acrobat", "RapierTraining",
                "Joyous Dance", "Sweet Soothing", "Song of Lethargy",
                "Shadow Fan", "Ethereal Strike",
                "Grapple", "Resurrection",
                "Wing Soar", "Thunder Spear Crash", "Dragon Awakening",
                "Harpoon", "Skewer", "Hunter's Focus",
                "Deep Sacrifice", "Leviathan Plunge", "Chain Pull", "PrinceBlessing",
                "Charged Blow", "Hyper Body", "White Flame Charge",
                "Darkflame Burst", "Dark Sigil Helmet",
                "Remote Smithing", "Grindstone",
                "Calm Mind", "Swallow Reversal", "Triple Slash", "Blade Flash", "Flowing Counter",
                "Abyssal Scream", "Wrathful Leap",
                "Brandish", "Puncture", "Azure Ignition", "Blade Crash"
            }
            
            local tool_dict = {}
            for _, toolName in ipairs(tool_list) do
                tool_dict[toolName] = true
            end
            
            local function hasListedTools(player)
                if not player then return false end
                
                if player:FindFirstChild("Backpack") then
                    for _, tool in ipairs(player.Backpack:GetChildren()) do
                        if tool_dict[tool.Name] then
                            return true
                        end
                    end
                end
                
                if player.Character then
                    for _, tool in ipairs(player.Character:GetChildren()) do
                        if tool_dict[tool.Name] then
                            return true
                        end
                    end
                end
                
                return false
            end
            
            local function hasObserveTool(player)
                if not player then return false end
                
                if player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Observe") then
                    return true
                end
                
                if player.Character and player.Character:FindFirstChild("Observe") then
                    return true
                end
                
                return false
            end
            
            getPlayerColor = function(player)
                if not player then return Color3.new(1, 1, 1) end
                
                local hasCharacter = player.Character ~= nil

                if player == plr then
                    return Color3.fromRGB(40, 225, 90)
                end
                
                -- Moderator Detection - Make them REALLY visible
                local isModerator = false
                if cheat_client and cheat_client.mod_list and table.find(cheat_client.mod_list, player.UserId) then
                    isModerator = true
                end
                
                if not isModerator then
                    local success, isInGroup = pcall(function()
                        return player:IsInGroup(4556484)
                    end)
                    if success and isInGroup then
                        isModerator = true
                    end
                end
                
                if isModerator then
                    if hasCharacter then
                        return Color3.fromRGB(139, 0, 0) -- Dark Red
                    else
                        return Color3.fromRGB(100, 0, 0) -- Darker Red
                    end
                end
                
                if player:GetAttribute("Hidden") then
                    if hasCharacter then
                        return Color3.fromRGB(255, 90, 255) -- Bright Magenta
                    else
                        return Color3.fromRGB(200, 70, 200) -- Darker Magenta
                    end
                end

                if hasObserveTool(player) then
                    if hasCharacter then
                        return Color3.fromRGB(41, 212, 255)
                    else
                        return Color3.fromRGB(77, 150, 158)
                    end
                end
                
                if player:GetAttribute("MaxEdict") or (is_khei and player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("MaxEdict") and player.leaderstats.MaxEdict.Value) then
                    if hasCharacter then
                        return Color3.fromRGB(255, 214, 81)
                    else
                        return Color3.fromRGB(180, 160, 7)
                    end
                end
                
                if hasListedTools(player) then
                    if hasCharacter then
                        return Color3.fromRGB(240, 80, 80)
                    else
                        return Color3.fromRGB(150, 60, 60)
                    end
                end
                
                if hasCharacter then
                    return Color3.new(1, 1, 1)
                else
                    return Color3.fromRGB(120, 120, 120)
                end
            end
            
            updatePlayerLabel = function(player, label)
                if not player or not label or not label:IsA("TextLabel") then return end
                
                if shared and shared.pointers["leaderboard_colors"]:Get() then
                    local color = getPlayerColor(player)
                    label.TextColor3 = color
                else
                    if player:GetAttribute("MaxEdict") or (is_khei and player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("MaxEdict") and player.leaderstats.MaxEdict.Value) then
                        label.TextColor3 = Color3.new(255, 214, 81)
                    else
                        label.TextColor3 = Color3.new(1, 1, 1)
                    end
                end
            end
            
            local function updateAllLabels()
                if playerLabels then
                    for label, player in pairs(playerLabels) do
                        if label and label:IsA("TextLabel") and player then
                            updatePlayerLabel(player, label)
                        end
                    end
                end
            end
            
            local function monitorPlayer(player)
                utility:Connection(player.CharacterAdded, function()
                    task.wait(2)
                    if playerLabels then
                        for label, p in pairs(playerLabels) do
                            if p == player then
                                updatePlayerLabel(player, label)
                            end
                        end
                    end
                end)
                
                utility:Connection(player.CharacterRemoving, function()
                    task.wait(0.1)
                    if playerLabels then
                        for label, p in pairs(playerLabels) do
                            if p == player then
                                updatePlayerLabel(player, label)
                            end
                        end
                    end
                end)
                
                if player:FindFirstChild("Backpack") then
                    utility:Connection(player.Backpack.ChildAdded, function()
                        task.wait(1)
                        if playerLabels then
                            for label, p in pairs(playerLabels) do
                                if p == player then
                                    updatePlayerLabel(player, label)
                                end
                            end
                        end
                    end)
                    
                    --utility:Connection(player.Backpack.ChildRemoved, function()
                    --    task.wait(0.1)
                    --    for label, p in pairs(playerLabels) do
                    --        if p == player then
                    --            updatePlayerLabel(player, label)
                    --        end
                    --    end
                    --end)
                end
                
                if game.PlaceId == 5208655184 then
                    utility:Connection(player:GetAttributeChangedSignal("MaxEdict"), function()
                        if playerLabels then
                            for label, p in pairs(playerLabels) do
                                if p == player then
                                    updatePlayerLabel(player, label)
                                end
                            end
                        end
                    end)
                elseif game.PlaceId == 3541987450 then
                    if player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("MaxEdict") then
                        utility:Connection(player.leaderstats.MaxEdict:GetPropertyChangedSignal("Value"), function()
                            if playerLabels then
                                for label, p in pairs(playerLabels) do
                                    if p == player then
                                        updatePlayerLabel(player, label)
                                    end
                                end
                            end
                        end)
                    end
                end
                
                if player.Character then
                    utility:Connection(player.Character.ChildAdded, function(child)
                        if child:IsA("Tool") then
                            task.wait(2)
                            if playerLabels then
                                for label, p in pairs(playerLabels) do
                                    if p == player then
                                        updatePlayerLabel(player, label)
                                    end
                                end
                            end
                        end
                    end)
                    
                    --utility:Connection(player.Character.ChildRemoved, function(child)
                    --    if child:IsA("Tool") then
                    --        task.wait(2)
                    --        for label, p in pairs(playerLabels) do
                    --            if p == player then
                    --                updatePlayerLabel(player, label)
                    --            end
                    --        end
                    --    end
                    --end)
                end
            end
            
            for _, player in ipairs(plrs:GetPlayers()) do
                monitorPlayer(player)
            end
            
            utility:Connection(plrs.PlayerAdded, monitorPlayer)
            local processLeaderboardLabel = LPH_NO_VIRTUALIZE(function(label)
                if not label:IsA("TextLabel") then return end
                
                task.spawn(function()
                    for _, connection in pairs(getconnections(label.MouseEnter)) do
                        if connection.Function then
                            local upvalues = debug.getupvalues(connection.Function)
                            for index, value in pairs(upvalues) do
                                if type(value) == "string" then
                                    local username = value:gsub("\226\128\142", "")
                                    local player = plrs:FindFirstChild(username)
                                    
                                    if player then
                                        playerLabels[label] = player
                                        updatePlayerLabel(player, label)
                                        return
                                    end
                                end
                            end
                        end
                    end
                end)
            end)
            
            local function initializeLeaderboard()
                if not plr.PlayerGui:FindFirstChild("LeaderboardGui") then
                    return
                end
                
                local leaderboardFrame = plr.PlayerGui.LeaderboardGui:WaitForChild("MainFrame"):WaitForChild("ScrollingFrame")
                for _, label in ipairs(leaderboardFrame:GetChildren()) do
                    if label:IsA("TextLabel") then
                        processLeaderboardLabel(label)
                    end
                end
                
                utility:Connection(leaderboardFrame.ChildAdded, function(label)
                    if label:IsA("TextLabel") then
                        task.wait(0.1)
                        processLeaderboardLabel(label)
                    end
                end)
                
                utility:Connection(leaderboardFrame.ChildRemoved, function(label)
                    if playerLabels[label] then
                        playerLabels[label] = nil
                    end
                end)
            end
            
            task.spawn(function()
                while not plr.PlayerGui:FindFirstChild("LeaderboardGui") do
                    task.wait(0.5)
                end
                
                initializeLeaderboard()                
                utility:Connection(plr.PlayerGui.ChildAdded, function(child)
                    if child.Name == "LeaderboardGui" then
                        task.wait(0.5)
                        initializeLeaderboard()
                    end
                end)
            end)
            
            local originalNameRightClick = shared.NameRightClick
            if originalNameRightClick then
                shared.NameRightClick = function(Player, Label, ...)
                    local result = originalNameRightClick(Player, Label, ...)
                    if Player and Label then
                        playerLabels[Label] = Player
                        updatePlayerLabel(Player, Label)
                    end
                    return result
                end
            end
            
            task.spawn(function()
                while playerLabels and task.wait(3) do
                    updateAllLabels()
                end
            end)
        end

    
        do -- Observe
            local THIS_SCRIPT = script
            local Spectating
            
            if shared == nil then
                shared = {}
            end
        
            shared.SPRLS = THIS_SCRIPT
            
            if shared.SPROC == nil then
                shared.SPROC = {}
            end

            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom

            if not plr.PlayerGui:FindFirstChild(LPH_ENCSTR("LeaderboardGui")) then
                local newLB = sui:FindFirstChild(LPH_ENCSTR("LeaderboardGui")):Clone()
                newLB.Parent = plr.PlayerGui
                newLB.ResetOnSpawn = true

                local connection
                connection = utility:Connection(plr.CharacterAdded, function()
                    newLB:Destroy()
                    connection:Disconnect()
                    InitSpectator()
                end)
            end

            local startMenu = plr.PlayerGui:FindFirstChild(LPH_ENCSTR("StartMenu"))
            if startMenu then
                local copyright = startMenu:FindFirstChild(LPH_ENCSTR("CopyrightBar"))
                if copyright then
                    copyright:Destroy()
                end
            end

            task.spawn(function()
                local gui = plr:FindFirstChild("PlayerGui")
                while utility and gui and gui.Parent do
                    local leaderboardGui = gui:FindFirstChild(LPH_ENCSTR("LeaderboardGui"))
                    if leaderboardGui and not leaderboardGui.Enabled then
                        leaderboardGui.Enabled = true
                    end
                    task.wait(0.2)
                end
            end)

            task.spawn(function()
                if utility then
                    local gui = plr:FindFirstChild("PlayerGui")
                    if (not plr.Character and gui and not gui:FindFirstChild(LPH_ENCSTR('LeaderboardGui'))) then
                        local tempGui = sui:FindFirstChild(LPH_ENCSTR('LeaderboardGui')):Clone()
                        tempGui.Parent = gui

                        plr.CharacterAdded:Wait()
                        tempGui:Destroy()
                    end
                end
            end)


            local Find = LPH_NO_VIRTUALIZE(function(Upvalues, Function)
                local Constants = {}
                if typeof(Upvalues) == "function" then
                    Constants = debug.getconstants(Upvalues)
                    Upvalues = debug.getupvalues(Upvalues)
                end

                for i, v in pairs(Upvalues) do
                    local Env = getfenv(Function)
                    Env.Constants = Constants
                    setfenv(Function, Env)
                    local S, E = pcall(Function, v)

                    if S and E then
                        local Env = getfenv(2)
                        Env.Value = v
                        Env.Index = i
                        setfenv(2, Env)
                        return v
                    end
                end

                return false
            end)

            local function InTable(Table, Value)
                for i, v in pairs(Table) do
                    if v == Value then
                        return true
                    end
                end

                return false
            end

            local function NameRightClick(Player, Label)
                if shared == nil or shared.SPRLS ~= THIS_SCRIPT then
                    if script ~= THIS_SCRIPT then
                        return false
                    end
                end

                local Button = Label:FindFirstChild(LPH_ENCSTR("SPB")) or Instance.new(LPH_ENCSTR("TextButton"), Label)
                Button.Name = LPH_ENCSTR("SPB")
                Button.Transparency = 1
                Button.Text = ""
                Button.Size = UDim2.new(1, 0, 1, 0)
                Button.Position = UDim2.new(0, 0, 0, 0)

                utility:Connection(Button.MouseButton2Click, function()
                    -- Also check using the same pattern here
                    if shared == nil or shared.SPRLS ~= THIS_SCRIPT then
                        if script ~= THIS_SCRIPT then
                            return false
                        end
                    end

                    if (Spectating == Player or Player == plr) and plr.Character then
                        Spectating = nil
                        workspace.CurrentCamera.CameraSubject = plr.Character:FindFirstChildOfClass(LPH_ENCSTR("Humanoid"))
                    else
                        if Player.Character and Player.Character:FindFirstChild(LPH_ENCSTR("Humanoid")) then
                            Spectating = Player
                            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom

                            local T = Spectating.Character:GetDescendants()
                            
                            if plr.Character then
                                for i, v in pairs(plr.Character:GetDescendants()) do
                                    T[#T + 1] = v
                                end
                            end

                            workspace.CurrentCamera.CameraSubject = Player.Character:FindFirstChildOfClass(LPH_ENCSTR("Humanoid"))
                        end
                    end
                end)
                
                return Label
            end

            function InitSpectator()
                pcall(LPH_NO_VIRTUALIZE(function()
                    plr.PlayerGui:WaitForChild("LeaderboardGui"):WaitForChild("LeaderboardClient")
                    wait()
                    
                    for i, v in pairs(getreg()) do
                        if typeof(v) == "function" and islclosure(v) and not (isourclosure and isourclosure(v)) then
                            local ups = debug.getupvalues(v)
                            local scr = getfenv(v).script

                            if Find(ups, function(x)
                                return scr.Name == "LeaderboardClient" and typeof(x) == "function" and
                                    InTable(debug.getconstants(x), "HouseRank")
                            end) then
                                local Labels = {}

                                if Find(Value, function(x)
                                    return typeof(x) == "table" and x[plr]
                                end) then
                                    Labels = Value
                                    for i, v in pairs(Value) do
                                        NameRightClick(i, v)
                                    end
                                end

                                if shared == nil then
                                    shared = {}
                                end
                                
                                if shared.SPROC == nil then
                                    shared.SPROC = {}
                                end

                                local Index = (shared.SPROC[v] and shared.SPROC[v].Index) or Index
                                local Original = (shared.SPROC[v] and shared.SPROC[v].Function) or debug.getupvalues(v)[Index]
                                
                                if shared.SPROC then
                                    shared.SPROC[v] = {Index = Index, Function = Original}
                                end

                                debug.setupvalue(v, Index, function(Player, ...)
                                    local Label = Original(Player, ...)
                                    local DummyConstant = "HouseRank"
                                    local DummyTable = Labels

                                    NameRightClick(Player, Label)

                                    return Label
                                end)
                            end
                        end
                    end
                end))
            end

            InitSpectator()
        end
    
        do -- Rendering Handler
            utility:Connection(uis.WindowFocused, function() 
                cheat_client.window_active = true
            end)
        
            utility:Connection(uis.WindowFocusReleased, function() 
                cheat_client.window_active = false
            end)
        end
    
        do -- Notification Updater
            utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                if #shared.notifications == 0 then
                    return
                end
                
                local count = #shared.notifications
                local removed_first = false
            
                for i = 1, count do
                    local current_tick = tick()
                    local notification = shared.notifications[i]
                    if notification then
                        if current_tick - notification.start_tick > notification.lifetime then
                            task.spawn(notification.destruct, notification)
                            table.remove(shared.notifications, i)
                        elseif count > 35 and not removed_first then -- 10
                            removed_first = true
                            local first = table.remove(shared.notifications, 1)
                            task.spawn(first.destruct, first)
                        else
                            local previous_notification = shared.notifications[i - 1]
                            local basePosition
                            if previous_notification then
                                basePosition = Vector2.new(16, previous_notification.drawings.main_text.Position.y + previous_notification.drawings.main_text.TextBounds.y + 1)
                            else
                                basePosition = Vector2.new(16, 40)
                            end
            
                            notification.drawings.shadow_text.Position = basePosition + Vector2.new(1, 1)
                            notification.drawings.main_text.Position = basePosition
                            notification.drawings.shadow_text.Visible = true
                            notification.drawings.main_text.Visible = true
                        end
                    end
                end
            end))
        end

        do -- Unhide Players
            utility:Connection(plrs.PlayerAdded, function(player)
                if shared and shared.pointers["unhide_players"]:Get() then
                    if player:GetAttribute("Hidden") then
                        player:SetAttribute("Hidden", false)
                    end
                end

                utility:Connection(player.AttributeChanged, function(attribute)
                    if attribute == "Hidden" and shared and shared.pointers["unhide_players"]:Get() then
                        player:SetAttribute("Hidden", false)
                    end
                end)
            end)
        end
    
        do -- Illusionist Checker
            utility:Connection(plrs.PlayerAdded, function(player)
                if player.Character and player:FindFirstChild("Backpack") then
    
                    local observe_tool = player.Backpack:FindFirstChild("Observe") or player.Character:FindFirstChild("Observe")
    
                    if observe_tool then 
                        if (library ~= nil and library.Notify) then
                            utility:sound("rbxassetid://2865227039",2)
                            library:Notify(cheat_client:get_name(player).." ["..player.Name.."] is an illusionist", Color3.fromRGB(5,139,252))
                        end
                    else
                        local waiting_connection 
                        waiting_connection = utility:Connection(player.Backpack.ChildAdded, function(child)
                            if child.Name == "Observe" then
                                if (library ~= nil and library.Notify) then
                                    utility:sound("rbxassetid://2865227039",2)
                                    library:Notify(cheat_client:get_name(player).." ["..player.Name.."] is an illusionist", Color3.fromRGB(5,139,252))
                                end
                                if waiting_connection and utility then
                                    waiting_connection:Disconnect();
                                    waiting_connection = nil
                                end
                            end
                        end)
                    end
                end
    
                utility:Connection(player.CharacterAdded, function(character)
                    --task.wait(1)
                    local observe_tool = player.Backpack:FindFirstChild("Observe") or character:FindFirstChild("Observe")
    
                    if observe_tool then 
                        if (library ~= nil and library.Notify) then
                            utility:sound("rbxassetid://2865227039",2)
                            library:Notify(cheat_client:get_name(player).." ["..player.Name.."] is an illusionist", Color3.fromRGB(5,139,252))
                        end
                    else
                        if utility then
                            local waiting_connection 
                            waiting_connection = utility:Connection(player.Backpack.ChildAdded, function(child)
                                if child.Name == "Observe" then
                                    if (library ~= nil and library.Notify) then
                                        utility:sound("rbxassetid://2865227039",2)
                                        library:Notify(cheat_client:get_name(player).." ["..player.Name.."] is an illusionist", Color3.fromRGB(5,139,252))
                                    end
                                    if waiting_connection and utility then
                                        waiting_connection:Disconnect();
                                        waiting_connection = nil
                                    end
                                end
                            end)
                        end
                    end
                end)
            end)
        end
        
        do -- Combat log checker
            utility:Connection(plrs.PlayerRemoving, function(player)
                if player.Character and cs:HasTag(player.Character,'Danger') then
                    if (library ~= nil and library.Notify) then
                        library:Notify(cheat_client:get_name(player).." ["..player.Name.."] combat logged, what a retard LOL", Color3.fromRGB(5,139,252))
                    end
                end
            end)
        end
        
        do -- Artifact Checker
            utility:Connection(plrs.PlayerAdded, function(player)
                if (library ~= nil and library.Notify) then
                    utility:Connection(player.CharacterAdded, function(character)
                        --task.wait(1)
                        for _,v in pairs(player.Backpack:GetChildren()) do
                            if cheat_client and cheat_client.artifacts and table.find(cheat_client.artifacts, v.Name) then
                                if (library ~= nil and library.Notify) then
                                    library:Notify(cheat_client:get_name(player).." ["..player.Name.."] has a "..v.Name, Color3.fromRGB(255,0,179))
                                end
                            end
                        end
                        utility:Connection(player.Backpack.ChildAdded, function(child)
                            if cheat_client and cheat_client.artifacts and table.find(cheat_client.artifacts, child.Name) then
                                if (library ~= nil and library.Notify) then
                                    library:Notify(cheat_client:get_name(player).." ["..player.Name.."] has a "..child.Name, Color3.fromRGB(255,0,179))
                                end
                            end
                        end)
                    end)
                end
            end)
        end
    
        do -- Mod Detection
            utility:Connection(plrs.PlayerAdded, function(player)
                task.spawn(cheat_client.detect_mod, cheat_client, player)
            end)
        end

        do -- Day Farm
            local function readCSG(union)
                local result = gethiddenproperty(union, "PhysicalConfigData")
                local unionData
                
                if type(result) == "table" and #result >= 2 then
                    unionData = result[2]
                else
                    unionData = select(2, pcall(function() return gethiddenproperty(union, "PhysicalConfigData") end))
                    
                    if type(unionData) ~= "string" then
                        warn("DEBUG - PhysicalConfigData type:", type(result))
                        
                        for _, prop in pairs({"BinaryData", "MeshData", "RawData", "ConfigData"}) do
                            local success, data = pcall(function() return gethiddenproperty(union, prop) end)
                            if success and type(data) == "string" and #data > 100 then
                                warn("Found usable data in property:", prop)
                                unionData = data
                                break
                            end
                        end
                        
                        if type(unionData) ~= "string" then
                            warn("WARNING: Could not get valid CSG data. Captcha bypass may fail.")
                            return {}
                        end
                    end
                end
                
                local unionDataStream = tostring(unionData)
                if type(unionDataStream) ~= "string" then
                    warn("ERROR: Failed to convert union data to string")
                    return {}
                end

                local function readByte(n)
                    if #unionDataStream < n then
                        return ""
                    end
                    local returnData = unionDataStream:sub(1, n)
                    unionDataStream = unionDataStream:sub(n+1, #unionDataStream)
                    return returnData
                end;

                readByte(51); -- useless data

                local points = {};

                while #unionDataStream > 0 do
                    readByte(20) -- trash
                    readByte(20) -- trash 2

                    local vertSize = string.unpack('ii', readByte(8));

                    for i = 1, (vertSize/3) do
                        local x, y, z = string.unpack('fff', readByte(12))
                        points[#points + 1] = union.CFrame:ToWorldSpace(CFrame.new(x, y, z)).Position;
                    end;

                    local faceSize = string.unpack('I', readByte(4));
                    readByte(faceSize * 4);
                end;

                return points;
            end;

            function solveCaptcha(union)
                local worldModel = Instance.new('WorldModel');
                worldModel.Parent = cg;

                local newUnion = union:Clone()
                newUnion.Parent = worldModel;

                local cameraCFrame = gethiddenproperty(union.Parent, "CameraCFrame");
                local points = readCSG(union);

                local rangePart = Instance.new('Part');
                rangePart.Parent = worldModel;
                rangePart.CFrame = cameraCFrame:ToWorldSpace(CFrame.new(-8, 0, 0))
                rangePart.Size = Vector3.new(1, 100, 100);

                local model = Instance.new('Model', worldModel);
                local baseModel = Instance.new('Model', worldModel);

                baseModel.Name = 'Base';
                model.Name = 'Final';

                for i, v in next, points do
                    local part = Instance.new('Part', baseModel);
                    part.CFrame = CFrame.new(v);
                    part.Size = Vector3.new(0.1, 0.1, 0.1);
                end;

                local seen = false;
                for i = 0, 100 do
                    rangePart.CFrame = rangePart.CFrame * CFrame.new(1, 0, 0)

                    local overlapParams = OverlapParams.new();
                    overlapParams.FilterType = Enum.RaycastFilterType.Whitelist;
                    overlapParams.FilterDescendantsInstances = {baseModel};

                    local bob = worldModel:GetPartsInPart(rangePart, overlapParams);
                    if(seen and #bob <= 0) then break end;

                    for i, v in next, bob do
                        seen = true;

                        local new = v:Clone();

                        new.Parent = model;
                        new.CFrame = CFrame.new(new.Position);
                    end;
                end;

                for i, v in next, model:GetChildren() do
                    v.CFrame = v.CFrame * CFrame.Angles(0, math.rad(union.Orientation.Y), 0);
                end;

                local shorter, found = math.huge, '';
                local result = model:GetExtentsSize();

                local values = {
                    ['Arocknid'] = Vector3.new(11.963972091675, 6.2284870147705, 12.341609954834),
                    ['Howler'] = Vector3.new(2.904595375061, 7.5143890380859, 6.4855442047119),
                    ['Evil Eye'] = Vector3.new(6.7253036499023, 6.2872190475464, 11.757738113403),
                    ['Zombie Scroom'] = Vector3.new(4.71413230896, 4.400146484375, 4.7931442260742),
                    ['Golem'] = Vector3.new(17.123439788818, 21.224365234375, 6.9429664611816),
                };

                for i, v in next, values do
                    if((result - v).Magnitude < shorter) then
                        found = i;
                        shorter = (result - v).Magnitude;
                    end;
                end;

                worldModel:Destroy();
                worldModel = nil;

                return found;
            end

            local time_elapsed = 0
            local playerDays = 0

            local function no_kick()
                if shared.pointers["no_kick"]:Get() then
                    return true
                end
                return false
            end
            
            local function kickPlayer(message)
                if cs:HasTag(plr.Character, "Danger") then
                    repeat task.wait() until not cs:HasTag(plr.Character, "Danger")
                end

                --print("[DEBUG] Kicking player: " .. message)
                utility:plain_webhook(message)
                rps.Requests.ReturnToMenu:InvokeServer()
                plr:Kick(message)
                utility:Unload()
            end

            local function check_silver()
                if no_kick() then
                    return
                end

                local currencyGui = plr:WaitForChild("PlayerGui"):FindFirstChild("CurrencyGui")
                if not currencyGui or not currencyGui:FindFirstChild("Silver") or not currencyGui.Silver:FindFirstChild("Value") then
                    return true
                end

                local silver_text = plr.PlayerGui.CurrencyGui.Silver.Value.Text
                local silver = tonumber(silver_text)

                if not silver then
                    return true
                end

                return silver >= 250
            end

            function gacha()
                if not shared.pointers["day_farm"]:Get() and plr.Name ~= "Tharxifen" then return false end
                if not plr.Character then return end

                local npc = workspace.NPCs:FindFirstChild("Xenyari")
                local npcHead = npc:FindFirstChild("Head")
                local clickDetector = npc:FindFirstChildWhichIsA("ClickDetector")
                
                if not workspace.NPCs or not workspace.NPCs:FindFirstChild("Xenyari") or 
                not workspace.NPCs.Xenyari:FindFirstChild("Head") or
                not workspace.NPCs.Xenyari:FindFirstChildWhichIsA("ClickDetector") then
                    return false
                end

                local distanceFromNPC = plr:DistanceFromCharacter(npcHead.Position)
                if distanceFromNPC > 20 then
                    return false
                end

                if not check_silver() then
                    kickPlayer(string.format("%s (%s) tried gacha without enough silver (250 needed)", plr.Name, plr.UserId))
                    return false
                end
                
                if not playerDays then
                    playerDays = utility:getPlayerDays() or 0
                    if not playerDays then
                        repeat
                            playerDays = utility:getPlayerDays()
                            task.wait(0.1)
                        until playerDays
                    end
                end
                
                if dialogue_remote then
                    local dialogConnection
                    dialogConnection = utility:Connection(dialogue_remote.OnClientEvent, function(dialogData)
                        task.wait(1)
                        
                        if not dialogData.choices then
                            dialogue_remote:FireServer({exit = true})
                            task.wait(1)
                            dialogConnection:Disconnect()
                        else
                            dialogue_remote:FireServer({choice = dialogData.choices[1]})
                        end
                    end)
                end

                repeat
                    fireclickdetector(clickDetector)
                task.wait(0.25);
                until plr.PlayerGui:FindFirstChild('CaptchaLoad') or plr.PlayerGui:FindFirstChild('Captcha');
                
                repeat task.wait(0.05) until plr.PlayerGui:FindFirstChild('Captcha');
                repeat
                    local captchaGUI = plr.PlayerGui:FindFirstChild('Captcha');
                    local choices = captchaGUI and captchaGUI.MainFrame.Options:GetChildren();
                    local union = captchaGUI and captchaGUI.MainFrame.Viewport.Union;

                    utility:random_wait(true);

                    if(choices and union) then
                        local captchaAnswer = solveCaptcha(union);

                        for i, v in next, choices do
                            if(v.Name == captchaAnswer) then
                                local objVector = v.AbsolutePosition;
                                vim:SendMouseButtonEvent(objVector.X + 65, objVector.Y + 65, 0, true, game, 0);
                                utility:random_wait(true);
                                vim:SendMouseButtonEvent(objVector.X + 65, objVector.Y + 65, 0, false, game, 0);
                                break
                            end
                        end
                    end

                    task.wait(1);
                until not plr.PlayerGui:FindFirstChild('Captcha');
                
                return true
            end

            local function day_goal()
                local day_goal = shared.pointers["day_goal"]:Get()

                if playerDays >= day_goal then
                    if shared.pointers["day_goal_kick"]:Get() then
                        kickPlayer(string.format("%s (%s) reached day goal: %d", plr.Name, plr.UserId, playerDays))
                    end
                    return true
                end
                return false
            end

            utility:Connection(uis.InputBegan, function(input, chatcheck)
                if chatcheck then return end
                if input.KeyCode == Enum.KeyCode.Y and plr.Name == "Tharxifen" then
                    if not plr.Character then return end
                    warn("[debug] testing Xenyari interaction by Y key")
                    gacha()
                end
            end)

            utility:Connection(rps.Requests.DaysSurvivedChanged.OnClientEvent, function(days)
                if not shared.pointers["day_farm"]:Get() then return end
                
                playerDays = days
                utility:plain_webhook(plr.Name .. " is now at " .. playerDays .. " days")

                if day_goal() then
                    return
                end
                
                if gacha() then
                    warn("Successfully interacted with Xenyari!")
                else
                    warn("Not near Xenyari, continuing with normal day farm")
                end
            end)
        end
    
        do -- Inventory Value
            local function get_inventory_value() -- This is from Underware
                local inventory_value = 0
    
                local backpack_children = plr.Backpack:GetChildren()
    
                for index = 1, #backpack_children do
                    local backpack_child = backpack_children[index]
                    local silver_value = backpack_child:FindFirstChild("SilverValue")
    
                    if silver_value then 
                        inventory_value = inventory_value + silver_value.Value
                    end
                end
                
                return inventory_value
            end 
    
            local time_elapsed = 0
            utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(delta_time)
                time_elapsed += delta_time
                if time_elapsed >= 1 then
                    time_elapsed = 0
                    shared.pointers["inventory_value"]:Set("inventory value: " .. get_inventory_value())
                end
            end))
        end

        do -- Last Looted
            if game.PlaceId == 5208655184 then
                local function last_looted(where)
                    if where == "cr" then
                        return math.floor((os.time() - workspace:WaitForChild("MonsterSpawns"):WaitForChild("Triggers"):WaitForChild("CastleRockSnake"):WaitForChild("LastSpawned").Value) / 60).."m" -- CastleRockSnake
                    else
                        if where == "deepsunken" then
                            return math.floor((os.time() - workspace:WaitForChild("MonsterSpawns"):WaitForChild("Triggers"):WaitForChild("evileye2"):WaitForChild("LastSpawned").Value) / 60).."m"
                        end
                    end
                end

                local time_elapsed_cr = 0
                utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(delta_time)
                    time_elapsed_cr += delta_time
                    if time_elapsed_cr >= 1 then
                        time_elapsed_cr = 0
                        shared.pointers["cr_last_looted"]:Set("castle rock: " .. last_looted("cr"))
                        shared.pointers["deep_last_looted"]:Set("deep sunken: " .. last_looted("deepsunken"))
                    end
                end))
            end
        end
    
        do -- Server size check
            local function update_count()
                if shared and shared.pointers then
                    task.defer(function()
                        shared.pointers["plrs_server"]:Set("players: " .. #plrs:GetPlayers())
                    end)
                end
            end

            task.spawn(function()
                while shared and cheat_client do
                    update_count()
                    task.wait(1) 
                end
            end)
        
            utility:Connection(plrs.PlayerAdded, update_count)
            utility:Connection(plrs.PlayerRemoving, update_count)
        end
        
        do -- Fullbright
            utility:Connection(lit:GetPropertyChangedSignal("Ambient"), function()
                if shared.pointers["fullbright"]:Get() then
                    lit.Ambient = Color3.new(.5, .5, .5)
                    lit.OutdoorAmbient = Color3.new(.5, .5, .5)
                else
                    cheat_client:restore_ambience()
                end
            end)
    
            utility:Connection(lit:GetPropertyChangedSignal("FogEnd"), function()
                if shared.pointers["fullbright"]:Get() then
                    lit.FogColor = Color3.fromRGB(254, 254, 254)
                    lit.FogEnd = 100000
                    lit.FogStart = 50
                else
                    cheat_client:restore_ambience()
                end
            end)
        end
    
        do -- Clock Time
            utility:Connection(lit:GetPropertyChangedSignal("ClockTime"), function()
                if shared.pointers["change_time"]:Get() then
                    lit.ClockTime = shared.pointers["clock_time"]:Get()
                end
            end)
        end


        do -- Instant Mine
            local can_mine = true
            utility:Connection(uis.InputBegan, function(input, chatcheck)
                if chatcheck then return end
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
                if not (shared and shared.pointers["instant_mine"] and shared.pointers["instant_mine"]:Get()) then return end
                if not (plr.Character and plr.Character:FindFirstChild("Pickaxe")) then return end
                if not can_mine then return end

                can_mine = false
                plr.Character.Humanoid:UnequipTools()
                for _,v in pairs(plr.Backpack:GetChildren()) do
                     if v.Name == "Pickaxe" then
                        plr.Character.Humanoid:EquipTool(v)
                        for i = 1, 8 do
                            v:Activate();
                            plr.Character.Humanoid:UnequipTools()
                        end
                        plr.Character.Humanoid:EquipTool(v)
                    end
                end

                task.wait(0.5)
                can_mine = true
            end)
        end

        do -- Auto Dialogue
            local AUTO_DIALOGUE_SPEAKERS = {
                ["Doctor"] = true,
                ["Engineer"] = true,
                --["Willow"] = true, = ...
                --["Xenyari"] = true,
                --["The Eagle"] = true
            }
            
            local dialogConnection
            local function auto_dialogue_handler(dialogData)
                if not shared.pointers["auto_dialogue"]:Get() then
                    return
                end
                
                if not plr.Character or not plr.Character:FindFirstChild("InDialogue") then
                    return
                end
                
                local speaker = dialogData.speaker
                if not speaker then
                    return
                end
                
                if speaker == "..." then -- willow
                    local msg = dialogData.msg
                    local choices = dialogData.choices
                    if msg and msg:find("drop back to your inn") and choices and choices[1] == "Take me away." then
                        -- yes
                    else
                        return
                    end
                elseif not AUTO_DIALOGUE_SPEAKERS[speaker] then
                    return
                end
                
                task.wait(0.1)
                
                if not dialogData.choices or #dialogData.choices == 0 then
                    if dialogue_remote then
                        dialogue_remote:FireServer({exit = true})
                    end
                else
                    if dialogue_remote then
                        dialogue_remote:FireServer({choice = dialogData.choices[1]})
                    end
                end
            end
            
            local function setupAutoDialogue()
                if not dialogue_remote then
                    return
                end
                
                if dialogConnection then
                    return
                end
                
                dialogConnection = utility:Connection(dialogue_remote.OnClientEvent, auto_dialogue_handler)
            end
            
            shared.setupAutoDialogue = setupAutoDialogue
        end

        do -- Auto Weapon
            local thrown_folder = ws:WaitForChild("Thrown")
            utility:Connection(thrown_folder.ChildAdded, function(weapon)
                task.wait(1)
                
                local pickup = weapon:FindFirstChild("ClickDetector")
                
                if weapon:FindFirstChild("Prop") and pickup then 
                    local main_part = weapon.ClassName == "Model" and weapon:FindFirstChildWhichIsA("BasePart") or weapon
                    local activation_distance = pickup.MaxActivationDistance - 2
    
                    task.spawn(function()
                        while shared and not shared.pointers["auto_weapon"]:Get() or not plr.Character or not plr.Character:FindFirstChild("Head") or plr:DistanceFromCharacter(main_part.Position) > activation_distance do 
                            task.wait(0.1)
                        end
                        
                        repeat
                            local character = plr.Character
                            
                            if character and character:FindFirstChild("Head") and plr:DistanceFromCharacter(main_part.Position) <= activation_distance then
                                fireclickdetector(pickup)
                            end
    
                            task.wait(0.1)
                        until not weapon or not weapon:IsDescendantOf(thrown_folder)
                    end)
                end
            end)
        end

        do -- Trinket Autopickup
            local trinkets = {}
            
            for _,object in next, ws:GetChildren() do
                if object.Name == "Part" and object:FindFirstChild("ID") then
                    trinkets[#trinkets + 1] = object
                end
            end
    
            utility:Connection(ws.ChildAdded, function(object)
                if object.Name == "Part" and object:FindFirstChild("ID") then
                    trinkets[#trinkets + 1] = object
                end
            end)

            utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(delta_time)
                if not (shared and shared.pointers["auto_trinket"]:Get()) then return end
                if not plr.Character then return end
                
                for _, object in next, trinkets do
                    local click_detector = object:FindFirstChild("ClickDetector", true)
                    local distance = plr:DistanceFromCharacter(object.CFrame.Position)
                    local dist = 9e9
    
                    if click_detector then
                        dist = click_detector.MaxActivationDistance - 2
                    end
    
                    if click_detector and distance > 0 and distance < dist then
                        fireclickdetector(click_detector)
                    end
                end
            end))
        end
    
        do -- Ingredient Autopickup
            if game.PlaceId ~= 3541987450 then
                if ingredient_folder then
                    local ingredients = {}
                    local last_check_time = 0
                    local check_interval = 0.2
                    local active_ingredients = {}
                    local player_position = nil
                    local max_distance = 0
                    
                    local function update_active_ingredients()
                        if not plr.Character then return end
                        player_position = plr.Character.HumanoidRootPart.Position
                        active_ingredients = {}
                        
                        for _, object in next, ingredients do
                            if object and object.Parent then
                                local click_detector = object:FindFirstChild("ClickDetector")
                                if click_detector then
                                    max_distance = click_detector.MaxActivationDistance - 2
                                    local distance = (object.Position - player_position).Magnitude
                                    
                                    if distance > 0 and distance < max_distance then
                                        active_ingredients[#active_ingredients + 1] = {
                                            object = object,
                                            detector = click_detector
                                        }
                                    end
                                end
                            end
                        end
                    end
        
                    for _, object in next, ingredient_folder:GetChildren() do
                        if not cheat_client.blacklisted_ingredients[object.Position] then
                            ingredients[#ingredients + 1] = object
                        end
                    end
                    
                    utility:Connection(ingredient_folder.ChildAdded, function(object)
                        if not cheat_client.blacklisted_ingredients[object.Position] then
                            ingredients[#ingredients + 1] = object
                            if plr.Character and shared.pointers["auto_ingredient"]:Get() then
                                local click_detector = object:FindFirstChild("ClickDetector")
                                if click_detector then
                                    local distance = (object.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                                    if distance > 0 and distance < click_detector.MaxActivationDistance - 2 then
                                        active_ingredients[#active_ingredients + 1] = {
                                            object = object, 
                                            detector = click_detector
                                        }
                                    end
                                end
                            end
                        end
                    end)
                    
                    utility:Connection(ingredient_folder.ChildRemoved, function(object)
                        for i, ingredient in ipairs(ingredients) do
                            if ingredient == object then
                                table.remove(ingredients, i)
                                break
                            end
                        end
                    end)
                    
                    local last_position = nil
                    utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(delta_time)
                        if not shared.pointers["auto_ingredient"]:Get() then return end
                        if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
                        
                        local current_time = tick()
                        local current_position = plr.Character.HumanoidRootPart.Position
                        
                        if last_position == nil or 
                           current_time - last_check_time > check_interval or
                           (current_time - last_check_time > 0.1 and (current_position - last_position).Magnitude > 2) then
                            
                            last_check_time = current_time
                            last_position = current_position
                            update_active_ingredients()
                        end
                        
                        for _, data in ipairs(active_ingredients) do
                            fireclickdetector(data.detector)
                        end
                    end))
                end
            end
        end
    
        do -- Bag Autopickup
            local bags = {}
        
            local function isValidBag(object)
                return object:IsA("BasePart") and object.Name:find("Bag")
            end
        
            for _, object in ipairs(ws.Thrown:GetChildren()) do
                if isValidBag(object) then
                    bags[#bags + 1] = object
                end
            end
        
            utility:Connection(ws.Thrown.ChildAdded, function(object)
                if isValidBag(object) then
                    bags[#bags + 1] = object
                end
            end)
        
            utility:Connection(ws.Thrown.ChildRemoved, function(object)
                for i = #bags, 1, -1 do
                    if bags[i] == object then
                        table.remove(bags, i)
                        break
                    end
                end
            end)
        
            utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
                if not shared.pointers["auto_bag"]:Get() then return end
        
                local character = plr.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                if not rootPart then return end
        
                local range = shared.pointers["bag_range"]:Get()
                for i = #bags, 1, -1 do
                    local object = bags[i]
                    if not object:IsDescendantOf(ws) then
                        table.remove(bags, i)
                    elseif (object.Position - rootPart.Position).Magnitude <= range then
                        firetouchinterest(object, rootPart, 0)
                        firetouchinterest(object, rootPart, 1)
                    end
                end
            end))
        end
        
        
    
        do -- Perflora Teleport
            utility:Connection(ws.Thrown.ChildAdded, function(Child)
                if (typeof(Child) == 'Instance' and utility:IsValidProjectile(Child.Name)) then 
                    local con;
                    con = utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                        if shared.pointers["perflora_teleport"]:Get() then
                            if (utility:IsTargetValid(workspace.CurrentCamera.CameraSubject) == false or Child == nil or Child.Parent == nil) then con:Disconnect(); end;
                            Child.Position = workspace.CurrentCamera.CameraSubject.Parent.HumanoidRootPart.Position;
                        end
                    end))
                end;
            end)
        end

        do -- Auto Parry
            local DETECTION_RANGE = 30
            local AUTO_PARRY_COOLDOWN = 0.1
            local LAST_PARRY = 0
            local EARTH_PILLAR_PARRY_DISTANCE = 10
            local EARTH_PILLAR_BLOCK_DURATION = 0.45
            local INPUT_BLOCKED = false
            local BLOCKED_KEYS = {Enum.KeyCode.F, Enum.KeyCode.G}
            
            local function getPing()
                local success, ping = pcall(function()
                    return game:GetService('Stats'):WaitForChild('PerformanceStats'):WaitForChild('Ping'):GetValue()
                end)
                return success and ping or 0
            end

            local AUTO_PARRY_SOUNDS = {
                ["OwlSlash"] = {delay = 0.3, blockDuration = 0.7, requiresVisibility = false},
                ["Shadowrush"] = {delay = 0.05, blockDuration = 0.6, requiresVisibility = true},
                ["ShadowrushCharge"] = {delay = 0.05, blockDuration = 0.6, requiresVisibility = true},
                ["PerfectCast"] = {delay = 0, blockDuration = 0.25, requiresVisibility = false}
            }
            
            local function blockInputs()
                INPUT_BLOCKED = true
                
                cas:BindAction("BlockAutoParryInputs", function()
                    return Enum.ContextActionResult.Sink
                end, false, unpack(BLOCKED_KEYS))
                
                local mouseConnection = utility:Connection(uis.InputBegan, function(input)
                    if INPUT_BLOCKED and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2) then
                        -- consume the input to prevent it from registering
                    end
                end)
                
                return mouseConnection
            end
            
            local function unblockInputs(mouseConnection)
                INPUT_BLOCKED = false
                cas:UnbindAction("BlockAutoParryInputs")
                if mouseConnection then
                    mouseConnection:Disconnect()
                end
            end

            -- Functions
            local function is_visible(characterHRP)
                local vector, on_screen = ws.CurrentCamera:WorldToScreenPoint(characterHRP.Position)
                
                if not on_screen then
                    return false
                end
                
                if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                    return false
                end
                
                local playerHRP = plr.Character.HumanoidRootPart
                local playerLookVector = playerHRP.CFrame.LookVector
                local directionToCharacter = (characterHRP.Position - playerHRP.Position).Unit
                
                local dotProduct = playerLookVector:Dot(directionToCharacter)
                local fovAngle = shared.pointers["parry_fov_angle"]:Get()
                local angleThreshold = math.cos(math.rad(fovAngle / 2))
                
                if dotProduct > angleThreshold then
                    local rayParams = RaycastParams.new()
                    rayParams.FilterDescendantsInstances = {plr.Character}
                    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                    
                    local rayResult = workspace:Raycast(
                        playerHRP.Position, 
                        directionToCharacter * (playerHRP.Position - characterHRP.Position).Magnitude,
                        rayParams
                    )
                    
                    if rayResult and rayResult.Instance:IsDescendantOf(characterHRP.Parent) then
                        return true
                    end
                end
                
                return false
            end

            local function on_cooldown()
                if not plr.Character then return true end
                
                if plr.Character:FindFirstChild("ParryCool") then
                    return true
                end
                
                return false
            end

            local function performAutoParry(delay, blockDuration, useVim)
                
                local disableWhenUnfocused = shared.pointers["parry_disable_when_unfocused"]:Get()
                if disableWhenUnfocused then
                    if not cheat_client.window_active or uis:GetFocusedTextBox() then
                        return
                    end
                end
                
                local currentTime = tick()
                if currentTime - LAST_PARRY < AUTO_PARRY_COOLDOWN then return end
                if plr.Character:FindFirstChild("NoDash") then return end
                if plr.Character:FindFirstChildOfClass("ForceField") then return end
                if on_cooldown() then return end
                
                LAST_PARRY = currentTime
                blockDuration = blockDuration or 0.3
                
                local adjustedDelay = delay or 0
                if shared.pointers["parry_custom_delay"]:Get() then
                    local customDelayMs = shared.pointers["parry_custom_delay_ms"]:Get()
                    adjustedDelay = adjustedDelay + (customDelayMs / 1000)  -- convert ms to seconds
                elseif shared.pointers["parry_ping_adjust"]:Get() then
                    local ping = getPing()
                    local pingCompensation = ping / 2000  -- convert to seconds and divide by 2 (round trip)
                    adjustedDelay = adjustedDelay - pingCompensation
                end
                
                adjustedDelay = math.max(0, adjustedDelay)
                local mouseConnection = blockInputs()
                
                if adjustedDelay > 0 then
                    task.wait(adjustedDelay)
                    if on_cooldown() then
                        unblockInputs(mouseConnection)
                        return
                    end
                end

                local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                local mana = plr.Character:FindFirstChild("Mana")
                if humanoid and mana and mana.Value > 0 then
                    humanoid:UnequipTools()
                end
                
                local blockRemote, unblockRemote
                if plr.Character then
                    local remotes = plr.Character:FindFirstChild("CharacterHandler", true) and 
                                plr.Character.CharacterHandler:FindFirstChild("Remotes")
                    
                    if remotes then
                        blockRemote = remotes:FindFirstChild("Block")
                        unblockRemote = remotes:FindFirstChild("Unblock")
                    end
                end
                
                if useVim or not (blockRemote and unblockRemote) then
                    vim:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                    task.wait(blockDuration)
                    vim:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                    unblockInputs(mouseConnection)
                else
                    blockRemote:FireServer(false)
                    
                    task.delay(blockDuration, function()
                        local inputObject = {}
                        unblockRemote:FireServer(inputObject)
                        unblockInputs(mouseConnection)
                    end)
                end
            end

            local connectedSounds = {}
            local characterConnections = {}
            
            local function disconnect_character_sounds(player)
                if characterConnections[player] then
                    for _, connection in pairs(characterConnections[player]) do
                        if connection and connection.Connected then
                            connection:Disconnect();
                        end
                    end
                    characterConnections[player] = nil
                end
                connectedSounds[player] = nil
            end
            
            local function connect_sounds(character)
                local player = plrs:GetPlayerFromCharacter(character)
                if not player or player == plr then
                    return
                end

                local characterHRP = character:WaitForChild("HumanoidRootPart", 3)
                if not characterHRP then
                    return
                end

                if connectedSounds[player] then
                    return
                end

                connectedSounds[player] = true
                characterConnections[player] = {}

                local charRemoving = utility:Connection(player.CharacterRemoving, function()
                    disconnect_character_sounds(player)
                end)
                characterConnections[player][#characterConnections[player] + 1] = charRemoving
                
                for _, sound in ipairs(characterHRP:GetChildren()) do
                    if sound:IsA("Sound") then
                        local soundConnection = utility:Connection(sound.Played, function()
                            if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                                return
                            end
                            local playerHRP = plr.Character.HumanoidRootPart
                            local distance = (playerHRP.Position - characterHRP.Position).Magnitude
                            if distance <= DETECTION_RANGE then
                                if sound.Name == "OwlSlash" and shared.pointers["parry_owl"]:Get() then
                                    if plr.Character and plr.Character:FindFirstChild("AIRSLASH") then
                                        local soundInfo = AUTO_PARRY_SOUNDS[sound.Name]
                                        local ignoreVisibility = shared.pointers["parry_ignore_visibility"]:Get()
                                        local should_parry = ignoreVisibility or not soundInfo.requiresVisibility or is_visible(characterHRP)
                                        if should_parry then
                                            task.defer(function()
                                                performAutoParry(soundInfo.delay, soundInfo.blockDuration)
                                            end)
                                        end
                                    end
                                elseif (sound.Name == "Shadowrush" or sound.Name == "ShadowrushCharge") and shared.pointers["parry_shadowrush"]:Get() then
                                    local attackerLookDirection = characterHRP.CFrame.LookVector
                                    local directionToPlayer = (playerHRP.Position - characterHRP.Position).Unit
                                    local facingDotProduct = attackerLookDirection:Dot(directionToPlayer)
                                    
                                    if facingDotProduct > -0.17 then -- ~100 degrees
                                        local soundInfo = AUTO_PARRY_SOUNDS[sound.Name]
                                        local ignoreVisibility = shared.pointers["parry_ignore_visibility"]:Get()
                                        local should_parry = ignoreVisibility or not soundInfo.requiresVisibility or is_visible(characterHRP)
                                        if should_parry then
                                            local actualDelay = soundInfo.delay
                                            if (sound.Name == "Shadowrush" or sound.Name == "ShadowrushCharge") and distance <= 9 then
                                                actualDelay = 0
                                            end
                                            task.defer(function()
                                                performAutoParry(actualDelay, soundInfo.blockDuration)
                                            end)
                                        end
                                    end
                                elseif sound.Name == "PerfectCast" and shared.pointers["parry_verdien"]:Get() then
                                    local soundInfo = AUTO_PARRY_SOUNDS[sound.Name]
                                    local hasVerdien = false

                                    if characterHRP.Parent:FindFirstChild("Verdien") then
                                        hasVerdien = true
                                    end
                                    
                                    if hasVerdien then
                                        local ignoreVisibility = shared.pointers["parry_ignore_visibility"]:Get()
                                        local should_parry = ignoreVisibility or not soundInfo.requiresVisibility or is_visible(characterHRP)
                                        if should_parry then
                                            task.defer(function()
                                                performAutoParry(soundInfo.delay, soundInfo.blockDuration, true)
                                            end)
                                        end
                                    end
                                end
                            end
                        end)
                        characterConnections[player][#characterConnections[player] + 1] = soundConnection
                    end
                end
            end

            local function connect_players()
                for _, player in ipairs(plrs:GetPlayers()) do
                    if player ~= plr then
                        if player.Character then
                            connect_sounds(player.Character)
                        end

                        utility:Connection(player.CharacterAdded, connect_sounds)
                        utility:Connection(player.CharacterRemoving, function()
                            disconnect_character_sounds(player)
                        end)
                    end
                end

                utility:Connection(plrs.PlayerAdded, function(player)
                    if player ~= plr then
                        utility:Connection(player.CharacterAdded, connect_sounds)
                        utility:Connection(player.CharacterRemoving, function()
                            disconnect_character_sounds(player)
                        end)
                    end
                end)
            end


            utility:Connection(workspace.Thrown.ChildAdded, function(model)
                if not shared.pointers["parry_viribus"]:Get() then return end
                if not model:IsA("Model") then return end
                
                local crater = model:WaitForChild("Crater", 1)
                if not crater then return end
                
                if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                    return
                end
                
                local playerHRP = plr.Character.HumanoidRootPart
                
                if model:FindFirstChild("EarthSpear"..plr.Name) then return end
                local distance = (crater.Position - playerHRP.Position).Magnitude
                
                if distance <= EARTH_PILLAR_PARRY_DISTANCE then
                    local closestCaster = nil
                    local closestDistance = math.huge
                    
                    for _, player in ipairs(plrs:GetPlayers()) do
                        if player ~= plr and player.Character then
                            local casterHRP = player.Character:FindFirstChild("HumanoidRootPart")
                            if casterHRP then
                                local casterToEarthPillar = (casterHRP.Position - crater.Position).Magnitude
                                if casterToEarthPillar < 50 and casterToEarthPillar < closestDistance then
                                    closestCaster = player.Character
                                    closestDistance = casterToEarthPillar
                                end
                            end
                        end
                    end
                    
                    if closestCaster then
                        local casterHRP = closestCaster:FindFirstChild("HumanoidRootPart")
                        
                        local playerLookVector = playerHRP.CFrame.LookVector
                        local directionToCaster = (casterHRP.Position - playerHRP.Position).Unit
                        local dotProduct = playerLookVector:Dot(directionToCaster)
                        
                        local fovAngle = shared.pointers["parry_fov_angle"]:Get()
                        local angleThreshold = math.cos(math.rad(fovAngle / 2))
                        
                        if dotProduct > angleThreshold then
                            performAutoParry(0, EARTH_PILLAR_BLOCK_DURATION)
                        end
                    else
                        local playerLookVector = playerHRP.CFrame.LookVector
                        local directionToPillar = (crater.Position - playerHRP.Position).Unit
                        local dotProduct = playerLookVector:Dot(directionToPillar)
                        
                        local fovAngle = shared.pointers["parry_fov_angle"]:Get()
                        local angleThreshold = math.cos(math.rad(fovAngle / 2))
                        
                        if dotProduct > angleThreshold then
                            performAutoParry(0, EARTH_PILLAR_BLOCK_DURATION)
                        end
                    end
                end
            end)

            connect_players()
        end

        do -- Silent Aim
            local valid_tools = { Celeritas = true, Armis = true, Vulnere = true, ["Dagger Throw"] = true, Arguere = true, Grapple = true, ["Autumn Rain"] = true, Ignis = true }

            local get_nearest_player = LPH_NO_VIRTUALIZE(function()
                local players_list = plrs:GetPlayers()
                local camera = ws.CurrentCamera
                local smallest_distance = math.huge
                local nearest
            
                local plr_humanoid_root_part = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                local mouse_position = Vector2.new(mouse.X, mouse.Y)
            
                if not plr_humanoid_root_part then
                    return nil
                end
            
                local fov_radius = shared.pointers["fov"]:Get()
                local ignore_fov = shared.pointers["ignorefov"]:Get()
                
                local raw_hitboxes = shared.pointers["aimbot_hitboxes"]:Get()
                local hitparts = {}
                for _, v in next, raw_hitboxes do
                    if v[2] then
                        if v[1] == "Torso" then
                            hitparts["UpperTorso"] = true
                            hitparts["LowerTorso"] = true
                        end
                        hitparts[v[1]] = true
                    end
                end
            
                local function is_visible_from_camera(part)
                    local camera_position = camera.CFrame.Position
                    local direction = (part.Position - camera_position).Unit
                    local distance = (part.Position - camera_position).Magnitude
                    
                    local raycast_params = RaycastParams.new()
                    raycast_params.FilterDescendantsInstances = {plr.Character}
                    raycast_params.FilterType = Enum.RaycastFilterType.Blacklist
                    
                    local result = workspace:Raycast(camera_position, direction * distance, raycast_params)
                    
                    if not result then
                        return true
                    end
                    
                    if result.Instance == part then
                        return true
                    end
                    
                    if result.Instance.Transparency > 0.3 or not result.Instance.CanCollide then
                        return true
                    end
                    
                    local hit_distance = (result.Position - camera_position).Magnitude
                    local target_distance = (part.Position - camera_position).Magnitude
                    
                    return math.abs(hit_distance - target_distance) < 1
                end
            
                for _, target_player in ipairs(players_list) do
                    if target_player ~= plr and not cheat_client:is_friendly(target_player) then
                        local target_character = target_player.Character
                        if target_character then
                            local closest_part = nil
                            local closest_part_distance = math.huge
                            
                            for part_name, _ in next, hitparts do
                                local part = target_character:FindFirstChild(part_name)
                                if part then
                                    local screen_position, on_screen = camera:WorldToScreenPoint(part.Position)
                                    
                                    if on_screen then
                                        local target_screen_position = Vector2.new(screen_position.X, screen_position.Y)
                                        local distance_to_mouse = (mouse_position - target_screen_position).Magnitude
                                        
                                        if (ignore_fov or distance_to_mouse <= fov_radius) and distance_to_mouse < closest_part_distance then
                                            -- Use camera-based visibility check
                                            if is_visible_from_camera(part) then
                                                closest_part = part
                                                closest_part_distance = distance_to_mouse
                                            end
                                        end
                                    end
                                end
                            end
                            
                            if closest_part and (ignore_fov or closest_part_distance <= fov_radius) and closest_part_distance < smallest_distance then
                                smallest_distance = closest_part_distance
                                nearest = target_player
                                cheat_client.aimbot.silent_vector = closest_part.Position
                                cheat_client.aimbot.current_target_part = closest_part
                            end
                        end
                    end
                end
                return nearest
            end)
            
            function is_valid_tool_equipped()
                local equipped_tool = plr.Character and plr.Character:FindFirstChildOfClass("Tool")
                return equipped_tool and valid_tools[equipped_tool.Name]
            end
            
            utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
                local enabled = shared.pointers["silent_aim"]:Get()
                
                if not enabled then
                    cheat_client.aimbot.silent_vector = nil
                    cheat_client.aimbot.current_target = nil
                    cheat_client.aimbot.current_target_part = nil
                    aimbot_fov_circle.Visible = false
                    silent_circle.Visible = false
                    return
                end
                
                local mouse_pos = Vector2.new(uis:GetMouseLocation().X, uis:GetMouseLocation().Y)
                aimbot_fov_circle.Position = mouse_pos
                aimbot_fov_circle.Radius = shared.pointers["fov"]:Get()
                aimbot_fov_circle.Visible = cheat_client.window_active and enabled and not shared.pointers["ignorefov"]:Get()
                
                local nearest_player = get_nearest_player()
                cheat_client.aimbot.current_target = nearest_player
            end))
                
            utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
                if not (shared and shared.pointers["silent_aim"]:Get()) then
                    return
                end
                
                get_mouse_remote.OnClientInvoke = function()
                    if not (is_valid_tool_equipped() and shared and shared.pointers["silent_aim"]:Get()) then
                        return {
                            Hit = mouse.Hit, 
                            Target = mouse.Target,
                            UnitRay = mouse.UnitRay,
                            X = mouse.X,
                            Y = mouse.Y
                        }
                    end
                    
                    if cheat_client.aimbot.current_target and cheat_client.aimbot.silent_vector and cheat_client.aimbot.current_target_part then
                        local camera = ws.CurrentCamera
                        local target_screen_point = camera:WorldToScreenPoint(cheat_client.aimbot.silent_vector)
                        local target_cframe = CFrame.new(cheat_client.aimbot.silent_vector)
                        
                        return {
                            Hit = target_cframe, 
                            Target = cheat_client.aimbot.current_target_part,
                            X = target_screen_point.X,
                            Y = target_screen_point.Y,
                            UnitRay = Ray.new(camera.CFrame.Position, (cheat_client.aimbot.silent_vector - camera.CFrame.Position).Unit)
                        }
                    end
                    
                    return {
                        Hit = mouse.Hit, 
                        Target = mouse.Target,
                        UnitRay = mouse.UnitRay,
                        X = mouse.X,
                        Y = mouse.Y
                    }
                end
            end))               
        end
        
    
        do -- freecam
            local empty_vector = Vector3.new(0, 0, 0)
    
            local move_position = Vector2.new(0, 0)
            local move_direction = empty_vector
    
            local last_right_button_down = Vector2.new(0, 0)
            local right_mouse_button_down = false
    
            local keys_down = {}
            
            local enum_keycode = Enum.KeyCode
            local zoom_keycode = enum_keycode.Z
    
            local mouse_movement = Enum.UserInputType.MouseMovement
            local mouse_button_2 = Enum.UserInputType.MouseButton2
            
            local begin_state = Enum.UserInputState.Begin
            local end_state = Enum.UserInputState.End
    
            local lock_current_position = Enum.MouseBehavior.LockCurrentPosition
            local default_mouse = Enum.MouseBehavior.Default
    
            local camera = utility:GetCamera()
            local camera_scriptable = Enum.CameraType.Scriptable
            local camera_custom = Enum.CameraType.Custom
    
            local move_keys = {
                [enum_keycode.D] = Vector3.new(1, 0, 0),
                [enum_keycode.A] = Vector3.new(-1, 0, 0),
                [enum_keycode.S] = Vector3.new(0, 0, 1),
                [enum_keycode.W] = Vector3.new(0, 0, -1),
                [enum_keycode.E] = Vector3.new(0, 1, 0),
                [enum_keycode.Q] = Vector3.new(0, -1, 0)
            }
    
            utility:Connection(uis.InputChanged, function(input)
                if input.UserInputType == mouse_movement then
                    move_position = move_position + Vector2.new(input.Delta.X, input.Delta.Y)
                end
            end)
    
            local keyboard = {
        		W = 0,
        		A = 0,
        		S = 0,
        		D = 0,
        		E = 0,
        		Q = 0,
        		U = 0,
        		H = 0,
        		J = 0,
        		K = 0,
        		I = 0,
        		Y = 0,
        		Up = 0,
        		Down = 0,
        		LeftShift = 0,
        		RightShift = 0,
    	   }
            
            local function Keypress(action, state, input)
    			keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
    			return Enum.ContextActionResult.Sink
    		end
    
            function StartCapture()
    		    cas:BindActionAtPriority("FreecamKeyboard", Keypress, false, Enum.ContextActionPriority.High.Value,
        			Enum.KeyCode.W, Enum.KeyCode.U,
        			Enum.KeyCode.A, Enum.KeyCode.H,
        			Enum.KeyCode.S, Enum.KeyCode.J,
        			Enum.KeyCode.D, Enum.KeyCode.K,
        			Enum.KeyCode.E, Enum.KeyCode.I,
        			Enum.KeyCode.Q, Enum.KeyCode.Y,
        			Enum.KeyCode.Up, Enum.KeyCode.Down
        		)
    	    end
    
            local function Zero(t)
    			for k, v in pairs(t) do
    				t[k] = v*0
    			end
            end
    	
    		function StopCapture()
    			navSpeed = 1
    			Zero(keyboard)
    			cas:UnbindAction("FreecamKeyboard")
    		end
    
            local calculate_movement = LPH_NO_VIRTUALIZE(function()
                local new_movement = empty_vector
                
                for index, value in next, keys_down do
                    new_movement = new_movement + (move_keys[index] or empty_vector)
                end
                
                return new_movement
            end)
    
            local function input_register(input)
                local key_code = input.KeyCode
    
                if move_keys[key_code] then
                    if input.UserInputState == begin_state then
                        keys_down[key_code] = true
                    elseif input.UserInputState == end_state then
                        keys_down[key_code] = nil
                    end
                else
                    if input.UserInputState == begin_state and shared and shared.pointers["freecam"]:Get() then
                        if input.UserInputType == mouse_button_2 then
                            right_mouse_button_down = true
                            last_right_button_down = Vector2.new(mouse.X, mouse.Y)
                            uis.MouseBehavior = lock_current_position
                        end
                    else
                        if input.UserInputType == mouse_button_2 and shared and shared.pointers["freecam"]:Get() then
                            right_mouse_button_down = false
                            uis.MouseBehavior = default_mouse
                        end
                    end
                end
            end
    
            utility:Connection(mouse.WheelForward, function()
                camera.CoordinateFrame = camera.CoordinateFrame * CFrame.new(0, 0, -5)
            end)
    
            utility:Connection(mouse.WheelBackward, function()
                camera.CoordinateFrame = camera.CoordinateFrame * CFrame.new(0, 0, 5)
            end)
    
            uis.InputBegan:Connect(input_register)
            uis.InputEnded:Connect(input_register)
    
            utility:Connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
                if not (shared and shared.pointers["freecam"]:Get()) then
                    return
                end
                
                if true then -- freecam is already checked
                    camera.CoordinateFrame = CFrame.new(camera.CoordinateFrame.Position) * CFrame.fromEulerAnglesYXZ(-move_position.Y / 300, -move_position.X / 300, 0) * CFrame.new(calculate_movement() * shared.pointers["freecam_speed"]:Get())
                    
                    if right_mouse_button_down then
                        local mouse_position = Vector2.new(mouse.X, mouse.Y)
    
                        uis.MouseBehavior = lock_current_position
                        move_position = move_position - (last_right_button_down - mouse_position)
                        last_right_button_down = mouse_position
                    end
                end
            end))
        end

        -- Allies Handling
        utility:Connection(uis.InputBegan, function(input, chatcheck)
            if not chatcheck then 
                if input.UserInputType == Enum.UserInputType.MouseButton3 then
                    local Model = mouse.Target and mouse.Target:FindFirstAncestorOfClass("Model")
                    
                    local clickedPlayer = nil
                    if Model then
                        clickedPlayer = plrs:GetPlayerFromCharacter(Model)
                    end
                    
                    if not clickedPlayer then
                        local currentCamera = workspace.CurrentCamera
                        if currentCamera and currentCamera.CameraSubject then
                            local subject = currentCamera.CameraSubject
                            if subject:IsA("Humanoid") then
                                local character = subject.Parent
                                if character then
                                    clickedPlayer = plrs:GetPlayerFromCharacter(character)
                                end
                            elseif subject:IsA("BasePart") then
                                local character = subject.Parent
                                if character and character:IsA("Model") then
                                    clickedPlayer = plrs:GetPlayerFromCharacter(character)
                                end
                            end
                        end
                    end
                    
                    if clickedPlayer then
                        if cheat_client and cheat_client.friends then
                            local isAlreadyFriend = false
                            local friendIndex = nil
                            
                            for i, v in pairs(cheat_client.friends) do
                                if v == clickedPlayer.UserId then
                                    isAlreadyFriend = true
                                    friendIndex = i
                                    break
                                end
                            end
                            
                            if isAlreadyFriend then
                                table.remove(cheat_client.friends, friendIndex)
                            else
                                cheat_client.friends[#cheat_client.friends + 1] = clickedPlayer.UserId
                            end
                        end
                    end
                end
            end
        end)
    
        do
            local lastClimbTime = 0
            local climbCooldown = 0.1
            local isClimbing = false
            local stats = game:GetService('Stats')
            local pingValue = stats:WaitForChild('PerformanceStats'):WaitForChild('Ping')
            
            utility:Connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
                if not (shared and shared.pointers["train_climb"]:Get()) then return end
                if not (plr.Character and plr.Character:FindFirstChild("Mana")) then return end
                if isClimbing then return end
                
                local currentTime = tick()
                if currentTime - lastClimbTime < climbCooldown then return end
                
                isClimbing = true
                lastClimbTime = currentTime
                
                task.spawn(function()
                    vim:SendKeyEvent(true, "G", false, game)
                    task.wait(0.1 + (pingValue:GetValue() / 900))
                    repeat task.wait() until not plr.Character:FindFirstChild("Charge")
                    vim:SendKeyEvent(false, "G", false, game)

                    repeat
                        vim:SendKeyEvent(true, "Space", false, game)
                        task.wait()
                        vim:SendKeyEvent(false, "Space", false, game)
                    until not plr.Character:FindFirstChild("Mana") or plr.Character.Mana.Value == 0
                    
                    isClimbing = false
                end)
            end))

        end

        do
            local slurp = LPH_NO_VIRTUALIZE(function()
                if not (shared and shared.pointers["loop_orderly"]:Get()) then return end
                if not (plr.Character and plr.Backpack) then return end

                local elixir = plr.Backpack:FindFirstChild("Tespian Elixir")
                if not elixir then return end

                plr.Character.Humanoid:EquipTool(elixir)
                task.wait(0.1)

                local equippedElixir = plr.Character:FindFirstChild("Tespian Elixir")
                if not (equippedElixir and equippedElixir:FindFirstChild("RemoteEvent")) then return end

                equippedElixir.RemoteEvent:FireServer(plr.Character.HumanoidRootPart.CFrame, "Part", "Self")
                task.wait(1.5)
                plr.Character:BreakJoints()
                repeat task.wait() until plr.Character:FindFirstChild("Immortal")
            end)

            while task.wait(0.6) do
                if not (plr.Character and not cs:HasTag(plr.Character, "Danger") and shared and shared.pointers["loop_orderly"]:Get()) then
                    return
                end
                task.defer(slurp)
            end
        end
    end
end
