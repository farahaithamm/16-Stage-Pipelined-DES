module E (
    input  wire [1:32] right,
    output wire [1:48] e_out
);

    assign e_out = {
        right[32], right[1],  right[2],  right[3],  right[4],  right[5],
        right[4],  right[5],  right[6],  right[7],  right[8],  right[9],
        right[8],  right[9],  right[10], right[11], right[12], right[13],
        right[12], right[13], right[14], right[15], right[16], right[17],
        right[16], right[17], right[18], right[19], right[20], right[21],
        right[20], right[21], right[22], right[23], right[24], right[25],
        right[24], right[25], right[26], right[27], right[28], right[29],
        right[28], right[29], right[30], right[31], right[32], right[1]
    };

endmodule