Config = {}

-------------------------------------- MENUS --------------------------------------------
Config.TeleportMenu = true
Config.VehicleSpawnMenu = true
Config.WeaponMenu = true
------------------------------------- OPTIONS -------------------------------------------
Config.Suicide = true
-------------------------------------------------------------------------------------------------- 
Config.Vehicles = {
    [1] = {
         name = "Bugatti Divo 2019",
         id = "divo",   
     },
    [2] = {
         name = "Bus",
         id = "bus"
     },	
 }

Config.locations = {
    [1] = {
        coords = vector3(-278.27,-1630.33,31.85),
        heading = 169.82,
        name = "MS | Weed",
	    },
    [2] = {
        coords = vector3(-1019.19,-2977.57,13.95),
        heading = 235.66,
        name = "MS | Airport",
    },
    [3] = {
        coords = vector3(2043.82,2788.98,50.03),
        heading = 189.45,
        name = "MS | Arena",
    },
    [4] = {
        coords = vector3(1436.06,1111.15,114.19),
        heading = 272.15,
        name = "MS | Ranch",
	},	
	[5] = {
		coords = vector3 (213.73,-2548.52,5.88),
		heading = 102.26,
		name = "~r~MS | Train Tracks",
    },
   
}

Config.Weapons = {
    [1] = {
        name = "AP Pistol",
        id = "weapon_appistol",
        description = "Spawn in an ~r~AP Pistol"
    },
	[2] = {
        name = "Combat Pistol",
        id = "weapon_combatpistol",
        description = "Spawn in a ~b~Combat Pistol"
    },
	[3] = {
        name = "Machine Pistol",
        id = "weapon_machinepistol",
        description = "Spawn in a ~b~Machine Pistol"
    },
}