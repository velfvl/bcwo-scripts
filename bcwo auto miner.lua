--[[
credits:
made by vel
]]
local version = "v1.0.8"

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
local character = player.Character

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

local function tweento(a,b)
	local c = game:GetService("TweenService"):Create(a:FindFirstChild("HumanoidRootPart"),TweenInfo.new(1,Enum.EasingStyle.Linear),{CFrame = b.CFrame})
	c:Play()
	c.Completed:Wait()
end

local function mine(a)
	tweento(character,a:FindFirstChild("Base"))
	repeat
		local pick = character:FindFirstChild("Pickaxe of Balance") or player:FindFirstChild("Backpack") and player:FindFirstChild("Backpack"):FindFirstChild("Pickaxe of Balance")
		if pick and pick.Parent == character then
			character:FindFirstChild("Pickaxe of Balance").RemoteFunction:InvokeServer("mine")
		else
			pick.Parent = character
		end
	until not a:FindFirstChild("Base") or a:FindFirstChild("Base").Transparency == 1
end

coroutine.wrap(function()
	while true do task.wait()
		for _,ore in pairs(workspace.Map.Ores:GetChildren()) do
			local base = ore:FindFirstChild("Base")
			if base and base.Position.Y <= 440 then
				if #set[1] ~= 0 or set[1][1] ~= "" then 
					for i=1,#set[1] do
						if ore.Name == set[1][i] then
							mine(ore)
						end
					end
				else
					mine(ore)
				end
			end
		end
	end
end)()

coroutine.wrap(function()
	while true do task.wait(.05)
		noclip()
		anchor(character:FindFirstChild("HumanoidRootPart"))
	end
end)()
