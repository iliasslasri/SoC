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
#define NB_BLOCS 1

// source and destination
uint32_t src[2*NB_BLOCS];
uint32_t dest[2*NB_BLOCS];

// for timer
volatile unsigned int t_start, t_end;

void handler()
{
    t_end = interval_timer_val();
    simple_printf("\n\n\nTime 0x%x (%u) -> duration %u \n\n\n\n",t_start, t_end, t_end-t_start);

    const char *fmt1 = "Encryption done.\n";
    simple_printf(fmt1);
    accel->ctrl = 0;

    simple_printf("Encryption of one block :");
    simple_printf("plaintext :      |key:                              |cipher text\n");
    for(int i=0; i<2*NB_BLOCS; i++){
        simple_printf(" 0x%x                   0x%x             => ", src[i], 0x0);
        simple_printf("            0x%x   \n", dest[i]);
    }
    while(1);
}

void main()
{
    RegisterISR(1, handler);
    RegisterISR(2, interval_timer_ISR);
    irq_enable();

    // timer 
    interval_timer_start();
    interval_timer_init_periodic();
    simple_printf("Let's start...\n");

    // writing params
    accel->k[0] = (uint32_t)0x0;
    accel->k[1] = (uint32_t)0x0;
    accel->k[2] = (uint32_t)0x0;
    accel->k[3] = (uint32_t)0x0;
    accel->src = (uint32_t) src;
    accel->dest = (uint32_t) dest;
    
    simple_printf("\nParameters written...\n");
    // src
    simple_printf("\nSource in %x  init \n", src);

    for(int i=0; i<2*NB_BLOCS; i++){
        src[i] = (uint32_t) 0x0;
    }

    simple_printf("\nDestination in %x init ...\n", dest);

    for(int i=0; i<2*NB_BLOCS; i++){
        dest[i] = (uint32_t)0x0;
    }

    accel->num = (uint32_t) 2*NB_BLOCS;

    for(int i=0; i<2*NB_BLOCS; i++){
        simple_printf("%x", src[i]);
    }

    const char *fmt = "\nSending cmd to start encryption...\n";
    simple_printf(fmt);

    t_start = interval_timer_val();
    accel->ctrl = (uint32_t) 1;
    while(1);
}