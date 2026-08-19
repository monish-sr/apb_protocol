class apb_scb;
	 apb_tx tx;
	 bit [`WIDTH-1:0] mem[*];

	 task run();
		  forever begin
			   mon2scb.get(tx);
			   if(tx.PWRITE) mem[tx.PADDR] = tx.PWDATA;
			   
			   else begin
					if(tx.PRDATA == mem[tx.PADDR]) apb_common::matching++;
					else apb_common::mismatching++;
			   end

			   tx.print("SCB");
		  end
	 endtask
endclass
