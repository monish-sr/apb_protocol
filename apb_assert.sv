module apb_assert(PCLK,PRESET_N,PSEL,PENABLE,PWRITE,PADDR,PWDATA,PRDATA,PREADY);
	
	input PCLK,PRESET_N,PSEL,PENABLE,PWRITE,PREADY;
	input [`ADDR_WIDTH-1:0] PADDR;
	input [`WIDTH-1:0]PWDATA, PRDATA;

	
	property no_enable_without_sel;
		 @(posedge PCLK) disable iff(!PRESET_N)
		 !PSEL |-> !PENABLE;
	endproperty
	NO_ENABLE_WITHOUT_SEL: assert property(no_enable_without_sel)
	else $error("Enable is high without Select!");

	property pready_signals_stable;
		 @(posedge PCLK) disable iff(!PRESET_N)
		 (PSEL && PENABLE && !PREADY) |=> $stable(PADDR);
	endproperty
	PREADY_SIGNALS_STABLE: assert property(pready_signals_stable)
	else $error("PADDR is not stable");

	property penable_low_b4_setup;
		 @(posedge PCLK) disable iff(!PRESET_N)
		 (PENABLE && PREADY) |=> !PENABLE;
	endproperty
	PENABLE_LOW_B4_SETUP: assert property(penable_low_b4_setup)
	else $error("PENABLE is not deasserted after PREADY - protocol stuck in ACCESS");

	property prdata_no_unknown;
		 @(posedge PCLK) disable iff(!PRESET_N)
		 !$isunknown(PRDATA);
	endproperty

	PRDATA_NO_UNKNOWN: assert property(prdata_no_unknown)
	else $error("PRDATA is unknown!");

endmodule


