module S1 (
    input  wire [1:6] sbox_in,
    output reg  [1:4] sbox_out
);

    wire [1:6] sel;
    assign sel = {sbox_in[1], sbox_in[6], sbox_in[2:5]};

    always @(*) begin
        case (sel)
            // Row 0
            6'b00_0000: sbox_out = 4'd14; 6'b00_0001: sbox_out = 4'd4;  6'b00_0010: sbox_out = 4'd13; 6'b00_0011: sbox_out = 4'd1;
            6'b00_0100: sbox_out = 4'd2;  6'b00_0101: sbox_out = 4'd15; 6'b00_0110: sbox_out = 4'd11; 6'b00_0111: sbox_out = 4'd8;
            6'b00_1000: sbox_out = 4'd3;  6'b00_1001: sbox_out = 4'd10; 6'b00_1010: sbox_out = 4'd6;  6'b00_1011: sbox_out = 4'd12;
            6'b00_1100: sbox_out = 4'd5;  6'b00_1101: sbox_out = 4'd9;  6'b00_1110: sbox_out = 4'd0;  6'b00_1111: sbox_out = 4'd7;
            // Row 1
            6'b01_0000: sbox_out = 4'd0;  6'b01_0001: sbox_out = 4'd15; 6'b01_0010: sbox_out = 4'd7;  6'b01_0011: sbox_out = 4'd4;
            6'b01_0100: sbox_out = 4'd14; 6'b01_0101: sbox_out = 4'd2;  6'b01_0110: sbox_out = 4'd13; 6'b01_0111: sbox_out = 4'd1;
            6'b01_1000: sbox_out = 4'd10; 6'b01_1001: sbox_out = 4'd6;  6'b01_1010: sbox_out = 4'd12; 6'b01_1011: sbox_out = 4'd11;
            6'b01_1100: sbox_out = 4'd9;  6'b01_1101: sbox_out = 4'd5;  6'b01_1110: sbox_out = 4'd3;  6'b01_1111: sbox_out = 4'd8;
            // Row 2
            6'b10_0000: sbox_out = 4'd4;  6'b10_0001: sbox_out = 4'd1;  6'b10_0010: sbox_out = 4'd14; 6'b10_0011: sbox_out = 4'd8;
            6'b10_0100: sbox_out = 4'd13; 6'b10_0101: sbox_out = 4'd6;  6'b10_0110: sbox_out = 4'd2;  6'b10_0111: sbox_out = 4'd11;
            6'b10_1000: sbox_out = 4'd15; 6'b10_1001: sbox_out = 4'd12; 6'b10_1010: sbox_out = 4'd9;  6'b10_1011: sbox_out = 4'd7;
            6'b10_1100: sbox_out = 4'd3;  6'b10_1101: sbox_out = 4'd10; 6'b10_1110: sbox_out = 4'd5;  6'b10_1111: sbox_out = 4'd0;
            // Row 3
            6'b11_0000: sbox_out = 4'd15; 6'b11_0001: sbox_out = 4'd12; 6'b11_0010: sbox_out = 4'd8;  6'b11_0011: sbox_out = 4'd2;
            6'b11_0100: sbox_out = 4'd4;  6'b11_0101: sbox_out = 4'd9;  6'b11_0110: sbox_out = 4'd1;  6'b11_0111: sbox_out = 4'd7;
            6'b11_1000: sbox_out = 4'd5;  6'b11_1001: sbox_out = 4'd11; 6'b11_1010: sbox_out = 4'd3;  6'b11_1011: sbox_out = 4'd14;
            6'b11_1100: sbox_out = 4'd10; 6'b11_1101: sbox_out = 4'd0;  6'b11_1110: sbox_out = 4'd6;  6'b11_1111: sbox_out = 4'd13;
        endcase
    end

endmodule