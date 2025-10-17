onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TB -color Yellow -label SW /tbench/sw
add wave -noupdate -expand -group TB -color Red -label LED /tbench/led
add wave -noupdate -expand -group TB -label CLK /tbench/clk50
add wave -noupdate -expand -group TB -label KEYS /tbench/keys
add wave -noupdate -expand -group PIO_IN -label CHIP_SLCT /tbench/dut/u0/pio_in/chipselect
add wave -noupdate -expand -group PIO_IN -label IRQ_MSK /tbench/dut/u0/pio_in/irq_mask
add wave -noupdate -expand -group PIO_IN -label IRQ /tbench/dut/u0/pio_in/irq
add wave -noupdate -expand -group IRQ_MAPPER -label RECEIVER_0 /tbench/dut/u0/irq_mapper/receiver0_irq
add wave -noupdate -expand -group IRQ_MAPPER -label RECEIVER_1 /tbench/dut/u0/irq_mapper/receiver1_irq
add wave -noupdate -expand -group IRQ_MAPPER -color Blue -label SENDER -radix binary /tbench/dut/u0/irq_mapper/sender_irq
add wave -noupdate -expand -group PULPINO /tbench/dut/u0/pulpino_0/irq_id
add wave -noupdate -expand -group PULPINO -radix binary /tbench/dut/u0/pulpino_0/irq_i
add wave -noupdate -expand -group IF_STAGE /tbench/dut/u0/pulpino_0/RISCV_CORE/if_stage_i/fetch_addr
add wave -noupdate -expand -group IF_STAGE /tbench/dut/u0/pulpino_0/RISCV_CORE/if_stage_i/jump_target_ex_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2039797 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 501
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
WaveRestoreZoom {0 ps} {1164430 ps}
