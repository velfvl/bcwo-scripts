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

repeat task.wait() until game:IsLoaded() notify("scirpt","init ".. version,5)
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

noclip()
anchor(character:FindFirstChild("HumanoidRootPart"))
while true do task.wait()
	for _,ore in pairs(workspace.Map.Ores:GetChildren()) do
		local base = ore:FindFirstChild("Base")
		if base and base.Position.Y <= 440 then
			tweento(character,base)
			repeat
				local pick = character:FindFirstChild("Pickaxe of Balance") or player:FindFirstChild("Backpack") and player:FindFirstChild("Backpack"):FindFirstChild("Pickaxe of Balance")
				if pick then
					character:FindFirstChild("Pickaxe of Balance").RemoteFunction:InvokeServer("mine")
				end
			until not ore:FindFirstChild("Base") or ore:FindFirstChild("Base").Transparency == 1
		end
	end
end
