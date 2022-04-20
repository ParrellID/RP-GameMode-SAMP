/*
                                                                    dddddddd
   SSSSSSSSSSSSSSS hhhhhhh                                          d::::::d
 SS:::::::::::::::Sh:::::h                                          d::::::d
S:::::SSSSSS::::::Sh:::::h                                          d::::::d
S:::::S     SSSSSSSh:::::h                                          d:::::d
S:::::S             h::::h hhhhh         aaaaaaaaaaaaa      ddddddddd:::::d
S:::::S             h::::hh:::::hhh      a::::::::::::a   dd::::::::::::::d
 S::::SSSS          h::::::::::::::hh    aaaaaaaaa:::::a d::::::::::::::::d
  SS::::::SSSSS     h:::::::hhh::::::h            a::::ad:::::::ddddd:::::d
    SSS::::::::SS   h::::::h   h::::::h    aaaaaaa:::::ad::::::d    d:::::d
       SSSSSS::::S  h:::::h     h:::::h  aa::::::::::::ad:::::d     d:::::d
            S:::::S h:::::h     h:::::h a::::aaaa::::::ad:::::d     d:::::d
            S:::::S h:::::h     h:::::ha::::a    a:::::ad:::::d     d:::::d
SSSSSSS     S:::::S h:::::h     h:::::ha::::a    a:::::ad::::::ddddd::::::dd
S::::::SSSSSS:::::S h:::::h     h:::::ha:::::aaaa::::::a d:::::::::::::::::d
S:::::::::::::::SS  h:::::h     h:::::h a::::::::::aa:::a d:::::::::ddd::::d
 SSSSSSSSSSSSSSS    hhhhhhh     hhhhhhh  aaaaaaaaaa  aaaa  ddddddddd   ddddd
*/


#include <a_samp>
#define FILTERSCRIPT

new Text:Time;
new Text:JamLex[2];

forward settime(playerid);

public OnGameModeInit()
{
	print("\n--------------------------------------");
	print(" Updated Version! WORLDCLOCK+DATE By Shadow");
	print("--------------------------------------\n");

    SetTimer("settime",1000,true);


	Time = TextDrawCreate(56.000000, 229.000000, "18:00");

	TextDrawFont(Time,3);
	TextDrawLetterSize(Time,0.600000, 2.000000);
	TextDrawColor(Time,0xFFFFFFFF);
	
	JamLex[0] = TextDrawCreate(87.000000, 229.000000, "_");
    TextDrawFont(JamLex[0], 1);
    TextDrawLetterSize(JamLex[0], 0.570833, 2.399986);
    TextDrawTextSize(JamLex[0], 298.500000, 75.000000);
    TextDrawSetOutline(JamLex[0], 1);
    TextDrawSetShadow(JamLex[0], 0);
    TextDrawAlignment(JamLex[0], 2);
    TextDrawColor(JamLex[0], -1);
    TextDrawBackgroundColor(JamLex[0], 255);
    TextDrawBoxColor(JamLex[0], 135);
    TextDrawUseBox(JamLex[0], 1);
    TextDrawSetProportional(JamLex[0], 1);
    TextDrawSetSelectable(JamLex[0], 0);

    JamLex[1] = TextDrawCreate(44.000000, 250.000000, "WPRP");
    TextDrawFont(JamLex[1], 1);
    TextDrawLetterSize(JamLex[1], 0.600000, 2.000000);
    TextDrawTextSize(JamLex[1], 400.000000, 17.000000);
    TextDrawSetOutline(JamLex[1], 1);
    TextDrawSetShadow(JamLex[1], 0);
    TextDrawAlignment(JamLex[1], 1);
    TextDrawColor(JamLex[1], -65281);
    TextDrawBackgroundColor(JamLex[1], 255);
    TextDrawBoxColor(JamLex[1], 50);
    TextDrawUseBox(JamLex[1], 0);
    TextDrawSetProportional(JamLex[1], 1);
    TextDrawSetSelectable(JamLex[1], 0);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	TextDrawShowForPlayer(playerid, Time);
	TextDrawShowForPlayer(playerid, JamLex[0]);
	TextDrawShowForPlayer(playerid, JamLex[1]);

	return 1;
}
public OnPlayerConnect(playerid)
{
	TextDrawShowForPlayer(playerid, Time);
	TextDrawShowForPlayer(playerid, JamLex[0]);
	TextDrawShowForPlayer(playerid, JamLex[1]);

	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	TextDrawHideForPlayer(playerid, Time);
	TextDrawHideForPlayer(playerid, JamLex[0]);
	TextDrawHideForPlayer(playerid, JamLex[1]);
	return 1;
}

public settime(playerid)
{

	new string[256],minutes,seconds;
    gettime( minutes, seconds);
	format(string, sizeof string, "%s%d:%s%d", (minutes < 10) ? ("0") : (""), minutes, (seconds < 10) ? ("0") : (""), seconds);
	TextDrawSetString(Time, string);
}
