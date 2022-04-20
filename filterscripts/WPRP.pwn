/***************************************************************************************
                         Subscribe Channel Youtube XYROOZ OFFICIAL

                           **********************************
						   ** Lapar Haus & Speedometer V1  **
                           ** Created By RyaNn12           **
						   ** Youtube  : XYROOZ OFFICIAL   **
						   ** Whatsapp : 082121470406      **
						   ** Discord  : R12 STORE         **
					  	   **********************************

           Bila Ada Perlu Dengan Saya Silahkan Hubungi Kontak Saya Yang Di Atas
****************************************************************************************/

#include <a_samp>
#include <dini>
#include <progress>
#include <zcmd>
#include <streamer>

#define MAX_HUNGER_AMOUNT 100
#define MAX_THIRST_AMOUNT 100
#define MAX_OBJ 10000
#define INVNUMBERS 9 // items yang tersedia di toko(menu Shop)
#define 	Dialog_Inventory 		2000
#define 	Dialog_Choose 			2001
#define 	Dialog_TakeInv 			2002
#define     DIALOG_MENUSHOP        2003
#define     DIALOG_MAKAN            2004
#define     DIALOG_MINUM            2005
#define     DIALOG_DLL              2006
#define 	COLOR_RED 				0xFF0000FF
#define		COLOR_GREY 				0xAFAFAFAA

/////////TEXTDRAW XYROOZ//////////
new Text:LaparHaus_TD[6],
	Text:Speedometer_TD[17],
	Text:PName_TD;
//////////////////////////////////

//Speedometer
new vehicleFuel[MAX_VEHICLES] = {100, ...};
new const vehNames[212][] = {
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster",
    "Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
    "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Article Trailer", "Previon", "Coach",
    "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow",
    "Pizzaboy", "Tram", "Article Trailer 2", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
    "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic",
    "Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton",
    "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher",
    "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick",
    "Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher",
    "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stuntplane", "Tanker", "Roadtrain",
    "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck",
    "Fortune", "Cadrona", "SWAT Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan",
    "Blade", "Streak", "Freight", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder",
    "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster", "Monster",
    "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30",
    "Huntley", "Stafford", "BF-400", "News Van", "Tug", "Petrol Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
    "Freight Box", "Article Trailer 3", "Andromada", "Dodo", "RC Cam", "Launch", "LSPD Car", "SFPD Car", "LVPD Car",
    "Police Rancher", "Picador", "S.W.A.T", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs",
    "Boxville", "Tiller", "Utility Trailer"
};
bool:isWawVehicle(vehid)
{
	switch(GetVehicleModel(vehid))
	{
		case 481, 509, 510: return true;
	}
	return false;
}
Float:GetVehicleSpeed(vehicleid)
{
	new
	    Float:x,
	    Float:y,
	    Float:z;

	if(GetVehicleVelocity(vehicleid, x, y, z))
	{
		return floatsqroot((x * x) + (y * y) + (z * z)) * 181.5;
	}

	return 0.0;
}
GetCarName(vehicleid)
{
	new
		modelid = GetVehicleModel(vehicleid),
		name[32];

	if(400 <= modelid <= 611)
	    strcat(name, vehNames[modelid - 400]);
	else
	    name = "Unknown";

	return name;
}
//////////////////
enum PlayerInfo
{
    pLapar,
    pHaus,

    pPack,
    pSlots 
}
new pInfo[MAX_PLAYERS][PlayerInfo];

enum dInvEnum
{
Float:ObjPos[3],
    ObjID,
    ObjData
};

new PlayerInv[MAX_PLAYERS][INVNUMBERS];

new InvNames[INVNUMBERS][] =
{
    "Empty",
	//makanan
 	"Donat",
	"Oreol",
	"Tacos",
	//minumana
	"Bir",
	"Jus Apel",
	"Jus Jeruk",
    "Sprunk",
    //dll
	"Tas Adidos"
	//buat obj baru
};

new InvObjects[INVNUMBERS] =
{
    1581,
    //makanan
    2880,//donat
    19573,//oreol
    2769,//tacos
	//minuman
	1486,//bir
	19564,//jus apel
	19563,//jus jeruk
	2856,//softdrink
	//dll
    3026     //TAS

};
enum subinfo
{
    iD_sub[64],
    iD_text[256]
};

new InfoSub[INVNUMBERS][subinfo] = {
    {"Kosong", "Kosong."},
	//makanan
    {"Donat", "Donat adalah penganan yang digoreng, dibuat \ndari adonan tepung terigu, gula, telur, dan mentega\n> Mengurangi rasa lapar\n> +15 Lapar"},
	{"Oreol", "Oreol sebuah cemilan biskuit coklat yang digemari anak muda,\ndan anda bisa jadi macan karena motonya 'SEMUA BISA JADI MACAN' :V\n> menghilangkan rasa lapar\n> +14 Lapar"},
	{"Tacos", "Taco adalah makanan khas Meksiko yang terdiri atas gulungan atau lipatan tortilla \nyang diisi dengan berbagai macam masakan di dalamnya.\n> menghilangkan rasa lapar\n> +13 Lapar"},
	//minuman
	{"Bir", "Bir adalah minuman beralkohol yang diproduksi melalui \nproses fermentasi bahan berpati tanpa melalui proses penyulingan setelah fermentasi.\n> Mengurangi rasa haus\n> +35 Haus"},
    {"Jus Apel", "Minuman rasa apel \n> Mengurangi rasa haus\n> +45 Haus"},
    {"Jus Jeruk", "Minuman rasa jeruk\n> Mengurangi rasa haus\n> +45 Haus"},
	{"Softdrink", "Minuman berenergi\n> Mengurangi rasa haus\n> +25 Haus"},
	//dll
    {"Tas", "Menambah Slot Tas Anda menjadi 20 Slot"}
};
new dInvData[MAX_OBJ][dInvEnum];
new total_vehicles_from_files=3000;
new PlayerAdminMassage[MAX_PLAYERS][INVNUMBERS];
new playermassagetoadmin[MAX_PLAYERS];

new
	Bar:lapar[MAX_PLAYERS],
	Bar:haus[MAX_PLAYERS];

new File[ 128 ];

public OnFilterScriptInit()
{
	print("\n~~~LAPAR HAUS & SPEEDOMETER V1~~~\n~~~CREATED BY XYROOZ OFFICIAL~~~\n");
	return 1;
}

public OnGameModeInit()
{
	print("\n~~~LAPAR HAUS & SPEEDOMETER V1~~~\n~~~CREATED BY XYROOZ OFFICIAL~~~\n");

    SetTimer("ProcessAllPlayers",150000,1);//Buat update stats progres bar lapar dan haus nya

	//TD Lapar & Haus
	LaparHaus_TD[0] = TextDrawCreate(480.102050, 357.090881, "BOX UTAMA");
	TextDrawLetterSize(LaparHaus_TD[0], 0.000000, 16.000005);
	TextDrawTextSize(LaparHaus_TD[0], 646.591796, 0.000000);
	TextDrawAlignment(LaparHaus_TD[0], 1);
	TextDrawColor(LaparHaus_TD[0], -1);
	TextDrawUseBox(LaparHaus_TD[0], 1);
	TextDrawBoxColor(LaparHaus_TD[0], 175);
	TextDrawSetShadow(LaparHaus_TD[0], 0);
	TextDrawBackgroundColor(LaparHaus_TD[0], 175);
	TextDrawFont(LaparHaus_TD[0], 1);
	TextDrawSetProportional(LaparHaus_TD[0], 1);

	LaparHaus_TD[1] = TextDrawCreate(480.300903, 356.811340, "BOX NAMA PLAYER");
	TextDrawLetterSize(LaparHaus_TD[1], 0.000000, 1.449999);
	TextDrawTextSize(LaparHaus_TD[1], 671.796386, 0.000000);
	TextDrawAlignment(LaparHaus_TD[1], 1);
	TextDrawColor(LaparHaus_TD[1], -1);
	TextDrawUseBox(LaparHaus_TD[1], 1);
	TextDrawBoxColor(LaparHaus_TD[1], 41215);
	TextDrawSetShadow(LaparHaus_TD[1], 0);
	TextDrawBackgroundColor(LaparHaus_TD[1], 200); //65535);
	TextDrawFont(LaparHaus_TD[1], 1);
	TextDrawSetProportional(LaparHaus_TD[1], 1);

	LaparHaus_TD[2] = TextDrawCreate(521.499328, 367.549835, "GARIS PANJANG");
	TextDrawLetterSize(LaparHaus_TD[2], 0.000000, 9.749999);
	TextDrawTextSize(LaparHaus_TD[2], 520.999511, 0.000000);
	TextDrawAlignment(LaparHaus_TD[2], 1);
	TextDrawColor(LaparHaus_TD[2], -1);
	TextDrawUseBox(LaparHaus_TD[2], 1);
	TextDrawBoxColor(LaparHaus_TD[2], 41215);
	TextDrawSetShadow(LaparHaus_TD[2], 0);
	TextDrawBackgroundColor(LaparHaus_TD[2], 255);
	TextDrawFont(LaparHaus_TD[2], 1);
	TextDrawSetProportional(LaparHaus_TD[2], 1);

	LaparHaus_TD[3] = TextDrawCreate(480.099822, 410.084838, "GARIS LEBAR");
	TextDrawLetterSize(LaparHaus_TD[3], 0.000000, -0.178998);
	TextDrawTextSize(LaparHaus_TD[3], 638.399902, 0.000000);
	TextDrawAlignment(LaparHaus_TD[3], 1);
	TextDrawColor(LaparHaus_TD[3], -1);
	TextDrawUseBox(LaparHaus_TD[3], 1);
	TextDrawBoxColor(LaparHaus_TD[3], 41215);
	TextDrawSetShadow(LaparHaus_TD[3], 0);
	TextDrawBackgroundColor(LaparHaus_TD[3], 255);
	TextDrawFont(LaparHaus_TD[3], 1);
	TextDrawSetProportional(LaparHaus_TD[3], 1);

	LaparHaus_TD[4] = TextDrawCreate(473.600158, 346.844543, "");
	TextDrawTextSize(LaparHaus_TD[4], 50.000000, 69.000000);
	TextDrawAlignment(LaparHaus_TD[4], 1);
	TextDrawColor(LaparHaus_TD[4], -1);
	TextDrawBackgroundColor(LaparHaus_TD[4], 0);
	TextDrawSetShadow(LaparHaus_TD[4], 0);
	TextDrawFont(LaparHaus_TD[4], 5);
	TextDrawSetProportional(LaparHaus_TD[4], 0);
	TextDrawSetPreviewModel(LaparHaus_TD[4], 19568);
	TextDrawSetPreviewRot(LaparHaus_TD[4], 90.000000, 0.000000, 0.000000, 1.000000);

	LaparHaus_TD[5] = TextDrawCreate(479.500000, 409.367095, "");
	TextDrawTextSize(LaparHaus_TD[5], 35.000000, 43.000000);
	TextDrawAlignment(LaparHaus_TD[5], 1);
	TextDrawColor(LaparHaus_TD[5], -1);
	TextDrawBackgroundColor(LaparHaus_TD[5], 0);
	TextDrawSetShadow(LaparHaus_TD[5], 0);
	TextDrawFont(LaparHaus_TD[5], 5);
	TextDrawSetProportional(LaparHaus_TD[5], 0);
	TextDrawSetPreviewModel(LaparHaus_TD[5], 2647);
	TextDrawSetPreviewRot(LaparHaus_TD[5], 20.000000, 0.000000, 90.000000, 1.000000);

	//TD Speedometer
	Speedometer_TD[0] = TextDrawCreate(346.002166, 357.144409, "BOX SPEEDOMETER");
	TextDrawLetterSize(Speedometer_TD[0], 0.000000, 16.100008);
	TextDrawTextSize(Speedometer_TD[0], 474.902252, 0.000000);
	TextDrawAlignment(Speedometer_TD[0], 1);
	TextDrawColor(Speedometer_TD[0], -1);
	TextDrawUseBox(Speedometer_TD[0], 1);
	TextDrawBoxColor(Speedometer_TD[0], 175);
	TextDrawSetShadow(Speedometer_TD[0], 0);
	TextDrawBackgroundColor(Speedometer_TD[0], 175);
	TextDrawFont(Speedometer_TD[0], 1);
	TextDrawSetProportional(Speedometer_TD[0], 1);

	Speedometer_TD[1] = TextDrawCreate(346.100189, 357.055664, "box");
	TextDrawLetterSize(Speedometer_TD[1], 0.000000, 1.450993);
	TextDrawTextSize(Speedometer_TD[1], 474.921630, 0.000000);
	TextDrawAlignment(Speedometer_TD[1], 1);
	TextDrawColor(Speedometer_TD[1], -1);
	TextDrawUseBox(Speedometer_TD[1], 1);
	TextDrawBoxColor(Speedometer_TD[1], 41215);
	TextDrawSetShadow(Speedometer_TD[1], 0);
	TextDrawBackgroundColor(Speedometer_TD[1], 255);
	TextDrawFont(Speedometer_TD[1], 1);
	TextDrawSetProportional(Speedometer_TD[1], 1);

	Speedometer_TD[2] = TextDrawCreate(364.200042, 357.211334, "SPEEDOMETER");
	TextDrawLetterSize(Speedometer_TD[2], 0.400000, 1.320000);
	TextDrawAlignment(Speedometer_TD[2], 1);
	TextDrawColor(Speedometer_TD[2], 16711935);
	TextDrawSetShadow(Speedometer_TD[2], 0);
	TextDrawSetOutline(Speedometer_TD[2], 1);
	TextDrawBackgroundColor(Speedometer_TD[2], -16776961);
	TextDrawFont(Speedometer_TD[2], 3);
	TextDrawSetProportional(Speedometer_TD[2], 1);

	Speedometer_TD[3] = TextDrawCreate(401.102691, 374.755828, "GARIS 1");
	TextDrawLetterSize(Speedometer_TD[3], 0.000000, 12.541005);
	TextDrawTextSize(Speedometer_TD[3], 401.000000, 0.000000);
	TextDrawAlignment(Speedometer_TD[3], 1);
	TextDrawColor(Speedometer_TD[3], -1);
	TextDrawUseBox(Speedometer_TD[3], 1);
	TextDrawBoxColor(Speedometer_TD[3], 41215);
	TextDrawSetShadow(Speedometer_TD[3], 0);
	TextDrawBackgroundColor(Speedometer_TD[3], 255);
	TextDrawFont(Speedometer_TD[3], 1);
	TextDrawSetProportional(Speedometer_TD[3], 1);

	Speedometer_TD[4] = TextDrawCreate(346.500000, 392.844573, "GARIS 2");
	TextDrawLetterSize(Speedometer_TD[4], 0.000000, -0.157000);
	TextDrawTextSize(Speedometer_TD[4], 474.836914, 0.000000);
	TextDrawAlignment(Speedometer_TD[4], 1);
	TextDrawColor(Speedometer_TD[4], -1);
	TextDrawUseBox(Speedometer_TD[4], 1);
	TextDrawBoxColor(Speedometer_TD[4], 41215);
	TextDrawSetShadow(Speedometer_TD[4], 0);
	TextDrawBackgroundColor(Speedometer_TD[4], 255);
	TextDrawFont(Speedometer_TD[4], 1);
	TextDrawSetProportional(Speedometer_TD[4], 1);

	Speedometer_TD[5] = TextDrawCreate(350.000000, 374.822265, "INFERNUS");
	TextDrawLetterSize(Speedometer_TD[5], 0.287000, 1.338666);
	TextDrawAlignment(Speedometer_TD[5], 1);
	TextDrawColor(Speedometer_TD[5], -65281);
	TextDrawSetShadow(Speedometer_TD[5], 0);
	TextDrawBackgroundColor(Speedometer_TD[5], 255);
	TextDrawFont(Speedometer_TD[5], 1);
	TextDrawSetProportional(Speedometer_TD[5], 1);

	Speedometer_TD[6] = TextDrawCreate(342.899963, 381.422454, "");
	TextDrawTextSize(Speedometer_TD[6], 55.000000, 73.000000);
	TextDrawAlignment(Speedometer_TD[6], 1);
	TextDrawColor(Speedometer_TD[6], -1);
	TextDrawSetShadow(Speedometer_TD[6], 0);
	TextDrawBackgroundColor(Speedometer_TD[6], 1);
	TextDrawFont(Speedometer_TD[6], 5);
	TextDrawSetProportional(Speedometer_TD[6], 0);
	TextDrawSetPreviewRot(Speedometer_TD[6], -10.000000, 0.000000, 60.000000, 1.000000);
	TextDrawSetPreviewVehCol(Speedometer_TD[6], 3, 3);

	Speedometer_TD[7] = TextDrawCreate(439.505035, 374.755828, "GARIS 3");
	TextDrawLetterSize(Speedometer_TD[7], 0.000000, 12.541005);
	TextDrawTextSize(Speedometer_TD[7], 439.402343, 0.000000);
	TextDrawAlignment(Speedometer_TD[7], 1);
	TextDrawColor(Speedometer_TD[7], -1);
	TextDrawUseBox(Speedometer_TD[7], 1);
	TextDrawBoxColor(Speedometer_TD[7], 41215);
	TextDrawSetShadow(Speedometer_TD[7], 0);
	TextDrawBackgroundColor(Speedometer_TD[7], 255);
	TextDrawFont(Speedometer_TD[7], 1);
	TextDrawSetProportional(Speedometer_TD[7], 1);

	Speedometer_TD[8] = TextDrawCreate(402.203369, 428.946777, "GARIS 4");
	TextDrawLetterSize(Speedometer_TD[8], 0.000000, -0.150000);
	TextDrawTextSize(Speedometer_TD[8], 475.000000, 0.000000);
	TextDrawAlignment(Speedometer_TD[8], 1);
	TextDrawColor(Speedometer_TD[8], -1);
	TextDrawUseBox(Speedometer_TD[8], 1);
	TextDrawBoxColor(Speedometer_TD[8], 41215);
	TextDrawSetShadow(Speedometer_TD[8], 0);
	TextDrawBackgroundColor(Speedometer_TD[8], 255);
	TextDrawFont(Speedometer_TD[8], 1);
	TextDrawSetProportional(Speedometer_TD[8], 1);

	Speedometer_TD[9] = TextDrawCreate(406.000050, 374.866668, "SPEED");
	TextDrawLetterSize(Speedometer_TD[9], 0.299499, 1.369777);
	TextDrawAlignment(Speedometer_TD[9], 1);
	TextDrawColor(Speedometer_TD[9], -65281);
	TextDrawSetShadow(Speedometer_TD[9], 0);
	TextDrawBackgroundColor(Speedometer_TD[9], 255);
	TextDrawFont(Speedometer_TD[9], 1);
	TextDrawSetProportional(Speedometer_TD[9], 1);

	Speedometer_TD[10] = TextDrawCreate(447.702595, 374.866668, "FUEL");
	TextDrawLetterSize(Speedometer_TD[10], 0.299499, 1.369777);
	TextDrawAlignment(Speedometer_TD[10], 1);
	TextDrawColor(Speedometer_TD[10], -65281);
	TextDrawSetShadow(Speedometer_TD[10], 0);
	TextDrawBackgroundColor(Speedometer_TD[10], 255);
	TextDrawFont(Speedometer_TD[10], 1);
	TextDrawSetProportional(Speedometer_TD[10], 1);

	Speedometer_TD[11] = TextDrawCreate(404.000020, 415.611175, "KM/H");
	TextDrawLetterSize(Speedometer_TD[11], 0.373500, 1.027555);
	TextDrawAlignment(Speedometer_TD[11], 1);
	TextDrawColor(Speedometer_TD[11], -16776961);
	TextDrawSetShadow(Speedometer_TD[11], 0);
	TextDrawSetOutline(Speedometer_TD[11], -1);
	TextDrawBackgroundColor(Speedometer_TD[11], 255);
	TextDrawFont(Speedometer_TD[11], 1);
	TextDrawSetProportional(Speedometer_TD[11], 1);

	Speedometer_TD[12] = TextDrawCreate(442.002270, 416.611236, "LITTER");
	TextDrawLetterSize(Speedometer_TD[12], 0.373500, 1.027555);
	TextDrawAlignment(Speedometer_TD[12], 1);
	TextDrawColor(Speedometer_TD[12], -16776961);
	TextDrawSetShadow(Speedometer_TD[12], 0);
	TextDrawSetOutline(Speedometer_TD[12], -1);
	TextDrawBackgroundColor(Speedometer_TD[12], 255);
	TextDrawFont(Speedometer_TD[12], 1);
	TextDrawSetProportional(Speedometer_TD[12], 1);

	Speedometer_TD[13] = TextDrawCreate(441.000000, 429.744384, "");
	TextDrawTextSize(Speedometer_TD[13], 38.000000, 20.000000);
	TextDrawAlignment(Speedometer_TD[13], 1);
	TextDrawColor(Speedometer_TD[13], -1);
	TextDrawSetShadow(Speedometer_TD[13], 0);
	TextDrawBackgroundColor(Speedometer_TD[13], 1);
	TextDrawFont(Speedometer_TD[13], 5);
	TextDrawSetProportional(Speedometer_TD[13], 0);
	TextDrawSetPreviewModel(Speedometer_TD[13], 3287);
	TextDrawSetPreviewRot(Speedometer_TD[13], 0.000000, 0.000000, 20.000000, 1.000000);

	Speedometer_TD[14] = TextDrawCreate(408.800079, 423.944580, "");
	TextDrawTextSize(Speedometer_TD[14], 23.000000, 30.000000);
	TextDrawAlignment(Speedometer_TD[14], 1);
	TextDrawColor(Speedometer_TD[14], -1);
	TextDrawSetShadow(Speedometer_TD[14], 0);
	TextDrawBackgroundColor(Speedometer_TD[14], 1);
	TextDrawFont(Speedometer_TD[14], 5);
	TextDrawSetProportional(Speedometer_TD[14], 0);
	TextDrawSetPreviewModel(Speedometer_TD[14], 1422);
	TextDrawSetPreviewRot(Speedometer_TD[14], 0.000000, 0.000000, 0.000000, 1.000000);

	Speedometer_TD[15] = TextDrawCreate(412.600006, 396.655670, "65");
	TextDrawLetterSize(Speedometer_TD[15], 0.400000, 1.600000);
	TextDrawAlignment(Speedometer_TD[15], 1);
	TextDrawColor(Speedometer_TD[15], 16711935);
	TextDrawSetShadow(Speedometer_TD[15], 0);
	TextDrawBackgroundColor(Speedometer_TD[15], 255);
	TextDrawFont(Speedometer_TD[15], 3);
	TextDrawSetProportional(Speedometer_TD[15], 1);

	Speedometer_TD[16] = TextDrawCreate(442.000000, 396.655670, "39");
	TextDrawLetterSize(Speedometer_TD[16], 0.400000, 1.600000);
	TextDrawAlignment(Speedometer_TD[16], 1);
	TextDrawColor(Speedometer_TD[16], 16711935);
	TextDrawSetShadow(Speedometer_TD[16], 0);
	TextDrawBackgroundColor(Speedometer_TD[16], 255);
	TextDrawFont(Speedometer_TD[16], 3);
	TextDrawSetProportional(Speedometer_TD[16], 1);

	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerConnect(playerid)
{
    ResetVariablePemain(playerid);

	lapar[playerid] = CreateProgressBar(532.700000, 386.245880, 100.000000, 9.000000, 16711935, 100.000000);
	haus[playerid] = CreateProgressBar(532.700000, 425.348266, 100.000000, 9.000000, 16777215, 100.000000);
	format( File, sizeof( File ), "LaparHaus/%s.txt", GetName(playerid));
    if(dini_Exists(File))//Buat load data user(dikarenakan sudah ada datanya)
    {
		pInfo[playerid][pLapar] = dini_Int( File,"Lapar");
		pInfo[playerid][pHaus] = dini_Int( File,"Haus");
		pInfo[playerid][pPack] = dini_Int( File,"Pack");
		pInfo[playerid][pSlots] = dini_Int( File,"Slots");
        for(new i=0;i<INVNUMBERS;i++)
        {
            new idstr[256];
            format(idstr, sizeof(idstr), "id%d", i);
            PlayerInv[playerid][i] = dini_Int( File, idstr );
        }
    }
    else //Buat user baru(Bikin file buat pemain baru dafar)
    {
        dini_Create( File );
		dini_IntSet(File,"Lapar",100);
		dini_IntSet(File,"Haus",100);
        dini_IntSet(File, "Pack", 0);
		dini_IntSet(File, "Slots", 0);
        for(new i=0;i<INVNUMBERS;i++)
		{
			new idstr[256];
			format(idstr, sizeof(idstr), "id%d",i);
			dini_IntSet(File, idstr,0);
		}
		pInfo[playerid][pLapar] = dini_Int( File,"Lapar");
		pInfo[playerid][pHaus] = dini_Int( File,"Haus");
		return 1;
  	}
  	
	new PlayerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
	
	PName_TD = TextDrawCreate(481.500000, 354.722503, "Nama_Player");
	TextDrawLetterSize(PName_TD, 0.428000, 1.712000);
	TextDrawTextSize(PName_TD, 1.000000, 0.000000);
	TextDrawAlignment(PName_TD, 1);
	TextDrawColor(PName_TD, 16711935);
	TextDrawSetShadow(PName_TD, 0);
	TextDrawSetOutline(PName_TD, 1);
	TextDrawBackgroundColor(PName_TD, -16776961);
	TextDrawFont(PName_TD, 1);
	TextDrawSetProportional(PName_TD, 1);
	TextDrawSetString(PName_TD,PlayerName);
	SendClientMessage(playerid, 0xffff00FF, "{00FF00}SERVER TERPASANG LAPAR HAUS & SPEEDOMETER V1"); // JANGAN HAPUS ATAU EDIT INI [ CREDIT OR AUTOHOR ]
	SendClientMessage(playerid, 0xffff00FF, "{00FF00}CREATED BY XYROOZ OFFICIAL | SUBSCRIBE MY CHANNEL YOUTUBE !"); // JANGAN HAPUS ATAU EDIT INI [ CREDIT OR AUTOHOR ]

	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    format(File, sizeof(File), "LaparHaus/%s.txt", GetName(playerid));
   	if( dini_Exists( File ) )
    {
    	dini_IntSet(File,"Lapar",pInfo[playerid][pLapar]);
		dini_IntSet(File,"Haus",pInfo[playerid][pHaus]);
        dini_IntSet(File, "Pack", pInfo[playerid][pPack]);
		dini_IntSet(File, "Slots", pInfo[playerid][pSlots]);
        for(new i=0;i<INVNUMBERS;i++)
		{
			new idstr[256];
			format(idstr, sizeof(idstr), "id%d",i);
			dini_IntSet(File, idstr, PlayerInv[playerid][i]);
		}
	}
	
	HideProgressBarForPlayer(playerid, lapar[playerid]);
   	HideProgressBarForPlayer(playerid, haus[playerid]);
	//TDHide Lapar & Haus
	TextDrawHideForPlayer(playerid, LaparHaus_TD[0]);
	TextDrawHideForPlayer(playerid, LaparHaus_TD[1]);
	TextDrawHideForPlayer(playerid, LaparHaus_TD[2]);
	TextDrawHideForPlayer(playerid, LaparHaus_TD[3]);
	TextDrawHideForPlayer(playerid, LaparHaus_TD[4]);
	TextDrawHideForPlayer(playerid, LaparHaus_TD[5]);
	TextDrawHideForPlayer(playerid, PName_TD);

	//TDHide Speedometer
	TextDrawHideForPlayer(playerid, Speedometer_TD[0]);
	TextDrawHideForPlayer(playerid, Speedometer_TD[1]);
	TextDrawHideForPlayer(playerid, Speedometer_TD[2]);
	TextDrawHideForPlayer(playerid, Speedometer_TD[3]);
	TextDrawHideForPlayer(playerid, Speedometer_TD[4]);
	TextDrawHideForPlayer(playerid, Speedometer_TD[5]);
	TextDrawHideForPlayer(playerid, Speedometer_TD[6]);
	TextDrawHideForPlayer(playerid, Speedometer_TD[7]);
	TextDrawHideForPlayer(playerid, Speedometer_TD[8]);
	TextDrawHideForPlayer(playerid, Speedometer_TD[9]);
	TextDrawHideForPlayer(playerid, Speedometer_TD[10]);
	TextDrawHideForPlayer(playerid, Speedometer_TD[11]);
	TextDrawHideForPlayer(playerid, Speedometer_TD[12]);
	TextDrawHideForPlayer(playerid, Speedometer_TD[13]);
	TextDrawHideForPlayer(playerid, Speedometer_TD[14]);
	TextDrawHideForPlayer(playerid, Speedometer_TD[15]);
	TextDrawHideForPlayer(playerid, Speedometer_TD[16]);
	
	return 1;
}

public OnPlayerSpawn(playerid)
{
   	SetProgressBarValue(lapar[playerid], pInfo[playerid][pLapar]);
   	SetProgressBarValue(haus[playerid], pInfo[playerid][pHaus]);
	ShowProgressBarForPlayer(playerid, lapar[playerid]);
   	ShowProgressBarForPlayer(playerid, haus[playerid]);
   	
   	//TDShow Lapar & Haus
	TextDrawShowForPlayer(playerid, LaparHaus_TD[0]);
	TextDrawShowForPlayer(playerid, LaparHaus_TD[1]);
	TextDrawShowForPlayer(playerid, LaparHaus_TD[2]);
	TextDrawShowForPlayer(playerid, LaparHaus_TD[3]);
	TextDrawShowForPlayer(playerid, LaparHaus_TD[4]);
	TextDrawShowForPlayer(playerid, LaparHaus_TD[5]);
	TextDrawShowForPlayer(playerid, PName_TD);

	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == Dialog_Inventory)
    {
        if(response == 1)
        {
            if(listitem == 0)
            {
                PakeItems(playerid,playermassagetoadmin[playerid]);
            }
            if(listitem == 1)
            {
                if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "Kamu tidak dapat melakukan ini di dalam mobil!");
                if(PlayerInv[playerid][playermassagetoadmin[playerid]] == 0) return 1;
                new str[128],Float:posz[3]; 
                GetPlayerPos(playerid,posz[0],posz[1],posz[2]); 
                BarangJatuh(playermassagetoadmin[playerid],posz[0],posz[1],posz[2]);
                format(str,sizeof(str),"{A9A9A9}* Kamu telah menjatuhkan %s dari tas Kamu",InvNames[playermassagetoadmin[playerid]]);
                PlayerInv[playerid][playermassagetoadmin[playerid]]--; 
                pInfo[playerid][pSlots] --;

				SendClientMessage(playerid,0xFF0000FF,str);
                total_vehicles_from_files++;
            }
            if(listitem == 2)
            {
                new string[512], Desc_sub[512], nazvanie_one[64], Name_sub[64];
                strmid(Name_sub, InfoSub[playermassagetoadmin[playerid]][iD_sub], 0, strlen(InfoSub[playermassagetoadmin[playerid]][iD_sub]), 255);
                strmid(Desc_sub, InfoSub[playermassagetoadmin[playerid]][iD_text], 0, strlen(InfoSub[playermassagetoadmin[playerid]][iD_text]), 512);
                format(nazvanie_one, sizeof(nazvanie_one),"%s", Name_sub);
                format(string, sizeof(string), "%s", Desc_sub);
                ShowPlayerDialog(playerid,465,DIALOG_STYLE_MSGBOX,nazvanie_one,string,"OK","");
            }
        }
        return 1;
    }

    if(dialogid == Dialog_Choose)
    {
        if(response == 1)
        {
            new nazvanie_one[64];
            playermassagetoadmin[playerid] = PlayerAdminMassage[playerid][listitem];
            format(nazvanie_one, sizeof(nazvanie_one),  "%s", InvNames[playermassagetoadmin[playerid]]);
            new listitems[] = "- Gunakan\n- Buang\n- Info";
            ShowPlayerDialog(playerid,Dialog_Inventory,DIALOG_STYLE_LIST,nazvanie_one,listitems,"Pilih","Kembali");

        }
        if(response == 0)
        {
        }
        return 1;
    }
    if(dialogid == Dialog_TakeInv)
    {
        playermassagetoadmin[playerid] = PlayerAdminMassage[playerid][listitem];
        if(response == 1)
        {
            if(dInvData[playermassagetoadmin[playerid]][ObjData] == 0) return SendClientMessage(playerid, 0xA9A9A9FF, "* Maaf, Kamu tidak bisa ambil objek ini");
            new buffer[120];
            format(buffer, sizeof(buffer), "* %s Sudah tersimpan di tas.", InvNames[dInvData[playermassagetoadmin[playerid]][ObjData]]);
            if(pInfo[playerid][pPack] == 0)
            {
            	if(pInfo[playerid][pSlots]  >= 10) return SendClientMessage(playerid, 0xA9A9A9FF, "* Tas kamu Penuh, Cobalah buang sesuatu.");
            }
			if(pInfo[playerid][pPack] == 1)
			{
			    if(pInfo[playerid][pSlots]  >= 20) return SendClientMessage(playerid, 0xA9A9A9FF, "* Tas kamu Penuh, Cobalah buang sesuatu.");
			}
			if(PlayerInv[playerid][dInvData[playermassagetoadmin[playerid]][ObjData]] > 0) PlayerInv[playerid][dInvData[playermassagetoadmin[playerid]][ObjData]] +=1, pInfo[playerid][pSlots] ++;
            else PlayerInv[playerid][dInvData[playermassagetoadmin[playerid]][ObjData]] +=1, pInfo[playerid][pSlots] ++;
			SendClientMessage(playerid, 0xA9A9A9FF, buffer);
		}
   		total_vehicles_from_files--;
     	DestroyDynamicObject(dInvData[playermassagetoadmin[playerid]][ObjID]);
      	dInvData[playermassagetoadmin[playerid]][ObjPos][0] = 0.0;
       	dInvData[playermassagetoadmin[playerid]][ObjPos][1] = 0.0;
       	dInvData[playermassagetoadmin[playerid]][ObjPos][2] = 0.0;
       	dInvData[playermassagetoadmin[playerid]][ObjID] = -1;
        dInvData[playermassagetoadmin[playerid]][ObjData] = 0;
        MungutItems(playerid);
        return 1;
	}
	if(dialogid == DIALOG_MENUSHOP)
	{
		if(response == 1)
        {
            if(listitem == 0)
            {
                menumakan(playerid);
			}
            if(listitem == 1)
            {
				menuminum(playerid);
			}
            if(listitem == 2)
			{
                dll(playerid);
			}
		}
	    if(response == 0)return SendClientMessage(playerid, -1, "Kalo Ada Perlu Silahkan Datang Lagi.");
	}
	if(dialogid == DIALOG_MAKAN)
	{
	    if(response == 0)return menuindoapril(playerid);
	    if(response == 1)
        {
            if(listitem == 0)
            {
                if(pInfo[playerid][pPack] == 0)
	            {
	            	if(pInfo[playerid][pSlots]  >= 10) return SendClientMessage(playerid, 0xA9A9A9FF, "* Tas kamu Penuh, Cobalah buang sesuatu.");
				}
				if(pInfo[playerid][pPack] == 1)
				{
				    if(pInfo[playerid][pSlots]  >= 20) return SendClientMessage(playerid, 0xA9A9A9FF, "* Tas kamu Penuh, Cobalah buang sesuatu.");
				}
                if(GetPlayerMoney(playerid) <3) return SendClientMessage(playerid, COLOR_RED, "* Uang Anda Tidak Cukup Untuk Membeli Item!");
				pInfo[playerid][pSlots] = pInfo[playerid][pSlots]+1;
				PlayerInv[playerid][1] = PlayerInv[playerid][1]+ 1;
				GivePlayerMoney(playerid, -3);
 				SendClientMessage(playerid, 0xA9A9A9FF, "* Kamu membeli Donat !" );
				menuindoapril(playerid);
			}
			if(listitem == 1)
			{
			    if(pInfo[playerid][pPack] == 0)
	            {
	            	if(pInfo[playerid][pSlots]  >= 10) return SendClientMessage(playerid, 0xA9A9A9FF, "* Tas kamu Penuh, Cobalah buang sesuatu.");
				}
				if(pInfo[playerid][pPack] == 1)
				{
				    if(pInfo[playerid][pSlots]  >= 20) return SendClientMessage(playerid, 0xA9A9A9FF, "* Tas kamu Penuh, Cobalah buang sesuatu.");
				}
                if(GetPlayerMoney(playerid) <6) return SendClientMessage(playerid, COLOR_RED, "* Uang Anda Tidak Cukup Untuk Membeli Item!");
				pInfo[playerid][pSlots] = pInfo[playerid][pSlots]+1;
				PlayerInv[playerid][2] = PlayerInv[playerid][2]+ 1;
				GivePlayerMoney(playerid, -6);
 				SendClientMessage(playerid, 0xA9A9A9FF, "* Kamu membeli Oreol !" );
				menuindoapril(playerid);
			}
			if(listitem == 2)
			{
			    if(pInfo[playerid][pPack] == 0)
	            {
	            	if(pInfo[playerid][pSlots]  >= 10) return SendClientMessage(playerid, 0xA9A9A9FF, "* Tas kamu Penuh, Cobalah buang sesuatu.");
				}
				if(pInfo[playerid][pPack] == 1)
				{
				    if(pInfo[playerid][pSlots]  >= 20) return SendClientMessage(playerid, 0xA9A9A9FF, "* Tas kamu Penuh, Cobalah buang sesuatu.");
				}
                if(GetPlayerMoney(playerid) <2) return SendClientMessage(playerid, COLOR_RED, "* Uang Anda Tidak Cukup Untuk Membeli Item!");
				pInfo[playerid][pSlots] = pInfo[playerid][pSlots]+1;
				PlayerInv[playerid][3] = PlayerInv[playerid][3]+ 1;
				GivePlayerMoney(playerid, -2);
 				SendClientMessage(playerid, 0xA9A9A9FF, "* Kamu membeli Tacos !" );
				menuindoapril(playerid);
			}
		}
	}
	if(dialogid == DIALOG_MINUM)
	{
	    if(response == 0)return menuindoapril(playerid);
	    if(response == 1)
        {
            if(listitem == 0)
            {
	            if(pInfo[playerid][pPack] == 0)
	            {
	            	if(pInfo[playerid][pSlots]  >= 10) return SendClientMessage(playerid, 0xA9A9A9FF, "* Tas kamu Penuh, Cobalah buang sesuatu.");
				}
				if(pInfo[playerid][pPack] == 1)
				{
				    if(pInfo[playerid][pSlots]  >= 20) return SendClientMessage(playerid, 0xA9A9A9FF, "* Tas kamu Penuh, Cobalah buang sesuatu.");
				}
                if(GetPlayerMoney(playerid) <10) return SendClientMessage(playerid, COLOR_RED, "* Uang Anda Tidak Cukup Untuk Membeli Item!");
				pInfo[playerid][pSlots] = pInfo[playerid][pSlots]+1;
				PlayerInv[playerid][4] = PlayerInv[playerid][4]+ 1; 
				GivePlayerMoney(playerid, -10);
 				SendClientMessage(playerid, 0xA9A9A9FF, "* Kamu membeli Bir !" );
				menuindoapril(playerid);
            }
            if(listitem == 1)
			{
	            if(pInfo[playerid][pPack] == 0)
	            {
	            	if(pInfo[playerid][pSlots]  >= 10) return SendClientMessage(playerid, 0xA9A9A9FF, "* Tas kamu Penuh, Cobalah buang sesuatu.");
				}
				if(pInfo[playerid][pPack] == 1)
				{
				    if(pInfo[playerid][pSlots]  >= 20) return SendClientMessage(playerid, 0xA9A9A9FF, "* Tas kamu Penuh, Cobalah buang sesuatu.");
				}
                if(GetPlayerMoney(playerid) <3) return SendClientMessage(playerid, COLOR_RED, "* Uang Anda Tidak Cukup Untuk Membeli Item!");
				pInfo[playerid][pSlots] = pInfo[playerid][pSlots]+1;
				PlayerInv[playerid][5] = PlayerInv[playerid][5]+ 1;
				GivePlayerMoney(playerid, -3);
 				SendClientMessage(playerid, 0xA9A9A9FF, "* Kamu membeli Jus apel !" );
    			menuindoapril(playerid);
	        }
			if(listitem == 2)
			{
			    if(pInfo[playerid][pPack] == 0)
	            {
	            	if(pInfo[playerid][pSlots]  >= 10) return SendClientMessage(playerid, 0xA9A9A9FF, "* Tas kamu Penuh, Cobalah buang sesuatu.");
				}
				if(pInfo[playerid][pPack] == 1)
				{
				    if(pInfo[playerid][pSlots]  >= 20) return SendClientMessage(playerid, 0xA9A9A9FF, "* Tas kamu Penuh, Cobalah buang sesuatu.");
				}
                if(GetPlayerMoney(playerid) <3) return SendClientMessage(playerid, COLOR_RED, "* Uang Anda Tidak Cukup Untuk Membeli Item!");
				pInfo[playerid][pSlots] = pInfo[playerid][pSlots]+1;
				PlayerInv[playerid][6] = PlayerInv[playerid][6]+ 1; 
				GivePlayerMoney(playerid, -3);
 				SendClientMessage(playerid, 0xA9A9A9FF, "* Kamu membeli Jus jeruk !" );
				menuindoapril(playerid);
			}
			if(listitem == 3)
			{
			    if(pInfo[playerid][pPack] == 0)
	            {
	            	if(pInfo[playerid][pSlots]  >= 10) return SendClientMessage(playerid, 0xA9A9A9FF, "* Tas kamu Penuh, Cobalah buang sesuatu.");
				}
				if(pInfo[playerid][pPack] == 1)
				{
				    if(pInfo[playerid][pSlots]  >= 20) return SendClientMessage(playerid, 0xA9A9A9FF, "* Tas kamu Penuh, Cobalah buang sesuatu.");
				}
                if(GetPlayerMoney(playerid) <3) return SendClientMessage(playerid, COLOR_RED, "* Uang Anda Tidak Cukup Untuk Membeli Item!");
				pInfo[playerid][pSlots] = pInfo[playerid][pSlots]+1;
				PlayerInv[playerid][7] = PlayerInv[playerid][7]+ 1;
				GivePlayerMoney(playerid, -3);
 				SendClientMessage(playerid, 0xA9A9A9FF, "* Kamu membeli Sprunk !" );
				menuindoapril(playerid);
			}
		}
	}
	if(dialogid == DIALOG_DLL)
	{
	    if(response == 0)return menuindoapril(playerid);
	    if(response == 1)
        {
            if(listitem == 0)
       	 	{
                if(pInfo[playerid][pPack] == 0)
	            {
	            	if(pInfo[playerid][pSlots]  >= 10) return SendClientMessage(playerid, 0xA9A9A9FF, "* Tas kamu Penuh, Cobalah buang sesuatu.");
				}
				if(pInfo[playerid][pPack] == 1)
				{
				    if(pInfo[playerid][pSlots]  >= 20) return SendClientMessage(playerid, 0xA9A9A9FF, "* Tas kamu Penuh, Cobalah buang sesuatu.");
				}
                if(GetPlayerMoney(playerid) <50) return SendClientMessage(playerid, COLOR_RED, "* Uang Anda Tidak Cukup Untuk Membeli Item!");
				pInfo[playerid][pSlots] = pInfo[playerid][pSlots]+1;
				PlayerInv[playerid][8] = PlayerInv[playerid][8]+ 1;
				GivePlayerMoney(playerid, -50);
 				SendClientMessage(playerid, 0xA9A9A9FF, "* Kamu membeli Tas !" );
			}
		}
	}
	return 1;
}

public OnPlayerUpdate(playerid)
{
    if( IsPlayerInAnyVehicle( playerid ) && GetPlayerState( playerid ) == PLAYER_STATE_DRIVER ) {
	    new vehicle = GetPlayerVehicleID( playerid );
	    if( !isWawVehicle( vehicle ) ) {

			new string[ 32 ];
			format( string, sizeof( string ), "~g~~h~~h~%.0f", GetVehicleSpeed( vehicle ) );
			TextDrawSetString(Speedometer_TD[15], string);

			new stringic[ 32 ];
			format( stringic, sizeof( stringic ), "~g~~h~~h~_%d", vehicleFuel[ vehicle ] );
			TextDrawSetString(Speedometer_TD[16], stringic);
		}
	}
	return 1;
}
public OnPlayerStateChange(playerid, newstate, oldstate)
{
 	if(newstate == PLAYER_STATE_DRIVER)
	{
        new vstr[ 30 ];
		format( vstr, sizeof( vstr ), "~r~~h~%s", GetCarName(GetPlayerVehicleID(playerid)));
		TextDrawSetString(Speedometer_TD[5], vstr );
		
		TextDrawSetPreviewModel(Speedometer_TD[6], GetVehicleModel( GetPlayerVehicleID( playerid )));
        TextDrawShowForPlayer(playerid, Speedometer_TD[6]);
        
		if( !isWawVehicle( GetPlayerVehicleID( playerid ) ) )
		{
			//TDShow Speedometer
			TextDrawShowForPlayer(playerid, Speedometer_TD[0]);
			TextDrawShowForPlayer(playerid, Speedometer_TD[1]);
			TextDrawShowForPlayer(playerid, Speedometer_TD[2]);
			TextDrawShowForPlayer(playerid, Speedometer_TD[3]);
			TextDrawShowForPlayer(playerid, Speedometer_TD[4]);
			TextDrawShowForPlayer(playerid, Speedometer_TD[5]);
			TextDrawShowForPlayer(playerid, Speedometer_TD[7]);
			TextDrawShowForPlayer(playerid, Speedometer_TD[8]);
			TextDrawShowForPlayer(playerid, Speedometer_TD[9]);
			TextDrawShowForPlayer(playerid, Speedometer_TD[10]);
			TextDrawShowForPlayer(playerid, Speedometer_TD[11]);
			TextDrawShowForPlayer(playerid, Speedometer_TD[12]);
			TextDrawShowForPlayer(playerid, Speedometer_TD[13]);
			TextDrawShowForPlayer(playerid, Speedometer_TD[14]);
			TextDrawShowForPlayer(playerid, Speedometer_TD[15]);
			TextDrawShowForPlayer(playerid, Speedometer_TD[16]);
		}
	}
	else if(oldstate == PLAYER_STATE_DRIVER)
	{
		//TDHide Speedometer
		TextDrawHideForPlayer(playerid, Speedometer_TD[0]);
		TextDrawHideForPlayer(playerid, Speedometer_TD[1]);
		TextDrawHideForPlayer(playerid, Speedometer_TD[2]);
		TextDrawHideForPlayer(playerid, Speedometer_TD[3]);
		TextDrawHideForPlayer(playerid, Speedometer_TD[4]);
		TextDrawHideForPlayer(playerid, Speedometer_TD[5]);
		TextDrawHideForPlayer(playerid, Speedometer_TD[6]);
		TextDrawHideForPlayer(playerid, Speedometer_TD[7]);
		TextDrawHideForPlayer(playerid, Speedometer_TD[8]);
		TextDrawHideForPlayer(playerid, Speedometer_TD[9]);
		TextDrawHideForPlayer(playerid, Speedometer_TD[10]);
		TextDrawHideForPlayer(playerid, Speedometer_TD[11]);
		TextDrawHideForPlayer(playerid, Speedometer_TD[12]);
		TextDrawHideForPlayer(playerid, Speedometer_TD[13]);
		TextDrawHideForPlayer(playerid, Speedometer_TD[14]);
		TextDrawHideForPlayer(playerid, Speedometer_TD[15]);
		TextDrawHideForPlayer(playerid, Speedometer_TD[16]);
	}
	return 1;
}

CMD:menuresto(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 50.0, 377.3607, -67.4345, 1001.5078))
	{
		menuindoapril(playerid);
	}
	else SendClientMessage(playerid, 0xCECECEFF, "{FF0000}Anda Harus Di Restoran !");

    return 1;
}

CMD:ransel(playerid)
{
    if(pInfo[playerid][pSlots] < 0 || pInfo[playerid][pSlots] == 0) return SendClientMessage(playerid,-1,"{FF0000}Isi Ransel Anda Kosong !");
	Inventory(playerid);
	return 1;
}

CMD:ambil(playerid)
{
    if(IsPlayerInVehicle(playerid,GetPlayerVehicleID(playerid))) return SendClientMessage(playerid,-1,"[SERVER] Kamu tidak bisa memakai command ini ketika sedang berkendara!");
	MungutItems(playerid);
	return 1;
}

//------------------------------------------------------------------------------
// Callback Dialog
//------------------------------------------------------------------------------

menumakan(playerid)
{
	new DiaString[1024];
	format(DiaString, 1024, "{FFFFFF}Donat \t$3 \nOreol \t$6\nTacos \t$2");
	ShowPlayerDialog(playerid, DIALOG_MAKAN, DIALOG_STYLE_LIST, "Menu Restoran", DiaString, "Beli", "Kembali");
}

menuminum(playerid)
{
	new String[500];

	format(String, 1024, "{FFFFFF}Bir \t$10 \nJus Apel \t$3 \n");
	format(String, 1024, "%s{FFFFFF}Jus Jeruk \t$3 \nSoftdrink \t$4 \n",String);
	ShowPlayerDialog(playerid, DIALOG_MINUM, DIALOG_STYLE_LIST, "Menu Restoran",String, "Beli", "Kembali");
}

menuindoapril(playerid)
{
	new String[100];

	format(String, 1024, "{FFFFFF}Makanan\n");
	format(String, 1024, "%s{FFFFFF}Minuman\n", String);
	format(String, 1024, "%s{FFFFFF}Dan Lain - Lain\n", String);

	ShowPlayerDialog(playerid, DIALOG_MENUSHOP, DIALOG_STYLE_LIST, "Menu Restoran", String, "Pilih", "Tutup");
	return 1;
}

dll(playerid)
{
	new String[100];
	format(String, 1024, "{FFFFFF}Tas \t$50\n", String);
	ShowPlayerDialog(playerid, DIALOG_DLL, DIALOG_STYLE_LIST, "Menu Restoran", String, "Beli", "Kembali");
}

//------------------------------------------------------------------------------
// bagian Forward
//------------------------------------------------------------------------------
forward ProcessAllPlayers();
forward ProcessPlayerHunger(playerid);
forward ProcessPlayerThirsty(playerid);

public ProcessPlayerHunger(playerid)
{
    pInfo[ playerid ][ pLapar ] = pInfo[ playerid ][ pLapar ]-1;
    if(pInfo[ playerid ][ pLapar ] <= 4)
    {
    	new Float:health;
        GetPlayerHealth(playerid,health);
        //SetPlayerHealth(playerid, health -10);
        SendClientMessage(playerid,-1,"* Kamu Mulai merasa Lapar");
    }
    return 1;
}

public ProcessPlayerThirsty(playerid)
{
    pInfo[ playerid ][ pHaus ] = pInfo[ playerid ][ pHaus ]-1;
    if(pInfo[ playerid ][ pHaus ] <= 4)
    {
    	new Float:health;
        GetPlayerHealth(playerid,health);
        //SetPlayerHealth(playerid, health -10);
        SendClientMessage(playerid,-1,"* Kamu Mulai Haus");
    }
    return 1;
}


public ProcessAllPlayers()
{
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
	    if(IsPlayerConnected(i))
        {
            ProcessPlayerHunger(i);

            ProcessPlayerThirsty(i);

            SetProgressBarValue(lapar[i], pInfo[ i ][ pLapar ]);
		    UpdateProgressBar(lapar[i], i);
		    SetProgressBarValue(haus[i], pInfo[ i ][ pHaus ]);
		   	UpdateProgressBar(haus[i], i);
        }
    }
    return 1;
}
//------------------------------------------------------------------------------
// bagian Stock
//------------------------------------------------------------------------------
stock GetName(playerid)
{
    new name[ 32 ];
    GetPlayerName(playerid, name, sizeof( name ));
    return name;
}

stock ResetVariablePemain(playerid)
{
	pInfo[playerid][pLapar] = 0;
	pInfo[playerid][pHaus] = 0;
	pInfo[playerid][pPack] = 0;
	pInfo[playerid][pSlots] = 0;
    for(new i=0;i<INVNUMBERS;i++)
    {
        PlayerInv[playerid][i] = 0;
    }
	return 1;
}

stock MungutItems(playerid)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
    new f = total_vehicles_from_files+1;
    new str[1024], listitems[1024], adm=0;
    for(new a = 0; a < total_vehicles_from_files; a++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 1.8, dInvData[a][ObjPos][0], dInvData[a][ObjPos][1], dInvData[a][ObjPos][2]))
        {
            f = a;
            PlayerAdminMassage[playerid][adm] = f;
            adm ++;
            format(str, sizeof(str), "%s\n", InvNames[dInvData[f][ObjData]]);
            if(dInvData[f][ObjData] > 0) strins(listitems, str, strlen(listitems), strlen(str));
        }
    }
    if(f > total_vehicles_from_files) return 1;
    ShowPlayerDialog(playerid,Dialog_TakeInv,DIALOG_STYLE_LIST,"Barang Yang Terlihat",listitems,"Ambil","Buang");
    return 1;
}

stock Inventory(playerid)
{
   	new str[1024], slotstr[1024];
    new listitems[1024], adm=0;
    for(new slot;slot<INVNUMBERS;slot++)
    {
        if(PlayerInv[playerid][slot] > 0 && slot != 0)
        {
            PlayerAdminMassage[playerid][adm] = slot;
            adm ++;
            format(str, sizeof(str), "[%d]\t%s\n", PlayerInv[playerid][slot],InvNames[slot]);
            strins(listitems, str, strlen(listitems), strlen(str));
        }
    }
    if(pInfo[playerid][pPack] == 0) format(slotstr,sizeof(slotstr),"Penyimpanan Tas [%d/10]",pInfo[playerid][pSlots]);
    if(pInfo[playerid][pPack] == 1) format(slotstr,sizeof(slotstr),"Penyimpanan Tas [%d/%d]",pInfo[playerid][pSlots],pInfo[playerid][pPack]*20);
    ShowPlayerDialog(playerid,Dialog_Choose,DIALOG_STYLE_LIST,slotstr,listitems,"Pilih","Keluar");
    return 1;
}

stock BarangJatuh(id, Float:gPosX, Float:gPosY, Float:gPosZ)
{
    if(id == 0) return 1;
    new f = total_vehicles_from_files+1;
    for(new a = 0; a < total_vehicles_from_files; a++)
    {
        if(dInvData[a][ObjPos][0] == 0.0)
        {
            f = a;
            break;
        }
    }
    if(f > total_vehicles_from_files) return 1;

    dInvData[f][ObjData] = id;
    dInvData[f][ObjPos][0] = gPosX;
    dInvData[f][ObjPos][1] = gPosY;
    dInvData[f][ObjPos][2] = gPosZ;
    new x_l = random(2);
    new y_l = random(2);
    dInvData[f][ObjID] = CreateDynamicObject(InvObjects[id], dInvData[f][ObjPos][0]+x_l, dInvData[f][ObjPos][1]+y_l, dInvData[f][ObjPos][2]-0.8, 0.0, 360.0, 250.0);
    if(id == 78) SetDynamicObjectMaterial(dInvData[f][ObjID], 0, 2060, "cj_ammo", "CJ_CANVAS2", 0);
	return 1;
}

stock PakeItems(playerid,itemid)
{
    if(itemid == 1)
    {
        pInfo[playerid][pLapar] = pInfo[playerid][pLapar]+15;
        PlayerInv[playerid][itemid]--;
        pInfo[playerid][pSlots] --;
        if(pInfo[playerid][pLapar] > MAX_HUNGER_AMOUNT)
        {
            pInfo[playerid][pLapar] = MAX_HUNGER_AMOUNT;
		}
        SendClientMessage(playerid,0xA9A9A9ff,"* Anda Sedang makan donat");
        ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 1, 1, 1, 1, 1);
        SetProgressBarValue(lapar[playerid], pInfo[ playerid ][ pLapar ]);
	    UpdateProgressBar(lapar[playerid], playerid);
    }
    if(itemid == 2)
    {
        pInfo[playerid][pLapar] = pInfo[playerid][pLapar]+14;
        PlayerInv[playerid][itemid]--;
        pInfo[playerid][pSlots] --;
        if(pInfo[playerid][pLapar] > MAX_HUNGER_AMOUNT)
        {
            pInfo[playerid][pLapar] = MAX_HUNGER_AMOUNT;
		}
        SendClientMessage(playerid,0xA9A9A9ff,"* Anda Sedang makan oreol");
        ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 1, 1, 1, 1, 1);
        SetProgressBarValue(lapar[playerid], pInfo[ playerid ][ pLapar ]);
	    UpdateProgressBar(lapar[playerid], playerid);
    }
    if(itemid == 3)
    {
        pInfo[playerid][pLapar] = pInfo[playerid][pLapar]+13;
        PlayerInv[playerid][itemid]--;
        pInfo[playerid][pSlots] --;
        if(pInfo[playerid][pLapar] > MAX_HUNGER_AMOUNT)
        {
            pInfo[playerid][pLapar] = MAX_HUNGER_AMOUNT;
		}
        SendClientMessage(playerid,0xA9A9A9ff,"* Anda Sedang makan tacos");
        ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 1, 1, 1, 1, 1);
        SetProgressBarValue(lapar[playerid], pInfo[ playerid ][ pLapar ]);
	    UpdateProgressBar(lapar[playerid], playerid);
    }

    if(itemid == 4)
    {
        pInfo[playerid][pHaus] = pInfo[playerid][pHaus]+35;
        PlayerInv[playerid][itemid]--;
        pInfo[playerid][pSlots] --;
        if(pInfo[playerid][pHaus] > MAX_THIRST_AMOUNT)
        {
            pInfo[playerid][pHaus] = MAX_THIRST_AMOUNT;
		}
        SendClientMessage(playerid,0xA9A9A9ff,"* Anda Sedang minum bir");
        ApplyAnimation(playerid,"VENDING","VEND_Drink2_P",1.4,0 ,1,1,0,2500,1);
        SetProgressBarValue(haus[playerid], pInfo[ playerid ][ pHaus ]);
	    UpdateProgressBar(haus[playerid], playerid);
    }
    if(itemid == 5)
    {
        pInfo[playerid][pHaus] = pInfo[playerid][pHaus]+45;
        PlayerInv[playerid][itemid]--;
        pInfo[playerid][pSlots] --;
        if(pInfo[playerid][pHaus] > MAX_THIRST_AMOUNT)
        {
            pInfo[playerid][pHaus] = MAX_THIRST_AMOUNT;
		}
        SendClientMessage(playerid,0xA9A9A9ff,"* Anda Sedang minum jus apel");
        ApplyAnimation(playerid,"VENDING","VEND_Drink2_P",1.4,0 ,1,1,0,2500,1);
        SetProgressBarValue(haus[playerid], pInfo[ playerid ][ pHaus ]);
	    UpdateProgressBar(haus[playerid], playerid);
    }
    if(itemid == 6)
    {
        pInfo[playerid][pHaus] = pInfo[playerid][pHaus]+45;
        PlayerInv[playerid][itemid]--;
        pInfo[playerid][pSlots] --;
        if(pInfo[playerid][pHaus] > MAX_THIRST_AMOUNT)
        {
            pInfo[playerid][pHaus] = MAX_THIRST_AMOUNT;
		}
        SendClientMessage(playerid,0xA9A9A9ff,"* Anda Sedang minum jus jeruk");
        ApplyAnimation(playerid,"VENDING","VEND_Drink2_P",1.4,0 ,1,1,0,2500,1);
        SetProgressBarValue(haus[playerid], pInfo[ playerid ][ pHaus ]);
	    UpdateProgressBar(haus[playerid], playerid);
    }
    if(itemid == 7)
    {
        pInfo[playerid][pHaus] = pInfo[playerid][pHaus]+25;
        PlayerInv[playerid][itemid]--;
        pInfo[playerid][pSlots] --;
        if(pInfo[playerid][pHaus] > MAX_THIRST_AMOUNT)
        {
            pInfo[playerid][pHaus] = MAX_THIRST_AMOUNT;
		}
        SendClientMessage(playerid,0xA9A9A9ff,"* Anda Sedang minum Sprunk");
        ApplyAnimation(playerid,"VENDING","VEND_Drink2_P",1.4,0 ,1,1,0,2500,1);
        SetProgressBarValue(haus[playerid], pInfo[ playerid ][ pHaus ]);
	    UpdateProgressBar(haus[playerid], playerid);
    }
	if(itemid == 8)
    {
        pInfo[playerid][pPack] = 1;
		PlayerInv[playerid][itemid]--;
        pInfo[playerid][pSlots] --;
        SendClientMessage(playerid,0xA9A9A9ff,"* Slot Tas Anda Telah Bertambah");
    }
    return 1;
}

//------------------------------------------------------------------------------
