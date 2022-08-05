local scriptver = 'v1.1'

--- Settings ---
local existingSettings = _G.RadarSettings or {}
local settings = {
    -- Radar settings
    RADAR_LINES = true; -- Displays distance rings
    SMOOTH_ROT = true; -- Rotates the radar smoothly
    RADAR_SCALE = 1; -- Controls how "zoomed in" the radar display is 
    RADAR_RADIUS = 100; -- The size of the radar itself
    RADAR_LINE_DISTANCE = 50; -- The distance between each line
    
    -- Marker settings
    DISPLAY_TEAM_COLORS = true; -- Sets the radar markers' color to their player's team color
    DISPLAY_OFFSCREEN = true; -- Leaves offscreen markers visible
    DISPLAY_TEAMMATES = true; -- Shows your teammates' markers
    OFFSCREEN_TRANSPARENCY = 0.4; -- Transparency of offscreen markers
    USE_QUADS = true; -- Displays radar markers as quads instead of circles
    MARKER_SCALEMIN = 0.85; -- Minimium scale radar markers can be
    MARKER_SCALEMAX = 1.75; -- Maximum scale radar markers can be 
    
    -- Theme
    RADAR_THEME = {
        Outline = Color3.fromRGB(6, 6, 6); -- Radar outline
        Background = Color3.fromRGB(25, 25, 30); -- Radar background
        DragHandle = Color3.fromRGB(51, 51, 255); -- Drag handle 
        
        Cardinal_Lines = Color3.fromRGB(100, 100, 155); -- Color of the horizontal and vertical lines
        Distance_Lines = Color3.fromRGB(64, 64, 69); -- Color of the distance rings
        
        Generic_Marker = Color3.fromRGB(255, 0, 107); -- Color of a player marker without a team
        Local_Marker = Color3.fromRGB(16, 235, 255); -- Color of your marker, regardless of team
    };
}

for k, v in pairs(existingSettings) do 
    if (v ~= nil) then
        settings[k] = v 
    end
end

local RADAR_LINES = settings.RADAR_LINES
local SMOOTH_ROT = settings.SMOOTH_ROT
local RADAR_SCALE = settings.RADAR_SCALE
local RADAR_RADIUS = settings.RADAR_RADIUS
local RADAR_LINE_DISTANCE = settings.RADAR_LINE_DISTANCE

local DISPLAY_TEAM_COLORS = settings.DISPLAY_TEAM_COLORS 
local DISPLAY_OFFSCREEN = settings.DISPLAY_OFFSCREEN
local DISPLAY_TEAMMATES = settings.DISPLAY_TEAMMATES
local OFFSCREEN_TRANSPARENCY = settings.OFFSCREEN_TRANSPARENCY
local USE_QUADS = settings.USE_QUADS
local MARKER_SCALEMIN = settings.MARKER_SCALEMIN
local MARKER_SCALEMAX = settings.MARKER_SCALEMAX


local RADAR_THEME = settings.RADAR_THEME 


--- Services ---
local inputService = game:GetService('UserInputService')
local runService = game:GetService('RunService')
local playerService = game:GetService('Players')

--- Localization ---
local newVec2 = Vector2.new
local newVec3 = Vector3.new

local mathSin = math.sin
local mathCos = math.cos
local mathExp = math.exp

local tableInsert = table.insert
local tableRemove = table.remove 
local tableFind = table.find 


--- Script connections ---
local scriptCns = {}

--- Other variables
local markerScale = math.clamp(RADAR_SCALE, MARKER_SCALEMIN, MARKER_SCALEMAX)
local scaleVec = newVec2(markerScale, markerScale)

local quadPointA = newVec2(0, 5)   * scaleVec
local quadPointB = newVec2(4, -5)  * scaleVec
local quadPointC = newVec2(0, -3)  * scaleVec
local quadPointD = newVec2(-4, -5) * scaleVec

--- Drawing setup ---
local drawObjects = {}
local function newDraw(objectClass, objectProperties) 
    local obj = Drawing.new(objectClass)
    tableInsert(drawObjects, obj)
    
    
    for i, v in pairs(objectProperties) do
        obj[i] = v
    end
    return obj
end


-- Drawing tween function 
local numLerp, drawingTween do -- obj property dest time 
    function numLerp(a, b, c) 
        return (1 - c) * a + c * b
    end
    
    local tweenTypes = {}
    tweenTypes.Vector2 = Vector2.zero.Lerp
    tweenTypes.number = numLerp
    tweenTypes.Color3 = Color3.new().Lerp
    
    
    function drawingTween(obj, property, dest, time) 
        task.spawn(function()
            local initialVal = obj[property]
            local tweenTime = 0
            local lerpFunc = tweenTypes[typeof(dest)]
            
            while (tweenTime < time) do 
                
                obj[property] = lerpFunc(initialVal, dest, 1 - math.pow(2, -10 * tweenTime / time))
                
                local deltaTime = task.wait()
                tweenTime += deltaTime
            end
            obj[property] = dest
        end)
    end
end

--- Local object manager --- 
local clientPlayer = playerService.LocalPlayer
local clientRoot, clientHumanoid do 
    scriptCns.charRespawn = clientPlayer.CharacterAdded:Connect(function(newChar) 
        clientRoot = newChar:WaitForChild('HumanoidRootPart')
        clientHumanoid = newChar:WaitForChild('Humanoid')
    end)
    
    if (clientPlayer.Character) then 
        clientRoot = clientPlayer.Character:FindFirstChild('HumanoidRootPart')
        clientHumanoid = clientPlayer.Character:FindFirstChild('Humanoid')
    end
end
local clientCamera do 
    clientCamera = workspace.CurrentCamera or workspace:FindFirstChildOfClass('Camera')
    scriptCns.cameraUpdate = workspace:GetPropertyChangedSignal('CurrentCamera'):Connect(function() 
        clientCamera = workspace.CurrentCamera
    end)
end
local clientTeam do 
    scriptCns.teamUpdate = clientPlayer:GetPropertyChangedSignal('Team'):Connect(function() 
        clientTeam = clientPlayer.Team
    end)
    clientTeam = clientPlayer.Team
end

--- PlaceID Check --- 
do
    local id = game.PlaceId
    if (id == 292439477 or id == 3233893879) then
        local notif = Drawing.new('Text')
        notif.Center = true
        notif.Color = Color3.fromRGB(255, 255, 255)
        notif.Font = 1
        notif.Outline = true
        notif.Position = newVec2(clientCamera.ViewportSize.X / 2, 200)
        notif.Size = 35
        notif.Text = 'Games with custom character systems\naren\'t supported. Sorry!'
        notif.Transparency = 0
        notif.Visible = true

        
        drawingTween(notif, 'Transparency', 1, 0.25)
        drawingTween(notif, 'Position', newVec2(clientCamera.ViewportSize.X / 2, 150), 0.25)
        task.wait(5)
        
        drawingTween(notif, 'Position', newVec2(clientCamera.ViewportSize.X / 2, 200), 0.25)
        drawingTween(notif, 'Transparency', 0, 0.25)
        task.wait(3)
        
        for _, con in pairs(scriptCns) do 
            con:Disconnect()
        end
        notif:Remove()
        return
    else
        -- might as well place control notification here 
        local notif = Drawing.new('Text')
        notif.Center = true
        notif.Color = Color3.fromRGB(255, 255, 255)
        notif.Font = 1
        notif.Outline = true
        notif.Position = newVec2(clientCamera.ViewportSize.X / 2, 200)
        notif.Size = 30
        notif.Text = ('Loaded Drawing Radar %s.\n\nPress the + key to zoom in, and - key to zoom out.\nPressing End closes the script.'):format(scriptver)
        notif.Transparency = 0
        notif.Visible = true

        task.spawn(function()
            task.wait(1)
            
            drawingTween(notif, 'Transparency', 1, 0.25)
            drawingTween(notif, 'Position', newVec2(clientCamera.ViewportSize.X / 2, 150), 0.25)
            task.wait(8)
            
            drawingTween(notif, 'Position', newVec2(clientCamera.ViewportSize.X / 2, 200), 0.25)
            drawingTween(notif, 'Transparency', 0, 0.25)
            task.wait(1)
            notif:Remove()
        end)
    end
end

--- Player managers --- 
local playerNames = {} -- Array containing all player names
local playerExisting = {} -- Dictionary with player names as keys
local playerManagers = {} -- Dictionary containing the player managers
local playerCns = {} -- Connections for each manager

do 
    local function removePlayer(player) 
        local thisName = player.Name
        local thisManager = playerManagers[thisName]
        local thisPlayerCns = playerCns[thisName]
                
        if (thisManager.onLeave) then 
            thisManager.onLeave()
        end
        
        for _, con in pairs(thisPlayerCns) do
            con:Disconnect()
        end
        
        thisManager.onDeath = nil
        thisManager.onLeave = nil
        thisManager.onRemoval = nil
        thisManager.onRespawn = nil
        
        
        playerExisting[thisName] = nil
        playerCns[thisName] = nil 
        playerManagers[thisName] = nil 
        
        tableRemove(playerNames, tableFind(playerNames, thisName))
        
    end
    
    
    local function readyPlayer(player) 
        -- Setup some variables that will be used alot
        local thisName = player.Name
        local thisManager = {}
        local thisPlayerCns = {}
        
        playerExisting[thisName] = true 
        tableInsert(playerNames, thisName)
        
        -- Setup connections
        thisPlayerCns['chr-add'] = player.CharacterAdded:Connect(function(newChar) 
            local RootPart = newChar:WaitForChild('HumanoidRootPart')
            local Humanoid = newChar:WaitForChild('Humanoid')
            
            if (thisManager.onRespawn) then
                thisManager.onRespawn(newChar, RootPart, Humanoid)
            end
            thisManager.Character = newChar
            thisManager.RootPart = RootPart
            thisManager.Humanoid = Humanoid
            
            thisPlayerCns['chr-die'] = Humanoid.Died:Connect(function() 
                if (thisManager.onDeath) then
                    thisManager.onDeath()
                end
            end)
        end)
        thisPlayerCns['chr-rem'] = player.CharacterRemoving:Connect(function() 
            if (thisManager.onRemoval) then
                thisManager.onRemoval()
            end
            
            thisManager.Character = nil
            thisManager.RootPart = nil
            thisManager.Humanoid = nil 
        end)
        thisPlayerCns['team'] = player:GetPropertyChangedSignal('Team'):Connect(function() 
            thisManager.Team = player.Team
        end)
        
        if (player.Character) then
            local Character = player.Character
            local Humanoid = Character:FindFirstChild('Humanoid')
            local RootPart = Character:FindFirstChild('HumanoidRootPart')
            
            thisManager.Character = Character
            thisManager.RootPart = RootPart
            thisManager.Humanoid = Humanoid 
            
            thisPlayerCns['chr-die'] = Humanoid.Died:Connect(function() 
                if (thisManager.onDeath) then
                    thisManager.onDeath()
                end
            end)
        end
        
        thisManager.Team = player.Team
        thisManager.Player = player
        
        -- Finalize
        playerManagers[thisName] = thisManager
        playerCns[thisName] = thisPlayerCns
    end
    
    -- Setup managers for every existing player 
    for _, player in ipairs(playerService:GetPlayers()) do
        if (player ~= clientPlayer) then
            readyPlayer(player)
        end
    end
    -- Setup managers for joining players, and clean managers for leaving players
    scriptCns.pm_playerAdd = playerService.PlayerAdded:Connect(readyPlayer)
    scriptCns.pm_playerRemove = playerService.PlayerRemoving:Connect(removePlayer)
    
end


--- Radar UI --- 
local radarLines = {}
local radarObjects = {}
local radarPosition = newVec2(300, 250)

radarObjects.main = newDraw('Circle', {
    Color = RADAR_THEME.Background;
    Position = radarPosition; 
    
    Filled = true;
    Visible = true;
    
    NumSides = 40;
    Radius = RADAR_RADIUS;
    ZIndex = 300;
})

radarObjects.outline = newDraw('Circle', {
    Color = RADAR_THEME.Outline;
    Position = radarPosition; 
    
    Filled = false;
    Visible = true;
    
    NumSides = 40;
    Thickness = 10;
    Radius = RADAR_RADIUS;
    ZIndex = 299;
})

radarObjects.dragHandle = newDraw('Circle', {
    Color = RADAR_THEME.DragHandle;
    Position = radarPosition; 
    
    Filled = false;
    Visible = false;
    
    NumSides = 40;
    Radius = RADAR_RADIUS;
    Thickness = 3;
    ZIndex = 350;
})

radarObjects.zoomText = newDraw('Text', {
    Center = true;
    Color = Color3.fromRGB(255, 255, 255);
    Font = 1;
    Outline = true;
    Size = 20;
    Transparency = 0;
    Visible = true;
    ZIndex = 305;
})

-- center marker
if (USE_QUADS) then 
    radarObjects.centerMark = newDraw('Quad', {
        Color = RADAR_THEME.Local_Marker;
        PointA = radarPosition + quadPointA;
        PointB = radarPosition + quadPointB;
        PointC = radarPosition + quadPointC;
        PointD = radarPosition + quadPointD;
        
        Filled = true;
        Visible = true;
        
        ZIndex = 303;
        Thickness = 2;
    })
else
    radarObjects.centerMark = newDraw('Circle', {
        Color = RADAR_THEME.Local_Marker;
        Position = radarPosition; 
        
        Filled = true;
        Visible = true;
        
        NumSides = 20;
        Radius = 3 * markerScale;
        Thickness = 2;
        ZIndex = 303;
    })
end

-- lines
if (RADAR_LINES) then 
    for i = 0, RADAR_RADIUS, RADAR_SCALE * RADAR_LINE_DISTANCE do 
        local thisLine = newDraw('Circle', {
            Color = RADAR_THEME.Distance_Lines;
            Position = radarPosition; 
            Radius = i;
            
            Filled = false;
            Visible = true;
            
            NumSides = 40;
            Thickness = 1;
            ZIndex = 300;
        })
        
        tableInsert(radarLines, thisLine)
    end
    
    radarObjects.horizontalLine = newDraw('Line', {
        Color = RADAR_THEME.Cardinal_Lines;
        From = radarPosition - newVec2(RADAR_RADIUS, 0);
        To = radarPosition + newVec2(RADAR_RADIUS, 0);
                
        Visible = true; 
        
        Thickness = 2;
        Transparency = 0.2;
        ZIndex = 300;
    })
    
    radarObjects.verticalLine = newDraw('Line', {
        Color = RADAR_THEME.Cardinal_Lines;
        From = radarPosition - newVec2(0, RADAR_RADIUS);
        To = radarPosition + newVec2(0, RADAR_RADIUS);
        
        Visible = true; 
        
        Thickness = 2;
        Transparency = 0.2;
        ZIndex = 300;
    })
else
    radarLines = nil 
end


--- Other functions
local function killScript() 
    for _, con in pairs(scriptCns) do 
        con:Disconnect()
    end
    
    local startLen = #playerNames
    for i = 1, startLen do 
        local thisName = playerNames[1]
        local thisManager = playerManagers[thisName]
        local thisPlayerCns = playerCns[thisName]
        
        
        for _, con in pairs(thisPlayerCns) do
            con:Disconnect()
        end
        
        tableRemove(playerNames, 1)
        playerExisting[thisName] = nil
        playerCns[thisName] = nil 
        playerManagers[thisName] = nil 
        
    end
    
    for _, obj in ipairs(drawObjects) do 
        drawingTween(obj, 'Transparency', 0, 0.5)
    end
    task.wait(0.6)
    for _, obj in ipairs(drawObjects) do 
        pcall(obj.Remove, obj) -- in case it errors for some reason like it randomly does :troll:
    end
end

local function setRadarScale()   
    markerScale = math.clamp(RADAR_SCALE, MARKER_SCALEMIN, MARKER_SCALEMAX)
    
    if (RADAR_LINES) then
        -- Calculate how many radar lines can fit at this scale 
        local lineCount = math.floor(RADAR_RADIUS / (RADAR_SCALE * RADAR_LINE_DISTANCE))
        
        -- If more lines can fit than there are made, make more 
        if (lineCount > #radarLines) then
            for i = 1, lineCount - #radarLines do 
                local thisLine = newDraw('Circle', {
                    Color = RADAR_THEME.Distance_Lines;
                    
                    Position = radarPosition;
                    
                    Filled = false;
                    Visible = true;
                    
                    NumSides = 40;
                    Thickness = 1;
                    ZIndex = 300;
                })
                
                tableInsert(radarLines, thisLine)
            end
        end
        
        for idx, line in ipairs(radarLines) do 
            if (idx > lineCount) then
                -- This line wont fit, hide it
                line.Visible = false  
            else
                -- This line fits, set its radius and display it 
                line.Radius = idx * (RADAR_SCALE * RADAR_LINE_DISTANCE)
                line.Visible = true
            end
        end
    end
    
    
    if (USE_QUADS) then 
        scaleVec = newVec2(markerScale, markerScale)
        
        quadPointA = newVec2(0, 5)   * scaleVec
        quadPointB = newVec2(4, -5)  * scaleVec
        quadPointC = newVec2(0, -3)  * scaleVec
        quadPointD = newVec2(-4, -5) * scaleVec
    else
        radarObjects.centerMark.Radius = 3 * markerScale
    end
end

local function setRadarPosition(newPosition) 
    radarPosition = newPosition
        
    radarObjects.main.Position = newPosition
    radarObjects.outline.Position = newPosition
    
    
    if (RADAR_LINES) then
        for _, line in ipairs(radarLines) do 
            line.Position = newPosition
        end 
        
        
        radarObjects.horizontalLine.From = newPosition - newVec2(RADAR_RADIUS, 0);
        radarObjects.horizontalLine.To = newPosition + newVec2(RADAR_RADIUS, 0);
        
        radarObjects.verticalLine.From = newPosition - newVec2(0, RADAR_RADIUS);
        radarObjects.verticalLine.To = newPosition + newVec2(0, RADAR_RADIUS);
    end
end

--- Input and drag handling
do
    local radarDragging = false
    local radarHovering = false
    
    local zoomingIn = false
    local zoomingOut = false
        
    -- The keycode is only checked if its found in this dictionary,
    -- just so a giant elif chain isnt done on every keypress
    local keysToCheck = {
        End = true;
        Equals = true;
        Minus = true;
    }
    
    scriptCns.inputBegan = inputService.InputBegan:Connect(function(io) 
        local inputType = io.UserInputType.Name

        if (inputType == 'Keyboard') then
            local keyCode = io.KeyCode.Name
            
            if (not keysToCheck[keyCode]) then
                return
            end
            
            if (keyCode == 'End') then
                killScript() 
            elseif (keyCode == 'Equals') then
                zoomingIn = true 
                
                local zoomText = radarObjects.zoomText
                zoomText.Position = radarPosition + newVec2(0, RADAR_RADIUS + 25)
                drawingTween(zoomText, 'Transparency', 1, 0.3)
                
                local accel = 0.1
                
                scriptCns.zoomInCn = runService.Heartbeat:Connect(function(deltaTime) 
                    RADAR_SCALE = math.clamp(RADAR_SCALE + (deltaTime * accel), 0.02, 3)
                    accel += deltaTime
                    
                    zoomText.Text = ('Scale: %.2f'):format(RADAR_SCALE)
                    setRadarScale()
                end)                
            elseif (keyCode == 'Minus') then
                zoomingOut = true
                
                local zoomText = radarObjects.zoomText
                zoomText.Position = radarPosition + newVec2(0, RADAR_RADIUS + 25)
                drawingTween(zoomText, 'Transparency', 1, 0.3)
                
                local accel = 0.1
                
                scriptCns.zoomOutCn = runService.Heartbeat:Connect(function(deltaTime) 
                    RADAR_SCALE = math.clamp(RADAR_SCALE - (deltaTime * accel), 0.02, 3)
                    accel += deltaTime
                    
                    zoomText.Text = ('Scale: %.2f'):format(RADAR_SCALE)
                    setRadarScale()
                end)    
            end
        elseif (inputType == 'MouseButton1') then
            local mousePos = inputService:GetMouseLocation()
            
            if ((mousePos - radarPosition).Magnitude < RADAR_RADIUS) then
                radarDragging = true
                radarObjects.dragHandle.Visible = true
                
                scriptCns.dragCn = inputService.InputChanged:Connect(function(io) 
                    if (io.UserInputType.Name == 'MouseMovement') then
                        local mousePos = inputService:GetMouseLocation()
                        radarObjects.dragHandle.Position = mousePos
                    end
                end)
            end
        end
    end)

    scriptCns.inputEnded = inputService.InputEnded:Connect(function(io) 
        local inputType = io.UserInputType.Name
        if (inputType == 'Keyboard') then
            local keyCode = io.KeyCode.Name
            
            if (not keysToCheck[keyCode]) then
                return
            end
            
            if (keyCode == 'Equals') then
                zoomingIn = false 
                
                drawingTween(radarObjects.zoomText, 'Transparency', 0, 0.3)
                
                local zoomCn = scriptCns.zoomInCn
                if (zoomCn and zoomCn.Connected) then 
                    zoomCn:Disconnect()
                end
            elseif (keyCode == 'Minus') then
                zoomingOut = false
                
                drawingTween(radarObjects.zoomText, 'Transparency', 0, 0.3)
                
                local zoomCn = scriptCns.zoomOutCn
                if (zoomCn and zoomCn.Connected) then 
                    zoomCn:Disconnect()
                end
            end
            
        elseif (inputType == 'MouseButton1') then
            if (radarDragging) then
                scriptCns.dragCn:Disconnect()
                radarDragging = false 
                
                setRadarPosition(radarObjects.dragHandle.Position)
                radarObjects.dragHandle.Visible = false 
            end
        end
    end)
end


--- Player marker setup
local hoverTexts = {}
local playerMarks = {} do 
    local function initMark(thisPlayer)
        local thisName = thisPlayer.Name 
        local thisManager = playerManagers[thisName]
        
        local mark
        local text
        
        if (USE_QUADS) then 
            mark = Drawing.new('Quad')
            mark.Filled = true
            mark.Thickness = 2
            mark.Visible = true
            mark.ZIndex = 302
        else
            mark = Drawing.new('Circle')
            mark.Filled = true
            mark.NumSides = 20
            mark.Radius = 3 * markerScale
            mark.Thickness = 2
            mark.Visible = true
            mark.ZIndex = 302
        end
        
        text = Drawing.new('Text')
        text.Center = true
        text.Color = Color3.fromRGB(255, 255, 255)
        text.Font = 1
        text.Outline = true
        text.Size = 15
        text.Text = thisPlayer.DisplayName or thisName
        text.Visible = false
        text.ZIndex = 305
        
        if (DISPLAY_TEAM_COLORS) then
            mark.Color = thisManager.Player.TeamColor.Color
        else
            mark.Color = RADAR_THEME.Generic_Marker
        end
        
        tableInsert(drawObjects, mark)
        tableInsert(drawObjects, text)
        
        hoverTexts[thisName] = text 
        playerMarks[thisName] = mark
        
        thisManager.onDeath = function()
            mark.Filled = false
        end
        thisManager.onRespawn = function()
            mark.Filled = true
        end
        thisManager.onLeave = function()
            tableRemove(drawObjects, tableFind(drawObjects, mark))
            tableRemove(drawObjects, tableFind(drawObjects, text))
            task.spawn(function() 
                drawingTween(mark, 'Transparency', 0, 1)
                task.wait(1)
                mark:Remove()
            end)
            text:Remove()
            
            playerMarks[thisName] = nil
            hoverTexts[thisName] = nil
        end
    end
    
    for _, thisName in ipairs(playerNames) do
        initMark(playerService[thisName])
    end
    
    scriptCns.addMarks = playerService.PlayerAdded:Connect(function(player) 
        task.wait()
        initMark(player)
    end)
end


-- Hover display
do 
    local visiblePlrs = {}
    local visibleCount = 0
    local lastCheckTime = 0
    
    scriptCns.inputChanged = inputService.InputChanged:Connect(function(io) 
        local nowTime = tick()
        if (nowTime - lastCheckTime > 0.05 and io.UserInputType.Name == 'MouseMovement') then
            lastCheckTime = nowTime
            local mousePos = inputService:GetMouseLocation()
            
            if ((mousePos - radarPosition).Magnitude < RADAR_RADIUS) then
                for _, thisName in ipairs(playerNames) do 
                    local thisMark = playerMarks[thisName]
                    local markPos = thisMark.PointC
                    
                    if ((mousePos - markPos).Magnitude < 15) then
                        if (visiblePlrs[thisName] == nil) then 
                            hoverTexts[thisName].Visible = true
                            visiblePlrs[thisName] = true
                            visibleCount += 1 
                        end
                    elseif (visiblePlrs[thisName]) then
                        hoverTexts[thisName].Visible = false
                        visiblePlrs[thisName] = nil
                        visibleCount -= 1 
                    end
                end
            else
                if (visibleCount > 0) then
                    for thisName in pairs(visiblePlrs) do 
                        hoverTexts[thisName].Visible = false
                        visiblePlrs[thisName] = nil
                        visibleCount -= 1 
                    end
                end
            end
        end
    end)
end



--- Main radar loop

-- Coordinate conversion functions
local function cartToPolar(x, y) 
    return math.sqrt(x^2 + y^2), math.atan2(y, x)
end
local function polarToCart(r, t) 
    return r * mathCos(t), r * mathSin(t)
end

do
    local finalLookVec = Vector3.zero
    
    local hOffset = newVec2(RADAR_RADIUS, 0) -- Horizontal offset
    local vOffset = newVec2(0, RADAR_RADIUS) -- Vertical offset
    
    local textOffset = newVec2(0, 15)
    
    local rad90 = math.rad(90)
    local rad180 = math.rad(180)
    
    scriptCns.radarLoop = runService.Heartbeat:Connect(function(deltaTime) 
        if (not clientRoot) then return end
        -- Get positions for random junk
        local selfPos = clientRoot.Position
        
        -- Camera angle
        do 
            local cameraLookVec = clientCamera.CFrame.LookVector
            local fixedLookVec = newVec3(cameraLookVec.X, 0, cameraLookVec.Z).Unit
            
            if (SMOOTH_ROT) then
                finalLookVec = finalLookVec:lerp(fixedLookVec, 1 - mathExp(-10 * deltaTime))
            else
                finalLookVec = fixedLookVec
            end
            
            camAngle = math.atan2(finalLookVec.X, finalLookVec.Z)
        end
        
        -- Vertical and horizontal lines
        do 
            if (RADAR_LINES) then
                local top = -vOffset
                local bottom = vOffset
                local left = -hOffset
                local right = hOffset
                                
                local angleCos = mathCos(-camAngle)
                local angleSin = mathSin(-camAngle)
                
                local fixedTop    = radarPosition + newVec2((top.X * angleSin)    - (top.Y * angleCos),    (top.X * angleCos)    + (top.Y * angleSin))
                local fixedBottom = radarPosition + newVec2((bottom.X * angleSin) - (bottom.Y * angleCos), (bottom.X * angleCos) + (bottom.Y * angleSin))     
                local fixedLeft   = radarPosition + newVec2((left.X * angleSin)   - (left.Y * angleCos),   (left.X * angleCos)   + (left.Y * angleSin))  
                local fixedRight  = radarPosition + newVec2((right.X * angleSin)  - (right.Y * angleCos),  (right.X * angleCos)  + (right.Y * angleSin))  
                
                local hLine, vLine = radarObjects.horizontalLine, radarObjects.verticalLine
                
                hLine.From = fixedLeft
                hLine.To = fixedRight
                
                vLine.From = fixedTop
                vLine.To = fixedBottom
            end
        end
        
        -- Centermark
        do
            local centerMark = radarObjects.centerMark
            if (USE_QUADS) then
                -- https://danceswithcode.net/engineeringnotes/rotations_in_2d/rotations_in_2d.html
                
                -- Get player LookVector
                local playerLookVec = clientRoot.CFrame.LookVector
                -- Convert it to an angle using atan2 and subtract the camera angle
                local angle = (math.atan2(playerLookVec.X, playerLookVec.Z) - camAngle) - rad90
                
                local angleCos = mathCos(angle)
                local angleSin = mathSin(angle)
                
                -- Rotate quad points by angle using the sin and cosine calculated above
                local fixedA = radarPosition + newVec2((quadPointA.X * angleSin) - (quadPointA.Y * angleCos), (quadPointA.X * angleCos) + (quadPointA.Y * angleSin))
                local fixedB = radarPosition + newVec2((quadPointB.X * angleSin) - (quadPointB.Y * angleCos), (quadPointB.X * angleCos) + (quadPointB.Y * angleSin))                
                local fixedC = radarPosition + newVec2((quadPointC.X * angleSin) - (quadPointC.Y * angleCos), (quadPointC.X * angleCos) + (quadPointC.Y * angleSin))  
                local fixedD = radarPosition + newVec2((quadPointD.X * angleSin) - (quadPointD.Y * angleCos), (quadPointD.X * angleCos) + (quadPointD.Y * angleSin))  
                -- Set points
                centerMark.PointA = fixedA
                centerMark.PointB = fixedB
                centerMark.PointC = fixedC
                centerMark.PointD = fixedD
            else
                centerMark.Position = radarPosition
                centerMark.Radius = 3 * markerScale
            end
        end
        
        -- Player marks
        do
            for _, thisName in ipairs(playerNames) do 
                local thisMark = playerMarks[thisName]
                local thisManager = playerManagers[thisName]
                
                
                if (DISPLAY_TEAMMATES == false and thisManager.Team == clientTeam) then
                    thisMark.Visible = false
                    continue
                end
                
                local thisRoot = thisManager.RootPart
                if (thisRoot) then
                    local posDelta = thisRoot.Position - selfPos
                    
                    local radius, angle = cartToPolar(posDelta.X, posDelta.Z)
                    local fixedRadius = radius * RADAR_SCALE
                    
                    if (fixedRadius > RADAR_RADIUS) then
                        if (DISPLAY_OFFSCREEN) then 
                            thisMark.Transparency = OFFSCREEN_TRANSPARENCY
                        else
                            thisMark.Visible = false
                            continue
                        end
                    else
                        thisMark.Visible = true
                        thisMark.Transparency = 1
                    end
                    
                    radius = math.clamp(fixedRadius, 0, RADAR_RADIUS)
                    angle += (camAngle + rad180)
                    
                    local x, y = polarToCart(radius, angle)
                    local finalPos = radarPosition + newVec2(x, y)
                    
                    if (USE_QUADS) then
                        -- Get player LookVector
                        local playerLookVec = thisRoot.CFrame.LookVector
                        -- Convert it to an angle using atan2 and subtract the camera angle
                        local angle = (math.atan2(playerLookVec.X, playerLookVec.Z)) - rad90 - camAngle
                        
                        local angleCos = mathCos(angle)
                        local angleSin = mathSin(angle)
                        
                        -- Rotate quad points by angle using the sin and cosine calculated above
                        local fixedA = finalPos + newVec2((quadPointA.X * angleSin) - (quadPointA.Y * angleCos), (quadPointA.X * angleCos) + (quadPointA.Y * angleSin))
                        local fixedB = finalPos + newVec2((quadPointB.X * angleSin) - (quadPointB.Y * angleCos), (quadPointB.X * angleCos) + (quadPointB.Y * angleSin))                
                        local fixedC = finalPos + newVec2((quadPointC.X * angleSin) - (quadPointC.Y * angleCos), (quadPointC.X * angleCos) + (quadPointC.Y * angleSin))  
                        local fixedD = finalPos + newVec2((quadPointD.X * angleSin) - (quadPointD.Y * angleCos), (quadPointD.X * angleCos) + (quadPointD.Y * angleSin))  

                        -- Set points
                        thisMark.PointA = fixedA
                        thisMark.PointB = fixedB
                        thisMark.PointC = fixedC
                        thisMark.PointD = fixedD
                    else
                        thisMark.Position = finalPos
                        thisMark.Radius = 3 * markerScale
                    end
                    
                    hoverTexts[thisName].Position = finalPos + textOffset
                end
            end
        end
    end)
end
