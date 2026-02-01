# Makefile Structure Analysis

## Overview

This project uses a **modular Makefile system** with:
- **Root Makefile**: Main entry point, includes all fragments
- **Fragment Makefiles** (`.make_utils/*.mk`): Modular build rules
- **Stub Makefiles** (`quartus_project/Makefile`, `sw/Makefile`): Forward to root

---

## Architecture

```
Makefile (root)
├── Includes: project-config.mk
├── Includes: variables.mk
├── Includes: riscv-gnu-toolchain.mk
├── Includes: source-code.mk
└── Includes: quartus.mk
```

---

## Root Makefile (`/Makefile`)

### Purpose
Central entry point that includes all fragment Makefiles.

### Key Variables
- `NPROC`: Number of CPU cores (for parallel builds)
- `PROJECT_DIR`: Current directory (project root)
- `FRAGMENT_DIR`: `.make_utils/` directory

### Targets

#### `all` (DEFAULT TARGET) ⚠️ **BROKEN**
```make
all: auto-testbench
```
**Problem**: `auto-testbench` is **never defined** anywhere! This causes the error.

#### `clean-stamps`
Removes all stamp files from `.make_utils/stamps/`

#### `clean-all`
Calls: `clean-stamps`, `clean-all-project`, `clean-memory-files`

#### `debug-%`
Debug helper: `make debug-VARIABLE_NAME` prints variable value

---

## Fragment Makefiles

### 1. `project-config.mk`
**Purpose**: Project configuration and naming

**Key Variables**:
- `PROJECT_NAME=pulpino_qsys_test`
- `QSYS_NAME=sys`
- `TARGET_ARCH=-march=rv32imc_zicsr_zifencei -mabi=ilp32`
- `ALTERNATIVE_MEM_RELOAD=true`

**No targets defined** - just configuration

---

### 2. `variables.mk`
**Purpose**: Define all paths, file lists, and build variables

**Key Directories**:
- `Q_DIR`: `quartus_project/`
- `SW_DIR`: `quartus_project/sw/`
- `SRC_DIR`: `quartus_project/sw/source_code/`
- `TOOLCHAIN_DIR`: `toolchain/`
- `STAMPS_DIR`: `.make_utils/stamps/`

**Key Files**:
- `QSYS_FILE`: `quartus_project/sys/synthesis/sys.qip`
- `QSYS_SRC`: `quartus_project/sys.qsys`
- `END_SOF`: `quartus_project/output_files/pulpino_qsys_test.sof`
- `ELF_INTERMEDIATE`: `quartus_project/sw/bundle.elf`
- `MEM`: `quartus_project/sw/mem_init/sys_onchip_memory2_0`

**Stamp Files** (track build state):
- `TOOLCHAIN_COMPILATION_STAMP`
- `DESIGN_COMPILE_STAMP`
- `TB_COMPILE_STAMP`
- `MEM_STAMP`
- `RELOAD_STAMP`
- etc.

**No targets defined** - just variables

---

### 3. `riscv-gnu-toolchain.mk`
**Purpose**: Build the RISC-V GCC toolchain

#### Targets

##### `built-toolchain`
**Dependencies**: `$(TOOLCHAIN_COMPILATION_STAMP)`

**What it does**:
1. Configures the RISC-V toolchain from `riscv-gnu-toolchain/` submodule
2. Compiles it with `make -j$(NPROC)` (parallel)
3. Installs to `toolchain/` directory
4. Creates stamp file

**When to use**: First time setup, or after `clean-toolchain`

##### `clean-toolchain`
**What it does**: Removes `toolchain/` directory and stamp
**Interactive**: Asks for confirmation (destructive operation)

---

### 4. `source-code.mk`
**Purpose**: Compile C/Assembly source code for RISC-V

#### Build Chain
```
.c/.S files → .o files → bundle.elf → bundle.bin → sys_onchip_memory2_0.hex
```

#### Targets

##### `compile-source-code`
**Dependencies**: `$(OBJS)` (all object files)

**What it does**: Compiles all `.c`, `.s`, `.S` files to `.o` files
- Uses RISC-V GCC from `toolchain/bin/riscv64-unknown-elf-gcc`
- Generates dependency files (`.d`) for incremental builds

##### `link-executable`
**Dependencies**: `$(ELF_INTERMEDIATE)` → `bundle.elf`

**What it does**: Links all object files into ELF executable
- Uses linker script: `sw/link.riscv.ld`
- Prints size of executable

##### `generate-binary`
**Dependencies**: `$(MEM).bin`

**What it does**: Converts ELF to binary
- Uses `objcopy` with address offset `-0x00008000` (boot address)
- Output: `sw/mem_init/sys_onchip_memory2_0.bin`

##### `generate-memory`
**Dependencies**: `$(MEM).hex`

**What it does**: Converts binary to Intel HEX format
- Uses custom tool: `tools/bin2hex`
- Output: `sw/mem_init/sys_onchip_memory2_0.hex`
- **This is the file that gets loaded into FPGA memory**

##### `clean-program-files`
Removes: `.o`, `.d`, `.elf`, `.bin`, `.hex` files

---

### 5. `quartus.mk`
**Purpose**: FPGA hardware compilation and simulation

#### Build Chain
```
sys.qsys → sys/synthesis/sys.qip → compile → pulpino_qsys_test.sof
```

#### Targets

##### `qsys-gui`
Opens Platform Designer (Qsys) GUI for `sys.qsys`

##### `compile-qsys`
**Dependencies**: `$(QSYS_FILE)` → `sys/synthesis/sys.qip`

**What it does**: Generates Qsys system
- Runs: `qsys-generate sys.qsys --synthesis=VERILOG --simulation=VERILOG`
- Creates synthesis and simulation files

##### `compile-quartus`
**Dependencies**: `$(END_SOF)` → `output_files/pulpino_qsys_test.sof`

**What it does**: Full Quartus compilation
- Runs: `quartus_sh --flow compile pulpino_qsys_test`
- Includes: Analysis, Synthesis, Fitter, Assembler
- Creates stamp: `DESIGN_COMPILE_STAMP`

**Dependencies chain**:
```
$(END_SOF) → $(DESIGN_COMPILE_STAMP) → $(VERILOG_SOURCES) $(QSYS_FILE) $(END_QSF) $(SDC_FILES)
```

##### `compile-testbench`
**Dependencies**: `$(TB_COMPILE_STAMP)`

**What it does**: Compiles testbench with `vlog`
- Requires: `$(DESIGN_COMPILE_STAMP)` (design must be compiled first)
- Compiles: `rtl/tb/tbench.sv`

##### `rtl-sim` / `rtl-sim-gui`
**Dependencies**: `$(RELOAD_STAMP)` `$(TB_COMPILE_STAMP)`

**What it does**: Runs RTL simulation
- `rtl-sim`: Command-line mode
- `rtl-sim-gui`: GUI mode
- Uses: `vsim -do "source $(rtl_sim_file); run -all"`

##### `gate-sim` / `gate-sim-gui`
**Dependencies**: `$(RELOAD_STAMP)` `$(TB_COMPILE_STAMP)`

**What it does**: Runs gate-level simulation (post-synthesis)
- First runs: `quartus_eda --simulation --tool=questa_oem`
- Then runs: `vsim` with gate-level netlist

##### `reload-memory`
**Dependencies**: `$(RELOAD_STAMP)`

**What it does**: Updates memory initialization in compiled design
- If `ALTERNATIVE_MEM_RELOAD=true`: Manually copies `.hex` files
- Otherwise: Uses `quartus_cdb --update_mif`
- Then runs: `quartus_asm` to regenerate bitstream

##### `program-sof`
**Dependencies**: `$(END_SOF)`

**What it does**: Programs FPGA via JTAG
- Runs: `quartus_pgm -m JTAG -o "p;output_files/pulpino_qsys_test.sof"`

##### `synthesis` / `fitting` / `assembly`
**What they do**: Individual Quartus compilation steps
- `synthesis`: `quartus_map` (synthesis only)
- `fitting`: `quartus_fit` (place & route)
- `assembly`: `quartus_asm` (bitstream generation)

##### Clean Targets
- `clean-project`: `quartus_sh --clean` (Quartus clean)
- `clean-altera`: Removes `db/`, `output_files/`, `sys/synthesis/`, etc.
- `clean-altera-full`: Calls multiple clean targets
- `clean-hardware-stamps`: Removes all stamp files

---

## Stub Makefiles

### `quartus_project/Makefile`
**Purpose**: Convenience wrapper - forwards all targets to root Makefile

**Why**: Allows running `make compile-quartus` from `quartus_project/` directory

### `quartus_project/sw/Makefile`
**Purpose**: Convenience wrapper - forwards software targets to root Makefile

---

## The `auto-testbench` Problem

### Current State
- **Referenced in**: `Makefile` line 9: `all: auto-testbench`
- **Referenced in**: `quartus_project/Makefile` line 29: `auto-testbench: $(MAKE) -C $(root) $@`
- **Defined in**: **NOWHERE!** ❌

### What It Should Do
Based on the name and context, `auto-testbench` should probably:
1. Compile the design (`compile-quartus`)
2. Compile the testbench (`compile-testbench`)
3. Possibly run a simulation

### Why It Doesn't Exist
Likely scenarios:
1. **Removed accidentally**: Someone deleted the target definition
2. **Never implemented**: Planned feature that wasn't completed
3. **Renamed**: Maybe it was supposed to be `compile-testbench`?

### Evidence
Looking at `quartus.mk`:
- There IS a `compile-testbench` target (line 45)
- It depends on `$(TB_COMPILE_STAMP)`
- But there's NO `auto-testbench` target

---

## Recommended Build Flow

### First Time Setup
```bash
# 1. Build RISC-V toolchain (takes a long time!)
make built-toolchain

# 2. Compile software
make compile-source-code
make link-executable
make generate-memory

# 3. Generate Qsys system
make compile-qsys

# 4. Compile FPGA design
make compile-quartus
```

### Normal Development Workflow

#### Software Changes
```bash
make compile-source-code
make link-executable
make generate-memory
make reload-memory  # Update FPGA memory
```

#### Hardware Changes (Verilog/Qsys)
```bash
make compile-qsys      # If Qsys changed
make compile-quartus   # Full compilation
```

#### Quick Rebuild
```bash
make compile-quartus   # Rebuilds everything if needed
```

---

## Dependency Graph

```
built-toolchain
    ↓
compile-source-code → link-executable → generate-binary → generate-memory
                                                              ↓
compile-qsys → compile-quartus ←─────────────────────────────┘
    ↓                ↓
compile-testbench → rtl-sim / gate-sim
```

---

## Fixing the `auto-testbench` Issue

### Option 1: Remove It (Simplest)
Change `Makefile` line 9:
```make
all: compile-quartus
```

### Option 2: Create It (Most Complete)
Add to `quartus.mk`:
```make
auto-testbench: compile-quartus compile-testbench
	@echo "Design and testbench compiled successfully"
```

### Option 3: Make It Build Everything
Add to `quartus.mk`:
```make
auto-testbench: built-toolchain compile-source-code link-executable generate-memory compile-qsys compile-quartus compile-testbench
	@echo "Full build complete: design, software, and testbench ready"
```

**Recommendation**: Use **Option 1** for now (simplest), or **Option 3** if you want a complete "build everything" target.

---

## Common Make Targets Summary

| Target | What It Does | Dependencies |
|--------|-------------|--------------|
| `built-toolchain` | Build RISC-V GCC | None (first time) |
| `compile-source-code` | Compile C/ASM → .o | Toolchain |
| `link-executable` | Link → bundle.elf | Object files |
| `generate-memory` | Create .hex file | bundle.elf |
| `compile-qsys` | Generate Qsys IP | sys.qsys |
| `compile-quartus` | Full FPGA compile | Qsys, Verilog, QSF |
| `compile-testbench` | Compile testbench | Compiled design |
| `rtl-sim` | Run RTL simulation | Testbench, memory |
| `gate-sim` | Run gate simulation | Testbench, memory |
| `program-sof` | Program FPGA | .sof file |
| `reload-memory` | Update memory in design | .hex file, compiled design |
| `clean-altera` | Clean Quartus files | None |
| `clean-all` | Clean everything | None |

---

## Key Insights

1. **Stamp-based build system**: Uses stamp files to track what's been built
2. **Modular design**: Each fragment handles one aspect (toolchain, software, hardware)
3. **Dependency-driven**: Make automatically handles dependencies
4. **Missing target**: `auto-testbench` is referenced but never defined
5. **Stub pattern**: Subdirectory Makefiles forward to root for convenience
