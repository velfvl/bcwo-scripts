local summonitemnames = set[1]

repeat task.wait() until game:IsLoaded()print("init")
local player = game:GetService("Players").LocalPlayer
player.Idled:Connect(function()game:GetService("VirtualUser"):ClickButton2(Vecter2.new())end)
local character = player.Character
local vim = game:GetService("VirtualInputManager")

local pos1 = Vector3.new(0,9000,0)
local pos2 = Vector3.new(-2,13,-284)

local mpos = Vector3.new(0,9000,0)

if game.PlaceId == 10228957718 then
	--[[coroutine.wrap(function()
		while true do task.wait(.5)
			if character:FindFirstChild("Shield") and not character:FindFirstChild("ShieldForceField") then
				character.Shield.ShieldRemote:FireServer()
			end
		end
	end)()]]
    game:GetService("ReplicatedStorage").VoteRemote:InvokeServer("Torment")
	coroutine.wrap(function()
		while true do task.wait()
			character:MoveTo(mpos)
		end
	end)()
	coroutine.wrap(function()
		while true do task.wait() 
			for _,item in pairs(summonitemnames) do
				local tool = player.Backpack:FindFirstChild(item.Name) or player.Character:FindFirstChild(item.Name)
				if tool then 
					for i = 1,#item.Spawns do
						for _,v in pairs(workspace:GetChildren()) do
							if v.Name == item.Spawns[i] and v:FindFirstChild("OwnerTag").Value ~= player or not workspace:FindFirstChild(item.Spawns[i]) then
								mpos = pos2
								tool.Parent = character
								vim:SendMouseButtonEvent(0, 0, 0, true, game, 1)
								task.wait(.25)
								vim:SendMouseButtonEvent(0, 0, 0, false, game, 1)
								tool.Parent = player.Backpack
								task.wait(.25)
								mpos = pos1
							end
						end
					end
				end
			end
		end
	end)()
end
