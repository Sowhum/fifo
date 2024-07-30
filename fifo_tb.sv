`timescale 1ns / 1ps

module FIFO_tb;

  parameter DEPTH = 32;
  parameter WIDTH = 8;
  parameter AF_LEVEL = 28;
  parameter AE_LEVEL = 4;

  logic clk;
  logic reset;
  logic write_en;
  logic read_en;
  logic [WIDTH-1:0] write_data;
  logic [WIDTH-1:0] read_data;
  logic full;
  logic almost_full;
  logic empty;
  logic almost_empty;

  // Instantiate the FIFO
  FIFO #(
    .DEPTH(DEPTH),
    .WIDTH(WIDTH),
    .AF_LEVEL(AF_LEVEL),
    .AE_LEVEL(AE_LEVEL)
  ) 
  fifo (
    .clk(clk),
    .reset(reset),
    .write_en(write_en),
    .read_en(read_en),
    .write_data(write_data),
    .read_data(read_data),
    .full(full),
    .almost_full(almost_full),
    .empty(empty),
    .almost_empty(almost_empty)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100 MHz clock
  end

  // Monitor signals
  initial begin
    $monitor("time: %0t, E: 0x%0h, F: 0x%0h, AE: 0x%0h, AF: 0x%0h, RD: 0x%0h, WD: 0x%0h",
             $time, empty, full, almost_empty, almost_full, read_data, write_data);
  end

  // Test stimulus
  initial begin
    reset = 1;
    read_en=0;
    write_en=0;
    write_data = 8'd0;
    #12 reset = 0;

    // Fill FIFO
    repeat (5) begin
      @(posedge clk);
      write_en = 1;
      write_data = write_data + 1;
    end
    @(posedge clk);
    write_en = 0;

    // Empty FIFO
    repeat (5) begin
      @(posedge clk);
      read_en = 1;
    end
    @(posedge clk);
    read_en = 0;

//    // Underflow 
//    reset = 1;
//    #12 reset = 0;
//    repeat (5) begin
//      @(posedge clk);
//      read_en = 1;
//    end
//    @(posedge clk);
//    read_en = 0;

    // Overflow 
    reset = 1;
    #12 reset = 0;
    write_data = 8'h10;
    repeat (DEPTH+1) begin
      @(posedge clk);
      write_en = 1;
      write_data = write_data + 1;
    end
    @(posedge clk);
    write_en = 0;

    #10 $finish;
  end
endmodule
