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

set ::env(DESIGN_NAME) ycr4_iconnect
set ::env(DESIGN_IS_CORE) "0"
set ::env(FP_PDN_CORE_RING) "0"

# Timing configuration
set ::env(CLOCK_PERIOD) "10"
set ::env(CLOCK_PORT) "core_clk rtc_clk"

set ::env(SYNTH_MAX_FANOUT) 4

## CTS BUFFER
set ::env(CTS_CLK_BUFFER_LIST) "sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8"
set ::env(CTS_SINK_CLUSTERING_SIZE) "16"
set ::env(CLOCK_BUFFER_FANOUT) "8"
set ::env(LEC_ENABLE) 0

set ::env(VERILOG_FILES) "\
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/top/ycr4_iconnect.sv                  \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/top/ycr4_cross_bar.sv                 \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/top/ycr4_router.sv                    \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/top/ycr_dmem_router.sv                \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/top/ycr_sram_mux.sv                   \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/top/ycr_tcm.sv                        \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/top/ycr_timer.sv                      \
    $::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/top/ycr_req_retiming.sv               \
    $::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/lib/ycr_arb.sv                        \
    $::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/lib/ctech_cells.sv                    \
    $::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/lib/sync_fifo2.sv                     \
	$::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/core/primitives/ycr_reset_cells.sv    \
	"
set ::env(VERILOG_INCLUDE_DIRS) [glob $::env(DESIGN_DIR)/../../verilog/rtl/yifive/ycr4c/src/includes ]
set ::env(SYNTH_READ_BLACKBOX_LIB) 1
set ::env(SYNTH_DEFINES) [list SYNTHESIS ]


set ::env(SDC_FILE) $::env(DESIGN_DIR)/base.sdc
set ::env(BASE_SDC_FILE) $::env(DESIGN_DIR)/base.sdc

set ::env(LEC_ENABLE) 0

## Floorplan
set ::env(FP_PIN_ORDER_CFG) $::env(DESIGN_DIR)/pin_order.cfg
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 390 1900"

set ::env(PL_TARGET_DENSITY) 0.20
set ::env(CELL_PAD) "2"

#set ::env(GLB_RT_ADJUSTMENT) {0.2}

#set ::env(PL_ROUTABILITY_DRIVEN) "1"
set ::env(PL_TIME_DRIVEN) "1"

set ::env(PL_RESIZER_BUFFER_INPUT_PORTS) {1}
set ::env(PL_RESIZER_BUFFER_OUTPUT_PORTS) {1}
set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) {1}
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) {1}
set ::env(GLB_OPTIMIZE_MIRRORING) {1}
set ::env(GLB_RESIZER_TIMING_OPTIMIZATIONS) {1}

### PDN
#set ::env(FP_PDN_CHECK_NODES) "0"
#set ::env(FP_PDN_HORIZONTAL_HALO) "10"
#set ::env(FP_PDN_VERTICAL_HALO) "10"
#
#set ::env(FP_PDN_VOFFSET) "5"
#set ::env(FP_PDN_VPITCH) "80"
#set ::env(FP_PDN_VSPACING) "15.5"
#set ::env(FP_PDN_VWIDTH) "3.1"
#
#set ::env(FP_PDN_HOFFSET) "10"
#set ::env(FP_PDN_HPITCH) "100"
#set ::env(FP_PDN_HSPACING) "10"
#set ::env(FP_PDN_HWIDTH) "3.1"


#set ::env(GLB_RT_MAXLAYER) 5
set ::env(RT_MAX_LAYER) {met4}
#set ::env(GLB_RT_MAX_DIODE_INS_ITERS) 20
set ::env(DIODE_INSERTION_STRATEGY) 3


set ::env(QUIT_ON_TIMING_VIOLATIONS) "0"
set ::env(QUIT_ON_MAGIC_DRC) "1"
set ::env(QUIT_ON_LVS_ERROR) "1"
set ::env(QUIT_ON_SLEW_VIOLATIONS) "0"


