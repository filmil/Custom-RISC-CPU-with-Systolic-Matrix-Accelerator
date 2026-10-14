// SPDX-License-Identifier: Apache-2.0
module arty_top #(
    parameter ROM_FILE = "",
    parameter RAM_FILE = ""
) (
    input  wire       CLK100MHZ,
    input  wire       ck_rst,
    output wire [3:0] led
);
    // Active-high reset for internal logic (ck_rst is active low on Arty A7)
    wire rst = ~ck_rst;

    wire        cpu_stall;
    wire [31:0] pc;
    wire [31:0] mem_addr;
    wire [31:0] mem_write_data;
    wire        mem_write;

    pixel_processor_top #(
        .ROM_FILE(ROM_FILE),
        .RAM_FILE(RAM_FILE)
    ) u_proc (
        .clk            (CLK100MHZ),
        .rst            (rst),
        .cpu_stall      (cpu_stall),
        .pc             (pc),
        .mem_addr       (mem_addr),
        .mem_write_data (mem_write_data),
        .mem_write      (mem_write)
    );

    // Map system activity to the 4 user LEDs:
    // led[0]: CPU active (not stalled)
    // led[1]: Coprocessor FSM stall asserted
    // led[2]: RAM write enable strobe
    // led[3]: PC activity bit (pc[4])
    assign led[0] = ~cpu_stall;
    assign led[1] = cpu_stall;
    assign led[2] = mem_write;
    assign led[3] = pc[4];

endmodule
