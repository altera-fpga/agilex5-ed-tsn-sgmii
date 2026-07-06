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
typedef class eth_fc_mon;

class eth_fc_mon_callbacks extends uvm_callback;

   // Called at start of observed transaction
   virtual function void pre_trans(eth_fc_mon xactor, eth_packet tr);
   endfunction: pre_trans

   // Called before acknowledging a transaction
   virtual function pre_ack(eth_fc_mon xactor,eth_packet tr);
   endfunction: pre_ack

   // Called at end of observed transaction
   virtual function void post_trans(eth_fc_mon xactor,eth_packet tr);
   endfunction: post_trans
   
   // Callback method post_cb_trans can be used for coverage
   virtual task post_cb_trans(eth_fc_mon xactor, eth_packet tr);
   endtask: post_cb_trans

endclass: eth_fc_mon_callbacks

   
class eth_fc_mon extends uvm_monitor;
   uvm_reg_data_t read_data;
   registers_urm reg_model;
   uvm_reg 	regs;
   uvm_analysis_port #(eth_packet) mon_analysis_port;  //TLM analysis port
   uvm_analysis_port #(eth_packet) mon_analysis_port_cov;  //TLM analysis port
   typedef virtual eth_fc_interface v_if;
   typedef virtual altera_avalon_mm_if#(`AVMM_CFG_SHARED_INF_INST) status_if;
   v_if mon_if;
   status_if mon_if_status;
   //eth_param_tb tb_cfg; 
   eth_packet u_item;
   // Dynamic Config Obj
   dyn_rcfg dyn_rcfg_obj_inst;

//internal variables
   bit flow_control=0;
   bit ignore_pkt[9];
   bit is_xoff[9];
   bit [8:0] port_en;
   bit [8:0] holdoff_en;
   bit [15:0] sfc_holdoff_val;
   bit [15:0] sfc_pause_val;
   bit same_holdoff;
   bit [15:0] cmn_holdoff_val;
   bit [1:0] fc_pkt_en;
   bit [15:0] pause_quanta[8];
   bit [15:0] hold_quanta[8];
   bit [15:0] scan_data=0;
   bit [15:0] pause_frame_en_reg=0; 
   bit [7:0] enable_bit_vector; 
   int num_xoff_gen =1;
   int pause_transaction_id=0; 
   int num_hold_clks;
   bit pause=1;
   bit tx_path_disable=0;
   bit tx_pause_en=1;
   bit port_reg ;
   uvm_event_pool event_pool;
   uvm_event wait_fc_reg_write;
   `uvm_register_cb(eth_fc_mon,eth_fc_mon_callbacks);
   `uvm_component_utils_begin(eth_fc_mon)

   `uvm_component_utils_end

   extern function new(string name = "eth_fc_mon",uvm_component parent);
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void end_of_elaboration_phase(uvm_phase phase);
   extern virtual function void start_of_simulation_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual task reset_phase(uvm_phase phase);
   extern virtual task gen_xoff(int q_id);
   extern virtual task gen_xon(int q_id);
   extern virtual task check_xoff(int num_hold_clks,int q_no);
   extern virtual task configure_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   extern virtual function void report_phase(uvm_phase phase);
   extern protected virtual task tx_monitor(int q_id);
   extern protected virtual task scan_csr();
   extern protected virtual task fc_registers();
   extern protected virtual task pause_frame_disable();
//   extern protected virtual task scan_fcen();
   
   covergroup fc_tx;

      FRAME_TYPE_PFC : coverpoint u_item.frame_type{
                         bins PFC={ETH_PFC_FRAME};
                     }

      FRAME_TYPE_SFC : coverpoint u_item.frame_type{
                        bins SFC={ETH_SFC_FRAME};
                     }

      NUM_Q : coverpoint enable_bit_vector{
                  bins VAL[]={1,2,4,8,16,32,64,128};
                  ignore_bins tx_pfc_not_supported = {1,2,4,8,16,32,64,128};
             }

     CROSS_FRAME_TYPE_PFCXENABLE_BIT_VECTOR : cross FRAME_TYPE_PFC,NUM_Q ;
      //chethan cross PAUSE_PFC,NUM_Q {
      //chethan  bins PFC_Q=binsof(PAUSE_PFC) intersect{ETH_PFC_FRAME} && binsof(NUM_Q);
      //chethan   }
    endgroup 

endclass: eth_fc_mon


function eth_fc_mon::new(string name = "eth_fc_mon",uvm_component parent);
   super.new(name, parent);
   mon_analysis_port = new ("mon_analysis_port",this);
   mon_analysis_port_cov = new ("mon_analysis_port_cov",this);
   fc_tx =new;
endfunction: new


function void eth_fc_mon::build_phase(uvm_phase phase);
   super.build_phase(phase);
   uvm_config_db#(registers_urm)::get(this, "", "reg_model", reg_model);
   if (reg_model == null)  `uvm_fatal("NO_CONN", "failed to get reg model in in eth fc mon");   
   u_item=eth_packet::type_id::create("u_item",this);
endfunction: build_phase

function void eth_fc_mon::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   uvm_config_db#(v_if)::get(this, "", "mst_if", mon_if);
   uvm_config_db#(status_if)::get(this, "", "status_if", mon_if_status);
   //uvm_config_db#(eth_param_tb)::get(this, "", "tb_config", tb_cfg);
   // Get Dyn cfg obj
   if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", dyn_rcfg_obj_inst)) begin 
      `uvm_fatal("dyn_rcfg", "failed to get dyn_rcfg_obj_inst object ");
   end
endfunction: connect_phase

function void eth_fc_mon::end_of_elaboration_phase(uvm_phase phase);
   super.end_of_elaboration_phase(phase); 
   //if (tb_cfg == null)  `uvm_fatal("NO_CONN", "failed to get config db in tx layering mon"); 
   if (mon_if == null)  `uvm_fatal("NO_CONN", "failed to get eth flow control interface in flow control mon"); 
   if (mon_if_status == null)  `uvm_fatal("NO_CONN", "failed to get status interface in flow control mon"); 
    event_pool = new();
    event_pool = event_pool.get_global_pool();
    wait_fc_reg_write = event_pool.get("fc_reg_write");
endfunction: end_of_elaboration_phase


function void eth_fc_mon::start_of_simulation_phase(uvm_phase phase);
   super.start_of_simulation_phase(phase);
endfunction: start_of_simulation_phase


task eth_fc_mon::reset_phase(uvm_phase phase);
   super.reset_phase(phase);
endtask: reset_phase


task eth_fc_mon::configure_phase(uvm_phase phase);
   super.configure_phase(phase);
endtask:configure_phase


task eth_fc_mon::run_phase(uvm_phase phase);
   super.run_phase(phase);
  wait(mon_if.rx_pcs_ready);
  wait_fc_reg_write.wait_trigger();
 if(flow_control) begin
    pause=1;
    mon_if.pause_enable=0;
      //after reading all reg sample cvg

      fork
          //  PFC is not supported in DM 
         //tx_monitor(0);
         //tx_monitor(1);
         //tx_monitor(2);
         //tx_monitor(3);
         //tx_monitor(4);
         //tx_monitor(5);
         //tx_monitor(6);
         //tx_monitor(7);
         tx_monitor(8);
        scan_csr; 
     join
   end//flow control=1
endtask: run_phase

task eth_fc_mon :: pause_frame_disable();
    regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(tx_packet_control_OFFSET_REG,dyn_rcfg_obj_inst.speed));
    read_data = regs.get();
    `uvm_info("ref model ", $sformatf(" tx_packet_control value in %s is %0h",regs.get_name(),read_data), UVM_LOW);
    tx_path_disable=read_data[0]; 
  // checking pause_frame enable  
    regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(tx_pauseframe_enable_OFFSET_REG,dyn_rcfg_obj_inst.speed));
    read_data = regs.get();
    `uvm_info("ref model ", $sformatf(" tx_packet_control value in %s is %0h",regs.get_name(),read_data), UVM_LOW);
    tx_pause_en=read_data[0];    
endtask 

task eth_fc_mon :: fc_registers();
 //#25us;//temp hack to allow reg writes   
    regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(tx_pauseframe_enable_OFFSET_REG,dyn_rcfg_obj_inst.speed));
    read_data = regs.get();
    `uvm_info("ref model ", $sformatf(" write value in %s is %0h",regs.get_name(),read_data), UVM_LOW);
    port_en[8]=read_data[0];    
    port_en[1]=read_data[1];    
    port_reg=read_data[1];    
    $display("read port reg[8]=%0d",port_en[8]);
    $display("read port reg[1]=%0d",port_en[1]);

    regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_retransmit_xoff_holdoff_quanta_OFFSET_REG,dyn_rcfg_obj_inst.speed));
    read_data = regs.get();
    `uvm_info("ref model ", $sformatf(" write value in %s is %0h",regs.get_name(),read_data), UVM_NONE);
    sfc_holdoff_val=read_data[15:0];    

    regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_tx_pause_quanta_OFFSET_REG,dyn_rcfg_obj_inst.speed));
    read_data = regs.get();
    `uvm_info("ref model ", $sformatf(" write value in %s is %0h",regs.get_name(),read_data), UVM_NONE);
    sfc_pause_val=read_data[15:0];//1 bit or 2 bit    

    //DM_TODO: check regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_cfg_retransmit_holdoff_en_OFFSET_REG,dyn_rcfg_obj_inst.speed));
    //DM_TODO: check read_data = regs.get();
    //`uvm_info("ref model ", $sformatf(" write value in %s is %0h",regs.get_name(),read_data), UVM_NONE);
    //same_holdoff=read_data[0];//1 bit or 2 bit    

    //DM_TODO: check regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_cfg_retransmit_holdoff_quanta_OFFSET_REG,dyn_rcfg_obj_inst.speed));
    //DM_TODO: check read_data = regs.get();
    //`uvm_info("ref model ", $sformatf(" write value in %s is %0h",regs.get_name(),read_data), UVM_NONE);
    //cmn_holdoff_val=read_data[15:0];//1 bit or 2 bit    

    //dest addr
    //DM_TODO: check regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_tx_pfc_daddrl_OFFSET_REG,dyn_rcfg_obj_inst.speed));
    //DM_TODO: check read_data = regs.get();
    //`uvm_info("ref model ", $sformatf(" write value in %s is %0h",regs.get_name(),read_data), UVM_NONE);
    u_item.dest_address[31:0]=32'hc2000001;

    //DM_TODO: check regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_tx_pfc_daddrh_OFFSET_REG,dyn_rcfg_obj_inst.speed));
    //DM_TODO: check read_data = regs.get();
    //`uvm_info("ref model ", $sformatf(" write value in %s is %0h",regs.get_name(),read_data[15:0]), UVM_NONE);
     u_item.dest_address[47:32]=16'h0180;

    //src addr
    regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_txmac_saddrl_OFFSET_REG,dyn_rcfg_obj_inst.speed));
    read_data = regs.get();
    `uvm_info("ref model ", $sformatf(" write value in %s is %0h",regs.get_name(),read_data), UVM_NONE);
    u_item.src_address[31:0]=read_data;

    regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_txmac_saddrh_OFFSET_REG,dyn_rcfg_obj_inst.speed));
    read_data = regs.get();
    `uvm_info("ref model ", $sformatf(" write value in %s is %0h",regs.get_name(),read_data[15:0]), UVM_NONE);
    u_item.src_address[47:32]=read_data[15:0];

    //DM_TODO: check regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_txsfc_ehip_cfg_OFFSET_REG,dyn_rcfg_obj_inst.speed));
    //DM_TODO: check read_data = regs.get();
    //`uvm_info("ref model ", $sformatf(" write value in %s is %0h",regs.get_name(),read_data[15:0]), UVM_NONE);
    fc_pkt_en=1;//read_data[1:0];
       
  //create flow control packet
    u_item.preamble=64'hfb555555555555d5;
 
    u_item.eth_type_or_length=16'h8808;
    //pause pfc opcode
    
    
   //pause quanta
  //   if(pause) begin
   regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_0_OFFSET_REG,dyn_rcfg_obj_inst.speed));
   read_data = regs.get;
   `uvm_info("ref model ", $sformatf(" write value in %s is %0d",regs.get_name(),read_data), UVM_NONE);
   pause_quanta[0]=read_data;
   regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_1_OFFSET_REG,dyn_rcfg_obj_inst.speed) );
   read_data = regs.get;
   `uvm_info("ref model ", $sformatf(" write value in %s is %0d",regs.get_name(),read_data), UVM_NONE);
   pause_quanta[1]=read_data;
   regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_2_OFFSET_REG,dyn_rcfg_obj_inst.speed) );
   read_data = regs.get;
   `uvm_info("ref model ", $sformatf(" write value in %s is %0d",regs.get_name(),read_data), UVM_NONE);
   pause_quanta[2]=read_data;
   regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_3_OFFSET_REG,dyn_rcfg_obj_inst.speed));
   read_data = regs.get;
   `uvm_info("ref model ", $sformatf(" write value in %s is %0d",regs.get_name(),read_data), UVM_NONE);
   pause_quanta[3]=read_data;
   regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_4_OFFSET_REG,dyn_rcfg_obj_inst.speed) );
   read_data = regs.get;
   `uvm_info("ref model ", $sformatf(" write value in %s is %0d",regs.get_name(),read_data), UVM_NONE);
   pause_quanta[4]=read_data;
   regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_5_OFFSET_REG,dyn_rcfg_obj_inst.speed) );
   read_data = regs.get;
   `uvm_info("ref model ", $sformatf(" write value in %s is %0d",regs.get_name(),read_data), UVM_NONE);
   pause_quanta[5]=read_data;
   regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_6_OFFSET_REG,dyn_rcfg_obj_inst.speed));
   read_data = regs.get;
   `uvm_info("ref model ", $sformatf(" write value in %s is %0d",regs.get_name(),read_data), UVM_NONE);
   pause_quanta[6]=read_data;
   regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_7_OFFSET_REG,dyn_rcfg_obj_inst.speed));
   read_data = regs.get;
   `uvm_info("ref model ", $sformatf(" write value in %s is %0d",regs.get_name(),read_data), UVM_NONE);
   pause_quanta[7]=read_data;
 // end
//hold quanta
 //  if(pause) begin
   regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_0_OFFSET_REG,dyn_rcfg_obj_inst.speed));
   read_data = regs.get;
   `uvm_info("ref model ", $sformatf(" write value in %s is %0d",regs.get_name(),read_data), UVM_NONE);
   hold_quanta[0]=read_data;
   regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_1_OFFSET_REG,dyn_rcfg_obj_inst.speed));
   read_data = regs.get;
   `uvm_info("ref model ", $sformatf(" write value in %s is %0d",regs.get_name(),read_data), UVM_NONE);
   hold_quanta[1]=read_data;
   regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_2_OFFSET_REG,dyn_rcfg_obj_inst.speed));
   read_data = regs.get;
   `uvm_info("ref model ", $sformatf(" write value in %s is %0d",regs.get_name(),read_data), UVM_NONE);
   hold_quanta[2]=read_data;
   regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_3_OFFSET_REG,dyn_rcfg_obj_inst.speed));
   read_data = regs.get;
   `uvm_info("ref model ", $sformatf(" write value in %s is %0d",regs.get_name(),read_data), UVM_NONE);
   hold_quanta[3]=read_data;
   regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_4_OFFSET_REG,dyn_rcfg_obj_inst.speed));
   read_data = regs.get;
   `uvm_info("ref model ", $sformatf(" write value in %s is %0d",regs.get_name(),read_data), UVM_NONE);
   hold_quanta[4]=read_data;
   regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_5_OFFSET_REG,dyn_rcfg_obj_inst.speed));
   read_data = regs.get;
   `uvm_info("ref model ", $sformatf(" write value in %s is %0d",regs.get_name(),read_data), UVM_NONE);
   hold_quanta[5]=read_data;
   regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_6_OFFSET_REG,dyn_rcfg_obj_inst.speed));
  read_data = regs.get;
   `uvm_info("ref model ", $sformatf(" write value in %s is %0d",regs.get_name(),read_data), UVM_NONE);
   hold_quanta[6]=read_data;
   regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_7_OFFSET_REG,dyn_rcfg_obj_inst.speed));
   read_data = regs.get;
   `uvm_info("ref model ", $sformatf(" write value in %s is %0d",regs.get_name(),read_data), UVM_NONE);
   hold_quanta[7]=read_data;
endtask 


task eth_fc_mon::scan_csr();
  forever begin
   uvm_reg_data_t read_data;
   registers_urm reg_model;
   uvm_reg 	regs;
    fc_registers;
    @(posedge mon_if_status.write);
    `uvm_info("",$sformatf("fc_mon write address = %0h, write data = %0h", mon_if_status.address,mon_if_status.writedata),UVM_NONE);
    #1 if(mon_if_status.address[17:2] == (`GET_REG_ADDR(tx_pauseframe_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))) scan_data=mon_if_status.writedata;
    $display("scanned data=%h",scan_data); 
  end
endtask

task eth_fc_mon::tx_monitor(input int q_id);
 bit start_counter=0;
  

 forever begin
   `uvm_info("eth_fc_MONITOR",$sformatf("forever_loop begin"),UVM_LOW);
   fc_registers;
   `uvm_info("fc_mon ", $sformatf(" start_counter= %0d holdoff_en=%0d for q:%d",start_counter,holdoff_en[q_id],q_id), UVM_NONE);
       fork 
         begin//xon thread
          fc_registers;
          wait(start_counter);
          `uvm_info("fc_mon ", $sformatf(" for q:%d",q_id), UVM_NONE);
           if(q_id==8) begin
             `uvm_info("fc_mon", $sformatf("Inside sfc mode of XON port_tx_xon_en=%0d tx_xon_en=%0d \n", mon_if.port_tx_xon_en,mon_if.tx_xon_en),UVM_LOW)
             @((posedge mon_if.port_tx_xon_en) or (posedge mon_if.tx_xon_en));
             `uvm_info("fc_mon", $sformatf("Inside sfc mode of XON port_tx_xon_en=%0d tx_xon_en=%0d \n", mon_if.port_tx_xon_en,mon_if.tx_xon_en),UVM_LOW)
              gen_xon(q_id);
              start_counter=0;
              #10ns;
              mon_if.tx_xon_en =0;
              mon_if.port_tx_xon_en =0;
           end
          `uvm_info("fc_mon ", $sformatf(" Thread2 Finish for q:%d",q_id), UVM_NONE);
         end //xon thread


         begin // xoff tread
           `uvm_info("fc_mon ", $sformatf(" for q:%d",q_id), UVM_NONE);
           if(q_id==8 ) begin
             `uvm_info("fc_mon", $sformatf("Inside sfc mode of XOFF port_tx_xoff_en=%0d tx_xoff_en=%0d \n", mon_if.port_tx_xoff_en,mon_if.tx_xoff_en),UVM_LOW)
             @((posedge mon_if.port_tx_xoff_en) or (posedge mon_if.tx_xoff_en));
             `uvm_info("fc_mon", $sformatf("Inside sfc mode of XOFF port_tx_xoff_en=%0d tx_xoff_en=%0d \n", mon_if.port_tx_xoff_en,mon_if.tx_xoff_en),UVM_LOW)
             fc_registers();

             // generate the repeated  xoff  based on xoff_width 
             `uvm_info("eth_fc_mon",$sformatf( "sfc_pause_val = %d xoff width=%d ns",sfc_pause_val,mon_if.xoff_width[q_id]),UVM_LOW)
             if((mon_if.xoff_width[q_id] == sfc_pause_val) || ( mon_if.xoff_width[q_id] == sfc_pause_val/2))
              num_xoff_gen = 1;
             else if (mon_if.xoff_width[q_id] == sfc_pause_val*2 && port_en[1] == 0)
              num_xoff_gen = 2;
             `uvm_info("eth_fc_mon",$sformatf( "num_xoff_gen = %d ",num_xoff_gen),UVM_LOW)
             
             gen_xoff(8);
             `uvm_info("fc_mon", $sformatf("AFTER XOFF GEN port_en[1]=%0d  scan_data[1]=%0d \n",port_en[1],scan_data[1]),UVM_LOW)
             start_counter=1;
             #10ns;
             mon_if.tx_xoff_en =0;
             mon_if.port_tx_xoff_en =0;
           end
           is_xoff[q_id]=1;
           `uvm_info("fc_mon ", $sformatf(" Thread3 Finish for q:%d",q_id), UVM_NONE);
           $display("enable bit vector=%h",enable_bit_vector);
         end // xoff tread
       join_any
       disable fork;

       u_item.pfc_class_en_vect[0]=0;
       u_item.pfc_class_en_vect[1]=enable_bit_vector[7:0];
       if(u_item.payload[0]) u_item.frame_type=ETH_PFC_FRAME;
       else u_item.frame_type=ETH_SFC_FRAME;
       u_item.calc_crc32();
       u_item.fcs={<<byte{u_item.fcs}};

       `uvm_info("eth_fc_MONITOR", "Completed transaction...",UVM_LOW)
       `uvm_info("eth_fc_MONITOR", u_item.sprint(),UVM_LOW)
       //`uvm_do_callbacks(eth_fc_mon,eth_fc_mon_callbacks,post_trans(this, u_item))
       pause_transaction_id = pause_transaction_id + 1;
       u_item.pause_transaction_id = pause_transaction_id;
       fc_tx.sample();

       if(is_xoff[q_id]) begin
          if(mon_if.tx_pfc[q_id]|| mon_if.tx_sfc)begin
             if(port_en[q_id]) ignore_pkt[q_id]=0;
             else ignore_pkt[q_id]=1;
          end
       end
       // Reading the txpacket_control register to check tx_path is enabled or disabled
       // if the tx_path is diabled,should not send the pause frames to scoreboard and reference model 
       pause_frame_disable;

       if(((fc_pkt_en[0] && !u_item.payload[0]) || (fc_pkt_en[1] && u_item.payload[0])) && !ignore_pkt[q_id]  && !tx_path_disable && tx_pause_en ) begin
         `uvm_info("eth_fc_MONITOR",$sformatf("writing flow control packet into analysis port"),UVM_LOW);
          `uvm_info("eth_fc_mon",$sformatf( "BEFORE WRITE to analysis port  sfc_pause_val = %d num_xoff_gen = %d ns",sfc_pause_val,num_xoff_gen),UVM_LOW)
         //----------------------------------------------------------------------------------------------//
         // If the xoff_width is greater than the sfc_pause_val need to generate multiple xoff_frames    //
         // Hence we writing twice same xoff frames to analysis port                                     //   
         // ---------------------------------------------------------------------------------------------//
          `uvm_info("eth_fc_mon",$sformatf( "payload[2] = %d sfc_pause_val[15:8] =%d u_item.payload[3] %d sfc_pause_val[7:0]= %d ",u_item.payload[2],sfc_pause_val[15:8], u_item.payload[3], sfc_pause_val[7:0]),UVM_LOW)
          if(num_xoff_gen == 2 && u_item.payload[2] == sfc_pause_val[15:8] && u_item.payload[3] == sfc_pause_val[7:0])  begin
          `uvm_info("eth_fc_mon",$sformatf( "1st xoff frames sfc_pause_val = %d num_xoff_gen = %d ns",sfc_pause_val,num_xoff_gen),UVM_LOW)
            mon_analysis_port.write(u_item);
            repeat(5) @(posedge mon_if.clk);
           `uvm_info("eth_fc_mon",$sformatf( "2nd xoff frames sfc_pause_val = %d num_xoff_gen = %d ns",sfc_pause_val,num_xoff_gen),UVM_LOW)
            mon_analysis_port.write(u_item);
          end
          else begin
           `uvm_info("eth_fc_mon",$sformatf( "only one xoff frames sfc_pause_val = %d num_xoff_gen = %d ns",sfc_pause_val,num_xoff_gen),UVM_LOW)
            mon_analysis_port.write(u_item);
          end
       end  
       mon_analysis_port_cov.write(u_item);//for coverage
      num_xoff_gen =1;

      `uvm_info("eth_fc_MONITOR",$sformatf("forever_loop end"),UVM_LOW);
      is_xoff[q_id]=0;
      ignore_pkt[q_id]=0;   
    //end  //second thread
  // join_any
 // disable fork;
 end //forever 
endtask: tx_monitor
 
task eth_fc_mon::check_xoff(int num_hold_clks,int q_no);
    $display("num hold clk=%d,q_no=%d",num_hold_clks,q_no);
   repeat (num_hold_clks) @(posedge mon_if.clk);
         `uvm_info("fc_mon", "hold time expired..\n",UVM_LOW)
         if(q_no!=8) begin
           enable_bit_vector=0;
           enable_bit_vector[q_no]=1;
         end
         //check if xoff condition still persistes
         if((q_no==8 && mon_if.tx_sfc) ||(q_no<8 && mon_if.tx_pfc[q_no]) || scan_data[q_no]) gen_xoff(q_no);
        endtask

task eth_fc_mon::gen_xoff(int q_id);
  `uvm_info("eth_fc_MONITOR",$sformatf("GENerating XOFF for q %d",q_id),UVM_LOW)
   u_item.payload=new[46];
   u_item.payload[1]=1;
   if(q_id==8) begin//pause
      u_item.payload[0]=0;//0 pause,1 pfc
   u_item.payload[2]=sfc_pause_val[15:8];
   u_item.payload[3]=sfc_pause_val[7:0];
   end
   else begin
      u_item.payload[0]=1;//0 pause,1 pfc
      u_item.payload[2]=0;
      u_item.payload[3]=enable_bit_vector;
    if(enable_bit_vector[0]) begin
      u_item.payload[4]=pause_quanta[0][15:8];
      u_item.payload[5]=pause_quanta[0][7:0];//queue1
    end
    if(enable_bit_vector[1]) begin
  u_item.payload[6]=pause_quanta[1][15:8];
      u_item.payload[7]=pause_quanta[1][7:0];
    end
    if(enable_bit_vector[2]) begin
      u_item.payload[8]=pause_quanta[2][15:8];
      u_item.payload[9]=pause_quanta[2][7:0];
    end
    if(enable_bit_vector[3]) begin
      u_item.payload[10]=pause_quanta[3][15:8];
      u_item.payload[11]=pause_quanta[3][7:0];
    end
    if(enable_bit_vector[4]) begin
      u_item.payload[12]=pause_quanta[4][15:8];
      u_item.payload[13]=pause_quanta[4][7:0];
    end
    if(enable_bit_vector[5]) begin
      u_item.payload[14]=pause_quanta[5][15:8];
      u_item.payload[15]=pause_quanta[5][7:0];
    end
    if(enable_bit_vector[6]) begin
      u_item.payload[16]=pause_quanta[6][15:8];
      u_item.payload[17]=pause_quanta[6][7:0];
    end
    if(enable_bit_vector[7]) begin
      u_item.payload[18]=pause_quanta[7][15:8];
      u_item.payload[19]=pause_quanta[7][7:0];
    end
   end
endtask

task eth_fc_mon::gen_xon(int q_id);
  `uvm_info("eth_fc_MONITOR",$sformatf("GENerating XON for Q %d",q_id),UVM_LOW)
    u_item.payload=new[46];
    u_item.payload[1]=1;
    if(q_id==8) u_item.payload[0]=0;//0 pause,1 pfc
    else begin
      u_item.payload[0]=1;//0 pause,1 pfc
     u_item.payload[2]=0;
     u_item.payload[3]=enable_bit_vector;
     //if(!enable_bit_vector[0]) begin
     //  u_item.payload[4]=pause_quanta[0][15:8];
     //  u_item.payload[5]=pause_quanta[0][7:0];//queue1
     //end
     // if(!enable_bit_vector[1]) begin
     // u_item.payload[6]=pause_quanta[1][15:8];
     // u_item.payload[7]=pause_quanta[1][7:0];
     // end 
     // if(!enable_bit_vector[2]) begin
     // u_item.payload[8]=pause_quanta[2][15:8];
     // u_item.payload[9]=pause_quanta[2][7:0];
     // end 
     // if(!enable_bit_vector[3]) begin
     // u_item.payload[10]=pause_quanta[3][15:8];
     // u_item.payload[11]=pause_quanta[3][7:0];
     // end 
     // if(!enable_bit_vector[4] ) begin
     // u_item.payload[12]=pause_quanta[4][15:8];
     // u_item.payload[13]=pause_quanta[4][7:0];
     // end 
     // if(!enable_bit_vector[5]) begin
     // u_item.payload[14]=pause_quanta[5][15:8];
     // u_item.payload[15]=pause_quanta[5][7:0];
     // end
     // if(!enable_bit_vector[6]) begin
     // u_item.payload[16]=pause_quanta[6][15:8];
     // u_item.payload[17]=pause_quanta[6][7:0];
     // end 
     // if(!enable_bit_vector[7]) begin
     // u_item.payload[18]=pause_quanta[7][15:8];
     // u_item.payload[19]=pause_quanta[7][7:0];
     // end 
   end
endtask


function void eth_fc_mon::report_phase(uvm_phase phase);
   super.report_phase(phase);
endfunction:report_phase
