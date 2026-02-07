# GMSK-V1 Makefile

# Tools - Use iverilog with SystemVerilog support (-g2012)
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

# Source Files
# 1. Packages (MUST BE COMPILED DOMINANTLY FIRST)
PKG_SRC = src/cv32e40p/rtl/include/cv32e40p_pkg.sv \
          src/cv32e40p/rtl/include/cv32e40p_apu_core_pkg.sv \
          src/cv32e40p/rtl/include/cv32e40p_fpu_pkg.sv

# 2. The Core (Explicitly exclude latch-based regfile and FPU to avoid conflicts)
CORE_SRC = src/cv32e40p/rtl/cv32e40p_alu.sv \
           src/cv32e40p/rtl/cv32e40p_alu_div.sv \
           src/cv32e40p/rtl/cv32e40p_apu_disp.sv \
           src/cv32e40p/rtl/cv32e40p_compressed_decoder.sv \
           src/cv32e40p/rtl/cv32e40p_controller.sv \
           src/cv32e40p/rtl/cv32e40p_core.sv \
           src/cv32e40p/rtl/cv32e40p_cs_registers.sv \
           src/cv32e40p/rtl/cv32e40p_decoder.sv \
           src/cv32e40p/rtl/cv32e40p_ex_stage.sv \
           src/cv32e40p/rtl/cv32e40p_ff_one.sv \
           src/cv32e40p/rtl/cv32e40p_fifo.sv \
           src/cv32e40p/rtl/cv32e40p_hwloop_regs.sv \
           src/cv32e40p/rtl/cv32e40p_id_stage.sv \
           src/cv32e40p/rtl/cv32e40p_if_stage.sv \
           src/cv32e40p/rtl/cv32e40p_int_controller.sv \
           src/cv32e40p/rtl/cv32e40p_load_store_unit.sv \
           src/cv32e40p/rtl/cv32e40p_mult.sv \
           src/cv32e40p/rtl/cv32e40p_obi_interface.sv \
           src/cv32e40p/rtl/cv32e40p_popcnt.sv \
           src/cv32e40p/rtl/cv32e40p_prefetch_buffer.sv \
           src/cv32e40p/rtl/cv32e40p_prefetch_controller.sv \
           src/cv32e40p/rtl/cv32e40p_register_file_ff.sv \
           src/cv32e40p/rtl/cv32e40p_sleep_unit.sv \
           src/cv32e40p/rtl/cv32e40p_top.sv \
           src/cv32e40p/rtl/cv32e40p_aligner.sv \
           src/cv32e40p/bhv/cv32e40p_sim_clock_gate.sv
           
# 3. Our Wrapper
WRAPPER_SRC = src/gmsk_v1_soc.v src/program_memory.v

# 4. Testbench
TB_SRC = tests/gmsk_v1_tb.v

# Output Binary
OUT = tests/gmsk_v1.vvp

# Include Paths (Critical for SV packages)
INCLUDES = -I src/cv32e40p/rtl/include

all: sim

sim:
	@echo "Compiling GMSK-V1 (CV32E40P Core)..."
	$(IVERILOG) -g2012 $(INCLUDES) -o $(OUT) $(PKG_SRC) $(CORE_SRC) $(WRAPPER_SRC) $(TB_SRC)
	@echo "Running Simulation..."
	$(VVP) $(OUT)

wave:
	$(GTKWAVE) tests/gmsk_v1.vcd &
