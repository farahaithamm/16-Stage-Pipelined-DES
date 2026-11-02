module PC2 (
    input  wire [1:28] right, left,
    output wire [1:48] subkey
);

    wire [1:56] in;
    assign in = {left, right};

    assign subkey = {
        in[14], in[17], in[11], in[24], in[1],  in[5],
        in[3],  in[28], in[15], in[6],  in[21], in[10],
        in[23], in[19], in[12], in[4],  in[26], in[8],
        in[16], in[7],  in[27], in[20], in[13], in[2],
        in[41], in[52], in[31], in[37], in[47], in[55],
        in[30], in[40], in[51], in[45], in[33], in[48],
        in[44], in[49], in[39], in[56], in[34], in[53],
        in[46], in[42], in[50], in[36], in[29], in[32]
    };

endmodule