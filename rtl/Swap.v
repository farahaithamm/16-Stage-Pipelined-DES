module Swap32 (
    input wire [1:32] left_in, right_in,
    output wire [1:32] left_out, right_out
);
    assign left_out = right_in;
    assign right_out = left_in;
endmodule