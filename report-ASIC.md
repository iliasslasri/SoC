           
### 1. PREMIERE ETAPE

|       | Clock Edge      |   Slack    |       |       |
|---    |:-:    |:-:    |:-:    |--:    |
|       |    86876   |    31312   |       |       |
|       |    80000   |   28562    |       |       |
|       |    22876   |   5879     |       |       |
|       |    11118   |   1048    |       |       |
|       |    9022   |    431   |       |       |
|       |    8160   |      9   |       |       |
|       |    8142   |      2   |       |       |
|       |    8138   |      0 |       |       |
|       |    8100   |      50   |       |       |
|       |    8000   |      9 |       |       |
|       |    7800   |      1 |       |       |
|       |    7500   |     23  |       |       |
|       |    7200   |     1  |       |       |
|       |    7000   |     1  |       |       |
|       |     6500  |    0   |       |       |
|       |     6000  |      1 |       |       |
|       |     5500  |      0 |       |       |
|       |     5000  |     0  |       |       |
|       |     3900  |    -90   |       |       |
|       |      4000 |      -25 |       |       |
|       |     4050  |   0    |       |       |

We then settle for 4050ps, as the minimal supported clock period, for 2 as UNROLL_FCTR.

for UNROLL_FCTR of 4 : 5000 : -1052

|       | Clock Edge      |   Slack    |       |       |
|---    |:-:    |:-:    |:-:    |--:    |
|       |    20000   |    1103   |       |       |
|       |   5000    |    -1052   |       |       |
|       |   7500    |    -56   |       |       |
|       |   8000    |    0   |       |       |
|       |   9000    |    0   |       |       |
|       |   8500    |    0   |       |       |
|       |   8250    |    0   |       |       |
|       |   7750    |    0   |       |       |
|       |   7650    |    0   |       |       |
|       |   7550    |    -17   |       |       |
|       |   7600    |    -0   |       |       |
|       |   7625    |    0   |       |       |
|       |   7610    |    0   |       |       |
|       |   7605    |    -1   |       |       |
|       |   7607    |    -4   |       |       |

***The minimal supported clock period, for 4 as UNROLL_FCTR is 7607pss*** 

UNROLL 8

|       | Clock Edge      |   Slack    |       |       |
|---    |:-:    |:-:    |:-:    |--:    |
|       |    20000   |   0    |       |       |
|       |    10000   |  -2007    |       |       |
|       |   16000    |     0  |       |       |
|       |   13000    |    -730   |       |       |
|       |   14500    |    -106   |       |       |
|       |   15000    |    0   |       |       |
|       |   14750    |    -63   |       |       |
|       |   14800    |    0   |       |       |
|       |   14775    |    -2   |       |       |
|       |   14780    |    -52   |       |       |
|       |   14790    |    0  |       |       |
|       |   14795    |    x  |       |       |

UNROLL 16

|       | Clock Edge      |   Slack    |       |       |
|---    |:-:    |:-:    |:-:    |--:    |
|       |   30000    |  0     |       |       |
|       |    15000   |   -5868   |       |       |
|       |   25000    |  -1845    |       |       |
|       |   35000    |    0   |       |       |
|       |   30000    |    0   |       |       |
|       |   27500    |    -810   |       |       |
|       |   28600    |    -810   |       |       |

### 

    UNROLL_FCTR     Period(ps)      Power cons(W)      total area (µm²)       Time to get a 1 crypto(s)
            1       2779             1.14885e-03        5096.320               8.53569× 10-6
            2       4050             1.43919e-03        10173.188              7.9785 × 10-7

Analysis:

***Complexity vs. Speed***: As UNROLL_FCTR increases, the gate count and power consumption increase significantly. However, the throughput also increases, leading to better performance.

***Energy Efficiency***: 

***Optimization Strategy***: UNROLL_FCTR of 4 offers a balanced trade-off between speed, complexity, and power consumption.

The results indicate that increasing UNROLL_FCTR improves throughput but at the cost of higher power consumption and complexity. The most energy-efficient configuration is achieved with UNROLL_FCTR set to 4.

