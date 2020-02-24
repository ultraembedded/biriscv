
module tcm_mem_ram
(
    // Inputs
     input           clk0_i
    ,input           rst0_i
    ,input  [ 13:0]  addr0_i
    ,input  [ 63:0]  data0_i
    ,input  [  7:0]  wr0_i
    ,input           clk1_i
    ,input           rst1_i
    ,input  [ 13:0]  addr1_i
    ,input  [ 63:0]  data1_i
    ,input  [  7:0]  wr1_i

    // Outputs
    ,output [ 63:0]  data0_o
    ,output [ 63:0]  data1_o
);



//-----------------------------------------------------------------
// Dual Port RAM 128KB
// Mode: Read First
//-----------------------------------------------------------------
/* verilator lint_off MULTIDRIVEN */
reg [63:0]   ram [16383:0] /*verilator public*/;
/* verilator lint_on MULTIDRIVEN */

reg [63:0] ram_read0_q;
reg [63:0] ram_read1_q;


// Synchronous write
always @ (posedge clk0_i)
begin
    if (wr0_i[0])
        ram[addr0_i][7:0] <= data0_i[7:0];
    if (wr0_i[1])
        ram[addr0_i][15:8] <= data0_i[15:8];
    if (wr0_i[2])
        ram[addr0_i][23:16] <= data0_i[23:16];
    if (wr0_i[3])
        ram[addr0_i][31:24] <= data0_i[31:24];
    if (wr0_i[4])
        ram[addr0_i][39:32] <= data0_i[39:32];
    if (wr0_i[5])
        ram[addr0_i][47:40] <= data0_i[47:40];
    if (wr0_i[6])
        ram[addr0_i][55:48] <= data0_i[55:48];
    if (wr0_i[7])
        ram[addr0_i][63:56] <= data0_i[63:56];

    ram_read0_q <= ram[addr0_i];
end

always @ (posedge clk1_i)
begin
    if (wr1_i[0])
        ram[addr1_i][7:0] <= data1_i[7:0];
    if (wr1_i[1])
        ram[addr1_i][15:8] <= data1_i[15:8];
    if (wr1_i[2])
        ram[addr1_i][23:16] <= data1_i[23:16];
    if (wr1_i[3])
        ram[addr1_i][31:24] <= data1_i[31:24];
    if (wr1_i[4])
        ram[addr1_i][39:32] <= data1_i[39:32];
    if (wr1_i[5])
        ram[addr1_i][47:40] <= data1_i[47:40];
    if (wr1_i[6])
        ram[addr1_i][55:48] <= data1_i[55:48];
    if (wr1_i[7])
        ram[addr1_i][63:56] <= data1_i[63:56];

    ram_read1_q <= ram[addr1_i];
end

assign data0_o = ram_read0_q;
assign data1_o = ram_read1_q;



endmodule
