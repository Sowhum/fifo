# fifo
FIFO based on BRAM

The files consist of Dual Port Synchronous BRAM instantiated in FIFO, the memory addresses are accessed by using pointers maintained by FIFO. A counter is also maintained to check for empty and full conditions. Additionally, almost empty and almost full flags are provided to write data in bursts hence utilizing clock more efficiently
The testbench first writes and then reads a certain amount of words and additionally can be used to check Underflow and Overflow conditions
Simulation was done Using Vivado

![image](https://github.com/user-attachments/assets/85b2dd01-a08d-4a15-b337-846f25803417)
