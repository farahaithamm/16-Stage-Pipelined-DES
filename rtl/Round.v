module Round (
    input wire clk, rst_n, start,
    input wire [1:5] level,
    input wire enc_in,
    input wire [1:32] right_in, left_in,
    input wire [1:28] c_in, d_in,
    output wire done,
    output wire enc_out,
    output wire [1:32] right_out, left_out,
    output wire [1:28] c_out, d_out
);

    wire [1:32] f_out;
    wire [1:48] subKey;
    wire [1:28] c_l, d_l, c_r, d_r, c_k, d_k, c_nx, d_nx;
    wire shr1;

    Key_Left_Shift KLS_C (
        .level(level), 
        .key_in(c_in), 
        .key_out(c_l)
    );

    Key_Left_Shift KLS_D (
        .level(level), 
        .key_in(d_in), 
        .key_out(d_l)
    );

    Key_Right_Shift KRS_C (
        .level(level),
        .key_in(c_in),
        .key_out(c_r)
    );

    Key_Right_Shift KRS_D (
        .level(level),
        .key_in(d_in),
        .key_out(d_r)
    );

    assign c_k = enc_in ? c_l : c_in;
    assign d_k = enc_in ? d_l : d_in;

    PC2 PC2_U (
        .right(d_k),
        .left(c_k),
        .subkey(subKey)
    );

    assign c_nx = enc_in ? c_l : c_r;
    assign d_nx = enc_in ? d_l : d_r;

    F F_U (
        .right(right_in),
        .roundKey(subKey),
        .f_out(f_out)
    );

    Round_Reg roundReg (
        .clk(clk),
        .rst_n(rst_n),
        .en(start),
        .left(right_in),
        .right(f_out ^ left_in),
        .c(c_nx),
        .d(d_nx),
        .enc(enc_in),
        .done(done),
        .left_reg(left_out),
        .right_reg(right_out),
        .c_reg(c_out),
        .d_reg(d_out),
        .enc_reg(enc_out)
    );

endmodule