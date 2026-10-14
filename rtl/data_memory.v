module data_memory (
    input         clk,
    
    // Control signals from CPU Control Unit
    input         mem_write,
    input         mem_read,
    
    // Addresses and Data from the CPU Datapath
    input  [31:0] address,
    input  [31:0] write_data,
    output [31:0] read_data
);

    // Create a memory array: 256 lines deep, 32 bits wide per line
    reg [31:0] ram [0:1023];

    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            ram[i] = 32'd0;
        end
    end

    // 1. Synchronous Write
    always @(posedge clk) begin
        if (mem_write) begin
            ram[address[7:0]] <= write_data;
        end
    end

    // 2. Combinational Read
    // If mem_read is HIGH, output the data. Otherwise, output 0 to keep the bus clean.
    assign read_data = (mem_read) ? ram[address[7:0]] : 32'd0;

endmodule
