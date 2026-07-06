// (C) 2001-2023 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


class eth_gdr_multi_instance_ptp_sanity_sequence extends uvm_sequence;

`uvm_object_utils(eth_gdr_multi_instance_ptp_sanity_sequence)

`uvm_declare_p_sequencer(eth_top_virtual_sequencer)

ptp_sanity_sequence seq[`NUM_INST];

 function new(string name = "eth_gdr_multi_instance_ptp_sanity_sequence");
    super.new(name);

 endfunction:new


   virtual task pre_body();
      uvm_phase phase;
      super.pre_body();
      phase = starting_phase;
      if (phase!=null) begin
	    phase.raise_objection(this);
      end

      foreach (seq[i]) 
      begin
         if (!$cast(seq[i], factory.create_object_by_name("ptp_sanity_sequence"))) begin
            `uvm_fatal("TEST:NOTASEQ", {"Type ", "ptp_sanity_sequence" , " is not a sequence type"});
         end
      end



   endtask: pre_body

   virtual task post_body();
      uvm_phase phase;
      super.post_body();
      phase = starting_phase;
      if (phase!=null) begin
	    phase.drop_objection(this);
      end
   endtask: post_body



   virtual task body();
	 `uvm_info("virtual sequence ", $psprintf(" I AM IN BODY OF VIRTUAL SEQ "),UVM_NONE);
 
         foreach (seq[i]) begin
	    automatic int j=i;
            p_sequencer.top_env.env_ip[j].inst_num = j;
            `uvm_info(get_full_name(),$sformatf("i is %0d, j is %d, inst_num is %0d", i, j, p_sequencer.top_env.env_ip[j].inst_num), UVM_MEDIUM)
	    fork
	        begin
                   begin
		      p_sequencer.top_env.env_ip[j].wait_for_linkup(.ip_sync(1)); 
                      seq[j].start(p_sequencer.virtual_sequencer_inst[j]);
                   end
            	end  // fork 
	    join_none
	 end  // foreach 
    	 wait fork;
       #10us;
   endtask // body 






endclass

