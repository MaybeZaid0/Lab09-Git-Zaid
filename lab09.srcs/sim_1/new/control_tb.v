`timescale 1ns / 1ps

module control_tb;
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;

    wire RegWrite, MemRead, MemWrite, ALUSrc, MemtoReg, Branch;
    wire [1:0] ALUOp;
    wire [3:0] ALUControl;

    main_control u_main_ctrl (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .Branch(Branch)
    );

    alu_control u_alu_ctrl (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(ALUControl)
    );

    initial begin
        opcode = 7'b0110011; funct3 = 3'b000; funct7 = 7'b0000000; #10;
        opcode = 7'b0110011; funct3 = 3'b000; funct7 = 7'b0100000; #10;
        opcode = 7'b0110011; funct3 = 3'b001; funct7 = 7'b0000000; #10;
        opcode = 7'b0110011; funct3 = 3'b101; funct7 = 7'b0000000; #10;
        opcode = 7'b0110011; funct3 = 3'b111; funct7 = 7'b0000000; #10;
        opcode = 7'b0110011; funct3 = 3'b110; funct7 = 7'b0000000; #10;
        opcode = 7'b0110011; funct3 = 3'b100; funct7 = 7'b0000000; #10;
        opcode = 7'b0010011; funct3 = 3'b000; funct7 = 7'bXXXXXXX; #10;
        opcode = 7'b0000011; funct3 = 3'b010; funct7 = 7'bXXXXXXX; #10;
        opcode = 7'b0000011; funct3 = 3'b001; funct7 = 7'bXXXXXXX; #10;
        opcode = 7'b0000011; funct3 = 3'b000; funct7 = 7'bXXXXXXX; #10;
        opcode = 7'b0100011; funct3 = 3'b010; funct7 = 7'bXXXXXXX; #10;
        opcode = 7'b0100011; funct3 = 3'b001; funct7 = 7'bXXXXXXX; #10;
        opcode = 7'b0100011; funct3 = 3'b000; funct7 = 7'bXXXXXXX; #10;
        opcode = 7'b1100011; funct3 = 3'b000; funct7 = 7'bXXXXXXX; #10;

        #10 $finish;
    end
endmodule