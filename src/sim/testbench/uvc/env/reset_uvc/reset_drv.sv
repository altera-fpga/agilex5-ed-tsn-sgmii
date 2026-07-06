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


//
// Template for UVM-compliant physical-level transactor
//

`ifndef RESET_DRV__SV
`define RESET_DRV__SV


typedef class reset_transaction;
typedef class reset_drv;

class reset_drv extends uvm_driver # (reset_transaction);

   typedef virtual reset_if v_if; 
   virtual spy_interface spy_if;
   v_if drv_if;
   uvm_cmdline_processor inst;   
   string m_sequence; 
   reset_transaction tr;
 
   `uvm_component_utils_begin(reset_drv)
   `uvm_component_utils_end

   extern function new(string name = "reset_drv",uvm_component parent = null); 
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void end_of_elaboration_phase(uvm_phase phase);
   extern virtual function void start_of_simulation_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual task reset_phase(uvm_phase phase);
   extern virtual task configure_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   extern protected virtual task send(reset_transaction tr); 
   extern protected virtual task hold_reset(reset_transaction tr); 
   extern virtual task delay(int no_of_cycle);
   extern virtual task wait_tx_ack(bit exp_val);
   extern virtual task wait_rx_ack(bit exp_val);
   extern virtual task wait_mac_tx_ack(bit exp_val);
   extern virtual task wait_mac_rx_ack(bit exp_val);
   extern virtual task wait_mac_ack(bit exp_val);
   extern virtual task wait_ip_ack(bit exp_val);

endclass: reset_drv


function reset_drv::new(string name = "reset_drv",uvm_component parent = null);
   super.new(name, parent);
endfunction: new

function void reset_drv::build_phase(uvm_phase phase);
   super.build_phase(phase);
   if(!uvm_config_db#(virtual spy_interface)::get(this, "", "spy_interface", spy_if)) begin
       `uvm_fatal("spy_interface", "failed to get spy_interface intf");
     end
   inst = uvm_cmdline_processor::get_inst();
   inst.get_arg_value("+m_sequence=",m_sequence);
endfunction: build_phase

function void reset_drv::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   uvm_config_db#(v_if)::get(this, "", "slv_if", drv_if);
endfunction: connect_phase

function void reset_drv::end_of_elaboration_phase(uvm_phase phase);
   super.end_of_elaboration_phase(phase);
   if (drv_if == null) 
   begin
     `uvm_fatal("NO_CONN", "Virtual port not connected to the actual interface instance");   
   end
endfunction: end_of_elaboration_phase

function void reset_drv::start_of_simulation_phase(uvm_phase phase);
   super.start_of_simulation_phase(phase);
endfunction: start_of_simulation_phase

task reset_drv::reset_phase(uvm_phase phase);
   super.reset_phase(phase);
endtask: reset_phase

task reset_drv::configure_phase(uvm_phase phase);
   super.configure_phase(phase);
endtask:configure_phase


task reset_drv::run_phase(uvm_phase phase);
   super.run_phase(phase);
   
   `uvm_info("reset_DRIVER", "Starting Driver...",UVM_NONE)
   this.drv_if.tx_rst_n      = 1;//1;
   this.drv_if.rx_rst_n      = 1;//1;
   this.drv_if.mac_tx_rst_n      = 1;//1;
   this.drv_if.mac_rx_rst_n      = 1;//1;
   this.drv_if.mac_rst_n      = 1;//1;
   this.drv_if.csr_rst_n     = 1;//1;
   this.drv_if.reconfig_rst_n  = 1;//1;
   this.drv_if.vip_rst       = 0;

   #1ns;

   forever begin
     `uvm_info("reset_DRIVER", "Starting transaction...",UVM_HIGH)
     seq_item_port.get_next_item(tr);
     `uvm_info("reset_DRIVER", $sformatf("\n %0s",tr.sprint()), UVM_MEDIUM);
     if(tr.hold_reset == 1) begin
       hold_reset(tr);
     `uvm_info("reset_DRIVER", "Asserted reset...",UVM_NONE)
     #10us;
          seq_item_port.item_done();
          #1ns;
   end 
   else begin
     send(tr); 
     delay(11);
     seq_item_port.item_done();
     #1ns;
     `uvm_info("reset_DRIVER", "Completed reset transaction transaction...",UVM_NONE)
   end
   end
endtask: run_phase

task reset_drv::delay(int no_of_cycle);
  `uvm_info("reset_DRIVER", $sformatf("inside delay task ,no_of_cycle= %0d",no_of_cycle), UVM_LOW);
  repeat(no_of_cycle) @(posedge drv_if.clock);
endtask

task reset_drv::wait_tx_ack(bit exp_val);
  `uvm_info("reset_DRIVER", $sformatf("wait_tx_ack : inside wait TX ACK"), UVM_LOW);
  fork
  begin
    wait(drv_if.tx_rst_ack_n == exp_val);
    `uvm_info("reset_DRIVER", $sformatf("wait_tx_ack : TX ACK detected"), UVM_LOW);
  end
  begin
   //TODO_GDR: B110 SRC ACK slow respond issue
   #700us; //#350us
   `uvm_error(get_type_name(), $sformatf("wait_tx_ack : timeout value exp is %d",exp_val));
  end
  join_any
  disable fork;
endtask

task reset_drv::wait_rx_ack(bit exp_val);
  `uvm_info("reset_DRIVER", $sformatf("wait_rx_ack : inside wait RX ACK"), UVM_LOW);
  fork
  begin
    wait(drv_if.rx_rst_ack_n == exp_val);
    `uvm_info("reset_DRIVER", $sformatf("wait_rx_ack : RX ACK chnage detected"), UVM_LOW);
  end
  begin
   //TODO_GDR: B110 SRC ACK slow respond issue
   #700us; //#350us
   `uvm_error(get_type_name(), $sformatf("wait_rx_ack : timeout value exp is %d",exp_val));
  end
  join_any
  disable fork;
endtask
task reset_drv::wait_mac_tx_ack(bit exp_val);
  `uvm_info("reset_DRIVER", $sformatf("wait_mac_tx_ack : inside wait TX ACK"), UVM_LOW);
  fork
  begin
    wait(drv_if.mac_tx_rst_ack_n == exp_val);
    `uvm_info("reset_DRIVER", $sformatf("wait_mac_tx_ack : TX ACK detected"), UVM_LOW);
  end
  begin
   //TODO_GDR: B110 SRC ACK slow respond issue
   #700us; //#350us
   `uvm_error(get_type_name(), $sformatf("wait_mac_tx_ack : timeout value exp is %d",exp_val));
  end
  join_any
  disable fork;
endtask

task reset_drv::wait_mac_rx_ack(bit exp_val);
  `uvm_info("reset_DRIVER", $sformatf("wait_mac_rx_ack : inside wait RX ACK"), UVM_LOW);
  fork
  begin
    wait(drv_if.mac_rx_rst_ack_n == exp_val);
    `uvm_info("reset_DRIVER", $sformatf("wait_mac_rx_ack : RX ACK chnage detected"), UVM_LOW);
  end
  begin
   //TODO_GDR: B110 SRC ACK slow respond issue
   #700us; //#350us
   `uvm_error(get_type_name(), $sformatf("wait_mac_rx_ack : timeout value exp is %d",exp_val));
  end
  join_any
  disable fork;
endtask
task reset_drv::wait_mac_ack(bit exp_val);
  `uvm_info("reset_DRIVER", $sformatf("wait_mac_ack : inside wait RX ACK"), UVM_LOW);
  fork
  begin
    wait(drv_if.mac_rst_ack_n == exp_val);
    `uvm_info("reset_DRIVER", $sformatf("wait_mac_ack : RX ACK chnage detected"), UVM_LOW);
  end
  begin
   //TODO_GDR: B110 SRC ACK slow respond issue
   #700us; //#350us
   `uvm_error(get_type_name(), $sformatf("wait_mac_ack : timeout value exp is %d",exp_val));
  end
  join_any
  disable fork;
endtask
task reset_drv::wait_ip_ack(bit exp_val);
  `uvm_info("reset_DRIVER", $sformatf("inside wait IP Rst ACK"), UVM_LOW);
  fork
  begin
    wait(drv_if.rst_ack_n == exp_val);
    `uvm_info("reset_DRIVER", $sformatf(" wait_ip_ack : rst_ack_n chnage detected"), UVM_LOW);
    wait(drv_if.tx_rst_ack_n == exp_val);
    `uvm_info("reset_DRIVER", $sformatf(" wait_ip_ack :  tx_rst_ack_n chnage detected"), UVM_LOW);
    wait(drv_if.rx_rst_ack_n == exp_val);
    `uvm_info("reset_DRIVER", $sformatf(" wait_ip_ack : rx_rst_ack_n chnage detected"), UVM_LOW);
  end
  begin
   #600us;//500us; // Need to update this delay as per FS, currently there is no information 
   `uvm_error(get_type_name(), $sformatf("timeout value exp is %d",exp_val));
  end
  join_any
  disable fork;
endtask

task reset_drv::send(reset_transaction tr);
  `uvm_info("reset_DRIVER", "driving reset transaction ...",UVM_NONE)

     if(tr.assert_reconfig_reset == 1)
     begin
       this.drv_if.reconfig_rst_n      = 0;
       delay(100);
       this.drv_if.reconfig_rst_n      = 1;
       delay(100);
     end

  fork
   begin
     if(tr.assert_transmit_reset == 1)
     begin
       delay(tr.transmit_reset_clock_cnt);
       this.drv_if.tx_rst_n      = 0;
       ////Wait For ACK Signal 
       //if(spy_if.anlt) begin
       //  repeat(10)
       //    delay(tr.receiver_reset_clock_cnt);
       //end else begin
        wait_tx_ack(0);
       //end
       delay(tr.transmit_reset_clock_cnt);
       this.drv_if.tx_rst_n      = 1;
       ////Wait For ACK Signal
       //if(spy_if.anlt) begin
       //  repeat(10)
       delay(tr.receiver_reset_clock_cnt);
       //end else begin
        wait_tx_ack(1);
       //end
     end
   end
   begin 
     if(tr.assert_receiver_reset == 1)
     begin
       delay(tr.receiver_reset_clock_cnt);
       this.drv_if.rx_rst_n      = 0;
       ////Wait For ACK Signal 
       //if(spy_if.anlt) begin
       //   repeat(10)
       //   delay(tr.receiver_reset_clock_cnt);
       //end else begin
         wait_rx_ack(0);
       //end
      // repeat(10)
       delay(tr.receiver_reset_clock_cnt);
       this.drv_if.rx_rst_n      = 1;
       ////Wait For ACK Signal 
       //if(spy_if.anlt) begin
       //  repeat(10)
        delay(tr.receiver_reset_clock_cnt);
       //end else begin
        wait_rx_ack(1);
       //end
     //  delay(tr.receiver_reset_clock_cnt);
     end
   end
   begin
     if(tr.assert_transmit_reset == 1)
     begin
       delay(tr.transmit_reset_clock_cnt);
       this.drv_if.mac_tx_rst_n      = 0;
       ////Wait For ACK Signal 
       //if(spy_if.anlt) begin
       //  repeat(10)
       //    delay(tr.receiver_reset_clock_cnt);
       //end else begin
        wait_tx_ack(0);
       //end
       delay(tr.transmit_reset_clock_cnt);
      wait_mac_tx_ack(1);
       this.drv_if.mac_tx_rst_n      = 1;
       ////Wait For ACK Signal
       //if(spy_if.anlt) begin
       //  repeat(10)
   //    delay(tr.receiver_reset_clock_cnt);
       //end else begin
    //  wait_mac_tx_ack(1);
       //end
     end
   end
   begin 
     if(tr.assert_receiver_reset == 1)
     begin
       delay(tr.receiver_reset_clock_cnt);
       this.drv_if.mac_rx_rst_n      = 0;
       ////Wait For ACK Signal 
       //if(spy_if.anlt) begin
       //   repeat(10)
       //   delay(tr.receiver_reset_clock_cnt);
       //end else begin
         wait_rx_ack(0);
       //end
      // repeat(10)
       delay(tr.receiver_reset_clock_cnt);
        wait_mac_rx_ack(1);
       this.drv_if.mac_rx_rst_n      = 1;
       ////Wait For ACK Signal 
       //if(spy_if.anlt) begin
       //  repeat(10)
      //  delay(tr.receiver_reset_clock_cnt);
       //end else begin
      //  wait_mac_rx_ack(1);
       //end
     //  delay(tr.receiver_reset_clock_cnt);
     end
   end
   begin
      if(tr.assert_ip_reset == 1)
      begin
       delay(tr.receiver_reset_clock_cnt);
       this.drv_if.mac_rst_n      = 0;
       ////Wait For ACK Signal 
       //if(spy_if.anlt) begin
       //   repeat(10)
       //   delay(tr.receiver_reset_clock_cnt);
       //end else begin
         wait_ip_ack(0);
       //end
      // repeat(10)
       delay(tr.receiver_reset_clock_cnt);
        wait_mac_ack(1);
       this.drv_if.mac_rst_n      = 1;
       ////Wait For ACK Signal 
       //if(spy_if.anlt) begin
       //  repeat(10)
      //  delay(tr.receiver_reset_clock_cnt);
       //end else begin
      //  wait_mac_rx_ack(1);
       //end
     //  delay(tr.receiver_reset_clock_cnt);
     end
   end
   begin
      if(tr.assert_ip_reset == 1)
      begin
       delay(tr.receiver_reset_clock_cnt);
       this.drv_if.csr_rst_n     = 0;
       ////Wait For ACK Signal 
       //if(spy_if.anlt) begin
       //  repeat(10)
       //    delay(tr.receiver_reset_clock_cnt);
       //end else begin
         wait_ip_ack(0);
       //end
       delay(tr.ip_reset_clock_cnt);
      // #14us; //Adding delay for r_reset to avoid x propagation // HSD #16011501796
       this.drv_if.csr_rst_n     = 1;
       ////Wait For ACK Signal 
       //if(spy_if.anlt) begin
       //  repeat(10)
           delay(tr.receiver_reset_clock_cnt);
       //end else begin
         wait_ip_ack(1);
       //end
     //  delay(tr.ip_reset_clock_cnt);
      end
   end
   begin
      if(tr.assert_vip_reset == 1) begin
         this.drv_if.vip_rst = 1;
         #10us;
         this.drv_if.vip_rst = 0;
         #10us;
      end
   end
   
 join
endtask: send

task reset_drv::hold_reset(reset_transaction tr);
  `uvm_info("reset_DRIVER", "driving reset transaction and not releasing reset ...",UVM_NONE)

     if(tr.assert_reconfig_reset == 1)
     begin
       this.drv_if.reconfig_rst_n      = 0;
       delay(100);
       this.drv_if.reconfig_rst_n      = 1;
       delay(100);
     end

  fork
   begin
     if(tr.assert_transmit_reset == 1)
     begin
       this.drv_if.tx_rst_n      = 0;
     end
   end
   begin 
     if(tr.assert_receiver_reset == 1)
     begin
       this.drv_if.rx_rst_n      = 0;
     end
   end
   begin
      if(tr.assert_ip_reset == 1)
      begin
       this.drv_if.csr_rst_n     = 0;
      end
   end
   begin
      if(tr.assert_vip_reset == 1) begin
         this.drv_if.vip_rst = 1;
         #10us;
         this.drv_if.vip_rst = 0;
         #10us;
      end
   end
   
 join
endtask: hold_reset 

`endif // RESET_DRV__SV


