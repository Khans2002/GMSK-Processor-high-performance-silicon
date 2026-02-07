module program_memory (
    input wire clk,
    input wire rst_n,
    input wire req,
    input wire [31:0] addr,
    output reg [31:0] rdata,
    output reg rvalid,
    output wire gnt
);

    // 1KB Memory (256 words x 32 bits)
    // Addr[31:2] is the word index (ignoring byte alignment bits 1:0)
    // We mask to [9:2] to fit 256 words (8 bits of index)
    reg [31:0] mem [0:255];

    // Grant immediately (Combinational/0-latency for simplicity)
    assign gnt = req;

    initial begin
        // Initialize memory with zeros
        integer i;
        for (i=0; i<256; i=i+1) mem[i] = 32'h00000013; // Fill with NOPs

        // Load the actual program
        $readmemh("src/program.hex", mem);
    end

    // Read Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rvalid <= 0;
            rdata <= 32'b0;
        end else begin
            if (req) begin
                // Fetch data (Simulate 1 cycle latency if needed, 
                // but CV32E40P can accept rvalid next cycle)
                rvalid <= 1;
                // Use limited address bits to prevent out-of-bounds
                // Subtract base address 0x00 and shift by 2
               rdata <= mem[(addr >> 2) & 8'hFF]; 
            end else begin
                rvalid <= 0;
            end
        end
    end

endmodule
