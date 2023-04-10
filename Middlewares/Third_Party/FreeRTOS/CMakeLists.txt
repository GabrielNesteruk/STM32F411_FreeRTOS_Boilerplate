set(SRC
    Source/croutine.c
    Source/event_groups.c
    Source/list.c
    Source/queue.c
    Source/stream_buffer.c
    Source/tasks.c
    Source/timers.c
    Source/CMSIS_RTOS_V2/cmsis_os2.c
    Source/portable/MemMang/heap_4.c
    Source/portable/GCC/ARM_CM4F/port.c
)

add_library(FreeRTOS STATIC ${SRC})

target_include_directories(FreeRTOS PRIVATE
    ${CMAKE_SOURCE_DIR}/Project/firmware/include
    Source/include
    Source/CMSIS_RTOS_V2
    Source/portable/GCC/ARM_CM4F
    ${CMAKE_SOURCE_DIR}/Middlewares/Third_Party/CMSIS/Device/ST/STM32F4xx/Include
    ${CMAKE_SOURCE_DIR}/Middlewares/Third_Party/CMSIS/Include
)

target_compile_definitions(FreeRTOS PRIVATE ${TARGET_DEFINITIONS})
target_compile_options(FreeRTOS PRIVATE ${ARM_COMPILER_FLAGS})