// Generally APB Protocol's Master -> AHB-to-APB Bridge | Bus: APB | Slave -> Peripherals (UART, I2C, etc.,)
// But in this code, Slave -> APB

// IMPLEMENTATION OF APB PROTOCOL WITH *WAIT* STATE (here, waits for 2 cycles)


module apb_prtcl #(parameter IDLE = 2'b00, SETUP = 2'b01, ACCESS = 2'b10)
(PCLK,PRESET_N,PSEL,PENABLE,PWRITE,PADDR,PWDATA,PRDATA,PREADY);
	
	input PCLK,PRESET_N; // GLOBAL SIGNALS

	// INPUT SIGNALS (From Master)
	input PSEL,PENABLE,PWRITE; 
	input [`ADDR_WIDTH-1:0] PADDR;
	input [`WIDTH-1:0] PWDATA;
	
	// OUTPUT SIGNALS (From Slave)
	output reg PREADY;
	output reg [`WIDTH-1:0] PRDATA;

	// INTERNAL SIGNALS
	reg [`WIDTH-1:0] mem [`DEPTH-1:0];
	integer i,wait_count;
	reg [1:0] ps, ns;

	always@(posedge PCLK) begin
		 if(PRESET_N == 0) begin
			  PREADY <= 0;
			  PRDATA <= 0;
			  wait_count <= 0;

			  for(i=0;i<`DEPTH;i=i+1) mem[i] <= 0;

			  ps <= IDLE;
			  ns <= IDLE;
		 end
		 else begin
			  ps <= ns;
		 end

		 if(ps == ACCESS) wait_count <= wait_count + 1;
		 else wait_count <= 0;
		 
	end

	always@(*) begin
		 ns = ps;
	     PRDATA = 0;
		 PREADY = 0;

		 case(ps)	  
			  IDLE: begin
				   if(PSEL == 1 && PENABLE == 0) ns = SETUP;
				   else ns = IDLE;
			  end
		 	  
		      SETUP: begin
				   if(PSEL == 1 && PENABLE == 1) ns = ACCESS;
			  end
		     
		 	  ACCESS:  begin
				   if(wait_count < 2) PREADY = 0;
				   else begin
						PREADY = 1;
						if(PWRITE == 1) mem[PADDR] = PWDATA;
						else PRDATA = mem[PADDR];
				   end
			       
			       if(PSEL == 1 && PENABLE == 0 ) ns = SETUP;
		    	   else if(PSEL == 0) ns = IDLE;
			  end

		 endcase
	end

endmodule
