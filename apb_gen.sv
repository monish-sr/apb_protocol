class apb_gen;

	 apb_tx tx,temp[$],t;

	 int used_addr_arr[$];
	 task run();
		  case(apb_common::testname)

			   "1W": begin // 1-TIME WRITE
					tx = new();
					tx.randomize() with {tx.PWRITE == 1;};
					gen2bfm.put(tx);
			   end

			   "5W": begin // 5-TIME WRITE
					repeat(5) begin
						 tx = new();
						 tx.randomize() with {tx.PWRITE == 1; !(tx.PADDR inside {used_addr_arr});};
						 gen2bfm.put(tx);
						 used_addr_arr.push_back(tx.PADDR);
					end
			   end

			   "NW": begin // N-TIME WRITE
					repeat(apb_common::N) begin
						 tx = new();
						 tx.randomize() with {tx.PWRITE == 1;!(tx.PADDR inside {used_addr_arr});};
						 gen2bfm.put(tx);
						 used_addr_arr.push_back(tx.PADDR);
					end
			   end

			   "1WRD": begin // 1-TIME WRITE AND READ
			   		begin
						 tx = new();
						 tx.randomize() with {tx.PWRITE == 1;};
						 gen2bfm.put(tx);
						 temp.push_back(tx);
			   		end

			   		begin
						 t = temp.pop_front();
						 tx = new();
						 tx.randomize() with {tx.PWRITE == 0;tx.PADDR == t.PADDR; tx.PWDATA == 0;};
						 gen2bfm.put(tx);
					end
			   end

			   "5WRD": begin // 5-TIMES WRITE AND READ
					repeat(5) begin
						 tx = new();
						 tx.randomize() with {tx.PWRITE == 1; !(tx.PADDR inside {used_addr_arr});};
						 gen2bfm.put(tx);
						 used_addr_arr.push_back(tx.PADDR);
						 temp.push_back(tx);
					end

					repeat(5) begin
						 tx = new();
						 t = temp.pop_front();
						 tx.randomize() with {tx.PWRITE == 0; tx.PADDR == t.PADDR; tx.PWDATA == 0;};
						 gen2bfm.put(tx);
					end
			   end

			   "NWRD": begin // N-TIMES WRITE AND READ
					repeat(apb_common::N) begin
						 tx = new();
						 tx.randomize() with {tx.PWRITE == 1; !(tx.PADDR inside {used_addr_arr});};
						 gen2bfm.put(tx);
						 used_addr_arr.push_back(tx.PADDR);
						 temp.push_back(tx);
					end

					repeat(apb_common::N) begin
						 tx = new();
						 t = temp.pop_front();
						 tx.randomize() with {tx.PWRITE == 0; tx.PADDR == t.PADDR; tx.PWDATA == 0;};
						 gen2bfm.put(tx);
					end
			   end

			   default: $error("INVALID CASE!");
		  endcase
	 endtask
endclass
