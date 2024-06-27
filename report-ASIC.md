           
# ASIC Implementation of the present Encryption Algorithm

UNROLL_FCTR  |   Period(ps)  |    Power cons(W)   |   total area (µm²)  |     Time to get a 1 crypto(s)|
|---    |:-:    |:-:    |:-:    |--:    |
|    1    |   2779        |     1.14885e-03    |    5096.320         |      8.53569× 10-6|
|    2    |   4050        |     1.43919e-03    |    10173.188        |      7.9785 × 10-7|
|    4    |   7607        |     2.02852e-03    |    20346.376        |      4.18925× 10-7|
|    8    |   14795       |     3.40719e-03    |    40692.752        |      2.17475× 10-7|
|    16   |   29500       |     6.16438e-03    |    81385.504        |      1.08737× 10-7|

#### Comparative Analysis:
##### Clock Period:
- The clock period increases with the unrolling factor. This is because higher unrolling factors result in more parallel operations per clock cycle, which necessitates a longer clock period to ensure that all operations complete without timing violations.
##### Power Consumption:
- Power consumption increases significantly with the unrolling factor due to the increased number of simultaneous operations and the associated overhead.
##### TOtal Area:
- The total area of the design approximately doubles with each increase in the unrolling factor. This is expected as more resources are required to implement additional parallel operations.
##### Performance (Time to Get One Cryptographic Operation):
- The time to complete one cryptographic operation decreases dramatically with higher unrolling factors, highlighting the performance gains from parallelism.
#####
#### Conculsions: 
##### Trade-offs:
- Increasing the unrolling factor improves performance (reduces the time to complete a cryptographic operation) but requires a longer clock period, more power, and greater area.
- We must balance these factors based on the application requirements. If speed is critical and resources are available, higher unrolling factors are beneficial. Conversely, for power or area-constrained applications, lower unrolling factors may be preferable.
##### Optimal Unrolling Factor:
- The optimal unrolling factor depends on the specific performance, power, and area constraints of the target application. For high-performance needs, higher unrolling factors like 4 or 8 may be optimal, despite their higher clock periods and resource requirements. For more balanced designs, a factor of 2 might provide a good trade-off.





## for UNROLL_FCTR = 1, 2, 4, 8, 16, we have the following results, while searching for the minimal supported clock period : 

### UNROLL 2
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

### UNROLL 4

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
|       |   7607    |    0   |       |       |

***The minimal supported clock period, for 4 as UNROLL_FCTR is 7607ps*** 

### UNROLL 8

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
|       |   14795    |    0  |       |       |

***The minimal supported clock period, for 8 as UNROLL_FCTR is 14795ps*** 

### UNROLL 16

|       | Clock Edge      |   Slack    |       |       |
|---    |:-:    |:-:    |:-:    |--:    |
|       |   30000    |  0     |       |       |
|       |    15000   |   -5868   |       |       |
|       |   25000    |  -1845    |       |       |
|       |   35000    |    0   |       |       |
|       |   30000    |    0   |       |       |
|       |   27500    |    -810   |       |       |
|       |   28600    |    -810   |       |       |
|       |   29500    |    0   |       |       |

***The minimal supported clock period, for 16 as UNROLL_FCTR is 29500ps*** 
