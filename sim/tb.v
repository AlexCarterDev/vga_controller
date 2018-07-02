`timescale 1ns/1ps
module tb;

`define CLK_PERIOD 10

reg clk = 0; 
reg [23:0] color = 0;

wire screenend;
wire active;
wire [9:0] active_x;
wire [9:0] active_y;

vga_controller #(20,1,2,3, 30,1,2,3, 4) 
vga (
	.clk65(clk),
	.color_in(color),
	.screenend(screenend),
	.active(active),
	.active_x(active_x),
	.active_y(active_y)
);

initial begin
	
end

always begin
	#(`CLK_PERIOD/2) clk = !clk;
end

endmodule
