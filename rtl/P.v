module P (
    input wire [1:32] sbox_out,
    output wire [1:32] p_out
);

    assign p_out = {
        sbox_out[16], sbox_out[7],  sbox_out[20], sbox_out[21],
        sbox_out[29], sbox_out[12], sbox_out[28], sbox_out[17],
        sbox_out[1],  sbox_out[15], sbox_out[23], sbox_out[26],
        sbox_out[5],  sbox_out[18], sbox_out[31], sbox_out[10],
        sbox_out[2],  sbox_out[8],  sbox_out[24], sbox_out[14],
        sbox_out[32], sbox_out[27], sbox_out[3],  sbox_out[9],
        sbox_out[19], sbox_out[13], sbox_out[30], sbox_out[6],
        sbox_out[22], sbox_out[11], sbox_out[4],  sbox_out[25]
    };

endmodule