class apb_env;
	 apb_agent agent;
	 apb_scb scb;
	 
	 task run();
		  agent = new();
		  scb = new();
		  
		  fork
			   agent.run();
			   scb.run();
		  join
	 endtask
endclass
