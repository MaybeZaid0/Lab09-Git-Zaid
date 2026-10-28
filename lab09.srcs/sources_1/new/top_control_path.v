`timescale 1ns / 1ps

module top_control_path (
    input  wire clk,     
    input  wire btnC,     
    input  wire btnU,       
    input  wire [15:0] sw,         
    output reg [15:0] led         
);

    wire rst;
    wire step_pulse;

    localparam READ_INPUTS = 1'b0;
    localparam DISPLAY_OUTPUTS = 1'b1;
    reg state, next_state;

    reg [6:0] cap_opcode;
    reg [2:0] cap_funct3;
    reg [6:0] cap_funct7;

    wire RegWrite, MemRead, MemWrite, ALUSrc, MemtoReg, Branch;
    wire [1:0] ALUOp;
    wire [3:0] ALUControl;

    debouncer u_reset_db (
        .clk(clk),
        .pbin(btnC),
        .pbout(rst)
    );

    button_pulse u_step_pulse (
        .clk(clk),
        .btn_raw(btnU),
        .pulse(step_pulse)
    );

    main_control u_main_ctrl (
        .opcode(cap_opcode),
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
        .funct3(cap_funct3),
        .funct7(cap_funct7),
        .ALUControl(ALUControl)
    );

    always @(posedge clk) begin
        if (rst) begin
            state <= READ_INPUTS;
            cap_opcode <= 7'b0;
            cap_funct3 <= 3'b0;
            cap_funct7 <= 7'b0;
        end else begin
            state <= next_state;
            
            if (state == READ_INPUTS && step_pulse) begin
                cap_opcode <= sw[6:0];
                cap_funct3 <= sw[9:7];
                cap_funct7 <= {1'b0, sw[15], 5'b00000}; 
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            READ_INPUTS: if (step_pulse) next_state = DISPLAY_OUTPUTS;
            DISPLAY_OUTPUTS: if (step_pulse) next_state = READ_INPUTS;
        endcase
    end

    always @(*) begin
        led = 16'b0; 
        
        if (state == READ_INPUTS) begin
            led[6:0] = sw[6:0];    
            led[9:7] = sw[9:7];    
            led[15] = sw[15];     
            led[14] = 1'b0;       
        end 
        else begin
            led[0] = RegWrite;
            led[1] = ALUSrc;
            led[2] = MemRead;
            led[3] = MemWrite;
            led[4] = MemtoReg;
            led[5] = Branch;
            led[7:6] = ALUOp;
            led[11:8] = ALUControl;
            led[14] = 1'b1;     
        end
    end

endmodule


