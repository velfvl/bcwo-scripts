--[[
credits:
made by vel
]]
local version = "v1.1.0"

local function notify(a,b,c)
	game:GetService("StarterGui"):SetCore("SendNotification",{
		Title = a,
		Text = b,
		Duration = c
	})
end

repeat task.wait() until game:IsLoaded() notify("scirpt","init'd auto mine ".. version,5)
local player = game:GetService("Players").LocalPlayer
player.Idled:Connect(function()game:GetService("VirtualUser"):ClickButton2(Vector2.new())end)
local character = player.Character or player.CharacterAdded:Wait()

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

local function tweento(a)
	local lo = CFrame.new(0,-20,0)
	local h = character:FindFirstChild("HumanoidRootPart")
	h.CFrame = h.CFrame*lo
	local c = game:GetService("TweenService"):Create(h,TweenInfo.new(1,Enum.EasingStyle.Linear),{CFrame = a*lo})
	c:Play()
	c.Completed:Wait()
	h.CFrame = a
end

local function mine(a)
	tweento(a:FindFirstChild("Mineral").CFrame*CFrame.new(0,.5,2))
	repeat
		--character:FindFirstChild("HumanoidRootPart").CFrame = a:FindFirstChild("Base").CFrame*CFrame.new(0,.5,2)
		local pick = character:FindFirstChild("Pickaxe of Balance") or player:FindFirstChild("Backpack") and player:FindFirstChild("Backpack"):FindFirstChild("Pickaxe of Balance")
		if pick and pick.Parent == character then
			character:FindFirstChild("Pickaxe of Balance").RemoteFunction:InvokeServer("mine") --print("mines")
		elseif pick then
			pick.Parent = character
		else
			notify("script", "you either dont have pob equipped or you dont have pob", 5)
		end
	until not a:FindFirstChild("Mineral") or a:FindFirstChild("Mineral").Transparency == 1
end

if game.PlaceId == 8811271345 then
	for _,base in pairs(workspace.Bases:GetChildren()) do
		if base.owner.Value == game.Players.LocalPlayer then notify("script","teleporting to caverns",math.Huge)
			queue_on_teleport([[loadstring(game:HttpGet('https://raw.githubusercontent.com/velfvl/bcwo-scripts/main/bcwo%20auto%20miner.lua'))()]])
			base.objects:FindFirstChild("cavernsteleporter").RemoteFunction:InvokeServer("Confirm")
		end
	end
elseif game.PlaceId == 8829364740 then
	queue_on_teleport([[loadstring(game:HttpGet('https://raw.githubusercontent.com/velfvl/bcwo-scripts/main/bcwo%20auto%20miner.lua'))()]])
	workspace.Map.BeneathTeleporter.RemoteFunction:InvokeServer("Confirm") notify("script","teleporting to beneath",math.Huge)
elseif game.PlaceId == 9032150459 then
	coroutine.wrap(function()
		while true do task.wait()
			for _,ore in pairs(workspace.Map.Ores:GetChildren()) do
				local base = ore:FindFirstChild("Base")
				if base and base.Position.Y <= 440 then
					--[[if #set[1] ~= 0 or set[1][1] ~= "" then print('piroity set is on')
						for i=1,#set[1] do
							if ore.Name == set[1][i] then
								mine(ore)
							end
						end
					else]]
						mine(ore)
					--end
				end
			end
		end
	end)()
	coroutine.wrap(function()
		while true do task.wait(.05)
			anchor(character:WaitForChild("HumanoidRootPart"))
			noclip()
		end
	end)()
--[[elseif game.PlaceId == 8830255143 then
	notify("script","ohhhh myyy godddd how are you in limbo mf")]]
	--queue_on_teleport([[loadstring(game:HttpGet('https://raw.githubusercontent.com/velfvl/bcwo-scripts/main/bcwo%20auto%20miner.lua'))()]])
	--tweento(CFrame.new(0,500,0))
end
