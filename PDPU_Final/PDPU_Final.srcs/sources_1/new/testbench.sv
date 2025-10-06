/*`include "pdpu_transaction.sv"
`include "pdpu_driver.sv"
`include "pdpu_monitor.sv"
`inlcude "pdpu_scoreboard.sv"
`inlcude "pdpu_agent.sv"
`include "pdpu_env.sv"
`inlcude "pdpu_test.sv"*/
// Transaction class

`include "pdpu_tb.sv"
`include "interface.sv"

class pdpu_transaction;
  bit [3:0][7:0] operands_a;
  bit [3:0][7:0] operands_b;
  bit [15:0] acc;
  bit [15:0] result;

  function void print(string name = "");
    $display("Transaction %s:", name);
    $display("  operands_a = %h", operands_a);
    $display("  operands_b = %h", operands_b);
    $display("  acc = %h", acc);
    $display("  result = %h", result);
  endfunction
endclass

//driver
class pdpu_driver;
  virtual pdpu_if vif;

  function new(virtual pdpu_if vif);
    this.vif = vif;
  endfunction

  task drive(pdpu_transaction trans);
    @(posedge vif.clk);
    vif.operands_a <= trans.operands_a;
    vif.operands_b <= trans.operands_b;
    vif.acc <= trans.acc;
  endtask
endclass


// Monitor
class pdpu_monitor;
  virtual pdpu_if vif;
  mailbox #(pdpu_transaction) mb;

  function new(virtual pdpu_if vif, mailbox #(pdpu_transaction) mb);
    this.vif = vif;
    this.mb = mb;
  endfunction

  task run();
    forever begin
      pdpu_transaction trans = new();
      @(posedge vif.clk);
      trans.operands_a = vif.operands_a;
      trans.operands_b = vif.operands_b;
      trans.acc = vif.acc;
      repeat(6) @(posedge vif.clk); // Wait for 6 clock cycles (pipeline stages)
      trans.result = vif.result_o;
      mb.put(trans);
    end
  endtask
endclass


// Scoreboard
class pdpu_scoreboard;
  mailbox #(pdpu_transaction) mb;

  function new(mailbox #(pdpu_transaction) mb);
    this.mb = mb;
  endfunction

  task run();
    bit [31:0] expected_result = 0;
    pdpu_transaction trans;
    forever begin
      mb.get(trans);
      // Simple check: Sum of products
     //bit [31:0] expected_result;
      for (int i = 0; i < 4; i++) begin
        expected_result += trans.operands_a[i] * trans.operands_b[i];
      end
      expected_result += trans.acc;
      
      if (trans.result == expected_result[15:0])
        $display("PASS: Expected %h, Got %h", expected_result[15:0], trans.result);
      else
        $display("FAIL: Expected %h, Got %h", expected_result[15:0], trans.result);
      
      trans.print();
    end
  endtask
endclass


// Agent
class pdpu_agent;
  pdpu_driver drv;
  pdpu_monitor mon;
  mailbox #(pdpu_transaction) mb;
  virtual pdpu_if vif;

  function new(virtual pdpu_if vif);
    this.vif = vif;
    mb = new();
    drv = new(vif);
    mon = new(vif, mb);
  endfunction

  task run();
    fork
      mon.run();
    join_none
  endtask
endclass

// Environment
class pdpu_env;
  pdpu_agent agent;
  pdpu_scoreboard scb;
  mailbox #(pdpu_transaction) mb;
  virtual pdpu_if vif;

  function new(virtual pdpu_if vif);
    this.vif = vif;
    agent = new(vif);
    mb = agent.mb;
    scb = new(mb);
  endfunction

  task run();
    fork
      agent.run();
      scb.run();
    join_none
  endtask
endclass


// Test
/*class pdpu_test;
  pdpu_env env;
  mailbox #(pdpu_transaction) mb;
  virtual pdpu_if vif;

  function new(virtual pdpu_if vif);
    this.vif = vif;
    env = new(vif);
    mb = env.mb;
  endfunction

  task run();
    pdpu_transaction trans;
    env.run();

    // Test case 1: All ones
    trans = new();
    trans.operands_a = '{8'hFF, 8'hFF, 8'hFF, 8'hFF};
    trans.operands_b = '{8'h01, 8'h01, 8'h01, 8'h01};
    trans.acc = 16'h0000;
    env.agent.drv.drive(trans);
    #100;

    // Test case 2: Mixed values
    trans = new();
    trans.operands_a = '{8'h10, 8'h20, 8'h30, 8'h40};
    trans.operands_b = '{8'h02, 8'h03, 8'h04, 8'h05};
    trans.acc = 16'h0100;
    env.agent.drv.drive(trans);
    #100;

    // Test case 3: Zero and max values
    trans = new();
    trans.operands_a = '{8'h00, 8'hFF, 8'h80, 8'h7F};
    trans.operands_b = '{8'hFF, 8'h00, 8'h7F, 8'h80};
    trans.acc = 16'hFFFF;
    env.agent.drv.drive(trans);
    #100;

    // Test case 4: Accumulator overflow
    trans = new();
    trans.operands_a = '{8'hFF, 8'hFF, 8'hFF, 8'hFF};
    trans.operands_b = '{8'hFF, 8'hFF, 8'hFF, 8'hFF};
    trans.acc = 16'hFFFF;
    env.agent.drv.drive(trans);
    #100;

    // Test case 5: All zeros
    trans = new();
    trans.operands_a = '{8'h00, 8'h00, 8'h00, 8'h00};
    trans.operands_b = '{8'h00, 8'h00, 8'h00, 8'h00};
    trans.acc = 16'h0000;
    env.agent.drv.drive(trans);
    #100;

    $finish;
  endtask
endclass */







