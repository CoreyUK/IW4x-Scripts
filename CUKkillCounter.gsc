#include maps\mp\gametypes\_hud_util;

main()
{
    level thread OnPlayerConnected();
    //iprintlnBold("Killstreak Script Loaded");
}

OnPlayerConnected()
{
    for(;;)
    {
        level waittill("connected", player);
        
        // Ignore bots
        if (isDefined(player.pers["isBot"]) && player.pers["isBot"])
        {
            continue;
        }

        player thread WatchPlayerSpawns();
    }
}

WatchPlayerSpawns()
{
    self endon("disconnect");

    while(true)
    {
        self waittill("spawned_player");
        self thread DisplayPlayerKillstreak();
    }
}

DisplayPlayerKillstreak()
{
    self endon("disconnect");
    self endon("death");
    level endon("game_ended");

    if (isDefined(self.killstreak_text))
    {
        self.killstreak_text destroy();
    }
    
    self.killstreak_text = self createFontString("hudsmall", 0.8);
    self.killstreak_text setPoint("BOTTOMLEFT", "BOTTOMLEFT", 105, -10);
    self.killstreak_text setText("^3KILLSTREAK: 0");

    while(true)
    {
        wait 0.1;

        if (isDefined(self.pers["cur_kill_streak"]))
        {
            self.killstreak_text setText("^3KILLSTREAK: " + self.pers["cur_kill_streak"]);
        }
    }
}
