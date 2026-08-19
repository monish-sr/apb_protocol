class apb_bfm;
	 apb_tx tx;
	 virtual apb_intf vif;

	 function new();
		  vif = top.pif;
	 endfunction

	 task run();
		  wait(vif.PRESET_N == 1);
		  reset();
		  forever begin
			   gen2bfm.get(tx);
			   drive_tx(tx);
			   
		  apb_common::bfm_count++;
		  end
	 endtask

	 task drive_tx(apb_tx tx);
		  @(posedge vif.PCLK);
		  vif.PADDR <= tx.PADDR;
		  vif.PWRITE <= tx.PWRITE;
		  
		  if(tx.PWRITE == 1) begin
			   vif.PWDATA <= tx.PWDATA;
		  end
		 
		  vif.PSEL <= 1'b1;
		  @(posedge vif.PCLK);
		  vif.PENABLE <= 1'b1;
		 
		  wait(vif.PREADY == 1'b1);

		  if(tx.PWRITE == 0)  tx.PRDATA = vif.PRDATA;

		  @(posedge vif.PCLK);
		  vif.PSEL <= 1'b0;
		  vif.PENABLE <= 1'b0;

	 endtask

	 task reset();
		  vif.PADDR <= 1'b0;
		  vif.PWRITE <= 1'b0;
		  vif.PSEL <= 1'b0;
		  vif.PENABLE <= 1'b0;
		  vif.PWDATA <= 1'b0;

	 endtask
endclass
