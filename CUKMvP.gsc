init()
{
    level thread on_player_connect_monitor();
    level thread monitor_players_stats();
}


on_player_connect_monitor()
{
    for (;;)
    {
        level waittill("connected", player);
        player thread setup_player_hud();
    }
}


setup_player_hud()
{
    if (!isDefined(self) || !isPlayer(self)) {
        return;
    }

    
    self.mvp_name_line_hud = maps\mp\gametypes\_hud_util::createFontString("fonts/objectivefont", 1.0);
    self.mvp_name_line_hud.x = 45;
    self.mvp_name_line_hud.y = -30;
    self.mvp_name_line_hud.alignX = "left";
    self.mvp_name_line_hud.alignY = "top";
    self.mvp_name_line_hud.horzAlign = "left";
    self.mvp_name_line_hud.vertAlign = "top";
    self.mvp_name_line_hud.alpha = 1;
    self.mvp_name_line_hud.foreground = true;
    self.mvp_name_line_hud.hidewheninmenu = true;
    self.mvp_name_line_hud.sort = 0;
    self.mvp_name_line_hud setText("^3MVP: ^7N/A"); 

    // MVP Kills and K/D Stats (White)
    self.mvp_stats_line_hud = maps\mp\gametypes\_hud_util::createFontString("fonts/objectivefont", 1.0);
    self.mvp_stats_line_hud.x = 45;
    self.mvp_stats_line_hud.y = -20;
    self.mvp_stats_line_hud.alignX = "left";
    self.mvp_stats_line_hud.alignY = "top";
    self.mvp_stats_line_hud.horzAlign = "left";
    self.mvp_stats_line_hud.vertAlign = "top";
    self.mvp_stats_line_hud.alpha = 1;
    self.mvp_stats_line_hud.foreground = true;
    self.mvp_stats_line_hud.hidewheninmenu = true;
    self.mvp_stats_line_hud.sort = 0;
    self.mvp_stats_line_hud.color = (1, 1, 1); // White
    self.mvp_stats_line_hud setText("^7(Kills: N/A, K/D: N/A)");

    // BOZO Name Line (Gold 'BOZO:' and pink name)
    self.bozo_name_line_hud = maps\mp\gametypes\_hud_util::createFontString("fonts/objectivefont", 1.0);
    self.bozo_name_line_hud.x = 45;
    self.bozo_name_line_hud.y = 0;
    self.bozo_name_line_hud.alignX = "left";
    self.bozo_name_line_hud.alignY = "top";
    self.bozo_name_line_hud.horzAlign = "left";
    self.bozo_name_line_hud.vertAlign = "top";
    self.bozo_name_line_hud.alpha = 1;
    self.bozo_name_line_hud.foreground = true;
    self.bozo_name_line_hud.hidewheninmenu = true;
    self.bozo_name_line_hud.sort = 0;
    self.bozo_name_line_hud.color = (1, 1, 1); // Set to white for proper color code application
    self.bozo_name_line_hud setText("^9BOZO: ^6N/A"); // Gold BOZO, Pink N/A

    // Bozo Deaths Stats (White)
    self.bozo_stats_line_hud = maps\mp\gametypes\_hud_util::createFontString("fonts/objectivefont", 1.0);
    self.bozo_stats_line_hud.x = 55;
    self.bozo_stats_line_hud.y = 10;
    self.bozo_stats_line_hud.alignX = "left";
    self.bozo_stats_line_hud.alignY = "top";
    self.bozo_stats_line_hud.horzAlign = "left";
    self.bozo_stats_line_hud.vertAlign = "top";
    self.bozo_stats_line_hud.alpha = 1;
    self.bozo_stats_line_hud.foreground = true;
    self.bozo_stats_line_hud.hidewheninmenu = true;
    self.bozo_stats_line_hud.sort = 0;
    self.bozo_stats_line_hud.color = (1, 1, 1); // White
    self.bozo_stats_line_hud setText("^7(Deaths: N/A)");
}

// Updates MVP HUD 
update_mvp_hud(mvp_name, mvp_kills, mvp_kd_display, mvp_team)
{
    if (isDefined(self.mvp_name_line_hud) && isDefined(self.mvp_stats_line_hud))
    {
        name_color_code = "^7"; // Default to white
        if (isDefined(mvp_team) && mvp_team != "") {
            if (isDefined(self.team) && self.team == mvp_team) {
                name_color_code = "^2"; // Green for teammate
            } else {
                name_color_code = "^1"; // Red for enemy
            }
        }
        self.mvp_name_line_hud setText("^9MVP: " + name_color_code + mvp_name);
        self.mvp_stats_line_hud setText("^7(Kills: " + mvp_kills + ", K/D: " + mvp_kd_display + ")");
    }
}

// Updates Bozo HUD 
update_bozo_hud(bozo_name, bozo_deaths)
{
    if (isDefined(self.bozo_name_line_hud) && isDefined(self.bozo_stats_line_hud))
    {
        self.bozo_name_line_hud setText("^9BOZO: ^6" + bozo_name); // Gold BOZO, Pink name
        self.bozo_stats_line_hud setText("^7(Deaths: " + bozo_deaths + ")");
    }
}


// Continuously monitor
monitor_players_stats()
{
    level endon("game_ended");

    last_mvp_name = "";
    last_mvp_score = -1;
    last_mvp_kills = -1;
    last_mvp_kd_raw = -1.0;
    last_mvp_team = "";

    last_bozo_name = "";
    last_bozo_deaths = -1;

    for (;;)
    {
        wait 1;

        current_mvp = find_mvp();
        current_bozo = find_bozo_by_deaths();

        // Handle MVP 
        mvp_name_current = "N/A";
        mvp_kills_current = "N/A";
        mvp_deaths_current = "N/A";
        mvp_kd_display_current = "N/A";
        mvp_kd_raw_current = -1.0;
        mvp_team_current = "";
        mvp_score_current = -1;

        if (isDefined(current_mvp))
        {
            mvp_name_current = current_mvp.name;
            mvp_score_current = current_mvp.score;
            mvp_kills_current = current_mvp.kills;
            mvp_deaths_current = current_mvp.deaths;
            mvp_team_current = current_mvp.team;

            if (mvp_deaths_current == 0) {
                if (mvp_kills_current > 0) {
                    mvp_kd_display_current = "Perfect";
                    mvp_kd_raw_current = 999999.0;
                } else {
                    mvp_kd_display_current = "0.00";
                    mvp_kd_raw_current = 0.0;
                }
            } else {
                mvp_kd_raw_current = mvp_kills_current / mvp_deaths_current;
                mvp_kd_display_current = "" + (int(mvp_kd_raw_current * 100) / 100.0);
            }
        }

        if (isDefined(mvp_score_current) && (mvp_name_current != last_mvp_name || mvp_score_current != last_mvp_score ||
            mvp_kills_current != last_mvp_kills || mvp_kd_raw_current != last_mvp_kd_raw ||
            mvp_team_current != last_mvp_team))
        {
            for (i = 0; i < level.players.size; i++)
            {
                player = level.players[i];
                if (isDefined(player) && isPlayer(player))
                {
                    player thread update_mvp_hud(mvp_name_current, mvp_kills_current, mvp_kd_display_current, mvp_team_current);
                }
            }
            last_mvp_name = mvp_name_current;
            last_mvp_score = mvp_score_current;
            last_mvp_kills = mvp_kills_current;
            last_mvp_kd_raw = mvp_kd_raw_current;
            last_mvp_team = mvp_team_current;
        } else if (!isDefined(mvp_score_current) && last_mvp_name != "N/A") {
             for (i = 0; i < level.players.size; i++)
            {
                player = level.players[i];
                if (isDefined(player) && isPlayer(player))
                {
                    player thread update_mvp_hud("N/A", "N/A", "N/A", "");
                }
            }
            last_mvp_name = "N/A";
            last_mvp_score = -1;
            last_mvp_kills = -1;
            last_mvp_kd_raw = -1.0;
            last_mvp_team = "";
        }

        // Handle Bozo  
        bozo_name_current = "N/A";
        bozo_deaths_current = "N/A";
        bozo_score_current = 999999;

        if (isDefined(current_bozo))
        {
            bozo_name_current = current_bozo.name;
            bozo_deaths_current = current_bozo.deaths;
            bozo_score_current = current_bozo.score;
        }

        if (isDefined(bozo_score_current) && (bozo_name_current != last_bozo_name || bozo_deaths_current != last_bozo_deaths))
        {
            for (i = 0; i < level.players.size; i++)
            {
                player = level.players[i];
                if (isDefined(player) && isPlayer(player))
                {
                    player thread update_bozo_hud(bozo_name_current, bozo_deaths_current);
                }
            }
            last_bozo_name = bozo_name_current;
            last_bozo_deaths = bozo_deaths_current;
            last_bozo_score = bozo_score_current;
        } else if (!isDefined(bozo_score_current) && last_bozo_name != "N/A") {
            for (i = 0; i < level.players.size; i++)
            {
                player = level.players[i];
                if (isDefined(player) && isPlayer(player))
                {
                    player thread update_bozo_hud("N/A", "N/A");
                }
            }
            last_bozo_name = "N/A";
            last_bozo_deaths = -1;
            last_bozo_score = 999999;
        }
    }
}

// Finds the player with the highest score.
find_mvp()
{
    best_player = undefined;
    highest_score = -1;

    for (i = 0; i < level.players.size; i++)
    {
        player = level.players[i];
        if (isDefined(player) && isPlayer(player) && isDefined(player.score))
        {
            if (player.score > highest_score)
            {
                highest_score = player.score;
                best_player = player;
            }
        }
    }
    return best_player;
}

// Finds the player with the highest deaths.
find_bozo_by_deaths()
{
    worst_player = undefined;
    highest_deaths = -1;

    for (i = 0; i < level.players.size; i++)
    {
        player = level.players[i];
        if (isDefined(player) && isPlayer(player) && isDefined(player.deaths))
        {
            if (player.deaths > highest_deaths)
            {
                highest_deaths = player.deaths;
                worst_player = player;
            }
        }
    }
    return worst_player;
}

