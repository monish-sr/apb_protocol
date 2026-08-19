class apb_agent;
	 apb_gen gen;
	 apb_bfm bfm;
	 apb_mon mon;
	 apb_cov cov;
	 
	 task run();
		  gen = new();
		  bfm = new();
		  mon = new();
		  cov = new();
		  fork
			   gen.run();
			   bfm.run();
	           mon.run();
			   cov.run();
		  join
	 endtask
endclass
