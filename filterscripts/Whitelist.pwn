/*


       SCRIPTED BY Asian Gamers ROLEPLAY
     !          KenZo , PATEEERS
     
     DO NOT REMOVE CREDITS
          SCRIPT BOLEH COPY PASTE, IDE? TIDAK BISA.

*/


#include <a_samp>
#include <Pawn.CMD> // GUNAKAN INCLUDE INI DAN NONAKTIFKAN INCLUDE ZCMD JIKA MENGGUNAKAN SCRIPT ATAU GM YANG MENGGUNAKAN SISTEM PAWN CMD SEPERTI GM INFERNO & GM LRP
//#include <zcmd> // AKTIFKAN JIKA MENGGUNAKAN GM SELAIN SISTEM PAWN.CMD
#include <sscanf2>
#include <dini>

/* DEFINE FROM LRP */
#define Servers(%1,%2) SendClientMessage(%1, -1, "{7fffd4}SERVER: {ffffff}"%2)
#define Info(%1,%2) SendClientMessage(%1, -1, "{7fffd4}INFO: {ffffff}"%2)
#define Usage(%1,%2) SendClientMessage(%1, -1 , ">{7fffd4} KEGUNAAN: {ffffff}"%2)
#define Error(%1,%2) SendClientMessage(%1, -1, "{ff0000}ERROR: {ffffff}"%2)

public OnFilterScriptInit()
{
	printf("==========================================================");
	printf("[ Asian Gamers RP ] WHITELIST SCRIPT LOADED");
	printf("==========================================================");
	return 1;
}

stock GetName(playerid)
{
    new name[ 64 ];
    GetPlayerName(playerid, name, sizeof( name ));
    return name;
}

enum E_WHITELIST // ENUM DATA
{
	pWhitelist,
	pAdmin
};
new pData[MAX_PLAYERS][E_WHITELIST];
new File[128];

forward SaveWhitelistSystem(playerid);
public SaveWhitelistSystem(playerid)
{
	format(File, sizeof(File), "[AkunPlayer]/Whitelist/%s.ini", GetName(playerid));
	if( dini_Exists( File ) )
	{
        dini_IntSet(File, "Whitelisted", pData[playerid][pWhitelist]);
        dini_IntSet(File, "Admin", pData[playerid][pAdmin]);
	}
}

forward LoadWhitelistSystem(playerid);
public LoadWhitelistSystem(playerid)
{
	format( File, sizeof( File ), "[AkunPlayer]/Whitelist/%s.ini", GetName(playerid));
    if(dini_Exists(File))//Buat load data user(dikarenakan sudah ada datanya)
    {  
        pData[playerid][pWhitelist] = dini_Int( File,"Whitelisted");
        pData[playerid][pAdmin] = dini_Int( File,"Admin");
    }
    else //Buat user baru(Bikin file buat pemain baru dafar)
    {
    	dini_Create( File );
        dini_IntSet(File, "Whitelisted", 0);
        dini_IntSet(File, "Admin", 0);
        pData[playerid][pWhitelist] = dini_Int( File,"Whitelisted");
        pData[playerid][pAdmin] = dini_Int( File,"Admin");
    }
    if(pData[playerid][pWhitelist] == 0)
	{
		SetTimerEx("Kicked", 3000, 0, "i", playerid);
	}
    return 1;
}

public OnPlayerConnect(playerid)
{
	Servers(playerid, "Memeriksa Status Nickname Anda..");
	LoadWhitelistSystem(playerid);
	return 1;
}

forward Kicked(playerid);
public Kicked(playerid)
{
	new string[512];
	Servers(playerid, "Anda belum terdaftar kedalam Database server ini dan anda tidak akan bisa mengakses Dialog apapun{ffff00}( Kicked )");
	format(string, sizeof string,"{ffffff}Nick Akun Anda:{7fffd4} %s\n\n{ffffff}Setelah diperiksa, Akun ini belum di Whitelist, Harap hubungi kepada Admin/Staff\n\n{ffff00}2020-2021 Asian Gamers Roleplay",GetName(playerid));
	ShowPlayerDialog(playerid, 9842, DIALOG_STYLE_MSGBOX,"{7fff00}Whitelist Asian Gamers:RP", string, "Oke","Keluar");
	SetTimerEx("KickPlayer", 1000, 0, "i", playerid);
	return 1;
}

forward KickPlayer(playerid);
public KickPlayer(playerid)
{
	Kick(playerid);
	return 1;
}

CMD:whitelist(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || pData[playerid][pAdmin] > 0)
	{
		new player[24];
		if(sscanf(params, "s[24]", player))
		{
			Usage(playerid, "/whitelist <name>");
			Info(playerid, "Akan menwhitelist player yang ingin masuk kedalam server.");
			return true;
		}

		format( File, sizeof( File ), "[AkunPlayer]/Whitelist/%s.ini", player);
		if( dini_Exists( File ) )
		{
			dini_IntSet(File, "Whitelisted", 1);
		}
		else
		{
			dini_Create( File );
			dini_IntSet(File, "Whitelisted", 1);
		}
		new fstring[512];
		format(fstring, sizeof fstring,"{7fffd4}WHITELIST: {ffffff}Berhasil menambahkan data whitelist %s", player);
		SendClientMessage(playerid, -1, fstring);
	}
	return true;
}

CMD:unwhitelist(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || pData[playerid][pAdmin] > 0)
	{
		new player[24];
		if(sscanf(params, "s[24]", player))
		{
			Usage(playerid, "/unwhitelist <name>");
			Info(playerid, "Akan menghapus data whitelist player yang ingin masuk kedalam server.");
			return true;
		}

		format( File, sizeof( File ), "[AkunPlayer]/Whitelist/%s.ini", player);
		if( dini_Exists( File ) )
		{
			dini_IntSet(File, "Whitelisted", 0);
		}
		else
		{
			dini_Create( File );
			dini_IntSet(File, "Whitelisted", 1);
		}
		new fstring[512];
		format(fstring, sizeof fstring,"{7fffd4}WHITELIST: {ffffff}Berhasil menambahkan data whitelist %s", player);
		SendClientMessage(playerid, -1,fstring);
	}
	return true;
}

CMD:setwadmin(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || pData[playerid][pAdmin] > 3)
	{
		new player[24];
		if(sscanf(params, "s[24]", player))
		{
			Usage(playerid, "/setwadmin <name>");
			Info(playerid, "Akan menambahkan data Player Admin Whitelist.");
			return true;
		}

		format( File, sizeof( File ), "[AkunPlayer]/Whitelist/%s.ini", player);
		if( dini_Exists( File ) )
		{
			dini_IntSet(File, "Admin", 1);
		}
		else
		{
			dini_Create( File );
			dini_IntSet(File, "Admin", 1);
		}
		new fstring[512];
		format(fstring, sizeof fstring,"{7fffd4}WHITELIST: {ffffff}Berhasil menambahkan data admin %s", player);
		SendClientMessage(playerid, -1,fstring);
	}
	return true;
}
