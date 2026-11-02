module SBox (
    input wire [1:48] sbox_in,
    output wire [1:32] sbox_out
);

    S1 S1_U0 (
        .sbox_in  (sbox_in[1:6]),
        .sbox_out (sbox_out[1:4])
    );

    S2 S2_U0 (
        .sbox_in  (sbox_in[7:12]),
        .sbox_out (sbox_out[5:8])
    );

    S3 S3_U0 (
        .sbox_in  (sbox_in[13:18]),
        .sbox_out (sbox_out[9:12])
    );

    S4 S4_U0 (
        .sbox_in  (sbox_in[19:24]),
        .sbox_out (sbox_out[13:16])
    );

    S5 S5_U0 (
        .sbox_in  (sbox_in[25:30]),
        .sbox_out (sbox_out[17:20])
    );

    S6 S6_U0 (
        .sbox_in  (sbox_in[31:36]),
        .sbox_out (sbox_out[21:24])
    );

    S7 S7_U0 (
        .sbox_in  (sbox_in[37:42]),
        .sbox_out (sbox_out[25:28])
    );

    S8 S8_U0 (
        .sbox_in  (sbox_in[43:48]),
        .sbox_out (sbox_out[29:32])
    );

endmodule