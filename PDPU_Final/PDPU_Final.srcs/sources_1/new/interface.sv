// Interface definition
interface pdpu_if(input logic clk, input logic rst_n);
  //logic clk;
  //logic rst_n;  // Added reset signal
  logic [3:0][7:0] operands_a;
  logic [3:0][7:0] operands_b;
  logic [15:0] acc;
  logic [15:0] result_o;

 /* clocking cb_drv @(posedge clk);
    default input #1step output #1step; // Using #1step for more precise timing
    input result_o;
    output operands_a, operands_b, acc;
  endclocking 
 
  modport pdpu_top_pipelined (
    input clk,
    input rst_n,
    input operands_a,
    input operands_b,
    input acc,
    output result_o
  );

  modport pdpu_tb (
    output clk,
    output rst_n,
    output operands_a,
    output operands_b,
    output acc,
    input result_o,
    clocking cb_drv
  ); */
endinterface: pdpu_if