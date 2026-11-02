module F (
    input wire [1:32] right,
    input wire [1:48] roundKey,
    output wire [1:32] f_out
);
    wire [1:48] e_out, sbox_in;
    wire [1:32] sbox_out;

    E E_U0 (
        .right(right),
        .e_out(e_out)
    );

    assign sbox_in = e_out ^ roundKey;

    SBox SBox_U0 (
        .sbox_in(sbox_in),
        .sbox_out(sbox_out)
    );

    P P_U0 (
        .sbox_out(sbox_out),
        .p_out(f_out)
    );
    
endmodule