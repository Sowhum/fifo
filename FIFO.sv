`timescale 1ns / 1ps

module FIFO #(
    parameter DEPTH = 32,
    parameter WIDTH = 8,
    parameter AF_LEVEL = 28,
    parameter AE_LEVEL = 4
)(
    input logic clk,
    input logic reset,
    input logic write_en,
    input logic read_en,
    input logic [WIDTH-1:0] write_data,
    output logic [WIDTH-1:0] read_data,
    output logic full,
    output logic almost_full,
    output logic empty,
    output logic almost_empty
);
    logic [$clog2(DEPTH)-1:0] write_ptr = 0;
    logic [$clog2(DEPTH)-1:0] read_ptr = 0;
    logic [$clog2(DEPTH):0] fifo_count = 0; 

    bram #(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH),
        .ADDR_WIDTH($clog2(DEPTH))
    ) BRAM (
        .clock(clk),
        .w_en(write_en),
        .r_en(read_en),
        .write_data(write_data),
        .write_addr(write_ptr),
        .read_addr(read_ptr),
        .read_data(read_data)
    );

    always @(posedge clk) begin
        if(reset) begin
            write_ptr<=0;
            read_ptr<=0;
            fifo_count<=0;
        end
        else begin
            if(write_en && !read_en) begin
                fifo_count<=fifo_count+1;
            end
            else if(!write_en && read_en) begin
                fifo_count<=fifo_count-1;
            end    
        end     
    end

    always @(posedge clk) begin
        if (write_en && !full) begin
            if (write_ptr == DEPTH-1) begin
                write_ptr <= 0;
            end else begin
                write_ptr <= write_ptr + 1;
            end
        end
    end

    always @(posedge clk) begin
        if (read_en && !empty) begin
            if (read_ptr == DEPTH-1) begin
                read_ptr <= 0;
            end else begin
                read_ptr <= read_ptr + 1;
            end
        end
    end
    
    always @(posedge clk) begin
        if (write_en && full) begin
            $fatal("FIFO IS FULL AND BEING WRITTEN");
        end
         if (read_en && empty) begin
            $fatal("FIFO IS EMPTY AND BEING READ");
         end
    end
     assign full = (fifo_count == DEPTH);
     assign empty = (fifo_count == 0);
     
     assign almost_full = fifo_count>AF_LEVEL?1:0;
     assign almost_empty = fifo_count<AE_LEVEL?1:0;
endmodule
