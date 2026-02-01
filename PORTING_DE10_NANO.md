# Porting Guide: DE1-SoC to DE10-Nano

This guide explains how to port the RISCV_ECU project from the Terasic DE1-SoC board to the Terasic DE10-Nano board.

## Key Differences Between Boards

### Device Information
- **DE1-SoC**: Cyclone V SoC (5CSEMA5F31C6)
- **DE10-Nano**: Cyclone V SoC (5CSEBA6U23I7)

### Hardware Resources
- **DE1-SoC**: 10 LEDs, 4 push buttons, 10 switches, 2x 40-pin GPIO headers
- **DE10-Nano**: 8 LEDs, 2 push buttons, 2x 40-pin GPIO headers, Arduino expansion header

## Required Changes

### 1. Device Part Number

Update the FPGA device part number in all QSF files:
- Change `5CSEMA5F31C6` to `5CSEBA6U23I7`

### 2. Pin Assignments

The DE10-Nano has different pin assignments. You need to update:

#### Clock Signals
- `CLOCK_50`: Different pin on DE10-Nano
- DE10-Nano provides: CLOCK_50, CLOCK2_50, CLOCK3_50

#### User I/O
- **LEDs**: DE10-Nano has 8 LEDs (vs 10 on DE1-SoC)
  - Update `LEDR[9:0]` to `LED[7:0]` (only 8 LEDs available)
- **Keys**: DE10-Nano has 2 push buttons (vs 4 on DE1-SoC)
  - Update `KEY[3:0]` to `KEY[1:0]` (only 2 keys available)
- **Switches**: DE10-Nano has no switches
  - Remove or comment out `SW[9:0]` assignments

#### GPIO Headers
- `GPIO_0[35:0]`: Different pin assignments
- `GPIO_1[35:0]`: Different pin assignments

### 3. Qsys System Configuration

Update the Qsys system file (`sys.qsys`):
- Change device parameter from `5CSEMA5F31C6` to `5CSEBA6U23I7`
- Update device family if needed (should remain "Cyclone V")

### 4. Top-Level Verilog Module

Update `pulpino_qsys_test.v`:
- Adjust LED count from 10 to 8
- Adjust KEY count from 4 to 2
- Remove or comment out SW inputs
- Update GPIO assignments if needed

### 5. Software Changes

The software should work without changes, but you may need to:
- Adjust LED output range (0-7 instead of 0-9)
- Adjust KEY input range (0-1 instead of 0-3)
- Remove SW input handling if switches are not available

## Pin Assignment Reference

Refer to the DE10-Nano User Manual for exact pin assignments. A template file has been created at:
- `quartus_project/pulpino_qsys_test_de10nano.qsf`

### Finding Pin Assignments

1. **DE10-Nano User Manual**: 
   - Download from Terasic website
   - Section: "Pin Assignments" or "FPGA Pin Assignments"
   - Look for tables showing signal names and pin numbers

2. **Example Projects**:
   - Check Terasic DE10-Nano example projects
   - Intel DE10-Nano hardware examples on GitHub
   - These often include complete QSF files with pin assignments

3. **Schematic**:
   - DE10-Nano schematic shows physical connections
   - Match signal names to FPGA pin numbers

### Common Pin Locations (verify in manual)

#### Clock
- `CLOCK_50`: Dedicated clock input pin
- `CLOCK2_50`: Available but may not be used
- `CLOCK3_50`: Available but may not be used

#### LEDs (8 LEDs on DE10-Nano)
- `LED[0]` through `LED[7]`: Check DE10-Nano user manual
- Usually on specific I/O banks

#### Keys (2 push buttons)
- `KEY[0]`: Reset button (typically active-low, dedicated pin)
- `KEY[1]`: User button (typically active-low)

#### GPIO Headers
- GPIO_0[35:0]: 40-pin header, check schematic
- GPIO_1[35:0]: Second 40-pin header, check schematic
- Pin assignments vary by header position

## Step-by-Step Porting Process

1. **Backup your current project**
   ```bash
   cp -r quartus_project quartus_project_de1soc_backup
   ```

2. **Update device part number** ✅ (Already done)
   - Edit `quartus_project/pulpino_qsys_test.qsf`
   - Change `DEVICE 5CSEMA5F31C6` to `DEVICE 5CSEBA6U23I7`
   - **Status**: Already updated in the main QSF file

3. **Update Qsys system** ✅ (Already done)
   - Open `quartus_project/sys.qsys` in Platform Designer
   - Update device parameter to `5CSEBA6U23I7`
   - Regenerate the system using: `qsys-generate sys.qsys`
   - **Status**: Device parameter already updated in sys.qsys

4. **Update pin assignments** ⚠️ (Requires manual input)
   - Get pin assignments from DE10-Nano user manual
   - Use template file: `pulpino_qsys_test_de10nano.qsf`
   - Fill in actual pin numbers from DE10-Nano documentation
   - Update `pulpino_qsys_test.qsf` with new pin locations
   - Update IO standards if needed (usually "3.3-V LVTTL")

5. **Update top-level module** ✅ (Template created)
   - A DE10-Nano compatible version is available at:
     `quartus_project/rtl/pulpino_qsys_test_de10nano.v`
   - Changes made:
     - LED count: 10 → 8 (LEDR[9:0] → LED[7:0])
     - KEY count: 4 → 2 (KEY[3:0] → KEY[1:0])
     - Removed SW inputs (DE10-Nano has no switches)
   - **Option 1**: Replace `pulpino_qsys_test.v` with the DE10-Nano version
   - **Option 2**: Manually update the existing file

6. **Update software (if needed)**
   - Modify software to use only 8 LEDs
   - Adjust for 2 keys instead of 4
   - Remove switch-related code

7. **Rebuild project**
   ```bash
   make clean-all
   make
   ```

8. **Test on hardware**
   - Program the DE10-Nano with the new bitstream
   - Verify all functionality

## Notes

- The DE10-Nano has fewer user I/O resources than DE1-SoC
- GPIO headers are the primary expansion method
- Consider using the Arduino expansion header for additional I/O
- The HPS (Hard Processor System) is available but not used in this project

## Quick Reference: Files Modified/Created

### Files Already Updated ✅
1. `quartus_project/pulpino_qsys_test.qsf` - Device changed to 5CSEBA6U23I7
2. `quartus_project/sys.qsys` - Device parameter updated to 5CSEBA6U23I7

### New Files Created ✅
1. `PORTING_DE10_NANO.md` - This porting guide
2. `quartus_project/rtl/pulpino_qsys_test_de10nano.v` - DE10-Nano compatible top-level module
3. `quartus_project/pulpino_qsys_test_de10nano.qsf` - Pin assignment template

### Files That Need Manual Updates ⚠️
1. **Pin Assignments**: Fill in actual pin numbers in `pulpino_qsys_test_de10nano.qsf` or merge into main QSF
2. **Top-Level Module**: Either use `pulpino_qsys_test_de10nano.v` or manually update `pulpino_qsys_test.v`
3. **Software** (optional): Update to use only 8 LEDs instead of 10

## Software Changes (Optional)

The current software should work, but you may want to adjust:

1. **LED Output Range**: Change from 0-10 to 0-7
   - In `main.c`, the counter goes 0-10, which is fine (only lower 8 bits will show)
   - Or modify to count 0-7 for cleaner display

2. **Key Input**: Only 2 keys available instead of 4
   - Current code uses KEY[0] for reset (works fine)
   - KEY[1] is available but not used in current code

3. **Switch Input**: No switches on DE10-Nano
   - Current code reads switches but doesn't use them critically
   - Can be left as-is (will read as zeros)

## Next Steps

1. **Get Pin Assignments**:
   - Download DE10-Nano User Manual from Terasic
   - Or check example projects for complete QSF files

2. **Update Pin Assignments**:
   - Fill in `pulpino_qsys_test_de10nano.qsf` with actual pins
   - Or merge pin assignments into main QSF file

3. **Replace Top-Level Module** (if using DE10-Nano version):
   ```bash
   cd quartus_project/rtl
   cp pulpino_qsys_test.v pulpino_qsys_test_de1soc_backup.v
   cp pulpino_qsys_test_de10nano.v pulpino_qsys_test.v
   ```

4. **Regenerate Qsys System**:
   ```bash
   cd quartus_project
   qsys-generate sys.qsys --synthesis=VERILOG --output-directory=sys/synthesis
   qsys-generate sys.qsys --simulation=VERILOG --output-directory=sys/simulation
   ```

5. **Rebuild Project**:
   ```bash
   make clean-all
   make
   ```

6. **Program Board**:
   ```bash
   make program-sof
   ```

## Resources

- [DE10-Nano User Manual](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=167&No=1046&PartNo=4)
- [DE10-Nano Getting Started Guide](https://www.intel.com/content/www/us/en/developer/articles/guide/terasic-de10-nano-get-started-guide.html)
- [DE10-Nano Hardware Examples](https://github.com/intel/de10-nano-hardware)
- [Terasic DE10-Nano Product Page](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=167&No=1046)
