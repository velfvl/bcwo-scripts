--made by vel
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

while true do task.wait()
	for _,ore in pairs(workspace.Map.Ores:GetChildren()) do
		local base = ore:FindFirstChild("Base")
		if base and base.Position.Y <= 440 then
			if #priority ~= 0 then
				for i = 1,#priority do
					if priority[i] == ore.Name then
						--print('prior '.. ore.Name)
						repeat
							character:SetPrimaryPartCFrame(base.CFrame)
							if character:FindFirstChild("Pickaxe of Balance") and player:FindFirstChild("Backpack") then
								character:FindFirstChild("Pickaxe of Balance").RemoteFunction:InvokeServer("mine")
							else
								player.Backpack:FindFirstChild("Pickaxe of Balance").Parent = character
								character:FindFirstChild("Pickaxe of Balance").RemoteFunction:InvokeServer("mine")
							end
						until not ore:FindFirstChild("Base")
					end
				end
			else
				repeat
					character:SetPrimaryPartCFrame(base.CFrame)
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
end
