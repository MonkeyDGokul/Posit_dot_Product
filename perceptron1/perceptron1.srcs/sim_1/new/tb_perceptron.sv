
`timescale 1ns / 1ps
module tb_perceptron;

    parameter N = 8;
    parameter WIDTH = 16;
    
    logic signed [WIDTH-1:0] input_features [N-1:0];
    logic signed [WIDTH-1:0] weights [N-1:0];
    logic signed [WIDTH-1:0] bias;
    
    logic clk;
    logic rst;
    
    logic result;
    logic signed [WIDTH*2-1:0] weighted_sum_out;
    
    logic expected_result;
    int unsigned pass_count = 0;
    int unsigned total_tests = 50;
    
    perceptron #(N, WIDTH) dut (
        .input_features(input_features),
        .weights(weights),
        .bias(bias),
        .clk(clk),
        .rst(rst),
        .result(result),
        .weighted_sum_out(weighted_sum_out)
    );

    always #5 clk = ~clk;

    // ------------------------
    // Driver Class
    // ------------------------
    class Driver;
        task drive_inputs(
            input logic signed [WIDTH-1:0] input_features_in [N-1:0],
            input logic signed [WIDTH-1:0] weights_in [N-1:0],
            input logic signed [WIDTH-1:0] bias_in
        );
            int i;
            for (i = 0; i < N; i++) begin
                tb_perceptron.input_features[i] = input_features_in[i];
                tb_perceptron.weights[i] = weights_in[i];
            end
            tb_perceptron.bias = bias_in;
        endtask
    endclass
    
    // ------------------------
    // Monitor Class
    // ------------------------
    class Monitor;
        logic captured_result;
        logic signed [WIDTH*2-1:0] captured_weighted_sum;
        
        task capture();
            captured_result = tb_perceptron.result;
            captured_weighted_sum = tb_perceptron.weighted_sum_out;
        endtask
    endclass
    
    // ------------------------
    // Scoreboard Class
    // ------------------------
    class Scoreboard;
        task compare(
            input logic expected_result,
            input logic actual_result
        );
            if (expected_result === actual_result) begin
                tb_perceptron.pass_count++;
                $display("Test Passed");
            end else begin
                $display("Test Failed: Expected %0b, Got %0b", expected_result, actual_result);
                assert(expected_result == actual_result) else $error("Mismatch detected");
            end
        endtask
    endclass
    
    // ------------------------
    // Environment Class
    // ------------------------
    class Environment;
        Driver driver;
        Monitor monitor;
        Scoreboard scoreboard;
        
        function new();
            driver = new;
            monitor = new;
            scoreboard = new;
        endfunction
        
        task run_test(
            input logic signed [WIDTH-1:0] test_input_features [N-1:0],
            input logic signed [WIDTH-1:0] test_weights [N-1:0],
            input logic signed [WIDTH-1:0] test_bias,
            input logic expected_result
        );
            driver.drive_inputs(test_input_features, test_weights, test_bias);
            #85;
            monitor.capture();
            scoreboard.compare(expected_result, monitor.captured_result);
        endtask
    endclass
    
    // ------------------------
    // Coverage Collection
    // ------------------------
    covergroup feature_cov;
        coverpoint input_features[0] {
            bins low = {[-32768:-1]};
            bins high = {[0:32767]};
        }
        coverpoint weights[0] {
            bins low = {[-32768:-1]};
            bins high = {[0:32767]};
        }
        coverpoint bias {
            bins low = {[-32768:-1]};
            bins high = {[0:32767]};
        }
        coverpoint result {
            bins result_0 = {0};
            bins result_1 = {1};
        }
    endgroup

    feature_cov fc = new();

    // ------------------------
    // Random Input Generation
    // ------------------------
    
    /*task generate_random_test_values(
        output logic signed [WIDTH-1:0] test_input_features [N-1:0],
        output logic signed [WIDTH-1:0] test_weights [N-1:0],
        output logic signed [WIDTH-1:0] test_bias
    );
        int i;
        for (i = 0; i < N; i++) begin
            test_input_features[i] = $urandom_range(-32768, 32767);
            test_weights[i] = $urandom_range(-32768, 32767);
        end
        test_bias = $urandom_range(-32768, 32767);
    endtask*/

    function logic compute_perceptron_result(
        input logic signed [WIDTH-1:0] local_input_features [N-1:0],
        input logic signed [WIDTH-1:0] local_weights [N-1:0],
        input logic signed [WIDTH-1:0] local_bias
    );
        logic signed [WIDTH*2-1:0] weighted_sum;
        logic signed [WIDTH*2-1:0] product [N-1:0];
        int i;
        weighted_sum = local_bias;

        for (i = 0; i < N; i++) begin
            product[i] = local_input_features[i] * local_weights[i];
            weighted_sum += product[i];
        end

        if (weighted_sum > 0) begin
            return 1;
        end else begin
            return 0;
        end
    endfunction

    Environment env;

    logic signed [WIDTH-1:0] test_input_features [N-1:0];
    logic signed [WIDTH-1:0] test_weights [N-1:0];
    logic signed [WIDTH-1:0] test_bias;

    int i;

    // ------------------------
    // Assertions
    // ------------------------
    always_ff @(posedge clk) begin
        if (rst) begin
            assert(result == 0) else $error("Reset failed: result should be 0 during reset");
            assert(weighted_sum_out == 0) else $error("Reset failed: weighted_sum_out should be 0 during reset");
        end else begin
            assert(weighted_sum_out <= $signed({WIDTH*2{1'b1}})) else $error("Weighted sum overflow detected");

            if (weighted_sum_out > 0) begin
                assert(result == 1) else $error("Incorrect result: result should be 1 when weighted_sum_out > 0");
            end else begin
                assert(result == 0) else $error("Incorrect result: result should be 0 when weighted_sum_out <= 0");
            end
        end
    end

    initial begin
        env = new;
        
        clk = 0;
        rst = 1;
        #10 rst = 0;

        for (i = 0; i < total_tests; i++) begin
            generate_random_test_values(test_input_features, test_weights, test_bias);
            expected_result = compute_perceptron_result(test_input_features, test_weights, test_bias);
            env.run_test(test_input_features, test_weights, test_bias, expected_result);

            $display("Test Case %0d:", i+1);
            $display("Input Features: %p", test_input_features);
            $display("Weights: %p", test_weights);
            $display("Bias: %d", test_bias);
            $display("Weighted Sum: %d", weighted_sum_out);
            $display("Perceptron classification result: %b", result);
            $display("Expected result: %b", expected_result);
            $display("");

            fc.sample();
        end

        $display("Tests passed: %0d/%0d", pass_count, total_tests);
        $display("Pass percentage: %0.2f%%", (pass_count * 100.0) / total_tests);

        $display("Coverage: %0.2f%%", fc.get_coverage());

        $finish;
    end

endmodule

