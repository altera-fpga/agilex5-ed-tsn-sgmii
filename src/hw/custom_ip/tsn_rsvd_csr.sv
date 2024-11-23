module tsn_rsvd_csr #(
      parameter DATA_WIDTH = 32

    ) (
        // clock
        input var logic                                 clk
			                                  
        // reset
       ,input var logic                               rst 

        // ingress
	   ,input var logic                      write_i
	   ,input var logic                       read_i   

        // egress
	   ,output var logic                      waitrequest_o
	   ,output var logic  [DATA_WIDTH-1:0]     readdata_o
	   ,output var logic                     readdatavalid_o
);
		always @(posedge clk)
			begin
				if(rst)
					waitrequest_o <= 1'b1;
				else if((waitrequest_o != 0) && (write_i | read_i))
					waitrequest_o <= 1'b0;
				else
					waitrequest_o <= 1'b1;
		end

			//Generating rd_vld signal
		always @(posedge clk)
			begin
				 if(rst) begin
					readdatavalid_o <= 1'b0;
         				readdata_o <= '0;
				 end else if ((readdatavalid_o !=1) && read_i) begin
					readdatavalid_o <= 1'b1;
         				readdata_o <= '0;
				 end else begin
					readdatavalid_o <= 1'b0;
         				readdata_o <= '0;
				 end
		end
/*
     always_ff @(posedge clk) begin
       if (write_i) begin
         //waitrequest_o   <= '0;
         readdatavalid_o <= '0;
       end else if (read_i) begin
         //waitrequest_o   <= '0;
         readdatavalid_o <= '1;
       end else begin
         //waitrequest_o   <= '1;
         readdatavalid_o <= '0;
       end

       if (rst) begin
         //waitrequest_o <= '1;
         readdata_o <= '0;
         readdatavalid_o <= '0;
       end

     end
*/
endmodule
