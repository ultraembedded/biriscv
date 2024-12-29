//-----------------------------------------------------------------
//                         biRISC-V CPU
//                            V0.8.1
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
`define ALU_NONE                                4'b0000
`define ALU_SHIFTL                              4'b0001
`define ALU_SHIFTR                              4'b0010
`define ALU_SHIFTR_ARITH                        4'b0011
`define ALU_ADD                                 4'b0100
`define ALU_SUB                                 4'b0110
`define ALU_AND                                 4'b0111
`define ALU_OR                                  4'b1000
`define ALU_XOR                                 4'b1001
`define ALU_LESS_THAN                           4'b1010
`define ALU_LESS_THAN_SIGNED                    4'b1011

//--------------------------------------------------------------------
// Instructions Masks
//--------------------------------------------------------------------
// andi
`define INST_ANDI 32'h7013
`define INST_ANDI_MASK 32'h707f

// addi
`define INST_ADDI 32'h13
`define INST_ADDI_MASK 32'h707f

// slti
`define INST_SLTI 32'h2013
`define INST_SLTI_MASK 32'h707f

// sltiu
`define INST_SLTIU 32'h3013
`define INST_SLTIU_MASK 32'h707f

// ori
`define INST_ORI 32'h6013
`define INST_ORI_MASK 32'h707f

// xori
`define INST_XORI 32'h4013
`define INST_XORI_MASK 32'h707f

// slli
`define INST_SLLI 32'h1013
`define INST_SLLI_MASK 32'hfc00707f

// srli
`define INST_SRLI 32'h5013
`define INST_SRLI_MASK 32'hfc00707f

// srai
`define INST_SRAI 32'h40005013
`define INST_SRAI_MASK 32'hfc00707f

// lui
`define INST_LUI 32'h37
`define INST_LUI_MASK 32'h7f

// auipc
`define INST_AUIPC 32'h17
`define INST_AUIPC_MASK 32'h7f

// add
`define INST_ADD 32'h33
`define INST_ADD_MASK 32'hfe00707f

// sub
`define INST_SUB 32'h40000033
`define INST_SUB_MASK 32'hfe00707f

// slt
`define INST_SLT 32'h2033
`define INST_SLT_MASK 32'hfe00707f

// sltu
`define INST_SLTU 32'h3033
`define INST_SLTU_MASK 32'hfe00707f

// xor
`define INST_XOR 32'h4033
`define INST_XOR_MASK 32'hfe00707f

// or
`define INST_OR 32'h6033
`define INST_OR_MASK 32'hfe00707f

// and
`define INST_AND 32'h7033
`define INST_AND_MASK 32'hfe00707f

// sll
`define INST_SLL 32'h1033
`define INST_SLL_MASK 32'hfe00707f

// srl
`define INST_SRL 32'h5033
`define INST_SRL_MASK 32'hfe00707f

// sra
`define INST_SRA 32'h40005033
`define INST_SRA_MASK 32'hfe00707f

// jal
`define INST_JAL 32'h6f
`define INST_JAL_MASK 32'h7f

// jalr
`define INST_JALR 32'h67
`define INST_JALR_MASK 32'h707f

// beq
`define INST_BEQ 32'h63
`define INST_BEQ_MASK 32'h707f

// bne
`define INST_BNE 32'h1063
`define INST_BNE_MASK 32'h707f

// blt
`define INST_BLT 32'h4063
`define INST_BLT_MASK 32'h707f

// bge
`define INST_BGE 32'h5063
`define INST_BGE_MASK 32'h707f

// bltu
`define INST_BLTU 32'h6063
`define INST_BLTU_MASK 32'h707f

// bgeu
`define INST_BGEU 32'h7063
`define INST_BGEU_MASK 32'h707f

// lb
`define INST_LB 32'h3
`define INST_LB_MASK 32'h707f

// lh
`define INST_LH 32'h1003
`define INST_LH_MASK 32'h707f

// lw
`define INST_LW 32'h2003
`define INST_LW_MASK 32'h707f

// lbu
`define INST_LBU 32'h4003
`define INST_LBU_MASK 32'h707f

// lhu
`define INST_LHU 32'h5003
`define INST_LHU_MASK 32'h707f

// lwu
`define INST_LWU 32'h6003
`define INST_LWU_MASK 32'h707f

// sb
`define INST_SB 32'h23
`define INST_SB_MASK 32'h707f

// sh
`define INST_SH 32'h1023
`define INST_SH_MASK 32'h707f

// sw
`define INST_SW 32'h2023
`define INST_SW_MASK 32'h707f

// ecall
`define INST_ECALL 32'h73
`define INST_ECALL_MASK 32'hffffffff

// ebreak
`define INST_EBREAK 32'h100073
`define INST_EBREAK_MASK 32'hffffffff

// eret
`define INST_ERET 32'h200073
`define INST_ERET_MASK 32'hcfffffff

// csrrw
`define INST_CSRRW 32'h1073
`define INST_CSRRW_MASK 32'h707f

// csrrs
`define INST_CSRRS 32'h2073
`define INST_CSRRS_MASK 32'h707f

// csrrc
`define INST_CSRRC 32'h3073
`define INST_CSRRC_MASK 32'h707f

// csrrwi
`define INST_CSRRWI 32'h5073
`define INST_CSRRWI_MASK 32'h707f

// csrrsi
`define INST_CSRRSI 32'h6073
`define INST_CSRRSI_MASK 32'h707f

// csrrci
`define INST_CSRRCI 32'h7073
`define INST_CSRRCI_MASK 32'h707f

// mul
`define INST_MUL 32'h2000033
`define INST_MUL_MASK 32'hfe00707f

// mulh
`define INST_MULH 32'h2001033
`define INST_MULH_MASK 32'hfe00707f

// mulhsu
`define INST_MULHSU 32'h2002033
`define INST_MULHSU_MASK 32'hfe00707f

// mulhu
`define INST_MULHU 32'h2003033
`define INST_MULHU_MASK 32'hfe00707f

// div
`define INST_DIV 32'h2004033
`define INST_DIV_MASK 32'hfe00707f

// divu
`define INST_DIVU 32'h2005033
`define INST_DIVU_MASK 32'hfe00707f

// rem
`define INST_REM 32'h2006033
`define INST_REM_MASK 32'hfe00707f

// remu
`define INST_REMU 32'h2007033
`define INST_REMU_MASK 32'hfe00707f

// wfi
`define INST_WFI 32'h10500073
`define INST_WFI_MASK 32'hffff8fff

// fence
`define INST_FENCE 32'hf
`define INST_FENCE_MASK 32'h707f

// sfence
`define INST_SFENCE 32'h12000073
`define INST_SFENCE_MASK 32'hfe007fff

// fence.i
`define INST_IFENCE 32'h100f
`define INST_IFENCE_MASK 32'h707f

//--------------------------------------------------------------------
// Privilege levels
//--------------------------------------------------------------------
`define PRIV_USER         2'd0
`define PRIV_SUPER        2'd1
`define PRIV_MACHINE      2'd3

//--------------------------------------------------------------------
// IRQ Numbers
//--------------------------------------------------------------------
`define IRQ_S_SOFT   1
`define IRQ_M_SOFT   3
`define IRQ_S_TIMER  5
`define IRQ_M_TIMER  7
`define IRQ_S_EXT    9
`define IRQ_M_EXT    11
`define IRQ_MIN      (`IRQ_S_SOFT)
`define IRQ_MAX      (`IRQ_M_EXT + 1)
`define IRQ_MASK     ((1 << `IRQ_M_EXT)   | (1 << `IRQ_S_EXT)   |                       (1 << `IRQ_M_TIMER) | (1 << `IRQ_S_TIMER) |                       (1 << `IRQ_M_SOFT)  | (1 << `IRQ_S_SOFT))

`define SR_IP_MSIP_R      `IRQ_M_SOFT
`define SR_IP_MTIP_R      `IRQ_M_TIMER
`define SR_IP_MEIP_R      `IRQ_M_EXT
`define SR_IP_SSIP_R      `IRQ_S_SOFT
`define SR_IP_STIP_R      `IRQ_S_TIMER
`define SR_IP_SEIP_R      `IRQ_S_EXT

//--------------------------------------------------------------------
// CSR Registers - Simulation control
//--------------------------------------------------------------------
`define CSR_DSCRATCH       12'h7b2
`define CSR_SIM_CTRL       12'h8b2
`define CSR_SIM_CTRL_MASK  32'hFFFFFFFF
    `define CSR_SIM_CTRL_EXIT (0 << 24)
    `define CSR_SIM_CTRL_PUTC (1 << 24)

//--------------------------------------------------------------------
// CSR Registers
//--------------------------------------------------------------------
`define CSR_MSTATUS       12'h300
`define CSR_MSTATUS_MASK  32'hFFFFFFFF
`define CSR_MISA          12'h301
`define CSR_MISA_MASK     32'hFFFFFFFF
`define MISA_RV32     32'h40000000
`define MISA_RVI      32'h00000100
`define MISA_RVE      32'h00000010
`define MISA_RVM      32'h00001000
`define MISA_RVA      32'h00000001
`define MISA_RVF      32'h00000020
`define MISA_RVD      32'h00000008
`define MISA_RVC      32'h00000004
`define MISA_RVS      32'h00040000
`define MISA_RVU      32'h00100000
`define CSR_MEDELEG       12'h302
`define CSR_MEDELEG_MASK  32'h0000FFFF
`define CSR_MIDELEG       12'h303
`define CSR_MIDELEG_MASK  32'h0000FFFF
`define CSR_MIE           12'h304
`define CSR_MIE_MASK      `IRQ_MASK
`define CSR_MTVEC         12'h305
`define CSR_MTVEC_MASK    32'hFFFFFFFF
`define CSR_MSCRATCH      12'h340
`define CSR_MSCRATCH_MASK 32'hFFFFFFFF
`define CSR_MEPC          12'h341
`define CSR_MEPC_MASK     32'hFFFFFFFF
`define CSR_MCAUSE        12'h342
`define CSR_MCAUSE_MASK   32'h8000000F
`define CSR_MTVAL         12'h343
`define CSR_MTVAL_MASK    32'hFFFFFFFF
`define CSR_MIP           12'h344
`define CSR_MIP_MASK      `IRQ_MASK
`define CSR_MCYCLE        12'hc00
`define CSR_MCYCLE_MASK   32'hFFFFFFFF
`define CSR_MTIME         12'hc01
`define CSR_MTIME_MASK    32'hFFFFFFFF
`define CSR_MTIMEH        12'hc81
`define CSR_MTIMEH_MASK   32'hFFFFFFFF
`define CSR_MHARTID       12'hF14
`define CSR_MHARTID_MASK  32'hFFFFFFFF

// Non-std
`define CSR_MTIMECMP        12'h7c0
`define CSR_MTIMECMP_MASK   32'hFFFFFFFF

//-----------------------------------------------------------------
// CSR Registers - Supervisor
//-----------------------------------------------------------------
`define CSR_SSTATUS       12'h100
`define CSR_SSTATUS_MASK  `SR_SMODE_MASK
`define CSR_SIE           12'h104
`define CSR_SIE_MASK      ((1 << `IRQ_S_EXT) | (1 << `IRQ_S_TIMER) | (1 << `IRQ_S_SOFT))
`define CSR_STVEC         12'h105
`define CSR_STVEC_MASK    32'hFFFFFFFF
`define CSR_SSCRATCH      12'h140
`define CSR_SSCRATCH_MASK 32'hFFFFFFFF
`define CSR_SEPC          12'h141
`define CSR_SEPC_MASK     32'hFFFFFFFF
`define CSR_SCAUSE        12'h142
`define CSR_SCAUSE_MASK   32'h8000000F
`define CSR_STVAL         12'h143
`define CSR_STVAL_MASK    32'hFFFFFFFF
`define CSR_SIP           12'h144
`define CSR_SIP_MASK      ((1 << `IRQ_S_EXT) | (1 << `IRQ_S_TIMER) | (1 << `IRQ_S_SOFT))
`define CSR_SATP          12'h180
`define CSR_SATP_MASK     32'hFFFFFFFF

//--------------------------------------------------------------------
// CSR Registers - DCACHE control
//--------------------------------------------------------------------
`define CSR_DFLUSH            12'h3a0 // pmpcfg0
`define CSR_DFLUSH_MASK       32'hFFFFFFFF
`define CSR_DWRITEBACK        12'h3a1 // pmpcfg1
`define CSR_DWRITEBACK_MASK   32'hFFFFFFFF
`define CSR_DINVALIDATE       12'h3a2 // pmpcfg2
`define CSR_DINVALIDATE_MASK  32'hFFFFFFFF

//--------------------------------------------------------------------
// Status Register
//--------------------------------------------------------------------
`define SR_UIE         (1 << 0)
`define SR_UIE_R       0
`define SR_SIE         (1 << 1)
`define SR_SIE_R       1
`define SR_MIE         (1 << 3)
`define SR_MIE_R       3
`define SR_UPIE        (1 << 4)
`define SR_UPIE_R      4
`define SR_SPIE        (1 << 5)
`define SR_SPIE_R      5
`define SR_MPIE        (1 << 7)
`define SR_MPIE_R      7
`define SR_SPP         (1 << 8)
`define SR_SPP_R       8

`define SR_MPP_SHIFT   11
`define SR_MPP_MASK    2'h3
`define SR_MPP_R       12:11
`define SR_MPP_U       `PRIV_USER
`define SR_MPP_S       `PRIV_SUPER
`define SR_MPP_M       `PRIV_MACHINE

`define SR_SUM_R        18
`define SR_SUM          (1 << `SR_SUM_R)

`define SR_MPRV_R       17
`define SR_MPRV         (1 << `SR_MPRV_R)

`define SR_MXR_R        19
`define SR_MXR          (1 << `SR_MXR_R)

`define SR_SMODE_MASK   (`SR_UIE | `SR_SIE | `SR_UPIE | `SR_SPIE | `SR_SPP | `SR_SUM)

//--------------------------------------------------------------------
// SATP definitions
//--------------------------------------------------------------------
`define SATP_PPN_R        19:0 // TODO: Should be 21??
`define SATP_ASID_R       30:22
`define SATP_MODE_R       31

//--------------------------------------------------------------------
// MMU Defs (SV32)
//--------------------------------------------------------------------
`define MMU_LEVELS        2
`define MMU_PTIDXBITS     10
`define MMU_PTESIZE       4
`define MMU_PGSHIFT       (`MMU_PTIDXBITS + 2)
`define MMU_PGSIZE        (1 << `MMU_PGSHIFT)
`define MMU_VPN_BITS      (`MMU_PTIDXBITS * `MMU_LEVELS)
`define MMU_PPN_BITS      (32 - `MMU_PGSHIFT)
`define MMU_VA_BITS       (`MMU_VPN_BITS + `MMU_PGSHIFT)

`define PAGE_PRESENT      0
`define PAGE_READ         1
`define PAGE_WRITE        2
`define PAGE_EXEC         3
`define PAGE_USER         4
`define PAGE_GLOBAL       5
`define PAGE_ACCESSED     6
`define PAGE_DIRTY        7
`define PAGE_SOFT         9:8

`define PAGE_FLAGS       10'h3FF

`define PAGE_PFN_SHIFT   10
`define PAGE_SIZE        4096

//--------------------------------------------------------------------
// Exception Causes
//--------------------------------------------------------------------
`define EXCEPTION_W                        6
`define EXCEPTION_MISALIGNED_FETCH         6'h10
`define EXCEPTION_FAULT_FETCH              6'h11
`define EXCEPTION_ILLEGAL_INSTRUCTION      6'h12
`define EXCEPTION_BREAKPOINT               6'h13
`define EXCEPTION_MISALIGNED_LOAD          6'h14
`define EXCEPTION_FAULT_LOAD               6'h15
`define EXCEPTION_MISALIGNED_STORE         6'h16
`define EXCEPTION_FAULT_STORE              6'h17
`define EXCEPTION_ECALL                    6'h18
`define EXCEPTION_ECALL_U                  6'h18
`define EXCEPTION_ECALL_S                  6'h19
`define EXCEPTION_ECALL_H                  6'h1a
`define EXCEPTION_ECALL_M                  6'h1b
`define EXCEPTION_PAGE_FAULT_INST          6'h1c
`define EXCEPTION_PAGE_FAULT_LOAD          6'h1d
`define EXCEPTION_PAGE_FAULT_STORE         6'h1f
`define EXCEPTION_EXCEPTION                6'h10
`define EXCEPTION_INTERRUPT                6'h20
`define EXCEPTION_ERET_U                   6'h30
`define EXCEPTION_ERET_S                   6'h31
`define EXCEPTION_ERET_H                   6'h32
`define EXCEPTION_ERET_M                   6'h33
`define EXCEPTION_FENCE                    6'h34
`define EXCEPTION_TYPE_MASK                6'h30
`define EXCEPTION_SUBTYPE_R                3:0

`define MCAUSE_INT                      31
`define MCAUSE_MISALIGNED_FETCH         ((0 << `MCAUSE_INT) | 0)
`define MCAUSE_FAULT_FETCH              ((0 << `MCAUSE_INT) | 1)
`define MCAUSE_ILLEGAL_INSTRUCTION      ((0 << `MCAUSE_INT) | 2)
`define MCAUSE_BREAKPOINT               ((0 << `MCAUSE_INT) | 3)
`define MCAUSE_MISALIGNED_LOAD          ((0 << `MCAUSE_INT) | 4)
`define MCAUSE_FAULT_LOAD               ((0 << `MCAUSE_INT) | 5)
`define MCAUSE_MISALIGNED_STORE         ((0 << `MCAUSE_INT) | 6)
`define MCAUSE_FAULT_STORE              ((0 << `MCAUSE_INT) | 7)
`define MCAUSE_ECALL_U                  ((0 << `MCAUSE_INT) | 8)
`define MCAUSE_ECALL_S                  ((0 << `MCAUSE_INT) | 9)
`define MCAUSE_ECALL_H                  ((0 << `MCAUSE_INT) | 10)
`define MCAUSE_ECALL_M                  ((0 << `MCAUSE_INT) | 11)
`define MCAUSE_PAGE_FAULT_INST          ((0 << `MCAUSE_INT) | 12)
`define MCAUSE_PAGE_FAULT_LOAD          ((0 << `MCAUSE_INT) | 13)
`define MCAUSE_PAGE_FAULT_STORE         ((0 << `MCAUSE_INT) | 15)
`define MCAUSE_INTERRUPT                (1 << `MCAUSE_INT)

//--------------------------------------------------------------------
// Debug
//--------------------------------------------------------------------
`define RISCV_REGNO_FIRST   13'd0
`define RISCV_REGNO_GPR0    13'd0
`define RISCV_REGNO_GPR31   13'd31
`define RISCV_REGNO_PC      13'd32
`define RISCV_REGNO_CSR0    13'd65
`define RISCV_REGNO_CSR4095 (`RISCV_REGNO_CSR0 +  13'd4095)
`define RISCV_REGNO_PRIV    13'd4161

module biriscv_trace_sim_gls
(
     input                        valid_i
    ,input  [31:0]                opcode_i
);

//-----------------------------------------------------------------
// get_regname_str: Convert register number to string
//-----------------------------------------------------------------

function [79:0] get_regname_str;
    input  [4:0] regnum;
begin
    case (regnum)
        5'd0:  get_regname_str = "zero";
        5'd1:  get_regname_str = "ra";
        5'd2:  get_regname_str = "sp";
        5'd3:  get_regname_str = "gp";
        5'd4:  get_regname_str = "tp";
        5'd5:  get_regname_str = "t0";
        5'd6:  get_regname_str = "t1";
        5'd7:  get_regname_str = "t2";
        5'd8:  get_regname_str = "s0";
        5'd9:  get_regname_str = "s1";
        5'd10: get_regname_str = "a0";
        5'd11: get_regname_str = "a1";
        5'd12: get_regname_str = "a2";
        5'd13: get_regname_str = "a3";
        5'd14: get_regname_str = "a4";
        5'd15: get_regname_str = "a5";
        5'd16: get_regname_str = "a6";
        5'd17: get_regname_str = "a7";
        5'd18: get_regname_str = "s2";
        5'd19: get_regname_str = "s3";
        5'd20: get_regname_str = "s4";
        5'd21: get_regname_str = "s5";
        5'd22: get_regname_str = "s6";
        5'd23: get_regname_str = "s7";
        5'd24: get_regname_str = "s8";
        5'd25: get_regname_str = "s9";
        5'd26: get_regname_str = "s10";
        5'd27: get_regname_str = "s11";
        5'd28: get_regname_str = "t3";
        5'd29: get_regname_str = "t4";
        5'd30: get_regname_str = "t5";
        5'd31: get_regname_str = "t6";
    endcase
end
endfunction

//-------------------------------------------------------------------
// Debug strings
//-------------------------------------------------------------------
reg [79:0] dbg_inst_str;
reg [79:0] dbg_inst_ra;
reg [79:0] dbg_inst_rb;
reg [79:0] dbg_inst_rd;

wire [4:0] ra_idx_w = opcode_i[19:15];
wire [4:0] rb_idx_w = opcode_i[24:20];
wire [4:0] rd_idx_w = opcode_i[11:7];

`define DBG_IMM_IMM20     {opcode_i[31:12], 12'b0}
`define DBG_IMM_IMM12     {{20{opcode_i[31]}}, opcode_i[31:20]}
`define DBG_IMM_BIMM      {{19{opcode_i[31]}}, opcode_i[31], opcode_i[7], opcode_i[30:25], opcode_i[11:8], 1'b0}
`define DBG_IMM_JIMM20    {{12{opcode_i[31]}}, opcode_i[19:12], opcode_i[20], opcode_i[30:25], opcode_i[24:21], 1'b0}
`define DBG_IMM_STOREIMM  {{20{opcode_i[31]}}, opcode_i[31:25], opcode_i[11:7]}
`define DBG_IMM_SHAMT     opcode_i[24:20]

always @ *
begin
    dbg_inst_str = "-";
    dbg_inst_ra  = "-";
    dbg_inst_rb  = "-";
    dbg_inst_rd  = "-";

    if (valid_i)
    begin
        dbg_inst_ra  = get_regname_str(ra_idx_w);
        dbg_inst_rb  = get_regname_str(rb_idx_w);
        dbg_inst_rd  = get_regname_str(rd_idx_w);

        case (1'b1)
            ((opcode_i & `INST_ANDI_MASK) == `INST_ANDI)   : dbg_inst_str = "andi";
            ((opcode_i & `INST_ADDI_MASK) == `INST_ADDI)   : dbg_inst_str = "addi";
            ((opcode_i & `INST_SLTI_MASK) == `INST_SLTI)   : dbg_inst_str = "slti";
            ((opcode_i & `INST_SLTIU_MASK) == `INST_SLTIU)  : dbg_inst_str = "sltiu";
            ((opcode_i & `INST_ORI_MASK) == `INST_ORI)    : dbg_inst_str = "ori";
            ((opcode_i & `INST_XORI_MASK) == `INST_XORI)   : dbg_inst_str = "xori";
            ((opcode_i & `INST_SLLI_MASK) == `INST_SLLI)   : dbg_inst_str = "slli";
            ((opcode_i & `INST_SRLI_MASK) == `INST_SRLI)   : dbg_inst_str = "srli";
            ((opcode_i & `INST_SRAI_MASK) == `INST_SRAI)   : dbg_inst_str = "srai";
            ((opcode_i & `INST_LUI_MASK) == `INST_LUI)    : dbg_inst_str = "lui";
            ((opcode_i & `INST_AUIPC_MASK) == `INST_AUIPC)  : dbg_inst_str = "auipc";
            ((opcode_i & `INST_ADD_MASK) == `INST_ADD)    : dbg_inst_str = "add";
            ((opcode_i & `INST_SUB_MASK) == `INST_SUB)    : dbg_inst_str = "sub";
            ((opcode_i & `INST_SLT_MASK) == `INST_SLT)    : dbg_inst_str = "slt";
            ((opcode_i & `INST_SLTU_MASK) == `INST_SLTU)   : dbg_inst_str = "sltu";
            ((opcode_i & `INST_XOR_MASK) == `INST_XOR)    : dbg_inst_str = "xor";
            ((opcode_i & `INST_OR_MASK) == `INST_OR)     : dbg_inst_str = "or";
            ((opcode_i & `INST_AND_MASK) == `INST_AND)    : dbg_inst_str = "and";
            ((opcode_i & `INST_SLL_MASK) == `INST_SLL)    : dbg_inst_str = "sll";
            ((opcode_i & `INST_SRL_MASK) == `INST_SRL)    : dbg_inst_str = "srl";
            ((opcode_i & `INST_SRA_MASK) == `INST_SRA)    : dbg_inst_str = "sra";
            ((opcode_i & `INST_JAL_MASK) == `INST_JAL)    : dbg_inst_str = "jal";
            ((opcode_i & `INST_JALR_MASK) == `INST_JALR)   : dbg_inst_str = "jalr";
            ((opcode_i & `INST_BEQ_MASK) == `INST_BEQ)    : dbg_inst_str = "beq";
            ((opcode_i & `INST_BNE_MASK) == `INST_BNE)    : dbg_inst_str = "bne";
            ((opcode_i & `INST_BLT_MASK) == `INST_BLT)    : dbg_inst_str = "blt";
            ((opcode_i & `INST_BGE_MASK) == `INST_BGE)    : dbg_inst_str = "bge";
            ((opcode_i & `INST_BLTU_MASK) == `INST_BLTU)   : dbg_inst_str = "bltu";
            ((opcode_i & `INST_BGEU_MASK) == `INST_BGEU)   : dbg_inst_str = "bgeu";
            ((opcode_i & `INST_LB_MASK) == `INST_LB)     : dbg_inst_str = "lb";
            ((opcode_i & `INST_LH_MASK) == `INST_LH)     : dbg_inst_str = "lh";
            ((opcode_i & `INST_LW_MASK) == `INST_LW)     : dbg_inst_str = "lw";
            ((opcode_i & `INST_LBU_MASK) == `INST_LBU)    : dbg_inst_str = "lbu";
            ((opcode_i & `INST_LHU_MASK) == `INST_LHU)    : dbg_inst_str = "lhu";
            ((opcode_i & `INST_LWU_MASK) == `INST_LWU)    : dbg_inst_str = "lwu";
            ((opcode_i & `INST_SB_MASK) == `INST_SB)     : dbg_inst_str = "sb";
            ((opcode_i & `INST_SH_MASK) == `INST_SH)     : dbg_inst_str = "sh";
            ((opcode_i & `INST_SW_MASK) == `INST_SW)     : dbg_inst_str = "sw";
            ((opcode_i & `INST_ECALL_MASK) == `INST_ECALL)  : dbg_inst_str = "ecall";
            ((opcode_i & `INST_EBREAK_MASK) == `INST_EBREAK) : dbg_inst_str = "ebreak";
            ((opcode_i & `INST_ERET_MASK) == `INST_ERET)   : dbg_inst_str = "eret";
            ((opcode_i & `INST_CSRRW_MASK) == `INST_CSRRW)  : dbg_inst_str = "csrrw";
            ((opcode_i & `INST_CSRRS_MASK) == `INST_CSRRS)  : dbg_inst_str = "csrrs";
            ((opcode_i & `INST_CSRRC_MASK) == `INST_CSRRC)  : dbg_inst_str = "csrrc";
            ((opcode_i & `INST_CSRRWI_MASK) == `INST_CSRRWI) : dbg_inst_str = "csrrwi";
            ((opcode_i & `INST_CSRRSI_MASK) == `INST_CSRRSI) : dbg_inst_str = "csrrsi";
            ((opcode_i & `INST_CSRRCI_MASK) == `INST_CSRRCI) : dbg_inst_str = "csrrci";
            ((opcode_i & `INST_MUL_MASK) == `INST_MUL)    : dbg_inst_str = "mul";
            ((opcode_i & `INST_MULH_MASK) == `INST_MULH)   : dbg_inst_str = "mulh";
            ((opcode_i & `INST_MULHSU_MASK) == `INST_MULHSU) : dbg_inst_str = "mulhsu";
            ((opcode_i & `INST_MULHU_MASK) == `INST_MULHU)  : dbg_inst_str = "mulhu";
            ((opcode_i & `INST_DIV_MASK) == `INST_DIV)    : dbg_inst_str = "div";
            ((opcode_i & `INST_DIVU_MASK) == `INST_DIVU)   : dbg_inst_str = "divu";
            ((opcode_i & `INST_REM_MASK) == `INST_REM)    : dbg_inst_str = "rem";
            ((opcode_i & `INST_REMU_MASK) == `INST_REMU)   : dbg_inst_str = "remu";
            ((opcode_i & `INST_IFENCE_MASK) == `INST_IFENCE)  : dbg_inst_str = "fence.i";
        endcase

        case (1'b1)

            ((opcode_i & `INST_ADDI_MASK) == `INST_ADDI) ,  // addi
            ((opcode_i & `INST_ANDI_MASK) == `INST_ANDI) ,  // andi
            ((opcode_i & `INST_SLTI_MASK) == `INST_SLTI) ,  // slti
            ((opcode_i & `INST_SLTIU_MASK) == `INST_SLTIU) , // sltiu
            ((opcode_i & `INST_ORI_MASK) == `INST_ORI) ,   // ori
            ((opcode_i & `INST_XORI_MASK) == `INST_XORI) ,  // xori
            ((opcode_i & `INST_CSRRW_MASK) == `INST_CSRRW) , // csrrw
            ((opcode_i & `INST_CSRRS_MASK) == `INST_CSRRS) , // csrrs
            ((opcode_i & `INST_CSRRC_MASK) == `INST_CSRRC) , // csrrc
            ((opcode_i & `INST_CSRRWI_MASK) == `INST_CSRRWI) ,// csrrwi
            ((opcode_i & `INST_CSRRSI_MASK) == `INST_CSRRSI) ,// csrrsi
            ((opcode_i & `INST_CSRRCI_MASK) == `INST_CSRRCI) :// csrrci
            begin
                dbg_inst_rb  = "-";
            end

            ((opcode_i & `INST_SLLI_MASK) == `INST_SLLI) , // slli
            ((opcode_i & `INST_SRLI_MASK) == `INST_SRLI) , // srli
            ((opcode_i & `INST_SRAI_MASK) == `INST_SRAI) : // srai
            begin
                dbg_inst_rb  = "-";
            end

            ((opcode_i & `INST_LUI_MASK) == `INST_LUI) : // lui
            begin
                dbg_inst_ra  = "-";
                dbg_inst_rb  = "-";
            end

            ((opcode_i & `INST_AUIPC_MASK) == `INST_AUIPC) : // auipc
            begin
                dbg_inst_ra  = "pc";
                dbg_inst_rb  = "-";
            end   

            ((opcode_i & `INST_JAL_MASK) == `INST_JAL) :  // jal
            begin
                dbg_inst_ra  = "-";
                dbg_inst_rb  = "-";

                if (rd_idx_w == 5'd1)
                    dbg_inst_str = "call";
            end

            ((opcode_i & `INST_JALR_MASK) == `INST_JALR) : // jalr
            begin
                dbg_inst_rb  = "-";

               if (ra_idx_w == 5'd1 && `DBG_IMM_IMM12 == 32'b0)
                    dbg_inst_str = "ret";
               else if (rd_idx_w == 5'd1)
                    dbg_inst_str = "call (R)";
            end

            // lb lh lw lbu lhu lwu
            ((opcode_i & `INST_LB_MASK) == `INST_LB) ,
            ((opcode_i & `INST_LH_MASK) == `INST_LH) ,
            ((opcode_i & `INST_LW_MASK) == `INST_LW) ,
            ((opcode_i & `INST_LBU_MASK) == `INST_LBU) ,
            ((opcode_i & `INST_LHU_MASK) == `INST_LHU) ,
            ((opcode_i & `INST_LWU_MASK) == `INST_LWU) :
            begin
                dbg_inst_rb  = "-";
            end 

            // sb sh sw
            ((opcode_i & `INST_SB_MASK) == `INST_SB) ,
            ((opcode_i & `INST_SH_MASK) == `INST_SH) ,
            ((opcode_i & `INST_SW_MASK) == `INST_SW) :
            begin
                dbg_inst_rd  = "-";
            end
        endcase        
    end
end

endmodule
