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



typedef class eth_packet;
typedef class eth_fc_drv;
typedef class eth_env_env;

class eth_fc_drv_callbacks extends uvm_callback;
   virtual task pre_tx( eth_fc_drv xactor,eth_packet tr);
   endtask: pre_tx

   virtual task post_tx( eth_fc_drv xactor,eth_packet tr);
   endtask: post_tx

endclass: eth_fc_drv_callbacks


class eth_fc_drv extends uvm_driver # (eth_packet);
        
      eth_env_env env;  
      eth_packet tr;
   //eth_param_tb tb_cfg;
   uvm_reg_data_t read_data;
   registers_urm reg_model;
   uvm_reg 	regs;
   // Dynamic Config Obj
   dyn_rcfg dyn_rcfg_obj_inst;
  `uvm_register_cb(eth_fc_drv,eth_fc_drv_callbacks);
   typedef virtual eth_fc_interface v_if; 
   typedef virtual altera_avalon_mm_if#(`AVMM_CFG_SHARED_INF_INST) status_if;
   v_if drv_if;
   status_if drv_if_status;
   bit [8:0] active_q=0;//8 for pfc,1 for sfc
   int i;
   bit pause;
   bit [23:0] csr_val=0;  
   bit [16:0] fc_mode=0;  
   bit [15:0] xoff_width[9];  
   extern function new(string name = "eth_fc_drv",uvm_component parent = null); 

      `uvm_component_utils_begin(eth_fc_drv)
      `uvm_component_utils_end

   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void end_of_elaboration_phase(uvm_phase phase);
   extern virtual function void start_of_simulation_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual task reset_phase(uvm_phase phase);
   extern virtual task configure_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   extern protected virtual task send(bit active,int q_id); 
   extern protected virtual task tx_driver();
   task reg_write(uvm_reg_data_t addr,uvm_reg_data_t data);
      uvm_status_e      status;
      uvm_reg 	regs[$];
      uvm_reg 	select_reg;
      bit reg_not_found =1;

      reg_model.default_map.get_registers(regs);
      foreach(regs[i]) begin
        if (addr == regs[i].get_address())
          begin
            select_reg = regs[i];
            reg_not_found = 0 ;
            `uvm_info("AVMM REG WRITE", $sformatf("Register(%s) address 'h%0h write data :'h%0h",select_reg.get_name(),addr,data), UVM_NONE)
            select_reg.write(status,.value(data), .map(reg_model.default_map));
          end
      end
      if(reg_not_found == 1)  `uvm_error("AVMM REG WRITE", $sformatf("No Register found with address :%0h",addr));
 endtask

 covergroup cg;
      PAUSE_PFC : coverpoint pause{
                  bins PFC={1}; 
                  bins SFC={0};
                  ignore_bins pfc_not_supported = {1};
      }
      NO_QUEUE: coverpoint active_q{
                  wildcard bins SFC = {9'b1_xxxx_xxxx};
                  //PFC not suported in DM 
                  //wildcard bins PFC_1 = {9'b0_xxxx_xxx1}; 
                  //wildcard bins PFC_2 = {9'b0_xxxx_xx1x}; 
                  //wildcard bins PFC_3 = {9'b0_xxxx_x1xx}; 
                  //wildcard bins PFC_4 = {9'b0_xxxx_1xxx}; 
                  //wildcard bins PFC_5 = {9'b0_xxx1_xxxx}; 
                  //wildcard bins PFC_6 = {9'b0_xx1x_xxxx}; 
                  //wildcard bins PFC_7 = {9'b0_x1xx_xxxx}; 
                  //wildcard bins PFC_8 = {9'b0_1xxx_xxxx}; 
      }
      cross PAUSE_PFC,NO_QUEUE {
            ignore_bins B1= binsof(PAUSE_PFC) intersect {1} && binsof(NO_QUEUE.SFC);
            ignore_bins B2= binsof(PAUSE_PFC) intersect {0} && !binsof(NO_QUEUE.SFC);
             }
 endgroup 

endclass: eth_fc_drv


function eth_fc_drv::new(string name = "eth_fc_drv",uvm_component parent = null);
   super.new(name, parent);
   cg =new;
endfunction: new


function void eth_fc_drv::build_phase(uvm_phase phase);
   super.build_phase(phase);
    uvm_config_db#(registers_urm)::get(this, "", "reg_model", reg_model);
   if (reg_model == null)  `uvm_fatal("NO_CONN", "failed to get reg model in in eth fc mon");   
endfunction: build_phase

function void eth_fc_drv::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   uvm_config_db#(status_if)::get(this, "", "status_if", drv_if_status);
   uvm_config_db#(v_if)::get(this, "", "mst_if", drv_if);
   //uvm_config_db#(eth_param_tb)::get(this, "", "tb_config", tb_cfg);
   // Get Dyn cfg obj
   if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", dyn_rcfg_obj_inst)) begin 
      `uvm_fatal("dyn_rcfg", "failed to get dyn_rcfg_obj_inst object");
   end
endfunction: connect_phase

function void eth_fc_drv::end_of_elaboration_phase(uvm_phase phase);
   super.end_of_elaboration_phase(phase);
   if (drv_if == null)  `uvm_fatal("NO_CONN", "Virtual port not connected to the actual interface instance");   
   if (drv_if_status == null)  `uvm_fatal("NO_CONN", "failed to get status interface in flow control mon"); 
   //if (tb_cfg == null)  `uvm_fatal("NO_CONN", "failed to get config db in tx layering drv");   
endfunction: end_of_elaboration_phase

function void eth_fc_drv::start_of_simulation_phase(uvm_phase phase);
   super.start_of_simulation_phase(phase);
endfunction: start_of_simulation_phase

 
task eth_fc_drv::reset_phase(uvm_phase phase);
   super.reset_phase(phase);
endtask: reset_phase

task eth_fc_drv::configure_phase(uvm_phase phase);
   super.configure_phase(phase);
endtask:configure_phase


task eth_fc_drv::run_phase(uvm_phase phase);
   super.run_phase(phase);
 //   wait(drv_if.rx_pcs_ready);
  `uvm_info("eth_fc_drv", "run phase...",UVM_LOW)
           drv_if.tx_sfc=0;
           drv_if.tx_pfc=0;
     //pause pfc opcode
      tx_driver();
 endtask: run_phase


task eth_fc_drv::tx_driver();
 forever begin
      `uvm_info("eth_fc_drv", "Starting transaction...",UVM_LOW)
      seq_item_port.get_next_item(tr);
     //  active_q=8'hff;
     `uvm_info("eth_fc_drv", "Received FLOW CONTROL transaction from sequencer...",UVM_LOW)
      tr.print;
      pause=tr.pause;
      fc_mode=tr.fc_mode;
    
      if(pause)  `uvm_info("eth_fc_drv",$sformatf( "pfc mode.value=%b",pause),UVM_LOW)
      else  `uvm_info("eth_fc_drv",$sformatf( "sfc mode.value=%b",pause),UVM_LOW)
   
      `uvm_info("eth_fc_drv",$sformatf( "fc mode=%b",fc_mode),UVM_LOW)
      `uvm_info("eth_fc_drv ", $sformatf(" this simulation will exercise %b queues",active_q), UVM_NONE);
    
      for(i=0;i<9;i++) begin
          xoff_width[i]=tr.xoff_width[i];
          //  xoff_width[i]=200;
          `uvm_info("eth_fc_drv",$sformatf( "xoff width[%d]=%d ns",i,xoff_width[i]*3.2),UVM_LOW)
      end
      for(i=0;i<9;i++) begin
         drv_if.xoff_width[i]=tr.xoff_width[i];
         `uvm_info("eth_fc_drv",$sformatf( "xoff width[%d]=%d ns",i,xoff_width[i]),UVM_LOW)
      end
      //cg.sample(); 
      
      //repeat(tr.no_fc_frames) begin
      repeat(2) begin
         if(!pause) active_q=9'h100;
         else 
          randcase
             30: active_q=$urandom_range(128,255);
             70: active_q=9'b011111111;
          endcase

          send(active_q[0],0);
          send(active_q[1],1);   
          send(active_q[2],2);   
          send(active_q[3],3);   
          send(active_q[4],4);   
          send(active_q[5],5);   
          send(active_q[6],6);   
          send(active_q[7],7);   
          send(active_q[8],8);
      end
      cg.sample(); 
      seq_item_port.item_done();
      `uvm_info("eth_fc_drv", "Completed transaction...",UVM_LOW)
   end
endtask : tx_driver

task eth_fc_drv::send(bit active,int q_id);
  if(active) begin
    if(fc_mode[q_id]) begin//csr
      `uvm_info("eth_flow control drv",$sformatf("using CSR for q %d",q_id),UVM_LOW)
       csr_val[q_id]=1;
       wait(drv_if_status.write==0);
       @(posedge drv_if_status.clk);
       env.reg_write(`GET_REG_ADDR(tx_pauseframe_control_OFFSET_REG,dyn_rcfg_obj_inst.speed),32'h2);//xoff
       #10ns;
       drv_if.tx_xoff_en =1;

       // in sequence we are sending normal frams in parallel to FC frames 
       // FOR 10M/100M its needs more time to finish the noraml frames to transmit 
       if(dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) 
         #350us;

       repeat(xoff_width[q_id]) @(posedge drv_if.clk);
       csr_val[q_id]=0;
       wait(drv_if_status.write==0);
       @(posedge drv_if_status.clk);
       env.reg_write(`GET_REG_ADDR(tx_pauseframe_control_OFFSET_REG,dyn_rcfg_obj_inst.speed),32'h1);//xoff
       wait(drv_if_status.write==0);
      #10ns;
       drv_if.tx_xon_en =1;
    end//csr
    else begin
       drv_if.port_based = 1; 
      `uvm_info("eth_flow control drv",$sformatf("using port for q %d for duration %d cycles",q_id,xoff_width[q_id]),UVM_LOW)
      if(q_id==8)  drv_if.tx_sfc=2'b10;
      else         drv_if.tx_pfc[q_id]=1;
       drv_if.port_based = 1; 
      #10ns;
      drv_if.port_tx_xoff_en = 1;
      
      // for 10M/100M needs more time 
      if(dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) 
        repeat((xoff_width[q_id])*10) @(posedge drv_if.clk);
      else
        repeat(xoff_width[q_id]) @(posedge drv_if.clk);
     
      `uvm_info("eth_flow control drv", $sformatf("wait done for xoff_width"),UVM_LOW);

      //As per FS, 10G/25G i_tx_pfc must be held for more than 205ns 
      if(dyn_rcfg_obj_inst.speed inside {_10G, _25G} && q_id != 8) begin
        #210ns;
      end

      if(q_id==8)  drv_if.tx_sfc=2'b01;
      else         drv_if.tx_pfc[q_id]=0;
      #10ns;
      // repeat(2) @(posedge drv_if.clk);
      drv_if.port_tx_xon_en = 1; 
      drv_if.port_based = 0; 
     
    end //signal
       if(dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) 
         #350us;
    
    repeat(3500) @(posedge drv_if.clk);
  end //active
  endtask: send
