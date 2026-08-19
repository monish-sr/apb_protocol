class apb_tx;
	 rand bit PWRITE;
	 rand bit [`ADDR_WIDTH-1:0] PADDR;
	 rand bit [`WIDTH-1:0] PWDATA;
	      bit [`WIDTH-1:0] PRDATA;

	 constraint num {
		  PWDATA inside {[0:(2**(`WIDTH))]};
		  PADDR inside {[1:(2**(`ADDR_WIDTH))]};
	 }

	 function void print(input string name = "");
		  $display("-----------Name: %0s [%0d] | Time: %0t-----------",name,(apb_common::bfm_count),$time);
		  $display("PWRITE: %0b",PWRITE);
		  $display("PADDR: %0d",PADDR);
		  $display("PWDATA: %0d",PWDATA);
		  $display("PRDATA: %0d\n",PRDATA);
	 endfunction
endclass
