module instruction_memory #(
    parameter MEM_FILE = ""
) (
    input  [31:0] pc,
    output [31:0] instruction
);

    // Create a memory array: 256 lines deep, 32 bits wide per line
    reg [31:0] rom [0:255];

    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            rom[i] = 32'h00000013; // NOP (addi x0, x0, 0)
        end
        if (MEM_FILE != "") begin
            $readmemh(MEM_FILE, rom);
        end
    end

    // Combinational Read: Grab the instruction at the current PC address.
    // We use pc[7:0] because our memory is only 256 words deep (which requires 8 bits to address).
    assign instruction = rom[pc[7:0]]; 

endmodule
