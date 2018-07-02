module vga_controller(
clk65,
color_in,
screenend, active, active_x, active_y
);

input clk65;
input [23:0] color_in;

output reg screenend = 0;
output reg active = 0;
output reg [9:0] active_x = 0;
output reg [9:0] active_y = 0;

parameter H_VISIBLE = 1024;
parameter H_FRONT = 24;
parameter H_SYNC = 136;
parameter H_BACK = 160;
// parameter H_LINE = 1344;

parameter V_VISIBLE = 768;
parameter V_FRONT = 3;
parameter V_SYNC = 6;
parameter V_BACK = 29;
// parameter V_FRAME = 806;

parameter SHIFT_ACTIVE = 4;

endmodule
