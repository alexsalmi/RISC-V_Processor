`timescale 1ns / 1ps
// Name: Quinn Meurer, Frank Yang, Alex Salmi
// BU ID: UXXXXXXXX, UXXXXXXXX, UXXXXXXXX
// EC413 Project part 1: ALU

module ALU (
	input branch_op,
  input [5:0]  ALU_Control,
  input [31:0] operand_A,
  input [31:0] operand_B,
  output [31:0] ALU_result,
  output branch

);

/******************************************************************************
*                      Start Your Code Here
******************************************************************************/

wire signed [31:0] s_op_a, s_op_b, s_alu_result, s_alu_resultS, BEQResult;

assign s_op_a = operand_A;

assign s_op_b = operand_B;

assign s_alu_result = s_op_a < s_op_b;

//assign s_alu_resultS = $signed(s_op_a) < $signed(s_op_b);

assign BEQResult = s_op_a == s_op_b;

assign ALU_result = ALU_Control == 6'b000000 ? operand_A + operand_B :			//Add good
                          ALU_Control == 6'b001000 ? operand_A - operand_B :  //Subtract good
                          ALU_Control == 6'b000010 ? s_alu_result:				//SLT/SLTI good
								  ALU_Control == 6'b000011 ? operand_A < operand_B :	//SLTU/SLTIU good
                          ALU_Control == 6'b000100 ? operand_A ^ operand_B :	//bitwise XOR good
                          ALU_Control == 6'b000111 ? operand_A & operand_B :	//bitwise AND good
								  ALU_Control == 6'b000110 ? operand_A | operand_B :	//bitwise OR good
								  ALU_Control == 6'b000001 ? operand_A << operand_B:	//SLLI good
								  ALU_Control == 6'b000101 ? operand_A >> operand_B:	//SRLI good
								  ALU_Control == 6'b001101 ? s_op_a >>> operand_B: //Arithmetic shiftR
								  ALU_Control == 6'b010000 ? operand_A == operand_B:		//BEQ good
								  ALU_Control == 6'b010001 ? !(operand_A == operand_B):	//BNE good
								  ALU_Control == 6'b010100 ? s_alu_result:				//BsignedLT good
								  ALU_Control == 6'b010101 ? !s_alu_result:				//BsignedGE good
								  ALU_Control == 6'b010110 ? operand_A < operand_B:	//BLTU good
								  ALU_Control == 6'b010111 ? !(operand_A < operand_B):	//BGEU good
								  ALU_Control == 6'b011111 ? operand_A:					//JAL good
								  ALU_Control == 6'b111111 ? operand_A:					//JALR good
								  0;




assign branch = (ALU_Control == 6'b010000 && (operand_A == operand_B) == 1 && branch_op == 1) ? 1 : //BEQ
					 (ALU_Control == 6'b010001 && (operand_A == operand_B) == 0 && branch_op == 1) ? 1 : //BNE
					 (ALU_Control == 6'b010100 && s_alu_result == 1 && branch_op == 1) ? 1: //BLT signed
				    (ALU_Control == 6'b010101 && s_alu_result == 0 && branch_op == 1) ? 1: //BGE signed
					 (ALU_Control == 6'b010110 && operand_A < operand_B == 1 && branch_op == 1) ? 1: //BLTU
					 (ALU_Control == 6'b010111 && operand_A < operand_B == 0 && branch_op == 1) ? 1: //BGEU

					 0;
endmodule
