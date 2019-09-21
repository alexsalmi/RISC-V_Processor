// Name: Quinn Meurer, Frank Yang, Alex Salmi
// BU ID: UXXXXXXXX, UXXXXXXXX, UXXXXXXXX
// EC413 Project: RAM testbench

module ram_tb();

parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 16;

reg  clock;

// Instruction Port
reg  [ADDR_WIDTH-1:0] i_address;
wire [DATA_WIDTH-1:0] i_read_data;

// Data Port
reg  wEn;
reg  [ADDR_WIDTH-1:0] d_address;
reg  [DATA_WIDTH-1:0] d_write_data;
wire [DATA_WIDTH-1:0] d_read_data;


ram #(
  .DATA_WIDTH(DATA_WIDTH),
  .ADDR_WIDTH(ADDR_WIDTH)
) uut (
  .clock(clock),

  // Instruction Port
  .i_address(i_address),
  .i_read_data(i_read_data),

  // Data Port
  .wEn(wEn),
  .d_address(d_address),
  .d_write_data(d_write_data),
  .d_read_data(d_read_data)

);

always #5 clock = ~clock;


initial begin
  clock = 1'b1;
  d_address = 16'd0;
  i_address = 16'd0;
  d_write_data = 16'd0;
  wEn = 1'b0;

  #10
  wEn = 1'b1;
  #10
  $display("Data Address %d: %h", d_address, d_read_data);
  d_write_data = 1;
  d_address = 4;
  #10
  $display("Data Address %d: %h", d_address, d_read_data);
  d_write_data = 2;
  d_address = 8;
  #10
  $display("Data Address %d: %h", d_address, d_read_data);

	//Check if instruction reading is working
  $readmemh("./gcd.vmh", uut.ram);
  #10
  wEn = 1'b0;
  i_address = i_address + 6'b100000;

  #100
  $stop();

end

endmodule
