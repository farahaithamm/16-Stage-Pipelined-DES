module IP (
    input  wire [1:64] plain_text,
    output wire [1:32] left, right
);

    wire [1:64] out;

    assign out = {
        plain_text[58], plain_text[50], plain_text[42], plain_text[34],
        plain_text[26], plain_text[18], plain_text[10], plain_text[2],
        plain_text[60], plain_text[52], plain_text[44], plain_text[36],
        plain_text[28], plain_text[20], plain_text[12], plain_text[4],
        plain_text[62], plain_text[54], plain_text[46], plain_text[38],
        plain_text[30], plain_text[22], plain_text[14], plain_text[6],
        plain_text[64], plain_text[56], plain_text[48], plain_text[40],
        plain_text[32], plain_text[24], plain_text[16], plain_text[8],
        plain_text[57], plain_text[49], plain_text[41], plain_text[33],
        plain_text[25], plain_text[17], plain_text[9],  plain_text[1],
        plain_text[59], plain_text[51], plain_text[43], plain_text[35],
        plain_text[27], plain_text[19], plain_text[11], plain_text[3],
        plain_text[61], plain_text[53], plain_text[45], plain_text[37],
        plain_text[29], plain_text[21], plain_text[13], plain_text[5],
        plain_text[63], plain_text[55], plain_text[47], plain_text[39],
        plain_text[31], plain_text[23], plain_text[15], plain_text[7]
    };

    assign left  = out[1:32];
    assign right = out[33:64];

endmodule