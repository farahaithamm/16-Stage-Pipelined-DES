module Key_Left_Shift (
    input wire [1:5] level,
    input wire [1:28] key_in,
    output wire [1:28] key_out
);

    assign key_out = (level == 1 || level == 2 || level == 9 || level == 16) ?
                 {key_in[2:28], key_in[1]} :      // shift by 1
                 {key_in[3:28], key_in[1:2]};     // shift by 2

endmodule