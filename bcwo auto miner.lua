--made by vel
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local function tweento(a,b)
	local c = game:GetService("TweeService"):Create(a:FindFirstChild("HumanoidRootPart"),TweenInfo.new(1,Enum.EasingStyle.Linear),{CFrame = b.CFrame})
	c:Play()
	c.Completed:Wait()
end

while true do task.wait()
	for _,ore in pairs(workspace.Map.Ores:GetChildren()) do
		local base = ore:FindFirstChild("Base")
		if base and base.Position.Y <= 440 then
			repeat
				tweento(player,base.CFrame)
				if character:FindFirstChild("Pickaxe of Balance") and player:FindFirstChild("Backpack") then
					character:FindFirstChild("Pickaxe of Balance").RemoteFunction:InvokeServer("mine")
				else
					player.Backpack:FindFirstChild("Pickaxe of Balance").Parent = character
					character:FindFirstChild("Pickaxe of Balance").RemoteFunction:InvokeServer("mine")
				end
			until not ore:FindFirstChild("Base")
		end
	end
end
