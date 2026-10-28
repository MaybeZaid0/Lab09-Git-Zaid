`timescale 1ns / 1ps

module debouncer (
    input  clk,
    input  pbin,
    output reg pbout = 0
);

    reg [1:0]  sync = 2'b00;
    reg [19:0] stable_cnt = 20'd0;   // ~10 ms at 100 MHz

    always @(posedge clk) begin
        sync <= {sync[0], pbin};

        if (sync[1] == pbout) begin
            stable_cnt <= 20'd0;
        end else begin
            stable_cnt <= stable_cnt + 1'b1;
            if (stable_cnt == 20'hFFFFF)
                pbout <= sync[1];
        end
    end

endmodule