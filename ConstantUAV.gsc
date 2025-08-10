init()
{
    if (getDvar("g_gametype") == "dm")
    {
        level thread enableConstantServerRadar();
    }
}


enableConstantServerRadar()
{
    for(;;) // LOOP 
    {
        foreach(player in level.players)
        {
            player.hasradar = 1;
        }
        wait 1;
    }
}