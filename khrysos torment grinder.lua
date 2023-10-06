--[[
credits:
made by vel
]]
local summonitemnames = set[1]

local cf1 = Vector3.new(0,500,0)
local cf2 = Vector3.new(0,1700,1200)

local cf = cf2

local function notify(a,b,c)
	game:GetService("StarterGui"):SetCore("SendNotification",{
		Title = a,
		Text = b,
		Duration = c
	})
end

repeat task.wait() until game:IsLoaded() notify("scirpt","init",5)
local player = game:GetService("Players").LocalPlayer
player.Idled:Connect(function()game:GetService("VirtualUser"):ClickButton2(Vecter2.new())end)

local character = player.Character
local vim = game:GetService("VirtualInputManager")

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
	a:TeleportAsync(8811271345,player)
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
	a.Parent = character
	a:FindFirstChild('RemoteFunction'):InvokeServer("ResetReviveCooldown")
	a.Parent = player.Backpack
	spawncompanion(a,b)
end

local function healcompanion(a)
	a.Parent = character
	a:FindFirstChild('RemoteFunction'):InvokeServer("RestoreHealth")
	a.Parent = player.Backpack
end

local function ultcompanion(a)
	a.Parent = character
	a:FindFirstChild('RemoteFunction'):InvokeServer("UltimateAttackPermit")
	a.Parent = player.Backpack
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
	if b and b:FindFirstChild("Humanoid") then
		local c = math.floor((b.Humanoid.Health/b.Humanoid.MaxHealth)*100+0.5)
		if c < 50 and calhpdb == false then
			calhpdb = true
			--print("yup")
			notify("script","healing ".. b.Name)
			healcompanion(a)
			calhpdb = false
		else
			--print("nope")
		end
	end
end

local function revive(a,b)
	a.Parent = character
	if b and isacompanion(a) == true then
		spawncompanion(a,b.CoName)
	else
		click()
	end
	a.Parent = player.Backpack
end

local function startspawn()
	for _,item in pairs(summonitemnames) do
		local tool = player.Backpack:FindFirstChild(item.Name) or player.Character:FindFirstChild(item.Name)
		if tool then
			if not workspace:FindFirstChild(item.Spawn) then notify("script","spawning ".. item.Spawn)
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
	for _,base in pairs(workspace.Bases:GetChildren()) do
		if base.owner.Value == game.Players.LocalPlayer then notify("script","teleporting to khrysos temple",math.Huge)
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
			for _,item in pairs(summonitemnames) do
				local tool = player.Backpack:FindFirstChild(item.Name) or player.Character:FindFirstChild(item.Name)
				if tool then
					local s = workspace:FindFirstChild(item.Spawn)
					if isacompanion(tool) then
						calculatehp(tool,s)
					end
					if not s then
						cf = cf1
						revive(tool,item)
						task.wait()
						cf = cf2
					end
				end
			end	 
		end
	end)()
	coroutine.wrap(function()
		while true do task.wait(.1)
			noclip()
			--anchor(character.PrimaryPart)
			character:MoveTo(cf)
		end
	end)()
end
