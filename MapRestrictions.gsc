#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
    mapName = getdvar("mapname");

    if (mapName == "mp_rust" ||
        mapName == "mp_nuked" ||
        mapName == "mp_killhouse" ||
        mapName == "mp_shipment" ||
        mapName == "mp_dome" ||
        mapName == "oilrig")
    {
        level thread onPlayerConnect();
    }
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");

    for(;;)
    {
        self waittill("spawned_player");

       
        primaryWeapon = self getCurrentWeapon(); 
        secondaryWeapon = self getCurrentOffhand(); 

        
        self takeWeapon("flash_grenade_mp");
        self takeWeapon("concussion_grenade_mp");

        
        self SetOffhandSecondaryClass("smoke");
        self giveWeapon("smoke_grenade_mp");

        
        self giveWeapon(primaryWeapon);
        self giveWeapon(secondaryWeapon);
        
        wait(0.5);
    }
}
