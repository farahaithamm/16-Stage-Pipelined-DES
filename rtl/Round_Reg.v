module Round_Reg (
    input wire clk, rst_n, en,
    input wire [1:32] left, right,
    input wire [1:28] c, d,
    input wire enc,
    output reg done,
    output reg [1:32] left_reg, right_reg,
    output reg [1:28] c_reg, d_reg,
    output reg enc_reg
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            left_reg <= 32'b0;
            right_reg <= 32'b0;
            c_reg <= 28'b0;
            d_reg <= 28'b0;
            enc_reg <= 1'b0;
            done <= 1'b0;
        end else begin
            done <= en;
            if (en) begin
                left_reg <= left;
                right_reg <= right;
                c_reg <= c;
                d_reg <= d;
                enc_reg <= enc;
            end
        end
    end

endmodule