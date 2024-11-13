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

//First dimension is the x axis starting from the top
//Second dimenstion is the y axis starting from the left
const mapEntry BINDINGS[SCREEN_WIDTH][SCREEN_HEIGHT] = {
    {
       {LD_0_Pin, LD_5_Pin, LD_0_GPIO_Port, LD_5_GPIO_Port},
       {LD_1_Pin, LD_5_Pin, LD_1_GPIO_Port, LD_5_GPIO_Port},
       {LD_2_Pin, LD_5_Pin, LD_2_GPIO_Port, LD_5_GPIO_Port},
       {LD_3_Pin, LD_5_Pin, LD_3_GPIO_Port, LD_5_GPIO_Port},
       {LD_4_Pin, LD_5_Pin, LD_4_GPIO_Port, LD_5_GPIO_Port}
    },
    {
        {LD_0_Pin, LD_4_Pin, LD_0_GPIO_Port, LD_4_GPIO_Port},
        {LD_1_Pin, LD_4_Pin, LD_1_GPIO_Port, LD_4_GPIO_Port},
        {LD_2_Pin, LD_4_Pin, LD_2_GPIO_Port, LD_4_GPIO_Port},
        {LD_3_Pin, LD_4_Pin, LD_3_GPIO_Port, LD_4_GPIO_Port},
        {LD_5_Pin, LD_4_Pin, LD_5_GPIO_Port, LD_4_GPIO_Port}
    },
    {
        {LD_0_Pin, LD_3_Pin, LD_0_GPIO_Port, LD_3_GPIO_Port},
        {LD_1_Pin, LD_3_Pin, LD_1_GPIO_Port, LD_3_GPIO_Port},
        {LD_2_Pin, LD_3_Pin, LD_2_GPIO_Port, LD_3_GPIO_Port},
        {LD_4_Pin, LD_3_Pin, LD_4_GPIO_Port, LD_3_GPIO_Port},
        {LD_5_Pin, LD_3_Pin, LD_5_GPIO_Port, LD_3_GPIO_Port}
    },
    {
        {LD_0_Pin, LD_2_Pin, LD_0_GPIO_Port, LD_2_GPIO_Port},
        {LD_1_Pin, LD_2_Pin, LD_1_GPIO_Port, LD_2_GPIO_Port},
        {LD_3_Pin, LD_2_Pin, LD_3_GPIO_Port, LD_2_GPIO_Port},
        {LD_4_Pin, LD_2_Pin, LD_4_GPIO_Port, LD_2_GPIO_Port},
        {LD_5_Pin, LD_2_Pin, LD_5_GPIO_Port, LD_2_GPIO_Port}
    },
    {
        {LD_0_Pin, LD_1_Pin, LD_0_GPIO_Port, LD_1_GPIO_Port},
        {LD_2_Pin, LD_1_Pin, LD_2_GPIO_Port, LD_1_GPIO_Port},
        {LD_3_Pin, LD_1_Pin, LD_3_GPIO_Port, LD_1_GPIO_Port},
        {LD_4_Pin, LD_1_Pin, LD_4_GPIO_Port, LD_1_GPIO_Port},
        {LD_5_Pin, LD_1_Pin, LD_5_GPIO_Port, LD_1_GPIO_Port}
    },
    {
        {LD_1_Pin, LD_0_Pin, LD_1_GPIO_Port, LD_0_GPIO_Port},
        {LD_2_Pin, LD_0_Pin, LD_2_GPIO_Port, LD_0_GPIO_Port},
        {LD_3_Pin, LD_0_Pin, LD_3_GPIO_Port, LD_0_GPIO_Port},
        {LD_4_Pin, LD_0_Pin, LD_4_GPIO_Port, LD_0_GPIO_Port},
        {LD_5_Pin, LD_0_Pin, LD_5_GPIO_Port, LD_0_GPIO_Port}
    }
};



typedef struct ScreenLed{
	uint8_t currentState;
	uint8_t state;

} ScreenLed;

typedef struct ScreenDevice {
	//LedBuffer 6 width 5 height
	ScreenLed buffer[SCREEN_WIDTH][SCREEN_HEIGHT];
	uint32_t refreshDelay; // in ms
	void (*drawScreen)(void);
	void (*init)(void);


} ScreenDevice;

void drawScreen();
void init();

#endif
