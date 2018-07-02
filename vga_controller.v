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
	localparam H_LINE = H_VISIBLE + H_FRONT + H_SYNC + H_BACK;

	parameter V_VISIBLE = 768;
	parameter V_FRONT = 3;
	parameter V_SYNC = 6;
	parameter V_BACK = 29;
	localparam V_FRAME = V_VISIBLE + V_FRONT + V_SYNC + V_BACK;

	parameter SHIFT_ACTIVE = 4;

	wire new_line;

	vga_hsync #(H_VISIBLE, H_FRONT, H_SYNC, H_BACK, H_LINE) 
		hs (clk, hsync, new_line);
	
	vga_vsync #(V_VISIBLE, V_FRONT, V_SYNC, V_BACK, V_FRAME)
		vs (clk, vsync, new_line);
	
endmodule

module vga_hsync (clk, hsync, new_line);
	input clk;
	output reg hsync = 0;
	output reg new_line = 0;
	
	parameter H_VISIBLE = 1024;
	parameter H_FRONT = 24;
	parameter H_SYNC = 136;
	parameter H_BACK = 160;
	parameter H_LINE = 1344;
	
	reg [10:0] count = 0;

	always @(posedge clk) begin
		if (count < (H_LINE - 1)) begin
			count <= count + 1;
		end else begin
			count <= 0;
		end
	end

	always @(posedge clk) begin
		if (count == 0) begin
			new_line <= 1;
		end else begin
			new_line <= 0;
		end
	end

	always @(posedge clk) begin
		if (count < H_SYNC) begin
		  hsync <= 0;
		end else begin
		  hsync <= 1;
		end
	end
endmodule

module vga_vsync (clk, vsync, new_line);	
	input clk;
	input new_line;
	output reg vsync = 0;
	
	parameter V_VISIBLE = 1024;
	parameter V_FRONT = 24;
	parameter V_SYNC = 136;
	parameter V_BACK = 160;
	parameter V_FRAME = 1344;
	
	reg [10:0] count = 0;
	
	always @(posedge new_line) begin
		if (count < (V_FRAME - 1)) begin
			count <= count + 1;
		end else begin 
			count <= 0;
		end 
	end 

	always @(posedge new_line) begin
		if (count < V_SYNC) begin 
			vsync <= 0;
		end else begin 
			vsync <= 1;
		end
	end
	 
endmodule 

