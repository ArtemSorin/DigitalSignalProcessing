#include <def21060.h>

#define N 24
#define K 3
#define M 4
#define KM K*M
#define K1 0.33

//-----------------------------------------------
// 0x30000-0x3ffff
// ������� ������ � DM
.SECTION/DM		dm_data;
.VAR in_buf1[N];
.VAR in_buf2[N];
.VAR in_select[2] = in_buf1, in_buf2;

.VAR TCB_Block1[8] = 0, 0, 0, 0,
					TCB_Block2+7, 	// ������ �� ��������������� ���� (������� CP (���� �� ���� ���������� ���  0x20000))
					@in_buf1,		// ���-�� ��������� (������� C   �������)
					1,				// ������� IM   ����������� ������
					in_buf1;		// ������� II   ����� ������
.VAR TCB_Block2[8] = 0, 0, 0, 0,
					TCB_Block1+7, 	// ������ �� ��������������� ���� (������� CP (���� �� ���� ���������� ���  0x20000))
					@in_buf2,		// ���-�� ��������� (������� C   �������)
					1,				// ������� IM   ����������� ������
					in_buf2;		// ������� II   ����� ������
					

.VAR out_buf1[N];
.VAR out_buf2[N];
.VAR out_select[2] = out_buf1, out_buf2;

.VAR TCB_BlockOut1[8] = 0, 0, 0, 0,
					TCB_BlockOut2+7, 	// ������ �� ��������������� ���� (������� CP (���� �� ���� ���������� ���  0x20000))
					@out_buf1,			// ���-�� ��������� (������� C   �������)
					1,					// ������� IM   ����������� ������
					out_buf1;			// ������� II   ����� ������
.VAR TCB_BlockOut2[8] = 0, 0, 0, 0,
					TCB_BlockOut1+7, 	// ������ �� ��������������� ���� (������� CP (���� �� ���� ���������� ���  0x20000))
					@out_buf2,			// ���-�� ��������� (������� C   �������)
					1,					// ������� IM   ����������� ������
					out_buf2;			// ������� II   ����� ������
//-----------------------------------------------

//-----------------------------------------------
// 0x20004-0x20007
// ���������� RESET
.SECTION/PM		pm_irq_svc;
		nop;
		jump start;
		nop;
		nop;
//-----------------------------------------------

//-----------------------------------------------
// 0x20028-0x2002b
// ����������
.SECTION/PM pm_irq_spr0;
	M1 = R10;

	jump compute (db);
		I0 = DM(M1, I1);
		I7 = DM(M1, I5);
//-----------------------------------------------

//-----------------------------------------------
// ������� ����
.SECTION/PM		pm_code;
start:
	I1 = in_select;
	I5 = out_select;
	
	M0 = 1;

	// ��������� ��������
	R1 = 0;		// c������ �
	R2 = 0;		// X
	R3 = 0;		// Y
	R4 = 0;		// tmp
	R5 = 0;		// tmp
	R6 = 0;		// ��
	R7 = 0;		// ����� �
	R8 = 0;		// X'
	R9 = 32;	// ������� ��������
	R10 = 0;	// 0 - ������ �����, 1 - ������ �����
	R11 = 0;	// ������� ��;	
	R12 = 0;	// Z
	

		// ��������� DMA ������ �2 �� �����
	R0 = TCB_BlockOut1 + 7;
	dm(CP2) = R0;
	
		// ��������� SPORT0 TRANSMIT
	R0 = 0x000C05F1;
	dm(STCTL0) = R0;	// SPEN = 1
						// SLEN = 31 (=32)
						// ICLK = 1
						// SDEN, SCHEN = 1
	
		// ��������� link-�����
	R0 = 0x0003FEBF;	// LAR-�������: LBUF2->���� � 0, LBUF3->���� � 0
	dm(LAR) = R0;		// ��������� ���� � 0
	R0 = 0x00000000;	// LCOM-�������:
	dm(LCOM) = R0;		// ����� �� 1�- �������
	R0 = 0x00000100;	// LCTL-�������: 32-������ ������, LBUF2-�����
	dm(LCTL) = R0;		// LBUF3-��������. ������ ������ LCTL ����� LAR
	
		// ��������� DMA ������ �0 �� ����
	R0 = TCB_Block1 + 7;
	dm(CP0) = R0;
	
		// ��������� SPORT0 RECIEVE
	R0 = 0x000C05F1;
	dm(SRCTL0) = R0;	// SPEN = 1
						// SLEN = 31 (=32)
						// ICLK = 1
						// SDEN, SCHEN = 1
	
	BIT SET IMASK SPR0I;
	BIT SET MODE1 IRPTEN;	// ���������� ���������� ����������
	

	//������ ����
wait:	IDLE;
		jump wait;
//-----------------------------------------------

//-----------------------------------------------
// ������������ ��������� �������
compute:
		LCNTR=32, DO xxx UNTIL LCE;
			
	yyy:	R5 = K;
			R4 = R5 - R1;
			IF EQ jump KT;
			R4 = PASS R1;
			IF EQ jump KT;

	zzz:	R5 = KM;
			R4 = R5 - R11;
			IF EQ jump KMT;
			R4 = PASS R11;
			IF EQ jump KMT;
						
			jump X;
			
			
	KT:		R1 = 0;
	
			R2 = DM(I0, M0);
				// ������� ������������
			R6 = R2 - R7;
			F6 = FLOAT R6;
			F5 = K1;
			F6 = F6 * F5;
			R7 = R2;
			
			jump zzz;
			
	KMT:	R11 = 0;
	
			F3 = DM(LBUF2);
			jump X;
				// ������� X'
	X:		F8 = F8 + F6;
			R4 = K - 1;	
			R4 = R4 - R1;
			IF EQ F8 = FLOAT R2;
			
			F12 = F8 + F3;
			R12 = TRUNC F12;
			
			R1 = R1 + 1;
			R11 = R11 + 1;

xxx:		DM(I7, M0) = F12;
		R14 = 1;
		R10 = R10 XOR R14;
		rti;
