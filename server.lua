ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("moneywash:wash")
AddEventHandler("moneywash:wash", function(amount, tax, finalAmount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local amount = Config.Amount
    local maxMoney = Config.Maxmoney
        if xPlayer ~= nil then
            if xPlayer.getAccount('black_money').money > maxMoney then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You have too much dirty cash on you.', length = 4000 })
            elseif xPlayer.getAccount('black_money').money < amount then 
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have enought dirty cash on you.', length = 4000 })
            elseif xPlayer.getAccount('black_money').money >= amount then
                local tax = math.random(Config.MinTax, Config.MaxTax) 
                local finalAmount = amount - tax
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Your money has been cleaned buy you had to pay a tax.', length = 4000 })
                xPlayer.removeAccountMoney('black_money', amount)
                Citizen.Wait(100)
                xPlayer.addMoney(finalAmount)
            end
        end
end)


