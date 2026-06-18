vlib work      
vlog Top.v top_tb.v ALU.v 7_seg.v D2BCD.v AN_sel.v clock_divider.v D_FF.v
vsim -voptargs=+acc work.top_tb 
add wave *
run -all
#quit -sim