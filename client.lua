ESX              = nil
local PlayerData = {}
local isNear = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function Draw3DText(x, y, z, text, scale)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(true)
    SetTextColour(255, 255, 255, 215)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 700
    DrawRect(_x, _y + 0.0150, 0.06 + factor, 0.03, 41, 11, 41, 100)
end

Citizen.CreateThread(function()
    local location = Config.Location
    local ped = PlayerPedId()
    local washTime = Config.WashTime
    while true do
        Citizen.Wait(5)
        if isNear then
            Draw3DText(location.x, location.y, location.z, "Press ~r~[E]~w~ To Start Washing Money.", 0.4)
            if Vdist(GetEntityCoords(ped), Config.Location) < 1 and IsControlJustReleased(1, 38) then
                exports['mythic_progbar']:Progress({
                    duration = washTime,
                    label = "Washing Money",
                    controlDisables = {
                        disableMovement = true,
                        disablSeCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                    },
                    animation = {
                        animDict = "amb@world_human_drug_dealer_hard@male@base",
                        anim = "base",
                        flags = 49,
                    },
                    }, function(status)
                    if not status then
                        TriggerServerEvent("moneywash:wash")
                    end
                end)
            end
        end
    end
end)

Citizen.CreateThread(function()
    local ped = PlayerPedId()
    while true do
        local coords = GetEntityCoords(ped)
        Citizen.Wait(5)
        if Vdist(coords, Config.Location) < Config.Distance then
            isNear = true
        else
            isNear = false    
        end
    end
end)
    