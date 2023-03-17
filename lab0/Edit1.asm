/**********************************************/
/*              Work with cycles              */
/**********************************************/

#include "def21060.h"
#define N 4000
#define cnShiftGreen 50

//---------------------------------------------
// Source array
// 0x30000
.SECTION/DM		dm_data;
.VAR input[N];
//---------------------------------------------

//---------------------------------------------
// Result array
// 0x24000
.SECTION/PM		pm_data;
.VAR output[N];
//---------------------------------------------

//---------------------------------------------
// 0x20004 - 0x20007
.SECTION/PM		pm_iqr_svc;
		nop;
		jump start;
		nop;
		nop;
//---------------------------------------------

//---------------------------------------------
// 0x20100 - 0x20200
.SECTION/PM		pm_code;
start:
		I0 = input;
		I1 = input;
		M0 = 1;
		M1 = 125;
		I8 = output;
		I9 = output;
		M8 = 1;
		M9 = 125;
		
		R2 = cnShiftGreen;
		R3 = 255;
		R4 = 255;

		LCNTR = 125, DO xxx UNTIL LCE;
			I0 = I1;
			I8 = I9;
			LCNTR = 125, DO yyy UNTIL LCE;
				R1 = DM(I0, M0);
				R0 = R0 OR FDEP R1 BY 8:8;
				R0 = R0 + R2;
				R3 = R3 - R0;
				IF LE R0 = R4;
				R1 = R1 OR FDEP R0 BY 8:8;
yyy:				PM(I8, M8) = R1;
		MODIFY(I1, M1);
xxx:		MODIFY(I9, M9);

wait:	IDLE;
	jump wait; 
//---------------------------------------------
