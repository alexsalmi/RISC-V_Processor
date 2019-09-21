`timescale 1ns / 1ps
// Name: Quinn Meurer, Frank Yang, Alex Salmi
// BU ID: UXXXXXXXX, UXXXXXXXX, UXXXXXXXX
// EC413 Project: ALU Test Bench

module ALU_tb();
reg branch_op;
reg [5:0] ctrl;
reg [31:0] opA, opB;

wire [31:0] result;
wire branch;

ALU dut (
  .branch_op(branch_op),
  .ALU_Control(ctrl),
  .operand_A(opA),
  .operand_B(opB),
  .ALU_result(result),
  .branch(branch)
);

initial begin
  branch_op = 1'b0;
  ctrl = 6'b000000;
  opA = 4;
  opB = 5;

  #10
  $display("ALU Result 4 + 5: %d",result);
  #10
  ctrl = 6'b000010;
  #10
  $display("ALU signed Result 4 < 5: %d",result);

  #10
  opB = 32'hffffffff;
  #10
  $display("ALU signed Result 4 < -1: %d",result);
    ctrl = 6'b000011;
  #10

  $display("ALU unsigned Result 4 < -1: %d",result);



  branch_op = 1'b1;
  opB = 32'hffffffff;
  opA = 32'hffffffff;
  ctrl = 6'b010_000; // BEQ
  #10
  $display("ALU Result (BEQ): %d",result);
  $display("Branch (should be 1): %b", branch);

/******************************************************************************
*                      Add Test Cases Here
******************************************************************************/

  branch_op = 1'b0;
  ctrl = 6'b001000;
  opA = 12;
  opB = 5;

  #10
  $display("ALU Result 12-5: %d",result);
  #10
  ctrl = 6'b000100;
  #10
  $display("ALU Result 12 Xor 5): %d",result);
  #10

  ctrl = 6'b000110;
  #10
  $display("ALU Result 12 OR 5): %d",result);
  #10

  ctrl = 6'b000111;
  #10
  $display("ALU Result 12 AND 5): %d",result);
  #10


  branch_op = 1'b1;
  opB = 2;
  opA = 11;
  ctrl = 6'b010_000;
  #10
  $display("ALU Result BEQ (2=11): %d",result);
  $display("Branch (should be 0): %b", branch);


  branch_op = 1'b1;
  opB = 2;
  opA = 11;
  ctrl = 6'b010_001;
  #10
  $display("ALU Result BNE (2=11): %d",result);
  $display("Branch (should be 1): %b", branch);



  branch_op = 1'b1;
  opB = 123;
  opA = 4;
  ctrl = 6'b010_100;
  #10
  $display("ALU Result BLT signed (4<123): %d",result);
  $display("Branch (should be 1): %b", branch);


  branch_op = 1'b1;
  opB = -123;
  opA = 4;
  ctrl = 6'b010_100;
  #10
  $display("ALU Result BLT signed (4<-123): %d",result);
  $display("Branch (should be 0): %b", branch);

  branch_op = 1'b1;
  opB = 123;
  opA = 4;
  ctrl = 6'b010_110;
  #10
  $display("ALU Result BLTU unsigned (4<123): %d",result);
  $display("Branch (should be 0): %b", branch);

  branch_op = 1'b1;
  opB = -123;
  opA = 4;
  ctrl = 6'b010_110;
  #10
  $display("ALU Result BLTU signed (4<-123): %d",result);
  $display("Branch (should be 0): %b", branch);




  branch_op = 1'b1;
  opB = 5;
  opA = 41;
  ctrl = 6'b010_101;
  #10
  $display("ALU Result BGE signed (41>5): %d",result);
  $display("Branch (should be 1): %b", branch);

  branch_op = 1'b1;
  opB = 5;
  opA = -1;
  ctrl = 6'b010_101;
  #10
  $display("ALU Result BGE signed (-1>5): %d",result);
  $display("Branch (should be 0): %b", branch);

  branch_op = 1'b1;
  opB = 5;
  opA = 41;
  ctrl = 6'b010_111;
  #10
  $display("ALU Result BGEU unsigned (41>5): %d",result);
  $display("Branch (should be 1): %b", branch);

  branch_op = 1'b1;
  opB = 5;
  opA = -1;
  ctrl = 6'b010_111;
  #10
  $display("ALU Result BGEU unsigned (-1>5): %d",result);
  $display("Branch (should be 1): %b", branch);


  branch_op = 1'b0;
  opB = 5;
  opA = -1;
  ctrl = 6'b010_111;
  #10
  $display("ALU Result BGE unsigned (-1>5): %d",result);
  $display("Branch (should be 0) branch_op is 0: %b", branch);























	branch_op = 1'b1;
	opB = 32'hfdff1af1;
	opA = 32'hfc4f1ff1;
	ctrl = 6'b111111;
	#10;
	$display("JAL 6'b111111: %d",result);
	$display("branch? %d",branch);

	branch_op = 1'b0;
	opB = 32'hfdff1af1;
	opA = 32'hfc4f1ff0;
	ctrl = 6'b011111;
	#10;
	$display("JALR 6'b011111: %d",result);
	$display("branch? %d",branch);


	opB = 3;
	opA = 1;
	ctrl = 6'b000001;
	#10;
	$display("1 shifted 3 bits left (8): %d",result);

	opB = 2;
	opA = 23;
	ctrl = 6'b000101;
	#10;
	$display("23 shifted 3 bits right (5): %d",result);

	opB = 2;
	opA = -5;
	ctrl = 6'b001101;
	#10;
	$display("5 (arithmetic) shift 2 bits right (ALU_Result): %d", result);
	$display("5 (arithmetic) shift 2 bits right ($signed(opA) >>> opB): %d", ($signed(opA) >>> opB));

	opB = 2;
	opA = 5;
	ctrl = 6'b001101;
	#10;
	$display("5 (arithmetic) shift 2 bits right (ALU_Result) : %d", result);
	$display("5 (arithmetic) shift 2 bits right ($signed(opA) >>> opB) : %d", ($signed(opA) >>> opB));

  #10
  $stop();

end

endmodule
