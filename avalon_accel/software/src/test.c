// #include "nios2_irq.h"
// #include "simple_printf.h"
// #include <stdint.h>

// #define accel  ((volatile struct accel_struct*)0x9000)

// struct accel_struct
// {
//   uint32_t key0;
//   uint32_t key1;
//   uint32_t key2;
//   uint32_t key3;
//   uint32_t SRC_ADDR;
//   uint32_t DEST_ADDR;
//   uint32_t NUM_ADDR;
//   uint32_t CTRL_ADDR;
// } ;

// // source and destination
// uint32_t src[160];
// uint32_t dest[160];

// void handler()
// {
//     const char *fmt1 = "encryption done.";
//     simple_printf(fmt1);
//     while(1){

//     }
// }


// void main()
// {
//     // enable interrupt
//     irq_enable();
//     RegisterISR(1, handler);
//     // writing params
//     accel->key0 = 0xdeadbeef;
//     accel->key1 = 0xc01dcafe;
//     accel->key2 = 0xbadec0de;
//     accel->key3 = 0x8badf00d;
//     accel->SRC_ADDR = (uint32_t) src;
//     accel->DEST_ADDR = (uint32_t) dest;
    
//     // src
//     src[0] = 0;
//     src[1] = 1;
//     src[2] = 2;
//     for(int i=3; i<160; i++){
//         src[0];
//     }

//     accel->NUM_ADDR = 0x00000080;

//     const char *fmt = "send cmd to start encryption.";
//     simple_printf(fmt);
//     accel->CTRL_ADDR = 1;
// }


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
  const char *fmt = "interruption recieved";
  simple_printf(fmt);
  while(1){
    data_in = GPIO->data;
    GPIO->data = data_in;
  }
}
