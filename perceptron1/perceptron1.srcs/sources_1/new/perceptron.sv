`timescale 1ns / 1ps

module perceptron #(parameter N = 8, WIDTH = 16)(
    input logic signed [WIDTH-1:0] input_features [N-1:0],
    input logic signed [WIDTH-1:0] weights [N-1:0],
    input logic signed [WIDTH-1:0] bias,
    output logic result,
    output logic signed [WIDTH*2-1:0] weighted_sum_out,
    input logic clk,
    input logic rst
);

    logic signed [WIDTH*2-1:0] product [N-1:0];
    logic signed [WIDTH*2-1:0] partial_sums [N/2-1:0];
    logic signed [WIDTH*2-1:0] final_sum;
    logic signed [WIDTH*2-1:0] corrected_sum;
    logic signed [WIDTH-1:0] dynamic_bias;

    logic signed [WIDTH*2-1:0] product_pipeline [N-1:0];
    logic signed [WIDTH*2-1:0] partial_sum_pipeline [N/2-1:0];

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (int i = 0; i < N; i++) begin
                product_pipeline[i] <= 0;
            end
            for (int j = 0; j < N/2; j++) begin
                partial_sum_pipeline[j] <= 0;
            end
        end else begin
            for (int i = 0; i < N; i++) begin
                product_pipeline[i] <= input_features[i] * weights[i];
            end

            partial_sum_pipeline[0] <= product_pipeline[0] + product_pipeline[1];
            partial_sum_pipeline[1] <= product_pipeline[2] + product_pipeline[3];
            partial_sum_pipeline[2] <= product_pipeline[4] + product_pipeline[5];
            partial_sum_pipeline[3] <= product_pipeline[6] + product_pipeline[7];
        end
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            final_sum <= 0;
            dynamic_bias <= bias;
        end else begin
            final_sum <= partial_sum_pipeline[0] + partial_sum_pipeline[1] + 
                         partial_sum_pipeline[2] + partial_sum_pipeline[3] + dynamic_bias;
            
            if (final_sum > 10000) begin
                dynamic_bias <= bias + 10;
            end else begin
                dynamic_bias <= bias;
            end
        end
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            corrected_sum <= 0;
        end else begin
            corrected_sum <= (final_sum < 0) ? 0 : final_sum;
        end
    end

    assign weighted_sum_out = corrected_sum;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 0;
        end else begin
            result <= (corrected_sum > 0) ? 1'b1 : 1'b0;
        end
    end
endmodule
