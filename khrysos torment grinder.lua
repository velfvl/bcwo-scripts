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
local player = game:GetService("Players").LocalPlayer or game:GetService("Players").PlayerAdded:Wait()
player.Idled:Connect(function()game:GetService("VirtualUser"):ClickButton2(Vector2.new())end)
local character = player.Character or player.CharacterAdded:Wait()

local function noclip()
	for i,v in pairs(character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end

local function fb()
	local l = game:GetService("Lighting")
	l.Brightness = 2
	l.ClockTime = 14
	l.FogEnd = 100000
	l.GlobalShadows = false
	l.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
	for i,v in pairs(l:GetDescendants()) do
		if v:IsA("Atmosphere") then
			v:Destroy()
		end
	end
end

local function nccam()
	local sc = (debug and debug.setconstant) or setconstant
	local gc = (debug and debug.getconstants) or getconstants
	if not sc or not getgc or not gc then
		return notify('script', 'your executor sucks')
	end
	local pop = player.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper
	for _, v in pairs(getgc()) do
		if type(v) == 'function' and getfenv(v).script == pop then
			for i, v1 in pairs(gc(v)) do
				if tonumber(v1) == .25 then
					sc(v, i, 0)
				elseif tonumber(v1) == 0 then
					sc(v, i, .25)
				end
			end
		end
	end
end

local function tweento(a,b)
	local lo
	if b then
		lo = CFrame.new(0,-20,0)
	else
		lo = CFrame.new(0,0,0)
	end
	local h = character:FindFirstChild("HumanoidRootPart")
	h.CFrame = h.CFrame*lo
	local c = game:GetService("TweenService"):Create(h,TweenInfo.new(1,Enum.EasingStyle.Linear),{CFrame = a*lo})
	c:Play()
	c.Completed:Wait()
	h.CFrame = a
end

local function creepygetterridder(a)
	notify("script","ACTIVATING CREEPY GETTERRIDDER 5000!!!!",5)
	character:FindFirstChild("HumanoidRootPart").CFrame = a:FindFirstChild("HumanoidRootPart").CFrame*CFrame.new(0,25,30)
	tweento(a:FindFirstChild("HumanoidRootPart").CFrame*CFrame.new(1000,50,1000))
	repeat task.wait() until not a
end

local function creepycheck()
	for _,v in pairs(workspace:GetChildren()) do
		if v.Name == "Creepy" then
			notify("script","OHHH MYYY GAUDDD ITSAAA CREEEEEEEPPY",5)
			task.wait(2)
			creepygetterridder(v)
		end
	end
end

local function mine(a)
	creepycheck()
	tweento(a:FindFirstChild("Mineral").CFrame*CFrame.new(0,2.5,3.5),true)
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
elseif game.PlaceId == 9032150459 then fb() nccam()
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
			noclip()
		end
	end)()
--[[elseif game.PlaceId == 8830255143 then
	notify("script","ohhhh myyy godddd how are you in limbo mf")]]
	--queue_on_teleport([[loadstring(game:HttpGet('https://raw.githubusercontent.com/velfvl/bcwo-scripts/main/bcwo%20auto%20miner.lua'))()]])
	--tweento(CFrame.new(0,500,0))
end
