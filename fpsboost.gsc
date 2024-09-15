
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;


init()
{
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );		
		
		if( !isDefined( player.message_shown) )
			player.message_shown = 0;
		
		if( !isDefined( player.cur_bright ) )
			player.cur_bright = 0;
		
		player thread watchButton();
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");
		
		if( !self.message_shown ) {
			self.message_shown = 1;
			self iPrintlnBold( "Welcome to ^6CUKServers ^7Press ^6N ^7for HIGH FPS" );
		}
		
		// Workaround for nightvision, this is very importanto!
		self _SetActionSlot( 1, "" );
	}
}

watchButton()
{
	self endon("disconnect");
	
	self notifyOnPlayerCommand( "fpsboost", "+actionslot 1" );
	
	for(;;) {
		self waittill( "fpsboost" );
		
		self.cur_bright = !self.cur_bright;
		self setClientDvar( "r_fullbright", self.cur_bright );
		
		if( self.cur_bright )
			self iPrintlnBold( "^7High FPS ^6On" );
		else 
			self iPrintlnBold( "^7High FPS ^6Off" );
	}
	
}


