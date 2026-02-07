// GMSK-V1: System-on-Chip Wrapper (The Interface)
// Author: Gooty Mohammed Sameer Khan
// Description: Wraps the complex CV32E40P core into a simple interface for Sameer OS

module gmsk_v1_soc (
    input wire clk,
    input wire rst_n,  // Active Low Reset
    output wire [31:0] current_pc
);

    // ==========================================
    // Internal Wires for Core Connection
    // ==========================================
    
    // Instruction Interface
    wire        instr_req;
    wire        instr_gnt;
    wire        instr_rvalid;
    wire [31:0] instr_addr;
    wire [31:0] instr_rdata;

    // Data Interface (Unused for now)
    wire        data_req;
    wire        data_gnt;
    wire        data_rvalid;
    wire        data_we;
    wire [3:0]  data_be;
    wire [31:0] data_addr;
    wire [31:0] data_wdata;
    wire [31:0] data_rdata;

    // Output PC for debugging
    assign current_pc = instr_addr;

    // ==========================================
    // 1. Instantiate the Beast (CV32E40P)
    // ==========================================
    cv32e40p_top #(
        .COREV_PULP(0),       // Standard RISC-V only
        .COREV_CLUSTER(0),
        .FPU(0),              // No Floating Point Unit yet
        .FPU_ADDMUL_LAT(0),
        .FPU_OTHERS_LAT(0),
        .ZFINX(0),
        .NUM_MHPMCOUNTERS(1)
    ) core (
        // Clock and Reset
        .clk_i(clk),
        .rst_ni(rst_n),
        .pulp_clock_en_i(1'b0),
        .scan_cg_en_i(1'b0),

        // Boot Address (Where to start?)
        .boot_addr_i(32'h00000000),
        .mtvec_addr_i(32'h00000000),
        .dm_halt_addr_i(32'h00000000),
        .hart_id_i(32'h00000000),
        .dm_exception_addr_i(32'h00000000),

        // Instruction Interface
        .instr_req_o(instr_req),
        .instr_gnt_i(instr_gnt),      // We must decide when to grant
        .instr_rvalid_i(instr_rvalid), // We must say data is valid
        .instr_addr_o(instr_addr),
        .instr_rdata_i(instr_rdata),

        // Data Interface (Tie off for now)
        .data_req_o(data_req),
        .data_gnt_i(1'b1),        // Always grant access
        .data_rvalid_i(1'b0),     // No data returning yet
        .data_we_o(data_we),
        .data_be_o(data_be),
        .data_addr_o(data_addr),
        .data_wdata_o(data_wdata),
        .data_rdata_i(32'b0),

        // Interrupts (No IRQs yet)
        .irq_i(32'b0),
        .irq_ack_o(),
        .irq_id_o(),

        // Debug (No JTAG yet)
        .debug_req_i(1'b0),
        .debug_havereset_o(),
        .debug_running_o(),
        .debug_halted_o(),

        // Control
        .fetch_enable_i(1'b1), // Tell it to RUN!
        .core_sleep_o()
    );

    // ==========================================
    // 2. Real Instruction Memory (ROM)
    // ==========================================
    program_memory instr_mem (
        .clk(clk),
        .rst_n(rst_n),
        .req(instr_req),
        .addr(instr_addr),
        .rdata(instr_rdata),
        .rvalid(instr_rvalid),
        .gnt(instr_gnt)
    ); 

endmodule
