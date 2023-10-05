--[[
credits:
made by vel
]]
local summonitemnames = set[1]

repeat task.wait() until game:IsLoaded()print("init")
local player = game:GetService("Players").LocalPlayer
if toggled == true then 
	player.Idled:Connect(function()game:GetService("VirtualUser"):ClickButton2(Vecter2.new())end)
end

local cf1 = CFrame.new(2,500,-0.5)
local cf2 = CFrame.new(0,1700,0)

local cf = cf2

repeat task.wait() until game:IsLoaded() print("init")
local player = game:GetService("Players").LocalPlayer
if toggled == true then 
	player.Idled:Connect(function()game:GetService("VirtualUser"):ClickButton2(Vecter2.new())end)
end

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
	a:FindFirstChild('RemoteFunction'):InvokeServer("ResetReviveCooldown")
	spawncompanion(a,b)
end

local function healcompanion(a)
	a:FindFirstChild('RemoteFunction'):InvokeServer("RestoreHealth")
end

local function ultcompanion(a)
	a:FindFirstChild('RemoteFunction'):InvokeServer("UltimateAttackPermit")
end

local function isacompanion(a)
	if a:FindFirstChild("RemoteFunction") then
		return true
	else
		return false
	end
end

local function calculatehp(a)
	if (a.Humanoid.MaxHealth/a.Humanoid.Health)*100 <= 25 then
		return true
	else
		return false
	end
end

local function revive(a,b,c)
	if isacompanion(c) == true then
		spawncompanion(a,b.CoName)
	else
		a.Parent = character
		click()
		a.Parent = player.Backpack
	end
end

local function startspawn()
	for _,item in pairs(summonitemnames) do
		local tool = player.Backpack:FindFirstChild(item.Name) or player.Character:FindFirstChild(item.Name)
		if tool then
			if not workspace:FindFirstChild(item.Spawn) then print('spawning '.. item.Spawns[i])
				cf = cf1
				if tool:FindFirstChild("RemoteFunction") then
					spawncompanion(tool,item.CoName)
				else
					tool.Parent = character
					click()
					tool.Parent = player.Backpack
				end
				task.wait(1)
				cf = cf2
			end
		end
	end
end

if game.PlaceId == 8811271345 then
	for _,base in pairs(workspace.Bases:GetChildren()) do
		if base.owner.Value == game.Players.LocalPlayer then print("khrysos solo script teleporting...")
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
					if s and calculatehp(s) and isacompanion(s) then
						healcompanion(tool)
					elseif not s then
						cf = cf1
						revive(tool,item,s)
						task.wait()
						cf = cf2
					end
				end
			end	 
		end
	end)()
	coroutine.wrap(function()
		while true do task.wait(.01)
			noclip()
			anchor(character.PrimaryPart)
			character:SetPrimaryPartCFrame(cf)
		end
	end)()
end
