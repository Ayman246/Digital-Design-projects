vlib work      
vlog top.v PIPELINE.v tb.v  
vsim -voptargs=+acc work.tb 
add wave *
run -all
#quit -sim