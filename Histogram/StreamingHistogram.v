// This module counts occurrences of word values
// over valid words carried by the streaming interface,
// and presents the counts on the querying interface.

module StreamingHistogram
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
    parameter data_width    = word_width * 2 ** log2_words
)
(
    // rising edge 200 MHz clock
    input  wire                     clk,
    // synchronous active-high reset
    input  wire                     rst,

    // streaming interface
    input  wire                     stream_valid,
    input  wire [data_width-1:0]    stream_data,

    // counter querying interface
    input  wire                     query_valid,
    input  wire [word_width-1:0]    query_word,
    output wire [count_width-1:0]   query_count
);

    localparam num_words = (1 << log2_words);

    // Frequency counter array
    reg [count_width-1:0] counts [0:(1 << word_width)-1];

    // Query pipeline registers
    reg [word_width-1:0] qword_pipeline [2:0];
    reg qvalid_pipeline [2:0];
    integer m, i, j, k;

    // Assign the queried count output
    assign query_count = (qvalid_pipeline[2]) ? counts[qword_pipeline[2]] : {count_width{1'b0}};

    // Sequential query pipeline
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            qword_pipeline[0] <= 0;
            qword_pipeline[1] <= 0;
            qword_pipeline[2] <= 0;
            qvalid_pipeline[0] <= 0;
            qvalid_pipeline[1] <= 0;
            qvalid_pipeline[2] <= 0;
        end else begin
            qword_pipeline[0] <= query_word;
            qword_pipeline[1] <= qword_pipeline[0];
            qword_pipeline[2] <= qword_pipeline[1];
            qvalid_pipeline[0] <= query_valid;
            qvalid_pipeline[1] <= qvalid_pipeline[0];
            qvalid_pipeline[2] <= qvalid_pipeline[1];
        end
    end

    // Temporary array for local tally
    reg [count_width-1:0] local_tally [0:(1 << word_width)-1];

    // Streaming data processing and count updates
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all counts to zero
            for (i = 0; i < (1 << word_width); i = i + 1) begin
                counts[i] <= 0;
            end
        end else if (stream_valid) begin
            // Reset local tally
            for (k = 0; k < (1 << word_width); k = k + 1) begin
                local_tally[k] = 0;
            end

            // Count occurrences in the current stream
            for (j = 0; j < num_words; j = j + 1) begin
                reg [word_width-1:0] current_word;
                current_word = stream_data[(j+1)*word_width-1 -: word_width]; // Extract word
                local_tally[current_word] = local_tally[current_word] + 1;   // Increment local tally
            end

            // Update global counts using local tally
            for (m = 0; m < (1 << word_width); m = m + 1) begin
                if (local_tally[m] != 0) begin
                    counts[m] <= counts[m] + local_tally[m];  // Update counts with tallies
                end
            end
        end
    end

endmodule
