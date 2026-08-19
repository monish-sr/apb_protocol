class apb_cov;
	 apb_tx tx;
	 virtual apb_intf vif;

	 // Covg 1: ADDR x WRITE
	 covergroup cg_tx;

		  C_PADDR: coverpoint tx.PADDR{
			   option.auto_bin_max = 4;
		  }

		  C_WR: coverpoint tx.PWRITE{
			   bins HIGH = {1'b1};
			   bins LOW = {1'b0};
			   }

		  C_PADDR_X_C_PWR: cross C_PADDR,C_WR;

	 endgroup

	 // Covg 2: PSEL x PENABLE
	 covergroup cg_vif @(posedge vif.PCLK);
		  C_PSEL: coverpoint vif.PSEL{
			   bins HIGH = {1'b1};
			   bins LOW = {1'b0};
		  }

		  C_PENABLE: coverpoint vif.PENABLE{
			   bins HIGH = {1'b1};
			   bins LOW = {1'b0};
		  }

		  C_PSEL_X_C_PENABLE: cross C_PSEL,C_PENABLE{
			   illegal_bins NOT_SEL_EN = binsof(C_PSEL) intersect {0} && binsof(C_PENABLE) intersect {1};
			   }
	 endgroup

	 function new();
		  vif = top.pif;
		  cg_tx = new();
		  cg_vif = new();
	 endfunction

	 task run();
		  forever begin
			   mon2cov.get(tx);
			   //tx.print("COV");
			   cg_tx.sample();
			   cg_vif.sample();
		  end
	 endtask
endclass
