class apb_mon;
	 virtual apb_intf vif;
	 apb_tx tx;
	 function new();
		  vif = top.pif;
	 endfunction

	 task run();
		  forever begin
			   @(posedge vif.PCLK);
			   if((vif.PENABLE==1) && (vif.PREADY == 1)) begin
					tx = new();
					tx.PADDR = vif.PADDR;
					tx.PWRITE = vif.PWRITE;

					if(tx.PWRITE == 1) begin
						 tx.PWDATA = vif.PWDATA;

					end

					else begin
						 tx.PRDATA = vif.PRDATA;
					end

					mon2cov.put(tx);
			    	mon2scb.put(tx);
			   end
		  end
	 endtask

endclass
