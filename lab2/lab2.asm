#include <def21060.h>

#define N 32
#define c_astr 2

//-------------------------------------------
// 0x30000-0x3ffff
// ������� ������ � DM
.SECTION/DM	dm_data;
.VAR in;
.VAR out;

//-------------------------------------------

//-------------------------------------------
// 0x20004-0x20007
// ���������� RESET
.SECTION/PM pm_irq_svc;
	nop;
	jump start;
	nop;
	nop;
//-------------------------------------------

//-------------------------------------------
// 0x20004-0x20007
// ���������� Timer High
.SECTION/PM pm_irq_tmz;
	call compute_pack(db);
		R1 = DM(in);
		nop;
	rti;
//-------------------------------------------

//-------------------------------------------
// ������� ����
.SECTION/PM pm_code;
start:
		TPERIOD = 50;
		TCOUNT = 50;
		
		BIT SET MODE1 IRPTEN;	// ���������� ���������� ����������
		BIT SET MODE2 TIMEN;	// �������� ������
		BIT SET IMASK TMZHI;	// ���������� ������ ����������� �� �������
	// ������ ����
wait:	idle;
		jump wait;
//-------------------------------------------

compute:
		rts;

pack:
		R11 = DM(I3, M4);
		R11 = LSHIFT R11 BY 1;
		R11 = R11 OR R1;
			// ������� ��������� ����� � ����� ���������
		R9 = R9 - 1, DM(I3, M4) = R11;;
		IF NE JUMP next_bit;
		R9 = 32;
		MODIFY(I3, M3);
		DM(out) = R1;
next_bit:	rts;
