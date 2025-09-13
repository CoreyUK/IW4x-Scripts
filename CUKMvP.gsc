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
    self.mvp_stats_line_hud.color = (1, 1, 1);
    self.mvp_stats_line_hud setText("^7(Kills: N/A, K/D: N/A)");

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
    self.bozo_name_line_hud.color = (1, 1, 1);
    self.bozo_name_line_hud setText("^9BOZO: ^6N/A");

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
    self.bozo_stats_line_hud.color = (1, 1, 1);
    self.bozo_stats_line_hud setText("^7(Deaths: N/A)");
}

update_mvp_hud(mvp_name, mvp_kills, mvp_kd_display, mvp_team)
{
    if (isDefined(self.mvp_name_line_hud) && isDefined(self.mvp_stats_line_hud))
    {
        name_color_code = "^7";
        if (isDefined(mvp_team) && mvp_team != "") {
            if (isDefined(self.team) && self.team == mvp_team) {
                name_color_code = "^2";
            } else {
                name_color_code = "^1";
            }
        }
        self.mvp_name_line_hud setText("^9MVP: " + name_color_code + mvp_name);
        self.mvp_stats_line_hud setText("^7(Kills: " + mvp_kills + ", K/D: " + mvp_kd_display + ")");
    }
}

update_bozo_hud(bozo_name, bozo_deaths)
{
    if (isDefined(self.bozo_name_line_hud) && isDefined(self.bozo_stats_line_hud))
    {
        self.bozo_name_line_hud setText("^9BOZO: ^6" + bozo_name);
        self.bozo_stats_line_hud setText("^7(Deaths: " + bozo_deaths + ")");
    }
}

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

        // Check and update MVP if stats have changed
        mvp_name_current = isDefined(current_mvp) ? current_mvp.name : "N/A";
        mvp_score_current = isDefined(current_mvp) ? current_mvp.score : -1;
        mvp_kills_current = isDefined(current_mvp) ? current_mvp.kills : -1;
        mvp_deaths_current = isDefined(current_mvp) ? current_mvp.deaths : -1;
        mvp_team_current = isDefined(current_mvp) ? current_mvp.team : "";

        if (mvp_name_current != last_mvp_name || mvp_score_current != last_mvp_score ||
            mvp_kills_current != last_mvp_kills || mvp_team_current != last_mvp_team)
        {
            mvp_kd_display_current = "N/A";
            if (isDefined(current_mvp)) {
                if (mvp_deaths_current == 0) {
                    mvp_kd_display_current = (mvp_kills_current > 0) ? "Perfect" : "0.00";
                } else {
                    mvp_kd_raw_current = mvp_kills_current / mvp_deaths_current;
                    mvp_kd_display_current = "" + (int(mvp_kd_raw_current * 100) / 100.0);
                }
            }

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
            last_mvp_team = mvp_team_current;
        }

        // Check and update Bozo if deaths have changed
        bozo_name_current = isDefined(current_bozo) ? current_bozo.name : "N/A";
        bozo_deaths_current = isDefined(current_bozo) ? current_bozo.deaths : -1;

        if (bozo_name_current != last_bozo_name || bozo_deaths_current != last_bozo_deaths)
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
        }
    }
}


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
