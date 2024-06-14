## Test explaination :

To test my work, I wrote a code that enables like this: 0xF001, then we can see that the sw (sw9,..,sw4) turns on (led9,..,led4). Then to send an interruption, we turn sw0 to 1, then we can see that the leds enabled changes, (sw3,..,sw0) turns on (led3,..,led0), and all others are desabled as well as the interruption (we can also change its polarization).



Test du programme d’exemple à src/test.c:

Pour cela, il faudra:

    reconfigurer le FPGA,

make fpga-conf

    attacher un serveur gdb,

make gdb-server

    attacher un terminal (pour la jtag-uart),

make terminal

    lancer une session GDB.

make debug
