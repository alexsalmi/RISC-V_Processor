// Name: Quinn Meurer, Frank Yang, Alex Salmi
// BU ID: UXXXXXXXX, UXXXXXXXX, UXXXXXXXX
// EC413 Project: Register File

module regFile (
  input clock,
  input reset,
  input wEn, // Write Enable
  input [31:0] write_data,
  input [4:0] read_sel1,
  input [4:0] read_sel2,
  input [4:0] write_sel,
  output [31:0] read_data1,
  output [31:0] read_data2
);

reg   [31:0] reg_file[0:31];

/******************************************************************************
*                      Start Your Code Here
******************************************************************************/
integer i;

always@(posedge clock)
	if(reset)
		reg_file[0] <= 0;
	else if(wEn && write_sel!=0)
		reg_file[write_sel] <= write_data;

assign read_data1 = reg_file[read_sel1];
assign read_data2 = reg_file[read_sel2];

endmodule
