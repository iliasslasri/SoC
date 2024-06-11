module avalon_accel(
  input  clk,
  input  reset_n,
  // target interface
  input         avs_write,
  input  [31:0] avs_writedata,
  output [31:0] avs_readdata,
  input  [4:0]  avs_address,
  // initiator interface
  output        avm_write,
  output        avm_read,
  input         avm_waitrequest,
  output [31:0] avm_writedata,
  input  [31:0] avm_readdata,
  output [31:0] avm_address,
  // interrupt
  output  irq
);

/*******************************
* Registers
  R0  -> K0
  R1  -> K1
  R2  -> K2
  R3  -> K3
  R4  -> src
  R5  -> dest
  R6  -> num
  R7  -> ctrl/status
*******************************/
logic[31:0] R[0:7];

// Aliases
wire[3:0][31:0] key_reg  = {R[3],R[2],R[1],R[0]};
wire[31:0]      src_addr_reg = R[4];
wire[31:0]     dest_addr_reg = R[5];
wire[31:0]       num_blk_reg = R[6];
wire[31:0]          ctrl_reg = R[7];

wire start_dma = ctrl_reg;

// Avalon Target interface to update the registers
always_ff@(posedge clk or negedge reset_n)
  if(!reset_n)
    for(int i=0; i<8;i++)
      R[i] <= '0;
  else if(avs_write)
      R[avs_address[4:2]] <= avs_writedata;

assign avs_readdata = R[avs_address[4:2]];

// FSM

endmodule
