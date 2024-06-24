module avalon_accel(
  input  clk,
  input  reset_n,
  // target interface
  input         avs_write,
  input  [31:0] avs_writedata,
  output logic [31:0] avs_readdata,
  input  [4:0]  avs_address,
  // initiator interface
  output    logic    avm_write,
  output        logic avm_read,
  input         avm_waitrequest,
  output logic [31:0] avm_writedata,
  input  [31:0] avm_readdata,
  output logic [31:0] avm_address,
  // interrupt
  output logic interrupt_sender_irq
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



assign avs_readdata = R[avs_address[4:2]];

//-----------------
// ------ FSM -----
// ----------------
parameter s1   = 3'b000;
parameter s2_1 = 3'b001;
parameter s2_2 = 3'b010;
parameter s3   = 3'b011;
parameter s4_1 = 3'b100;
parameter s4_2 = 3'b101;
parameter s5   = 3'b110;
parameter s6   = 3'b111;
reg [2:0] state;

// for accelerator
logic [63:0] ct;
logic [63:0] pt;
logic eoc, start;


// Avalon Target interface to update the registers
always_ff@(posedge clk or negedge reset_n)
  if(!reset_n)
    begin
      avm_address <= 0;
      avm_read <= 0;
      avm_write <= 0;
      avm_writedata <= 0;
      state <= s1;
      for(int i=0; i<8;i++)
        R[i] <= '0;
    end
  else begin
    if(avs_write)
      R[avs_address[4:2]] <= avs_writedata;
    /// FSM ------
    case(state)
      s1 : begin
        if(start_dma)
          state <= s2_1;
      end

      // Reading the first 32-bit word
      s2_1 :
          if(num_blk_reg != 0)
            begin
              avm_write <= 0;
              avm_read <= 1;
              avm_address <= R[4];
              if(!avm_waitrequest)begin
                R[4] <= R[4] + 4;
                pt[31:0] <= avm_readdata;
                state <= s2_2;
              end
            end
          else
            state <= s1;
      
      // Reading the second 32-bit word
      s2_2 :
            begin
              avm_read <= 1;
              avm_address <= R[4];
              if(!avm_waitrequest)begin
                R[4] <= R[4] + 4;
                pt[63:32] <= avm_readdata;
                state <= s3;
                start <= 1;
              end
            end
      
      // Waiting the end of decrypting
      s3: begin 
          start <= 0;
          avm_read <= 0;
          if(eoc) state <= s4_1;
        end
      
      // writing first 32-bit word to mem
      s4_1: begin
          avm_write <= 1;
          if(!avm_waitrequest)begin
            avm_writedata <= ct[31:0];
            avm_address <= dest_addr_reg;
            R[5] <= R[5] + 4;
            state <= s4_2;
          end
      end

      // writing second 32-bit word to mem
      s4_2: begin
          avm_write <= 1;
          if(!avm_waitrequest)begin
            avm_writedata <= ct[63:32];
            avm_address <= R[5];
            R[5] <= R[5] + 4;

            // decreùenting block number 
            R[6] = R[6] - 1;

            if(R[6] == 0)begin
              state <= s5;

            end
            else state <= s2_1;
          end
          
      end

      // gen of interruption
      s5 : begin
        state <= s6;
      end
      
      // waiting for ack
      s6 : begin
        if(ctrl_reg == 0)
          state <= s1;
      end
    endcase

  end

always_ff @(posedge clk or negedge reset_n)
  if(!reset_n)
    interrupt_sender_irq <= 0;
  else begin
    if(state == s5) interrupt_sender_irq <= 1;
    else if(state == s6)  interrupt_sender_irq <= 0;
  end

//// -------------- \\\\\
///  --  present  --  \\\
present my_inst (
                 .clk(clk),
                 .nrst(reset_n),
                 .start(start),
                 .eoc(eoc),
                 .plaintext(pt),
                 .key(key_reg),
                 .ciphertext(ct)
                );
endmodule
