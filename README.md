# GMSK-V1: High Performance Silicon
![Status](https://img.shields.io/badge/Status-Phase%202%20Complete-success)
![RTL](https://img.shields.io/badge/RTL-SystemVerilog-blue)
![Core](https://img.shields.io/badge/Core-CV32E40P-orange)

**GMSK** (**G**raph **M**atrix **S**calar **K**ernel) is a high-performance RISC-V SoC initiative architected by **Gooty Mohammed Sameer Khan**. This project integrates industrial-grade open-source cores with custom AI acceleration logic designed for next-generation computing.

## 🧬 The Ideology
The GMSK architecture is built on four pillars:
*   **G**raph: Optimized for Neural Network computational graphs.
*   **M**atrix: Hardware acceleration for dense Tensor operations.
*   **S**calar: Efficient general-purpose computing (RISC-V).
*   **K**ernel: The central silicon brain of Sameer OS.

## 🏗️ Technical Architecture
**GMSK-V1** is the production-grade implementation, integrating the **CV32E40P** (formerly RI5CY) from the OpenHW Group.

*   **Core**: CV32E40P (32-bit RISC-V, 4-stage pipeline).
*   **ISA**: RV32IMFC (Integer, Multiply, Float, Compressed).
*   **Verified**: 100% compatible with Icarus Verilog simulation.
*   **Memory**: Custom single-cycle instruction memory (ROM).

## 🚀 Simulation Status
We have successfully integrated the core and verified it via **RTL Simulation**.

### Phase 2: Assembly Execution (Completed)
The core has successfully executed **hand-assembled machine code** without a compiler toolchain.
- **Test Program**: `10 + 20 = 30`
- **Result**: Confirmed via Register File inspection (`x3` = `0x1E`).

## 🛠️ How to Run
### Prerequisites
- **Icarus Verilog** (`iverilog`)
- **GTKWave** (Optional, for waveform viewing)

### Quick Start
1.  **Clone the Repository**:
    ```bash
    git clone https://github.com/your-username/GMSK-V1.git
    cd GMSK-V1
    ```

2.  **Run Simulation**:
    ```bash
    make sim
    ```
    *Output should show the core fetching instructions and registers updating.*

3.  **View Waveforms**:
    ```bash
    make wave
    ```

## 📂 Project Structure
```text
.
├── src/
│   ├── gmsk_v1_soc.v      # Top-level SoC Wrapper
│   ├── program_memory.v   # Instruction RAM (ROM)
│   ├── program.hex        # Machine Code
│   └── cv32e40p/          # Core RTL
├── tests/
│   └── gmsk_v1_tb.v       # SystemVerilog Testbench
└── Makefile               # Build System
```

## 📜 License
This project utilizes the CV32E40P core (Solderpad/Apache 2.0).
GMSK Architecture © 2026 Gooty Mohammed Sameer Khan.
