# POLIno Qsys Project

Development of a PULPino-based processor. Right now the processor is unespecialized and can be adapted to other uses, more akin to a development plataform, but the goal is to specialize it into a fuel injection ECU.

## Overview

This project integrates the [PULPino (zero-riscy)](https://github.com/pulp-platform/pulpino) RISC-V core into an Intel/Altera FPGA using the Platform Designer (Qsys). The project is configured for a Terasic DE1-SoC board, but it can also be simulated using QuestaSim.

The project is structured to automate the build process as much as possible using a modular `Makefile` system. It includes both the hardware source design in verilog an Altera formats and the software that runs on the RISC-V core.

## Prerequisites

*   Intel Quartus Prime (tested with 24.1std.0 Lite Edition)
*   Questa Intel FPGA Edition
*   A RISC-V GCC toolchain. The project includes a submodule to build one automatically.

## Project Structure

*   `Makefile`: The main entry point for all build and simulation tasks.
*   `.make_utils/`: Contains `Makefile` fragments that define the build system logic.
*   `quartus_project/`: Contains the Quartus project, Qsys system, RTL source files, and software source code.
    *   `quartus_project/rtl/`: Contains the top-level Verilog file and testbench.
    *   `quartus_project/sw/`: Contains the C and Assembly source code for the RISC-V core.
    *   `quartus_project/sys.qsys`: The Qsys system definition.
*   `riscv-gnu-toolchain/`: A git submodule for building the RISC-V GCC toolchain.

## Build Procedure

The entire project, including the RISC-V toolchain, hardware, and software, can be built by running a single command from the root of the project:

```bash
make
```

This will perform the following steps:

1.  **Build the RISC-V GCC toolchain:** The `riscv-gnu-toolchain` submodule will be compiled.
2.  **Compile the software:** The C/Assembly code in `quartus_project/sw/` will be compiled into a memory initialization file (`.hex`).
3.  **Synthesize the hardware:** The Qsys system will be generated, and the Quartus project will be compiled to create an FPGA bitstream (`.sof`).

### Individual Build Steps

It is also possible to run the build steps individually:

*   **Build the toolchain:** `make toolchain`
*   **Compile the software:** `make sw`
*   **Compile the Quartus project:** `make compile-quartus`

## Simulation

### RTL Simulation

To run an RTL simulation of the design, use the following command:

```bash
make rtl-sim
```

This will launch QuestaSim in command-line mode, run the simulation, and exit. To open the GUI, use:

```bash
make rtl-sim-gui
```

### Gate-Level Simulation

To run a gate-level simulation, use the following command:

```bash
make gate-sim
```

To open the GUI, use:

```bash
make gate-sim-gui
```

## Running on Hardware

To program the FPGA, use the following command:

```bash
make program-sof
```

This will program the `.sof` file located in `quartus_project/output_files/` to the connected FPGA.
