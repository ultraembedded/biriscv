//-----------------------------------------------------------------
//                         biRISC-V CPU
//                            V0.5.0
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

module biriscv_fetch
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           fetch_accept_i
    ,input           icache_accept_i
    ,input           icache_valid_i
    ,input           icache_error_i
    ,input  [ 63:0]  icache_inst_i
    ,input           fetch_invalidate_i
    ,input           branch_request_i
    ,input  [ 31:0]  branch_pc_i
    ,input  [ 31:0]  next_pc_f_i
    ,input  [  1:0]  next_taken_f_i

    // Outputs
    ,output          fetch_valid_o
    ,output [ 63:0]  fetch_instr_o
    ,output [  1:0]  fetch_pred_branch_o
    ,output          fetch_fault_fetch_o
    ,output          fetch_fault_page_o
    ,output [ 31:0]  fetch_pc_o
    ,output          icache_rd_o
    ,output          icache_flush_o
    ,output          icache_invalidate_o
    ,output [ 31:0]  icache_pc_o
    ,output [ 31:0]  pc_f_o
    ,output          pc_accept_o
);



//-------------------------------------------------------------
// Registers / Wires
//-------------------------------------------------------------
reg         active_q;

reg [31:0]  pc_f_q;
reg [31:0]  pc_d_q;

reg         branch_valid_q;
reg         stall_q;

reg         icache_fetch_q;
reg         icache_invalidate_q;

reg [99:0]  skid_buffer_q;
reg         skid_valid_q;

wire        icache_busy_w =  icache_fetch_q && !icache_valid_i;
wire        stall_w       = !fetch_accept_i || icache_busy_w || !icache_accept_i;

wire        branch_w      = branch_valid_q || branch_request_i;
wire [31:0] branch_pc_w   = (branch_valid_q & !branch_request_i) ? pc_f_q : branch_pc_i;

//-------------------------------------------------------------
// Sequential
//-------------------------------------------------------------
always @ (posedge clk_i or posedge rst_i)
if (rst_i)
begin
    pc_f_q         <= 32'b0;
    branch_valid_q <= 1'b0;
    icache_fetch_q <= 1'b0;
    skid_buffer_q  <= 100'b0;
    skid_valid_q   <= 1'b0;
    active_q       <= 1'b0;
    stall_q        <= 1'b0;
end
else
begin
    // Branch request skid buffer
    if ((stall_w || !active_q || stall_q) && branch_w)
    begin
        branch_valid_q <= branch_w;
        pc_f_q         <= branch_pc_w;
    end
    else if (!stall_w)
    begin
        // NPC
        pc_f_q         <= next_pc_f_i;
        branch_valid_q <= 1'b0;
    end

    stall_q      <= stall_w;

    if (branch_w)
        active_q <= 1'b1;
    
    // Instruction output back-pressured - hold in skid buffer
    if (fetch_valid_o && !fetch_accept_i)
    begin
        skid_valid_q  <= 1'b1;
        skid_buffer_q <= {fetch_fault_page_o, fetch_fault_fetch_o, fetch_pred_branch_o, fetch_pc_o, fetch_instr_o};
    end
    else
    begin
        skid_valid_q  <= 1'b0;
        skid_buffer_q <= 100'b0;
    end

    // ICACHE fetch tracking
    if (icache_rd_o && icache_accept_i)
        icache_fetch_q <= 1'b1;
    else if (icache_valid_i)
        icache_fetch_q <= 1'b0;
end

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    icache_invalidate_q <= 1'b0;
else if (icache_invalidate_o && !icache_accept_i)
    icache_invalidate_q <= 1'b1;
else
    icache_invalidate_q <= 1'b0;

wire [31:0] icache_pc_w = (branch_w & ~stall_q) ? branch_pc_w : pc_f_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    pc_d_q <= 32'b0;
else if (icache_rd_o && icache_accept_i)
    pc_d_q <= icache_pc_w;

reg [1:0] pred_d_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    pred_d_q <= 2'b0;
else if (icache_rd_o && icache_accept_i)
    pred_d_q <= next_taken_f_i;
else if (icache_valid_i)
    pred_d_q <= 2'b0;

//-------------------------------------------------------------
// Outputs
//-------------------------------------------------------------
assign icache_rd_o         = active_q & fetch_accept_i & !icache_busy_w;
assign icache_pc_o         = {icache_pc_w[31:3],3'b0};
assign icache_flush_o      = fetch_invalidate_i | icache_invalidate_q;
assign icache_invalidate_o = 1'b0;

assign fetch_valid_o       = (icache_valid_i || skid_valid_q) & !branch_w;
assign fetch_pc_o          = skid_valid_q ? skid_buffer_q[95:64] : {pc_d_q[31:3],3'b0};
assign fetch_instr_o       = skid_valid_q ? skid_buffer_q[63:0]  : icache_inst_i;
assign fetch_pred_branch_o = skid_valid_q ? skid_buffer_q[97:96] : pred_d_q;

// Faults
assign fetch_fault_fetch_o = skid_valid_q ? skid_buffer_q[98]  : icache_error_i;
assign fetch_fault_page_o  = skid_valid_q ? skid_buffer_q[99] : 1'b0;

assign pc_f_o              = icache_pc_w;
assign pc_accept_o         = ~stall_w;



endmodule
