onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbench/test_mode
add wave -noupdate /tbench/fetch_enable
add wave -noupdate /tbench/clock_gating
add wave -noupdate /tbench/tb_clk
add wave -noupdate /tbench/jtag_reset
add wave -noupdate /tbench/key_reset
add wave -noupdate /tbench/KEY_r
add wave -noupdate /tbench/sw_in
add wave -noupdate /tbench/ledr_out
add wave -noupdate -expand -group TIMER -label clk /tbench/dut/u0/timer_0/clk
add wave -noupdate -expand -group TIMER -label select /tbench/dut/u0/timer_0/chipselect
add wave -noupdate -expand -group TIMER -label address /tbench/dut/u0/timer_0/address
add wave -noupdate -expand -group TIMER -label write_data /tbench/dut/u0/timer_0/writedata
add wave -noupdate -expand -group TIMER -label int_enabe /tbench/dut/u0/timer_0/control_interrupt_enable
add wave -noupdate -expand -group TIMER -label internal_counter /tbench/dut/u0/timer_0/internal_counter
add wave -noupdate -expand -group TIMER -label timeout /tbench/dut/u0/timer_0/timeout_occurred
add wave -noupdate /tbench/dut/u0/timer_0/period_h_register
add wave -noupdate /tbench/dut/u0/timer_0/period_l_register
add wave -noupdate -expand -group IRQ_MAPPER -label sender_irq /tbench/dut/u0/irq_mapper/sender_irq
add wave -noupdate -expand -group IRQ_MAPPER -label int0 /tbench/dut/u0/irq_mapper/receiver0_irq
add wave -noupdate -expand -group IRQ_MAPPER -label int1 /tbench/dut/u0/irq_mapper/receiver1_irq
add wave -noupdate -expand -group IRQ_MAPPER -label int2 /tbench/dut/u0/irq_mapper/receiver2_irq
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5374706 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 359
configure wave -valuecolwidth 89
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
WaveRestoreZoom {13543336 ps} {14129298 ps}
