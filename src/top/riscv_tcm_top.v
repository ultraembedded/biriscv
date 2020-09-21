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
//History
//-----------------------------------------------------------------
//2020/9/10 Altus: Change _i_ interface to Master, _t_ interafce to Slave
//2020/9/10 Altus: Expand AXI lite to AXI
//
//
module riscv_tcm_top
//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
#(
     parameter BOOT_VECTOR      = 32'h0000_0000
    ,parameter CORE_ID          = 0
    ,parameter TCM_MEM_BASE     = 32'h0000_0000
    ,parameter TCM_ROM_SIZE     = 16'h4000       //Altus: Add ROM
    ,parameter TCM_RAM_SIZE     = 16'hC000       //Altus: Add ROM, Set TCM size
    ,parameter SUPPORT_BRANCH_PREDICTION = 1
    ,parameter SUPPORT_MULDIV   = 1
    ,parameter SUPPORT_SUPER    = 0
    ,parameter SUPPORT_MMU      = 0
    ,parameter SUPPORT_DUAL_ISSUE = 1
    ,parameter SUPPORT_LOAD_BYPASS = 1
    ,parameter SUPPORT_MUL_BYPASS = 1
    ,parameter SUPPORT_REGFILE_XILINX = 0
    ,parameter EXTRA_DECODE_STAGE = 0
    ,parameter MEM_CACHE_ADDR_MIN = 32'h80000000
    ,parameter MEM_CACHE_ADDR_MAX = 32'hffffffff
    ,parameter NUM_BTB_ENTRIES  = 32
    ,parameter NUM_BTB_ENTRIES_W = 5
    ,parameter NUM_BHT_ENTRIES  = 512
    ,parameter NUM_BHT_ENTRIES_W = 9
    ,parameter RAS_ENABLE       = 1
    ,parameter GSHARE_ENABLE    = 0
    ,parameter BHT_ENABLE       = 1
    ,parameter NUM_RAS_ENTRIES  = 8
    ,parameter NUM_RAS_ENTRIES_W = 3
)
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
(
    // Clock, Reset, Interrupts
     input           clk
    ,input           rst
    ,input           rst_cpu
    ,input  [ 31:0]  intr

    // AXI Master
    ,output [ 3:0]   riscv_mst_awid     //Altus expand to AXI
    ,output [ 31:0]  riscv_mst_awaddr
    ,output [ 7:0]   riscv_mst_awlen    //Altus expand to AXI
    ,output [ 2:0]   riscv_mst_awsize   //Altus expand to AXI
    ,output [ 1:0]   riscv_mst_awburst  //Altus expand to AXI
    ,output [ 3:0]   riscv_mst_awcache  //Altus expand to AXI
    ,output [ 2:0]   riscv_mst_awprot   //Altus expand to AXI
    ,output [ 3:0]   riscv_mst_awqos    //Altus expand to AXI
    ,output [ 3:0]   riscv_mst_awregion //Altus expand to AXI
    //,output [ 5:0]   riscv_mst_awatop   //Altus expand to AXI - not used
    //,output          riscv_mst_awuser   //Altus expand to AXI - not used
    ,output          riscv_mst_awvalid
    ,input           riscv_mst_awready

    ,output [ 31:0]  riscv_mst_wdata
    ,output [  3:0]  riscv_mst_wstrb
    ,output          riscv_mst_wlast   //Altus expand to AXI
    //,output          riscv_mst_wuser   //Altus expand to AXI - not used
    ,output          riscv_mst_wvalid
    ,input           riscv_mst_wready

    ,input  [  1:0]  riscv_mst_bresp
    ,input           riscv_mst_bvalid
    ,output          riscv_mst_bready

    ,output [ 3:0]   riscv_mst_arid     //Altus expand to AXI
    ,output [ 31:0]  riscv_mst_araddr
    ,output [ 7:0]   riscv_mst_arlen    //Altus expand to AXI
    ,output [ 2:0]   riscv_mst_arsize   //Altus expand to AXI
    ,output [ 1:0]   riscv_mst_arburst  //Altus expand to AXI
    ,output          riscv_mst_arlock   //Altus expand to AXI
    ,output [ 3:0]   riscv_mst_arcache  //Altus expand to AXI
    ,output [ 2:0]   riscv_mst_arprot   //Altus expand to AXI
    ,output [ 3:0]   riscv_mst_arqos    //Altus expand to AXI
    ,output [ 3:0]   riscv_mst_arregion //Altus expand to AXI
    //,output          riscv_mst_aruser   //Altus expand to AXI - not used
    ,output          riscv_mst_arvalid
    ,input           riscv_mst_arready
    
    ,input  [ 31:0]  riscv_mst_rdata
    ,input  [  1:0]  riscv_mst_rresp
    ,input           riscv_mst_rvalid
    ,output          riscv_mst_rready
       
    // AXI Slave
    ,input  [  3:0]  riscv_slv_awid
    ,input  [ 31:0]  riscv_slv_awaddr
    ,input  [  7:0]  riscv_slv_awlen
    ,input  [  2:0]  riscv_slv_awsize  //Altus expand to AXI
    ,input  [  1:0]  riscv_slv_awburst
    ,input  [  3:0]  riscv_slv_awcache  //Altus expand to AXI
    ,input  [  2:0]  riscv_slv_awprot   //Altus expand to AXI
    ,input  [  3:0]  riscv_slv_awqos    //Altus expand to AXI
    ,input  [  3:0]  riscv_slv_awregion //Altus expand to AXI
    //,input  [  5:0]  riscv_slv_awatop   //Altus expand to AXI - not used
    //,input           riscv_slv_awuser   //Altus expand to AXI - not used
    ,input           riscv_slv_awvalid
    ,output          riscv_slv_awready
    
    ,input  [ 31:0]  riscv_slv_wdata
    ,input  [  3:0]  riscv_slv_wstrb
    ,input           riscv_slv_wlast
    //,input           riscv_slv_wuser   //Altus expand to AXI - not used
    ,input           riscv_slv_wvalid
    ,output          riscv_slv_wready

    ,output [  1:0]  riscv_slv_bresp
    ,output          riscv_slv_bvalid
    ,input           riscv_slv_bready
    ,output [  3:0]  riscv_slv_bid     //Altus: Is it used?
 
    ,input  [  3:0]  riscv_slv_arid
    ,input  [ 31:0]  riscv_slv_araddr
    ,input  [  7:0]  riscv_slv_arlen
    ,input  [  2:0]  riscv_slv_arsize   //Altus expand to AXI
    ,input  [  1:0]  riscv_slv_arburst
    ,input           riscv_slv_arlock   //Altus expand to AXI
    ,input  [  3:0]  riscv_slv_arcache  //Altus expand to AXI
    ,input  [  2:0]  riscv_slv_arprot   //Altus expand to AXI
    ,input  [  3:0]  riscv_slv_arqos    //Altus expand to AXI
    ,input  [  3:0]  riscv_slv_arregion //Altus expand to AXI
    //,input           riscv_slv_aruser   //Altus expand to AXI - not used
    ,input           riscv_slv_arvalid
    ,output          riscv_slv_arready
    
    ,output [ 31:0]  riscv_slv_rdata
    ,output [  1:0]  riscv_slv_rresp
    ,output          riscv_slv_rvalid
    ,input           riscv_slv_rready
    ,output [  3:0]  riscv_slv_rid      //Altus: Is it used?
    ,output          riscv_slv_rlast    //Altus: Is it used?
);

wire  [ 31:0]  ifetch_pc_w;
wire  [ 31:0]  dport_tcm_data_rd_w;
wire           dport_tcm_cacheable_w;
wire           dport_flush_w;
wire  [  3:0]  dport_tcm_wr_w;
wire           ifetch_rd_w;
wire           dport_axi_accept_w;
wire           dport_cacheable_w;
wire           dport_tcm_flush_w;
wire  [ 10:0]  dport_resp_tag_w;
wire  [ 10:0]  dport_axi_resp_tag_w;
wire           ifetch_accept_w;
wire  [ 31:0]  dport_data_rd_w;
wire           dport_tcm_invalidate_w;
wire           dport_ack_w;
wire  [ 10:0]  dport_axi_req_tag_w;
wire  [ 31:0]  dport_data_wr_w;
wire           dport_invalidate_w;
wire  [ 10:0]  dport_tcm_req_tag_w;
wire  [ 31:0]  dport_tcm_addr_w;
wire           dport_axi_error_w;
wire           dport_tcm_ack_w;
wire           dport_tcm_rd_w;
wire  [ 10:0]  dport_tcm_resp_tag_w;
wire           dport_writeback_w;
wire  [ 31:0]  cpu_id_w = CORE_ID;
wire           dport_rd_w;
wire           dport_axi_ack_w;
wire           dport_axi_rd_w;
wire  [ 31:0]  dport_axi_data_rd_w;
wire           dport_axi_invalidate_w;
wire  [ 31:0]  boot_vector_w = BOOT_VECTOR;
wire  [ 31:0]  dport_addr_w;
wire           ifetch_error_w;
wire  [ 31:0]  dport_tcm_data_wr_w;
wire           ifetch_flush_w;
wire  [ 31:0]  dport_axi_addr_w;
wire           dport_error_w;
wire           dport_tcm_accept_w;
wire           ifetch_invalidate_w;
wire           dport_axi_writeback_w;
wire  [  3:0]  dport_wr_w;
wire           ifetch_valid_w;
wire  [ 31:0]  dport_axi_data_wr_w;
wire  [ 10:0]  dport_req_tag_w;
wire  [ 63:0]  ifetch_inst_w;
wire           dport_axi_cacheable_w;
wire           dport_tcm_writeback_w;
wire  [  3:0]  dport_axi_wr_w;
wire           dport_axi_flush_w;
wire           dport_tcm_error_w;
wire           dport_accept_w;

//Altus expand to AXI - _i_ I/F
assign   riscv_mst_awid     =4'b1000;//Altus expand to AXI
assign   riscv_mst_awlen    ='b0;//Altus expand to AXI
assign   riscv_mst_awsize   ='b0;//Altus expand to AXI
assign   riscv_mst_awburst  ='b0;//Altus expand to AXI
assign   riscv_mst_awcache  ='b0;//Altus expand to AXI
assign   riscv_mst_awprot   ='b0;//Altus expand to AXI
assign   riscv_mst_awqos    ='b0;//Altus expand to AXI
assign   riscv_mst_awregion ='b0;//Altus expand to AXI
//assign   riscv_mst_awatop   ='b0;//Altus expand to AXI - not used
//assign   riscv_mst_awuser   ='b0;//Altus expand to AXI - not used
assign   riscv_mst_wlast    ='b1;//Altus expand to AXI
//assign   riscv_mst_wuser    ='b0;//Altus expand to AXI - not used
assign   riscv_mst_arid     =4'b1001;//Altus expand to AXI
assign   riscv_mst_arlen    ='b0;//Altus expand to AXI
assign   riscv_mst_arsize   ='b0;//Altus expand to AXI
assign   riscv_mst_arburst  ='b0;//Altus expand to AXI
assign   riscv_mst_arlock   ='b0;//Altus expand to AXI
assign   riscv_mst_arcache  ='b0;//Altus expand to AXI
assign   riscv_mst_arprot   ='b0;//Altus expand to AXI
assign   riscv_mst_arqos    ='b0;//Altus expand to AXI
assign   riscv_mst_arregion ='b0;//Altus expand to AXI
//assign   riscv_mst_aruser   ='b0;//Altus expand to AXI - not used

riscv_core
#(
     .MEM_CACHE_ADDR_MIN(MEM_CACHE_ADDR_MIN)
    ,.MEM_CACHE_ADDR_MAX(MEM_CACHE_ADDR_MAX)
    ,.SUPPORT_BRANCH_PREDICTION(SUPPORT_BRANCH_PREDICTION)
    ,.SUPPORT_MULDIV(SUPPORT_MULDIV)
    ,.SUPPORT_SUPER(SUPPORT_SUPER)
    ,.SUPPORT_MMU(SUPPORT_MMU)
    ,.SUPPORT_DUAL_ISSUE(SUPPORT_DUAL_ISSUE)
    ,.SUPPORT_LOAD_BYPASS(SUPPORT_LOAD_BYPASS)
    ,.SUPPORT_MUL_BYPASS(SUPPORT_MUL_BYPASS)
    ,.SUPPORT_REGFILE_XILINX(SUPPORT_REGFILE_XILINX)
    ,.EXTRA_DECODE_STAGE(EXTRA_DECODE_STAGE)
    ,.NUM_BTB_ENTRIES(NUM_BTB_ENTRIES)
    ,.NUM_BTB_ENTRIES_W(NUM_BTB_ENTRIES_W)
    ,.NUM_BHT_ENTRIES(NUM_BHT_ENTRIES)
    ,.NUM_BHT_ENTRIES_W(NUM_BHT_ENTRIES_W)
    ,.RAS_ENABLE(RAS_ENABLE)
    ,.GSHARE_ENABLE(GSHARE_ENABLE)
    ,.BHT_ENABLE(BHT_ENABLE)
    ,.NUM_RAS_ENTRIES(NUM_RAS_ENTRIES)
    ,.NUM_RAS_ENTRIES_W(NUM_RAS_ENTRIES_W)
)
u_core
(
    // Inputs
     .clk_i(clk)
    ,.rst_i(rst_cpu)
    ,.mem_d_data_rd_i(dport_data_rd_w)
    ,.mem_d_accept_i(dport_accept_w)
    ,.mem_d_ack_i(dport_ack_w)
    ,.mem_d_error_i(dport_error_w)
    ,.mem_d_resp_tag_i(dport_resp_tag_w)
    ,.mem_i_accept_i(ifetch_accept_w)
    ,.mem_i_valid_i(ifetch_valid_w)
    ,.mem_i_error_i(ifetch_error_w)
    ,.mem_i_inst_i(ifetch_inst_w)
    ,.intr_i(|intr)
    ,.reset_vector_i(boot_vector_w)
    ,.cpu_id_i(cpu_id_w)

    // Outputs
    ,.mem_d_addr_o(dport_addr_w)
    ,.mem_d_data_wr_o(dport_data_wr_w)
    ,.mem_d_rd_o(dport_rd_w)
    ,.mem_d_wr_o(dport_wr_w)
    ,.mem_d_cacheable_o(dport_cacheable_w)
    ,.mem_d_req_tag_o(dport_req_tag_w)
    ,.mem_d_invalidate_o(dport_invalidate_w)
    ,.mem_d_writeback_o(dport_writeback_w)
    ,.mem_d_flush_o(dport_flush_w)
    ,.mem_i_rd_o(ifetch_rd_w)
    ,.mem_i_flush_o(ifetch_flush_w)
    ,.mem_i_invalidate_o(ifetch_invalidate_w)
    ,.mem_i_pc_o(ifetch_pc_w)
);


dport_mux
#(
     .TCM_MEM_BASE(TCM_MEM_BASE), 
     .TCM_RAM_SIZE(TCM_RAM_SIZE),
     .TCM_ROM_SIZE(TCM_ROM_SIZE)
)
u_dmux
(
    // Inputs
     .clk_i(clk)
    ,.rst_i(rst)
    ,.mem_addr_i(dport_addr_w)
    ,.mem_data_wr_i(dport_data_wr_w)
    ,.mem_rd_i(dport_rd_w)
    ,.mem_wr_i(dport_wr_w)
    ,.mem_cacheable_i(dport_cacheable_w)
    ,.mem_req_tag_i(dport_req_tag_w)
    ,.mem_invalidate_i(dport_invalidate_w)
    ,.mem_writeback_i(dport_writeback_w)
    ,.mem_flush_i(dport_flush_w)
    ,.mem_tcm_data_rd_i(dport_tcm_data_rd_w)
    ,.mem_tcm_accept_i(dport_tcm_accept_w)
    ,.mem_tcm_ack_i(dport_tcm_ack_w)
    ,.mem_tcm_error_i(dport_tcm_error_w)
    ,.mem_tcm_resp_tag_i(dport_tcm_resp_tag_w)
    ,.mem_ext_data_rd_i(dport_axi_data_rd_w)
    ,.mem_ext_accept_i(dport_axi_accept_w)
    ,.mem_ext_ack_i(dport_axi_ack_w)
    ,.mem_ext_error_i(dport_axi_error_w)
    ,.mem_ext_resp_tag_i(dport_axi_resp_tag_w)

    // Outputs
    ,.mem_data_rd_o(dport_data_rd_w)
    ,.mem_accept_o(dport_accept_w)
    ,.mem_ack_o(dport_ack_w)
    ,.mem_error_o(dport_error_w)
    ,.mem_resp_tag_o(dport_resp_tag_w)
    ,.mem_tcm_addr_o(dport_tcm_addr_w)
    ,.mem_tcm_data_wr_o(dport_tcm_data_wr_w)
    ,.mem_tcm_rd_o(dport_tcm_rd_w)
    ,.mem_tcm_wr_o(dport_tcm_wr_w)
    ,.mem_tcm_cacheable_o(dport_tcm_cacheable_w)
    ,.mem_tcm_req_tag_o(dport_tcm_req_tag_w)
    ,.mem_tcm_invalidate_o(dport_tcm_invalidate_w)
    ,.mem_tcm_writeback_o(dport_tcm_writeback_w)
    ,.mem_tcm_flush_o(dport_tcm_flush_w)
    ,.mem_ext_addr_o(dport_axi_addr_w)
    ,.mem_ext_data_wr_o(dport_axi_data_wr_w)
    ,.mem_ext_rd_o(dport_axi_rd_w)
    ,.mem_ext_wr_o(dport_axi_wr_w)
    ,.mem_ext_cacheable_o(dport_axi_cacheable_w)
    ,.mem_ext_req_tag_o(dport_axi_req_tag_w)
    ,.mem_ext_invalidate_o(dport_axi_invalidate_w)
    ,.mem_ext_writeback_o(dport_axi_writeback_w)
    ,.mem_ext_flush_o(dport_axi_flush_w)
);


tcm_mem
#(
     .TCM_RAM_SIZE(TCM_RAM_SIZE),
     .TCM_ROM_SIZE(TCM_ROM_SIZE)
)
u_tcm
(
    // Inputs
     .clk_i(clk)
    ,.rst_i(rst)
    ,.mem_i_rd_i(ifetch_rd_w)
    ,.mem_i_flush_i(ifetch_flush_w)
    ,.mem_i_invalidate_i(ifetch_invalidate_w)
    ,.mem_i_pc_i(ifetch_pc_w)
    ,.mem_d_addr_i(dport_tcm_addr_w)
    ,.mem_d_data_wr_i(dport_tcm_data_wr_w)
    ,.mem_d_rd_i(dport_tcm_rd_w)
    ,.mem_d_wr_i(dport_tcm_wr_w)
    ,.mem_d_cacheable_i(dport_tcm_cacheable_w)
    ,.mem_d_req_tag_i(dport_tcm_req_tag_w)
    ,.mem_d_invalidate_i(dport_tcm_invalidate_w)
    ,.mem_d_writeback_i(dport_tcm_writeback_w)
    ,.mem_d_flush_i(dport_tcm_flush_w)
    ,.axi_awvalid_i(riscv_slv_awvalid)
    ,.axi_awaddr_i(riscv_slv_awaddr)
    ,.axi_awid_i(riscv_slv_awid)
    ,.axi_awlen_i(riscv_slv_awlen)
    ,.axi_awburst_i(riscv_slv_awburst)
    ,.axi_wvalid_i(riscv_slv_wvalid)
    ,.axi_wdata_i(riscv_slv_wdata)
    ,.axi_wstrb_i(riscv_slv_wstrb)
    ,.axi_wlast_i(riscv_slv_wlast)
    ,.axi_bready_i(riscv_slv_bready)
    ,.axi_arvalid_i(riscv_slv_arvalid)
    ,.axi_araddr_i(riscv_slv_araddr)
    ,.axi_arid_i(riscv_slv_arid)
    ,.axi_arlen_i(riscv_slv_arlen)
    ,.axi_arburst_i(riscv_slv_arburst)
    ,.axi_rready_i(riscv_slv_rready)

    // Outputs
    ,.mem_i_accept_o(ifetch_accept_w)
    ,.mem_i_valid_o(ifetch_valid_w)
    ,.mem_i_error_o(ifetch_error_w)
    ,.mem_i_inst_o(ifetch_inst_w)
    ,.mem_d_data_rd_o(dport_tcm_data_rd_w)
    ,.mem_d_accept_o(dport_tcm_accept_w)
    ,.mem_d_ack_o(dport_tcm_ack_w)
    ,.mem_d_error_o(dport_tcm_error_w)
    ,.mem_d_resp_tag_o(dport_tcm_resp_tag_w)
    ,.axi_awready_o(riscv_slv_awready)
    ,.axi_wready_o(riscv_slv_wready)
    ,.axi_bvalid_o(riscv_slv_bvalid)
    ,.axi_bresp_o(riscv_slv_bresp)
    ,.axi_bid_o(riscv_slv_bid)
    ,.axi_arready_o(riscv_slv_arready)
    ,.axi_rvalid_o(riscv_slv_rvalid)
    ,.axi_rdata_o(riscv_slv_rdata)
    ,.axi_rresp_o(riscv_slv_rresp)
    ,.axi_rid_o(riscv_slv_rid)
    ,.axi_rlast_o(riscv_slv_rlast)
);


dport_axi
u_axi
(
    // Inputs
     .clk_i(clk)
    ,.rst_i(rst)
    ,.mem_addr_i(dport_axi_addr_w)
    ,.mem_data_wr_i(dport_axi_data_wr_w)
    ,.mem_rd_i(dport_axi_rd_w)
    ,.mem_wr_i(dport_axi_wr_w)
    ,.mem_cacheable_i(dport_axi_cacheable_w)
    ,.mem_req_tag_i(dport_axi_req_tag_w)
    ,.mem_invalidate_i(dport_axi_invalidate_w)
    ,.mem_writeback_i(dport_axi_writeback_w)
    ,.mem_flush_i(dport_axi_flush_w)
    ,.axi_awready_i(riscv_mst_awready)
    ,.axi_wready_i(riscv_mst_wready)
    ,.axi_bvalid_i(riscv_mst_bvalid)
    ,.axi_bresp_i(riscv_mst_bresp)
    ,.axi_arready_i(riscv_mst_arready)
    ,.axi_rvalid_i(riscv_mst_rvalid)
    ,.axi_rdata_i(riscv_mst_rdata)
    ,.axi_rresp_i(riscv_mst_rresp)

    // Outputs
    ,.mem_data_rd_o(dport_axi_data_rd_w)
    ,.mem_accept_o(dport_axi_accept_w)
    ,.mem_ack_o(dport_axi_ack_w)
    ,.mem_error_o(dport_axi_error_w)
    ,.mem_resp_tag_o(dport_axi_resp_tag_w)
    ,.axi_awvalid_o(riscv_mst_awvalid)
    ,.axi_awaddr_o(riscv_mst_awaddr)
    ,.axi_wvalid_o(riscv_mst_wvalid)
    ,.axi_wdata_o(riscv_mst_wdata)
    ,.axi_wstrb_o(riscv_mst_wstrb)
    ,.axi_bready_o(riscv_mst_bready)
    ,.axi_arvalid_o(riscv_mst_arvalid)
    ,.axi_araddr_o(riscv_mst_araddr)
    ,.axi_rready_o(riscv_mst_rready)
);



endmodule
