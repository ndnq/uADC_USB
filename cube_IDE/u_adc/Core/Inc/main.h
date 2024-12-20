/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.h
  * @brief          : Header for main.c file.
  *                   This file contains the common defines of the application.
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2024 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __MAIN_H
#define __MAIN_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "stm32f0xx_hal.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Exported types ------------------------------------------------------------*/
/* USER CODE BEGIN ET */

/* USER CODE END ET */

/* Exported constants --------------------------------------------------------*/
/* USER CODE BEGIN EC */

/* USER CODE END EC */

/* Exported macro ------------------------------------------------------------*/
/* USER CODE BEGIN EM */

/* USER CODE END EM */

/* Exported functions prototypes ---------------------------------------------*/
void Error_Handler(void);

/* USER CODE BEGIN EFP */

/* USER CODE END EFP */

/* Private defines -----------------------------------------------------------*/
#define MIC0_Pin GPIO_PIN_0
#define MIC0_GPIO_Port GPIOA
#define MIC1_Pin GPIO_PIN_1
#define MIC1_GPIO_Port GPIOA
#define MIC2_Pin GPIO_PIN_2
#define MIC2_GPIO_Port GPIOA
#define MIC3_Pin GPIO_PIN_3
#define MIC3_GPIO_Port GPIOA
#define MIC4_Pin GPIO_PIN_4
#define MIC4_GPIO_Port GPIOA
#define MIC5_Pin GPIO_PIN_5
#define MIC5_GPIO_Port GPIOA
#define MIC6_Pin GPIO_PIN_6
#define MIC6_GPIO_Port GPIOA
#define MIC7_Pin GPIO_PIN_7
#define MIC7_GPIO_Port GPIOA
#define LD_1_Pin GPIO_PIN_0
#define LD_1_GPIO_Port GPIOB
#define LD_2_Pin GPIO_PIN_1
#define LD_2_GPIO_Port GPIOB
#define LD_3_Pin GPIO_PIN_8
#define LD_3_GPIO_Port GPIOA
#define MEM_CS_Pin GPIO_PIN_9
#define MEM_CS_GPIO_Port GPIOA
#define LD_0_Pin GPIO_PIN_15
#define LD_0_GPIO_Port GPIOA
#define LD_4_Pin GPIO_PIN_6
#define LD_4_GPIO_Port GPIOB
#define LD_5_Pin GPIO_PIN_7
#define LD_5_GPIO_Port GPIOB
#define USR_IN_boot_Pin GPIO_PIN_8
#define USR_IN_boot_GPIO_Port GPIOB

/* USER CODE BEGIN Private defines */

/* USER CODE END Private defines */

#ifdef __cplusplus
}
#endif

#endif /* __MAIN_H */
