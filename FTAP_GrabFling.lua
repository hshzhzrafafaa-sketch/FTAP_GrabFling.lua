-- FTAP GRAB FLING + ANTI GRAB + ESP
-- Toggle ON/OFF | Power 1 - 999999
-- Auto fling SAAT GRAB (sekali lempar)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local enabled = false
local espEnabled = false
local power = 5000
local lastFling = {}

-- ===== UI =====
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FTAP_GrabFling"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 240)
frame.Position = UDim2.new(0.05, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "FTAP GRAB FLING"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.9,0,0,36)
toggle.Position = UDim2.new(0.05,0,0.18,0)
toggle.Text = "SCRIPT : OFF"
toggle.BackgroundColor3 = Color3.fromRGB(170,0,0)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.SourceSansBold
toggle.TextSize = 16

local espBtn = Instance.new("TextButton", frame)
espBtn.Size = UDim2.new(0.9,0,0,36)
espBtn.Position = UDim2.new(0.05,0,0.36,0)
espBtn.Text = "ESP : OFF"
espBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
espBtn.TextColor3 = Color3.new(1,1,1)
espBtn.Font = Enum.Font.SourceSansBold
espBtn.TextSize = 16

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.9,0,0,34)
box.Position = UDim2.new(0.05,0,0.56,0)
box.PlaceholderText = "POWER (1 - 999999)"
box.Text = tostring(power)
box.Font = Enum.Font.SourceSans
box.TextSize = 15
box.TextColor3 = Color3.new(1,1,1)
box.BackgroundColor3 = Color3.fromRGB(40,40,40)

-- ===== EVENTS =====
toggle.MouseButton1Click:Connect(function()
	enabled = not enabled
	toggle.Text = enabled and "SCRIPT : ON" or "SCRIPT : OFF"
	toggle.BackgroundColor3 = enabled and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
end)

espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espBtn.Text = espEnabled and "ESP : ON" or "ESP : OFF"
	espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0,120,200) or Color3.fromRGB(60,60,60)
end)

box.FocusLost:Connect(function()
	local v = tonumber(box.Text)
	if v then
		power = math.clamp(v, 1, 999999)
		box.Text = tostring(power)
	end
end)

-- ===== ANTI GRAB =====
local function setAntiGrab(on)
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	if on then
		if not hrp:FindFirstChild("AntiGrabBV") then
			local bv = Instance.new("BodyVelocity", hrp)
			bv.Name = "AntiGrabBV"
			bv.MaxForce = Vector3.new(1e9,1e9,1e9)
			bv.Velocity = Vector3.new()
			local bg = Instance.new("BodyGyro", hrp)
			bg.Name = "AntiGrabBG"
			bg.MaxTorque = Vector3.new(1e9,1e9,1e9)
			bg.CFrame = hrp.CFrame
		end
	else
		if hrp:FindFirstChild("AntiGrabBV") then hrp.AntiGrabBV:Destroy() end
		if hrp:FindFirstChild("AntiGrabBG") then hrp.AntiGrabBG:Destroy() end
	end
end

-- ===== ESP =====
local espFolder = Instance.new("Folder", gui)
espFolder.Name = "ESP"

local function clearESP()
	for _,v in ipairs(espFolder:GetChildren()) do v:Destroy() end
end

local function makeESP(plr)
	if plr == LocalPlayer then return end
	local char = plr.Character
	if not char then return end
	local head = char:FindFirstChild("Head")
	if not head then return end

	local bill = Instance.new("BillboardGui", espFolder)
	bill.Adornee = head
	bill.Size = UDim2.new(0,200,0,40)
	bill.AlwaysOnTop = true

	local txt = Instance.new("TextLabel", bill)
	txt.Size = UDim2.new(1,0,1,0)
	txt.BackgroundTransparency = 1
	txt.TextColor3 = Color3.new(1,0,0)
	txt.TextStrokeTransparency = 0
	txt.Font = Enum.Font.SourceSansBold
	txt.TextSize = 14

	RunService.RenderStepped:Connect(function()
		if not espEnabled or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
			bill:Destroy()
			return
		end
		local d = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
		txt.Text = plr.Name.." ["..math.floor(d).."]"
	end)
end

-- ===== MAIN LOOP =====
task.spawn(function()
	while task.wait(0.1) do
		if enabled then
			setAntiGrab(true)
			if espEnabled then
				clearESP()
				for _,p in ipairs(Players:GetPlayers()) do makeESP(p) end
			else
				clearESP()
			end
		else
			setAntiGrab(false)
			clearESP()
		end
	end
end)
