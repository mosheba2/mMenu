local lastvehic = nil
local inZone = false


function Notify(text)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(text)
	DrawNotification(false, true)
end

local timers = {
    health = 0,
    armour = 0,
    bus = 0,
    invincibility = 0,
}

local cooldowns = {
    health = 15,
    armour = 15,
    bus = 60,
    invincibility = 5
}



function notify(msg)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(msg)
    DrawNotification(true, false)
end

function setInvincibility()
    timers.invincibility = cooldowns.invincibility
end

RMenu.Add('combat', 'main', RageUI.CreateMenu("~r~Server Name","",0,100)) ------ change this to whatever you want
RMenu:Get('combat', 'main'):SetSubtitle("Your subtitle here")------ change this to whatever you want
RMenu.Add('combat', 'weapons', RageUI.CreateSubMenu(RMenu:Get('combat','main'), "Weapon Spawner", "~b~Choose your weapon", nil, nil))
RMenu.Add('combat', 'vehicles', RageUI.CreateSubMenu(RMenu:Get('combat','main'), "Vehicle Spawner", "~b~Select a vehicle", nil, nil))
RMenu.Add('combat', 'teleport', RageUI.CreateSubMenu(RMenu:Get('combat','main'), "Teleporter", "~b~Select a location to teleport to", nil, nil))

RageUI.CreateWhile(1.0, RMenu:Get('combat', 'main'), 311, function()
    RageUI.IsVisible(RMenu:Get('combat', 'main'), true, true, true, function()
        if not inZone then
            RageUI.Button("~g~Replenish Health", "Select to replenish your health", { }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    if timers.health <= 0 then
                        timers.health = cooldowns.health
                        SetEntityHealth(PlayerPedId(), 200)
                        notify("~g~Replenished your health")
                    else
                        notify(string.format("~r~You must wait another %ss before you can replenish your health again!", timers.health))
                    end
                end
            end, nil)

            RageUI.Button("~b~Replenish Armour", "Select to replenish your armour", { }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    if timers.armour <= 0 then
                        timers.armour = cooldowns.armour
                        SetPedArmour(PlayerPedId(), 100)
                        Notify("~g~Replenished your armour")
                    else
                        Notify(string.format("~r~You must wait another %ss before you can replenish your armour again!", timers.armour))
                    end
                end
            end, nil)

            if Config.TeleportMenu == true then
                RageUI.Button("~r~Teleport Menu", "Select to open the teleport menu", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if (Selected) then end
                end, RMenu:Get('combat','teleport'))
            end

            if Config.WeaponMenu == true then
                RageUI.Button("~p~Weapon Spawner", "Select to open the weapon spawner", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if (Selected) then end
                end, RMenu:Get('combat','weapons'))
            end

            if Config.VehicleSpawnMenu == true then
                RageUI.Button("~y~Vehicle Spawner", "Select to open the vehicle spawner", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if (Selected) then end
                end, RMenu:Get('combat','vehicles'))
            end

            if Config.Suicide == true then
                RageUI.Button("~r~Suicide", "~r~Select to kill yourself", { }, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        SetEntityHealth(PlayerPedId(), 0)
                        Notify("~g~You ~r~Died")
                    end
            end, nil)
        end

            RageUI.Button("~c~Clear Loadout", "Select to reset your loadout", { }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    RemoveAllPedWeapons(GetPlayerPed(-1), true)
                    TriggerEvent("alert:toast", "DemonRZMENU", "Removed all weapons!", "dark", "success", 4000)
                end
            end, nil)
        else
            Notify("~r~You cannot use this menu in this area!")
        end
    end, function()
    end)
    RageUI.IsVisible(RMenu:Get('combat', 'weapons'),true,true,true,function()
        for name, values in ipairs(Config.Weapons) do
            RageUI.Button(tostring(values.name), string.format("%s", values.description),{ }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    GiveWeaponToPed(PlayerPedId(), GetHashKey(values.id), 9999, false, true)
                end
            end)
        end 
    end, function()
        ---Panels
    end)

    RageUI.IsVisible(RMenu:Get('combat', 'vehicles'),true,true,true,function()
        for name, values in ipairs(Config.Vehicles) do
            RageUI.Button(tostring(values.name), string.format("Select to spawn a %s", values.name),{ }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    if (values.name == "Bus" and timers.bus <= 0) or values.name ~= "Bus" then
                        if values.name == "Bus" then
                            timers.bus = cooldowns.bus
                        end
                        RequestModel(GetHashKey(values.id))
                        while not HasModelLoaded(GetHashKey(values.id)) do
                            Citizen.Wait(100)
                        end
                        local playerPed = PlayerPedId()
                        local pos = GetEntityCoords(playerPed)
                        local vehicle = CreateVehicle(GetHashKey(values.id), pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)
                        SetPedIntoVehicle(playerPed, vehicle, -1)
                        if lastvehic ~= nil then
                            SetEntityAsMissionEntity(lastvehic, true, true)
                            DeleteVehicle(lastvehic)
                        end
                        lastvehic = vehicle
                    else
                        notify(string.format("~r~You cannot spawn another bus for %ss",timers.bus))
                    end
                end
            end)
        end 
    end, function()
        ---Panels
    end)

    RageUI.IsVisible(RMenu:Get('combat', 'teleport'),true,true,true,function()
        for name, values in ipairs(Config.locations) do
            RageUI.Button(tostring(values.name), string.format("Select to teleport to %s", values.name),{ }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local playerPed = PlayerPedId()
                    setInvincibility()
                    SetEntityCoords(playerPed, values.coords.x, values.coords.y, values.coords.z, 0, 0, 0, false)
                    SetEntityHeading(playerPed, values.heading)
                end
            end)
        end 
    end, function()
        ---Panels
    end)
end)

Citizen.CreateThread(function()
    while true do
        for k,_ in pairs(timers) do
            timers[k] = timers[k]-1
        end
        -- checking of distance to redzone
        local pos = GetEntityCoords(PlayerPedId())
        dist = #(vector3(-227.3,-2622.93,6.05)-pos)
        if dist <= 140 then
            inZone = true ------- change to false and set line 191 to true if you want the menu to open in a specific location! 
        else
            inZone = false
        end
        if timers.invincibility > 0 then
            SetPlayerInvincibleKeepRagdollEnabled(PlayerId(), true)
            TriggerServerEvent("K9:sv_combatSetEntityAlpha", 190)
            SetEntityAlpha(GetPlayerPed(-1), 190)
        elseif timers.invincibility == 0 then
            SetPlayerInvincibleKeepRagdollEnabled(PlayerId(), false)
            TriggerServerEvent("K9:sv_combatSetEntityAlpha", 255)
            SetEntityAlpha(GetPlayerPed(-1), 255)
            HudWeaponWheelIgnoreControlInput(false)
        end
        Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        while timers.invincibility > 0 do
            HudWeaponWheelIgnoreControlInput(true)
            Wait(0)
        end
        Wait(400)
    end
end)

RegisterNetEvent("K9:cl_combatSetEntityAlpha")
AddEventHandler("K9:cl_combatSetEntityAlpha", function(entity, value)
    SetEntityAlpha(entity, value)
end)
