`ifndef __MUX_ETH_DRIVER__
`define __MUX_ETH_DRIVER__


class mux_eth_driver extends altuvm_driver#(svt_ethernet_transaction);
  //
  svt_ethernet_transaction      pkt;
  int                           pkt_cnt;
  //
  uvm_blocking_put_port #(svt_ethernet_transaction) put_port;

  // Factory registration
  `uvm_component_utils_begin(mux_eth_driver)
  `uvm_component_utils_end

  //constructor
  function new(string name = "mux_eth_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //Build
  function void build_phase(uvm_phase phase);
    //
    super.build_phase(phase);
    //
    put_port = new("put_port", this);
    pkt_cnt =1;
  endfunction

  //Run
  task run_phase(uvm_phase phase);
     begin
       forever begin
         seq_item_port.get_next_item(req);
         req.create_ethernet_transaction();
         // Cast the transaction
         $cast(pkt, req.clone());
         // Send transaction to commong driver
         put_port.put(pkt);
         `uvm_info(get_type_name(), $sformatf("Sent Transaction No: %0d", pkt_cnt), UVM_HIGH)
         // Please add logic over here if needed
         pkt_cnt++;
         seq_item_port.item_done();
       end
     end
  endtask
  
endclass : mux_eth_driver
`endif // __MUX_ETH_DRIVER__
