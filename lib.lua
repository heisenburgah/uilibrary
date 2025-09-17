-- hydroxide.solutions ui released woohooo

-- Services
local plrs = game:GetService("Players")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")

return function(shared, utility)
    if not shared or not utility then
        error("Library requires 'shared' and 'utility' dependencies to be passed")
    end
    
    local library = {}

    -- Library Functions
    function library:Window(windowProperties)
        -- // Variables
        local window = {
            current = nil,
            currentindex = 1,
            content = {},
            pages = {}
        }
        local windowProperties = windowProperties or {}
        --
        local windowName = windowProperties.name or windowProperties.Name or "New Window"
        -- // Functions
        function window:Movement(moveAction, moveDirection)
            if moveAction == "Movement" then
                window.content[window.currentindex]:Turn(false)
                --
                local function isSkippable(item)
                    if item and item.pointer and shared.blatant_features then
                        local blatant_mode_enabled = shared.pointers["blatant_mode"] and shared.pointers["blatant_mode"]:Get()
                        for _, feature in pairs(shared.blatant_features) do
                            if item.pointer == feature and not blatant_mode_enabled then
                                return true
                            end
                        end
                    end
                    return false
                end
                
                local startIndex = window.currentindex
                local attempts = 0
                repeat
                    if window.content[moveDirection == "Down" and window.currentindex + 1 or window.currentindex - 1] then
                        window.currentindex = moveDirection == "Down" and window.currentindex + 1 or window.currentindex - 1
                    else
                        window.currentindex = moveDirection == "Down" and 1 or #window.content
                    end
                    attempts = attempts + 1
                until not isSkippable(window.content[window.currentindex]) or attempts > #window.content or window.currentindex == startIndex
                --
                window.content[window.currentindex]:Turn(true)
            else
                window.content[window.currentindex]:Action(moveDirection)
            end
        end
        --
        function window:ChangeKeys(keyType, moveDirection, newKey)
            for i,v in pairs(shared.moveKeys[keyType]) do
                if tostring(v) == tostring(moveDirection) then
                    shared.moveKeys[keyType][i] = nil
                    shared.moveKeys[keyType][newKey] = moveDirection
                end
            end
        end
        -- // Main
        local windowFrame = utility:Create("Square", {
            Visible = true,
            Filled = true,
            Thickness = 0,
            Color = shared.theme.inline,
            Size = UDim2.new(0, 280, 0, 19),
            Position = UDim2.new(0, 50, 0, 80)
        }, "menu")
        --
        local windowInline = utility:Create("Square", {
            Parent = windowFrame,
            Visible = true,
            Filled = true,
            Thickness = 0,
            Color = shared.theme.dark,
            Size = UDim2.new(1, -2, 1, -4),
            Position = UDim2.new(0, 1, 0, 3)
        }, "menu")
        --
        local windowAccent = utility:Create("Square", {
            Parent = windowFrame,
            Visible = true,
            Filled = true,
            Thickness = 0,
            Color = "accent",
            Size = UDim2.new(1, 0, 0, 2),
            Position = UDim2.new(0, 0, 0, 0)
        }, "menu")
        --
        local windowText = utility:Create("Text", {
            Parent = windowAccent,
            Visible = true,
            Text = windowName,
            Center = true,
            Outline = true,
            Font = 2,
            Color = shared.theme.text,
            Size = 13,
            Position = UDim2.new(0.5, 0, 0, 3)
        }, "menu")
        
        -- // Connections
        utility:Connection(uis.InputBegan, function(Input)
            if shared.toggleKey[2] and Input.KeyCode then
                if shared.moveKeys["Movement"][Input.KeyCode.Name] then
                    window:Movement("Movement", shared.moveKeys["Movement"][Input.KeyCode.Name])
                elseif shared.moveKeys["Action"][Input.KeyCode.Name] then
                    window:Movement("Action", shared.moveKeys["Action"][Input.KeyCode.Name])
                end
            end
            
            if shared and shared.toggleKey and shared.toggleKey[1] and Input.KeyCode == shared.toggleKey[1] then
                utility:Toggle()
            elseif shared and shared.unloadKey and shared.unloadKey[1] and Input.KeyCode == shared.unloadKey[1] then
                utility:Unload()
            elseif shared and shared.saveKey and shared.saveKey[1] and Input.KeyCode == shared.saveKey[1] then
                utility:SaveConfig()
                return
            elseif shared and shared.loadKey and shared.loadKey[1] and Input.KeyCode == shared.loadKey[1] then
                utility:LoadConfig()
            end
        end)
        
        -- // Nested Functions
        function window:ChangeName(newName)
            windowText.Text = newName
        end
        --
        function window:Refresh()
            window.content = {}
            local contentCount = 0
            --
            for index, page in pairs(window.pages) do
                page:Position(19 + (contentCount * 17))
                window.content[#window.content + 1] = page
                contentCount = contentCount + 1
                --
                if page.open then
                    for index, section in pairs(page.sections) do
                        section:Position(19 + (contentCount * 17))
                        contentCount = contentCount + 1
                        --
                        for index, content in pairs(section.content) do
                            content:Position(19 + (contentCount * 17))
                            if not content.noaction then
                                window.content[#window.content + 1] = content
                            end
                            contentCount = contentCount + 1
                        end
                    end
                end
            end
            --
            utility:Update(windowFrame, "Size", UDim2.new(0, 280, 0, 23 + (contentCount * 17)))
            utility:Update(windowInline, "Size", UDim2.new(1, -2, 1, -4), windowFrame)
        end
        --
        function window:Page(pageProperties)
            -- // Variables
            local page = {open = false, sections = {}}
            local pageProperties = pageProperties or {}
            --
            local pageName = pageProperties.name or pageProperties.Name or "New Page"
            -- // Functions
            -- // Main
            local pageText = utility:Create("Text", {
                Parent = windowFrame,
                Visible = true,
                Text = "[+] "..pageName,
                Outline = true,
                Font = 2,
                Color = (#window.content == 0 and shared.theme.accent or shared.theme.text),
                Size = 13,
                Position = UDim2.new(0, 5, 0, 19 + ((#window.content) * 17))
            }, "menu")

            -- // Nested Functions
            function page:Turn(state)
                if state then
                    utility:Update(pageText, "Color", "accent")
                else
                    utility:Update(pageText, "Color", "text")
                end
            end
            --
            function page:Position(yAxis)
                utility:Update(page.text, "Position", UDim2.new(0, 5, 0, yAxis), windowFrame)
            end
            --
            function page:Open(state, externalOpen)
                if not externalOpen then
                    local ind = 0
                    for index, other_page in pairs(window.pages) do
                        if other_page == page then
                            ind = index
                        else
                            if other_page.open then
                                other_page:Open(false, true)
                            end
                        end
                    end
                    --
                    window.currentindex = ind
                end
                --
                page.open = state
                pageText.Text = (page.open and "[-] " or "[+] ") .. pageName
                --
                for index, section in pairs(page.sections) do
                    section:Open(page.open)
                end
                --
                window:Refresh()
            end
            --
            function page:Action(action)
                if action == "Enter" then
                    page:Open(not page.open)
                elseif action == "Right" and not page.open then
                    page:Open(true)
                elseif action == "Left" and page.open then
                    page:Open(false)
                end
            end
            --
            function page:Section(sectionProperties)
                -- // Variables
                local section = {content = {}}
                local sectionProperties = sectionProperties or {}
                --
                local sectionName = sectionProperties.name or sectionProperties.Name or "New Section"
                -- // Functions
                -- // Main
                local sectionText = utility:Create("Text", {
                    Visible = false,
                    Text = "["..sectionName.."]",
                    Outline = true,
                    Font = 2,
                    Color = shared.theme.section,
                    Size = 13
                }, "menu")
                -- // Nested Functions
                function section:Open(state)
                    section.text.Visible = state
                    --
                    for index, content in pairs(section.content) do
                        content:Open(state)
                    end
                end
                --
                function section:Position(yAxis)
                    utility:Update(section.text, "Position", UDim2.new(0, 22, 0, yAxis), windowFrame)
                end
                --
                function section:Label(labelProperties)
                    -- // Variables
                    local label = {noaction = true}
                    local labelProperties = labelProperties or {}
                    --
                    local labelName = labelProperties.name or labelProperties.Name or "New Label"
                    local labelPointer = labelProperties.pointer or labelProperties.Pointer or labelProperties.flag or labelProperties.Flag or nil
                    -- // Functions
                    -- // Main
                    local labelText = utility:Create("Text", {
                        Visible = false,
                        Text = labelName,
                        Outline = true,
                        Font = 2,
                        Color = shared.theme.text,
                        Size = 13
                    }, "menu")
                    -- // Nested Functions
                    function label:Turn(state)
                        if state then
                            utility:Update(label.text, "Color", "accent")
                        else
                            utility:Update(label.text, "Color", "text")
                        end
                    end
                    --
                    function label:Position(yAxis)
                        utility:Update(label.text, "Position", UDim2.new(0, 22, 0, yAxis), windowFrame)
                    end
                    --
                    function label:Open(state)
                        label.text.Visible = state
                    end
                    --
                    function label:Action(action)
                    end
                    -- // Returning + Other
                    label.name = labelName
                    label.text = labelText
                    --
                    section.content[#section.content + 1] = label
                    --
                    if labelPointer then
                        local pointer = {}
                        --
                        function pointer:Get()
                            return label.name
                        end
                        --
                        function pointer:Set(value)
                            if typeof(value) == "string" then
                                label.name = value
                                label.text.Text = value
                            end
                        end
                        --
                        shared.pointers[labelPointer] = pointer
                    end
                    return label
                end
                --
                function section:Button(buttonProperties)
                    -- // Variables
                    local button = {}
                    local buttonProperties = buttonProperties or {}
                    --
                    local buttonName = buttonProperties.name or buttonProperties.Name or "New Button"
                    local buttonConfirm = buttonProperties.confirm or buttonProperties.Confirm or false
                    local buttonCallback = buttonProperties.callback or buttonProperties.Callback or buttonProperties.CallBack or buttonProperties.callBack or function() end
                    -- // Functions
                    -- // Main
                    local buttonText = utility:Create("Text", {
                        Visible = false,
                        Text = buttonName,
                        Outline = true,
                        Font = 2,
                        Color = shared.theme.text,
                        Size = 13
                    }, "menu")
                    -- // Nested Functions
                    function button:Turn(state)
                        if state then
                            utility:Update(button.text, "Color", "accent")
                        else
                            utility:Update(button.text, "Color", "text")
                        end
                    end
                    --
                    function button:Position(yAxis)
                        utility:Update(button.text, "Position", UDim2.new(0, 22, 0, yAxis), windowFrame)
                    end
                    --
                    function button:Open(state)
                        button.text.Visible = state
                    end
                    --
                    function button:Action(action)
                        if buttonConfirm and button.text.Text ~= "confirm?" then
                            button.text.Text = "confirm?"
                            task.delay(3, function()
                                if button.text.Text == "confirm?" then
                                    button.text.Text = buttonName
                                end
                            end)
                            return
                        end
                        --
                        button.text.Text = "<"..buttonName..">"
                        --
                        buttonCallback()
                        --
                        wait(0.2)
                        button.text.Text = buttonName
                    end
                    -- // Returning + Other
                    button.name = buttonName
                    button.text = buttonText
                    --
                    section.content[#section.content + 1] = button
                    --
                    return button
                end
                --
                function section:Toggle(toggleProperties)
                    local toggle = {}
                    local toggleProperties = toggleProperties or {}
                    --
                    local toggleName = toggleProperties.name or toggleProperties.Name or "New Toggle"
                    local toggleDefault = toggleProperties.default or toggleProperties.Default or toggleProperties.def or toggleProperties.Def or false
                    local togglePointer = toggleProperties.pointer or toggleProperties.Pointer or toggleProperties.flag or toggleProperties.Flag or nil
                    local toggleCallback = toggleProperties.callback or toggleProperties.Callback or toggleProperties.CallBack or toggleProperties.callBack or function() end
                    -- // Functions
                    -- // Main
                    local is_blatant_feature = false
                    local blatant_mode_enabled = shared.pointers["blatant_mode"] and shared.pointers["blatant_mode"]:Get()
                    
                    for _, feature in pairs(shared.blatant_features) do
                        if togglePointer == feature then
                            is_blatant_feature = true
                            break
                        end
                    end
                    
                    local initial_color = shared.theme.text
                    if is_blatant_feature and not blatant_mode_enabled then
                        initial_color = Color3.fromRGB(255, 0, 0)
                    end
                    
                    local toggleText = utility:Create("Text", {
                        Visible = false,
                        Text = toggleName .. " -> " .. (toggleDefault and "ON" or "OFF"),
                        Outline = true,
                        Font = 2,
                        Color = initial_color,
                        Size = 13
                    }, "menu")
                    -- // Nested Functions
                    function toggle:Turn(state)
                        local is_blatant_feature = false
                        local blatant_mode_enabled = shared.pointers["blatant_mode"] and shared.pointers["blatant_mode"]:Get()
                        
                        for _, feature in pairs(shared.blatant_features) do
                            if togglePointer == feature then
                                is_blatant_feature = true
                                break
                            end
                        end
                        
                        if is_blatant_feature and not blatant_mode_enabled then
                            utility:Update(toggle.text, "Color", Color3.fromRGB(255, 0, 0))
                        elseif state then
                            utility:Update(toggle.text, "Color", "accent")
                        else
                            utility:Update(toggle.text, "Color", "text")
                        end
                    end
                    --
                    function toggle:Position(yAxis)
                        utility:Update(toggle.text, "Position", UDim2.new(0, 22, 0, yAxis), windowFrame)
                    end
                    --
                    function toggle:Open(state)
                        toggle.text.Visible = state
                    end
                    --
                    function toggle:Action(action)
                        local is_blatant_feature = false
                        local blatant_mode_enabled = shared.pointers["blatant_mode"] and shared.pointers["blatant_mode"]:Get()
                        
                        for _, feature in pairs(shared.blatant_features) do
                            if togglePointer == feature then
                                is_blatant_feature = true
                                break
                            end
                        end
                        
                        if is_blatant_feature and not blatant_mode_enabled then
                            return
                        end
                        
                        toggle.current = not toggle.current
                        toggle.text.Text = toggle.name .. " -> " .. (toggle.current and "ON" or "OFF")
                        --
                        toggleCallback(toggle.current)
                    end
                    -- // Returning + Other
                    toggle.name = toggleName
                    toggle.text = toggleText
                    toggle.current = toggleDefault
                    --
                    local is_blatant_feature = false
                    local blatant_mode_enabled = shared.pointers["blatant_mode"] and shared.pointers["blatant_mode"]:Get()
                    
                    for _, feature in pairs(shared.blatant_features) do
                        if togglePointer == feature then
                            is_blatant_feature = true
                            break
                        end
                    end
                    
                    if is_blatant_feature then
                        toggle.pointer = togglePointer
                        shared.blatant_toggles[#shared.blatant_toggles + 1] = toggle
                    end
                    
                    -- Always add toggle to section (show all toggles, use colors for indication)
                    section.content[#section.content + 1] = toggle
                    --
                    if togglePointer then
                        local pointer = {}
                        --
                        function pointer:Get()
                            return toggle.current
                        end
                        --
                        function pointer:Set(value)
                            toggle.current = value
                            toggle.text.Text = toggle.name .. " -> " .. (toggle.current and "ON" or "OFF")
                            --
                            toggleCallback(toggle.current)
                        end
                        --
                        shared.pointers[togglePointer] = pointer
                    end
                    --
                    return toggle
                end
                --
                function section:Slider(sliderProperties)
                    local slider = {}
                    local sliderProperties = sliderProperties or {}
                    --
                    local sliderName = sliderProperties.name or sliderProperties.Name or "New Toggle"
                    local sliderDefault = sliderProperties.default or sliderProperties.Default or sliderProperties.def or sliderProperties.Def or 1
                    local sliderMax = sliderProperties.max or sliderProperties.Max or sliderProperties.maximum or sliderProperties.Maximum or 10
                    local sliderMin = sliderProperties.min or sliderProperties.Min or sliderProperties.minimum or sliderProperties.Minimum or 1
                    local sliderTick = sliderProperties.tick or sliderProperties.Tick or sliderProperties.decimals or sliderProperties.Decimals or 1
                    local sliderPointer = sliderProperties.pointer or sliderProperties.Pointer or sliderProperties.flag or sliderProperties.Flag or nil
                    local sliderCallback = sliderProperties.callback or sliderProperties.Callback or sliderProperties.CallBack or sliderProperties.callBack or function() end
                    -- // Functions
                    -- // Main
                    local sliderText = utility:Create("Text", {
                        Visible = false,
                        Text = sliderName .. " -> " .. "<" .. tostring(sliderDefault) .. "/" .. tostring(sliderMax) .. ">",
                        Outline = true,
                        Font = 2,
                        Color = shared.theme.text,
                        Size = 13
                    }, "menu")
                    -- // Nested Functions
                    function slider:Turn(state)
                        if state then
                            utility:Update(slider.text, "Color", "accent")
                        else
                            utility:Update(slider.text, "Color", "text")
                        end
                    end
                    --
                    function slider:Position(yAxis)
                        utility:Update(slider.text, "Position", UDim2.new(0, 22, 0, yAxis), windowFrame)
                    end
                    --
                    function slider:Open(state)
                        slider.text.Visible = state
                    end
                    --
                    function slider:Action(action)
                        slider.current = math.clamp(action == "Left" and (slider.current - slider.tick) or (slider.current + slider.tick), slider.min, slider.max)
                        slider.text.Text = sliderName .. " -> " .. "<" .. tostring(slider.current) .. "/" .. tostring(slider.max) .. ">"
                        --
                        sliderCallback(slider.current)
                    end
                    -- // Returning + Other
                    slider.name = sliderName
                    slider.text = sliderText
                    slider.current = sliderDefault
                    slider.max = sliderMax
                    slider.min = sliderMin
                    slider.tick = sliderTick
                    --
                    section.content[#section.content + 1] = slider
                    --
                    if sliderPointer then
                        local pointer = {}
                        --
                        function pointer:Get()
                            return slider.current
                        end
                        --
                        function pointer:Set(value)
                            slider.current = value
                            slider.text.Text = sliderName .. " -> " .. "<" .. tostring(slider.current) .. "/" .. tostring(slider.max) .. ">"
                            --
                            sliderCallback(slider.current)
                        end
                        --
                        shared.pointers[sliderPointer] = pointer
                    end
                    --
                    return slider
                end
                --
                function section:List(listProperties)
                    local list = {}
                    local listProperties = listProperties or {}
                    --
                    local listName = listProperties.name or listProperties.Name or "New List"
                    local listEnter = listProperties.enter or listProperties.Enter or listProperties.comfirm or listProperties.Comfirm or false
                    local listDefault = listProperties.default or listProperties.Default or listProperties.def or listProperties.Def or 1
                    local listOptions = listProperties.options or listProperties.Options or {"Option 1", "Option 2", "Option 3"}
                    local listPointer = listProperties.pointer or listProperties.Pointer or listProperties.flag or listProperties.Flag or nil
                    local listCallback = listProperties.callback or listProperties.Callback or listProperties.CallBack or listProperties.callBack or function() end
                    -- // Functions
                    -- // Main
                    local listText = utility:Create("Text", {
                        Visible = false,
                        Text = listName .. " -> " .. tostring(listOptions[listDefault]),
                        Outline = true,
                        Font = 2,
                        Color = shared.theme.text,
                        Size = 13
                    }, "menu")
                    -- // Nested Functions
                    function list:Turn(state)
                        if state then
                            utility:Update(list.text, "Color", "accent")
                        else
                            utility:Update(list.text, "Color", "text")
                        end
                    end
                    --
                    function list:Position(yAxis)
                        utility:Update(list.text, "Position", UDim2.new(0, 22, 0, yAxis), windowFrame)
                    end
                    --
                    function list:Open(state)
                        list.text.Visible = state
                    end
                    --
                    function list:Action(action)
                        if (listEnter and action == "Enter") then
                            listCallback(list.options[list.current])
                        else
                            list.current = ((list.options[action == "Left" and list.current - 1 or list.current + 1]) and (action == "Left" and list.current - 1 or list.current + 1)) or (action == "Left" and #list.options or 1)
                            --
                            list.text.Text = listName .. " -> " .. tostring(list.options[list.current])
                            --
                            if not listEnter then
                                listCallback(list.options[list.current])
                            end
                        end
                    end
                    -- // Returning + Other
                    if listPointer then
                        local pointer = {}
                        --
                        function pointer:Get(cfg)
                            if cfg then
                                return list.current
                            else
                                return list.options[list.current]
                            end
                        end
                        --
                        function pointer:Set(value)
                            if typeof(value) == "number" and list.options[value] then
                                list.current = value
                                --
                                list.text.Text = listName .. " -> " .. tostring(list.options[list.current])
                                --
                                if not listEnter then
                                    listCallback(list.options[list.current])
                                end
                            end
                        end
                        --
                        shared.pointers[listPointer] = pointer
                    end
                    --
                    list.name = listName
                    list.text = listText
                    list.current = listDefault
                    list.options = listOptions
                    --
                    section.content[#section.content + 1] = list
                    --
                    return list
                end
                --
                function section:MultiList(multiListProperties)
                    local multiList = {}
                    local multiListProperties = multiListProperties or {}
                    --
                    local multiListName = multiListProperties.name or multiListProperties.Name or "New Multilist"
                    local multiListDefault = multiListProperties.default or multiListProperties.Default or multiListProperties.def or multiListProperties.Def or 1
                    local multiListOptions = multiListProperties.options or multiListProperties.Options or {{"Option 1", false}, {"Option 2", false}, {"Option 3", false}}
                    local multiListPointer = multiListProperties.pointer or multiListProperties.Pointer or multiListProperties.flag or multiListProperties.Flag or nil
                    local multiListCallback = multiListProperties.callback or multiListProperties.Callback or multiListProperties.CallBack or multiListProperties.callBack or function() end
                    -- // Functions
                    -- // Main
                    local multiListText = utility:Create("Text", {
                        Visible = false,
                        Text = multiListName .. " -> " .. "<" .. (multiListOptions[multiListDefault] and (tostring(multiListOptions[multiListDefault][1]) .. ":" .. ((multiListOptions[multiListDefault][2]) and "ON" or "OFF")) or "Nil") .. ">",
                        Outline = true,
                        Font = 2,
                        Color = shared.theme.text,
                        Size = 13
                    }, "menu")
                    -- // Nested Functions
                    function multiList:Turn(state)
                        if state then
                            utility:Update(multiList.text, "Color", "accent")
                        else
                            utility:Update(multiList.text, "Color", "text")
                        end
                    end
                    --
                    function multiList:Position(yAxis)
                        utility:Update(multiList.text, "Position", UDim2.new(0, 22, 0, yAxis), windowFrame)
                    end
                    --
                    function multiList:Open(state)
                        multiList.text.Visible = state
                    end
                    --
                    function multiList:Action(action)
                        if action == "Enter" then
                            multiList.options[multiList.current][2] = not multiList.options[multiList.current][2]
                            --
                            multiList.text.Text = multiList.name .. " -> " .. "<" .. tostring(multiList.options[multiList.current][1]) .. ":" .. (multiList.options[multiList.current][2] and "ON" or "OFF") .. ">"
                            --
                            multiListCallback(multiList.options)
                        else
                            multiList.current = ((multiList.options[action == "Left" and multiList.current - 1 or multiList.current + 1]) and (action == "Left" and multiList.current - 1 or multiList.current + 1)) or (action == "Left" and #multiList.options or 1)
                            --
                            multiList.text.Text = multiList.name .. " -> " .. "<" .. tostring(multiList.options[multiList.current][1]) .. ":" .. (multiList.options[multiList.current][2] and "ON" or "OFF") .. ">"
                            --
                            multiListCallback(multiList.options)
                        end
                    end
                    -- // Returning + Other
                    if multiListPointer then
                        local pointer = {}
                        --
                        function pointer:Get()
                            return multiList.options
                        end
                        --
                        function pointer:Set(value)
                            if typeof(value) == "table" and value[multiList.current] then
                                multiList.options = value
                                --
                                multiList.text.Text = multiList.name .. " -> " .. "<" .. tostring(multiList.options[multiList.current][1]) .. ":" .. (multiList.options[multiList.current][2] and "ON" or "OFF") .. ">"
                                --
                                multiListCallback(multiList.options)
                            end
                        end
                        --
                        shared.pointers[multiListPointer] = pointer
                    end
                    --
                    multiList.name = multiListName
                    multiList.text = multiListText
                    multiList.current = multiListDefault
                    multiList.options = multiListOptions
                    --
                    section.content[#section.content + 1] = multiList
                    --
                    return multiList
                end
                --
                function section:PlayerList(playerListProperties)
                    local playerList = {}
                    local playerListProperties = playerListProperties or {}
                    --
                    local playerListName = playerListProperties.name or playerListProperties.Name or "New Toggle"
                    local playerListEnter = playerListProperties.enter or playerListProperties.Enter or playerListProperties.comfirm or playerListProperties.Comfirm or false
                    local playerListCallback = playerListProperties.callback or playerListProperties.Callback or playerListProperties.CallBack or playerListProperties.callBack or function() end
                    local playerListOptions = {}
                    local plr = plrs.LocalPlayer
                    -- // Functions
                    for index, player in pairs(plrs:GetPlayers()) do
                        if player ~= plr then
                            playerListOptions[#playerListOptions + 1] = player
                        end
                    end
                    --
                    utility:Connection(plrs.PlayerAdded, function(player)
                        if player ~= plr then
                            if not table.find(playerList.options, player) then
                                playerList.options[#playerList.options + 1] = player
                            end
                            --
                            if #playerList.options == 1 then
                                playerList.current = 1
                                --
                                playerList.text.Text = playerList.name .. " -> " .. "<" .. tostring(playerList.options[playerList.current].Name) .. ">"
                                --
                                if not playerListEnter then
                                    playerListCallback(tostring(playerList.options[playerList.current]))
                                end
                            end
                        end
                    end)
                    --
                    utility:Connection(plrs.PlayerRemoving, function(player)
                        if player ~= plr then
                            local index = table.find(playerList.options, player)
                            local current = playerList.current
                            local current_plr = playerList.options[current]
                            --
                            if index then
                                table.remove(playerList.options, index)
                            end
                            --
                            if #playerList.options == 0 then
                                playerList.text.Text = playerList.name .. " -> " .. "<Nil>"
                            else
                                local oldCurrent = playerList.current
                                --
                                if index and playerList.options[playerList.current] ~= current_plr and table.find(playerList.options, current_plr) then
                                    playerList.current = table.find(playerList.options, current_plr)
                                end
                                --
                                playerList.text.Text = playerList.name .. " -> " .. "<" .. tostring(playerList.options[playerList.current].Name) .. ">"
                                --
                                if not playerListEnter then
                                    if oldCurrent ~= playerList.current then
                                        playerListCallback(tostring(playerList.options[playerList.current]))
                                    end
                                end
                            end
                        end
                    end)
                    
                    -- // Main
                    local playerListText = utility:Create("Text", {
                        Visible = false,
                        Text = playerListName .. " -> " .. "<" .. (#playerListOptions >= 1 and tostring(playerListOptions[1].Name) or "Nil") .. ">",
                        Outline = true,
                        Font = 2,
                        Color = shared.theme.text,
                        Size = 13
                    }, "menu")
                    -- // Nested Functions
                    function playerList:Turn(state)
                        if state then
                            utility:Update(playerList.text, "Color", "accent")
                        else
                            utility:Update(playerList.text, "Color", "text")
                        end
                    end
                    --
                    function playerList:Position(yAxis)
                        utility:Update(playerList.text, "Position", UDim2.new(0, 22, 0, yAxis), windowFrame)
                    end
                    --
                    function playerList:Open(state)
                        playerList.text.Visible = state
                    end
                    --
                    function playerList:Action(action)
                        if (playerListEnter and action == "Enter") then
                            if #playerList.options >= 1 then
                                playerListCallback(tostring(playerList.options[playerList.current]))
                            end
                        else
                            if #playerList.options >= 1 then
                                local oldCurrent = playerList.current
                                --
                                playerList.current = ((playerList.options[action == "Left" and playerList.current - 1 or playerList.current + 1]) and (action == "Left" and playerList.current - 1 or playerList.current + 1)) or (action == "Left" and #playerList.options or 1)
                                --
                                playerList.text.Text = playerList.name .. " -> " .. "<" .. tostring(playerList.options[playerList.current].Name) .. ">"
                                --
                                if not playerListEnter then
                                    if oldCurrent ~= playerList.current then
                                        playerListCallback(tostring(playerList.options[playerList.current]))
                                    end
                                end
                            end
                        end
                    end
                    -- // Returning + Other
                    playerList.name = playerListName
                    playerList.text = playerListText
                    playerList.current = 1
                    playerList.options = playerListOptions
                    --
                    section.content[#section.content + 1] = playerList
                    --
                    return playerList
                end
                --
                function section:Keybind(keybindProperties)
                    -- // Variables
                    local keybind = {}
                    local keybindProperties = keybindProperties or {}
                    --
                    local keybindName = keybindProperties.name or keybindProperties.Name or "New Keybind"
                    local keybindDefault = keybindProperties.default or keybindProperties.Default or keybindProperties.def or keybindProperties.Def or nil
                    local keybindInputs = keybindProperties.inputs or keybindProperties.Inputs or true
                    local keybindPointer = keybindProperties.pointer or keybindProperties.Pointer or keybindProperties.flag or keybindProperties.Flag or nil
                    local keybindCallback = keybindProperties.callback or keybindProperties.Callback or keybindProperties.CallBack or keybindProperties.callBack or function() end
                    -- // Functions
                    function keybind:Shorten(string)
                        for i,v in pairs(shared.shortenedInputs) do
                            string = string.gsub(string, i, v)
                        end
                        --
                        return string
                    end
                    --
                    function keybind:Change(input)
                        input = input or "..."
                        local inputTable = {}
                        --
                        if input.EnumType then
                            if input.EnumType == Enum.KeyCode or input.EnumType == Enum.UserInputType then
                                if input.Name == "Backspace" or input.Name == "Escape" then
                                    keybind.current = {}
                                    keybind.text.Text = keybindName .. " -> " .. "<" .. "..." .. ">"
                                    return true
                                elseif table.find(shared.allowedKeyCodes, input.Name) or table.find(shared.allowedInputTypes, input.Name) then
                                    inputTable = {input.EnumType == Enum.KeyCode and "KeyCode" or "UserInputType", input.Name}
                                    --
                                    keybind.current = inputTable
                                    keybind.text.Text = keybindName .. " -> " .. "<" .. (#keybind.current > 0 and keybind:Shorten(keybind.current[2]) or "...") .. ">"
                                    --
                                    return true
                                end
                            end
                        end
                        --
                        return false
                    end
                    -- // Main
                    local keybindText = utility:Create("Text", {
                        Visible = false,
                        Text = keybindName .. " -> " .. "<" .. "..." .. ">",
                        Outline = true,
                        Font = 2,
                        Color = shared.theme.text,
                        Size = 13
                    }, "menu")
                    -- // Nested Functions
                    function keybind:Turn(state)
                        if state then
                            utility:Update(keybind.text, "Color", "accent")
                        else
                            utility:Update(keybind.text, "Color", "text")
                        end
                    end
                    --
                    function keybind:Position(yAxis)
                        utility:Update(keybind.text, "Position", UDim2.new(0, 22, 0, yAxis), windowFrame)
                    end
                    --
                    function keybind:Open(state)
                        keybind.text.Visible = state
                    end
                    --
                    function keybind:Action(action)
                        if not keybind.selecting then
                            keybind.text.Text = keybindName .. " -> " .. "<" .. "..." .. ">"
                            --
                            keybind.selecting = true
                            --
                            local connection
                            connection = utility:Connection(uis.InputBegan, function(Input)
                                if connection then
                                    local inputProcessed = keybind:Change(Input.KeyCode.Name ~= "Unknown" and Input.KeyCode or (keybind.inputs and Input.UserInputType))
                                    --
                                    if inputProcessed then
                                        wait()
                                        keybind.selecting = false
                                        --
                                        utility:RemoveConnection(connection)
                                        if #keybind.current > 0 then
                                            keybindCallback(Enum[keybind.current[1]][keybind.current[2]])
                                        end
                                    end
                                end
                            end)
                        end
                    end
                    -- // Returning + Other
                    if keybindPointer then
                        local pointer = {}
                        --
                        function pointer:Get(cfg)
                            if cfg then
                                return keybind.current
                            else
                                if #keybind.current == 0 then
                                    return nil
                                end
                                return Enum[keybind.current[1]][keybind.current[2]]
                            end
                        end
                        --
                        function pointer:Set(value)
                            if value and value[1] and value[2] then
                                local inputProcessed = keybind:Change(Enum[value[1]][value[2]])
                                --
                                if inputProcessed then
                                    keybindCallback(Enum[keybind.current[1]][keybind.current[2]])
                                end
                            end
                        end
                        --
                        shared.pointers[keybindPointer] = pointer
                    end
                    --
                    keybind.name = keybindName
                    keybind.text = keybindText
                    keybind.current = {}
                    keybind.inputs = keybindInputs
                    keybind.selecting = false
                    --
                    keybind:Change(keybindDefault)
                    --
                    section.content[#section.content + 1] = keybind
                    --
                    return keybind
                end
                --
                function section:ColorList(colorListProperties)
                    local colorList = {}
                    local colorListProperties = colorListProperties or {}
                    --
                    local colorListName = colorListProperties.name or colorListProperties.Name or "New Toggle"
                    local colorListDefault = colorListProperties.default or colorListProperties.Default or colorListProperties.def or colorListProperties.Def or 1
                    local colorListPointer = colorListProperties.pointer or colorListProperties.Pointer or colorListProperties.flag or colorListProperties.Flag or nil
                    local colorListCallback = colorListProperties.callback or colorListProperties.Callback or colorListProperties.CallBack or colorListProperties.callBack or function() end
                    -- // Functions
                    -- // Main
                    --
                    local colorListText = utility:Create("Text", {
                        Visible = false,
                        Text = colorListName .. " -> " .. "<   >",
                        Outline = true,
                        Font = 2,
                        Color = shared.theme.text,
                        Size = 13
                    }, "menu")
                    --
                    local colorListColor = utility:Create("Square", {
                        Visible = false,
                        Filled = true,
                        Thickness = 0,
                        Color = shared.colors[colorListDefault],
                        Size = UDim2.new(0, 17, 0, 9),
                    }, "menu")
                    -- // Nested Functions
                    function colorList:Turn(state)
                        if state then
                            utility:Update(colorList.text, "Color", "accent")
                        else
                            utility:Update(colorList.text, "Color", "text")
                        end
                    end
                    --
                    function colorList:Position(yAxis)
                        utility:Update(colorList.text, "Position", UDim2.new(0, 22, 0, yAxis), windowFrame)
                        utility:Update(colorList.color, "Position", UDim2.new(0, 22 + colorList.text.TextBounds.X - 26, 0, yAxis + 3), windowFrame)
                    end
                    --
                    function colorList:Open(state)
                        colorList.text.Visible = state
                        colorList.color.Visible = state
                    end
                    --
                    function colorList:Action(action)
                        colorList.current = ((colorList.options[action == "Left" and colorList.current - 1 or colorList.current + 1]) and (action == "Left" and colorList.current - 1 or colorList.current + 1)) or (action == "Left" and #colorList.options or 1)
                        --
                        colorList.text.Text = colorListName .. " -> " .. "<   >"
                        colorList.color.Color = colorList.options[colorList.current]
                        --
                        colorListCallback(colorList.options[colorList.current])
                    end
                    -- // Returning + Other
                    if colorListPointer then
                        local pointer = {}
                        --
                        function pointer:Get(cfg)
                            if cfg then
                                return colorList.current
                            else
                                return colorList.options[colorList.current]
                            end
                        end
                        --
                        function pointer:Set(value)
                            colorList.current = value
                            --
                            colorList.text.Text = colorListName .. " -> " .. "<   >"
                            colorList.color.Color = colorList.options[colorList.current]
                            --
                            colorListCallback(colorList.options[colorList.current])
                        end
                        --
                        shared.pointers[colorListPointer] = pointer
                    end
                    --
                    colorList.name = colorListName
                    colorList.text = colorListText
                    colorList.color = colorListColor
                    colorList.current = colorListDefault
                    colorList.options = shared.colors
                    --
                    section.content[#section.content + 1] = colorList
                    --
                    return colorList
                end
                -- // Returning + Other
                section.name = sectionName
                section.text = sectionText
                --
                page.sections[#page.sections + 1] = section
                --
                return section
            end
            -- // Returning + Other
            page.name = pageName
            page.text = pageText
            --
            window.pages[#window.pages + 1] = page
            window:Refresh()
            --
            return page
        end
        -- // Returning
        return window
    end

    function library:StatusWindow(windowProperties)
        -- // Variables
        local statusWindow = {
            visible = false,
            statusItems = {}
        }
        local windowProperties = windowProperties or {}
        local windowName = windowProperties.name or "Status Effects"
        local windowPosition = windowProperties.position or UDim2.new(1, -220, 0.7, -50)
        
        -- // Main Window Elements
        local statusFrame = utility:Create("Square", {
            Visible = false,
            Filled = true,
            Thickness = 0,
            Color = shared.theme.inline,
            Size = UDim2.new(0, 200, 0, 19),
            Position = windowPosition
        }, "status")
        
        local statusInline = utility:Create("Square", {
            Parent = statusFrame,
            Visible = false,
            Filled = true,
            Thickness = 0,
            Color = shared.theme.dark,
            Size = UDim2.new(1, -2, 1, -4),
            Position = UDim2.new(0, 1, 0, 3)
        }, "status")
        
        local statusAccent = utility:Create("Square", {
            Parent = statusFrame,
            Visible = false,
            Filled = true,
            Thickness = 0,
            Color = "accent",
            Size = UDim2.new(1, 0, 0, 2),
            Position = UDim2.new(0, 0, 0, 0)
        }, "status")
        
        local statusTitle = utility:Create("Text", {
            Parent = statusAccent,
            Visible = false,
            Text = windowName,
            Center = true,
            Outline = true,
            Font = 2,
            Color = shared.theme.text,
            Size = 13,
            Position = UDim2.new(0.5, 0, 0, 3)
        }, "status")
        
        statusWindow.statusFrame = statusFrame
        
        -- // Functions
        function statusWindow:SetVisible(visible)
            statusWindow.visible = visible
            statusFrame.Visible = visible
            statusInline.Visible = visible
            statusAccent.Visible = visible
            statusTitle.Visible = visible
            
            for _, item in pairs(statusWindow.statusItems) do
                if item.text then
                    item.text.Visible = visible
                end
            end
        end
        
        function statusWindow:Toggle()
            statusWindow:SetVisible(not statusWindow.visible)
        end
        
        function statusWindow:Clear()
            for _, item in pairs(statusWindow.statusItems) do
                if item.text then
                    item.text:Remove()
                end
            end
            statusWindow.statusItems = {}
            statusWindow:UpdateSize()
        end
        
        function statusWindow:AddItem(text, color)
            local yOffset = 19 + (#statusWindow.statusItems * 17) + 2
            
            local itemText = utility:Create("Text", {
                Parent = statusFrame,
                Visible = statusWindow.visible,
                Text = "[+] " .. text,
                Outline = true,
                Font = 2,
                Color = color or shared.theme.text,
                Size = 13,
                Position = UDim2.new(0, 5, 0, yOffset)
            }, "status")
            
            statusWindow.statusItems[#statusWindow.statusItems + 1] = {
                text = itemText
            }
            
            statusWindow:UpdateSize()
        end
        
        function statusWindow:UpdateSize()
            local contentHeight = 19 + (#statusWindow.statusItems * 17) + 5
            local newHeight = math.max(contentHeight, 30)
            
            statusFrame.Size = Vector2.new(200, newHeight)
            statusInline.Size = Vector2.new(198, newHeight - 4)
        end
        
        function statusWindow:UpdatePosition(xPercent, yPercent)
            local newPosition = UDim2.new(xPercent/100, -110, yPercent/100, -100)
            local framePos = Vector2.new(
                newPosition.X.Scale * (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X or 1024) + newPosition.X.Offset,
                newPosition.Y.Scale * (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.Y or 768) + newPosition.Y.Offset
            )
            
            statusFrame.Position = framePos
            statusInline.Position = Vector2.new(framePos.X + 1, framePos.Y + 3)
            statusAccent.Position = framePos
            statusTitle.Position = Vector2.new(framePos.X + 100, framePos.Y + 3)
            
            for i, item in pairs(statusWindow.statusItems) do
                if item.text then
                    local yOffset = 19 + ((i-1) * 17) + 2
                    item.text.Position = Vector2.new(framePos.X + 5, framePos.Y + yOffset)
                end
            end
        end
        
        return statusWindow
    end

    function library:Notify(text, color) 
        if shared and shared.pointers["notifications"]:Get() then
            local notification = {
                text = text,
                drawings = {},
                color = color,
                start_tick = tick(),
                lifetime = 8,
            }
        
            do -- Create Drawings
                notification.drawings.shadow_text = utility:Create("Text", {
                    Center = false,
                    Outline = false,
                    Color = Color3.new(),
                    Transparency = 200/255,
                    Text = text,
                    Size = 13,
                    Font = 2,
                    ZIndex = 99,
                    Visible = false
                }, "notification")
            
                notification.drawings.main_text = utility:Create("Text", {
                    Center = false,
                    Outline = false,
                    Color = notification.color,
                    Transparency = 1,
                    Text = text,
                    Size = 13,
                    Font = 2,
                    ZIndex = 100,
                    Visible = false
                }, "notification")
            end
        
            function notification:destruct()
                local shadow_text_origin = self.drawings.shadow_text.Position
                local main_text_origin = self.drawings.main_text.Position
                local shadow_text_transparency = self.drawings.shadow_text.Transparency
                local main_text_transparency = self.drawings.main_text.Transparency
        
                for i = 0, 1, 1/60 do
                    self.drawings.shadow_text.Position = shadow_text_origin:Lerp(Vector2.new(), i)
                    self.drawings.main_text.Position = main_text_origin:Lerp(Vector2.new(), i)
                    self.drawings.shadow_text.Transparency = shadow_text_transparency * (1 - i)
                    self.drawings.main_text.Transparency = main_text_transparency * (1 - i)
                    rs.RenderStepped:Wait()
                end

                for _,v in next, notification.drawings do
                    if shared and shared.drawing_containers then
                        table.remove(shared.drawing_containers.notification, table.find(shared.drawing_containers.notification, v))
                        v:Remove()
                    end
                end

                self.drawings.main_text = nil
                self.drawings.shadow_text = nil
                table.clear(self)
                self = nil
            end
        
            shared.notifications[#shared.notifications + 1] = notification
            return notification
        end
    end

    return library
end
