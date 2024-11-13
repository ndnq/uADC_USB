/*
 * screen.h
 *
 *  Created on: Nov 13, 2024
 *      Author: Daniel
 */

#ifndef __SCREEN_H
#define __SCREEN_H
#include "main.h"

#define SCREEN_HEIGHT 5
#define SCREEN_WIDTH 6

#define STATE_HZ 1
#define STATE_PP 0


typedef struct mapEntry{
	uint16_t HIGH_SIDE_PIN;
	uint16_t LOW_SIDE_PIN;
	GPIO_TypeDef* HIGH_SIDE_PORT;
	GPIO_TypeDef* LOW_SIDE_PORT;

} mapEntry;

const mapEntry BINDINGS[SCREEN_HEIGHT][SCREEN_WIDTH] = {
		{{1,1,1,1},{1,1,1,1},{1,1,1,1},{1,1,1,1},{1,1,1,1},{1,1,1,1}},
		{{1,1,1,1},{1,1,1,1},{1,1,1,1},{1,1,1,1},{1,1,1,1},{1,1,1,1}},
		{{1,1,1,1},{1,1,1,1},{1,1,1,1},{1,1,1,1},{1,1,1,1},{1,1,1,1}},
		{{1,1,1,1},{1,1,1,1},{1,1,1,1},{1,1,1,1},{1,1,1,1},{1,1,1,1}},
		{{1,1,1,1},{1,1,1,1},{1,1,1,1},{1,1,1,1},{1,1,1,1},{1,1,1,1}}
};


typedef struct ScreenLed{
	uint16_t HIGH_SIDE_PIN;
	uint16_t LOW_SIDE_PIN;
	GPIO_TypeDef* HIGH_SIDE_PORT;
	GPIO_TypeDef* LOW_SIDE_PORT;
	uint8_t currentState;
	uint8_t state;

} ScreenLed;

typedef struct ScreenDevice {
	//LedBuffer 6 width 5 height
	ScreenLed buffer[SCREEN_HEIGHT][SCREEN_WIDTH];
	uint32_t refreshDelay; // in ms
	void (*drawScreen)(void);
	void (*init)(void);


} ScreenDevice;

void drawScreen();
void init();

#endif
