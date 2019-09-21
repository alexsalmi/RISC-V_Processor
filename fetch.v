// Name: Quinn Meurer, Frank Yang, Alex Salmi
// BU ID: UXXXXXXXX, UXXXXXXXX, UXXXXXXXX
// EC413 Project: Fetch Module

module fetch #(
  parameter ADDRESS_BITS = 16
) (
  input  clock,
  input  reset,
  input  next_PC_select,
  input  [ADDRESS_BITS-1:0] target_PC,
  output [ADDRESS_BITS-1:0] PC
);

reg [ADDRESS_BITS-1:0] PC_reg;

assign PC = PC_reg;

/******************************************************************************
*                      Start Your Code Here
******************************************************************************/

always@(posedge clock) begin
	if (next_PC_select == 1'b0) begin
		PC_reg <= PC_reg + 4;
	end else begin
		PC_reg <= target_PC;
	end
end

always@(posedge reset) begin
	PC_reg <= 16'h0000;
end

endmodule
