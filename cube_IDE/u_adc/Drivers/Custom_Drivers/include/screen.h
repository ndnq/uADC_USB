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


typedef struct ScreenDevice {
	//LedBuffer 6 width 5 height
	uint8_t buffer[SCREEN_WIDTH][SCREEN_HEIGHT];
	uint32_t refreshDelay; // in ms
	//Variables keeping track of the scanned position
	uint8_t xpos;
	uint8_t ypos;
	//Basiclyy a queue with one element. If there are any LEDS lit up they will be turned off before turning on the next one
	mapEntry lastLED;
	uint8_t isSomeLedOn;

	void (*drawScreen)(void);
	void (*init)(void);




} ScreenDevice;
extern const mapEntry BINDINGS[SCREEN_WIDTH][SCREEN_HEIGHT];
extern ScreenDevice dev;
void drawScreen();
void lightUpLED(uint8_t x, uint8_t y);
void setPinHiZ(GPIO_TypeDef* port, uint16_t pin);
void setPinWithInit(GPIO_TypeDef* port, uint16_t pin,uint8_t state);
void revertLastLED();
void setLEDHiZ(uint8_t x,uint8_t y);
void setLEDatpos(uint8_t x, uint8_t y);
void init();

#endif
