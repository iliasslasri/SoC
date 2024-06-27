#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "nios2_irq.h"
#include "simple_printf.h"
#include <stdint.h>
#include "interval_timer.h"


uint64_t sbox (uint64_t d)
{
    switch (d & 0xF) {
        case 0x0: return (0xcLL);
        case 0x1: return (0x5LL);
        case 0x2: return (0x6LL);
        case 0x3: return (0xbLL);
        case 0x4: return (0x9LL);
        case 0x5: return (0x0LL);
        case 0x6: return (0xaLL);
        case 0x7: return (0xdLL);
        case 0x8: return (0x3LL);
        case 0x9: return (0xeLL);
        case 0xa: return (0xfLL);
        case 0xb: return (0x8LL);
        case 0xc: return (0x4LL);
        case 0xd: return (0x7LL);
        case 0xe: return (0x1LL);
        case 0xf: return (0x2LL);
    }
}

void SBoxLayer (uint64_t *d)
{
    int i;
    for (i=0; i<16; i++)
    {
        uint64_t t = *d >>(4*i);
        *d = ( *d & ~(0xFLL << 4*i) ) | (sbox(t) << 4*i);
    }
}

void pLayer (uint64_t *d)
{
#define BIT(i) (*d & (0x1LL<<i))>>i
    *d =
        BIT(63) << 63 | BIT(62) << 47 | BIT(61) << 31| BIT(60) << 15 |
        BIT(59) << 62 | BIT(58) << 46 | BIT(57) << 30| BIT(56) << 14 |
        BIT(55) << 61 | BIT(54) << 45 | BIT(53) << 29| BIT(52) << 13 |
        BIT(51) << 60 | BIT(50) << 44 | BIT(49) << 28| BIT(48) << 12 |
        BIT(47) << 59 | BIT(46) << 43 | BIT(45) << 27| BIT(44) << 11 |
        BIT(43) << 58 | BIT(42) << 42 | BIT(41) << 26| BIT(40) << 10 |
        BIT(39) << 57 | BIT(38) << 41 | BIT(37) << 25| BIT(36) <<  9 |
        BIT(35) << 56 | BIT(34) << 40 | BIT(33) << 24| BIT(32) <<  8 |
        BIT(31) << 55 | BIT(30) << 39 | BIT(29) << 23| BIT(28) <<  7 |
        BIT(27) << 54 | BIT(26) << 38 | BIT(25) << 22| BIT(24) <<  6 |
        BIT(23) << 53 | BIT(22) << 37 | BIT(21) << 21| BIT(20) <<  5 |
        BIT(19) << 52 | BIT(18) << 36 | BIT(17) << 20| BIT(16) <<  4 |
        BIT(15) << 51 | BIT(14) << 35 | BIT(13) << 19| BIT(12) <<  3 |
        BIT(11) << 50 | BIT(10) << 34 | BIT( 9) << 18| BIT( 8) <<  2 |
        BIT( 7) << 49 | BIT( 6) << 33 | BIT( 5) << 17| BIT( 4) <<  1 |
        BIT( 3) << 48 | BIT( 2) << 32 | BIT( 1) << 16| BIT( 0) <<  0 ;
#undef BIT
}

typedef struct {
    uint64_t kl;
    uint64_t kh;
} KEY;

void UpdateKey (KEY *k, uint8_t round)
{
    KEY tk ;
    uint8_t tmp;
    tk.kl = (k->kl << 61) | (k->kh >> (64-61));
    tk.kh = (k->kh << 61 )| (k->kl >> (64-61));
#define SBOX_NIB(pos)((tk.kh & ~(0xFLL<<(pos-64))) | (sbox( (tk.kh & (0xFLL<<(pos-64))) >>(pos-64)) << (pos-64)))
    tk.kh = SBOX_NIB(124);
    tk.kh = SBOX_NIB(120);
    tk.kl = (tk.kl & ~(0x3LL<<62)) | ((tk.kl>>62 ^ (round & 0x3)) << 62);
    tk.kh = tk.kh & ~0x7LL | (( tk.kh ^ (round>>2)) & 0x7LL);
    *k = tk;
}

void present (uint64_t *d, KEY *k)
{
    uint8_t round ;
    for (round =1; round <32; round++)
    {
    
        *d = *d ^ k->kh;
        SBoxLayer (d);
        pLayer(d);
        UpdateKey(k,round);
    }
    *d = *d ^ k->kh;
}

volatile unsigned int t_start, t_end;

int main ()
{
    uint64_t D[1] = {0x0000000000000000UL};
    KEY K_ref[] =
    {
    {0x0000000000000000UL, 0x0000000000000000UL}
    };
    interval_timer_start();
    interval_timer_init_periodic();
    
    simple_printf("----------------------------------");

    t_start = interval_timer_val();
    present(D,K_ref);
    t_end = interval_timer_val();
    simple_printf("\n\n\nTime 0x%x (%u) -> duration %u \n\n\n\n",t_start, t_end, t_end-t_start);

    simple_printf("----------------------------------");

    return 0;
}

