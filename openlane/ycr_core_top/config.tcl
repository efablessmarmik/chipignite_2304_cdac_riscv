# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

set script_dir [file dirname [file normalize [info script]]]

set ::env(ROUTING_CORES) "6"

set ::env(DESIGN_NAME) ycr_core_top
set ::env(DESIGN_IS_CORE) "0"
set ::env(FP_PDN_CORE_RING) "0"

set ::env(CLOCK_PERIOD) "10"
set ::env(CLOCK_PORT) "clk"

set ::env(SYNTH_MAX_FANOUT) 4

## CTS BUFFER
set ::env(CTS_CLK_BUFFER_LIST) "sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8"
set ::env(CTS_SINK_CLUSTERING_SIZE) "16"
set ::env(CLOCK_BUFFER_FANOUT) "8"
set ::env(LEC_ENABLE) 0

set ::env(VERILOG_FILES) "\
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/core/pipeline/ycr_pipe_top.sv           \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/core/ycr_core_top.sv                    \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/core/ycr_dm.sv                          \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/core/ycr_tapc_synchronizer.sv           \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/core/ycr_clk_ctrl.sv                    \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/core/ycr_scu.sv                         \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/core/ycr_tapc.sv                        \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/core/ycr_tapc_shift_reg.sv              \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/core/ycr_dmi.sv                         \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/core/primitives/ycr_reset_cells.sv      \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/core/pipeline/ycr_pipe_ifu.sv           \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/core/pipeline/ycr_pipe_idu.sv           \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/core/pipeline/ycr_pipe_exu.sv           \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/core/pipeline/ycr_pipe_mprf.sv          \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/core/pipeline/ycr_pipe_csr.sv           \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/core/pipeline/ycr_pipe_ialu.sv          \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/core/pipeline/ycr_pipe_mul.sv           \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/core/pipeline/ycr_pipe_div.sv           \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/core/pipeline/ycr_pipe_lsu.sv           \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/core/pipeline/ycr_pipe_hdu.sv           \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/core/pipeline/ycr_pipe_tdu.sv           \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/core/pipeline/ycr_ipic.sv               \
    $::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/top/ycr_req_retiming.sv               \
    $::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/lib/sync_fifo2.sv                     \
	"
set ::env(VERILOG_INCLUDE_DIRS) [glob $::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/includes ]
set ::env(SYNTH_READ_BLACKBOX_LIB) 1
set ::env(SYNTH_DEFINES) [list SYNTHESIS ]


set ::env(SDC_FILE) $::env(DESIGN_DIR)/base.sdc
set ::env(BASE_SDC_FILE) $::env(DESIGN_DIR)/base.sdc

set ::env(LEC_ENABLE) 0

set ::env(VDD_PIN) [list {vccd1}]
set ::env(GND_PIN) [list {vssd1}]

## Floorplan
set ::env(FP_PIN_ORDER_CFG) $::env(DESIGN_DIR)/pin_order.cfg
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 540 950 "

set ::env(PL_TARGET_DENSITY) 0.43
set ::env(CELL_PAD) "4"

## Routing
set ::env(GRT_ADJUSTMENT) 0.2

#set ::env(GLB_RT_MAXLAYER) 5
set ::env(RT_MAX_LAYER) {met4}
#set ::env(GLB_RT_MAX_DIODE_INS_ITERS) 10
set ::env(DIODE_INSERTION_STRATEGY) 3


set ::env(QUIT_ON_TIMING_VIOLATIONS) "0"
set ::env(QUIT_ON_MAGIC_DRC) "1"
set ::env(QUIT_ON_LVS_ERROR) "1"
set ::env(QUIT_ON_SLEW_VIOLATIONS) "0"

#Need to cross-check why global timing opimization creating setup vio with hugh hold fix
set ::env(GLB_RESIZER_TIMING_OPTIMIZATIONS) "0"

