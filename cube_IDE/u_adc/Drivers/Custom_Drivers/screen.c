/*
 * screen.c
 *
 *  Created on: Nov 13, 2024
 *      Author: Daniel
 */

#include "include/screen.h"

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


ScreenDevice dev = {.refreshDelay = 20, .drawScreen = drawScreen, .init = init};

void init(){
	dev.xpos = 0;
	dev.ypos = 0;
	dev.isSomeLedOn = 0;
	for (int x = 0; x < SCREEN_WIDTH; x++) {
		for (int y = 0; y < SCREEN_HEIGHT; y++) {
			dev.buffer[x][y] = 0;
			setLEDHiZ(x, y);
		}
	}
}


//Set single PIN as high impedance
void setPinHiZ(GPIO_TypeDef* port, uint16_t pin){
	GPIO_InitTypeDef GPIO_InitStruct = {0};
	GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_HIGH;
	GPIO_InitStruct.Pull = GPIO_NOPULL;
	GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_OD;
	GPIO_InitStruct.Pin = pin;
	HAL_GPIO_WritePin(port, pin, GPIO_PIN_SET);
	HAL_GPIO_Init(port, &GPIO_InitStruct);

}
//Set LED ports as high impedance
void setLEDHiZ(uint8_t x,uint8_t y){
	setPinHiZ(BINDINGS[x][y].HIGH_SIDE_PORT,BINDINGS[x][y].HIGH_SIDE_PIN);
	setPinHiZ(BINDINGS[x][y].LOW_SIDE_PORT,BINDINGS[x][y].LOW_SIDE_PIN);
}

//Set single PIN as output with the desired state
void setPinWithInit(GPIO_TypeDef* port, uint16_t pin,uint8_t state){
	GPIO_InitTypeDef GPIO_InitStruct = {0};
	GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_HIGH;
	GPIO_InitStruct.Pull = GPIO_NOPULL;
	GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
	GPIO_InitStruct.Pin = pin;
	HAL_GPIO_WritePin(port, pin, state);
	HAL_GPIO_Init(port, &GPIO_InitStruct);

}
//Set LED to be LIT
void setLEDatpos(uint8_t x, uint8_t y){
	//IF other LEDS are on turn them off
	if(dev.isSomeLedOn == 1){
		revertLastLED();
	}
	//Set the LED
	setPinWithInit(BINDINGS[x][y].HIGH_SIDE_PORT, BINDINGS[x][y].HIGH_SIDE_PIN, GPIO_PIN_SET);
	setPinWithInit(BINDINGS[x][y].LOW_SIDE_PORT, BINDINGS[x][y].LOW_SIDE_PIN, GPIO_PIN_RESET);
	dev.lastLED = BINDINGS[x][y];
	dev.isSomeLedOn = 1;
}

void revertLastLED(){
	setPinHiZ(dev.lastLED.HIGH_SIDE_PORT,dev.lastLED.HIGH_SIDE_PIN);
	setPinHiZ(dev.lastLED.LOW_SIDE_PORT,dev.lastLED.LOW_SIDE_PIN);
}



//REDO THIS
void drawScreen(){

}


