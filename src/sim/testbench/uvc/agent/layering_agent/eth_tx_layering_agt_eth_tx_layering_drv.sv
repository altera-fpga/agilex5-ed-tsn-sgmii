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


`ifndef ETH_TX_LAYERING_DRV__SV
`define ETH_TX_LAYERING_DRV__SV

typedef class eth_packet;
typedef class eth_tx_layering_drv;
typedef class ptp_tx_ref_model;
class eth_tx_layering_drv_callbacks extends uvm_callback;

     virtual task pre_tx( eth_tx_layering_drv xactor,eth_packet tr);
   endtask: pre_tx

   virtual task post_tx( eth_tx_layering_drv xactor,eth_packet tr);
   endtask: post_tx

endclass: eth_tx_layering_drv_callbacks


class eth_tx_layering_drv extends uvm_driver # (eth_packet);
   
   typedef virtual eth_sideband_interface v_if;
   v_if drv_if;
   virtual spy_interface spy_if;
   avst_sequencer  avst_sqr;
   //eth_param_tb tb_cfg;
   // Dynamic Config Obj
   dyn_rcfg dyn_rcfg_obj_inst; 
   packet_seq avst_sequence;
   ptp_tx_ref_model ref_model;
   //int fp_q[$:254]; //stumulur
   int unsigned randc_fp; 
   int unsigned fp_q[$];   //set to max
   int packet_id=0;
   string  file_avst_pkt = "avst_tx_lyring_drv_avst_pkt.log";
   integer file_avst_tx_lyring_drv_avst_pkt_id = $fopen(file_avst_pkt,"a");

   string m_sequence;
   uvm_cmdline_processor inst;
   string  file_eth_pkt = "avst_tx_lyring_drv_eth_pkt.log";
   integer file_avst_tx_lyring_drv_eth_pkt_id = $fopen(file_eth_pkt,"a");
   //Object: reg_model
   //This is register model handle
   registers_urm reg_model;
   bit pp;
   uvm_reg 	regs;
   bit txcrc_cover_preamble;
   uvm_reg_data_t txmac_ehip_cfg;
   uvm_reg_data_t tx_crc_control;

   `uvm_register_cb(eth_tx_layering_drv,eth_tx_layering_drv_callbacks); 
   
   extern function new(string name = "eth_tx_layering_drv",uvm_component parent = null); 
 
      `uvm_component_utils_begin(eth_tx_layering_drv)
      `uvm_component_utils_end

   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void end_of_elaboration_phase(uvm_phase phase);
   extern virtual function void start_of_simulation_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual task reset_phase(uvm_phase phase);
   extern virtual task configure_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   extern protected virtual task send(eth_packet tr); 
   extern protected virtual task tx_driver();
	extern virtual function int unsigned get_fp_randc();

   function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $fclose(file_avst_tx_lyring_drv_eth_pkt_id);
    $fclose(file_avst_tx_lyring_drv_avst_pkt_id);
   endfunction:report_phase

endclass: eth_tx_layering_drv


function eth_tx_layering_drv::new(string name = "eth_tx_layering_drv",uvm_component parent = null);
   super.new(name, parent);
endfunction: new


function void eth_tx_layering_drv::build_phase(uvm_phase phase);
   super.build_phase(phase);
   
   if(!uvm_config_db#(virtual spy_interface)::get(this, "", "spy_interface", spy_if)) begin
       `uvm_fatal("spy_interface", "failed to get spy_interface intf in layering drv");
     end  

     inst = uvm_cmdline_processor::get_inst();
     inst.get_arg_value("+m_sequence=",m_sequence);

   endfunction: build_phase

function void eth_tx_layering_drv::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   uvm_config_db#(v_if)::get(this, "", "mst_if", drv_if);
   //uvm_config_db#(eth_param_tb)::get(this, "", "tb_config", tb_cfg);
   // Get Dyn cfg obj
   if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", dyn_rcfg_obj_inst)) begin 
      `uvm_fatal("dyn_rcfg", "failed to get dyn_rcfg_obj_inst object from test");
   end
endfunction: connect_phase

function void eth_tx_layering_drv::end_of_elaboration_phase(uvm_phase phase);
   super.end_of_elaboration_phase(phase);
   if (drv_if == null)  `uvm_fatal("NO_CONN", "Virtual port not connected to the actual interface instance");   
   //if (tb_cfg == null)  `uvm_fatal("NO_CONN", "failed to get config db in tx layering drv");   
endfunction: end_of_elaboration_phase

function void eth_tx_layering_drv::start_of_simulation_phase(uvm_phase phase);
   super.start_of_simulation_phase(phase);

 drv_if.ptp_req=0;
 drv_if.ptp_fp=0;
 drv_if.ptp_ets=0;
 drv_if.ptp_cf=0;
 drv_if.ptp_0csum=0;
 drv_if.ptp_eb=0;
 drv_if.ptp_format=0;
 drv_if.ptp_ts_offset=0;
 drv_if.ptp_cf_offset=0;
 drv_if.ptp_csum_offset=0;
 drv_if.ptp_eb_offset=0;
 drv_if.ptp_ts=0;
 drv_if.ptp_error=0;

 
endfunction: start_of_simulation_phase

 
task eth_tx_layering_drv::reset_phase(uvm_phase phase);
   super.reset_phase(phase);
   // ToDo: Reset output signals
endtask: reset_phase

task eth_tx_layering_drv::configure_phase(uvm_phase phase);
   super.configure_phase(phase);
   //ToDo: Configure your component here
endtask:configure_phase

//Function to generate non-zero unique FP for PTP
function int unsigned eth_tx_layering_drv::get_fp_randc();
   bit succ =0; 
   while(!succ) begin
		succ =  std::randomize(randc_fp) with 
				{  foreach (randc_fp[i]){            
                  if(i>(dyn_rcfg_obj_inst.fp_width-1)){
                     randc_fp[i]==0;                  
                  }
               }
               randc_fp!=0;
               unique {randc_fp,fp_q};};
   end  
   
	//If success push to queue
   fp_q.push_back(randc_fp);
	
	//Reset the queue if the size reach max
   if(fp_q.size() == ((2**dyn_rcfg_obj_inst.fp_width)-1)) begin //minus 1 because value 0 is remove from the list
		`uvm_info("tx layering driver", "Reset fp_q",UVM_LOW)
      fp_q.delete();
   end
	
	`uvm_info(get_full_name(), $sformatf("FP generated is = %0h",randc_fp), UVM_MEDIUM)
	
   return randc_fp;
endfunction: get_fp_randc



task eth_tx_layering_drv::run_phase(uvm_phase phase);
   int i=0,pos;
   eth_packet      u_item;
   avst_req_base   l_item;
   super.run_phase(phase);
   //initialised tx_error
   
  `uvm_info("tx layering driver", "Initialized tx_error",UVM_LOW)
	  drv_if.tx_error = 0;
 //  $display("value of preamble passthrough is %d ",tb_cfg.preamble_passthrough);
   if(!uvm_config_db#(avst_sequencer)::get(this,"","lower_sqr",avst_sqr)) `uvm_fatal("NO_CONN", "Handle for avst sequencer not received");   
//pkt_seq=packet_seq::type_id::create("l_seq",this);
   avst_sequence=packet_seq::type_id::create("avst_sequence",this);
  `uvm_info("tx layering driver", "Starting transaction...",UVM_LOW)
   wait(drv_if.tx_lane_stable);
  `uvm_info("tx layering driver", "got tx lane stable,waiting for rx pcs ready",UVM_LOW)
   wait(drv_if.rx_pcs_ready);
    drv_if.l2_tx_preamble='hFB555_555_555_555_d5;
   //for(int j=1;j<=255;j++)
   //for(int j=1;j<=((2**dyn_rcfg_obj_inst.fp_width)-1);j++) 
   //begin
	//   fp_q.push_back(j);
   //end
	
   //fork 
	//forever begin 
	//	wait(ref_model.o_ptp_tx_fp_q.size()>0+i);
	//	fp_q.push_back(ref_model.o_ptp_tx_fp_q[$]);
	//	i++;
	//end
   //join_none 
   forever begin
	 l_item=avst_req_base::type_id::create("l_item",this);
	 seq_item_port.get_next_item(u_item);
	 packet_id = packet_id + 1;
    `uvm_info("tx layering driver",$psprintf("layering drv:this is the raw_pkt %s \n",u_item.sprint()),UVM_NONE);
     regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(tx_crc_control_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
     tx_crc_control = regs.get();
    `uvm_info("tx layering driver",$psprintf("layering drv: value of tx_crc_control is %d \n",tx_crc_control[1]),UVM_NONE);
   //  drv_if.tx_skip_crc= ~tx_crc_control[1];
    //regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
    regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(tx_preamble_control_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
    txmac_ehip_cfg = regs.get();
    pp = txmac_ehip_cfg[0];
    txcrc_cover_preamble = 0;//DM_TODO: txmac_ehip_cfg[9]; 
    //Shabbir: Calculate crc again if AVST UVC has to insert CRC and it should include preamble in CRC calculation
    if(u_item.skip_tx_crc_insertion==1 && txcrc_cover_preamble==1) begin
      u_item.calc_crc32(.txcrc_cover_preamble(1));
    end
   if(dyn_rcfg_obj_inst.speed inside {_50G,_40G} ) begin
     u_item.pack_bytes(!u_item.skip_tx_crc_insertion,0);
	   //if(tb_cfg.preamble_passthrough) drv_if.temp_pre=u_item.preamble;
	   if(pp) drv_if.temp_pre=u_item.preamble;
   end
   else begin
     //u_item.pack_bytes(!u_item.skip_tx_crc_insertion,tb_cfg.preamble_passthrough);
     u_item.pack_bytes(tx_crc_control[1],pp);
   end
	  l_item.data_symbols=new[u_item.packed_bytes.size](u_item.packed_bytes);
	  l_item.delay[0] = 5;
	  l_item.ipg = u_item.interpacket_gap;
	  l_item.num_symbols = l_item.data_symbols.size;
	  l_item.channel[0] = ~tx_crc_control[1];//using channel to drive i_tx_skip_crc to DUT
//driving ptp
	   //to make sure that fp is selected randomly from the queue
      //if(u_item.is_ptp_seq && fp_q.size > 0) begin
      //   pos=$urandom_range(fp_q.size-1); 
      //   drv_if.ptp_fp = fp_q[pos];
      //   fp_q.delete(pos);
	   //end else begin 
      //   drv_if.ptp_fp = 0;
      //   if(fp_q.size()==0) begin
      //      for(int j=1;j<=((2**dyn_rcfg_obj_inst.fp_width)-1);j++)
      //      begin
      //         fp_q.push_back(j);
      //      end
      //   end
	   //end

           //Qualify with ptp==1 so that it dont get randomised accidentally
           if((u_item.is_ptp_seq == 1) && (dyn_rcfg_obj_inst.ptp==1)) begin         
					drv_if.ptp_fp = get_fp_randc();
           end else begin 
					drv_if.ptp_fp = 0;
           end
			
           drv_if.ptp_p2p_en        = u_item.m_ptp_op[7];
           drv_if.ptp_format        = u_item.m_ptp_op[6]; 
	        drv_if.ptp_req           = u_item.m_ptp_op[5]; //insert 2 step   
           drv_if.ptp_ets           = u_item.m_ptp_op[4];   
           drv_if.ptp_cf            = u_item.m_ptp_op[3];   
           drv_if.ptp_0csum         = u_item.m_ptp_op[2];   
           drv_if.ptp_eb            = u_item.m_ptp_op[1];   
           drv_if.ptp_asym_lat_en   = u_item.m_ptp_op[0];    
           drv_if.ptp_asym_sign     = u_item.asym_sign;
           drv_if.ptp_asym_p2p_idx  = u_item.asym_p2p_idx;
           drv_if.ptp_ts_offset     = u_item.ptp_offset;   
           drv_if.ptp_cf_offset     = u_item.cf_offset;   
           drv_if.ptp_error         = (u_item.m_ptp_kind == PTP_NORMAL) ? 0: 1;


           if(u_item.m_ptp_op[2])    drv_if.ptp_csum_offset = u_item.cs_offset;//works as eb too   
           if(u_item.m_ptp_op[1])    drv_if.ptp_eb_offset   = u_item.cs_offset;//works as eb too  

           `uvm_info("tx layering driver",$psprintf("cs_offset=%0h",u_item.cs_offset),UVM_LOW);
           //drv_if.ptp_ts = u_item.ingress_ts;
/* if(u_item.insert_2step) begin
              drv_if.ptp_req=1;
              drv_if.ptp_fp=u_item.i_ptp_tx_fp;
            end
            if(u_item.insert_1step) begin
              drv_if.ptp_format=u_item.ts_format;
              drv_if.ptp_asym_lat_en=u_item.ptp_asym_latency_en;
              if(u_item.udp_cs_0) begin
              drv_if.ptp_0csum=1;
              drv_if.ptp_csum_offset=u_item.cs_offset;
              end
              if(u_item.add_eb) begin
              drv_if.ptp_eb=1;
              drv_if.ptp_eb_offset=u_item.cs_offset;//cs and eb
              end
              if(u_item.insert_cf) begin
              drv_if.ptp_cf=1;
              drv_if.ptp_cf_offset=u_item.cf_offset;
              drv_if.ptp_ts=u_item.ingress_ts; //should be 131
              end
              else begin
              drv_if.ptp_ets=1;
              if(u_item.ts_format) drv_if.ptp_cf_offset=u_item.cf_offset;
              drv_if.ptp_ts_offset=u_item.ptp_offset;
              end 
             end*/
/*          end
    else begin
              drv_if.ptp_req=0;
              drv_if.ptp_0csum=0;
              drv_if.ptp_eb=0;
              drv_if.ptp_cf=0;
              drv_if.ptp_ets=0;
    end
*/    

	  drv_if.tx_error = u_item.tx_error_insertion;
    `uvm_info("tx layering driver",$psprintf("Driving avst Frame \n",l_item.print()),UVM_DEBUG);
  	$fwrite(file_avst_tx_lyring_drv_avst_pkt_id,"Transaction no:%0d\n %s \n",packet_id,l_item.convert2string());
    `uvm_info("tx layering driver",$psprintf("Driving ethernet Frame ",u_item.print()),UVM_DEBUG);
  	$fwrite(file_avst_tx_lyring_drv_eth_pkt_id,"Transaction no:%0d\n %s \n",packet_id,u_item.print_transaction(packet_id));
         avst_sequence.start_item(l_item, -1, avst_sqr);
	 avst_sequence.finish_item(l_item, -1);
 // Optional: l_seq.get_response(rsp);
	 seq_item_port.item_done();
        //@(negedge drv_if.eop);
        if((dyn_rcfg_obj_inst.ptp==1)) begin
          if((m_sequence == "eth_ptp_hard_reset_recovery_sequence") || (m_sequence == "eth_ptp_soft_reset_recovery_sequence")) begin
            
             `uvm_info("tx layering driver",$psprintf("Excluding the sequence %s",m_sequence),UVM_NONE);
          end
          else
           begin
          @(negedge spy_if.act_eop); 
        end
        end
	end
endtask: run_phase


task eth_tx_layering_drv::tx_driver();
 forever begin
      eth_packet tr;
      // ToDo: Set output signals to their idle state
//      this.drv_if.master.async_en      <= 0;
      `uvm_info("eth_env_DRIVER", "Starting transaction...",UVM_LOW)
      seq_item_port.get_next_item(tr);
	  `uvm_do_callbacks(eth_tx_layering_drv,eth_tx_layering_drv_callbacks,
                    pre_tx(this, tr))
      send(tr); 
      seq_item_port.item_done();
      `uvm_info("eth_env_DRIVER", "Completed transaction...",UVM_LOW)
      `uvm_info("eth_env_DRIVER", tr.sprint(),UVM_HIGH)
      `uvm_do_callbacks(eth_tx_layering_drv,eth_tx_layering_drv_callbacks,
                    post_tx(this, tr))

   end
endtask : tx_driver

task eth_tx_layering_drv::send(eth_packet tr);
   // ToDo: Drive signal on interface
  
endtask: send


`endif // ETH_TX_LAYERING_DRV__SV


