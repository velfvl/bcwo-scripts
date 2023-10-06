--[[
credits:
made by vel
]]
local pinguser = set[1]

local eventwbh = set[2][1]
local statswbh = set[2][2]
local chatwbh = set[2][3]

local summonitemnames = set[3]

repeat task.wait() until game:IsLoaded()print("init")
local player = game:GetService("Players").LocalPlayer
player.Idled:Connect(function()game:GetService("VirtualUser"):ClickButton2(Vecter2.new())end)

local character = player.Character
local vim = game:GetService("VirtualInputManager")

--local spawncf = character.PrimaryPart.CFrame*CFrame.new(0,40,0)

local prioritizedmsgs = {
	[1] = {
		["Message"] = "A bright light is blinding the world!",
		["Name"] = "The Blinding Light",
		["Title"] = "Light has beamed upon you with a heave of energy",
		["Color"] = tonumber(0xffffff)
	},
	[2] = {
		["Message"] = "The world is being shrouded in darkness!",
		["Name"] = "The Shrouding Darkness",
		["Title"] = "Darkness is brought upon you from a dark source.",
		["Color"] = tonumber(0x000000)
	},
	[3] = {
		["Message"] = "Your actions have created imbalances to reality.",
		["Name"] = "Cultist Army",
		["Title"] = "Cultist army has arrived.",
		["Color"] = tonumber(0x333333)
	},
	[4] = {
		["Message"] = "The angels of the sky are descending!",
		["Name"] = "The Heavens",
		["Title"] = "Angels have descended!",
		["Color"] = tonumber(0xecbc00)
	},
	[5] = {
		["Message"] = "The void is infiltrating reality!",
		["Name"] = "The Void",
		["Title"] = "Void has spawn!",
		["Color"] = tonumber(0x301f41)
	},
	[6] = {
		["Message"] = "[Server]: Interdimensional Travelling Merchant Rain has arrived!",
		["Name"] = "Travelling Merchant Rain",
		["Title"] = "Rain has arrived!",
		["Color"] = tonumber(0xe82424)
	},
	[7] = {
		["Message"] = "[Server]: Interdimensional Travelling Merchant Rain has left the island!",
		["Name"] = "Travelling Merchant Rain",
		["Title"] = "Rain has left!",
		["Color"] = tonumber(0xe82424)
	}
}

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

function Format(Int)
	return string.format("%02i", Int)
end

function timeconv(secs)
	local mins = (secs - secs%60)/60
	secs = secs - mins*60
	local hrs = (mins - mins%60)/60
	mins = mins - hrs*60
	return Format(hrs).." hrs, "..Format(mins).." mins and "..Format(secs).." secs"
end

function getstatslogembed()
	local statslogembed = {
	    ["title"] = "Your stats! | BCWO STATS LOG | ".. timeconv(time()),
	    ["description"] = "",
		['type'] = "rich",
	    ["color"] = tonumber(0xffbf00),
	    ["fields"] = {
	        {
	            ["name"] = "------Account------",
	            ["value"] = "Username: ".. player.Name.. " | Display Name: ".. player.DisplayName
	        },
		        {
	            ["name"] = "------Stats------",
	            ["value"] = "Cash: ".. player.leaderstats.Cash.Value.. " | Rank: ".. player.leaderstats.Rank.Value
	        }
	    },
	    ["footer"] = {
	        ["text"] = "Others:\nPlaceId: ".. game.PlaceId.. "\nJobId: ".. game.JobId.. "\nUserId: ".. player.UserId.. "\nPing: ".. player:GetNetworkPing() * (1000).. "ms"
	    }
	}
	return statslogembed
end

function embedsend(url,embed,user)
	if url == nil then return end
	if user == nil then user = "" end
    local http = game:GetService("HttpService")
    local headers = {
        ["Content-Type"] = "application/json"
    }
	local data = {
		["content"] = user,
	    ["embeds"] = {
		        {
        	    ["title"] = embed.title,
            	["description"] = embed.description,
				["type"] = embed.type,
            	["color"] = embed.color,
            	["fields"] = embed.fields,
        	    ["footer"] = {
            	    ["text"] = embed.footer.text
            	}
        	}
    	}
	}
    local body = http:JSONEncode(data)
    local response = request({
        Url = url,
        Method = "POST",
        Headers = headers,
        Body = body
    })
end

function messagesend(url,message)
	if url == nil then return end
    local http = game:GetService("HttpService")
    local headers = {
        ["Content-Type"] = "application/json"
    }
    local data = {
        ["content"] = message
    }
    local body = http:JSONEncode(data)
    local response = request({
        Url = url,
        Method = "POST",
        Headers = headers,
        Body = body
    })
end

player.PlayerGui.Chat.Frame.ChatChannelParentFrame.Frame_MessageLogDisplay.Scroller.DescendantAdded:Connect(function(frame)
	if frame:IsA('Frame') and toggled == true then
		for _,msg in pairs(prioritizedmsgs) do
			if frame.TextLabel.Text == msg.Message then
				local msgembed = {
					["title"] = msg.Title.." | BCWO BIOME LOG | ".. timeconv(time()),
    				["description"] = '"'..msg.Name..'"',
					['type'] = "rich",
				    ["color"] = msg.Color,
				    ["fields"] = {},
				    ["footer"] = {
    				    ["text"] = "Others:\nPlaceId: ".. game.PlaceId.. "\nJobId: ".. game.JobId.. "\nUserId: ".. player.UserId.. "\nPing: ".. player:GetNetworkPing() * (1000).. "ms"
    					}
				}
				embedsend(eventwbh,msgembed,pinguser)
			end
		end
		messagesend(chatwbh,frame.TextLabel.Text)
	end
end)

if game.PlaceId == 8811271345 then
	embedsend(statswbh,getstatslogembed())
	coroutine.wrap(function()
		while true do task.wait(.5)
			if character:FindFirstChild("Shield") and not character:FindFirstChild("ShieldForceField") then
				character.Shield.ShieldRemote:FireServer()
			end
		end
	end)()
	coroutine.wrap(function()
		while true do task.wait()
			--character:SetPrimaryPartCFrame(spawncf)
			for _,item in pairs(summonitemnames) do
				local tool = player.Backpack:FindFirstChild(item.Name) or player.Character:FindFirstChild(item.Name)
				if tool then 
					for i = 1,#item.Spawn do
						local s = workspace:FindFirstChild(item.Spawn)
						if s and calculatehp(s) and isacompanion(s) then
							healcompanion(tool)
						elseif not s then
							revive(tool,item,s)
						end
					end
				end
			end
		end
	end)()
end

coroutine.wrap(function()
	while task.wait(1800) do
		embedsend(statswbh,getstatslogembed())
	end
end)()
