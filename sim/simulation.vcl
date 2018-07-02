transcript on 
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}

vlib rtl_work
vmap work rtl_work

vlog ../vga_controller.v

vlog tb.v

vsim tb

do wave.do
view structure
view signals
run 10us
