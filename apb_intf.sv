interface apb_intf (input PCLK,PRESET_N);
	 logic PSEL, PENABLE, PWRITE;
	 logic [`ADDR_WIDTH-1:0] PADDR;
	 logic [`WIDTH-1:0] PWDATA;
	 logic [`WIDTH-1:0] PRDATA;
	 logic PREADY;
endinterface
