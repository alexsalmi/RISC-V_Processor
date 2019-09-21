//// Name: Quinn Meurer, Frank Yang, Alex Salmi
// BU ID: UXXXXXXXX, UXXXXXXXX, UXXXXXXXX
//// EC413 Project: Top level module

module top #(
  parameter ADDRESS_BITS = 16
) (
  input clock,
  input reset,

  output [31:0] wb_data
);


/******************************************************************************
*                      Start Your Code Here
******************************************************************************/

// Fetch Wires
wire next_PC_select;
wire [ADDRESS_BITS-1:0] target_PC;
wire [ADDRESS_BITS-1:0] PC;

// Decode Wires
wire [31:0] instruction;
wire branch;
wire [1:0] op_A_sel;
wire op_B_sel;
wire [4:0] read_sel1;
wire [4:0] read_sel2;
wire [4:0] write_sel;
wire wEn;
wire [31:0] imm32;
wire [5:0] ALU_Control;
wire branch_op;
wire mem_wEn;
wire wb_sel;

// Reg File Wires
wire [31:0] read_data1;
wire [31:0] read_data2;

// Execute Wires
wire [ADDRESS_BITS-1:0] JALR_target; // Assigned outside of ALU
wire [31:0] ALU_op_A;
wire [31:0] ALU_op_B;
wire [31:0] ALU_result;

// Memory Wires
wire [31:0] d_read_data;

// Writeback wires

//// 00 for read data 1, 01 for auipic (PC), 10 for JALR (PC + 4), 11 for LUI (zero)
assign ALU_op_A = op_A_sel == 2'b00 ? read_data1 :
						op_A_sel == 2'b01 ? PC :
						op_A_sel == 2'b10 ? PC + 4 :
						0;

//// 0 for Read_data_2, 1 for immediate. Think that u don't care about jal and jalr
assign ALU_op_B = op_B_sel == 1'b0 ? read_data2 : imm32;

////1 if LOAD 0 otherwise
assign wb_data = wb_sel == 1'b1 ? d_read_data : ALU_result;

assign JALR_target = (read_data1 + imm32) & 32'hfffffffe;

fetch #(
  .ADDRESS_BITS(ADDRESS_BITS)
) fetch_inst (
  .clock(clock),
  .reset(reset),
  .next_PC_select(next_PC_select),
  .target_PC(target_PC),
  .PC(PC)
);


decode #(
  .ADDRESS_BITS(ADDRESS_BITS)
) decode_unit (

  // Inputs from Fetch
  .PC(PC),
  .instruction(instruction),

  // Inputs from Execute/ALU
  .JALR_target(JALR_target[ADDRESS_BITS-1:0]),
  .branch(branch),

  // Outputs to Fetch
  .next_PC_select(next_PC_select),
  .target_PC(target_PC),

  // Outputs to Reg File
  .read_sel1(read_sel1),
  .read_sel2(read_sel2),
  .write_sel(write_sel),
  .wEn(wEn),

  // Outputs to Execute/ALU
  .branch_op(branch_op),
  .imm32(imm32),
  .op_A_sel(op_A_sel),
  .op_B_sel(op_B_sel),
  .ALU_Control(ALU_Control),

  // Outputs to Memory
  .mem_wEn(mem_wEn),

  // Outputs to Writeback
  .wb_sel(wb_sel)

);


regFile regFile_inst (
  .clock(clock),
  .reset(reset),
  .wEn(wEn), // Write Enable
  .write_data(wb_data),
  .read_sel1(read_sel1),
  .read_sel2(read_sel2),
  .write_sel(write_sel),
  .read_data1(read_data1),
  .read_data2(read_data2)
);



ALU alu_inst(
  .branch_op(branch_op),
  .ALU_Control(ALU_Control),
  .operand_A(ALU_op_A),
  .operand_B(ALU_op_B),
  .ALU_result(ALU_result),
  .branch(branch)
);


ram #(
  .ADDR_WIDTH(ADDRESS_BITS)
) main_memory (
  .clock(clock),

  // Instruction Port
  .i_address(PC),
  .i_read_data(instruction),

  // Data Port
  .wEn(mem_wEn),
  .d_address(ALU_result[ADDRESS_BITS-1:0]),
  .d_write_data(read_data2),
  .d_read_data(d_read_data)
);

endmodule
