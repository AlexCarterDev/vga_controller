module vga_controller(
clk, 
color_in, screenend, active, active_x, active_y,
hsync, vsync, red, green, blue
);

	input clk;
	input [23:0] color_in;

	output screenend;
	output active;
	output [9:0] active_x;
	output [9:0] active_y;
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

	parameter PRE_ACTIVE = 1; // min 1

	wire new_line;
	wire h_visible_pre;
	wire v_visible;

	vga_hsync #(H_VISIBLE, H_FRONT, H_SYNC, H_BACK, H_LINE, PRE_ACTIVE) 
		hs (clk, hsync, new_line, h_visible_pre);
	
	vga_vsync #(V_VISIBLE, V_FRONT, V_SYNC, V_BACK, V_FRAME)
		vs (clk, vsync, new_line, v_visible);

	vga_active #(H_VISIBLE, V_VISIBLE, PRE_ACTIVE)
		va (clk, vsync, h_visible_pre, v_visible, color_in,
			screenend, active, active_x, active_y, red, green, blue);
	
endmodule

module vga_hsync (clk, hsync, new_line, visible_pre);
	input clk;
	output reg hsync = 0;
	output reg new_line = 0;
	output reg visible_pre = 0;
	
	parameter H_VISIBLE = 1024;	// 20
	parameter H_FRONT = 24; // 3
	parameter H_SYNC = 136; // 4
	parameter H_BACK = 160; // 5
	parameter H_LINE = 1344;
	parameter VISIBLE_PRE_COUNT = 0;
	
	localparam VISIBLE_PRE_FROM = H_SYNC + H_BACK - VISIBLE_PRE_COUNT;
	localparam VISIBLE_PRE_TO = VISIBLE_PRE_FROM + H_VISIBLE;
	
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
	
	always @(posedge clk) begin
		if ((count >= VISIBLE_PRE_FROM) & (count < VISIBLE_PRE_TO)) begin
			visible_pre <= 1;
		end else begin
			visible_pre <= 0;
		end 
	end 
endmodule

module vga_vsync (clk, vsync, new_line, visible);	
	input clk;
	input new_line;
	output reg vsync = 0;
	output reg visible = 0;
	
	parameter V_VISIBLE = 1024;
	parameter V_FRONT = 24;
	parameter V_SYNC = 136;
	parameter V_BACK = 160;
	parameter V_FRAME = 1344;
	
	localparam VISIBLE_FROM = V_SYNC + V_BACK;
	localparam VISIBLE_TO = VISIBLE_FROM + V_VISIBLE;
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
	
	always @(posedge new_line) begin
		if ((count >= VISIBLE_FROM) & (count < VISIBLE_TO)) begin
			visible <= 1;
		end else begin
			visible <= 0;
		end 
	end 
endmodule 

module vga_active(
clk, 
vsync, h_visible, v_visible, color,
screenend, active, active_x, active_y, red, green, blue
);
	input clk;
	input vsync;
	input h_visible;
	input v_visible;
	input [23:0] color;
	
	output reg screenend = 0;
	output active;
	output [9:0] active_x;
	output [9:0] active_y;
	output reg [7:0] red = 0;
	output reg [7:0] green = 0;
	output reg [7:0] blue = 0;
	
	parameter WIDTH = 1024;
	parameter HEIGHT = 768;
	parameter COLOR_GAP = 0; 
	
	reg [9:0] x = 0;
	reg [9:0] y = 0;
	reg [9:0] active_fifo = 0;
	
	assign active = h_visible & v_visible;
	assign active_x = x;
	assign active_y = y;
	
	reg [1:0] sh_vsync = 0;
	always @(posedge clk) begin
		sh_vsync <= {sh_vsync[0], vsync};
		screenend <= sh_vsync == 2'b10;
	end
	
	always @(posedge clk) begin
		if (screenend) begin
			x <= 0;
			y <= 0;
		end else if (active) begin
			if (x < (WIDTH - 1)) begin
				x <= x + 1'b1;
			end else begin
				if (y < (HEIGHT - 1)) begin
					x <= 0;
					y <= y + 1;
				end else begin
					y <= 0;
					x <= 0;
				end 
			end 
		end 
	end 
	
	always @(posedge clk) begin
		active_fifo = (active_fifo << 1) | active;
		if (active_fifo[(COLOR_GAP - 1)]) begin
			red <= color[23:16];
			green <= color[15:8];
			blue <= color[7:0];
		end else begin
			red <= 0;
			green <= 0;
			blue <= 0;
		end 
	end 
endmodule
