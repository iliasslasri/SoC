module avalon_accel(
  input  clk,
  input  reset_n,
  // target interface
  input         avs_write,
  input  [31:0] avs_writedata,
  output [31:0] avs_readdata,
  input  [4:0]  avs_address,
  // initiator interface
  output  logic avm_write,
  output  logic avm_read,
  input         avm_waitrequest,
  output logic [31:0] avm_writedata,
  input  [31:0] avm_readdata,
  output logic [31:0] avm_address,
  // interrupt
  output logic irq
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
    for(int i=0; i<8; i++)
      R[i] <= '0;
  else
    if(avs_write) 
      R[avs_address[4:2]] <= avs_writedata;


// __________________ \\
// ______ FSM _______ \\
// __________________ \\

enum logic [3:0] {wait_for_crtl, read_frst_word, read_scd_word, start_encr, wait_end_encry, write_frst_word, write_scd_word, gen_irq} state; 
assign avs_readdata = (avs_address == 5'h1c) ? !(state == wait_for_crtl) : R[avs_address[4:2]];

// for accelerator
logic [63:0] ct;
logic [63:0] pt;
logic eoc;


logic[31:0] read_addr_reg;
logic[31:0] write_addr_reg;
logic[31:0] blk_reg;

always_ff@(posedge clk or negedge reset_n)
  if(!reset_n)begin
    read_addr_reg <= '0;      
    avm_address <= '0;
  end
  else
  begin
     if (state == read_frst_word && !avm_waitrequest) begin
          read_addr_reg <= read_addr_reg + 4;
          avm_address <= read_addr_reg;
          pt[63:32] <= avm_readdata;
     end
     if (state == read_scd_word  && !avm_waitrequest) begin 
        read_addr_reg <= read_addr_reg + 4;
        avm_address <= read_addr_reg;
        pt[31:0] <= avm_readdata;
      end
    if (state == write_frst_word && !avm_waitrequest) begin
      avm_writedata <= ct[63:32];
      write_addr_reg <= write_addr_reg + 4;
      avm_address <= write_addr_reg;
     end
     if (state == write_scd_word  && !avm_waitrequest) begin
      avm_writedata <= ct[31:0];
      write_addr_reg <= write_addr_reg + 4;
      avm_address <= write_addr_reg;
     end
     if (state == wait_for_crtl) begin 
        write_addr_reg <= dest_addr_reg;
        read_addr_reg <= src_addr_reg;
      end
  end

always_ff@(posedge clk or negedge reset_n)
  if(!reset_n)begin
      avm_read <= 0;
      avm_write <= 0;
    end
  else begin
    if(state == read_scd_word || state == read_frst_word)begin
      // avm_address <= read_addr_reg;
      avm_read <= 1;
      avm_write <= 0;
    end
    else if(state == write_scd_word || state == write_frst_word)begin
      // avm_address <= write_addr_reg;
      avm_read <= 0;
      avm_write <= 1;
    end
    else begin
      avm_read <= 0;
      avm_write <= 0;
    end
  end


always_ff@(posedge clk or negedge reset_n)
  if(!reset_n)
    blk_reg <= '0;
  else
    begin
      if (state == start_encr) blk_reg <= blk_reg - 1;
      if (state == wait_for_crtl)  blk_reg <= num_blk_reg;
    end


wire start_present = (state == start_encr);


always_ff@(posedge clk or negedge reset_n)
  if(!reset_n)
    state <= wait_for_crtl;
  else
    case(state)
      wait_for_crtl :
        if(start_dma) state <= read_frst_word;
      read_frst_word :
	      if(!avm_waitrequest) state <= read_scd_word;
      read_scd_word :
	      if(!avm_waitrequest) state <= start_encr;
      start_encr :
      	state <= wait_end_encry;
      wait_end_encry :
	      if (eoc) state <= write_frst_word ;
      write_frst_word :
        if(!avm_waitrequest) state <= write_scd_word;
      write_scd_word :
        if(!avm_waitrequest) if(blk_reg) state <= read_frst_word;
                              else state <= gen_irq;
      gen_irq :
      	if (!start_dma) state <= wait_for_crtl;
    endcase 
 
always_ff @(posedge clk or negedge reset_n)
  if(!reset_n)
    irq <= 0;
  else begin
    if(state == gen_irq) irq <= 1;
    else if(irq)  irq <= 0;
  end

//// -------------- \\\\\
///  --  present  --  \\\
present my_inst (
                 .clk(clk),
                 .nrst(reset_n),
                 .start(start_present),
                 .eoc(eoc),
                 .plaintext(pt),
                 .key(key_reg),
                 .ciphertext(ct)
                );
endmodule