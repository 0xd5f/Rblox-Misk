local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/0xd5f/Rblox-Misk/main/UI.lua"))()
local Window = Library.CreateLib("BCWARE","BCW")
local Tab = Window:NewTab("Misk")
local Section = Tab:NewSection("Player")


Section:NewSlider("SpeedHack", "SpeedHack )", 500, 0, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

Section:NewSlider("JumpHack", "JumpHack )", 500, 0, function(j)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = j
end)

Section:NewSlider("HipHeight", "HipHeight )", 500, 0, function(h)
    game.Players.LocalPlayer.Character.Humanoid.HipHeight = h
end)

local Section = Tab:NewSection("Misk") -- Mountain
Section:NewKeybind("Ring Magnet", "Ring Magnet", Enum.KeyCode.E, function()
    for i,v in pairs(game:GetDescendants()) do
        if v.Name == 'Ring' then
        v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        end
        end
end)

clip = true
--Section:NewButton("", "No clip", function()
    Section:NewKeybind("No clip", "No clip", Enum.KeyCode.N, function()
        clip = not clip
        game:GetService('RunService').Stepped:connect(function()
            if not clip then
                game.Players.LocalPlayer.Character.Head.CanCollide = false
                game.Players.LocalPlayer.Character.Torso.CanCollide = false
                game.Players.LocalPlayer.Character["Left Leg"].CanCollide = false
                game.Players.LocalPlayer.Character["Right Leg"].CanCollide = false  
            end
        end) 
end)

local flying = false
Section:NewKeybind("Fly", "Fly", Enum.KeyCode.F, function()
    flying = not flying
    repeat wait()
    until game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:findFirstChild("Torso") and game.Players.LocalPlayer.Character:findFirstChild("Humanoid")
    local mouse = game.Players.LocalPlayer:GetMouse()
    repeat wait() until mouse
    local plr = game.Players.LocalPlayer
    local torso = plr.Character.Torso
    local deb = true
    local ctrl = {f = 0, b = 0, l = 0, r = 0}
    local lastctrl = {f = 0, b = 0, l = 0, r = 0}
    local maxspeed = 80
    local speed = 0

    
    function FlyFunction()
    local bg = Instance.new("BodyGyro", torso)
    bg.P = 9e4
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.cframe = torso.CFrame
    local bv = Instance.new("BodyVelocity", torso)
    bv.velocity = Vector3.new(0,0.1,0)
    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
    repeat wait()
    plr.Character.Humanoid.PlatformStand = true
    if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
    speed = speed+.5+(speed/maxspeed)
    if speed > maxspeed then
    speed = maxspeed
    end
    elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
    speed = speed-1
    if speed < 0 then
    speed = 0
    end
    end
    if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
    bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
    lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
    elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
    bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
    else
    bv.velocity = Vector3.new(0,0.1,0)
    end
    bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
    until not flying
    ctrl = {f = 0, b = 0, l = 0, r = 0}
    lastctrl = {f = 0, b = 0, l = 0, r = 0}
    speed = 0
    bg:Destroy()
    bv:Destroy()
    plr.Character.Humanoid.PlatformStand = false
    end
    mouse.KeyDown:connect(function(key)
    if key:lower() == "w" then
    ctrl.f = 1
    elseif key:lower() == "s" then
    ctrl.b = -1
    elseif key:lower() == "a" then
    ctrl.l = -1
    elseif key:lower() == "d" then
    ctrl.r = 1
    end
    end)
    mouse.KeyUp:connect(function(key)
    if key:lower() == "w" then
    ctrl.f = 0
    elseif key:lower() == "s" then
    ctrl.b = 0
    elseif key:lower() == "a" then
    ctrl.l = 0
    elseif key:lower() == "d" then
    ctrl.r = 0
    end
    end)
    FlyFunction()
end)
local Vis = Window:NewTab("Visuals")
local Section = Vis:NewSection("Visuals")

local enemy_color = Color3.fromRGB(255, 100, 100)
local team_color = Color3.fromRGB(100, 255, 100)
function esp()
    
    if not executed_already then
        if game.PlaceId == 292439477 then -- phantom forces characters fix
            local replication;
    
            for i,v in next, getgc(true) do
                if type(v) == "table" and rawget(v,'getbodyparts') then
                    replication = v;
                end
            end
    
            local characterparts = debug.getupvalue(replication.getbodyparts, 1)
            local player = game:GetService("Players").LocalPlayer
    
            function updater()
                for person,bodyparts in next, characterparts do
                    local character = bodyparts['head'].Parent;
                    if not person.Character or character.Name ~= person.Name then
                        character.Name = person.Name;
                        person.Character = character;
                    end
                end
                local character = player.Character;
                if character and character.Name == "Player" then
                    character.Name = player.Name;
                end
            end
    
            game:GetService("RunService"):BindToRenderStep("CharacterUpdater", 1, updater)
        end
    
        getgenv().executed_already = true;
       getgenv().skeleton_esp = true;
        local plrs = game:GetService("Players")
        local localplayer = plrs.LocalPlayer;
        local camera = game:GetService("Workspace").CurrentCamera;
        --local enemy_color = Color3.fromRGB(255, 100, 100)
        --local team_color = Color3.fromRGB(100, 255, 100)
    
        local function createESP(plr)
            local shead = Drawing.new("Line")
            shead.Thickness = 1;
            shead.Color = enemy_color;
    
            local srarm = Drawing.new("Line")
            srarm.Thickness = 1;
            srarm.Color = enemy_color;
    
          local slarm = Drawing.new("Line")
            slarm.Thickness = 1;
            slarm.Color = enemy_color;
    
           local srleg = Drawing.new("Line")
            srleg.Thickness = 1;
            srleg.Color = enemy_color;
    
           local slleg = Drawing.new("Line")
            slleg.Thickness = 1;
            slleg.Color = enemy_color;
    
            local name = plr.Name;
    
            function esp_func()
                if not skeleton_esp then
                    if shead.Visible then
                        shead.Visible = false;
                    end
                    if srarm.Visible then
                        srarm.Visible = false;
                    end
                    if slarm.Visible then
                        slarm.Visible = false;
                    end
                    if srleg.Visible then
                        srleg.Visible = false;
                    end
                    if slleg.Visible then
                        slleg.Visible = false;
                    end
                    return;
                end
                if plr then
                    if not localplayer.Character then shead.Visible = false; srarm.Visible = false; slarm.Visible = false; srleg.Visible = false; slleg.Visible = false; return end
                    if not plr.Character then shead.Visible = false; srarm.Visible = false; slarm.Visible = false; srleg.Visible = false; slleg.Visible = false; return end
                    if not plr.Character.Head then shead.Visible = false; srarm.Visible = false; slarm.Visible = false; srleg.Visible = false; slleg.Visible = false; return end
                    if (camera.CFrame.p - plr.Character.Head.CFrame.p).magnitude >= 1500 then shead.Visible = false; srarm.Visible = false; slarm.Visible = false; srleg.Visible = false; slleg.Visible = false; return end
    
                    local char = plr.Character;
    
                    local head = char["Head"];
                    local torso = char["Torso"];
                    local rarm = char["Right Arm"];
                    local larm = char["Left Arm"];
                    local rleg = char["Right Leg"];
                    local lleg = char["Left Leg"];
                    local p1 = head.CFrame.Position;
                    local p2 = torso.CFrame.Position;
                    local p3 = rarm.CFrame.Position;
                    local p4 = larm.CFrame.Position;
                    local p5 = rleg.CFrame.Position;
                    local p6 = lleg.CFrame.Position;
    
                    local sp1,v1 = camera:WorldToViewportPoint(p1)
                    local sp2,v2 = camera:WorldToViewportPoint(p2)
                    local sp3,v3 = camera:WorldToViewportPoint(p3)
                    local sp4,v4 = camera:WorldToViewportPoint(p4)
                    local sp5,v5 = camera:WorldToViewportPoint(p5)
                    local sp6,v6 = camera:WorldToViewportPoint(p6)
    
                    if skeleton_esp and v1 then
                        shead.From = Vector2.new(sp1.X, sp1.Y)
                        shead.To = Vector2.new(sp2.X, sp2.Y)
    
                        srarm.From = Vector2.new(sp2.X, sp2.Y)
                        srarm.To = Vector2.new(sp3.X, sp3.Y)
    
                        slarm.From = Vector2.new(sp2.X, sp2.Y)
                        slarm.To = Vector2.new(sp4.X, sp4.Y)
    
                        srleg.From = Vector2.new(sp2.X, sp2.Y)
                        srleg.To = Vector2.new(sp5.X, sp5.Y)
    
                        slleg.From = Vector2.new(sp2.X, sp2.Y)
                        slleg.To = Vector2.new(sp6.X, sp6.Y)
    
                        shead.Visible = true;
                        srarm.Visible = true;
                        slarm.Visible = true;
                        srleg.Visible = true;
                        slleg.Visible = true;
                    elseif not v1 then
                        shead.Visible = false;
                        srarm.Visible = false;
                        slarm.Visible = false;
                        srleg.Visible = false;
                        slleg.Visible = false;
                    end
    
                    if plr.Team ~= localplayer.Team and shead.Color == team_color then
                        shead.Color = enemy_color;
                    elseif plr.Team == localplayer.Team and shead.Color == enemy_color then
                        shead.Color = team_color;
                    end
    
                    if plr.Team ~= localplayer.Team and srarm.Color == team_color then
                        srarm.Color = enemy_color;
                    elseif plr.Team == localplayer.Team and srarm.Color == enemy_color then
                        srarm.Color = team_color;
                    end
    
                    if plr.Team ~= localplayer.Team and slarm.Color == team_color then
                        slarm.Color = enemy_color;
                    elseif plr.Team == localplayer.Team and slarm.Color == enemy_color then
                        slarm.Color = team_color;
                    end
    
                    if plr.Team ~= localplayer.Team and srleg.Color == team_color then
                        srleg.Color = enemy_color;
                    elseif plr.Team == localplayer.Team and srleg.Color == enemy_color then
                        srleg.Color = team_color;
                    end
    
                    if plr.Team ~= localplayer.Team and slleg.Color == team_color then
                        slleg.Color = enemy_color;
                    elseif plr.Team == localplayer.Team and slleg.Color == enemy_color then
                        slleg.Color = team_color;
                    end
                else
                    game:GetService("RunService"):UnbindFromRenderStep("ESP_" .. name)
                    shead.Visible = false;
                    shead:Destroy()
    
                    srarm.Visible = false;
                    srarm:Destroy()
    
                    slarm.Visible = false;
                    slarm:Destroy()
    
                    srleg.Visible = false;
                    srleg:Destroy()
    
                    slleg.Visible = false;
                    slleg:Destroy()
                end
            end
    
            game:GetService("RunService"):BindToRenderStep("ESP_" .. name, 1, esp_func)
        end
    
    
        for _,plr in next, plrs:GetPlayers() do
            if plr ~= localplayer then
                createESP(plr)
            end
        end
    
        plrs.PlayerAdded:connect(function(plr)
            createESP(plr)
        end)
    
        return;
    end
end


Section:NewButton("ESP Seleton", "ESP Seleton", function()
   esp()
    executed_already = not executed_already
    skeleton_esp = not skeleton_esp    
end)

Section:NewColorPicker("Enemy Color", "Enemy Color", Color3.fromRGB(255, 100, 100), function(enemy_col)
    enemy_color = enemy_col   
end)
Section:NewColorPicker("Team Color", "Team Color", Color3.fromRGB(100, 255, 100), function(team_col)
    team_color = team_col   
end)

Section:NewButton("ESP Box", "ESP Box", function()
    while wait(0.5) do
        for i, childrik in ipairs(workspace:GetDescendants()) do
            if childrik:FindFirstChild("Humanoid") then
                if not childrik:FindFirstChild("EspBox") then
                    if childrik ~= game.Players.LocalPlayer.Character then
                        local esp = Instance.new("BoxHandleAdornment",childrik)
                        esp.Adornee = childrik
                        esp.ZIndex = 0
                        esp.Size = Vector3.new(4, 5, 1)
                        esp.Transparency = 0.65
                        esp.Color3 = Color3.fromRGB(255,48,48)
                        esp.AlwaysOnTop = true
                        esp.Name = "EspBox"
                    end
                end
            end
        end
    end
end)
--spawn(loadstring(game:HttpGet("https://pastebin.com/raw/zKjj0TQD", true)))()

local Set = Window:NewTab("Setings")
local Section = Set:NewSection("Setings")

Section:NewKeybind("Menu Key", "Menu Key", Enum.KeyCode.Insert, function()
	Library:ToggleUI()
end)

local spam = false
Section:NewTextBox("Spamer", "Spamer", function(txt1)
    spam = not spam
    while wait() do
        local A_1 = txt1 local A_2 = "ALL"
        if not spam then
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(A_1,A_2)
            wait(0.5)
        end   
    end  
end)



