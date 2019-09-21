// Name: Quinn Meurer, Frank Yang, Alex Salmi
// BU ID: UXXXXXXXX, UXXXXXXXX, UXXXXXXXX
// EC413 Project: Register File Test Bench

module regFile_tb();

reg clock, reset;

/******************************************************************************
*                      Start Your Code Here
******************************************************************************/
reg wEn;
reg [31:0] write_data;
wire [31:0] read_data1, read_data2;
reg [4:0] read_sel1, read_sel2, write_sel;
// Fill in port connections
regFile uut (
  .clock(clock),
  .reset(reset),
  .wEn(wEn), // Write Enable
  .write_data(write_data),
  .read_sel1(read_sel1),
  .read_sel2(read_sel2),
  .write_sel(write_sel),
  .read_data1(read_data1),
  .read_data2(read_data2)
);


always #5 clock = ~clock;

initial begin
  clock = 1'b1;
  reset = 1'b1;

  #20;
  reset = 1'b0;

  // Test reads and writes to the register file here
  #100
  // Changing a register value
  wEn = 1;
  write_sel = 5'b00001;
  write_data = 32'b01111111111111111111111111111111;

	#10
	// Reading a reset register value (sel1, should be 0) and a changed register value (sel2, should be same value as write_data)
	wEn = 0;
	read_sel1 = 5'b00000;
	read_sel2 = 5'b00001;

	#100
	// Changing another value
  wEn = 1;
  write_sel = 5'b00011;
  write_data = 32'b10101010101010101010101010101010;
  #10
  //Changing the value of a register that has already been changed
  write_sel = 5'b00001;
  write_data = 32'b00000000000000001111111111111111;


	#10
	// Reading the values of the registers that were just updated
	wEn = 0;
	read_sel1 = 5'b00011;
	read_sel2 = 5'b00001;

	#100
	// Read during write test, both read_data1 and read_data2 should be 0
  read_sel1 = 5'b01111;
  wEn = 1;
  write_sel = 5'b01111;
  write_data = 32'b10101010101010101010101010101010;
  read_sel2 = 5'b01111;

  #100
  // Read_data1 and read_data2 should now hold the new updated value
  read_sel1 = 5'b01111;
  read_sel2 = 5'b01111;

end // always
endmodule
