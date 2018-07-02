module vga_controller(
clk, 
color_in, screenend, active, active_x, active_y,
hsync, vsync, red, green, blue
);

	input clk;
	input [23:0] color_in;

	output reg screenend = 0;
	output reg active = 0;
	output reg [9:0] active_x = 0;
	output reg [9:0] active_y = 0;
	output hsync;
	output vsync;
	output [7:0] red;
	output [7:0] green;
	output [7:0] blue;
	
	parameter H_VISIBLE = 1024;
	parameter H_FRONT = 24;
	parameter H_SYNC = 136;
	parameter H_BACK = 160;
	parameter H_LINE = 1344;

	parameter V_VISIBLE = 768;
	parameter V_FRONT = 3;
	parameter V_SYNC = 6;
	parameter V_BACK = 29;
	parameter V_FRAME = 806;

	parameter SHIFT_ACTIVE = 4;

	wire new_line;

	vga_hsync #(H_VISIBLE, H_FRONT, H_SYNC, H_BACK, H_LINE) 
		hs (clk, hsync, new_line);
	
	
	
endmodule

module vga_hsync (clk, hsync, new_line);
	parameter H_VISIBLE = 1024;
	parameter H_FRONT = 24;
	parameter H_SYNC = 136;
	parameter H_BACK = 160;
	parameter H_LINE = 1344;

	input clk;
	output reg hsync = 0;
	output reg new_line = 0;
	
	reg [10:0] count = 10'b0000000000;

	always @(posedge clk) begin
		if (count < (H_LINE - 1)) begin
			count <= count + 1;
		end else begin
			count <= 0;
		end
	end

	always @(posedge clk) begin
		if (count == H_LINE) begin
			new_line <= 1;
		end else begin
			new_line <= 0;
		end
	end

	always @(posedge clk) begin
		if (count < H_SYNC) begin
		  hsync <= 0;
		end else if (count >= H_SYNC) begin
		  hsync <= 1;
		end
	end
endmodule



