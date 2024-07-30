`timescale 1ns / 1ps

module bram #(
    parameter DEPTH = 32,
    parameter WIDTH = 8,
    parameter ADDR_WIDTH = 5
)(
    input logic clock,
    input logic w_en,
    input logic r_en,
    input logic [WIDTH-1:0] write_data,
    input logic [ADDR_WIDTH-1:0] write_addr,
    input logic [ADDR_WIDTH-1:0] read_addr,
    output logic [WIDTH-1:0] read_data
);
    (* ram_style ="block" *)
    logic [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge clock) begin
        if (w_en) begin
            mem[write_addr] <= write_data;
        end 
    end

    always @(posedge clock) begin
        if(r_en)begin
            if (write_addr == read_addr && w_en) begin
                read_data <= write_data;
            end else begin
                read_data <= mem[read_addr];
            end
        end
    end
endmodule
