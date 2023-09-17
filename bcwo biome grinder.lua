--[[
!!BCWO AUTO BIOME SCRIPT!!
-------------------------------------
shitpost notes:
auto shield op
webhook sender
literal afk machine
-------------------------------------
credits:
made by vel
]]
local toggled = set[1]

local pinguser = set[2]

local eventwbh = set[3][1]
local statswbh = set[3][2]
local chatwbh = set[3][3]

local summonitemnames = set[4]

repeat task.wait() until game:IsLoaded()print("init")
local player = game:GetService("Players").LocalPlayer
if toggled == true then 
	player.Idled:Connect(function()game:GetService("VirtualUser"):ClickButton2(Vecter2.new())end)
end

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
		["Message"] = "The void has infiltrated reality!",
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
	        ["text"] = "```Others:\nPlaceId: ".. game.PlaceId.. "\nJobId: ".. game.JobId.. "\nUserId: ".. player.UserId.. "\nPing: ".. player:GetNetworkPing() * (1000).. "ms```"
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
	if frame:IsA('Frame') then
		for _,msg in pairs(prioritizedmsgs) do
			if frame.TextLabel.Text == msg.Message then
				local msgembed = {
					["title"] = msg.Title.." | BCWO BIOME LOG | ".. timeconv(time()),
    				["description"] = '"'..msg.Name..'"',
					['type'] = "rich",
				    ["color"] = msg.Color,
				    ["fields"] = {},
				    ["footer"] = {
    				    ["text"] = "```Others:\nPlaceId: ".. game.PlaceId.. "\nJobId: ".. game.JobId.. "\nUserId: ".. player.UserId.. "\nPing: ".. player:GetNetworkPing() * (1000).. "ms```"
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
		while true do task.wait()
			if character:FindFirstChild("Shield") and toggled ~= false then
				character.Shield.ShieldRemote:FireServer()
			end
		end
	end)()
	coroutine.wrap(function()
		while true do task.wait() if toggled == false then break end
			--character:SetPrimaryPartCFrame(spawncf)
			for _,item in pairs(summonitemnames) do if toggled == false then break end
				local tool = player.Backpack:FindFirstChild(item.Name) or player.Character:FindFirstChild(item.Name)
				if tool then 
					for i = 1,#item.Spawns do if toggled == false then break end
						if not workspace:FindFirstChild(item.Spawns[i]) then
							tool.Parent = character
							vim:SendMouseButtonEvent(0, 0, 0, true, game, 1)
							task.wait(.1)
							vim:SendMouseButtonEvent(0, 0, 0, false, game, 1)
							tool.Parent = player.Backpack
							task.wait(.1)
						end
					end
				end
			end
		end
	end)()
end

coroutine.wrap(function()
	while task.wait(1800) do
		if toggled == false then break end
		embedsend(statswbh,getstatslogembed())
	end
end)()
