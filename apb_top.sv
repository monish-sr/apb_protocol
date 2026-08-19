module top #(parameter IDLE = 2'b00, SETUP = 2'b01, ACCESS = 2'b10);
	
	bit PCLK,PRESET_N;
	apb_intf pif(PCLK,PRESET_N);

	apb_prtcl #(.IDLE(IDLE), .SETUP(SETUP), .ACCESS(ACCESS))
		dut(
			 .PCLK(pif.PCLK),
			 .PRESET_N(pif.PRESET_N),
			 .PSEL(pif.PSEL),
			 .PENABLE(pif.PENABLE),
			 .PWRITE(pif.PWRITE),
			 .PADDR(pif.PADDR),
			 .PWDATA(pif.PWDATA),
			 .PRDATA(pif.PRDATA),
			 .PREADY(pif.PREADY)
			 );

	
	apb_env env;

	always #5 PCLK = ~PCLK;
	initial begin
		 PCLK = 0;
		 PRESET_N = 0;

		 pif.PSEL = 0;
		 pif.PENABLE = 0;
		 pif.PADDR = 0;
		 pif.PWRITE = 0;
		 pif.PWDATA = 0;

		 repeat(2) @(posedge PCLK);
		 PRESET_N = 1;

		 env = new();
		 env.run();
	end

	initial #1000 $finish();

	initial begin

		 case(apb_common::testname)
			  "1W": wait(apb_common::bfm_count == 1);
			  "5W": wait(apb_common::bfm_count == 5);
			  "NW": wait(apb_common::bfm_count == apb_common::N);
			  "1WRD": wait(apb_common::bfm_count == 1*2);
			  "5WRD": wait(apb_common::bfm_count == 5*2);
			  "NWRD": wait(apb_common::bfm_count == apb_common::N*2);
		 endcase
		 #1;

		 if(apb_common::testname == "1WRD" || apb_common::testname == "5WRD" || apb_common::testname == "NWRD") begin
			  if(apb_common::matching!=0 && (apb_common::matching == apb_common::N || apb_common::matching == 5 || apb_common::matching == 1) && apb_common::mismatching == 0 )
				   $display("\nTESTCASE PASSED!\nTestname: %0s | Matching: %0d | Mismatching: %0d | Count: %0d",apb_common::testname,apb_common::matching, apb_common::mismatching,apb_common::bfm_count);
			  else

				   $display("\nTESTCASE FAILED!\nTestname: %0s | Matching: %0d | Mismatching: %0d | Count: %0d",apb_common::testname,apb_common::matching, apb_common::mismatching,apb_common::bfm_count);
		 end

		 else $display("TESTCASE PASSED!\nTestname: %0s | Count: %0d",apb_common::testname,apb_common::bfm_count);
		 
	end
endmodule
