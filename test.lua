local j = loadstring(game:HttpGet("\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\48\120\100\53\102\47\82\98\108\111\120\45\77\105\115\107\47\109\97\105\110\47\85\73\50\46\108\117\97"), "\77\97\116\101\114\105\97\108\32\76\117\97")() local n = j:Load({ Title = "\66\67\87\32\82\69\67\79\73\76", SizeX = 300, SizeY = 460 }) local h = n:New({ Title = "\77\97\105\110" }) local e = n:New({ Title = "\83\101\116\116\105\110\103\115" }) h:Separator() function q()  game:GetService("\83\116\97\114\116\101\114\71\117\105"):SetCore("\83\101\110\100\78\111\116\105\102\105\99\97\116\105\111\110",{ Title = "\66\67\87\65\82\69"; Text = "\77\97\120\65\109\109\111\32\79\78"; Duration = 5; }) while game:GetService("\82\117\110\83\101\114\118\105\99\101").RenderStepped:wait() do game.Players.LocalPlayer.CharacterAdded:Connect(function() wait(1) debug.setupvalue(getsenv(game.Players.LocalPlayer.PlayerScripts.Shockwave).Restock,6,math.huge)  end)     end  end function o() c = hookfunction(getrenv().math.random, newcclosure(function(a, b, ...) if a and b then b = a else return 0 end return c(a, b, ...) end)) game:GetService("\83\116\97\114\116\101\114\71\117\105"):SetCore("\83\101\110\100\78\111\116\105\102\105\99\97\116\105\111\110",{ Title = "\78\111\83\112\114\101\97\100"; Text = "\78\111\83\112\114\101\97\100\32\79\78"; Duration = 5; }) print("\78\111\83\112\114\101\97\100\32\79\78") end shared.WB = false local f = getrawmetatable(game) local _ = f.__namecall setreadonly(f, false) f.__namecall = newcclosure(function(self, ...) local s_ = getnamecallmethod() local ts = {...} if s_ == 'FindPartOnRayWithIgnoreList' and shared.WB then table.insert(ts[2], game.GetService(game, 'Workspace').Map) return _(self, unpack(ts)) end return _(self,...) end) local pt= false local function s(t,pt) for _,i in pairs(t:GetChildren()) do if i:IsA("\66\97\115\101\80\97\114\116") and not i.Parent:FindFirstChild("\72\117\109\97\110\111\105\100") and not i.Parent.Parent:FindFirstChild("\72\117\109\97\110\111\105\100") then i.LocalTransparencyModifier=pt end s(i,pt) end end function g(b) if b then s(workspace,0.4) else s(workspace,0) end end function r()  game:GetService("\83\116\97\114\116\101\114\71\117\105"):SetCore("\83\101\110\100\78\111\116\105\102\105\99\97\116\105\111\110",{ Title = "\78\111\70\111\103"; Text = "\78\111\70\111\103\32\79\78"; Duration = 5; }) wait() game.Lighting.FogEnd = 1000000 wait() end local qp = game:GetService("\80\108\97\121\101\114\115") local oq = game:GetService("\82\117\110\83\101\114\118\105\99\101") local go = game:GetService("\85\115\101\114\73\110\112\117\116\83\101\114\118\105\99\101") local bg = workspace.CurrentCamera local rb = false local cr = bg.ViewportSize / 2 local i, Axis_Y = cr.X, cr.Y local ki = Drawing.new("\76\105\110\101") local ak = Drawing.new("\76\105\110\101") _G.SendNotifications = true    _G.DefaultSettings = false    _G.ToMouse = false    _G.CrosshairVisible = false    _G.CrosshairSize = 20    _G.CrosshairThickness = 1    _G.CrosshairColor = Color3.fromRGB(0, 255, 0)    _G.CrosshairTransparency = 1    oq.RenderStepped:Connect(function() local la = _G.CrosshairSize / 2 ki.Color = _G.CrosshairColor ki.Thickness = _G.CrosshairThickness ki.Visible = _G.CrosshairVisible ki.Transparency = _G.CrosshairTransparency ak.Color = _G.CrosshairColor ak.Thickness = _G.CrosshairThickness ak.Visible = _G.CrosshairVisible ak.Transparency = _G.CrosshairTransparency if _G.ToMouse == true then ki.From = Vector2.new(go:GetMouseLocation().X - la, go:GetMouseLocation().Y) ki.To = Vector2.new(go:GetMouseLocation().X + la, go:GetMouseLocation().Y) ak.From = Vector2.new(go:GetMouseLocation().X, go:GetMouseLocation().Y - la) ak.To = Vector2.new(go:GetMouseLocation().X, go:GetMouseLocation().Y + la) elseif _G.ToMouse == false then ki.From = Vector2.new(i - la, Axis_Y) ki.To = Vector2.new(i + la, Axis_Y) ak.From = Vector2.new(i, Axis_Y - la) ak.To = Vector2.new(i, Axis_Y + la) end end) if _G.DefaultSettings == true then _G.CrosshairVisible = false _G.CrosshairSize = 25 _G.CrosshairThickness = 1 _G.CrosshairColor = Color3.fromRGB(40, 90, 255) _G.CrosshairTransparency = 1 end h:Button({ Text = "\77\97\120\32\65\109\109\111", Callback = function() q()  end, Menu = { Information = function() n:Banner({ Text = "\70\117\108\108\32\97\109\109\111" }) end } }) h:Button({ Text = "\78\111\32\83\112\114\101\97\100", Callback = function() o()  end, Menu = { Information = function() n:Banner({ Text = "\82\101\109\111\118\101\115\32\116\104\101\32\115\99\97\116\116\101\114\32\111\102\32\98\117\108\108\101\116\115" }) end } }) h:Separator() h:Bind({ Text = "\120\82\97\121", Bind = Enum.KeyCode.X, Notify = true, Callback = function(c) pt=not pt g(pt) print(("xRay: %s"):format(tostring(c))) end, Menu = { Information = function() n:Banner({ Text = "\77\97\107\101\115\32\116\101\120\116\117\114\101\115\32\116\114\97\110\115\112\97\114\101\110\116" }) end } }) h:TextField({ Text = "\120\82\97\121\32\86\97\108\117\101", Callback = function(m) s(workspace,m) end, Menu = { Information = function() n:Banner({ Text = "\84\104\105\115\32\105\115\32\97\32\84\101\120\116\70\105\101\108\100" }) end } }) h:Bind({ Text = "\87\97\108\108\32\83\104\111\116", Bind = Enum.KeyCode.T, Notify = true, Callback = function(k) shared.WB = not shared.WB print(("Wall Shot: %s"):format(tostring(k))) end, Menu = { Information = function() n:Banner({ Text = "\65\108\108\111\119\115\32\121\111\117\32\116\111\32\107\105\108\108\32\116\104\114\111\117\103\104\32\97\32\119\97\108\108" }) end } }) h:Button({ Text = "\78\111\32\70\111\103", Notify = true, Callback = function() r() print(("\78\111\32\70\111\103\58\32\79\78")) end, Menu = { Information = function() n:Banner({ Text = "\82\101\109\111\118\101\115\32\116\104\101\32\115\99\97\116\116\101\114\32\111\102\32\98\117\108\108\101\116\115" }) end } }) h:Separator() h:Toggle({ Text = "\67\114\111\115\115\104\97\105\114", Callback = function() _G.CrosshairVisible = not _G.CrosshairVisible end, Enabled = false, Menu = { Information = function() n:Banner({ Text = "\67\114\111\115\115\104\97\105\114" }) end } }) h:Slider({ Text = "\67\114\111\115\115\104\97\105\114\32\83\105\122\101", Callback = function(a) _G.CrosshairSize = a end, Min = 0, Max = 400, Def = 15, Menu = { Information = function() n:Banner({ Text = "\67\114\111\115\115\104\97\105\114\32\83\105\122\101" }) end } }) h:Slider({ Text = "\67\114\111\115\115\104\97\105\114\32\84\104\105\99\107\110\101\115\115", Callback = function(l) _G.CrosshairThickness = l end, Min = 0, Max = 5, Def = 1, Menu = { Information = function() n:Banner({ Text = "\67\114\111\115\115\104\97\105\114\32\84\104\105\99\107\110\101\115\115" }) end } }) h:ColorPicker({ Text = "\67\114\111\115\115\104\97\105\114\32\67\111\108\111\114", Callback = function(m) _G.CrosshairColor = m end, Menu = { Information = function() n:Banner({ Text = "\67\114\111\115\115\104\97\105\114\32\67\111\108\111\114" }) end } }) h:Label({ Text = "\66\67\87\65\82\69\32\90\84\82\69\72\46\82\85", XAlignment = "\67\101\110\116\101\114", Menu = { Information = function() n:Banner({ Text = "\66\67\87\65\82\69\32\90\84\82\69\72\46\82\85" }) end } }) e:GuiSettings()
