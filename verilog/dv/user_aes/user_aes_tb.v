////////////////////////////////////////////////////////////////////////////
// SPDX-FileCopyrightText:  2021 , Dinesh Annayya
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0
// SPDX-FileContributor: Modified by Dinesh Annayya <dinesha@opencores.org>
//////////////////////////////////////////////////////////////////////
////                                                              ////
////  Standalone User validation Test bench                       ////
////                                                              ////
////  This file is part of the Riscduino cores project            ////
////                                                              ////
////  Description                                                 ////
////   This is a standalone test bench to validate the            ////
////   Digital core with Risc core executing code from TCM/SRAM.  ////
////   with icache and dcache bypass mode                         ////
////                                                              ////
////  To Do:                                                      ////
////    nothing                                                   ////
////                                                              ////
////  Author(s):                                                  ////
////      - Dinesh Annayya, dinesha@opencores.org                 ////
////                                                              ////
////  Revision :                                                  ////
////    0.1 - 16th Feb 2021, Dinesh A                             ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`default_nettype wire

`timescale 1 ns / 1 ns

`include "sram_macros/sky130_sram_2kbyte_1rw1r_32x512_8.v"
`include "uart_agent.v"
module user_aes_tb;

parameter real CLK1_PERIOD  = 20; // 50Mhz
parameter real CLK2_PERIOD = 2.5;
parameter real IPLL_PERIOD = 5.008;
parameter real XTAL_PERIOD = 6;

`include "user_tasks.sv"


//----------------------------------
// Uart Configuration
// ---------------------------------
reg [1:0]      uart_data_bit        ;
reg	       uart_stop_bits       ; // 0: 1 stop bit; 1: 2 stop bit;
reg	       uart_stick_parity    ; // 1: force even parity
reg	       uart_parity_en       ; // parity enable
reg	       uart_even_odd_parity ; // 0: odd parity; 1: even parity

reg [7:0]      uart_data            ;
reg [15:0]     uart_divisor         ;	// divided by n * 16
reg [15:0]     uart_timeout         ;// wait time limit

reg [15:0]     uart_rx_nu           ;
reg [15:0]     uart_tx_nu           ;
reg [7:0]      uart_write_data [0:39];
reg 	       uart_fifo_enable     ;	// fifo mode disable



     /************* Port-B Mapping **********************************
     *   Pin-14       PB0/CLKO/ICP1             digital_io[11]
     *   Pin-15       PB1/SS[1]OC1A(PWM3)       digital_io[12]
     *   Pin-16       PB2/SS[0]/OC1B(PWM4)      digital_io[13]
     *   Pin-17       PB3/MOSI/OC2A(PWM5)       digital_io[14]
     *   Pin-18       PB4/MISO                  digital_io[15]
     *   Pin-19       PB5/SCK                   digital_io[16]
     *   Pin-9        PB6/XTAL1/TOSC1           digital_io[6]
     *   Pin-10       PB7/XTAL2/TOSC2           digital_io[7]
     *   ********************************************************/

     wire [7:0]  port_b_in = {   io_out[7],
		                 io_out[6],
		                 io_out[16],
		                 io_out[15],
			         io_out[14],
			         io_out[13],
		                 io_out[12],
		                 io_out[11]
			     };
	initial begin
		test_fail = 0;
                wbd_ext_cyc_i ='h0;  // strobe/request
                wbd_ext_stb_i ='h0;  // strobe/request
                wbd_ext_adr_i ='h0;  // address
                wbd_ext_we_i  ='h0;  // write
                wbd_ext_dat_i ='h0;  // data output
                wbd_ext_sel_i ='h0;  // byte enable
	end

	`ifdef WFDUMP
	   initial begin
	   	$dumpfile("simx.vcd");
	   	$dumpvars(2, user_aes_tb);
	   	$dumpvars(0, user_aes_tb.u_top.u_riscv_top);
	   	$dumpvars(0, user_aes_tb.u_top.u_uart_i2c_usb_spi.u_uart0_core);
	   end
       `endif

	initial begin

	       $value$plusargs("risc_core_id=%d", d_risc_id);
           init();

               uart_data_bit           = 2'b11;
               uart_stop_bits          = 0; // 0: 1 stop bit; 1: 2 stop bit;
               uart_stick_parity       = 0; // 1: force even parity
               uart_parity_en          = 0; // parity enable
               uart_even_odd_parity    = 1; // 0: odd parity; 1: even parity
               uart_divisor            = 15;// divided by n * 16
               uart_timeout            = 500;// wait time limit
               uart_fifo_enable        = 0;	// fifo mode disable

               #200; // Wait for reset removal
               repeat (10) @(posedge clock);
               $display("Monitor: Standalone User Uart Test Started");
               
               // Remove Wb Reset
               //wb_user_core_write(`ADDR_SPACE_WBHOST+`WBHOST_GLBL_CFG,'h1);

               // Enable UART Multi Functional Ports
               wb_user_core_write(`ADDR_SPACE_GLBL+`GLBL_CFG_MUTI_FUNC,'h100);
               
                wait_riscv_boot();
               repeat (2) @(posedge clock);
               #1;
		// Remove all the reset
		if(d_risc_id == 0) begin
		     $display("STATUS: Working with Risc core 0");
                   //wb_user_core_write(`ADDR_SPACE_GLBL+`GLBL_CFG_CFG0,'h11F);
		end else if(d_risc_id == 1) begin
		     $display("STATUS: Working with Risc core 1");
                     wb_user_core_write(`ADDR_SPACE_GLBL+`GLBL_CFG_CFG0,'h21F);
		end else if(d_risc_id == 2) begin
		     $display("STATUS: Working with Risc core 2");
                     wb_user_core_write(`ADDR_SPACE_GLBL+`GLBL_CFG_CFG0,'h41F);
		end else if(d_risc_id == 3) begin
		     $display("STATUS: Working with Risc core 3");
                     wb_user_core_write(`ADDR_SPACE_GLBL+`GLBL_CFG_CFG0,'h81F);
		end

               repeat (100) @(posedge clock);  // wait for Processor Get Ready

               tb_uart.uart_init;
               wb_user_core_write(`ADDR_SPACE_UART0+8'h0,{3'h0,2'b00,1'b1,1'b1,1'b1});  
               tb_uart.control_setup (uart_data_bit, uart_stop_bits, uart_parity_en, uart_even_odd_parity, 
                                              uart_stick_parity, uart_timeout, uart_divisor);

		// Set the PORT-B Direction as Output
                wb_user_core_write(`ADDR_SPACE_GPIO+`GPIO_CFG_DSEL,'h0000FF00);
		// Set the GPIO Output data: 0x00000000
                wb_user_core_write(`ADDR_SPACE_GPIO+`GPIO_CFG_ODATA,'h0000000);
   
              fork
	          begin
                     repeat (1400000) @(posedge clock); 
	          end
	          begin
                     wait(port_b_in == 8'h18);
	          end
	          begin
                     while(1) begin
                        wb_user_core_read(`ADDR_SPACE_GPIO+`GPIO_CFG_ODATA,read_data);
                        repeat (1000) @(posedge clock); 
                     end
	          end
               join_any
	
	       wb_user_core_read_check(`ADDR_SPACE_GLBL+`GLBL_CFG_SOFT_REG_0,read_data,32'h00000000);

               $display("###################################################");
               if(test_fail == 0) begin
                  `ifdef GL
                      $display("Monitor: %m (GL) Passed");
                  `else
                      $display("Monitor: %m (RTL) Passed");
                  `endif
               end else begin
                   `ifdef GL
                       $display("Monitor: %m (GL) Failed");
                   `else
                       $display("Monitor: %m (RTL) Failed");
                   `endif
                end
               $display("###################################################");
               #100
               $finish;

	end



// SSPI Slave I/F
assign io_in[5]  = 1'b1; // RESET
assign io_in[21] = 1'b0 ; // SPIS SCK 


//------------------------------------------------------
//  Integrate the Serial flash with qurd support to
//  user core using the gpio pads
//  ----------------------------------------------------

   wire flash_clk = io_out[28];
   wire flash_csb = io_out[29];
   // Creating Pad Delay
   wire #1 io_oeb_29 = io_oeb[33];
   wire #1 io_oeb_30 = io_oeb[34];
   wire #1 io_oeb_31 = io_oeb[35];
   wire #1 io_oeb_32 = io_oeb[36];
   tri  #1 flash_io0 = (io_oeb_29== 1'b0) ? io_out[33] : 1'bz;
   tri  #1 flash_io1 = (io_oeb_30== 1'b0) ? io_out[34] : 1'bz;
   tri  #1 flash_io2 = (io_oeb_31== 1'b0) ? io_out[35] : 1'bz;
   tri  #1 flash_io3 = (io_oeb_32== 1'b0) ? io_out[36] : 1'bz;

   assign io_in[33] = flash_io0;
   assign io_in[34] = flash_io1;
   assign io_in[35] = flash_io2;
   assign io_in[36] = flash_io3;

   // Quard flash
     s25fl256s #(.mem_file_name("user_aes.hex"),
	         .otp_file_name("none"),
                 .TimingModel("S25FL512SAGMFI010_F_30pF")) 
		 u_spi_flash_256mb (
           // Data Inputs/Outputs
       .SI      (flash_io0),
       .SO      (flash_io1),
       // Controls
       .SCK     (flash_clk),
       .CSNeg   (flash_csb),
       .WPNeg   (flash_io2),
       .HOLDNeg (flash_io3),
       .RSTNeg  (!wb_rst_i)

       );


//---------------------------
//  UART Agent integration
// --------------------------
wire uart_txd,uart_rxd;

assign uart_txd   = io_out[7];
assign io_in[6]  = uart_rxd ;
 
uart_agent tb_uart(
	.mclk                (clock              ),
	.txd                 (uart_rxd           ),
	.rxd                 (uart_txd           )
	);



endmodule
`include "s25fl256s.sv"
`default_nettype wire
