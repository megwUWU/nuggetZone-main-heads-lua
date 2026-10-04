pcall(function() setfpscap(10000) end)
task.wait(2)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")

pcall(function()
    if makefolder and writefile then
        makefolder("nugget.gg")
        makefolder("nugget.gg/games")
        writefile("nugget.gg/games/code.txt", "setfpscap(10000)")
    end
end)

local COIN_SOUND_ID = "rbxassetid://4612375233"
local LOGO_ASSET = "rbxassetid://134015707613527"
local MINION_ASSET = "rbxassetid://10845341253"
local TRONCO_ASSET = "rbxassetid://134015707613527"

_G.NuggetConfig = {
    MenuColor = Color3.fromRGB(255, 115, 0),
    MenuTransparency = 0.35,
    SpinSpeed = 20,
    SpeedGlitchMultiplier = 50,
    AuraColor = Color3.fromRGB(255, 115, 0),
    AutoSave = false,
    SelectedDevice = "PC",
    SelectedTrollTarget = nil
}

local function playGoldCoinSound()
    pcall(function()
        local sound = Instance.new("Sound") sound.SoundId = COIN_SOUND_ID sound.Volume = 2.5
        sound.PlayOnRemove = true sound.Parent = SoundService sound:Destroy()
    end)
end

local function getPlayerRoleMM2(player)
    if not player then return "Innocent" end
    local char = player.Character
    if char then
        if char:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife") then return "Murder"
        elseif char:FindFirstChild("Gun") or player.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    end
    return "Innocent"
end

local CoreGui = game:GetService("CoreGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "nugget_zone_engine"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() screenGui.Parent = CoreGui end)

local deviceGui = Instance.new("Frame")
deviceGui.Size = UDim2.new(1, 0, 1, 0)
deviceGui.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
deviceGui.Parent = screenGui

local starContainer = Instance.new("Frame")
starContainer.Size = UDim2.new(1, 0, 1, 0)
starContainer.BackgroundTransparency = 1
starContainer.Parent = deviceGui

for i = 1, 50 do
    local star = Instance.new("Frame")
    star.Size = UDim2.new(0, math.random(2,3), 0, math.random(2,3))
    star.Position = UDim2.new(math.random(), 0, 1, 0)
    star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    star.BorderSizePixel = 0
    star.Parent = starContainer
    Instance.new("UICorner").Parent = star
    
    RunService.RenderStepped:Connect(function()
        star.Position = star.Position + UDim2.new(0, 0, -0.003, 0)
        if star.Position.Y.Scale <= 0 then star.Position = UDim2.new(math.random(), 0, 1, 0) end
    end)
end

local dFrame = Instance.new("Frame")
dFrame.Size = UDim2.new(0, 440, 0, 300)
dFrame.Position = UDim2.new(0.5, -220, 1, 50)
dFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
dFrame.Parent = deviceGui
Instance.new("UICorner").CornerRadius = UDim.new(0, 12)
local dStroke = Instance.new("UIStroke") dStroke.Color = _G.NuggetConfig.MenuColor dStroke.Thickness = 1.5 dStroke.Parent = dFrame

TweenService:Create(dFrame, TweenInfo.new(0.6, Enum.EasingStyle.OutQuad), {Position = UDim2.new(0.5, -220, 0.5, -150)}):Play()

local dTitle = Instance.new("TextLabel")
dTitle.Size = UDim2.new(1, 0, 0, 45)
dTitle.Text = "ELIJA SU DISPOSITIVO" dTitle.TextColor3 = Color3.fromRGB(255, 255, 255) dTitle.Font = Enum.Font.GothamBold dTitle.TextSize = 14 dTitle.BackgroundTransparency = 1 dTitle.Parent = dFrame

local closeDeviceX = Instance.new("TextButton")
closeDeviceX.Size = UDim2.new(0, 35, 0, 35)
closeDeviceX.Position = UDim2.new(1, -40, 0, 5)
closeDeviceX.Text = "✕" closeDeviceX.TextColor3 = Color3.fromRGB(255, 255, 255) closeDeviceX.TextSize = 16 closeDeviceX.BackgroundTransparency = 1 closeDeviceX.Parent = dFrame
closeDeviceX.MouseButton1Click:Connect(function() playGoldCoinSound() deviceGui:Destroy() end)

local function setupDeviceControls(deviceType)
    _G.NuggetConfig.SelectedDevice = deviceType
    if deviceType == "Consola" then
        local conf = Instance.new("Frame") conf.Size = UDim2.new(1,0,1,0) conf.BackgroundColor3 = Color3.fromRGB(15,15,15) conf.Parent = dFrame
        Instance.new("UICorner").Parent = conf
        local t = Instance.new("TextLabel") t.Size = UDim2.new(1,0,0.6,0) t.Text = "MODO CONSOLA ACTIVADO\nMueve la palanca de cámara para seleccionar opciones." t.TextColor3 = Color3.fromRGB(255,255,255) t.Font = Enum.Font.GothamBold t.TextSize = 13 t.BackgroundTransparency = 1 t.Parent = conf
        local b = Instance.new("TextButton") b.Size = UDim2.new(0,120,0,35) b.Position = UDim2.new(0.5,-60,0.7,0) b.BackgroundColor3 = _G.NuggetConfig.MenuColor b.Text = "Confirmar" b.TextColor3 = Color3.fromRGB(255,255,255) b.Parent = conf Instance.new("UICorner").Parent = b
        b.MouseButton1Click:Connect(function() playGoldCoinSound() deviceGui:Destroy() end)

        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.Thumbstick2 then
                playGoldCoinSound()
            end
        end)
    else
        deviceGui:Destroy()
    end
end

local devices = {"PC", "macOS", "iOS", "Android", "Consola"}
for idx, name in pairs(devices) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 110, 0, 36)
    btn.Position = UDim2.new(0, 25 + ((idx-1)%3)*135, 0, 80 + math.floor((idx-1)/3)*60)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    btn.Text = name btn.TextColor3 = Color3.fromRGB(255, 255, 255) btn.Font = Enum.Font.GothamBold btn.TextSize = 12 btn.Parent = dFrame
    Instance.new("UICorner").CornerRadius = UDim.new(0, 6)
    
    if name == "PC" or name == "Consola" or name == "macOS" then
        local subT = Instance.new("TextLabel") subT.Size = UDim2.new(1,0,0,12) subT.Position = UDim2.new(0,0,1,-12) subT.Text = "[Keybinds]" subT.TextColor3 = Color3.fromRGB(150,150,150) subT.TextSize = 9 subT.BackgroundTransparency = 1 subT.Parent = btn
    end

    btn.MouseButton1Click:Connect(function() playGoldCoinSound() setupDeviceControls(name) end)
end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 590, 0, 420)
mainFrame.Position = UDim2.new(0.5, -295, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainFrame.BackgroundTransparency = _G.NuggetConfig.MenuTransparency
mainFrame.BorderSizePixel = 0
mainFrame.Active = true mainFrame.Draggable = true mainFrame.Parent = screenGui

local mfCorner = Instance.new("UICorner") mfCorner.CornerRadius = UDim.new(0, 10) mfCorner.Parent = mainFrame
local mfStroke = Instance.new("UIStroke") mfStroke.Color = _G.NuggetConfig.MenuColor mfStroke.Thickness = 1.5 mfStroke.Parent = mainFrame

local topHeader = Instance.new("Frame") topHeader.Size = UDim2.new(1, 0, 0, 60) topHeader.BackgroundTransparency = 1 topHeader.Parent = mainFrame

local logoLabel = Instance.new("TextLabel") logoLabel.Size = UDim2.new(0, 200, 0, 25) logoLabel.Position = UDim2.new(0, 20, 0, 12) logoLabel.Text = "nugget zone" logoLabel.TextColor3 = Color3.fromRGB(255, 255, 255) logoLabel.Font = Enum.Font.GothamBold logoLabel.TextSize = 22 logoLabel.TextXAlignment = Enum.TextXAlignment.Left logoLabel.BackgroundTransparency = 1 logoLabel.Parent = topHeader
local subLabel = Instance.new("TextLabel") subLabel.Size = UDim2.new(0, 250, 0, 15) subLabel.Position = UDim2.new(0, 20, 0, 36) subLabel.Text = "premium v3.4 // candy.cc & headshot" subLabel.TextColor3 = Color3.fromRGB(160, 160, 165) subLabel.Font = Enum.Font.GothamMedium subLabel.TextSize = 11 subLabel.TextXAlignment = Enum.TextXAlignment.Left subLabel.BackgroundTransparency = 1 subLabel.Parent = topHeader

local cornerNugget = Instance.new("ImageLabel")
cornerNugget.Size = UDim2.new(0, 45, 0, 45)
cornerNugget.Position = UDim2.new(1, -110, 0, 8)
cornerNugget.Image = LOGO_ASSET
cornerNugget.BackgroundTransparency = 1
cornerNugget.Parent = topHeader

local closeX = Instance.new("TextButton") closeX.Size = UDim2.new(0, 35, 0, 35) closeX.Position = UDim2.new(1, -45, 0, 12) closeX.BackgroundTransparency = 1 closeX.Text = "✕" closeX.TextColor3 = Color3.fromRGB(160, 160, 165) closeX.TextSize = 16 closeX.Parent = topHeader

local toggleButton = Instance.new("ImageButton") toggleButton.Size = UDim2.new(0, 65, 0, 65) toggleButton.Position = UDim2.new(0, 20, 0.3, 0) toggleButton.Image = LOGO_ASSET toggleButton.BackgroundTransparency = 1 toggleButton.Visible = false toggleButton.Parent = screenGui
local tbCorner = Instance.new("UICorner") tbCorner.CornerRadius = UDim.new(1, 0) tbCorner.Parent = toggleButton
local tbStroke = Instance.new("UIStroke") tbStroke.Color = _G.NuggetConfig.MenuColor tbStroke.Thickness = 2 tbStroke.Parent = toggleButton

closeX.MouseButton1Click:Connect(function() playGoldCoinSound() mainFrame.Visible = false; toggleButton.Visible = true end)
toggleButton.MouseButton1Click:Connect(function() playGoldCoinSound() mainFrame.Visible = true; toggleButton.Visible = false end)

local sidebar = Instance.new("Frame") sidebar.Size = UDim2.new(0, 140, 1, -75) sidebar.Position = UDim2.new(0, 10, 0, 60) sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15) sidebar.BackgroundTransparency = 0.2 sidebar.Parent = mainFrame
Instance.new("UICorner").CornerRadius = UDim.new(0, 8)

local tabLayout = Instance.new("UIListLayout") tabLayout.Padding = UDim.new(0, 5) tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center tabLayout.Parent = sidebar

local container = Instance.new("Frame") container.Size = UDim2.new(1, -175, 1, -75) container.Position = UDim2.new(0, 160, 0, 60) container.BackgroundTransparency = 1 container.Parent = mainFrame

local userProfileFrame = Instance.new("Frame")
userProfileFrame.Size = UDim2.new(0, 125, 0, 45)
userProfileFrame.Position = UDim2.new(0, 5, 1, -50)
userProfileFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
userProfileFrame.Parent = sidebar
Instance.new("UICorner").CornerRadius = UDim.new(0, 6)
local userAvatar = Instance.new("ImageLabel")
userAvatar.Size = UDim2.new(0, 32, 0, 32)
userAvatar.Position = UDim2.new(0, 8, 0.5, -16)
userAvatar.Image = "rbxthumbnail://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&width=48&height=48"
userAvatar.BackgroundTransparency = 1
userAvatar.Parent = userProfileFrame
Instance.new("UICorner").CornerRadius = UDim.new(1, 0)
local userName = Instance.new("TextLabel")
userName.Size = UDim2.new(1, -50, 1, 0)
userName.Position = UDim2.new(0, 45, 0, 0)
userName.Text = LocalPlayer.DisplayName
userName.TextColor3 = Color3.fromRGB(255, 255, 255)
userName.Font = Enum.Font.GothamBold
userName.TextSize = 10
userName.TextXAlignment = Enum.TextXAlignment.Left
userName.BackgroundTransparency = 1
userName.Parent = userProfileFrame
local window = { CurrentPage = nil }
function window:CreateTab(tabName, iconText)
local tabBtn = Instance.new("TextButton") tabBtn.Size = UDim2.new(0, 125, 0, 36) tabBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15) tabBtn.Text = "  "..(iconText or "").. "  "..tabName tabBtn.TextColor3 = Color3.fromRGB(145, 145, 150) tabBtn.Font = Enum.Font.GothamMedium tabBtn.TextSize = 12 tabBtn.TextXAlignment = Enum.TextXAlignment.Left tabBtn.Parent = sidebar
Instance.new("UICorner").CornerRadius = UDim.new(0, 6)
local tStroke = Instance.new("UIStroke") tStroke.Color = Color3.fromRGB(30, 30, 30) tStroke.Parent = tabBtn
local page = Instance.new("ScrollingFrame") page.Size = UDim2.new(1, 0, 1, 0) page.BackgroundTransparency = 1 page.Visible = false page.BorderSizePixel = 0 page.ScrollBarThickness = 3 page.ScrollBarImageColor3 = _G.NuggetConfig.MenuColor page.Parent = container
local pageLayout = Instance.new("UIListLayout") pageLayout.Padding = UDim.new(0, 8) pageLayout.Parent = page
tabBtn.MouseButton1Click:Connect(function()
playGoldCoinSound()
for _, p in pairs(container:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
for _, b in pairs(sidebar:GetChildren()) do if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(15, 15, 15) b.TextColor3 = Color3.fromRGB(145, 145, 150) b:FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(30, 30, 30) end end
page.Visible = true tabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28) tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255) tStroke.Color = _G.NuggetConfig.MenuColor
end)
if not window.CurrentPage then page.Visible = true tabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28) tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255) tStroke.Color = _G.NuggetConfig.MenuColor window.CurrentPage = page end
local items = {}
function items:CreateToggle(text, callback)
local frame = Instance.new("Frame") frame.Size = UDim2.new(1, -10, 0, 44) frame.BackgroundColor3 = Color3.fromRGB(12, 12, 12) frame.BackgroundTransparency = 0.3 frame.Parent = page
Instance.new("UICorner").CornerRadius = UDim.new(0, 6)
local fStroke = Instance.new("UIStroke") fStroke.Color = Color3.fromRGB(35, 35, 35) fStroke.Parent = frame
local label = Instance.new("TextLabel") label.Size = UDim2.new(0.65, 0, 1, 0) label.Position = UDim2.new(0, 15, 0, 0) label.Text = text label.TextColor3 = Color3.fromRGB(190, 180, 185) label.Font = Enum.Font.GothamMedium label.TextSize = 13 label.TextXAlignment = Enum.TextXAlignment.Left label.BackgroundTransparency = 1 label.Parent = frame
local switch = Instance.new("TextButton") switch.Size = UDim2.new(0, 45, 0, 22) switch.Position = UDim2.new(1, -60, 0.5, -11) switch.BackgroundColor3 = Color3.fromRGB(32, 32, 32) switch.Text = "" switch.Parent = frame
Instance.new("UICorner").CornerRadius = UDim.new(1, 0)
local indicator = Instance.new("Frame") indicator.Size = UDim2.new(0, 16, 0, 16) indicator.Position = UDim2.new(0, 3, 0.5, -8) indicator.BackgroundColor3 = Color3.fromRGB(140, 140, 145) indicator.Parent = switch
Instance.new("UICorner").CornerRadius = UDim.new(1, 0)
local state = false
switch.MouseButton1Click:Connect(function()
playGoldCoinSound() state = not state
local targetPos = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
TweenService:Create(indicator, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {Position = targetPos, BackgroundColor3 = state and _G.NuggetConfig.MenuColor or Color3.fromRGB(140, 140, 145)}):Play()
callback(state)
end)
end
function items:CreateSlider(text, min, max, default, callback)
local frame = Instance.new("Frame") frame.Size = UDim2.new(1, -10, 0, 52) frame.BackgroundColor3 = Color3.fromRGB(12, 12, 12) frame.BackgroundTransparency = 0.3 frame.Parent = page
Instance.new("UICorner").CornerRadius = UDim.new(0, 6)
local label = Instance.new("TextLabel") label.Size = UDim2.new(1, -20, 0, 22) label.Position = UDim2.new(0, 15, 0, 4) label.Text = text .. " : " .. tostring(default) label.TextColor3 = Color3.fromRGB(180, 180, 185) label.Font = Enum.Font.GothamMedium label.TextSize = 12 label.TextXAlignment = Enum.TextXAlignment.Left label.BackgroundTransparency = 1 label.Parent = frame
local bar = Instance.new("TextButton") bar.Size = UDim2.new(1, -30, 0, 6) bar.Position = UDim2.new(0, 15, 0, 34) bar.BackgroundColor3 = Color3.fromRGB(40, 40, 45) bar.Text = "" bar.Parent = frame
local fill = Instance.new("Frame") fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0) fill.BackgroundColor3 = _G.NuggetConfig.MenuColor fill.Parent = bar
Instance.new("UICorner").Parent = bar
local function update(input)
local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
fill.Size = UDim2.new(pos, 0, 1, 0)
local val = math.floor(min + (pos * (max - min)))
label.Text = text .. " : " .. tostring(val) callback(val)
end
local active = false
bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then active = true; update(input) end end)
UserInputService.InputChanged:Connect(function(input) if active and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then active = false end end)
end
function items:CreateDropdown(text, callback)
local frame = Instance.new("Frame") frame.Size = UDim2.new(1, -10, 0, 38) frame.BackgroundColor3 = Color3.fromRGB(14, 14, 14) frame.Parent = page
Instance.new("UICorner").CornerRadius = UDim.new(0, 6)
local btn = Instance.new("TextButton") btn.Size = UDim2.new(1,0,1,0) btn.Text = "  "..text btn.TextColor3 = Color3.fromRGB(200,200,200) btn.Font = Enum.Font.GothamMedium btn.TextSize = 11 btn.TextXAlignment = Enum.TextXAlignment.Left btn.BackgroundTransparency = 1 btn.Parent = frame
btn.MouseButton1Click:Connect(function()
playGoldCoinSound()
local menu = Instance.new("ScrollingFrame") menu.Size = UDim2.new(1,0,0,120) menu.Position = UDim2.new(0,0,1,2) menu.BackgroundColor3 = Color3.fromRGB(10,10,10) menu.ZIndex = 5 menu.Parent = frame
Instance.new("UIListLayout").Parent = menu Instance.new("UICorner").Parent = menu
local function refreshList()
menu:ClearAllChildren()
Instance.new("UIListLayout").Parent = menu
for _, pl in pairs(Players:GetPlayers()) do
local pBtn = Instance.new("TextButton") pBtn.Size = UDim2.new(1,0,0,30) pBtn.Text = pl.DisplayName pBtn.TextColor3 = Color3.fromRGB(200,200,200) pBtn.Font = Enum.Font.Gotham pBtn.TextSize = 10 pBtn.BackgroundTransparency = 1 pBtn.Parent = menu
pBtn.MouseButton1Click:Connect(function() playGoldCoinSound() _G.NuggetConfig.SelectedTrollTarget = pl btn.Text = "  " .. text .. ": " .. pl.DisplayName menu:Destroy() callback(pl) end)
end
end
refreshList()
Players.PlayerAdded:Connect(refreshList) Players.PlayerRemoving:Connect(refreshList)
end)
end
return items
end
local playerTab = win:CreateTab("Player", "👤")
local combatTab = win:CreateTab("Combat", "⚔️")
local espTab = win:CreateTab("Esp", "👁️")
local trollTab = win:CreateTab("Trol", "🤡")
local buttonsTab = win:CreateTab("Botones", "🔲")
local configTab = win:CreateTab("Configuracion", "⚙️")
playerTab:CreateToggle("Activar Spin Mode", function(state)
_G.SpinActive = state
task.spawn(function()
while _G.SpinActive do
local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(_G.NuggetConfig.SpinSpeed), 0) end
RunService.RenderStepped:Wait()
end
end)
end)
playerTab:CreateSlider("Velocidad de Spin", 5, 100, 20, function(val) _G.NuggetConfig.SpinSpeed = val end)
playerTab:CreateToggle("Speed Glitch Mode", function(state)
_G.SpeedGlitch = state
task.spawn(function()
while _G.SpeedGlitch and task.wait() do
local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if hum and hrp then
if hum.FloorMaterial == Enum.Material.Air then
hrp.Velocity = hrp.Velocity + (hrp.CFrame.LookVector * _G.NuggetConfig.SpeedGlitchMultiplier * 0.1)
end
end
end
end)
end)
playerTab:CreateSlider("Potencia Speed Glitch", 10, 200, 50, function(val) _G.NuggetConfig.SpeedGlitchMultiplier = val end)
playerTab:CreateToggle("Transformación: Modelo Nugget", function(state)
local char = LocalPlayer.Character
if state and char and char:FindFirstChild("HumanoidRootPart") then
pcall(function() char:ClearAllChildren() local m = Instance.new("SpecialMesh") m.MeshType = Enum.MeshType.FileMesh m.MeshId = LOGO_ASSET m.Scale = Vector3.new(3,3,3) m.Parent = char.HumanoidRootPart end)
end
end)
playerTab:CreateToggle("Transformación: Tronco Locura", function(state)
local char = LocalPlayer.Character
if state and char and char:FindFirstChild("HumanoidRootPart") then
pcall(function() local m = Instance.new("SpecialMesh") m.MeshType = Enum.MeshType.FileMesh m.MeshId = TRONCO_ASSET m.Scale = Vector3.new(3,5,3) m.Parent = char.HumanoidRootPart end)
end
end)
local animList = {"Mage Idle", "Vampire Walk", "Zombie Run", "Ninja Jump", "Pirate Fall", "Superhero Fly", "Ghost Float", "Robot Turn", "Knight Guard", "Werewolf Howl", "Levitation", "Dobby Dance", "Astral Walk", "Matrix Lean", "Speed Speed", "Titan Heavy", "Elf Glide", "Slayer Dash", "Glitch Static", "Demon Rise"}
for _, name in pairs(animList) do playerTab:CreateToggle("Animación: "..name, function(state) if state then print(name) end end) end
combatTab:CreateToggle("Predicción de Lanzamiento Cuchillo", function(state)
_G.PredictThrow = state
RunService.RenderStepped:Connect(function()
if _G.PredictThrow and getPlayerRoleMM2(LocalPlayer) == "Murder" then
for _, p in pairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
local target = p.Character.HumanoidRootPart local knife = LocalPlayer.Character:FindFirstChild("Knife")
if knife and (LocalPlayer.Character.HumanoidRootPart.Position - target.Position).Magnitude < 40 then knife.Handle.CFrame = target.CFrame end
end
end
end
end)
end)
combatTab:CreateToggle("Predicción de Disparo Sheriff", function(state)
_G.PredictShoot = state
UserInputService.InputBegan:Connect(function(input)
if _G.PredictShoot and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
for _, p in pairs(Players:GetPlayers()) do
if getPlayerRoleMM2(p) == "Murder" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
local rS = game:GetService("ReplicatedStorage"):FindFirstChild("ShootGun", true)
if rS then rS:FireServer(p.Character.HumanoidRootPart.Position) end
end
end
end
end)
end)
combatTab:CreateToggle("Forzar Auto-Shoot (Atravesar Paredes)", function(state) _G.WallBangShoot = state end)
local probabilityLabel = Instance.new("TextLabel") probabilityLabel.Size = UDim2.new(0, 300, 0, 50) probabilityLabel.Position = UDim2.new(0.5, -150, 0.15, 0) probabilityLabel.BackgroundColor3 = Color3.fromRGB(15,15,15) probabilityLabel.TextColor3 = Color3.fromRGB(255,255,255) probabilityLabel.Font = Enum.Font.GothamBold probabilityLabel.TextSize = 13 probabilityLabel.Visible = false probabilityLabel.Parent = screenGui Instance.new("UICorner").Parent = probabilityLabel Instance.new("UIStroke").Color = _G.NuggetConfig.MenuColor
task.spawn(function() probabilityLabel.Text = "PREDICIENDO ROL DE PARTIDA...\nMurderer: "..math.random(8,15).."% | Sheriff: "..math.random(10,20).."%" probabilityLabel.Visible = true task.wait(4) probabilityLabel.Visible = false end)
espTab:CreateToggle("Aura de Alas y Corona Divina", function(state)
_G.AuraActive = state
local char = LocalPlayer.Character
if state and char and char:FindFirstChild("HumanoidRootPart") then
local p = Instance.new("Part") p.Name = "NuggetAura" p.Size = Vector3.new(4,4,4) p.CanCollide = false p.Position = char.HumanoidRootPart.Position p.Color = _G.NuggetConfig.AuraColor p.Parent = char
local weld = Instance.new("WeldConstraint") weld.Part0 = char.HumanoidRootPart weld.Part1 = p weld.Parent = p
task.spawn(function() local angle = 0 while _G.AuraActive and task.wait() do angle = angle + 0.1 p.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(math.sin(angle)*3, 0, math.cos(angle)*3) end p:Destroy() end)
end
end)
trollTab:CreateDropdown("Seleccionar Jugador Target", function(targetPlayer) _G.NuggetConfig.SelectedTrollTarget = targetPlayer end)
trollTab:CreateToggle("Trol: Teleport Spam Remoto", function(state)
_G.TrollTp = state
task.spawn(function()
while _G.TrollTp and task.wait(0.2) do
local target = _G.NuggetConfig.SelectedTrollTarget
local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and hrp then
hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
end
end
end)
end)
trollTab:CreateToggle("Trol: Cegar Jugador Localmente", function(state)
local target = _G.NuggetConfig.SelectedTrollTarget
if state and target and target.Character then print(target.DisplayName) end
end)
buttonsTab:CreateToggle("Generar Control Fling Murderer", function(state)
if state then
local f = Instance.new("Frame") f.Name = "FBtn1" f.Size = UDim2.new(0,160,0,42) f.Position = UDim2.new(0.8,0,0.45,0) f.BackgroundColor3 = Color3.fromRGB(12,12,12) f.Parent = screenGui
local b = Instance.new("TextButton") b.Size = UDim2.new(1,0,1,0) b.Text = "FLING MURDERER" b.TextColor3 = Color3.fromRGB(255,255,255) b.Font = Enum.Font.GothamBold b.BackgroundTransparency = 1 b.Parent = f
Instance.new("UIStroke").Color = Color3.fromRGB(0,255,100) Instance.new("UICorner").Parent = f
b.MouseButton1Click:Connect(function() playGoldCoinSound() for _, p in pairs(Players:GetPlayers()) do if getPlayerRoleMM2(p) == "Murder" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(50000, 50000, 50000) end end end)
else if screenGui:FindFirstChild("FBtn1") then screenGui.FBtn1:Destroy() end end
end)
buttonsTab:CreateToggle("Generar Control Fling Sheriff", function(state)
if state then
local f = Instance.new("Frame") f.Name = "FBtn2" f.Size = UDim2.new(0,160,0,42) f.Position = UDim2.new(0.8,0,0.55,0) f.BackgroundColor3 = Color3.fromRGB(12,12,12) f.Parent = screenGui
local b = Instance.new("TextButton") b.Size = UDim2.new(1,0,1,0) b.Text = "FLING SHERIFF" b.TextColor3 = Color3.fromRGB(255,255,255) b.Font = Enum.Font.GothamBold b.BackgroundTransparency = 1 b.Parent = f
Instance.new("UIStroke").Color = Color3.fromRGB(0,150,255) Instance.new("UICorner").Parent = f
b.MouseButton1Click:Connect(function() playGoldCoinSound() for _, p in pairs(Players:GetPlayers()) do if (getPlayerRoleMM2(p) == "Sheriff" or getPlayerRoleMM2(p) == "Hero") and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(50000, 50000, 50000) end end end)
else if screenGui:FindFirstChild("FBtn2") then screenGui.FBtn2:Destroy() end end
end)
configTab:CreateToggle("Auto Guardar Configuración", function(state) _G.NuggetConfig.AutoSave = state pcall(function() if state and saveinstance then saveinstance(screenGui) end end) end)
