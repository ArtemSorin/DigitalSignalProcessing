//-----------------------------------------------
// ������������ ������ �1. ������� 0
// 15.03.2023
// �������� ���� 
// ����2-8
//-----------------------------------------------
#include <def21060.h>

#define cnARRNUMBER 32
#define cnPACKNUMBER cnARRNUMBER / 32
#define c_astr 2

//-----------------------------------------------
// ������� ������ � DM
.SECTION/DM		dm_data;
.VAR input[cnARRNUMBER] = "input.dat";	//y(i)
.VAR delta[cnARRNUMBER];				//d(i)
.VAR deltapack[cnPACKNUMBER];			//packed d(i)

//-----------------------------------------------
// ������� ������ � PM
.SECTION/PM		pm_data;
.VAR output[cnARRNUMBER];				//Y(i)

//-----------------------------------------------
// ���������� RESET
.SECTION/PM		pm_irq_svc;
		nop;
		jump start;
		nop;
		nop;

//-----------------------------------------------
// ������� ����
.SECTION/PM		pm_code;
start:
			//������ � ������ ������� �������� y(i)
		I1 = input;
		M7 = 1;
		M3 = 0;
			//������ � delta(i)
		I2 = delta;
			//������ � Y(i)
		I8 = output;
		M15 = 1;
			// ��������� �������� ���������
		I3 = deltapack;
		R9 = 32;		//������� ������������� ����� � ����
		
		R12 = 0;		//Y(0)
		R13 = c_astr;	//c*
		R14 = 0;		//dY(0)
		R15 = -1;		//��������� ��� ��������� �����
		R5 = 0;			//delta
		R4 = 0;			//z
			//���� ������� �� ��������� �������
		LCNTR = cnARRNUMBER, DO xxx UNTIL LCE;
			call compute_d (db);
			
			R2 = DM(I1, M7);	//y(i)
			R4 = R12 - R2;		//z(i) = Y(i) - y(i)
			
			R5 = R13 * R0 (SSI);		//delta
			
			call compute_pack (db);
			
			R14 = R14 + R0;				//dY(i)
			R12 = R12 + R14;			//Y(i)
			
xxx:		DM(I2, M7) = R0, PM(I8, M15) = R12;
	//������ ����
wait:	IDLE;
		jump wait;
	//������������ ��� ���������� delta
	//������� ��������: R4 z(i)
	//�������� ���������: R0 (+1 / -1), R1 (1 / 0 - ��� ��������)
compute_d:
			R0 = 1;
			R1 = 0;
			R4 = PASS R4;		//���� z(i)
			rts (db);
				if GE R0 = R0 * R15 (SSI);	//sign(z) +1 / -1
				if MS R1 = R1 - 1;

	//������������ ��� �������� ���������� ���� � 32-��������� pack
	//������� ���������: R1 - (0 / 1), I3, M3 - ����� 
	//
	//
compute_pack:
		R11 = DM(I3, M4);
		R11 = LSHIFT R11 BY 1;
		R11 = R11 or R1;
			//������� ��������� ����� � ����� ���������
		R9 = R9 - 1, DM(I3, M4) = R11;;
		IF NE JUMP next_bit;
		R9 = 32;
		MODIFY(I3, M3);
next_bit:	rts;
