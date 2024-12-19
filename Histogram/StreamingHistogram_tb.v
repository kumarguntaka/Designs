// This is a basic testbench for StreamingHistogram assignment.

`timescale 1ps / 1ps

module StreamingHistogramTB
#(
    // log2 of the number of data words in a single streaming cycle
    parameter log2_words    = 3,
    // width of each data word in bits
    parameter word_width    = 12,
    // width of the data word frequency counter in bits
    parameter count_width   = 48,

    // derived data width
    // word 0 is contained in bits [word_width - 1 : 0]
    // word 1 is contained in bits [2 * word_width - 1 : word_width]
    // ...
    // word K is contained in bits [(K + 1) * word_width - 1 : K * word_width],
    //  0 <= K < 2 ** log2_words
    parameter data_width    = word_width * 2 ** log2_words)
();

    // only for gatesim
    // glbl glbl ();

    // -------------------------
    // device under test signals

    // rising edge 100 MHz clock
    reg                     clk;
    // synchronous active-high reset
    reg                     rst;

    // streaming interface
    reg                     stream_valid;
    reg  [data_width-1:0]   stream_data;

    // counter querying interface
    reg                     query_valid;
    reg  [word_width-1:0]   query_word;
    wire [count_width-1:0]  query_count;

    // --------------------------
    // device under test instance

    StreamingHistogram
`ifndef GATESIM
    #(  .log2_words     (log2_words),
        .word_width     (word_width),
        .count_width    (count_width))
`endif
    dut (
        .clk            (clk),
        .rst            (rst),

        .stream_valid   (stream_valid),
        .stream_data    (stream_data),

        .query_valid    (query_valid),
        .query_word     (query_word),
        .query_count    (query_count));

    // ------------------------------------------------------------
    // internal 2-dim array of stream words for driving stream_data

    reg  [word_width-1:0]   stream_word [2 ** log2_words - 1 : 0];
    genvar g;
    generate
        for (g = 0; g < 2 ** log2_words; g=g+1) begin: gen_pack
            always @* stream_data[(g+1)*word_width-1 : g*word_width] = stream_word[g];
        end
    endgenerate

    // ----------------
    // clock generation

    always begin
        clk = 1'b0;
        #5000;
        clk = 1'b1;
        #5000;
    end

    // ----------------
    // reset generation

    initial begin : init
        //logic [32*8-1:0] vcdfile;
        string vcdfile;
        int vcdlevel;

        rst = 1'b1;
        /* if ($value$plusargs("VCDFILE=%s",vcdfile))
            $dumpfile(vcdfile);
        if ($value$plusargs("VCDLEVEL=%d",vcdlevel))
            $dumpvars(vcdlevel); */
            $dumpfile("test.vcd");
            $dumpvars(9, dut);
        @(posedge clk);
        $display("%t: asserted reset", $time);
        repeat (10) @(posedge clk);
        rst <= 1'b0;
        $display("%t: negated reset", $time);
    end

    // -------------------------
    // stream and query stimulus

    initial begin : stim
        integer i;
        reg  [word_width-1:0] rw [2 ** log2_words];
        for (i = 0; i < 2 ** log2_words; i=i+1) begin
            rw[i] = {$random} % 2 ** word_width;
        end

        stream_valid <= 1'b0;
        for (i = 0; i < 2 ** log2_words; i=i+1)
            stream_word[i] <= {$random} % 2 ** word_width;
        query_valid  <= 1'b0;
        query_word   <= {$random} % 2 ** word_width;

        @(negedge rst);
        repeat ((1 << word_width) + 20) @(posedge clk);
        $display("%t: starting stream stimulus", $time);

        repeat (100) begin : repeated_stream_data
            integer i;
            @(posedge clk);
            stream_valid <= {$random} % 100 < 95;
            for (i = 0; i < 2 ** log2_words; i=i+1)
                stream_word[i] <= rw[{$random} % 2 ** log2_words];
        end

        repeat (1000) begin : rand_stream_data
            integer i;
            @(posedge clk);
            stream_valid <= {$random} % 100 < 95;
            for (i = 0; i < 2 ** log2_words; i=i+1)
                stream_word[i] <= {$random} % 2 ** word_width;
        end

        stream_valid <= 1'b0;
        for (i = 0; i < 2 ** log2_words; i=i+1)
            stream_word[i] <= {$random} % 2 ** word_width;
        $display("%t: completed stream stimulus", $time);

        repeat (10) @(posedge clk);
        $display("%t: starting query stimulus", $time);

        repeat (2 << word_width) begin
            @(posedge clk);
            query_valid  <= {$random} % 100 < 95;
            query_word   <= {$random} % 2 ** word_width;
        end

        query_valid  <= 1'b0;
        query_word   <= {$random} % 2 ** word_width;
        $display("%t: completed query stimulus", $time);

        repeat (10) @(posedge clk);
        $display("%t: TEST PASSED", $time);
        $finish;
    end

    // -----
    // model

    reg [count_width-1:0] counters [0 : 2 ** word_width - 1];
    initial begin : init_counters
        integer i;
        for (i = 0; i < 2 ** word_width; i=i+1) begin
            counters[i] = {count_width{1'b0}};
        end
    end

    always @(negedge clk) begin : model
        reg [word_width-1:0] word;
        if (stream_valid) begin : model_counters
            integer i;
            for (i = 0; i < 2 ** log2_words; i=i+1) begin
                word = stream_data >> (i * word_width);
                counters[word] = counters[word] + 1;
                //$display("%t: stream word[%0d] = %x, count = %d",
                    //$time, i, word, counters[word]);
            end
        end
    end

    // -------
    // checker

    reg                     query_valid_p1;
    reg                     query_valid_p2;
    reg                     query_valid_p3;

    reg  [word_width-1:0]   query_word_p1;
    reg  [word_width-1:0]   query_word_p2;
    reg  [word_width-1:0]   query_word_p3;

    always @(posedge clk) begin
        query_valid_p1 <= query_valid;
        query_valid_p2 <= query_valid_p1;
        query_valid_p3 <= query_valid_p2;

        query_word_p1  <= query_word;
        query_word_p2  <= query_word_p1;
        query_word_p3  <= query_word_p2;
    end

    always @(negedge clk) begin
        if (query_valid_p3) begin
            if (query_count == counters[query_word_p3]) begin
                $display("%t: query count [%x] = %d (ok)", $time, query_word_p3, query_count);
            end
            else begin
                $fatal(1, "%t: query count [%x] = %d, expected %d (error)", $time, query_word_p3, query_count, counters[query_word_p3]);
            end
        end
    end

endmodule
