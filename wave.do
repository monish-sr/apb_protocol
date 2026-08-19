onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 30 -expand -group {GLOBAL SIGNALS} /top/pif/PCLK
add wave -noupdate -height 30 -expand -group {GLOBAL SIGNALS} /top/pif/PRESET_N
add wave -noupdate -height 30 -expand -group {STATE DECIDING SIGNALS} /top/pif/PSEL
add wave -noupdate -height 30 -expand -group {STATE DECIDING SIGNALS} /top/pif/PENABLE
add wave -noupdate -height 30 -expand -group {INPUT SIGNALS} /top/pif/PWRITE
add wave -noupdate -height 30 -expand -group {INPUT SIGNALS} /top/pif/PADDR
add wave -noupdate -height 30 -expand -group {INPUT SIGNALS} /top/pif/PWDATA
add wave -noupdate -height 30 -expand -group {OUTPUT SIGNALS} /top/pif/PRDATA
add wave -noupdate -height 30 -expand -group {OUTPUT SIGNALS} /top/pif/PREADY
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {36 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {132 ns}
