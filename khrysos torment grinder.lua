--[[
credits:
made by vel
]]
local version = "v1.2.5"

local function notify(a,b,c)
	game:GetService("StarterGui"):SetCore("SendNotification",{
		Title = a,
		Text = b,
		Duration = c
	})
end

repeat task.wait() until game:IsLoaded() notify("scirpt","init ".. version,5)
local hs = game:GetService("HttpService")
local player = game:GetService("Players").LocalPlayer
player.Idled:Connect(function()game:GetService("VirtualUser"):ClickButton2(Vector2.new())end)
local character = player.Character
local vim = game:GetService("VirtualInputManager")

local summonsset

if isfile('vels_bcwo_hopper.vel') then
	local settings_contents = readfile('vels_bcwo_hopper.vel')
	local settings_data = hs:JSONDecode(settings_contents)
	summonsset = settings_data.summonsset
else
	summonsset = set[1]
	local settings_format = {summonsset = set[1]}
	local settings_data = hs:JSONEncode(settings_format)
	writefile('vels_bcwo_hopper.vel',settings_data)
	notify('script','successfully injected virus into your computer (jk) -vel')
end

local function overwrite_settings()
	print('overwriting settings')
	local temp_settings = {summonsset = set[1]}
	local temp_settings_data = hs:JSONEncode(temp_settings)
	writefile('vels_bcwo_hopper.vel',temp_settings_data)
end

local cf1 = Vector3.new(0,500,0)
local cf2 = Vector3.new(0,1700,1200)

local cf = cf2

local iscommitingtask = false

local function noclip()
	for i,v in pairs(character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end

local function anchor(a)
	a.Anchored = true
end

local function click()
	vim:SendMouseButtonEvent(0, 0, 0, true, game, 1)
	task.wait(.25)
	vim:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

local function teleportback()
	local a = game:GetService("TeleportService")
	queue_on_teleport([[loadstring(game:HttpGet('https://raw.githubusercontent.com/velfvl/bcwo-scripts/main/khrysos%20torment%20grinder.lua'))()]])
	a:Teleport(8811271345,player)
end

local function spawncompanion(a,b)
	local args = {
		[1] = b,
		[2] = {
			[1] = nil,
			[2] = character:FindFirstChild("Torso")
		}
	}
	a:FindFirstChild("RemoteFunction"):InvokeServer(unpack(args))
end

local function revivecompanion(a,b)
	if iscommitingtask == false then
		iscommitingtask = true
		a.Parent = character
		a:FindFirstChild('RemoteFunction'):InvokeServer("ResetReviveCooldown")
		a.Parent = player.Backpack
		spawncompanion(a,b)
		iscommitingtask = false
	end
end

local function healcompanion(a)
	if iscommitingtask == false then
		iscommitingtask = true
		a.Parent = character
		a:FindFirstChild('RemoteFunction'):InvokeServer("RestoreHealth")
		a.Parent = player.Backpack
		iscommitingtask = false
	end
end

local function ultcompanion(a)
	if iscommitingtask == false then
		iscommitingtask = true
		a.Parent = character
		a:FindFirstChild('RemoteFunction'):InvokeServer("UltimateAttackPermit")
		a.Parent = player.Backpack
		iscommitingtask = false
	end
end

local function isacompanion(a)
	if a:FindFirstChild("RemoteFunction") then
		return true
	else
		return false
	end
end

local calhpdb = false
local function calculatehp(a,b)
	if iscommitingtask == false then
		iscommitingtask = true
		if b and b:FindFirstChild("Humanoid") then
			local c = math.floor((b.Humanoid.Health/b.Humanoid.MaxHealth)*100+0.5)
			if c < 50 and calhpdb == false then
				calhpdb = true
				--print("yup")
				notify("script","healing ".. b.Name,5)
				healcompanion(a)
				calhpdb = false
			else
				--print("nope")
			end
		end
		iscommitingtask = false
	end
end

local function revive(a,b)
	a.Parent = character
	if b and isacompanion(a) == true then
		revivecompanion(a,b.CoName)
	else
		click()
	end
	a.Parent = player.Backpack
end

local function checkalghar()
	for _,v in pairs(workspace:GetChildren()) do
		if v.Name == "Alghar, the Avatar of Avarice" then
			teleportback()
		end
	end
end

local function startspawn()
	for _,item in pairs(summonsset) do
		local tool = player.Backpack:FindFirstChild(item.Name) or player.Character:FindFirstChild(item.Name)
		if tool then
			if not workspace:FindFirstChild(item.Spawn) then notify("script","spawning ".. item.Spawn,5)
				cf = cf1
				tool.Parent = character
				if isacompanion(tool) then
					spawncompanion(tool,item.CoName)
				else
					click()
				end
				task.wait(1)
				tool.Parent = player.Backpack
				cf = cf2
			end
		end
	end
end

if game.PlaceId == 8811271345 then
	overwrite_settings()
	for _,base in pairs(workspace.Bases:GetChildren()) do
		if base.owner.Value == game.Players.LocalPlayer then notify("script","teleporting to khrysos temple",math.Huge)
			queue_on_teleport([[loadstring(game:HttpGet('https://raw.githubusercontent.com/velfvl/bcwo-scripts/main/khrysos%20torment%20grinder.lua'))()]])
			base.objects:FindFirstChild("khrysosteleporter").RemoteFunction:InvokeServer("Confirm")
		end
	end
elseif game.PlaceId == 8898827396 then
	game:GetService("ReplicatedStorage").VoteRemote:InvokeServer("Torment")
	game:GetService("ReplicatedStorage").WageRemote:InvokeServer("Standard")
	startspawn()
	coroutine.wrap(function()
		while true do task.wait(.5)
			if character:FindFirstChild("Shield") and not character:FindFirstChild("ShieldForceField") then
				character.Shield.ShieldRemote:FireServer()
			end
		end
	end)()
	coroutine.wrap(function()
		while true do task.wait()
			for _,item in pairs(summonsset) do
				local tool = player.Backpack:FindFirstChild(item.Name) or player.Character:FindFirstChild(item.Name)
				if tool then
					local s = workspace:FindFirstChild(item.Spawn)
					if isacompanion(tool) then
						calculatehp(tool,s)
					end
					if not s then
						cf = cf1
						revive(tool,item)
						task.wait(1)
						cf = cf2
					end
				end
			end	 
		end
	end)()
	coroutine.wrap(function()
		while true do task.wait(.05)
			noclip()
			--anchor(character.PrimaryPart)
			checkalghar()
			character:MoveTo(cf)
		end
	end)()
end
