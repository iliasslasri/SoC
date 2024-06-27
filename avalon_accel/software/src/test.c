#include "nios2_irq.h"
#include "simple_printf.h"
#include <stdint.h>
#include "interval_timer.h"


typedef struct {
    uint32_t k[4];
    uint32_t src;
    uint32_t dest;
    uint32_t num;
    uint32_t ctrl;
} DMA_t;

#define accel ((volatile DMA_t*)0x8000)

// source and destination
uint32_t src[160];
uint32_t dest[160];

// for timer
// unsigned int t_start, t_end;

void handler()
{
    // t_end = interval_timer_val();
    // simple_printf("time 0x%x (%u) -> duration %u \n",t_start, t_end, t_end-t_start);
    const char *fmt1 = "encryption done.";
    simple_printf(fmt1);
    accel->ctrl = 0;
    simple_printf("Source : \n");
    for(int i=0; i<160; i++){
        simple_printf("%d", src[i]);
    }

    simple_printf("\nEncryption : \n");
    for(int i=0; i<160; i++){
        simple_printf("%d", dest[i]);
    }
    while(1){

    }
}

void main()
{
    RegisterISR(1, handler);
    irq_enable();

    // timer 
    // interval_timer_start();
    simple_printf("Let's start...\n");

    // writing params
    accel->k[0] = (uint32_t)0xdeadbeef;
    accel->k[1] = (uint32_t)0xc01dcafe;
    accel->k[2] = (uint32_t)0xbadec0de;
    accel->k[3] = (uint32_t)0x8badf00d;
    accel->src = (uint32_t) src;
    accel->dest = (uint32_t) dest;
    
    simple_printf("\nParameters written...\n");
    // src
    simple_printf("\nSource in %x  init \n", src);

    src[0] = 0;
    src[1] = 1;
    src[2] = 2;
    src[2] = 3;
    for(int i=4; i<160; i++){
        src[i] = 0;
    }

    simple_printf("\nDestination in %x init ...\n", dest);

    for(int i=0; i<160; i++){
        dest[i] = 0;
    }

    accel->num = (uint32_t) 0x00000080;

    for(int i=0; i<160; i++){
        simple_printf("%d", src[i]);
    }

    const char *fmt = "send cmd to start encryption...\n";
    simple_printf(fmt);

    // t_start = interval_timer_val();
    accel->ctrl = (uint32_t) 1;
    while(1);
}