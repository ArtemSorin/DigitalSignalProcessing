#include <def21060.h>
#include <signal.h>
#include "Project4.h"

extern void SetupSPORT(int, int, int);

//-------------------------------------------
// ���������� ���������� �� SPORT0-���� (� DMA), ����� � ������
// ���������� � ����� �� ���� ������� ���� ��������
//-------------------------------------------
void SPORT0_DMA_Receive_Handler(int sig)
{
	//int *ptrInBuffer;
	//int *ptrOutBuffer;
	
	// ����� ���������� ����� ��� �����
	
	// ����� ���������� ����� ��� ������
	
	// ������� �� ��������� � �������� �� ������ �������
	//ProcessBuffer(ptrInBuffer, ptrOutBuffer, cnN);
	
	return;
}

// �������������
int main()
{
		// ���������� ���������� ���������� �� ����� ����� SP0RT0
	//interrupt(SIG_SPR0I, SPORT0_DMA_Receive_Handler);
	//interruptss(SIG_SPR0I, SPORT0_DMA_Receive_Handler);
	
		// ���������������� � �������� ���� SPORT0 �� ����
	SetupSPORT(0, 0xC05F1, cnDIVISOR);
	
		// ���������������� � �������� ���� SPORT1 �� ��������
	SetupSPORT(1, 0xC05F1, cnDIVISOR);
	
	
	// ��������� main(). ��������� ������� ��������
	return 0;
}
