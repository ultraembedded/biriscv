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
//-----------------------------------------------------------------module biriscv_csr_regfile
(
     input           clk_i
    ,input           rst_i

    ,input           ext_intr_i
    ,input           timer_intr_i

    ,input [31:0]    cpu_id_i
    ,input [31:0]    misa_i

    ,input [5:0]     exception_i
    ,input [31:0]    exception_pc_i
    ,input [31:0]    exception_addr_i

    // CSR read port
    ,input  [11:0]   csr_raddr_i
    ,output [31:0]   csr_rdata_o

    // CSR write port
    ,input  [11:0]   csr_waddr_i
    ,input  [31:0]   csr_wdata_i

    ,output          csr_branch_o
    ,output [31:0]   csr_target_o

    // Masked interrupt output
    ,output [31:0]   interrupt_o
);

//-----------------------------------------------------------------
// Includes
//-----------------------------------------------------------------
`include "biriscv_defs.v"

//-----------------------------------------------------------------
// Registers / Wires
//-----------------------------------------------------------------
reg [31:0]  csr_mepc_q;
reg [31:0]  csr_mcause_q;
reg [31:0]  csr_sr_q;
reg [31:0]  csr_mtvec_q;
reg [31:0]  csr_mip_q;
reg [31:0]  csr_mie_q;
reg [1:0]   csr_mpriv_q;
reg [31:0]  csr_mcycle_q;
reg [31:0]  csr_mscratch_q;
reg [31:0]  csr_mtval_q;

//-----------------------------------------------------------------
// Masked Interrupts
//-----------------------------------------------------------------
reg [31:0] irq_pending_r;
reg [31:0] irq_masked_r;

always @ *
begin
    irq_pending_r   = (csr_mip_q & csr_mie_q);
    irq_masked_r    = csr_sr_q[`SR_MIE_R] ? irq_pending_r : 32'b0;
end

assign interrupt_o = irq_masked_r;

//-----------------------------------------------------------------
// CSR Read Port
//-----------------------------------------------------------------
reg [31:0] rdata_r;
always @ *
begin
    rdata_r = 32'b0;

    case (csr_raddr_i)
    `CSR_MSCRATCH: rdata_r = csr_mscratch_q & `CSR_MSCRATCH_MASK;
    `CSR_MEPC:     rdata_r = csr_mepc_q & `CSR_MEPC_MASK;
    `CSR_MTVEC:    rdata_r = csr_mtvec_q & `CSR_MTVEC_MASK;
    `CSR_MCAUSE:   rdata_r = csr_mcause_q & `CSR_MCAUSE_MASK;
    `CSR_MTVAL:    rdata_r = csr_mtval_q & `CSR_MTVAL_MASK;
    `CSR_MSTATUS:  rdata_r = csr_sr_q & `CSR_MSTATUS_MASK;
    `CSR_MIP:      rdata_r = csr_mip_q & `CSR_MIP_MASK;
    `CSR_MIE:      rdata_r = csr_mie_q & `CSR_MIE_MASK;
    `CSR_MCYCLE,
    `CSR_MTIME:    rdata_r = csr_mcycle_q;
    `CSR_MHARTID:  rdata_r = cpu_id_i;
    `CSR_MISA:     rdata_r = misa_i;
    default:       rdata_r = 32'b0;
    endcase
end

assign csr_rdata_o = rdata_r;

//-----------------------------------------------------------------
// CSR register next state
//-----------------------------------------------------------------
reg [31:0]  csr_mepc_r;
reg [31:0]  csr_mcause_r;
reg [31:0]  csr_mtval_r;
reg [31:0]  csr_sr_r;
reg [31:0]  csr_mtvec_r;
reg [31:0]  csr_mip_r;
reg [31:0]  csr_mie_r;
reg [1:0]   csr_mpriv_r;
reg [31:0]  csr_mcycle_r;
reg [31:0]  csr_mscratch_r;

always @ *
begin
    csr_mepc_r      = csr_mepc_q;
    csr_sr_r        = csr_sr_q;
    csr_mcause_r    = csr_mcause_q;
    csr_mtval_r     = csr_mtval_q;
    csr_mtvec_r     = csr_mtvec_q;
    csr_mip_r       = csr_mip_q;
    csr_mie_r       = csr_mie_q;
    csr_mpriv_r     = csr_mpriv_q;
    csr_mscratch_r  = csr_mscratch_q;
    csr_mcycle_r    = csr_mcycle_q + 32'd1;

    // Interrupts
    if ((exception_i & `EXCEPTION_TYPE_MASK) == `EXCEPTION_INTERRUPT)
    begin
        // Save interrupt / supervisor state
        csr_sr_r[`SR_MPIE_R] = csr_sr_r[`SR_MIE_R];
        csr_sr_r[`SR_MPP_R]  = csr_mpriv_q;

        // Disable interrupts and enter supervisor mode
        csr_sr_r[`SR_MIE_R]  = 1'b0;

        // Raise priviledge to machine level
        csr_mpriv_r          = `PRIV_MACHINE;

        // Record interrupt source PC
        csr_mepc_r           = exception_pc_i;
        csr_mtval_r          = 32'b0;

        // Piority encoded interrupt cause
        if (interrupt_o[`IRQ_M_SOFT])
            csr_mcause_r = `MCAUSE_INTERRUPT + 32'd`IRQ_M_SOFT;
        else if (interrupt_o[`IRQ_M_TIMER])
            csr_mcause_r = `MCAUSE_INTERRUPT + 32'd`IRQ_M_TIMER;
        else if (interrupt_o[`IRQ_M_EXT])
            csr_mcause_r = `MCAUSE_INTERRUPT + 32'd`IRQ_M_EXT;
    end
    // Exception return
    else if (exception_i == `EXCEPTION_ERET)
    begin
        // Set privilege level to previous MPP
        csr_mpriv_r          = csr_sr_r[`SR_MPP_R];

        // Interrupt enable pop
        csr_sr_r[`SR_MIE_R]  = csr_sr_r[`SR_MPIE_R];
        csr_sr_r[`SR_MPIE_R] = 1'b1;

        // TODO: Set next MPP to user mode??
        csr_sr_r[`SR_MPP_R] = `SR_MPP_U;
    end
    // Exceptions
    else if (|exception_i)
    begin
        // Save interrupt / supervisor state
        csr_sr_r[`SR_MPIE_R] = csr_sr_r[`SR_MIE_R];
        csr_sr_r[`SR_MPP_R]  = csr_mpriv_q;

        // Disable interrupts and enter supervisor mode
        csr_sr_r[`SR_MIE_R]  = 1'b0;

        // Raise priviledge to machine level
        csr_mpriv_r  = `PRIV_MACHINE;

        // Record fault source PC
        csr_mepc_r   = exception_pc_i;

        // Bad address / PC
        case (exception_i)
        `EXCEPTION_MISALIGNED_FETCH,
        `EXCEPTION_FAULT_FETCH,
        `EXCEPTION_ILLEGAL_INSTRUCTION,
        `EXCEPTION_PAGE_FAULT_INST:     csr_mtval_r = exception_pc_i;
        `EXCEPTION_MISALIGNED_LOAD,
        `EXCEPTION_FAULT_LOAD,
        `EXCEPTION_MISALIGNED_STORE,
        `EXCEPTION_FAULT_STORE,
        `EXCEPTION_PAGE_FAULT_LOAD,
        `EXCEPTION_PAGE_FAULT_STORE:    csr_mtval_r = exception_addr_i;
        default:                        csr_mtval_r = 32'b0;
        endcase        

        // Fault cause
        if (exception_i == `EXCEPTION_ECALL)
            csr_mcause_r = {28'b0, exception_i[3:0]} + {30'b0, csr_mpriv_q};
        else
            csr_mcause_r = {28'b0, exception_i[3:0]};
    end
    else
    begin
        case (csr_waddr_i)
        `CSR_MSCRATCH: csr_mscratch_r = csr_wdata_i & `CSR_MSCRATCH_MASK;
        `CSR_MEPC:     csr_mepc_r     = csr_wdata_i & `CSR_MEPC_MASK;
        `CSR_MTVEC:    csr_mtvec_r    = csr_wdata_i & `CSR_MTVEC_MASK;
        `CSR_MCAUSE:   csr_mcause_r   = csr_wdata_i & `CSR_MCAUSE_MASK;
        `CSR_MTVAL:    csr_mtval_r    = csr_wdata_i & `CSR_MTVAL_MASK;
        `CSR_MSTATUS:  csr_sr_r       = csr_wdata_i & `CSR_MSTATUS_MASK;
        `CSR_MIP:      csr_mip_r      = csr_wdata_i & `CSR_MIP_MASK;
        `CSR_MIE:      csr_mie_r      = csr_wdata_i & `CSR_MIE_MASK;
        `CSR_MCYCLE,
        `CSR_MTIME:    csr_mcycle_r   = csr_wdata_i;
        default:
            ;
        endcase
    end
 
    // External interrupts
    if (ext_intr_i)   csr_mip_r[`SR_IP_MEIP_R] = 1'b1;
    if (timer_intr_i) csr_mip_r[`SR_IP_MTIP_R] = 1'b1;
end

//-----------------------------------------------------------------
// Sequential
//-----------------------------------------------------------------
`ifdef verilator
`define HAS_SIM_CTRL
`endif
`ifdef verilog_sim
`define HAS_SIM_CTRL
`endif

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
begin
    csr_mepc_q         <= 32'b0;
    csr_sr_q           <= 32'b0;
    csr_mcause_q       <= 32'b0;
    csr_mtval_q        <= 32'b0;
    csr_mtvec_q        <= 32'b0;
    csr_mip_q          <= 32'b0;
    csr_mie_q          <= 32'b0;
    csr_mpriv_q        <= `PRIV_MACHINE;
    csr_mcycle_q       <= 32'b0;
    csr_mscratch_q     <= 32'b0;
end
else
begin
    csr_mepc_q         <= csr_mepc_r;
    csr_sr_q           <= csr_sr_r;
    csr_mcause_q       <= csr_mcause_r;
    csr_mtval_q        <= csr_mtval_r;
    csr_mtvec_q        <= csr_mtvec_r;
    csr_mip_q          <= csr_mip_r;
    csr_mie_q          <= csr_mie_r;
    csr_mpriv_q        <= `PRIV_MACHINE;
    csr_mcycle_q       <= csr_mcycle_r;
    csr_mscratch_q     <= csr_mscratch_r;

`ifdef HAS_SIM_CTRL
    // CSR SIM_CTRL
    if (csr_waddr_i == `CSR_DSCRATCH && ~(|exception_i))
    begin
        case (csr_wdata_i & 32'hFF000000)
        `CSR_SIM_CTRL_EXIT:
        begin
            //exit(csr_wdata_i[7:0]);
            $finish;
            $finish;
        end
        `CSR_SIM_CTRL_PUTC:
        begin
            $write("%c", csr_wdata_i[7:0]);
        end
        endcase
    end
`endif
end

//-----------------------------------------------------------------
// CSR branch
//-----------------------------------------------------------------
reg        branch_r;
reg [31:0] branch_target_r;

always @ *
begin
    branch_r        = 1'b0;
    branch_target_r = 32'b0;

    // Interrupts
    if (exception_i == `EXCEPTION_INTERRUPT)
    begin
        branch_r        = 1'b1;
        branch_target_r = csr_mtvec_q;
    end
    // Exception return
    else if (exception_i == `EXCEPTION_ERET)
    begin
        branch_r        = 1'b1;
        branch_target_r = csr_mepc_q;
    end
    // Exceptions
    else if (|exception_i)
    begin
        branch_r        = 1'b1;
        branch_target_r = csr_mtvec_q;
    end
end

assign csr_branch_o = branch_r;
assign csr_target_o = branch_target_r;

endmodule
