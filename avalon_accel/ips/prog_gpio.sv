module prog_gpio (
    input logic clk, reset_n,
    input logic avs_write,
    input logic [31:0] avs_writedata,
    // gpio prog
    input logic [4:0] avs_address,
    input logic [31:0] pio_i,
    output logic [31:0] pio_o,
    output logic irq,

    output logic [31:0] avs_readdata

);
logic[31:0] data_out;
logic[31:0] data_in;
// gpio prog
logic[31:0] enable;
logic[31:0] irq_mask;
logic[31:0] irq_pol;

logic irq_ack;
always_ff @(posedge clk or negedge reset_n) begin
  if(!reset_n) begin
    irq_mask <= '0;
    irq_pol <= '0;
    enable <= '1;
    data_out <= '0;
    irq_ack <= 0;
  end
  else begin
    irq_ack <= 0;
    if(avs_write)
    case(avs_address)
      0: data_out <= (avs_writedata & enable);
      4: enable <= avs_writedata;
      8: irq_mask <= avs_writedata;
      12: irq_pol <= avs_writedata;
      16: irq_ack <= 1;
    endcase
  end
end 

always_comb begin 
  case(avs_address)
    0: avs_readdata = data_in;
    4: avs_readdata = enable;
    8: avs_readdata = irq_mask;
    12: avs_readdata = irq_pol;
    default: avs_readdata = 0;
  endcase
end

assign data_in = pio_i & enable;
assign pio_o = (data_out & enable) ;

wire [31:0] enabled_irqs = (data_in^irq_pol) & enable & irq_mask;

always_ff @(posedge clk or negedge reset_n)
  if(!reset_n)
    irq <= 0;
  else begin
    if(irq_ack) irq <= 0;
    else if(enabled_irqs != 0)  irq <= 1;
  end

endmodule