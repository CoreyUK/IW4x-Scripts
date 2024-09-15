#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
 
init()
{   
    level thread onPlayerConnect();
    setDvarIfUninitialized("sv_disablejavelin", 0);
    
    setDvar("com_maxfps", 333);
    setDvar("sv_rate", 45000);
    setDvar("snaps", 20);
    setDvar("sv_network_fps", 1000);
    setDvar("bg_playerCollision", 0);
	setDvar("bg_playerEjection", 0);
}
 
onPlayerConnect()
{
    for(;;)
    {
        level waittill( "connected", player );
        player thread onPlayerSpawned();
        player thread fixJavelin();
    }
}
 
onPlayerSpawned()
{
    self endon("disconnect");
 
    for(;;)
    {
        self waittill_either("player_spawned", "giveLoadout");
        self checkIfValidWeapons();
        wait(0.5);  
    }
}
 
fixJavelin() 
{
    self endon("disconnect");
 
    for(;;)
    {
        self waittill ( "weapon_change" );   
        curWeapon = self getCurrentWeapon(); 
 
        if ( WeaponType( curWeapon ) == "projectile" )
        {   
            self disableOffhandWeapons();
        }  
        else 
        {
            self enableOffhandWeapons();
        } 
    }   
}
 
checkIfValidWeapons()
{
    self endon( "death" );
    self endon( "disconnect" );
 
    weaponList = self GetWeaponsListAll();
        
    foreach ( weaponName in weaponList )
    {
        if ( isSubstr( weaponName, "_gl" ) )
        {
            self iPrintLnBold( "Grenade launchers are disallowed on this server" );
            self takeWeapon( weaponName );
            self giveWeapon( "m4_mp" );
            wait (0.2);         
            self switchToWeapon( "m4_mp" );
        }
 
        weaponNameShort = strtok( weaponName, "_" )[0];
        
        if ( weaponNameShort == self.loadoutPrimary )
        {
            if ( !isValidPrimary( weaponNameShort ) )
            {
                self takeWeapon( weaponName );
                self giveWeapon( "m4_mp" );
                wait (0.2);
                self iPrintLnBold( weaponNameShort + " is disallowed on this server. It has been replaced");
                self switchToWeapon( "m4_mp" );
            }
        }
 
        if ( weaponNameShort == self.loadoutSecondary )
        {
            if ( !isValidSecondary( weaponNameShort ) )
            {
                self takeWeapon( weaponName );
                self giveWeapon( "usp_mp" );
            }
            
            if ( weaponNameShort == "javelin" || weaponNameShort == "at4" || weaponNameShort == "m79" || weaponNameShort == "rpg" )
            {
                self takeWeapon( weaponName );
                self giveWeapon( "stinger_mp" );
            }
        }
    }
}
 
isValidPrimary( refString )
{
    switch ( refString )
    {
        case "riotshield":
        case "ak47":
        case "m16":
        case "m4":
        case "fn2000":
        case "m40a3":
        case "masada":
        case "famas":
        case "fal":
        case "scar":
        case "tavor":
        case "mp5k":
        case "uzi":
        case "p90":
        case "kriss":
        case "ump45":
        case "barrett":
        case "wa2000":
        case "m21":
        case "cheytac":
        case "rpd":
        case "sa80":
        case "mg4":
        case "m240":
        case "aug":
        case "remington700":
        case "g36c":
        case "skorpion":
        case "dragunov":
        case "thompson":
        case "peacekeeper":
        case "ak74":
        case "ak47classic":
        case "mk14":
        case "ak74u":
        case "type25":
        case "pp19":
        case "stg44":
        case "msmc":
        case "l96a1":
        case "dsr":
        case "ballista":
        case "an94":
        case "mp40":
        case "m8a1":
        case "ak12":
        case "hamr":
        case "m27":
        case "arx160":
        case "remington_r5":
        case "mp7":
        case "mosin":
        case "msr":
        case "mp5sd":
        case "type95":
        case "svu":
        case "ripper":
        case "pdw":
        case "xpr":
        case "pp90":
        case "hbra3":
        case "sc2010":
        case "as50":
        case "mtar":
        case "smr":
        case "l118a":
            return true;
        default:
            //assertMsg( "Replacing invalid primary weapon: " + refString );
            return false;
    }
}
 
isValidSecondary( refString )
{
    //if (refString == "javelin" && getDvarInt("sv_disablejavelin") == 1)
    //{
    //
    //  return true;
    //}
            
    switch ( refString )
    {
        case "beretta":
        case "usp":
        case "deserteagle":
        case "deserteaglegold":
        case "coltanaconda":
        case "glock":
        case "beretta393":
        case "pp2000":
        case "tmp":
        // replace first
        case "m79":
        case "rpg":
        case "at4":
        case "stinger":
        case "javelin":
        // changes to above code
        case "ranger":
        case "model1887":
        case "striker":
        case "aa12":
        case "m1014":
        case "spas12":
        //case "onemanarmy":
        case "w1200":
        case "colt45":
        case "b23r":
        case "r870_mcs":
        case "kap40":
        case "commando_knife":
        case "re45":
        case "ksg":
            return true;
        default:
            //assertMsg( "Replacing invalid secondary weapon: " + refString );
            return false;
     }
}