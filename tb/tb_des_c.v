//=============================================================================
// tb_des_c.v
// Same stimulus / pipeline checker as DES_tb.v. Expected values come from
// the C model (des.c) via DPI — not $system — so the sim can $finish.
//=============================================================================

module tb_des;

    import "DPI-C" function longint unsigned des_ref_c(
        input longint unsigned data,
        input longint unsigned key,
        input int enc
    );

    reg clk, rst_n, start;
    reg [1:64] in, key;
    reg encrypt;
    wire [1:64] out;
    wire done;

    reg [1:64] exp_in;          // reference result of the operation being sent
    integer errors, checked, seed, max_gap, i;

    DES DUT (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .in(in),
        .key(key),
        .encrypt(encrypt),
        .out(out),
        .done(done)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    // ======================= reference model (C: des.c) =======================
    function [1:64] des_ref;
        input [1:64] d;
        input [1:64] k;
        input enc;
        begin
            des_ref = des_ref_c(d, k, enc);
        end
    endfunction

    // ======================= checker =======================
    // 16-stage pipe of expected results, moves together with the DES pipeline
    reg [1:64] pipe_exp [0:15];
    reg pipe_v [0:15];

    always @(posedge clk or negedge rst_n) begin : shift
        integer j;
        if (!rst_n)
            for (j = 0; j < 16; j = j + 1) pipe_v[j] <= 0;
        else begin
            pipe_exp[0] <= exp_in;
            pipe_v[0] <= start;
            for (j = 1; j < 16; j = j + 1) begin
                pipe_exp[j] <= pipe_exp[j-1];
                pipe_v[j] <= pipe_v[j-1];
            end
        end
    end

    // op in the last stage -> done must be 1 and out must match; otherwise done must be 0
    always @(negedge clk) begin
        if (rst_n) begin
            if (done !== pipe_v[15]) begin
                $display("[FAIL] @%0t done=%b expected=%b", $time, done, pipe_v[15]);
                errors = errors + 1;
            end
            else if (pipe_v[15]) begin
                checked = checked + 1;
                if (out !== pipe_exp[15]) begin
                    $display("[FAIL] @%0t out=%h expected=%h", $time, out, pipe_exp[15]);
                    errors = errors + 1;
                end
            end
        end
    end

    // ======================= stimulus =======================
    task gap;
        input [31:0] n;
        begin
            start = 0;
            repeat (n) begin
                in = {$random(seed), $random(seed)};
                key = {$random(seed), $random(seed)};
                encrypt = $random(seed);
                @(negedge clk);
            end
        end
    endtask

    task send;
        input [1:64] s_in, s_key;
        input s_enc;
        begin
            in = s_in;  key = s_key;  encrypt = s_enc;
            exp_in = des_ref(s_in, s_key, s_enc);
            start = 1;
            @(negedge clk);
            gap({$random(seed)} % (max_gap + 1));
        end
    endtask

    reg [1:64] sp [0:7];
    reg [1:64] wk [0:5];
    integer a, b;

    task directed;
        begin
            for (a = 0; a < 8; a = a + 1)
                for (b = 0; b < 8; b = b + 1) begin
                    send(sp[a], sp[b], 1);
                    send(sp[a], sp[b], 0);
                end
            for (a = 0; a < 64; a = a + 1)
                send(64'h8000000000000000 >> a, 64'h133457799BBCDFF1, 1);
            for (a = 0; a < 64; a = a + 1) begin
                send(64'h0123456789ABCDEF, 64'h8000000000000000 >> a, 1);
                send(64'h0123456789ABCDEF, 64'h8000000000000000 >> a, 0);
            end
            for (a = 0; a < 6; a = a + 1) begin
                send(64'h0123456789ABCDEF, wk[a], 1);
                send(64'h0123456789ABCDEF, wk[a], 0);
            end
        end
    endtask

    task random_ops;
        input [31:0] count;
        integer c;
        begin
            for (c = 0; c < count; c = c + 1)
                send({$random(seed), $random(seed)}, {$random(seed), $random(seed)}, $random(seed));
        end
    endtask

    initial begin
        sp[0] = 64'h0000000000000000;  sp[1] = 64'hFFFFFFFFFFFFFFFF;
        sp[2] = 64'h0123456789ABCDEF;  sp[3] = 64'h8000000000000000;
        sp[4] = 64'h0000000000000001;  sp[5] = 64'hAAAAAAAAAAAAAAAA;
        sp[6] = 64'h5555555555555555;  sp[7] = 64'hFEDCBA9876543210;
        wk[0] = 64'h0101010101010101;  wk[1] = 64'hFEFEFEFEFEFEFEFE;
        wk[2] = 64'h1F1F1F1F0E0E0E0E;  wk[3] = 64'hE0E0E0E0F1F1F1F1;
        wk[4] = 64'h01FE01FE01FE01FE;  wk[5] = 64'hFE01FE01FE01FE01;

        errors = 0;  checked = 0;  seed = 1234;  max_gap = 0;
        rst_n = 0; start = 0; in = 0; key = 0; encrypt = 1; exp_in = 0;
        repeat (3) @(negedge clk);
        rst_n = 1;

        max_gap = 0;   directed;          gap(20);
        max_gap = 0;   random_ops(500);   gap(20);
        max_gap = 5;   random_ops(500);   gap(20);

        max_gap = 0;
        for (i = 0; i <= 18; i = i + 1) begin
            send(64'h0123456789ABCDEF, 64'h133457799BBCDFF1, 1);
            gap(i);
            send(64'h3FA40E8A984D4815, 64'h0123456789ABCDEF, 0);
            gap(20);
        end

        repeat (4) send(64'h0123456789ABCDEF, 64'h133457799BBCDFF1, 1);
        gap(4);
        #2 rst_n = 0;  #1;
        if (done === 1'b0 && out === 64'h0) $display("[PASS] async reset clears done/out");
        else begin $display("[FAIL] async reset: done=%b out=%h", done, out); errors = errors + 1; end
        @(negedge clk);
        rst_n = 1;
        gap(20);
        random_ops(20);  gap(20);

        $display("--------------------------------");
        if (errors == 0) $display("ALL TESTS PASSED (%0d results checked vs C)", checked);
        else             $display("%0d ERROR(S)", errors);
        $display("--------------------------------");
        $finish;
    end

endmodule
