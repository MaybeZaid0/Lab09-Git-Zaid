`timescale 1ns / 1ps

module alu_control (
    input  wire [1:0] ALUOp,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output reg  [3:0] ALUControl
);

    always @(*) begin
        ALUControl = 4'b0000; 

        case (ALUOp)
            2'b00: ALUControl = 4'b0010;
            2'b01: ALUControl = 4'b0110;
            2'b11: begin 
                if (funct3 == 3'b000) ALUControl = 4'b0010; // ADDI -> ADD
            end
            2'b10: begin 
                case (funct3)
                    3'b000: begin
                        if (funct7 == 7'b0000000) ALUControl = 4'b0010; // ADD
                        else if (funct7 == 7'b0100000) ALUControl = 4'b0110; // SUB
                    end
                    3'b001: ALUControl = 4'b0100; // SLL
                    3'b101: ALUControl = 4'b0101; // SRL
                    3'b111: ALUControl = 4'b0000; // AND
                    3'b110: ALUControl = 4'b0001; // OR
                    3'b100: ALUControl = 4'b0011; // XOR
                    default: ALUControl = 4'b0000;
                endcase
            end
        endcase
    end
endmodule