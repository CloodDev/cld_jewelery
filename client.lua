ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    
	PlayerData = ESX.GetPlayerData()
    Citizen.Wait(5000)
end)
doable = 1
local LID = GetPlayerServerId(PlayerId())
local cfgMarker = {
    [1] = {x=2969.1057, y=2777.1296, z=38.4480-0.95},
    [2] = {x=-542.2153, y=1983.1702, z=127.1940-0.95},
    [3] = {x=-621.9427, y=-232.3385, z=38.05718-0.95}
}
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        player = GetEntityCoords(PlayerPedId())
	end
end)

CreateThread(function()
    while true do 
        for i = 1,3,1 do
            ESX.DrawMarker(vec3(cfgMarker[i].x, cfgMarker[i].y, cfgMarker[i].z))
        end
        Citizen.Wait(10)
    end
end)
CreateThread(function()
    local closest = 0
    while true do
        for i = 1,3,1 do
            local DistMarker = GetDistanceBetweenCoords(player,  cfgMarker[i].x,cfgMarker[i].y,cfgMarker[i].y, false)
            if DistMarker <= 1 then
                closest = i
                if IsControlPressed(1, 51) and IsPedInAnyVehicle(PlayerPedId()) == false then
                    NiggerEvent(closest)
                    Citizen.Wait(100)
                end
            end
        end
        Citizen.Wait(10)
    end
end)
local ExileBlips = {
    {
        coords = {-596.3100, 2091.4133, 131.5872},
        sprite = 617,
        display = 4,
        scale = 1.0,
        color = 3,
        shortrange = true,
        name = "Kopalnia Kryształów",
        exileBlip = false,
        exileBlipId = ""
    },{
        coords = {2969.1057, 2777.1296, 38.4480},
        sprite = 618,
        display = 4,
        scale = 0.7,
        color = 70,
        shortrange = true,
        name = "Kopalnia Metalu",
        exileBlip = false,
        exileBlipId = ""
    },{
        coords = {-621.9427, -232.3385, 38.05718},
        sprite = 617,
        display = 4,
        scale = 1.0,
        color = 34,
        shortrange = true,
        name = "Jubiler",
        exileBlip = false,
        exileBlipId = ""
    },
}
CreateThread(function()
	for i,v in ipairs(ExileBlips) do
		local blip = AddBlipForCoord(v.coords[1], v.coords[2], v.coords[3])

		SetBlipSprite (blip, v.sprite)
		SetBlipDisplay(blip, v.display)
		SetBlipScale  (blip, v.scale)
		SetBlipColour (blip, v.color)
		SetBlipAsShortRange(blip, v.shortrange)
	
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(v.name)
		EndTextCommandSetBlipName(blip)
	end	
end)
function NiggerEvent(Action)
    if Action == 1 then
        StartMinigMetal()
    elseif Action == 2 then
        StartMinigGem()
    elseif Action == 3 then
        JeweleryCrafting()
    else end
end

function wiertarkaprop()
    wiertarka = CreateObject(GetHashKey('prop_tool_drill'), 1.0, 1.0, 1.0, 1, 1, 0)
    AttachEntityToEntity(wiertarka, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.1, 0.04, -0.03, -90.0, 180.0, 0.0, 1, 1, 0, 1, 1, 1)
end


function Wiertara()
    if not IsPedInAnyVehicle(PlayerPedId(), true) then
        doable = 0
        DeleteEntity(wiertarka)
        SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
        Citizen.Wait(1)
        ESX.Streaming.RequestAnimDict("anim@heists@fleeca_bank@drilling", function()
            TaskPlayAnim(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_start", 8.0, 3.0, -1, 57, 1, false, false, false)
            wiertarkaprop()
            exports['Z']:taskBar(15000, 'WYKOPYWANIE MATERIALOW')
            DeleteEntity(wiertarka)
            ClearPedTasks(PlayerPedId())
        end)
        doable = 1
    end
end


function PlayerHaveDrill()
    ESX.TriggerServerCallback('jewel:DrillCheck', function(ilosc)
        return ilosc
    end)
end

function StartMinigGem()
    if doable == 1 then
    ESX.TriggerServerCallback('jewel:DrillCheck', function(ilosc)
        if ilosc == 0 then
            ESX.ShowNotification('Nie Posiadasz Wiertła')
        else
            Wiertara()
            TTS('MineGem', LID)
        end  
    end)
    end
end

function StartMinigMetal()
    if doable == 1 then
    ESX.TriggerServerCallback('jewel:DrillCheck', function(ilosc)
        if ilosc == 0 then
            ESX.ShowNotification('Nie Posiadasz Wiertła')
        else
            Wiertara()
            TTS('MineMetal', LID)
        end  
    end)
    end
end
function getLabel(key,typie)
    if typie == 'gem' then
        if key == 'obsidianGem' then
            return "Obsydian"
        elseif key == 'rubyGem' then
            return "Rubin"
        elseif key == 'saphireGem' then
            return "Szafir"
        elseif key == 'amethystGem' then
            return "Ametyst"
        elseif key == 'emeraldGem' then
            return "Szmaragd"
        elseif key == 'diamondGem' then
            return "Diament"
        end
    elseif typie =='metal'then
        if key == 'copperOre' then
            return "Miedź"
        elseif key == 'bronzeOre' then
            return "Brąz"
        elseif key == 'ironOre' then
            return "Żelazo"
        elseif key == 'silverOre' then
            return "Srebro"
        elseif key == 'electrumOre' then
            return "Elektrum"
        elseif key == 'goldOre' then
            return "Złoto"
        elseif key == 'platinumOre' then
            return "Platyna"
        end
    end
end
function JeweleryCrafting()
    local Elementy = {}
    local Elementy2 = {}
    ESX.TriggerServerCallback('jewel:InvCheck', function(ilosc)
        for key,value in pairs(ilosc) do    
            if not(value.gemList == null) then
                for k,v in pairs(value.gemList)do
                    for klucz,wartosc in pairs(v)do
                        local GutLabel = getLabel(klucz, 'gem')
                        table.insert(Elementy,  {label = GutLabel, value = klucz})
                    end
                end
            elseif not(value.metalList == null) then
                for k,v in pairs(value.metalList)do
                    for klucz,wartosc in pairs(v)do
                        local GutLabel2 = getLabel(klucz, 'metal')
                        table.insert(Elementy2,  {label = GutLabel2, value = klucz})
                    end
                end
            end
        end
        table.insert(Elementy2, {label = 'Zakończ Wytwarzanie', value = 'close'})
        table.insert(Elementy, {label = 'Zakończ Wytwarzanie', value = 'close'})
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Jewler_Actions', {
            title    = "Jubiler",
            align    = 'center',
            elements = Elementy
        }, function(data, menu)
            if data.current.value == 'close' then
                ESX.UI.Menu.CloseAll()
            elseif data.current.value == 'rubyGem' then
                local ogGem = data.current.value
                ESX.UI.Menu.CloseAll()
                OpenMetalPicker(ogGem,Elementy2)
            elseif data.current.value == 'obsidianGem' then
                local ogGem = data.current.value
                ESX.UI.Menu.CloseAll()
                OpenMetalPicker(ogGem,Elementy2)
            elseif data.current.value == 'saphireGem' then
                local ogGem = data.current.value
                ESX.UI.Menu.CloseAll()
                OpenMetalPicker(ogGem,Elementy2)
            elseif data.current.value == 'amethystGem' then
                local ogGem = data.current.value
                ESX.UI.Menu.CloseAll()
                OpenMetalPicker(ogGem,Elementy2)
            elseif data.current.value == 'emeraldGem' then
                local ogGem = data.current.value
                ESX.UI.Menu.CloseAll()
                OpenMetalPicker(ogGem,Elementy2)
            elseif data.current.value == 'diamondGem' then
                local ogGem = data.current.value
                ESX.UI.Menu.CloseAll()
                OpenMetalPicker(ogGem,Elementy2)
            end
            menu.close()
        end)
    end)
end

function OpenMetalPicker(ogGem, Elementy2)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Jewler_Actions2', {
        title    = 'Jubiler',
        align    = 'center',
        elements = Elementy2
        }, function(data2, menu2)
        if data2.current.value == 'copperOre' then
            local ogMetal = data2.current.value
            ESX.UI.Menu.CloseAll()
            OpenTypePicker(ogMetal, ogGem)
            menu2.close()
        elseif data2.current.value == 'bronzeOre' then
            local ogMetal = data2.current.value
            ESX.UI.Menu.CloseAll()
            OpenTypePicker(ogMetal, ogGem)
            menu2.close()
        elseif data2.current.value == 'ironOre' then
            local ogMetal = data2.current.value
            ESX.UI.Menu.CloseAll()
            OpenTypePicker(ogMetal, ogGem)
            menu2.close()
        elseif data2.current.value == 'silverOre' then
            local ogMetal = data2.current.value
            ESX.UI.Menu.CloseAll()
            OpenTypePicker(ogMetal, ogGem)
            menu2.close()
        elseif data2.current.value == 'electrumOre' then
            local ogMetal = data2.current.value
            ESX.UI.Menu.CloseAll()
            OpenTypePicker(ogMetal, ogGem)
            menu2.close()
        elseif data2.current.value == 'goldOre' then
            local ogMetal = data2.current.value
            ESX.UI.Menu.CloseAll()
            OpenTypePicker(ogMetal, ogGem)
            menu2.close()
        elseif data2.current.value == 'platinumOre' then
            local ogMetal = data2.current.value
            ESX.UI.Menu.CloseAll()
            OpenTypePicker(ogMetal, ogGem)
            menu2.close()
        elseif data2.current.value == 'close' then
            ESX.UI.Menu.CloseAll()
        end
    end)
end
function OpenTypePicker(ogMetal, ogGem)
    local Elementy3 = {
        {label = 'Pierścień', value = 'ring'},
        {label = 'Kolczyk', value = 'earring'},
        {label = 'Naszyjnik', value = 'necklace'}
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Jewler_Actions3', {
        title    = 'Jubiler',
        align    = 'center',
        elements = Elementy3
    }, function(data3, menu3)
        if data3.current.value == 'necklace' then
            local ogTyp = data3.current.value
            ESX.UI.Menu.CloseAll()
            local Outcome = CalcPrice(ogGem,ogMetal,ogTyp)
            giveItem(Outcome)
            menu3.close()
        elseif data3.current.value == 'ring' then
            local ogTyp = data3.current.value
            ESX.UI.Menu.CloseAll()
            local Outcome = CalcPrice(ogGem,ogMetal,ogTyp)
            giveItem(Outcome)
            menu3.close()
        elseif data3.current.value == 'earring' then
            local ogTyp = data3.current.value
            ESX.UI.Menu.CloseAll()
            local Outcome = CalcPrice(ogGem,ogMetal,ogTyp)
            giveItem(Outcome)
            menu3.close()
        end
    end)
end

function giveItem(a)
    --print(json.encode(a))
    for k,v in pairs(a) do
        if k == 1 then
            TTS('sellPrice', LID, v)
            ESX.ShowNotification('Sprzedano za '..v..'$')
            exports['avalon_taskbar']:taskBar(10000, 'SPRZEDAWANIE BIZUTERI')
        elseif k == 2 then
            TTS('giveItem', LID, v)
            exports['avalon_taskbar']:taskBar(10000, 'Składanie Biżuteri')
        elseif k == 3 then
            --print(json.encode(v))
            for key,value in pairs(v) do
                if key == 1 then
                    --print(value..'Gem')
                    TTS('RemoveItem',LID,value..'Gem')
                elseif key == 2 then
                    --print(value..'Metal')
                    TTS('RemoveItem',LID,value..'Ore')
                end
            end 
        end
    end
end

function CalcPrice(ogGem,ogMetal,ogTyp)
    --print(ogGem..ogTyp..ogMetal)
    local metalVal = 0
    local GemVal = 0
    local typVal = 0
    
    local gemLista = {'obsidianGem'='obsidian' ,'rubyGem'='ruby' ,'saphireGem'='saphire' ,'amethystGem'='amethyst' ,'emeraldGem'='emerald' , 'diamondGem' = 'diamond'}
    local metalLista = {'copperOre'='copper', }
    if ogGem == 'obsidianGem' then
        local gem = "obsidian"
        local GemVal = 5
        if ogMetal == 'copperOre' then
            local metal = "copper"
            local metalVal = 5
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'bronzeOre' then
            local metal = "bronze"
            local metalVal = 10
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'ironOre'then
            local metal = "iron"
            local metalVal = 20
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'silverOre'then
            local metal = "silver"
            local metalVal = 30
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'electrumOre'then
            local metal = "electrum"
            local metalVal = 40
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'goldOre'then
            local metal = "gold"
            local metalVal = 50
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'platinumOre'then
            local metal = "platinum"
            local metalVal = 60
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        end
    elseif ogGem == 'rubyGem'then
        local gem = "ruby"
        local GemVal = 10
        if ogMetal == 'copperOre' then
            local metal = "copper"
            local metalVal = 5
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'bronzeOre' then
            local metal = "bronze"
            local metalVal = 10
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'ironOre'then
            local metal = "iron"
            local metalVal = 20
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'silverOre'then
            local metal = "silver"
            local metalVal = 30
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'electrumOre'then
            local metal = "electrum"
            local metalVal = 40
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'goldOre'then
            local metal = "gold"
            local metalVal = 50
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'platinumOre'then
            local metal = "platinum"
            local metalVal = 60
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        end
    elseif ogGem == 'saphireGem'then
        local gem = "saphire"
        local GemVal = 20
        if ogMetal == 'copperOre' then
            local metal = "copper"
            local metalVal = 5
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'bronzeOre' then
            local metal = "bronze"
            local metalVal = 10
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'ironOre'then
            local metal = "iron"
            local metalVal = 20
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'silverOre'then
            local metal = "silver"
            local metalVal = 30
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'electrumOre'then
            local metal = "electrum"
            local metalVal = 40
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'goldOre'then
            local metal = "gold"
            local metalVal = 50
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'platinumOre'then
            local metal = "platinum"
            local metalVal = 60
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        end
    elseif ogGem == 'amethystGem'then
        local gem = "amethyst"
        local GemVal = 30
        if ogMetal == 'copperOre' then
            local metal = "copper"
            local metalVal = 5
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'bronzeOre' then
            local metal = "bronze"
            local metalVal = 10
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'ironOre'then
            local metal = "iron"
            local metalVal = 20
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'silverOre'then
            local metal = "silver"
            local metalVal = 30
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'electrumOre'then
            local metal = "electrum"
            local metalVal = 40
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'goldOre'then
            local metal = "gold"
            local metalVal = 50
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'platinumOre'then
            local metal = "platinum"
            local metalVal = 60
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        end
    elseif ogGem == 'emeraldGem'then
        local gem = "emerald"
        local GemVal = 40
        if ogMetal == 'copperOre' then
            local metal = "copper"
            local metalVal = 5
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'bronzeOre' then
            local metal = "bronze"
            local metalVal = 10
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'ironOre'then
            local metal = "iron"
            local metalVal = 20
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'silverOre'then
            local metal = "silver"
            local metalVal = 30
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'electrumOre'then
            local metal = "electrum"
            local metalVal = 40
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'goldOre'then
            local metal = "gold"
            local metalVal = 50
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'platinumOre'then
            local metal = "platinum"
            local metalVal = 60
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        end
    elseif ogGem == 'diamondGem'then
        local gem = "diamond"
        local GemVal = 50
        if ogMetal == 'copperOre' then
            local metal = "copper"
            local metalVal = 5
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'bronzeOre' then
            local metal = "bronze"
            local metalVal = 10
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'ironOre'then
            local metal = "iron"
            local metalVal = 20
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'silverOre'then
            local metal = "silver"
            local metalVal = 30
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'electrumOre'then
            local metal = "electrum"
            local metalVal = 40
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'goldOre'then
            local metal = "gold"
            local metalVal = 50
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'platinumOre'then
            local metal = "platinum"
            local metalVal = 60
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        end
        if ogMetal == 'copperOre' then
            local metal = "copper"
            local metalVal = 5
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'bronzeOre' then
            local metal = "bronze"
            local metalVal = 10
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'ironOre'then
            local metal = "iron"
            local metalVal = 20
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'silverOre'then
            local metal = "silver"
            local metalVal = 30
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'electrumOre'then
            local metal = "electrum"
            local metalVal = 40
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'goldOre'then
            local metal = "gold"
            local metalVal = 50
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        elseif ogMetal == 'platinumOre'then
            local metal = "platinum"
            local metalVal = 60
            if ogTyp == 'necklace' then
                local typVal = 10
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'ring' then
                local typVal = 11
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            elseif ogTyp == 'earring' then
                local typVal = 12
                local name = gem..ogTyp..metal
                local finVal = typVal*metalVal*GemVal
                local finOut = {[1] = finVal,[2]= name,[3] = {[1]=gem,[2]=metal}}
                return finOut
            end
        end
    end
end


function TTS(Co,source,dane)
    if dane == nil then
        dane = 0
    end
    TriggerServerEvent("jcrafter:CToS", Co, source,dane)
end