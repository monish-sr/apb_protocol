`define DEPTH 16
`define WIDTH 4
`define ADDR_WIDTH $clog2(`DEPTH)

`include "apb_design.v"
`include "apb_common.sv"
`include "apb_tx.sv"
`include "apb_intf.sv"
`include "apb_cov.sv"
`include "apb_mon.sv"
`include "apb_bfm.sv"
`include "apb_gen.sv"
`include "apb_scb.sv"
`include "apb_agent.sv"
`include "apb_env.sv"
`include "apb_assert.sv"
bind apb_prtcl apb_assert u_apb_assert(.*);
`include "apb_top.sv"
