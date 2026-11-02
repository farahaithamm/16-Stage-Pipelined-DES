module Key_Right_Shift (
    input wire [1:5] level,
    input wire [1:28] key_in,
    output wire [1:28] key_out
);

    // Right shift (decrypt): shift round (17-level)
    assign key_out = (level == 1 || level == 8 || level == 15 || level == 16) ?
                 {key_in[28], key_in[1:27]} :      // shift by 1
                 {key_in[27:28], key_in[1:26]};    // shift by 2

endmodule