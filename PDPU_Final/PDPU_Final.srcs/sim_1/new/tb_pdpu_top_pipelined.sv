`timescale 1ns/1ps

module tb_pdpu_top_pipelined();

    // Parameter definitions
    parameter int unsigned N = 4;       // dot-product size
    parameter int unsigned n_i = 8;     // input word size
    parameter int unsigned es_i = 2;    // input exponent size
    parameter int unsigned n_o = 16;    // output word size
    parameter int unsigned es_o = 2;    // output exponent size
    parameter int unsigned ALIGN_WIDTH = 14; // alignment width

    // Clock and reset signals
    logic clk_i;

    // Test input and output signals
    logic [N-1:0][n_i-1:0] operands_a;
    logic [N-1:0][n_i-1:0] operands_b;
    logic [n_o-1:0] acc;
    logic [n_o-1:0] result_o;

    // Clock generation
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i; // 10ns clock period
    end

    // DUT instantiation
    pdpu_top_pipelined #(
        .N(N),
        .n_i(n_i),
        .es_i(es_i),
        .n_o(n_o),
        .es_o(es_o),
        .ALIGN_WIDTH(ALIGN_WIDTH)
    ) dut (
        .clk_i(clk_i),
        .operands_a(operands_a),
        .operands_b(operands_b),
        .acc(acc),
        .result_o(result_o)
    );

    // Testbench procedure
    initial begin
        // Initialize inputs
        /*operands_a = '{8'hA5, 8'h5A, 8'hFF, 8'h01};  // Example operands for vector A
        operands_b = '{8'h3C, 8'h12, 8'hAB, 8'h7F};  // Example operands for vector B
        acc = 16'h0000;  // Example accumulator value

        // Wait for a few clock cycles to simulate the pipeline
        #100;

        // Check the output (for this example, expected results need to be calculated based on input)
        $display("Result_o: %h", result_o);*/

        // Add more test cases as necessary with different inputs
        operands_a = '{8'h1A, 8'h5B, 8'hF1, 8'h00};  
        operands_b = '{8'h4C, 8'h22, 8'hBB, 8'h8F};  
        acc = 16'h0000;

        #100;

        $display("Result_o: %h", result_o);

        // End the simulation
        $finish;
    end

endmodule
