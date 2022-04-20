#include "Utils.h"
#include <vector>
#include <stdio.h>
#include <stdlib.h>

// Disable fopen_s warnings
#pragma warning( disable : 4996 )

using namespace std;

struct VehicleSegment {
	unsigned int time;
	unsigned short vehicle;
	unsigned short lrkeys;
	unsigned short udkeys;
	signed short keys;
	float quat1;
	float quat2;
	float quat3;
	float quat4;
	float xpos;
	float ypos;
	float zpos;
	float xvel;
	float yvel;
	float zvel;
	float health;
	unsigned char phealth;
	unsigned char parmour;
	unsigned char weaponid;
	unsigned char siren;
	unsigned char gear;
};


class VehicleRecording {
public:
	VehicleRecording();
	void addSegment(VehicleSegment s);
	void writeToFile(char* file);
	void readFromFile(char* file);
	void reset();

	vector<VehicleSegment> vdata;

	int type;
	int updaterate;
};