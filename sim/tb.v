`timescale 1ns/1ps
module tb;

`define CLK_PERIOD 10

reg clk = 0; 
reg [23:0] color = 0;

wire screenend;
wire active;
wire [9:0] active_x;
wire [9:0] active_y;

wire hsync;
wire vsync;
wire [7:0] red;
wire [7:0] green;
wire [7:0] blue;


vga_controller #(20,3,4,5, 10,3,4,5, 2) 
vga (
	.clk(clk),
	.color_in(color),
	.screenend(screenend),
	.active(active),
	.active_x(active_x),
	.active_y(active_y),
	.hsync(hsync),
	.vsync(vsync),
	.red(red),
	.green(green),
	.blue(blue)
);

initial begin
	color = 24'hffffff;
end

always begin
	#(`CLK_PERIOD/2) clk = !clk;
end

endmodule
