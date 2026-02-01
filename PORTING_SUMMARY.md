# Porting Summary: DE1-SoC to DE10-Nano

## Project Validation Status: ✅ **VALIDATED**

The project has been successfully ported from Terasic DE1-SoC to Terasic DE10-Nano and validated on hardware. All LEDs are functioning correctly.

---

## Files Modified

### 1. **`Makefile`** (Root)
**Path:** `/Makefile`

**Changes Made:**
- **Line 9:** Changed default target from `auto-testbench` to `compile-quartus`
  ```makefile
  # Before:
  all: auto-testbench
  
  # After:
  all: compile-quartus
  ```

**Reason:**
- The `auto-testbench` target was not defined anywhere in the Makefile system
- This caused build errors: `make: *** No rule to make target 'auto-testbench'`
- Changed to `compile-quartus` which is the main build target for hardware compilation

---

### 2. **`quartus_project/pulpino_qsys_test.qsf`**
**Path:** `quartus_project/pulpino_qsys_test.qsf`

**Changes Made:**

#### a) Device Part Number
- **Line 11:** Changed device from `5CSEMA5F31C6` (DE1-SoC) to `5CSEBA6U23I7` (DE10-Nano)
  ```tcl
  set_global_assignment -name DEVICE 5CSEBA6U23I7
  ```

#### b) Top-Level Entity
- **Line 13:** Updated to match the project name
  ```tcl
  set_global_assignment -name TOP_LEVEL_ENTITY pulpino_qsys_test
  ```

#### c) Pin Assignments - Clock
- **CLOCK_50:** Changed from DE1-SoC pin to DE10-Nano pin `PIN_V11`
  ```tcl
  set_location_assignment PIN_V11 -to CLOCK_50
  ```

#### d) Pin Assignments - Keys (Push Buttons)
- Changed from `KEY[3:0]` (4 keys) to `KEY[1:0]` (2 keys)
- **KEY[0]:** `PIN_AH17` (DE10-Nano)
- **KEY[1]:** `PIN_AH16` (DE10-Nano)
  ```tcl
  set_location_assignment PIN_AH17 -to KEY[0]
  set_location_assignment PIN_AH16 -to KEY[1]
  ```

#### e) Pin Assignments - LEDs
- Changed from `LEDR[9:0]` (10 LEDs) to `LED[7:0]` (8 LEDs)
- Updated all 8 LED pin assignments:
  ```tcl
  set_location_assignment PIN_W15  -to LED[0]
  set_location_assignment PIN_AA24 -to LED[1]
  set_location_assignment PIN_V16  -to LED[2]
  set_location_assignment PIN_V15  -to LED[3]
  set_location_assignment PIN_AF26 -to LED[4]
  set_location_assignment PIN_AE26 -to LED[5]
  set_location_assignment PIN_Y16  -to LED[6]
  set_location_assignment PIN_AA23 -to LED[7]
  ```

#### f) Pin Assignments - GPIO Headers
- **GPIO_0[35:0]:** Updated all 36 pins with DE10-Nano pin assignments
- **GPIO_1[35:0]:** Updated all 36 pins with DE10-Nano pin assignments
- Added IO standard assignments: `3.3-V LVTTL`

#### g) File Assignments (Critical Fix)
- Added missing source file assignments that were causing "Top-level design entity undefined" error:
  ```tcl
  set_global_assignment -name VERILOG_FILE rtl/pulpino_qsys_test.v
  set_global_assignment -name QSYS_FILE sys.qsys
  set_global_assignment -name QIP_FILE sys/synthesis/sys.qip
  set_global_assignment -name SIP_FILE sys/simulation/sys.sip
  set_global_assignment -name QIP_FILE sw/mem_init/meminit.qip
  set_global_assignment -name SIP_FILE sw/mem_init/meminit.sip
  set_global_assignment -name QIP_FILE pll.qip
  set_global_assignment -name SIP_FILE pll.sip
  set_global_assignment -name SYSTEMVERILOG_FILE rtl/tb/tbench.sv
  set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
  ```

**Reasons:**
- **Device change:** DE10-Nano uses a different Cyclone V device (5CSEBA6U23I7 vs 5CSEMA5F31C6)
- **Hardware differences:** DE10-Nano has 8 LEDs (vs 10), 2 keys (vs 4), no switches
- **Pin differences:** All pins are physically different between the two boards
- **File assignments:** Required for Quartus to find and compile all source files

---

### 3. **`quartus_project/sys.qsys`**
**Path:** `quartus_project/sys.qsys`

**Changes Made:**
- **Device parameter:** Changed from `5CSEMA5F31C6` to `5CSEBA6U23I7`
  ```xml
  <parameter name="device" value="5CSEBA6U23I7" />
  ```

**Reason:**
- Qsys (Platform Designer) system must target the correct FPGA device
- Device-specific optimizations and constraints depend on the correct device selection
- Required for proper synthesis and fitting

---

### 4. **`quartus_project/rtl/pulpino_qsys_test.v`**
**Path:** `quartus_project/rtl/pulpino_qsys_test.v`

**Changes Made:**

#### a) Module Ports - Keys
- Changed from `KEY[3:0]` to `KEY[1:0]`
  ```verilog
  // Before:
  input  [3:0]  KEY,
  
  // After:
  input  [1:0]  KEY,      // DE10-Nano has 2 keys (vs 4 on DE1-SoC)
  ```

#### b) Module Ports - LEDs
- Changed from `LEDR[9:0]` to `LED[7:0]`
  ```verilog
  // Before:
  output [9:0]  LEDR,
  
  // After:
  output [7:0]  LED,      // DE10-Nano has 8 LEDs (vs 10 on DE1-SoC)
  ```

#### c) Module Ports - Switches
- **Removed:** `SW[9:0]` input (DE10-Nano has no switches)
  ```verilog
  // Removed:
  // input  [9:0]  SW,
  ```

#### d) Reset Logic
- Updated to use only `KEY[0]` (DE10-Nano has 2 keys, KEY[0] is reset)
  ```verilog
  assign reset_n = KEY[0] & ~jtag_reset;
  ```

#### e) GPIO Output Assignment
- Updated LED assignment to use 8 LEDs instead of 10
  ```verilog
  // Before:
  assign LEDR [9:0] = gpio_out [9:0];
  
  // After:
  assign LED [7:0] = gpio_out [7:0];
  ```

#### f) GPIO Input Assignment
- Updated to use only 2 keys, padded remaining bits with zeros
  ```verilog
  // Before:
  assign gpio_in [3:0] = KEY [3:0];
  assign gpio_in [13:4] = SW [9:0];
  
  // After:
  assign gpio_in [1:0] = KEY [1:0];
  assign gpio_in [31:2] = 30'b0;  // No switches, pad with zeros
  ```

**Reasons:**
- **Hardware constraints:** DE10-Nano has different I/O resources than DE1-SoC
- **Signal names:** DE10-Nano uses `LED[7:0]` instead of `LEDR[9:0]`
- **Missing peripherals:** DE10-Nano has no switches, so SW input was removed
- **Compatibility:** Top-level module must match the physical board connections

---

### 5. **`.make_utils/quartus.mk`**
**Path:** `.make_utils/quartus.mk`

**Changes Made:**
- **Line 98:** Updated `program-sof` target to specify device index `@2` in JTAG chain
  ```makefile
  # Before:
  quartus_pgm -m JTAG -o "p;$(Q_DIR)/output_files/$(PROJECT_NAME).sof"
  
  # After:
  quartus_pgm -m JTAG -o "p;$(Q_DIR)/output_files/$(PROJECT_NAME).sof@2"
  ```

**Reason:**
- DE10-Nano has a **JTAG chain with 2 devices:**
  - Device 1 = SOCVHPS (Hard Processor System - ARM)
  - Device 2 = FPGA (Cyclone V)
- Without `@2`, Quartus tries to program device 1 (ARM) instead of device 2 (FPGA)
- This caused error: `Expected JTAG ID code 0x02D020DD for device 1, but found 0x4BA00477`
- Specifying `@2` ensures the FPGA (device 2) is programmed correctly

---

## Files Created (Documentation)

### 6. **`PORTING_DE10_NANO.md`**
**Purpose:** Comprehensive porting guide with step-by-step instructions

### 7. **`DE10_NANO_CONFIGURATION.md`**
**Purpose:** FPGA configuration mode switch (SW10) settings for JTAG programming

### 8. **`USB_BLASTER_STATUS.md`**
**Purpose:** USB Blaster driver status and troubleshooting guide

### 9. **`TROUBLESHOOTING_JTAG.md`**
**Purpose:** JTAG connection troubleshooting and solutions

### 10. **`LED_BEHAVIOR.md`**
**Purpose:** Detailed explanation of expected LED behavior based on software analysis

### 11. **`MAKEFILE_ANALYSIS.md`**
**Purpose:** Complete analysis of the Makefile structure and build system

---

## Files Deleted

### 12. **`quartus_project/pulpino_qsys_test_de10nano.qsf`**
**Reason:** Temporary template file created during porting. Its contents were merged into the main `pulpino_qsys_test.qsf` file, so the template was no longer needed.

---

## Key Differences: DE1-SoC vs DE10-Nano

| Feature | DE1-SoC | DE10-Nano |
|---------|---------|-----------|
| **Device** | 5CSEMA5F31C6 | 5CSEBA6U23I7 |
| **LEDs** | 10 (LEDR[9:0]) | 8 (LED[7:0]) |
| **Keys** | 4 (KEY[3:0]) | 2 (KEY[1:0]) |
| **Switches** | 10 (SW[9:0]) | None |
| **GPIO Headers** | 2x 40-pin | 2x 40-pin (different pins) |
| **JTAG Chain** | Single device | 2 devices (HPS + FPGA) |

---

## Build Process Changes

### Required Build Steps (No Changes)
The build process remains the same:
1. `make built-toolchain` - Build RISC-V GCC toolchain
2. `make compile-source-code` - Compile C/Assembly code
3. `make generate-memory` - Generate memory initialization files
4. `make compile-qsys` - Generate Qsys system
5. `make compile-quartus` - Compile Quartus project
6. `make program-sof` - Program FPGA via JTAG

### Programming Command Fix
- **Issue:** JTAG chain has 2 devices, need to specify FPGA device
- **Solution:** Added `@2` to programming command to target device 2 (FPGA)

---

## Validation Results

✅ **Hardware Validation:**
- FPGA successfully programmed
- LEDs functioning correctly
- Software executing as expected
- Timer interrupts working
- GPIO outputs responding

✅ **Software Behavior:**
- Binary counter (0-7) running on LEDs 0, 1, 2
- Timer interrupts at ~347 kHz (with DEBUG_FLAG)
- Reset functionality working (KEY[0])

---

## Summary

**Total Files Modified:** 5
**Total Files Created:** 6 (documentation)
**Total Files Deleted:** 1 (temporary template)

**Main Changes:**
1. Device part number updated throughout project
2. Pin assignments updated for DE10-Nano hardware
3. Top-level module adapted for different I/O resources
4. Makefile targets fixed
5. Programming command updated for JTAG chain

**Project Status:** ✅ **Fully Ported and Validated**

---

## References

- DE10-Nano User Manual: [Terasic](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=167&No=1046&PartNo=4)
- Quartus Prime Programmer User Guide
- PULPino Documentation
