################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Drivers/Custom_Drivers/screen.c 

OBJS += \
./Drivers/Custom_Drivers/screen.o 

C_DEPS += \
./Drivers/Custom_Drivers/screen.d 


# Each subdirectory must supply rules for building sources it contributes
Drivers/Custom_Drivers/%.o Drivers/Custom_Drivers/%.su Drivers/Custom_Drivers/%.cyclo: ../Drivers/Custom_Drivers/%.c Drivers/Custom_Drivers/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m0 -std=gnu11 -DUSE_HAL_DRIVER -DSTM32F042x6 -c -I../Core/Inc -I../Drivers/STM32F0xx_HAL_Driver/Inc -I../Drivers/STM32F0xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F0xx/Include -I../Drivers/CMSIS/Include -I../USB_DEVICE/App -I../USB_DEVICE/Target -I../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Inc -Os -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Drivers-2f-Custom_Drivers

clean-Drivers-2f-Custom_Drivers:
	-$(RM) ./Drivers/Custom_Drivers/screen.cyclo ./Drivers/Custom_Drivers/screen.d ./Drivers/Custom_Drivers/screen.o ./Drivers/Custom_Drivers/screen.su

.PHONY: clean-Drivers-2f-Custom_Drivers

