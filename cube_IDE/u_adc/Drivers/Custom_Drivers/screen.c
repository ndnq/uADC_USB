/*
 * screen.c
 *
 *  Created on: Nov 13, 2024
 *      Author: Daniel
 */

#include "include/screen.h"



ScreenDevice dev = {.refreshDelay = 20, .drawScreen = drawScreen, .init = init};

void init(){
	GPIO_InitTypeDef GPIO_InitStruct = {0};
	GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_HIGH;
	GPIO_InitStruct.Pull = GPIO_NOPULL;
	for (int x = 0; x < SCREEN_WIDTH; x++) {
		for (int y = 0; y < SCREEN_HEIGHT; y++) {
			uint16_t Hpin 	= 			BINDINGS[x][y].HIGH_SIDE_PIN;
			GPIO_TypeDef* Hport 	= 	BINDINGS[x][y].HIGH_SIDE_PORT;
			uint16_t Lpin 	= 			BINDINGS[x][y].LOW_SIDE_PIN;
			GPIO_TypeDef* Lport 	= 	BINDINGS[x][y].LOW_SIDE_PORT;
			dev.buffer[x][y].state = 0;
			dev.buffer[x][y].currentState = 0;
			//Set high Z at all pins
			GPIO_InitStruct.Pin = Hpin;
			GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_OD;
			HAL_GPIO_Init(Hport, &GPIO_InitStruct);
			HAL_GPIO_WritePin(Hport, Hpin, GPIO_PIN_SET);
			GPIO_InitStruct.Pin = Lpin;
			HAL_GPIO_Init(Lport, &GPIO_InitStruct);
			HAL_GPIO_WritePin(Lport, Lpin, GPIO_PIN_SET);
		}
	}
}


//REDO THIS
void drawScreen(){
	GPIO_InitTypeDef GPIO_InitStruct = {0};
	GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_HIGH;
	GPIO_InitStruct.Pull = GPIO_NOPULL;
	//For each Column
	for (int x = 0; x < SCREEN_WIDTH; x++) {
		//In each Row
		for (int y = 0; y < SCREEN_HEIGHT; y++) {
			//Get pins for each LED
			uint16_t Hpin 	= dev.buffer[x][y].HIGH_SIDE_PIN;
			GPIO_TypeDef* Hport 	= dev.buffer[x][y].HIGH_SIDE_PORT;
			uint16_t Lpin 	= dev.buffer[x][y].LOW_SIDE_PIN;
			GPIO_TypeDef* Lport 	= dev.buffer[x][y].LOW_SIDE_PORT;
			uint8_t state 	= dev.buffer[x][y].state;

			if (state){
				//Set the pin states to corresponding ones
				//High pin
				GPIO_InitStruct.Pin = Hpin;
				GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
				HAL_GPIO_Init(Hport, &GPIO_InitStruct);
				HAL_GPIO_WritePin(Hport, Hpin, GPIO_PIN_SET);
				//Low pin
				GPIO_InitStruct.Pin = Lpin;
				HAL_GPIO_Init(Lport, &GPIO_InitStruct);
				HAL_GPIO_WritePin(Lport, Lpin, GPIO_PIN_RESET);
			}
			HAL_Delay(20);
			//Ensure every led is OFF at the end of the cycle
			GPIO_InitStruct.Pin = Hpin;
			GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_OD;
			HAL_GPIO_Init(Hport, &GPIO_InitStruct);
			HAL_GPIO_WritePin(Hport, Hpin, GPIO_PIN_SET);
			GPIO_InitStruct.Pin = Lpin;
			HAL_GPIO_Init(Lport, &GPIO_InitStruct);
			HAL_GPIO_WritePin(Lport, Lpin, GPIO_PIN_SET);
		}
	}
}
