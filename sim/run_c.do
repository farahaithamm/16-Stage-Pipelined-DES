#=============================================================================
# run_c.do
#
# Build des.c as a DPI library, compile RTL + tb_des_c, run in Questa.
#
# Usage, from this folder (sim/):
#     do run_c.do
#=============================================================================

quit -sim

set TB_FILE tb_des_c.v
set TB      tb_des
set C_SRC des.c

if {$tcl_platform(platform) eq "windows"} {
    set DPI_LIB des_dpi.dll
} else {
    set DPI_LIB libdes_dpi.so
}

# DPI shared library (in-process C reference; no $system)
if {$tcl_platform(platform) eq "windows"} {
    set gcc_cmd [list gcc -shared -O2 -DDES_NO_MAIN -o $DPI_LIB $C_SRC]
} else {
    set gcc_cmd [list gcc -shared -fPIC -O2 -DDES_NO_MAIN -o $DPI_LIB $C_SRC]
}

if {[catch {eval exec $gcc_cmd} err]} {
    puts "ERROR: gcc failed to build $DPI_LIB: $err"
    return
}
puts "Built C DPI library $DPI_LIB"

if {[file exists work]} {
    vdel -all -lib work
}
vlib work
vmap work work

set rtl_files {}
foreach f [lsort [glob -nocomplain *.v]] {
    set name [file tail $f]
    if {$name eq $TB_FILE || [string match -nocase "*_tb.v" $name]} { continue }
    lappend rtl_files $f
}
vlog -work work +acc {*}$rtl_files
vlog -sv -work work +acc $TB_FILE

# Load DPI lib (name without extension)
vsim -voptargs=+acc -sv_lib des_dpi work.$TB

# ---------- Waves ----------
add wave -divider "TB"
add wave -radix hex /tb_des/clk
add wave -radix hex /tb_des/rst_n
add wave -radix hex /tb_des/in
add wave -radix hex /tb_des/key
add wave -radix bin /tb_des/encrypt
add wave -radix hex /tb_des/start
add wave -radix hex /tb_des/out
add wave -radix hex /tb_des/done

run -all
#quit -f
