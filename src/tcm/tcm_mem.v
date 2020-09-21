//-----------------------------------------------------------------
//                         biRISC-V CPU
//                            V0.6.0
//                     Ultra-Embedded.com
//                     Copyright 2019-2020
//
//                   admin@ultra-embedded.com
//
//                     License: Apache 2.0
//-----------------------------------------------------------------
// Copyright 2020 Ultra-Embedded.com
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//-----------------------------------------------------------------

module tcm_mem #(
     parameter TCM_ROM_SIZE         = 'd16384,
     parameter TCM_RAM_SIZE         = 'd49152
)
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           mem_i_rd_i
    ,input           mem_i_flush_i
    ,input           mem_i_invalidate_i
    ,input  [ 31:0]  mem_i_pc_i
    ,input  [ 31:0]  mem_d_addr_i
    ,input  [ 31:0]  mem_d_data_wr_i
    ,input           mem_d_rd_i
    ,input  [  3:0]  mem_d_wr_i
    ,input           mem_d_cacheable_i
    ,input  [ 10:0]  mem_d_req_tag_i
    ,input           mem_d_invalidate_i
    ,input           mem_d_writeback_i
    ,input           mem_d_flush_i
    ,input           axi_awvalid_i
    ,input  [ 31:0]  axi_awaddr_i
    ,input  [  3:0]  axi_awid_i
    ,input  [  7:0]  axi_awlen_i
    ,input  [  1:0]  axi_awburst_i
    ,input           axi_wvalid_i
    ,input  [ 31:0]  axi_wdata_i
    ,input  [  3:0]  axi_wstrb_i
    ,input           axi_wlast_i
    ,input           axi_bready_i
    ,input           axi_arvalid_i
    ,input  [ 31:0]  axi_araddr_i
    ,input  [  3:0]  axi_arid_i
    ,input  [  7:0]  axi_arlen_i
    ,input  [  1:0]  axi_arburst_i
    ,input           axi_rready_i

    // Outputs
    ,output          mem_i_accept_o
    ,output          mem_i_valid_o
    ,output          mem_i_error_o
    ,output [ 63:0]  mem_i_inst_o
    ,output [ 31:0]  mem_d_data_rd_o
    ,output          mem_d_accept_o
    ,output          mem_d_ack_o
    ,output          mem_d_error_o
    ,output [ 10:0]  mem_d_resp_tag_o
    ,output          axi_awready_o
    ,output          axi_wready_o
    ,output          axi_bvalid_o
    ,output [  1:0]  axi_bresp_o
    ,output [  3:0]  axi_bid_o
    ,output          axi_arready_o
    ,output          axi_rvalid_o
    ,output [ 31:0]  axi_rdata_o
    ,output [  1:0]  axi_rresp_o
    ,output [  3:0]  axi_rid_o
    ,output          axi_rlast_o
);



//-------------------------------------------------------------
// AXI -> PMEM Interface
//-------------------------------------------------------------
wire          ext_accept_w;
wire          ext_ack_w;
wire [ 31:0]  ext_read_data_w;
wire [  3:0]  ext_wr_w;
wire          ext_rd_w;
wire [  7:0]  ext_len_w;
wire [ 31:0]  ext_addr_w;
wire [ 31:0]  ext_write_data_w;

tcm_mem_pmem
u_conv
(
    // Inputs
    .clk_i(clk_i),
    .rst_i(rst_i),
    .axi_awvalid_i(axi_awvalid_i),
    .axi_awaddr_i(axi_awaddr_i),
    .axi_awid_i(axi_awid_i),
    .axi_awlen_i(axi_awlen_i),
    .axi_awburst_i(axi_awburst_i),
    .axi_wvalid_i(axi_wvalid_i),
    .axi_wdata_i(axi_wdata_i),
    .axi_wstrb_i(axi_wstrb_i),
    .axi_wlast_i(axi_wlast_i),
    .axi_bready_i(axi_bready_i),
    .axi_arvalid_i(axi_arvalid_i),
    .axi_araddr_i(axi_araddr_i),
    .axi_arid_i(axi_arid_i),
    .axi_arlen_i(axi_arlen_i),
    .axi_arburst_i(axi_arburst_i),
    .axi_rready_i(axi_rready_i),
    .ram_accept_i(ext_accept_w),
    .ram_ack_i(ext_ack_w),
    .ram_error_i(1'b0),
    .ram_read_data_i(ext_read_data_w),

    // Outputs
    .axi_awready_o(axi_awready_o),
    .axi_wready_o(axi_wready_o),
    .axi_bvalid_o(axi_bvalid_o),
    .axi_bresp_o(axi_bresp_o),
    .axi_bid_o(axi_bid_o),
    .axi_arready_o(axi_arready_o),
    .axi_rvalid_o(axi_rvalid_o),
    .axi_rdata_o(axi_rdata_o),
    .axi_rresp_o(axi_rresp_o),
    .axi_rid_o(axi_rid_o),
    .axi_rlast_o(axi_rlast_o),
    .ram_wr_o(ext_wr_w),
    .ram_rd_o(ext_rd_w),
    .ram_len_o(ext_len_w),
    .ram_addr_o(ext_addr_w),
    .ram_write_data_o(ext_write_data_w)
);

//-------------------------------------------------------------
// Dual Port RAM
//-------------------------------------------------------------

// Mux access to the 2nd port between external access and CPU data access
wire                 muxed_hi_w   = ext_accept_w ? ext_addr_w[2] : mem_d_addr_i[2];
wire [12:0] muxed_addr_w = ext_accept_w ? ext_addr_w[15:3] : mem_d_addr_i[15:3];
wire [31:0] muxed_data_w = ext_accept_w ? ext_write_data_w : mem_d_data_wr_i;
wire [3:0]  muxed_wr_w   = ext_accept_w ? ext_wr_w         : mem_d_wr_i;
wire [63:0] data_r_w;
wire [63:0] data_r_w_ram;
wire [63:0] data_r_rom;
wire [63:0] mem_i_inst_ram;
wire [63:0] mem_i_inst_rom;
wire access_ram = muxed_addr_w>=TCM_ROM_SIZE/8;
tcm_mem_ram #(
     .TCM_RAM_SIZE(TCM_RAM_SIZE))
u_ram
(
    // Instruction fetch
     .clk0_i(clk_i)
    ,.rst0_i(rst_i)
    ,.addr0_i(mem_i_pc_i[15:3])
    ,.data0_i(64'b0)
    ,.wr0_i(8'b0)

    // External access / Data access
    ,.clk1_i(clk_i)
    ,.rst1_i(rst_i)
    ,.addr1_i((access_ram) ? {muxed_addr_w- TCM_ROM_SIZE/8}                               : 'b0)//Altus: Disable write when accessing ROM, adjust address
    ,.data1_i((access_ram) ? (muxed_hi_w ? {muxed_data_w, 32'b0} : {32'b0, muxed_data_w}) : 'b0)//Altus: Disable write when accessing ROM
    ,.wr1_i  ((access_ram) ? (muxed_hi_w ? {muxed_wr_w,    4'b0} : {4'b0, muxed_wr_w   }) : 'b0)//Altus: Disable write when accessing ROM

    // Outputs
    ,.data0_o(mem_i_inst_ram)
    ,.data1_o(data_r_w_ram)
);

tcm_mem_rom #(
     .ROM_SIZE(TCM_ROM_SIZE)
)
u_rom
(
    // Instruction fetch
     .clk0_i(clk_i)
    ,.addr0_i(mem_i_pc_i[15:3])

    // External access / Data access
    ,.clk1_i(clk_i)
    ,.addr1_i(muxed_addr_w)

    // Outputs
    ,.data0_o(mem_i_inst_rom)
    ,.data1_o(data_r_rom)
);

assign mem_i_inst_o = (mem_i_pc_i[15:3]>=TCM_ROM_SIZE/8) ? mem_i_inst_ram : mem_i_inst_rom;//Altus: Select data source RAM/ROM

reg muxed_hi_q;
reg [12:0] muxed_addr_q; //Altus: Sample address to select data out between ROM and RAM 

always @ (posedge clk_i or posedge rst_i)
    if (rst_i) begin
    muxed_hi_q   <= 1'b0;
    muxed_addr_q <= 'b0;
    end
    else begin
    muxed_hi_q <= muxed_hi_w;
    muxed_addr_q <= muxed_addr_w;//Altus: Sample address to select data out between ROM and RAM 
    end

assign data_r_w     = (muxed_addr_q >=TCM_ROM_SIZE/8)    ? data_r_w_ram   : data_r_rom    ;//Altus: Select data source RAM/ROM
assign ext_read_data_w = muxed_hi_q ? data_r_w[63:32] : data_r_w[31:0];

//-------------------------------------------------------------
// Instruction Fetch
//-------------------------------------------------------------
reg        mem_i_valid_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    mem_i_valid_q <= 1'b0;
else
    mem_i_valid_q <= mem_i_rd_i;

assign mem_i_accept_o  = 1'b1;
assign mem_i_valid_o   = mem_i_valid_q;
assign mem_i_error_o   = 1'b0;

//-------------------------------------------------------------
// Data Access / Incoming external access
//-------------------------------------------------------------
reg        mem_d_accept_q;
reg [10:0] mem_d_tag_q;
reg        mem_d_ack_q;
reg        ext_ack_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    mem_d_accept_q <= 1'b1;
// External request, do not accept internal requests in next cycle
else if (ext_rd_w || ext_wr_w != 4'b0)
    mem_d_accept_q <= 1'b0;
else
    mem_d_accept_q <= 1'b1;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
begin
    mem_d_ack_q    <= 1'b0;
    mem_d_tag_q    <= 11'b0;
end
else if ((mem_d_rd_i || mem_d_wr_i != 4'b0 || mem_d_flush_i || mem_d_invalidate_i || mem_d_writeback_i) && mem_d_accept_o)
begin
    mem_d_ack_q    <= 1'b1;
    mem_d_tag_q    <= mem_d_req_tag_i;
end
else
    mem_d_ack_q    <= 1'b0;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    ext_ack_q <= 1'b0;
// External request accepted
else if ((ext_rd_w || ext_wr_w != 4'b0) && ext_accept_w)
    ext_ack_q <= 1'b1;
else
    ext_ack_q <= 1'b0;

assign mem_d_ack_o          = mem_d_ack_q;
assign mem_d_resp_tag_o     = mem_d_tag_q;
assign mem_d_data_rd_o      = muxed_hi_q ? data_r_w[63:32] : data_r_w[31:0];
assign mem_d_error_o        = 1'b0;

assign mem_d_accept_o       = mem_d_accept_q;
assign ext_accept_w         = !mem_d_accept_q;
assign ext_ack_w            = ext_ack_q;

`ifdef verilator
//-------------------------------------------------------------
// write: Write byte into memory
//-------------------------------------------------------------
function write; /*verilator public*/
    input [31:0] addr;
    input [7:0]  data;
    reg  [31:0] addr_int;
begin
    if(addr>=TCM_ROM_SIZE) begin
    	addr_int=addr-TCM_ROM_SIZE;
   	case (addr_int[2:0])
    	3'd0: u_ram.ram[addr_int/8][7:0]  = data;
    	3'd1: u_ram.ram[addr_int/8][15:8]  = data;
    	3'd2: u_ram.ram[addr_int/8][23:16] = data;
    	3'd3: u_ram.ram[addr_int/8][31:24] = data;
    	3'd4: u_ram.ram[addr_int/8][39:32] = data;
    	3'd5: u_ram.ram[addr_int/8][47:40] = data;
    	3'd6: u_ram.ram[addr_int/8][55:48] = data;
    	3'd7: u_ram.ram[addr_int/8][63:56] = data;
    	endcase
    end
    else
	case (addr[2:0])
    	3'd0: u_rom.rom[addr/8][7:0]   = data;
    	3'd1: u_rom.rom[addr/8][15:8]  = data;
    	3'd2: u_rom.rom[addr/8][23:16] = data;
    	3'd3: u_rom.rom[addr/8][31:24] = data;
    	3'd4: u_rom.rom[addr/8][39:32] = data;
    	3'd5: u_rom.rom[addr/8][47:40] = data;
    	3'd6: u_rom.rom[addr/8][55:48] = data;
    	3'd7: u_rom.rom[addr/8][63:56] = data;
    	endcase
 //$display ("%h(%h, %h) ",u_rom.rom[addr/8],addr/8,data);

end
endfunction
//-------------------------------------------------------------
// read: Read byte from memory
//-------------------------------------------------------------
function [7:0] read; /*verilator public*/
    input [31:0] addr;
    reg  [31:0] addr_int;
begin
    if(addr>=TCM_ROM_SIZE) begin
    	addr_int=addr-TCM_ROM_SIZE;
    	case (addr_int[2:0])
    	3'd0: read = u_ram.ram[addr_int/8][7:0];
    	3'd1: read = u_ram.ram[addr_int/8][15:8];
    	3'd2: read = u_ram.ram[addr_int/8][23:16];
    	3'd3: read = u_ram.ram[addr_int/8][31:24];
    	3'd4: read = u_ram.ram[addr_int/8][39:32];
    	3'd5: read = u_ram.ram[addr_int/8][47:40];
    	3'd6: read = u_ram.ram[addr_int/8][55:48];
    	3'd7: read = u_ram.ram[addr_int/8][63:56];
    	endcase
     end 
     else
	case (addr[2:0])
    	3'd0: read = u_rom.rom[addr/8][7:0];
    	3'd1: read = u_rom.rom[addr/8][15:8];
    	3'd2: read = u_rom.rom[addr/8][23:16];
    	3'd3: read = u_rom.rom[addr/8][31:24];
    	3'd4: read = u_rom.rom[addr/8][39:32];
    	3'd5: read = u_rom.rom[addr/8][47:40];
    	3'd6: read = u_rom.rom[addr/8][55:48];
    	3'd7: read = u_rom.rom[addr/8][63:56];
    	endcase
end
endfunction
`endif



endmodule
