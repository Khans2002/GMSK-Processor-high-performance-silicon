// GMSK-V1: Core Verification Testbench
// Author: Gooty Mohammed Sameer Khan

`timescale 1ns / 1ps

module gmsk_v1_tb;

    reg clk;
    reg rst_n;
    wire [31:0] pc;

    // Instantiate the SOC Wrapper
    gmsk_v1_soc uut (
        .clk(clk),
        .rst_n(rst_n),
        .current_pc(pc)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Monitor Register Writes
    // We "peek" into the core's register file using hierarchical paths
    // Monitor Port A
    wire        rf_we_a;
    wire [4:0]  rf_waddr_a;
    wire [31:0] rf_wdata_a;
    
    assign rf_we_a    = uut.core.core_i.id_stage_i.register_file_i.we_a_i;
    assign rf_waddr_a = uut.core.core_i.id_stage_i.register_file_i.waddr_a_i;
    assign rf_wdata_a = uut.core.core_i.id_stage_i.register_file_i.wdata_a_i;

    // Monitor Port B
    wire        rf_we_b;
    wire [4:0]  rf_waddr_b;
    wire [31:0] rf_wdata_b;

    assign rf_we_b    = uut.core.core_i.id_stage_i.register_file_i.we_b_i;
    assign rf_waddr_b = uut.core.core_i.id_stage_i.register_file_i.waddr_b_i;
    assign rf_wdata_b = uut.core.core_i.id_stage_i.register_file_i.wdata_b_i;

    // Monitor PC, Instruction, and Register Writes (Both Ports)
    initial begin
        $monitor("T=%0t | PC=%h | Instr=%h | A:%b x%0d=%h | B:%b x%0d=%h", 
                 $time, pc, uut.instr_rdata, 
                 rf_we_a, rf_waddr_a, rf_wdata_a,
                 rf_we_b, rf_waddr_b, rf_wdata_b);
    end

    initial begin
        $dumpfile("tests/gmsk_v1.vcd");
        $dumpvars(0, gmsk_v1_tb);

        // Reset Sequence
        rst_n = 0; // Reset Active (Low)
        #20;
        rst_n = 1; // Release Reset
        
        $display("------------------------------------------------");
        $display(" GMSK-V1 (CV32E40P) Simulation Started");
        $display("------------------------------------------------");

        // Run simulation
        #200;

        $display("PC Check: %h", pc);
        
        if (pc != 32'b0) begin
            $display("SUCCESS: Core is fetching instructions! 🚀");
        end else begin
            $display("WARNING: PC did not move. Core might be asleep.");
        end

        $finish;
    end

endmodule
