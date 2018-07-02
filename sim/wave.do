onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clk
add wave -noupdate -radix unsigned /tb/active
add wave -noupdate -radix unsigned /tb/active_x
add wave -noupdate -radix unsigned /tb/active_y
add wave -noupdate -radix hexadecimal /tb/color
add wave -noupdate /tb/screenend
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {52087 ps} 0}
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
WaveRestoreZoom {0 ps} {630 ns}
