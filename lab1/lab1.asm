#include "def21060.h"
#define M 6
#define K 2
#define N 30
#define RES K * M
//-------------------------------------------
// 0x30000-0x3ffff
// сегмент данных в DM
.SECTION/DM	dm_data;
.VAR A[N] = "input.dat";
.VAR DATA_FULL[RES];
//-------------------------------------------

//-------------------------------------------
// 0x24000-27fff
// сегмент данных в PM
.SECTION/PM	pm_data;
.VAR E[M];
.VAR AVG[K];						
//-------------------------------------------	

//-------------------------------------------
// 0x20004-0x20007
// обработчик RESET
.SECTION/PM pm_irq_svc;
	nop;
	jump start;
	nop;
	nop;
//-------------------------------------------

//-------------------------------------------
// сегмент кода
.SECTION/PM pm_code;
start:
	I0 = A;
	M0 = 1;
	
	I1 = DATA_FULL;
	M1 = 1;
	
	R2 = N;
	R3 = 0;
	
	R1 = DM(I0,M0);
	R5 =  1000; //минимальная оценка
	R6 = -1000; //максимальная оценка
		
	LCNTR = N-1, DO LabelEndLoop UNTIL LCE;
		//поиск минимума
		COMP(R5, R1);
		IF GE R5 = R1;
		
		//поиск максимума
		COMP(R6, R1);
		IF LT R6 = R1;
LabelEndLoop: R1 = DM(I0, M0);
	//поиск минимума из последних
	COMP(R5, R1);
	IF GE R5 = R1;
	
	//поиск максимума из последних
	COMP(R6, R1);
	IF LT R6 = R1;
wait: IDLE;
		jump wait;
//-------------------------------------------