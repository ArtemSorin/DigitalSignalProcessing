#include <def21060.h>
#include <signal.h>
#include "Project4.h"

extern void SetupSPORT(int, int, int);

//-------------------------------------------
// обработчик прерывания от SPORT0-приём (с DMA), буфер в памяти
// определить с каким из двух буферов надо работать
//-------------------------------------------
void SPORT0_DMA_Receive_Handler(int sig)
{
	//int *ptrInBuffer;
	//int *ptrOutBuffer;
	
	// взять актуальный буфер для ввода
	
	// взять актуальный буфер для вывода
	
	// вызвать ПП обработки и передать ей адреса буферов
	//ProcessBuffer(ptrInBuffer, ptrOutBuffer, cnN);
	
	return;
}

// инициализация
int main()
{
		// установить обработчик прерывания по приёму через SP0RT0
	//interrupt(SIG_SPR0I, SPORT0_DMA_Receive_Handler);
	//interruptss(SIG_SPR0I, SPORT0_DMA_Receive_Handler);
	
		// сконфигурировать и включить порт SPORT0 на приём
	SetupSPORT(0, 0xC05F1, cnDIVISOR);
	
		// сконфигурировать и включить порт SPORT1 на передачу
	SetupSPORT(1, 0xC05F1, cnDIVISOR);
	
	
	// завершить main(). Диспетчер остаётся работать
	return 0;
}
