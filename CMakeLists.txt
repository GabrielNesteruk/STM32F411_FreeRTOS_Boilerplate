cmake_minimum_required(VERSION 3.25.1)

project(RollerBlind)

enable_language(C CXX ASM)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(SRC
    Project/app/startup_stm32f411xe.s
    Project/app/main.cpp
)

set(ARM_COMPILER_FLAGS
    -mcpu=cortex-m4
    -mthumb
    -mfpu=fpv4-sp-d16
    -mfloat-abi=hard
    $<$<CONFIG:Debug>:-Og>
    $<$<CONFIG:Release>:-Os>
    -Wall
    -fdata-sections
    -ffunction-sections
    $<$<CONFIG:Debug>:-g>
    $<$<CONFIG:Debug>:-gdwarf-2>
    -MMD
    -MP
)

set(ARM_LINKER_FLAGS
    -mcpu=cortex-m4
    -mthumb
    -mfpu=fpv4-sp-d16
    -mfloat-abi=hard
    -specs=nano.specs
    -T${CMAKE_SOURCE_DIR}/Project/app/STM32F411RETx_FLASH.ld
    -lc
    -lm
    -lnosys
    -Wl,-Map=${PROJECT_NAME}.map,--cref
    -Wl,--gc-sections
)

set(TARGET_DEFINITIONS
    -DSTM32F411xE
)

add_subdirectory(Middlewares/Third_Party/FreeRTOS)

set(EXECUTABLE ${PROJECT_NAME}.elf)

add_executable(${EXECUTABLE} ${SRC})
target_link_libraries(${EXECUTABLE} PRIVATE FreeRTOS)

target_compile_definitions(${EXECUTABLE} PRIVATE ${TARGET_DEFINITIONS})

target_include_directories(${EXECUTABLE} PRIVATE
    Project/firmware/include
    Middlewares/Third_Party/CMSIS/Device/ST/STM32F4xx/Include
    Middlewares/Third_Party/CMSIS/Include
)

target_compile_options(${EXECUTABLE} PRIVATE ${ARM_COMPILER_FLAGS})

target_link_options(${EXECUTABLE} PRIVATE ${ARM_LINKER_FLAGS})

add_custom_command(TARGET ${EXECUTABLE}
    POST_BUILD
    COMMAND arm-none-eabi-size ${EXECUTABLE}
)

add_custom_command(TARGET ${EXECUTABLE}
    POST_BUILD
    COMMAND arm-none-eabi-objcopy -O ihex ${EXECUTABLE} ${PROJECT_NAME}.hex
    COMMAND arm-none-eabi-objcopy -O binary ${EXECUTABLE} ${PROJECT_NAME}.bin
)