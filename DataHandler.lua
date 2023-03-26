local DataStoreService = game:GetService("DataStoreService")
local DataStore1 = DataStoreService:GetDataStore("DataStore1")
local DataStore2 = DataStoreService:GetDataStore("DataStore2")
local CurrentSaveFile

local function leaderstats(player)
	-- Public Data
	leaderstats = Instance.new("Folder")
	leaderstats.Parent = player
	leaderstats.Name = "leaderstats"
	
	-- Data below can be pasted for more values
	Value1 = Instance.new("IntValue")
	Value1.Parent = leaderstats
	Value1.Name = "Value1"
	
	Value2 = Instance.new("IntValue")
	Value2.Parent = leaderstats
	Value2.Name = "Value2"
	
	-- Private Data
		-- Player purchases, gamepasses, etc
end

local function load(player, CurrentSaveFile)
	local Data
	local success, errorMessage = pcall(function()
		Data = CurrentSaveFile:GetAsync(player.UserId)
	end)
	
	if success and Data then
		
		-- Loading public data
		Value1.Value = Data.Value1
		Value2.Value = Data.Value2

		-- Loading private data
		
		-- Printing results
		print(tostring(player).." / "..player.UserId.." Has Loaded Their Data From "..tostring(CurrentSaveFile))
	else
		print(tostring(player).." / "..player.UserId.." Does Not Have Any Data")
	end
end

local function save(player, CurrentSaveFile)
	if player:FindFirstChild("leaderstats") and CurrentSaveFile then
		
		local Data = {
			Value1 = player.leaderstats.Value1.Value,
			Value2 = player.leaderstats.Value2.Value
		}

		local success, errorMessage = pcall(function()
			CurrentSaveFile:SetAsync(player.UserId, Data)
		end)

		-- Printing results
		if success then
			print(tostring(player).." / "..player.UserId.." Has Saved Their Data To "..tostring(CurrentSaveFile))
		else
			print(tostring(player).." / "..player.UserId.." Had An Error Saving Data To"..tostring(CurrentSaveFile))
		end
	else
		print(player.Name.." / "..player.UserId.." Did Not Save Any Data")
	end
end

game.Players.PlayerRemoving:Connect(function(player)
	save(player, CurrentSaveFile)
end)

game:BindToClose(function()
	for _, player in pairs(game.Players:GetPlayers()) do
		save(player, CurrentSaveFile)
	end
end)

local SaveSlotAction = game.ReplicatedStorage.RemoteEvents.SaveSlotAction

SaveSlotAction.OnServerEvent:Connect(function(player, SaveFile, Action)
	if Action == "Load" then
		
		task.wait(leaderstats(player))
	
		-- Defining savefile to load
		if SaveFile == "SaveFile1" then
			player.CurrentSaveFile.Value = DataStore1
			CurrentSaveFile = player.CurrentSaveFile.Value
		end
		if SaveFile == "SaveFile2" then
			player.CurrentSaveFile.Value = DataStore2
			CurrentSaveFile = player.CurrentSaveFile.Value
		end

        -- Apply Save
		load(player, CurrentSaveFile)

	end
	
	if Action == "Reset" then

		-- Defining the savefile to reset
		if SaveFile == "SaveFile1" then
			SaveFile = DataStore1
		end
		if SaveFile == "SaveFile2" then
			SaveFile = DataStore2
		end
		
		-- Reseting the defined savefile
		local Data = {
			Value1 = 0,
			Value2 = 0
		}
		
		local success, errorMessage = pcall(function()
			SaveFile:SetAsync(player.UserId, Data)
		end)
		
		-- Printing results
		if success then
			print(tostring(player).." Has Reset Their Data On "..tostring(SaveFile))
		else
			print(tostring(player).." Had An Error Reseting Their Data On "..tostring(SaveFile))
		end
		
	end
end)