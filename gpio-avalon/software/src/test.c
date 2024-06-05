// define macros to access to the data registers of
#include "nios2_irq.h"
#include "simple_printf.h"
#include <stdint.h>

struct gpio
{
  uint32_t data;
  uint32_t enable;
  uint32_t irq_mask;
  uint32_t irq_pol;
  uint32_t irq_ack;
} ;

#define GPIO ((volatile struct gpio*) 0x00008000)



void handler()
{
  const char *fmt = "interruption recieved";
  GPIO->enable = 0x000F;
  GPIO->irq_mask = 0x000;
  simple_printf(fmt);
  GPIO->irq_ack = 0;
}

int main()
{
  irq_enable();
  RegisterISR(1, handler);
  GPIO->irq_pol = 0x000;
  GPIO->irq_mask = 0x001;
  GPIO->enable = 0xFFF1;
  uint32_t data_in;
  while(1){
    data_in = GPIO->data;
    GPIO->data = data_in;
  }
}