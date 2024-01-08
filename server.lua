ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)
--[[Chuj ci w dupe wiecej z nami kutasie krzywy nie grasz]]
local DebugMode = true
local gemList = {[1]='obsidian' ,[2]='ruby' ,[3]='saphire' ,[4]='amethyst' ,[5]='emerald' , [6] = 'diamond'}
local metalList = {[1]='copper',[2]='bronze' ,[3]='iron',[4]='silver',[5]='electrum' ,[6]='gold',[7]='platinum' ,}
local valueGems = {['obsidian'] = 5,['ruby'] = 10,['saphire'] = 20,['amethyst'] = 30,['emerald'] = 40, ['diamond'] = 50}
local valueMetal = {['copper']= 5,['bronze']= 10,['iron']= 20,['silver']= 30,['electrum']= 40,['gold']= 50,['platinum']= 60,}
local jewType = {[1]='necklace',[2]='earring',[3]='ring'}
local jewVal = {['necklace'] = 10,['earring'] = 11,['ring'] = 12}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

ESX.RegisterServerCallback('jewel:DrillCheck', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
    local item = 'drill'
	local items = xPlayer.getInventory(item)
	local found = 0
	local qtty = 0
	for k,v in pairs(items) do
		if k == item then
			found = 1
			qtty = v
           
		end
	end
	if found == 1 then
		cb(qtty)
	else
		cb(0)
	end
end)
ESX.RegisterServerCallback('jewel:InvCheck', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.getInventory(true)
	local GemListClient = {}
	local MetalListClient = {}
	local Gemcount = 0
	local Metalcount = 0
	local Listy = {}
	--print(json.encode(items))
	for k,v in pairs(items) do
		for i = 1,6,1 do
			if k == gemList[i]..'Gem' then
				--print(k..v)			
				table.insert(GemListClient, {[k] = v})
				--print(json.encode(GemListClient))
				--local Gemcount = Gemcount + 1
			end
		end		
		for i = 1,7,1 do
			if k == metalList[i].."Ore"then
				table.insert(MetalListClient, {[k] = v})
				--print(json.encode(MetalListClient))
				--local Metalcount = Metalcount + 1
			end
		end																
	end
	--print(json.encode(MetalListClient))
	--print(json.encode(GemListClient))
	table.insert(Listy, {["gemList"]=GemListClient})
	table.insert(Listy, {["metalList"]=MetalListClient})
	--print(json.encode(Listy))
	cb(Listy)
end)
function RandomGem()
	local Gem = 0
    local Rnum = math.random(1,21)
	if Rnum == 21 then
		local Gem = 6
		return Gem
	elseif Rnum > 18 then
		local Gem = 5
		return Gem
	elseif Rnum > 15 then
		local Gem = 4
		return Gem
	elseif Rnum > 11 then
		local Gem = 3
		return Gem
	elseif Rnum > 6 then
		local Gem = 2
		return Gem
	elseif Rnum > 0 then
		local Gem = 1
		return Gem
	end
end

function RandomMetal()
	local Gem = 0
    local Rnum = math.random(1,27)
	if Rnum == 27 then
		local Gem = 7
		return Gem
	elseif Rnum > 25 then
		local Gem = 6
		return Gem
	elseif Rnum > 22 then
		local Gem = 5
		return Gem
	elseif Rnum > 18 then
		local Gem = 4
		return Gem
	elseif Rnum > 13 then
		local Gem = 3
		return Gem
	elseif Rnum > 7 then
		local Gem = 2
		return Gem
	elseif Rnum > 0 then
		local Gem = 1
		return Gem
	end	
end
RegisterNetEvent('jcrafter:CToS')
AddEventHandler('jcrafter:CToS', function(a,b,c)
	local source = b
	local xPlayer = ESX.GetPlayerFromId(source)
	if a == "MineGem" then
		local RGem = RandomGem()
		xPlayer.addInventoryItem(gemList[RGem]..'Gem', 1)
	elseif a == 'MineMetal' then
		local RMetal = RandomMetal()
		xPlayer.addInventoryItem(metalList[RMetal]..'Ore', 1)
	elseif a == 'RemoveDrill' then
		xPlayer.removeInventoryItem('drill',1)
	elseif a == 'sellPrice' then
		xPlayer.addAccountMoney('bank',c)
		print(c..' id: '..b)
	elseif a == 'giveItem' then
		--xPlayer.addInventoryItem(c, 1)
		--print(c)
	elseif a == 'RemoveItem' then
		xPlayer.removeInventoryItem(c,1)
		--print(c)
	end
end)