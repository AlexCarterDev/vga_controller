onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clk
add wave -noupdate -group {vga user } -radix unsigned /tb/active
add wave -noupdate -group {vga user } -radix unsigned /tb/active_x
add wave -noupdate -group {vga user } -radix unsigned /tb/active_y
add wave -noupdate -group {vga user } -radix hexadecimal /tb/color
add wave -noupdate -group {vga user } /tb/screenend
add wave -noupdate -expand -group {vga out} /tb/vsync
add wave -noupdate -expand -group {vga out} /tb/hsync
add wave -noupdate -expand -group {vga out} /tb/red
add wave -noupdate -expand -group {vga out} /tb/green
add wave -noupdate -expand -group {vga out} /tb/blue
add wave -noupdate -expand -group hsync /tb/vga/hs/hsync
add wave -noupdate -expand -group hsync /tb/vga/hs/new_line
add wave -noupdate -expand -group hsync -radix unsigned /tb/vga/hs/count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {185000 ps} 0}
configure wave -namecolwidth 252
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {735 ns}
