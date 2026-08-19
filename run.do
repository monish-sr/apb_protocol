vlib work

vlog list.svh

vopt top +cover=fcbest +acc=rnb -o 5WRD

vsim -assertdebug -coverage 5WRD -l mem.log -sv_seed 85132

view assertions

add wave -position insertpoint sim:/top/*


do wave.do

coverage save -onexit N_WRITE_READ.ucdb

run -all
