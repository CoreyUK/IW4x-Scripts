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

        
        self SetOffhandSecondaryClass("smoke");
        self giveWeapon( "smoke_grenade_mp" );

        
        wait(0.5);
    }
}