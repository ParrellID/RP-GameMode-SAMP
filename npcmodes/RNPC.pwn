#include <a_npc>
/*
	RNPC NPC script
	Version 0.3 	@ 13.7.2012
	Version 0.3.3 	@ 24.5.2014
	Mauzen
	
	Communication codes:
		Server -> NPC:
			101:<slot> 		Start playing back ID recording
			102				Stop current playback
			109				Start playing back the following recording file
			110				Disable autorepeat
			111				Enable autorepeat
			
		NPC -> Server:
			001:<version>	Notification about join
			002				Notification about finished playback
			003				Notification about stopped playback
		
			201:<slot>		Started vehicle playback
			202:<slot>		Started on-foot playback
			208				Started custom file playback on-foot
			209				Started custom file playback in vehicle

*/

// Buildnumber of this NPC script, should match the number of the RNPC include
#define RNPC_SCRIPT_VERSION			"10"

new npcid;
new vehicle;
new repeat;
new curplayback[32];

main(){}

public OnNPCEnterVehicle(vehicleid, seatid)
{
	vehicle = true;
}

public OnNPCExitVehicle()
{
	vehicle = false;
}

public OnNPCConnect(myplayerid)
{	
    npcid = myplayerid;
	// Register at server
	SendCommand("RNPC:001:"RNPC_SCRIPT_VERSION);
}
public OnRecordingPlaybackEnd() 
{	
	SendCommand("RNPC:002");
	if (repeat) {
		new rec[9];
		if (vehicle) {
			StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER, curplayback);
			format(rec, sizeof(rec), "RNPC:201");
		} else {
			StartRecordingPlayback(PLAYER_RECORDING_TYPE_ONFOOT, curplayback);
			format(rec, sizeof(rec), "RNPC:202");
		}
		SendCommand(rec);
	}
}

public OnClientMessage(color, text[])
{
    if (!strcmp(text,"RNPC:101", false, 8))
    {
		new slot = strval(text[9]);
		new rec[12];
        format(curplayback, 32, "rnpc%03d-%02d", npcid, slot);
		
		StopRecordingPlayback();
        if (vehicle) {
			StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER, curplayback);
			format(rec, 12, "RNPC:201:%d", slot);
		} else {
			StartRecordingPlayback(PLAYER_RECORDING_TYPE_ONFOOT, curplayback);
			format(rec, 12, "RNPC:202:%d", slot);
		}
		
        SendCommand(rec);
		return;
    }
	
	if (!strcmp(text,"RNPC:102",false))
	{
		StopRecordingPlayback();
		SendCommand("RNPC:003");
		return;
	}
	
	if (!strcmp(text,"RNPC:109:",false, 9))
    {
		new rec[9];
		format(curplayback, 32, text[9]);
		// Remove trailing .rec to prevent crash
		if (strfind(curplayback, ".rec", true) > -1) {
			strmid(curplayback, curplayback, 0, strlen(curplayback) - 4);
		}
		StopRecordingPlayback();
        if (vehicle) {
			StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER, curplayback);
			format(rec, 8, "RNPC:208");
		} else {
			StartRecordingPlayback(PLAYER_RECORDING_TYPE_ONFOOT, curplayback);
			format(rec, 8, "RNPC:209");
		}
		
        SendCommand(rec);
		return;
    }
	
	if (!strcmp(text,"RNPC:110",false))
    {
		repeat = 0;
		return;
    }
	
	if (!strcmp(text,"RNPC:111",false))
    {
		repeat = 1;
		return;
    }
}