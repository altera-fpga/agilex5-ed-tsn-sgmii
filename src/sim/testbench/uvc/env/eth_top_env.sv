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



`ifndef ETH_TOP_ENV__SV
`define ETH_TOP_ENV__SV
  import altuvm_avalon_st_test_pkg::*;
  import vector_uvc_pkg::*;
  import reset_uvc_pkg::*;
  import altuvm_avalon_mm_pkg::*;

class eth_top_env extends uvm_env;

   eth_env_env                  env_ip[];
   
   svt_axi_system_configuration m_axi_system_cfg;
   svt_axi_system_env           m_axi_st_env;

   kr_cfg                       kr_cfg_inst;
   altuvm_avalon_mm_agent       kr10g_avmm_agt;
   altuvm_avalon_mm_config      kr10g_avmm_agt_cfg;
   altuvm_avalon_mm_agent       kr25g_avmm_agt;
   altuvm_avalon_mm_config      kr25g_avmm_agt_cfg;
   altuvm_avalon_mm_agent       kr40g_avmm_agt;
   altuvm_avalon_mm_config      kr40g_avmm_agt_cfg;
   altuvm_avalon_mm_agent       kr50g_avmm_agt;
   altuvm_avalon_mm_config      kr50g_avmm_agt_cfg;
   altuvm_avalon_mm_agent       kr100g_avmm_agt;
   altuvm_avalon_mm_config      kr100g_avmm_agt_cfg;
   altuvm_avalon_mm_agent       kr200g_avmm_agt;
   altuvm_avalon_mm_config      kr200g_avmm_agt_cfg;
   altuvm_avalon_mm_agent       kr400g_avmm_agt;
   altuvm_avalon_mm_config      kr400g_avmm_agt_cfg;

   eth_anlt_f_csr_doc_urm kr10g_reg_model;
   eth_anlt_f_csr_doc_urm kr25g_reg_model;
   eth_anlt_f_csr_doc_urm kr40g_reg_model;
   eth_anlt_f_csr_doc_urm kr50g_reg_model;
   eth_anlt_f_csr_doc_urm kr100g_reg_model;
   eth_anlt_f_csr_doc_urm kr200g_reg_model;
   eth_anlt_f_csr_doc_urm kr400g_reg_model;

   altuvm_avalon_mm_reg_adapter_eth kr10g_reg_adpt;
   altuvm_avalon_mm_reg_adapter_eth kr25g_reg_adpt;
   altuvm_avalon_mm_reg_adapter_eth kr40g_reg_adpt;
   altuvm_avalon_mm_reg_adapter_eth kr50g_reg_adpt;
   altuvm_avalon_mm_reg_adapter_eth kr100g_reg_adpt;
   altuvm_avalon_mm_reg_adapter_eth kr200g_reg_adpt;
   altuvm_avalon_mm_reg_adapter_eth kr400g_reg_adpt;

   // For P2P
   altuvm_avalon_mm_agent       p2p_avmm_agt;
   altuvm_avalon_mm_config      p2p_avmm_agt_cfg;
   gdr_ehip_p2p_urm             p2p_reg_model;
   altuvm_avalon_mm_reg_adapter p2p_reg_adpt;
   altuvm_avalon_mm_reg_predictor p2p_reg_predictor;
   // For ASM
   altuvm_avalon_mm_agent       asm_avmm_agt;
   altuvm_avalon_mm_config      asm_avmm_agt_cfg;
   gdr_ehip_asm_urm             asm_reg_model;
   altuvm_avalon_mm_reg_adapter asm_reg_adpt;
   altuvm_avalon_mm_reg_predictor asm_reg_predictor;

   string p2p_avmm_rtb_path;
   string asm_avmm_rtb_path;

   string kr10g_avmm_rtb_path;
   string kr25g_avmm_rtb_path;
   string kr40g_avmm_rtb_path;
   string kr50g_avmm_rtb_path;
   string kr100g_avmm_rtb_path;
   string kr200g_avmm_rtb_path;
   string kr400g_avmm_rtb_path;
   int   num_inst = 1;

   // This is virtual sequnecer instance 
   eth_top_virtual_sequencer top_virtual_sequencer_inst;
   anlt_register_coverage anlt_reg_cov;

   `uvm_component_utils(eth_top_env)
     
   extern function new(string name="eth_top_env", uvm_component parent=null);
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
   extern function void start_of_simulation_phase(uvm_phase phase);
   extern virtual task reset_phase(uvm_phase phase);
   extern virtual task configure_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   extern virtual function void report_phase(uvm_phase phase);
   extern virtual task shutdown_phase(uvm_phase phase);
`ifdef ENABLE_ETH_VIP
   extern virtual task config_vip(speed_e speed = _25G, int inst = 0, bit vip_np_en = 0, int vip_np_num = 0, anlt_std_e anlt_std = IEEE);
   extern virtual task vip_dme_page_cfg(speed_e speed = _25G, int inst = 0, bit vip_np_en = 0, int vip_np_num = 0, anlt_std_e anlt_std = IEEE);
   extern virtual task vip_dme_page_cfg_consortium_mode(speed_e speed = _25G, int inst = 0, bit vip_np_en = 0, int vip_np_num = 0, anlt_std_e anlt_std = IEEE);
   extern virtual task reset_vip(int inst = 0);
   extern virtual task wait_rx_pcs_ready(speed_e speed = _25G, int node = 0, int inst = 0, anlt_std_e anlt_std = IEEE);
   extern virtual task wait_for_an_complete(speed_e speed = _25G, int node = 0, int inst = 0, anlt_std_e anlt_std = IEEE);
   extern virtual task wait_for_lt_complete(speed_e speed = _25G, int node = 0, int inst = 0, bit skip_c3_delay=1'b0, bit skip_reconfig=1'b0);
   extern virtual function bit [17:0] get_neg_port(speed_e speed = _25G, int inst = 0, anlt_std_e anlt_std = IEEE);
   extern virtual function bit [24:0] get_tech_ability(speed_e speed = _25G, int inst = 0, anlt_std_e anlt_std = IEEE);
   extern virtual task check_base_page(speed_e speed = _25G, int node = 0, int inst = 0, bit [47:0] vip_page_received, anlt_std_e anlt_std = IEEE);   
   extern virtual task reconfig_vip_for_lt_mode(speed_e speed = _25G, int inst = 0, int wait_timer=15);
   extern virtual task reconfig_vip_for_an_mode(speed_e speed = _25G, int inst = 0);
   extern virtual task reconfig_vip_for_datamode(speed_e speed = _25G, int inst = 0);
   extern virtual task reconfig_vip_for_consortium_mode(speed_e speed = _25G, int inst = 0);
   extern virtual task nonce_possibility(speed_e speed = _25G, int inst = 0, bit allow_enable_errors=1);
   extern virtual function void disable_an_snps_errors(speed_e speed = _25G, int inst = 0);
   extern virtual function void enable_an_snps_errors(speed_e speed = _25G, int inst = 0);
   extern virtual function void disable_lt_snps_errors(speed_e speed = _25G, int inst = 0);
   extern virtual function void enable_lt_snps_errors(speed_e speed = _25G, int inst = 0);
   extern virtual function void enable_10_25G_snps_errors(speed_e speed = _25G, int inst = 0);
   extern virtual function void disable_10_25G_snps_errors(speed_e speed = _25G, int inst = 0);
   extern virtual function void enable_snps_errors(speed_e speed = _25G, int inst = 0, string ERR_TYPE = "ALL");
   extern virtual function void disable_snps_errors(speed_e speed = _25G, int inst = 0, string ERR_TYPE = "ALL");
`endif
   extern task reg_write_anlt(string reg_name,uvm_reg_data_t write_data, input speed_e speed);
   extern task reg_read_anlt(string reg_name,ref uvm_reg_data_t read_data, input speed_e speed, bit disable_check=0);
   extern task reg_write_by_addr_anlt(uvm_reg_data_t reg_offset,uvm_reg_data_t write_data, input speed_e speed);
   extern task reg_read_by_addr_anlt(uvm_reg_data_t reg_offset,ref uvm_reg_data_t read_data, input speed_e speed);
   extern task gdr_ral_write_anlt(string reg_name,uvm_reg_data_t write_data, input speed_e speed); 
   extern task gdr_ral_read_anlt(string reg_name,ref uvm_reg_data_t read_data, input speed_e speed);
   extern function int gdr_ral_offset_anlt(string reg_name, speed_e speed);
   extern function int gdr_ral_get_anlt(string reg_name, string field_name = "", speed_e speed);
   extern function void gdr_ral_predict_anlt(string reg_name, string field_name = "", uvm_reg_data_t reg_data, uvm_predict_e kind, speed_e speed);
   extern function void gdr_ral_set_reset_anlt(string reg_name, string field_name = "", int field_val, speed_e speed);
   extern function void gdr_ral_set_anlt(string reg_name, string field_name = "", int field_val, speed_e speed);
   extern function void gdr_ral_reset_anlt(string reg_name, string field_name = "", speed_e speed);

   extern task gdr_ral_write_p2p(string reg_name, uvm_reg_data_t addr, uvm_reg_data_t write_data);
   extern task gdr_ral_read_p2p(string reg_name,ref uvm_reg_data_t read_data);
   extern function int gdr_ral_offset_p2p(string reg_name);
   extern function int gdr_ral_get_p2p(string reg_name, string field_name);
   extern function void gdr_ral_predict_p2p(string reg_name, string field_name, uvm_reg_data_t reg_data, uvm_predict_e kind);
   extern function void gdr_ral_set_reset_p2p(string reg_name, string field_name, int field_val);
   extern function void gdr_ral_set_p2p(string reg_name, string field_name, int field_val);
   extern function void gdr_ral_reset_p2p(string reg_name, string field_name);
   extern task gdr_ral_write_asm(string reg_name, uvm_reg_data_t addr, uvm_reg_data_t write_data);
   extern task gdr_ral_read_asm(string reg_name,ref uvm_reg_data_t read_data);
   extern function int gdr_ral_offset_asm(string reg_name);
   extern function int gdr_ral_get_asm(string reg_name, string field_name);
   extern function void gdr_ral_predict_asm(string reg_name, string field_name, uvm_reg_data_t reg_data, uvm_predict_e kind);
   extern function void gdr_ral_set_reset_asm(string reg_name, string field_name, int field_val);
   extern function void gdr_ral_set_asm(string reg_name, string field_name, int field_val);
   extern function void gdr_ral_reset_asm(string reg_name, string field_name);
   extern task reg_read_asm(string reg_name,ref uvm_reg_data_t read_data,input bit[1:0] disable_check=0,uvm_reg_byte_en_t byte_enable='hf);
   extern task reg_read_p2p(string reg_name,ref uvm_reg_data_t read_data,input bit[1:0] disable_check=0,uvm_reg_byte_en_t byte_enable='hf);
   extern task write_asym_p2p_latency(bit [23:0] asym_lat= 130, bit [23:0] p2p_lat= 131, bit rand_asym_p2p_lat= 1);
   extern task read_asym_p2p_latency(bit compare_dis = 0);

endclass: eth_top_env

   task eth_top_env::reg_write_anlt(string reg_name,uvm_reg_data_t write_data, input speed_e speed);
     uvm_status_e  status;
     uvm_reg 	   reg_select;
     
     case(speed)
       _10G:  begin
                reg_select = kr10g_reg_model.get_reg_by_name(reg_name);
                if(reg_select != null)
                  reg_select.write(status,.value(write_data), .map(kr10g_reg_model.default_map));
              end
       _25G:  begin
                reg_select = kr25g_reg_model.get_reg_by_name(reg_name);
                if(reg_select != null)
                  reg_select.write(status,.value(write_data), .map(kr25g_reg_model.default_map));
              end
       _40G:  begin
                reg_select = kr40g_reg_model.get_reg_by_name(reg_name);
                if(reg_select != null)
                  reg_select.write(status,.value(write_data), .map(kr40g_reg_model.default_map));
              end
       _50G:  begin
                  reg_select = kr50g_reg_model.get_reg_by_name(reg_name);
                  if(reg_select != null)
                    reg_select.write(status,.value(write_data), .map(kr50g_reg_model.default_map));
                end
       _100G: begin
                reg_select = kr100g_reg_model.get_reg_by_name(reg_name);
                if(reg_select != null)
                  reg_select.write(status,.value(write_data), .map(kr100g_reg_model.default_map));
              end
       _200G: begin
                reg_select = kr200g_reg_model.get_reg_by_name(reg_name);
                if(reg_select != null)
                  reg_select.write(status,.value(write_data), .map(kr200g_reg_model.default_map));
              end
       _400G: begin
                reg_select = kr400g_reg_model.get_reg_by_name(reg_name);
                if(reg_select != null)
                  reg_select.write(status,.value(write_data), .map(kr400g_reg_model.default_map));
              end
     endcase

     if(reg_select != null)
       `uvm_info("AVMM REG WRITE", $sformatf("Register(%s) address 'h%0h write data :'h%0h, speed : %s",reg_select.get_name(),reg_select.get_offset(),write_data,speed), UVM_NONE)
     else
       `uvm_error("AVMM REG WRITE", $sformatf("Register not found: address 'h%0h, speed : %s",reg_select.get_offset(),speed));
     
   endtask:reg_write_anlt
   
   
   task eth_top_env::reg_read_anlt(string reg_name,ref uvm_reg_data_t read_data, input speed_e speed, bit disable_check=0);
     uvm_status_e  status;
     uvm_reg 	   reg_select;
     
     case(speed)
       _10G:  begin
                reg_select = kr10g_reg_model.get_reg_by_name(reg_name);
                if(reg_select != null)
                  reg_select.read(status,.value(read_data), .map(kr10g_reg_model.default_map));
              end
       _25G:  begin
                reg_select = kr25g_reg_model.get_reg_by_name(reg_name);
                if(reg_select != null)
                  reg_select.read(status,.value(read_data), .map(kr25g_reg_model.default_map));
              end
       _40G:  begin
                reg_select = kr40g_reg_model.get_reg_by_name(reg_name);
                if(reg_select != null)
                  reg_select.read(status,.value(read_data), .map(kr40g_reg_model.default_map));
              end
       _50G:  begin
                  reg_select = kr50g_reg_model.get_reg_by_name(reg_name);
                  if(reg_select != null)
                    reg_select.read(status,.value(read_data), .map(kr50g_reg_model.default_map));
                end
       _100G: begin
                reg_select = kr100g_reg_model.get_reg_by_name(reg_name);
                if(reg_select != null)
                  reg_select.read(status,.value(read_data), .map(kr100g_reg_model.default_map));
              end
       _200G: begin
                reg_select = kr200g_reg_model.get_reg_by_name(reg_name);
                if(reg_select != null)
                  reg_select.read(status,.value(read_data), .map(kr200g_reg_model.default_map));
              end
       _400G: begin
                reg_select = kr400g_reg_model.get_reg_by_name(reg_name);
                if(reg_select != null)
                  reg_select.read(status,.value(read_data), .map(kr400g_reg_model.default_map));
              end
     endcase

     if(reg_select != null)
       begin
         if(disable_check == 0)
         begin
           `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] Register(%s) address 'h%0h actual read data :'h%0h expected read data :'h%0h, speed : %s",reg_select.get_name(),reg_select.get_offset(),read_data,reg_select.get_mirrored_value(),speed), UVM_NONE)
           if(reg_select.get_mirrored_value() != read_data)
             `uvm_error("AVMM REG READ", $sformatf("Register(%s) read data mismatch for address %h, speed : %s",reg_select.get_name(),reg_select.get_offset(),speed));
         end
         else
         begin
           `uvm_info("AVMM REG READ", $sformatf("[COMPARISON DISABLED] Register(%s) address 'h%0h actual read data :'h%0h, speed : %s",reg_select.get_name(),reg_select.get_offset(),read_data,speed), UVM_NONE)
         end
       end
       else 
         `uvm_error("AVMM REG READ", $sformatf("Register not found: address 'h%0h, speed : %s",reg_select.get_offset(),speed));

     endtask:reg_read_anlt

     task eth_top_env::reg_write_by_addr_anlt(uvm_reg_data_t reg_offset,uvm_reg_data_t write_data, input speed_e speed);
         altuvm_avalon_mm_write_seq   write_seq;
     
     
         write_seq = altuvm_avalon_mm_write_seq::type_id::create("write");
         case(speed)
           _10G:  write_seq.set_sequencer(top_virtual_sequencer_inst.kr10g_sqr);
           _25G:  write_seq.set_sequencer(top_virtual_sequencer_inst.kr25g_sqr);
           _40G:  write_seq.set_sequencer(top_virtual_sequencer_inst.kr40g_sqr);
           _50G:  write_seq.set_sequencer(top_virtual_sequencer_inst.kr50g_sqr);
           _100G: write_seq.set_sequencer(top_virtual_sequencer_inst.kr100g_sqr);
           _200G: write_seq.set_sequencer(top_virtual_sequencer_inst.kr200g_sqr);
           _400G: write_seq.set_sequencer(top_virtual_sequencer_inst.kr400g_sqr);
         endcase
         write_seq.randomize() with {
                init_latency inside {[0:3]};
                address   == reg_offset<<2;
                foreach (byteenable[i]) byteenable[i] == 1;
	        writedata[0] == write_data[7:0]; 
	        writedata[1] == write_data[15:8]; 
	        writedata[2] == write_data[23:16]; 
	        writedata[3] == write_data[31:24]; 
              };
          case(speed)
            _10G:  write_seq.start(top_virtual_sequencer_inst.kr10g_sqr);
            _25G:  write_seq.start(top_virtual_sequencer_inst.kr25g_sqr);
            _40G:  write_seq.start(top_virtual_sequencer_inst.kr40g_sqr);
            _50G:  write_seq.start(top_virtual_sequencer_inst.kr50g_sqr);
            _100G: write_seq.start(top_virtual_sequencer_inst.kr100g_sqr);
            _200G: write_seq.start(top_virtual_sequencer_inst.kr200g_sqr);
            _400G: write_seq.start(top_virtual_sequencer_inst.kr400g_sqr);
         endcase
     
   endtask:reg_write_by_addr_anlt

   task eth_top_env::reg_read_by_addr_anlt(uvm_reg_data_t reg_offset,ref uvm_reg_data_t read_data, input speed_e speed);
     altuvm_avalon_mm_read_seq      read_seq;
     
         read_seq  = altuvm_avalon_mm_read_seq::type_id::create("read");
         case(speed)
           _10G:  read_seq.set_sequencer(top_virtual_sequencer_inst.kr10g_sqr);
           _25G:  read_seq.set_sequencer(top_virtual_sequencer_inst.kr25g_sqr);
           _40G:  read_seq.set_sequencer(top_virtual_sequencer_inst.kr40g_sqr);
           _50G:  read_seq.set_sequencer(top_virtual_sequencer_inst.kr50g_sqr);
           _100G: read_seq.set_sequencer(top_virtual_sequencer_inst.kr100g_sqr);
           _200G: read_seq.set_sequencer(top_virtual_sequencer_inst.kr200g_sqr);
           _400G: read_seq.set_sequencer(top_virtual_sequencer_inst.kr400g_sqr);
         endcase
         read_seq.randomize() with {
              init_latency inside {[0:3]};
              address   == reg_offset << 2;
              foreach (byteenable[i]) byteenable[i] == 1;
            };
         case(speed)
            _10G:  read_seq.start(top_virtual_sequencer_inst.kr10g_sqr);
            _25G:  read_seq.start(top_virtual_sequencer_inst.kr25g_sqr);
            _40G:  read_seq.start(top_virtual_sequencer_inst.kr40g_sqr);
            _50G:  read_seq.start(top_virtual_sequencer_inst.kr50g_sqr);
            _100G: read_seq.start(top_virtual_sequencer_inst.kr100g_sqr);
            _200G: read_seq.start(top_virtual_sequencer_inst.kr200g_sqr);
            _400G: read_seq.start(top_virtual_sequencer_inst.kr400g_sqr);
         endcase
            read_data = {read_seq.readdata[3],read_seq.readdata[2],read_seq.readdata[1],read_seq.readdata[0]};

     endtask:reg_read_by_addr_anlt

task eth_top_env::gdr_ral_write_anlt(string reg_name,uvm_reg_data_t write_data, input speed_e speed);
     uvm_status_e    status;
     uvm_reg 	     reg_select;
     
     case(speed)
       _10G:  begin
                reg_select = kr10g_reg_model.get_reg_by_name(reg_name);
                reg_select.write(status,.value(write_data), .map(kr10g_reg_model.default_map));
              end
       _25G:  begin
                reg_select = kr25g_reg_model.get_reg_by_name(reg_name);
                reg_select.write(status,.value(write_data), .map(kr25g_reg_model.default_map));
              end
       _40G:  begin
                reg_select = kr40g_reg_model.get_reg_by_name(reg_name);
                reg_select.write(status,.value(write_data), .map(kr40g_reg_model.default_map));
              end
       _50G:  begin
                  reg_select = kr50g_reg_model.get_reg_by_name(reg_name);
                  reg_select.write(status,.value(write_data), .map(kr50g_reg_model.default_map));
                end
       _100G: begin
                reg_select = kr100g_reg_model.get_reg_by_name(reg_name);
                reg_select.write(status,.value(write_data), .map(kr100g_reg_model.default_map));
              end
       _200G: begin
                reg_select = kr200g_reg_model.get_reg_by_name(reg_name);
                reg_select.write(status,.value(write_data), .map(kr200g_reg_model.default_map));
              end
       _400G: begin
                reg_select = kr400g_reg_model.get_reg_by_name(reg_name);
                reg_select.write(status,.value(write_data), .map(kr400g_reg_model.default_map));
              end
     endcase
endtask:gdr_ral_write_anlt

task eth_top_env::gdr_ral_read_anlt(string reg_name,ref uvm_reg_data_t read_data, input speed_e speed);
     uvm_status_e    status;
     uvm_reg 	     reg_select;
   
     case(speed)
       _10G:  begin
                reg_select = kr10g_reg_model.get_reg_by_name(reg_name);
                reg_select.read(status,.value(read_data), .map(kr10g_reg_model.default_map));
              end
       _25G:  begin
                reg_select = kr25g_reg_model.get_reg_by_name(reg_name);
                reg_select.read(status,.value(read_data), .map(kr25g_reg_model.default_map));
              end
       _40G:  begin
                reg_select = kr40g_reg_model.get_reg_by_name(reg_name);
                reg_select.read(status,.value(read_data), .map(kr40g_reg_model.default_map));
              end
       _50G:  begin
                  reg_select = kr50g_reg_model.get_reg_by_name(reg_name);
                  reg_select.read(status,.value(read_data), .map(kr50g_reg_model.default_map));
                end
       _100G: begin
                reg_select = kr100g_reg_model.get_reg_by_name(reg_name);
                reg_select.read(status,.value(read_data), .map(kr100g_reg_model.default_map));
              end
       _200G: begin
                reg_select = kr200g_reg_model.get_reg_by_name(reg_name);
                reg_select.read(status,.value(read_data), .map(kr200g_reg_model.default_map));
              end
       _400G: begin
                reg_select = kr400g_reg_model.get_reg_by_name(reg_name);
                reg_select.read(status,.value(read_data), .map(kr400g_reg_model.default_map));
              end
     endcase
endtask:gdr_ral_read_anlt

function int eth_top_env::gdr_ral_offset_anlt(string reg_name, speed_e speed);
    uvm_reg     reg_select;

    case(speed)
       _10G:  reg_select = kr10g_reg_model.get_reg_by_name(reg_name);
       _25G:  reg_select = kr25g_reg_model.get_reg_by_name(reg_name);
       _40G:  reg_select = kr40g_reg_model.get_reg_by_name(reg_name);
       _50G:  reg_select = kr50g_reg_model.get_reg_by_name(reg_name);
       _100G: reg_select = kr100g_reg_model.get_reg_by_name(reg_name);
       _200G: reg_select = kr200g_reg_model.get_reg_by_name(reg_name);
       _400G: reg_select = kr400g_reg_model.get_reg_by_name(reg_name);
     endcase
     
     return reg_select.get_offset();
endfunction:gdr_ral_offset_anlt

function int eth_top_env::gdr_ral_get_anlt(string reg_name, string field_name = "", speed_e speed);
    uvm_reg_field reg_field;
    uvm_reg       reg_select;

    case(speed)
       _10G:  reg_select = kr10g_reg_model.get_reg_by_name(reg_name);
       _25G:  reg_select = kr25g_reg_model.get_reg_by_name(reg_name);
       _40G:  reg_select = kr40g_reg_model.get_reg_by_name(reg_name);
       _50G:  reg_select = kr50g_reg_model.get_reg_by_name(reg_name);
       _100G: reg_select = kr100g_reg_model.get_reg_by_name(reg_name);
       _200G: reg_select = kr200g_reg_model.get_reg_by_name(reg_name);
       _400G: reg_select = kr400g_reg_model.get_reg_by_name(reg_name);
     endcase

     if(field_name == "")
       return reg_select.get();
     else begin
       reg_field = reg_select.get_field_by_name(field_name);
       return reg_field.get();
     end
endfunction:gdr_ral_get_anlt

function void eth_top_env::gdr_ral_predict_anlt(string reg_name, string field_name = "", uvm_reg_data_t reg_data, uvm_predict_e kind, speed_e speed);
    uvm_reg   reg_select;

    case(speed)
       _10G:  begin
                reg_select = kr10g_reg_model.get_reg_by_name(reg_name);
                reg_select.predict(.value(reg_data), .kind(kind), .map(kr10g_reg_model.default_map));
              end
       _25G:  begin
                reg_select = kr25g_reg_model.get_reg_by_name(reg_name);
                reg_select.predict(.value(reg_data), .kind(kind), .map(kr25g_reg_model.default_map));
              end
       _40G:  begin
                reg_select = kr40g_reg_model.get_reg_by_name(reg_name);
                reg_select.predict(.value(reg_data), .kind(kind), .map(kr40g_reg_model.default_map));
              end
       _50G:  begin
                  reg_select = kr50g_reg_model.get_reg_by_name(reg_name);
                  reg_select.predict(.value(reg_data), .kind(kind), .map(kr50g_reg_model.default_map));
                end
       _100G: begin
                reg_select = kr100g_reg_model.get_reg_by_name(reg_name);
                reg_select.predict(.value(reg_data), .kind(kind), .map(kr100g_reg_model.default_map));
              end
       _200G: begin
                reg_select = kr200g_reg_model.get_reg_by_name(reg_name);
                reg_select.predict(.value(reg_data), .kind(kind), .map(kr200g_reg_model.default_map));
              end
       _400G: begin
                reg_select = kr400g_reg_model.get_reg_by_name(reg_name);
                reg_select.predict(.value(reg_data), .kind(kind), .map(kr400g_reg_model.default_map));
              end
     endcase
     return;
endfunction:gdr_ral_predict_anlt

function void eth_top_env::gdr_ral_set_reset_anlt(string reg_name, string field_name = "", int field_val, speed_e speed);
    uvm_reg_field  reg_field;
    uvm_reg        reg_select;

    case(speed)
       _10G:  reg_select = kr10g_reg_model.get_reg_by_name(reg_name);
       _25G:  reg_select = kr25g_reg_model.get_reg_by_name(reg_name);
       _40G:  reg_select = kr40g_reg_model.get_reg_by_name(reg_name);
       _50G:  reg_select = kr50g_reg_model.get_reg_by_name(reg_name);
       _100G: reg_select = kr100g_reg_model.get_reg_by_name(reg_name);
       _200G: reg_select = kr200g_reg_model.get_reg_by_name(reg_name);
       _400G: reg_select = kr400g_reg_model.get_reg_by_name(reg_name);
     endcase

     reg_field  = reg_select.get_field_by_name(field_name);
     reg_field.set_reset(field_val);
     return;
endfunction:gdr_ral_set_reset_anlt

function void eth_top_env::gdr_ral_set_anlt(string reg_name, string field_name = "", int field_val, speed_e speed);
    uvm_reg_field  reg_field;
    uvm_reg        reg_select;

    case(speed)
       _10G:  reg_select = kr10g_reg_model.get_reg_by_name(reg_name);
       _25G:  reg_select = kr25g_reg_model.get_reg_by_name(reg_name);
       _40G:  reg_select = kr40g_reg_model.get_reg_by_name(reg_name);
       _50G:  reg_select = kr50g_reg_model.get_reg_by_name(reg_name);
       _100G: reg_select = kr100g_reg_model.get_reg_by_name(reg_name);
       _200G: reg_select = kr200g_reg_model.get_reg_by_name(reg_name);
       _400G: reg_select = kr400g_reg_model.get_reg_by_name(reg_name);
     endcase

     reg_field  = reg_select.get_field_by_name(field_name);
     reg_field.set(field_val);
     return;
endfunction:gdr_ral_set_anlt

function void eth_top_env::gdr_ral_reset_anlt(string reg_name, string field_name = "", speed_e speed);
    uvm_reg_field  reg_field;
    uvm_reg        reg_select;

    case(speed)
       _10G:  reg_select = kr10g_reg_model.get_reg_by_name(reg_name);
       _25G:  reg_select = kr25g_reg_model.get_reg_by_name(reg_name);
       _40G:  reg_select = kr40g_reg_model.get_reg_by_name(reg_name);
       _50G:  reg_select = kr50g_reg_model.get_reg_by_name(reg_name);
       _100G: reg_select = kr100g_reg_model.get_reg_by_name(reg_name);
       _200G: reg_select = kr200g_reg_model.get_reg_by_name(reg_name);
       _400G: reg_select = kr400g_reg_model.get_reg_by_name(reg_name);
     endcase

     if(field_name == "")
       reg_select.reset();
     else begin
       reg_field  = reg_select.get_field_by_name(field_name);
       reg_field.reset();
     end 
     return;
endfunction:gdr_ral_reset_anlt

`ifdef ENABLE_ETH_VIP

  task eth_top_env :: config_vip(speed_e speed = _25G, int inst = 0, bit vip_np_en = 0, int vip_np_num = 0, anlt_std_e anlt_std = IEEE);
    if(anlt_std == IEEE) begin
      vip_dme_page_cfg(speed,inst,vip_np_en,vip_np_num,anlt_std);
    end
    else if(anlt_std == CONSORTIUM) begin
      vip_dme_page_cfg_consortium_mode(speed,inst,vip_np_en,vip_np_num,anlt_std);
    end
    else if(anlt_std == IEEE_CONSORTIUM) begin
      vip_dme_page_cfg(speed,inst,vip_np_en,vip_np_num,anlt_std);
      vip_dme_page_cfg_consortium_mode(speed,inst,vip_np_en,vip_np_num,anlt_std);
    end
  endtask:config_vip

  task eth_top_env :: vip_dme_page_cfg(speed_e speed = _25G, int inst = 0, bit vip_np_en = 0, int vip_np_num = 0, anlt_std_e anlt_std = IEEE);
    bit [3:0]  vip_fec_cap;
    bit [1:0]  vip_pause_cap;
    bit [24:0] vip_tech_ability;
    bit vip_rf;

    vip_tech_ability = get_tech_ability(speed,inst,anlt_std);
    vip_pause_cap = $urandom_range(3,0);
    vip_rf = $urandom_range(1,0);

    if(speed == _25G) begin
      if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKR)
        vip_fec_cap = 5'b00010;
      else if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == FCFEC)
        vip_fec_cap = 5'b00100;
    end
    else if(speed == _100G && env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1) begin
        vip_fec_cap = 5'b00001;
    end

    
    env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_NEXT_PAGE_BIT,vip_np_en);
    env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_NMBR_NXT_PGE,vip_np_num);
    env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_NON_PHY_CAPABILITY,vip_pause_cap);
    env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_RF_BIT,vip_rf);
    env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_TECHNOLOGY_ABILITY_FIELD,vip_tech_ability);
    if(anlt_std == IEEE)
      env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_FEC_CAPABILITY,vip_fec_cap);
    `uvm_info(get_type_name(), $sformatf("VIP DME PAGE CONFIG: \n NP - %0b,\nNUM_OF_NP - %0d,\nFEC - %0b,\nPAUSE - %0b\nRF - %0b\nTECH_ABILITY %0b",vip_np_en,vip_np_num,vip_fec_cap,vip_pause_cap,vip_rf,vip_tech_ability), UVM_NONE)
  endtask:vip_dme_page_cfg
  
  task eth_top_env :: vip_dme_page_cfg_consortium_mode(speed_e speed = _25G, int inst = 0, bit vip_np_en = 0, int vip_np_num = 0, anlt_std_e anlt_std = IEEE);
    bit [20:0] vip_tech_ability;
    bit f1,f2,f3,f4,lf1,lf2,lf3,lfr;

    if(anlt_std == CONSORTIUM) begin
      vip_tech_ability = get_tech_ability(speed,inst,anlt_std);
      if(speed == _25G) begin
        if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKR) 
          {f1,f3} = $urandom_range(0,3);
        else if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == FCFEC)
          {f2,f4} = $urandom_range(0,3);
      end
      else if(speed == _50G) begin
        {f1,f3} = $urandom_range(0,3);
      end
    end
    else if(anlt_std == IEEE_CONSORTIUM) begin
      if(speed == _50G) begin
        {lf1,lfr} = $urandom_range(0,3);
      end
      else if(speed == _100G) begin
        {lf2,lfr} = $urandom_range(0,3);
      end
      else if(speed == _200G) begin
        {lf3,lfr} = $urandom_range(0,3);
      end
    end

    reconfig_vip_for_consortium_mode(speed,inst);
    env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_NEXT_PAGE_BIT,vip_np_en);
    env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_NMBR_NXT_PGE,vip_np_num);
    env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_NEXT_PAGE,{5'h0,1'h1,32'h04df0353,11'h5});
    env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_UNFORMATTED_NEXT_PAGE,{5'h0,1'h0,3'h0,lfr,f4,f3,f2,f1,lf3,lf2,lf1,vip_tech_ability,11'h203});
    `uvm_info(get_type_name(), $sformatf("VIP DME PAGE CONFIG: \n NP - %0b,\nNUM_OF_NP - %0d,\nF1 - %0b,\nF2 - %0b,\nF3 - %0b,\nF4 - %0b,\nLF1 - %0b,\nLF2 - %0b,\nLF3 - %0b,\nLFR - %0b",vip_np_en,vip_np_num,f1,f2,f3,f4,lf1,lf2,lf3,lfr), UVM_NONE)
  endtask:vip_dme_page_cfg_consortium_mode

  task eth_top_env :: reset_vip(int inst = 0);
      env_ip[inst].svt_ethernet_txrx_inst.reset = 1;
      repeat (10) @(env_ip[inst].svt_ethernet_txrx_inst.xgmii_rx_clk);
      //#10ns;
      env_ip[inst].svt_ethernet_txrx_inst.reset = 0;
      #1step;
      @(env_ip[inst].svt_ethernet_txrx_inst.xgmii_rx_clk);
  endtask:reset_vip

task eth_top_env :: reconfig_vip_for_lt_mode(speed_e speed = _25G, int inst = 0, int wait_timer=15);
   bit [31:0] c3_read_data;
   uvm_status_e      status;
   bit std_am = 0;

   reset_vip(inst);

   env_ip[inst].`MAC_CFG.enable_autoadaptation = 1;
   env_ip[inst].`MAC_CFG.autoadaptation_training_complete_count = 10;
   env_ip[inst].`MAC_CFG.autoadaptation_wait_timer = wait_timer;
   env_ip[inst].`MAC_CFG.autoadaptation_max_wait_timer = 90000000;

 if (((speed == _50G)  && (env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) ||  //GDR: ETH-10/15
          ((speed == _100G) && (env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) || //GDR: ETH-2
          ((speed == _100G) && (env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) || //GDR: ETH-14
          (speed == _200G) || //GDR: ETH-5/11
          (speed == _400G) )  //GDR: ETH-3/9/18
  begin
   env_ip[inst].`MAC_CFG.enable_autoadaptation_pam = 1;
   env_ip[inst].`MAC_CFG.enable_pam4 = 1;
   env_ip[inst].`MAC_CFG.enable_pam4_precoding = 0;
   env_ip[inst].`MAC_CFG.autoadaptation_modulation_and_precode_order[0] = svt_ethernet_enum_pkg::AUTOADAPTATION_PAM2;
   env_ip[inst].`MAC_CFG.autoadaptation_modulation_and_precode_order[1] = svt_ethernet_enum_pkg::AUTOADAPTATION_PAM4;
   env_ip[inst].`MAC_CFG.autoadaptation_modulation_and_precode_order[2] = svt_ethernet_enum_pkg::AUTOADAPTATION_BYPASS;
  end
   
   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      // Set <cfg>.interface_select
      // Set <cfg>.<fec>
      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      case (speed)
        _10G  : begin
                env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_XSBI_SERIAL;                                                    //GDR: ETH-12
                env_ip[inst].`MAC_CFG.enable_autoadaptation_cl93 = 0;
                end
        _25G  : begin
                env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_25G_SERIAL;                                                                      //GDR: ETH-1
                env_ip[inst].`MAC_CFG.enable_autoadaptation_cl93 = 1;
                env_ip[inst].`MAC_CFG.autoadaptation_cl93_prbs_lane[0]=0;
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type inside {RSFECKR,RSFECKP,LLFEC}) env_ip[inst].`MAC_CFG.enable_xxvsbi_lsbi_rs_fec = 1;                                                        //GDR: ETH-7
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == FCFEC) env_ip[inst].`MAC_CFG.enable_fec = 1;                                                                                            //GDR: ETH-17
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKP) env_ip[inst].`MAC_CFG.enable_kp4_rs_fec =1;
                end 
        _40G  : begin
                env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_XLSBI_SERIAL;                                                       //GDR: ETH-16
                env_ip[inst].`MAC_CFG.enable_autoadaptation_cl93 = 0;
                end
        _50G  : begin
                env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_50G_SERIAL;                                                                       //GDR: TBD
                if ((speed == _50G)  && (env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
                 env_ip[inst].`MAC_CFG.enable_autoadaptation_cl93 = 1;
                 env_ip[inst].`MAC_CFG.autoadaptation_cl93_prbs_lane[0]=0;
                end
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type inside {RSFECKR,RSFECKP,LLFEC}) env_ip[inst].`MAC_CFG.enable_xxvsbi_lsbi_rs_fec =1;                                                              //GDR: ETH-4
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKP) env_ip[inst].`MAC_CFG.enable_kp4_rs_fec =1;                                                       //GDR: ETH-10
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == LLFEC) env_ip[inst].`MAC_CFG.enable_ll_rs_fec =1;                                                                   //GDR: ETH-15
                end
        _100G : begin 
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == NOFEC) begin 
		     env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_CAUI_25X4;       //GDR: ETH-8
                end else if (env_ip[inst].dyn_rcfg_obj_inst.ch_num==1) begin //802.3ck interleaved fec
		     env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_100G_CK;
		end else begin
                     if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4) env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_CSBI_4_LANE;                   //GDR: ETH-13/14
                     if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2) env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_CSBI_4_LANE;                   //GDR: ETH-14
                     if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1) env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_CSBI_2_LANE;                   //GDR: ETH-2
                end
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type inside {RSFECKR,RSFECKP,LLFEC} && (env_ip[inst].dyn_rcfg_obj_inst.ch_num != 1)) env_ip[inst].`MAC_CFG.enable_rs_fec =1;                                                                                      //GDR: ETH-13
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKP) env_ip[inst].`MAC_CFG.enable_kp4_rs_fec =1;                                                                        //GDR: ETH-2
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == LLFEC) env_ip[inst].`MAC_CFG.enable_ll_rs_fec =1;    //GDR: ETH-14
                if ((speed == _100G) && (env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4)) begin//GDR: ETH-2
                       env_ip[inst].`MAC_CFG.enable_autoadaptation_cl93 = 1;
                       env_ip[inst].`MAC_CFG.autoadaptation_cl93_prbs_lane[0]=0;
                  end
                end
        _200G : begin
                if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4) env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_200G_SERIAL;                          //GDR: ETH-5
                if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2) env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_200G_SERIAL_4_LANE;   //GDR: ETH-11
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKP) env_ip[inst].`MAC_CFG.enable_kp4_rs_fec =1;                                                                        //GDR: ETH-11
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == LLFEC) env_ip[inst].`MAC_CFG.enable_ll_rs_fec =1;                                                                                   //GDR: ETH-5
                end
        _400G : begin
                if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 8) env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_400G_SERIAL;                         //GDR: ETH-9/18
                if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4) env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_400G_SERIAL_8_LANE;  //GDR: ETH-3
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKP) env_ip[inst].`MAC_CFG.enable_kp4_rs_fec =1;                                                                        //GDR: ETH-3/18
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == LLFEC) env_ip[inst].`MAC_CFG.enable_ll_rs_fec =1;                                                                                   //GDR: ETH-9
                end
        default: `uvm_fatal("SETUP_VIP_CFG", {"Speed is not defined, check gdr.csv"})
      endcase
   

      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      // Set <cfg>.<alignTimer>
      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      case (speed)
         
         _25G:    if(env_ip[inst].dyn_rcfg_obj_inst.fec_type inside {RSFECKR,RSFECKP,LLFEC}) begin
                        // 1280/(2*40) = 16 codewords    
                        env_ip[inst].`MAC_CFG.xxvsbi_rs_fec_mode_align_timer = std_am ? 1024 : 16;
                  end
         _40G  :  env_ip[inst].`MAC_CFG.xlsbi_40g_align_timer = std_am ? 16384 : 64;
         
         _50G:    
                    if(env_ip[inst].dyn_rcfg_obj_inst.fec_type inside {RSFECKR,RSFECKP,LLFEC}) begin
                      env_ip[inst].`MAC_CFG.lsbi_50g_align_timer = std_am ? 20480 : 320;
                    end
                    else begin
                      env_ip[inst].`MAC_CFG.lsbi_50g_align_timer = std_am ? 16384 : 256;
                    end
         _100G:
	            if (env_ip[inst].dyn_rcfg_obj_inst.ch_num==1) begin //802.3ck interleaved fec
                      env_ip[inst].`MAC_CFG.cgbi_rs_fec_mode_align_timer = 'd64;
                    end else if(env_ip[inst].dyn_rcfg_obj_inst.fec_type inside {RSFECKR,RSFECKP,LLFEC}) begin
                      env_ip[inst].`MAC_CFG.csbi_100g_align_timer = std_am ? 16384 : 256;
                    end
                    else begin
                      env_ip[inst].`MAC_CFG.csbi_100g_align_timer = std_am ? 16384 : 256;
                    end
         _200G: 
                     //5120/(2*40) = 64 codewords     
                     env_ip[inst].`MAC_CFG.ccbi_rs_fec_mode_align_timer = std_am ? 4096 : 64;
         _400G: 
                     //10240/(2*40) = 128 codewords      
                     env_ip[inst].`MAC_CFG.cdbi_rs_fec_mode_align_timer = std_am ? 8192 : 128;
      endcase

      
      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      // Set common cfgs
      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      if((env_ip[inst].dyn_rcfg_obj_inst.fec_type != NOFEC) && (speed != _100G) ) env_ip[inst].`MAC_CFG.enable_xxvsbi_lsbi_consortium_mode = 0; // ALEX: TODO why except 100G ?
      if((speed != _10G) && (speed != _25G) ) env_ip[inst].`MAC_CFG.mac_expected_minimum_ipg = 1;
      //if(env_ip[inst].`MAC_CFG.enable_pam4) env_ip[inst].`MAC_CFG.enable_pam4_gray_coding = 0;///1; // TODO Randomize ??
      env_ip[inst].`MAC_CFG.enable_mon_pkt_drop_on_framing_error=0;
      env_ip[inst].`MAC_CFG.enable_mon_pkt_retain_on_framing_error=1;
      env_ip[inst].`MAC_CFG.enable_vip_cdr = 1;  // TODO randomize ??
      env_ip[inst].`MAC_CFG.enable_mon_pkt_drop_on_framing_error = 0;
//      env_ip[inst].`MAC_CFG.disable_pause_mode = 1;
      env_ip[inst].`MAC_CFG.enable_mac_transaction_cov = 1; 
      env_ip[inst].`MAC_CFG.enable_detailed_transaction_print_tx = 1; 

      //ALEX : TODO Need to review following configuration
      env_ip[inst].`MAC_CFG.mac_address[0] = 48'h000000004455;   //ALEX : Need to check this configuration
      env_ip[inst].`MAC_CFG.disable_entry_to_fault_state = 1'b1;  //
      env_ip[inst].`MAC_CFG.enable_complete_data_frame_with_preamble_rx = 1; 
      env_ip[inst].`MAC_CFG.disable_pause_mode = 1;

      if (env_ip[inst].dyn_rcfg_obj_inst.mode==OTN) begin
	 env_ip[inst].`MAC_CFG.enable_complete_data_frame_with_preamble_rx = 1; 
	 env_ip[inst].`MAC_CFG.mac_expected_minimum_ipg = 1; 
	 env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_66B_MULTILANE_ENCODER;
	 env_ip[inst].`MAC_CFG.xsbi_scrambler_active = 1;//Set xsbi_scrambler/descrambler_active to 1 to enable scrambler(OTN mode)
	 env_ip[inst].`MAC_CFG.xsbi_descrambler_active = 1;
	 env_ip[inst].`MAC_CFG.csbi_100g_align_timer = 32'd64;
      end else if (env_ip[inst].dyn_rcfg_obj_inst.mode==FLEXE) begin
	 env_ip[inst].`MAC_CFG.enable_complete_data_frame_with_preamble_rx = 1; 
	 env_ip[inst].`MAC_CFG.mac_expected_minimum_ipg = 1; 
         env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_66B_MULTILANE_ENCODER;
         env_ip[inst].`MAC_CFG.xsbi_scrambler_active = 0;//Set xsbi_scrambler/descrambler_active to 0 to disable scrambler
         env_ip[inst].`MAC_CFG.xsbi_descrambler_active = 0;
         env_ip[inst].`MAC_CFG.csbi_100g_align_timer = 32'd64;
      end
	 
   `uvm_info("wait_for_lt_complete", $psprintf("reconfiguring VIP agent config for LT mode:\n",env_ip[inst].`MAC_CFG.print()), UVM_NONE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.reconfigure_via_task(env_ip[inst].`MAC_CFG);
endtask:reconfig_vip_for_lt_mode

task eth_top_env :: reconfig_vip_for_an_mode(speed_e speed = _25G, int inst = 0);
   reset_vip(inst);
   env_ip[inst].`MAC_CFG.interface_select = 1;
   `uvm_info(get_type_name(), $psprintf("reconfiguring VIP agent config for AN mode:\n",env_ip[inst].`MAC_CFG.print()), UVM_NONE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.reconfigure_via_task(env_ip[inst].`MAC_CFG);
endtask:reconfig_vip_for_an_mode

task eth_top_env :: reconfig_vip_for_datamode(speed_e speed = _25G, int inst = 0);
      bit std_am = 0;

      reset_vip(inst);

      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      // Set <cfg>.interface_select
      // Set <cfg>.<fec>
      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      case (speed)
        _10G  : env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_XSBI_SERIAL;                                                    //GDR: ETH-12
        _25G  : begin
                env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_25G_SERIAL;                                                                      //GDR: ETH-1
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type inside {RSFECKR,RSFECKP,LLFEC}) env_ip[inst].`MAC_CFG.enable_xxvsbi_lsbi_rs_fec = 1;                                                        //GDR: ETH-7
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == FCFEC) env_ip[inst].`MAC_CFG.enable_fec = 1;                                                                                            //GDR: ETH-17
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKP) env_ip[inst].`MAC_CFG.enable_kp4_rs_fec =1;
                end 
        _40G  : env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_XLSBI_SERIAL;                                                       //GDR: ETH-16
        _50G  : begin
                env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_50G_SERIAL;                                                                       //GDR: TBD
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type inside {RSFECKR,RSFECKP,LLFEC}) env_ip[inst].`MAC_CFG.enable_xxvsbi_lsbi_rs_fec =1;                                                              //GDR: ETH-4
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKP) env_ip[inst].`MAC_CFG.enable_kp4_rs_fec =1;                                                       //GDR: ETH-10
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == LLFEC) env_ip[inst].`MAC_CFG.enable_ll_rs_fec =1;                                                                   //GDR: ETH-15
                end
        _100G : begin 
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == NOFEC) begin
		     env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_CAUI_25X4;       //GDR: ETH-8
                end else if (env_ip[inst].dyn_rcfg_obj_inst.ch_num==1) begin //802.3ck interleaved fec
		     env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_100G_CK;
                end else begin
                     if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4) env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_CSBI_4_LANE;                   //GDR: ETH-13/14
                     if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2) env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_CSBI_4_LANE;                   //GDR: ETH-14
                     if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1) env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_CSBI_2_LANE;                   //GDR: ETH-2
                end
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type inside {RSFECKR,RSFECKP,LLFEC} && (env_ip[inst].dyn_rcfg_obj_inst.ch_num != 1)) env_ip[inst].`MAC_CFG.enable_rs_fec =1;                                                                                      //GDR: ETH-13
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKP) env_ip[inst].`MAC_CFG.enable_kp4_rs_fec =1;                                                                        //GDR: ETH-2
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == LLFEC) env_ip[inst].`MAC_CFG.enable_ll_rs_fec =1;                                                                                   //GDR: ETH-14
                end
        _200G : begin
                if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4) env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_200G_SERIAL;                          //GDR: ETH-5
                if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2) env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_200G_SERIAL_4_LANE;   //GDR: ETH-11
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKP) env_ip[inst].`MAC_CFG.enable_kp4_rs_fec =1;                                                                        //GDR: ETH-11
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == LLFEC) env_ip[inst].`MAC_CFG.enable_ll_rs_fec =1;                                                                                   //GDR: ETH-5
                end
        _400G : begin
                if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 8) env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_400G_SERIAL;                         //GDR: ETH-9/18
                if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4) env_ip[inst].`MAC_CFG.interface_select = svt_ethernet_enum_pkg::ETH_400G_SERIAL_8_LANE;  //GDR: ETH-3
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKP) env_ip[inst].`MAC_CFG.enable_kp4_rs_fec =1;                                                                        //GDR: ETH-3/18
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == LLFEC) env_ip[inst].`MAC_CFG.enable_ll_rs_fec =1;                                                                                   //GDR: ETH-9
                end
        default: `uvm_fatal("SETUP_VIP_CFG", {"Speed is not defined, check gdr.csv"})
      endcase

      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      // Set <cfg>.<PAM4>
      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      if (((speed == _50G)  && (env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) ||                                                        //GDR: ETH-10/15
          ((speed == _100G) && (env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) ||                                                        //GDR: ETH-2
          ((speed == _100G) && (env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) ||                                                        //GDR: ETH-14
          (speed == _200G) ||                                                                                                                               //GDR: ETH-5/11
          (speed == _400G) )                                                                                                                                  //GDR: ETH-3/9/18
      begin
        env_ip[inst].`MAC_CFG.enable_pam4 = 1;
        env_ip[inst].`MAC_CFG.enable_pam4_precoding = 0;
      end

      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      // Set <cfg>.<alignTimer>
      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      case (speed)
         
         _25G:    if(env_ip[inst].dyn_rcfg_obj_inst.fec_type inside {RSFECKR,RSFECKP,LLFEC}) begin
                        // 1280/(2*40) = 16 codewords    
                        env_ip[inst].`MAC_CFG.xxvsbi_rs_fec_mode_align_timer = std_am ? 1024 : 16;
                  end
         _40G  :  env_ip[inst].`MAC_CFG.xlsbi_40g_align_timer = std_am ? 16384 : 64;
         
         _50G:    
                    if(env_ip[inst].dyn_rcfg_obj_inst.fec_type inside {RSFECKR,RSFECKP,LLFEC}) begin
                      env_ip[inst].`MAC_CFG.lsbi_50g_align_timer = std_am ? 20480 : 320;
                    end
                    else begin
                      env_ip[inst].`MAC_CFG.lsbi_50g_align_timer = std_am ? 16384 : 256;
                    end
         _100G: 
	            if (env_ip[inst].dyn_rcfg_obj_inst.ch_num==1) begin //802.3ck interleaved fec
                      env_ip[inst].`MAC_CFG.cgbi_rs_fec_mode_align_timer = 'd64;
                    end else if(env_ip[inst].dyn_rcfg_obj_inst.fec_type inside {RSFECKR,RSFECKP,LLFEC}) begin
                      env_ip[inst].`MAC_CFG.csbi_100g_align_timer = std_am ? 16384 : 256;
                    end
                    else begin
                      env_ip[inst].`MAC_CFG.csbi_100g_align_timer = std_am ? 16384 : 256;
                    end
         _200G:  
                     //5120/(2*40) = 64 codewords     
                     env_ip[inst].`MAC_CFG.ccbi_rs_fec_mode_align_timer = std_am ? 4096 : 64;
         _400G: 
                     //10240/(2*40) = 128 codewords      
                     env_ip[inst].`MAC_CFG.cdbi_rs_fec_mode_align_timer = std_am ? 8192 : 128;
      endcase

      
      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      // Set common cfgs
      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      if((env_ip[inst].dyn_rcfg_obj_inst.fec_type != NOFEC) && (speed != _100G) ) env_ip[inst].`MAC_CFG.enable_xxvsbi_lsbi_consortium_mode = 0; // ALEX: TODO why except 100G ?
      if((speed != _10G) && (speed != _25G) ) env_ip[inst].`MAC_CFG.mac_expected_minimum_ipg = 1;
      //if(env_ip[inst].`MAC_CFG.enable_pam4) env_ip[inst].`MAC_CFG.enable_pam4_gray_coding = 0;///1; // TODO Randomize ??
      env_ip[inst].`MAC_CFG.enable_mon_pkt_drop_on_framing_error=0;
      env_ip[inst].`MAC_CFG.enable_mon_pkt_retain_on_framing_error=1;
      env_ip[inst].`MAC_CFG.enable_vip_cdr = 1;  // TODO randomize ??
      env_ip[inst].`MAC_CFG.enable_mon_pkt_drop_on_framing_error = 0;
//      env_ip[inst].`MAC_CFG.disable_pause_mode = 1;
      env_ip[inst].`MAC_CFG.enable_mac_transaction_cov = 1; 
      env_ip[inst].`MAC_CFG.enable_detailed_transaction_print_tx = 1; 

      //ALEX : TODO Need to review following configuration
      env_ip[inst].`MAC_CFG.mac_address[0] = 48'h000000004455;   //ALEX : Need to check this configuration
      env_ip[inst].`MAC_CFG.disable_entry_to_fault_state = 1'b1;  //
      env_ip[inst].`MAC_CFG.enable_complete_data_frame_with_preamble_rx = 1; 
      env_ip[inst].`MAC_CFG.disable_pause_mode = 1;

      if (env_ip[inst].dyn_rcfg_obj_inst.mode==OTN) begin
	 env_ip[inst].`MAC_CFG.enable_complete_data_frame_with_preamble_rx = 1; 
	 env_ip[inst].`MAC_CFG.mac_expected_minimum_ipg = 1; 
	 env_ip[inst].`MAC_CFG.interface_select=svt_ethernet_enum_pkg::ETH_66B_MULTILANE_ENCODER; 
	 env_ip[inst].`MAC_CFG.xsbi_scrambler_active = 1;//Set xsbi_scrambler/descrambler_active to 1 to enable scrambler(OTN mode)
	 env_ip[inst].`MAC_CFG.xsbi_descrambler_active = 1;
	 env_ip[inst].`MAC_CFG.csbi_100g_align_timer = 32'd64;
      end else if (env_ip[inst].dyn_rcfg_obj_inst.mode==FLEXE) begin
	 env_ip[inst].`MAC_CFG.enable_complete_data_frame_with_preamble_rx = 1; 
	 env_ip[inst].`MAC_CFG.mac_expected_minimum_ipg = 1; 
	 env_ip[inst].`MAC_CFG.interface_select =svt_ethernet_enum_pkg::ETH_66B_MULTILANE_ENCODER; 
	 env_ip[inst].`MAC_CFG.xsbi_scrambler_active = 0;//Set xsbi_scrambler/descrambler_active to 0 to disable scrambler
	 env_ip[inst].`MAC_CFG.xsbi_descrambler_active = 0;
	 env_ip[inst].`MAC_CFG.csbi_100g_align_timer = 32'd64;
      end

      env_ip[inst].`MAC_CFG.enable_autoadaptation = 0;
      env_ip[inst].`MAC_CFG.enable_autoadaptation_pam = 0;
      
      `uvm_info("reconfig_vip_for_datamode", $psprintf("reconfiguring VIP agent for data xfer",env_ip[inst].`MAC_CFG.print()), UVM_NONE);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.reconfigure_via_task(env_ip[inst].`MAC_CFG);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_csbi_am_not_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
      

endtask:reconfig_vip_for_datamode

task eth_top_env :: reconfig_vip_for_consortium_mode(speed_e speed = _25G, int inst = 0);
   env_ip[inst].`MAC_CFG.enable_xxvsbi_lsbi_consortium_mode = 1;
   `uvm_info(get_type_name(), $psprintf("reconfiguring VIP agent config for consortium:\n",env_ip[inst].`MAC_CFG.print()), UVM_NONE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.reconfigure_via_task(env_ip[inst].`MAC_CFG);
endtask:reconfig_vip_for_consortium_mode

function bit [17:0] eth_top_env::get_neg_port(speed_e speed = _25G, int inst = 0, anlt_std_e anlt_std = IEEE);
  case(speed)
    _10G: get_neg_port = 18'h1;
    _25G: begin
           if(anlt_std inside {IEEE,IEEE_CONSORTIUM}) begin
             if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKR)
               get_neg_port = 18'h40;
             else if(env_ip[inst].dyn_rcfg_obj_inst.fec_type inside {NOFEC,FCFEC})
               get_neg_port = 18'h20;
           end
           else if(anlt_std == CONSORTIUM) begin
             if(env_ip[inst].dyn_rcfg_obj_inst.cr_mode == 1)
               get_neg_port = 18'h2000;
             else
              get_neg_port = 18'h1000;
           end
          end
    _40G: begin
           if(env_ip[inst].dyn_rcfg_obj_inst.cr_mode == 1)
             get_neg_port = 18'h4;
           else
             get_neg_port = 18'h2;
          end          
    _50G: begin
           if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1) begin
             get_neg_port = 18'h80;
           end
           else if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2) begin
             if(env_ip[inst].dyn_rcfg_obj_inst.cr_mode == 1)
               get_neg_port = 18'h8000;
             else
               get_neg_port = 18'h4000;
           end
          end
     _100G: begin
             if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)
               get_neg_port = 18'h400;
             else if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)
               get_neg_port = 18'h100;
             else if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4)
               if(env_ip[inst].dyn_rcfg_obj_inst.cr_mode == 1)
                get_neg_port = 18'h10;
              else
                get_neg_port = 18'h8;  
            end           
     _200G: begin
             if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)
              get_neg_port = 18'h800;
             else if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4)
              get_neg_port = 18'h200;
            end
     _400G: begin
             if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4)
               get_neg_port = 18'h20000;
             else if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 8)
               get_neg_port = 18'h10000;
            end
  endcase
  endfunction:get_neg_port

  function bit [24:0] eth_top_env::get_tech_ability(speed_e speed = _25G, int inst = 0, anlt_std_e anlt_std = IEEE);
    if(anlt_std inside {IEEE,IEEE_CONSORTIUM}) begin
      case(speed)
        _10G:  get_tech_ability = 25'h4;
          _25G:  begin
                  if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKR) 
                    get_tech_ability = 25'h400;
                  else if(env_ip[inst].dyn_rcfg_obj_inst.fec_type inside {NOFEC,FCFEC})
                    get_tech_ability = 25'h200;
                 end
          _40G:  begin
                  if(env_ip[inst].dyn_rcfg_obj_inst.cr_mode == 1)
                    get_tech_ability = 25'h10;
                  else
                    get_tech_ability = 25'h8;
                 end
          _50G:  begin
                  if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)
                    get_tech_ability = 25'h2000;
                 end
          _100G: begin
                  if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)
                    get_tech_ability = 25'h10000;
                  else if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)
                    get_tech_ability = 25'h4000;
                  else if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4)
                    if(env_ip[inst].dyn_rcfg_obj_inst.cr_mode == 1)
                     get_tech_ability = 25'h100;
                    else
                     get_tech_ability = 25'h80;
                 end
          _200G: begin
                  if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)
                    get_tech_ability = 25'h20000;
                  else if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4)
                    get_tech_ability = 25'h8000;
                 end
          _400G: begin
                  if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4)
                    get_tech_ability = 25'h40000; 
                 end
      endcase
    end
    else if(anlt_std == CONSORTIUM) begin
      case(speed)
        _25G: begin
               if(env_ip[inst].dyn_rcfg_obj_inst.cr_mode == 1)
                 get_tech_ability = 25'h20;
               else
                 get_tech_ability = 25'h10;
              end
        _50G: begin
               if(env_ip[inst].dyn_rcfg_obj_inst.cr_mode == 1)
                 get_tech_ability = 25'h200;
               else
                 get_tech_ability = 25'h100;
              end
       _400G: begin
               if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 8)
                 get_tech_ability = 25'h40000;
              end
      endcase
    end
  endfunction:get_tech_ability

task eth_top_env :: check_base_page(speed_e speed = _25G, int node = 0, int inst = 0, bit [47:0] vip_page_received, anlt_std_e anlt_std = IEEE);
   string func_name = "check_base_page"; 
   uvm_reg_data_t read_data;  
   uvm_status_e      status;
   uvm_reg_data_t c3_data;
   uvm_reg_data_t c4_data;
   uvm_reg_data_t c5_data;
   bit [4:0]  fec_req;
   bit an_param_ovr=0;
   bit an_usr_bp=0;
   bit an_np_ctrl=0;
   bit an_rf=0;   
      
   gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_cfg1")),.read_data(read_data),.speed(speed)); 
   an_param_ovr = read_data[5];
   an_usr_bp = read_data[1];
   an_np_ctrl = read_data[2];
   an_rf = read_data[3];

      if (an_param_ovr && !an_usr_bp) begin
         gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_cfg3")),.read_data(c3_data),.speed(speed)); 
         gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_cfg4")),.read_data(c4_data),.speed(speed)); 
         gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_cfg3")),.read_data(c5_data),.speed(speed)); 
	 if (vip_page_received[12:10] != c3_data[30:28]
	     || vip_page_received[13] != an_rf
	     || vip_page_received[42:21] != c4_data[29:5]
	     || vip_page_received[47:46] != c3_data[25:24] //Revisit:vinoth2x - check the FEC bits
	     ) begin
	    `uvm_error(get_type_name(), $sformatf("%s: Page sent to VIP has incorrect fields. \nExpected: Pause Ability=%0x, RF=%0x, Tech ability=%0x, FEC=%0x \nActual: Pause Ability=%0x, RF=%0x, Tech ability=%0x, FEC=%0x",func_name, c3_data[30:28],an_rf,c4_data[29:5],c3_data[25:24],vip_page_received[12:10],vip_page_received[13],vip_page_received[42:21],vip_page_received[47:46]));
	 end		  
      end else if (an_usr_bp) begin
         gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_cfg3")),.read_data(c3_data),.speed(speed)); 
         gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_cfg4")),.read_data(c4_data),.speed(speed)); 
	 if (vip_page_received[12:10] != c3_data[12:10]
	     || vip_page_received[13] != c3_data[13]
	     || vip_page_received[42:21] != c4_data[29:5]
	     || vip_page_received[47:46] != c4_data[31:30] //Revisit:vinoth2x - check the FEC bits
	     ) begin
	    `uvm_error(get_type_name(), $sformatf("%s: Page sent to VIP has incorrect fields. \nExpected: Pause Ability=%0x, RF=%0x, Tech ability=%0x, FEC=%0x \nActual: Pause Ability=%0x, RF=%0x, Tech ability=%0x, FEC=%0x",func_name,c3_data[12:10],c3_data[13],c4_data[29:5],c4_data[31:30],vip_page_received[12:10],vip_page_received[13],vip_page_received[42:21],vip_page_received[47:46]));
	 end		  
      end else begin // if (an_usr_bp)
        if(env_ip[inst].dyn_rcfg_obj_inst.speed == _25G) begin
          if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKR && vip_page_received[44])
            fec_req = 5'b00010;
          else if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == FCFEC && vip_page_received[45])
            fec_req = 5'b00100;
        end
        else if(env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) begin
          if(env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1 && vip_page_received[43])
            fec_req = 5'b00001;
        end
        else
          fec_req = 5'b0;
          
        if(vip_page_received[4:0] != 5'b1 ||
          vip_page_received[12:10] != env_ip[inst].dyn_rcfg_obj_inst.anpause ||
          vip_page_received[13] != an_rf ||
          ((anlt_std != CONSORTIUM) && (vip_page_received[42:21] != get_tech_ability(speed,inst,anlt_std))) || 
          ((anlt_std == IEEE) && (vip_page_received[47:43] != fec_req)))
          `uvm_error(get_type_name(), $sformatf("%s: Page sent to VIP has incorrect fields. \nEXP selector=%0x, ACT selector=%0x , \nEXP pause=%0x, ACT pause=%0x, \nEXP rf=%0x, ACT rf=%0x, \nEXP tech ability=%0x, ACT tech ability=%0x, \nEXP fec=%0x, ACT=%0x",func_name,5'b1,vip_page_received[4:0],env_ip[inst].dyn_rcfg_obj_inst.anpause,vip_page_received[12:10],an_rf,vip_page_received[13],get_tech_ability(speed,inst,anlt_std),vip_page_received[42:21],fec_req,vip_page_received[47:43]));
      end
endtask:check_base_page

task eth_top_env :: nonce_possibility(speed_e speed = _25G, int inst = 0, bit allow_enable_errors=1); 
  string func_name = "nonce_possibility";
   bit 	  nonce_match=1;
   time   start_time;
   bit 	  select=0;
   `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_HIGH);
   while (nonce_match) begin
      if (!select) begin
	 @(env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_dme_page_received===1'b0);
	 @(env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_dme_page_received===1'b1);
      end else begin
	 @(env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_dme_page_transmitted===1'b0);
	 @(env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_dme_page_transmitted===1'b1);
      end
      // Detect Nonce match
      if((env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_48b_linkword_ip[20:16]==env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_48b_linkword_op[20:16])& (!select)) begin
	 `uvm_info(get_type_name(), $sformatf("%s: Nonce match detected",func_name), UVM_NONE);
   	 disable_an_snps_errors();
	 select=1;
       // Case of no nonce match
      end else if(env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_48b_linkword_ip[20:16]!=env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_48b_linkword_op[20:16]
		  && !select
		  )  begin
	 nonce_match=0;
      // Enable back errors after nonce match resolved
      end else if (select) begin
	 fork begin
	    // Wait for TX disable
	    fork : wait_tx_disable
	       begin
	       	  while (1) begin
	       	     start_time = $time;
                     if(env_ip[inst].spy_if.an_chan == 0)
                        @ (env_ip[inst].spy_if.tx_serial[0]);
                     else if(env_ip[inst].spy_if.an_chan == 1)
                        @ (env_ip[inst].spy_if.tx_serial[1]);
                     else if(env_ip[inst].spy_if.an_chan == 2)
                        @ (env_ip[inst].spy_if.tx_serial[2]);
                     else if(env_ip[inst].spy_if.an_chan == 3)
                        @ (env_ip[inst].spy_if.tx_serial[3]);
                     else if(env_ip[inst].spy_if.an_chan == 4)
                        @ (env_ip[inst].spy_if.tx_serial[4]);
                     else if(env_ip[inst].spy_if.an_chan == 5)
                        @ (env_ip[inst].spy_if.tx_serial[5]);
                     else if(env_ip[inst].spy_if.an_chan == 6)
                        @ (env_ip[inst].spy_if.tx_serial[6]);
                     else if(env_ip[inst].spy_if.an_chan == 7)
                        @ (env_ip[inst].spy_if.tx_serial[7]);
	       	  end
	       end
	       begin
	       	  while (1) begin
	       	     if (($time-start_time)>1us) begin
	       		`uvm_info(get_type_name(), $sformatf("TX Disable entered"), UVM_LOW);
	       		disable wait_tx_disable;
	       	     end
	       	     #1ns;
	       	  end
	       end
	    join
            wait(env_ip[inst].spy_if.debug_signal  == 'hB0);
	    if (allow_enable_errors)
	      enable_an_snps_errors();
	 end
	 join_none
	 nonce_match=0;
      end // if (select)
   end // while (nonce_match)
   `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_HIGH); 
endtask :nonce_possibility
	  

task eth_top_env :: wait_for_an_complete(speed_e speed = _25G, int node = 0, int inst = 0, anlt_std_e anlt_std = IEEE);
   string func_name = "wait_for_an_complete";
   uvm_reg_data_t read_data;
   uvm_status_e      status;
   bit an_en=0;
   bit an_timeout_en;
   bit [47:0] vip_page_sent;
   bit [47:0] vip_page_received;
   bit [31:0] exp_an_status;
   uvm_reg_data_t c7_data;
   uvm_reg_data_t c8_data;
   uvm_reg_data_t cb_data;
   bit [31:0] ce_data;
   bit ll_fec_neg;
   bit rs_fec_neg;
   bit[17:0] neg_port;
   bit neg_fail;
   bit consortium_np_rcvd;
   bit an_fail;
   bit baser_fec_neg_en;
   bit an_lp_ability = 1;
   bit an_status;
   bit an_ability = 1;
   bit an_adv_rf;
   bit an_complete = 1;
   bit an_page_rcvd = 1;
   bit[47:0] vip_consortium_page_rcvd; 
   bit[47:0] vip_consortium_page_sent; 
   
   // Read config reg values
   // AN enable
   `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW);

   gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_cfg1")),.read_data(read_data),.speed(speed)); 
   an_en = read_data[0];
   if (an_en) begin
      `uvm_info(get_type_name(), $sformatf("%s: AN Enabled",func_name), UVM_LOW);
      fork : wait_seq_an
	 begin
	    wait (env_ip[inst].spy_if.seq_mode==6'h01);
	    disable wait_seq_an;
	 end 
	 begin
	    #800us;
	    `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting for SEQ mode",func_name));
	 end
      join
      enable_an_snps_errors(speed,inst);
      gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"seq_status")),.read_data(read_data),.speed(speed)); 
      // Read twice because B1.1,2 is latch high
      gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"seq_status")),.read_data(read_data),.speed(speed)); 
      if(read_data[15:8] != 'h01)  
	`uvm_error(get_type_name(), $sformatf("%s: SEQ recofig mode is incorrect. EXP='h01, ACT=%0x",func_name,read_data[15:8]));
      // Wait for AN complete
      fork : wait_an_complete
	 begin
	    wait (env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state == svt_ethernet_enum_pkg::AN73_ARBITER_STATE_COMPLETE_ACKNOWLEDGEMENT);	    
            vip_page_received = env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_48b_linkword_ip;
	    `uvm_info(get_name(), $sformatf("%s: Base page received by VIP = %0x",func_name,vip_page_received), UVM_LOW);
	    vip_page_sent = env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_48b_linkword_op;
	    `uvm_info(get_name(), $sformatf("%s: Base page sent by VIP = %0x",func_name,vip_page_sent), UVM_LOW);
            if(anlt_std inside {CONSORTIUM,IEEE_CONSORTIUM}) begin
              consortium_np_rcvd = 1;
              wait(env_ip[inst].spy_if.debug_signal  == 'h130);
              `uvm_info(get_name(), $sformatf("%s: DUT moved to next page wait first time",func_name), UVM_NONE);
              wait(env_ip[inst].spy_if.debug_signal  == 'h120);
	      vip_consortium_page_sent = env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_48b_linkword_op[47:0];
	      `uvm_info(get_name(), $sformatf("%s: Consortium page sent by VIP = %0x",func_name,vip_consortium_page_sent), UVM_LOW);
              wait(env_ip[inst].spy_if.debug_signal  == 'h130);
              vip_consortium_page_rcvd = env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_48b_linkword_ip[47:0];
	      `uvm_info(get_name(), $sformatf("%s: Consortium page received by VIP = %0x",func_name,vip_consortium_page_rcvd), UVM_LOW);
            end

	    disable_an_snps_errors(speed,inst);
	    env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.EVENT_AN73_COMPLETE.wait_trigger();
	    `uvm_info(get_name(), $sformatf("%s: AN  is up from VIP side",func_name), UVM_NONE);
	     wait (env_ip[inst].spy_if.an_done==1'b1);
	    `uvm_info(get_name(), $sformatf("%s: AN  is up from DUT side",func_name), UVM_NONE);

            if(anlt_std == IEEE) begin
              if(speed == _25G) begin
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKR && (vip_page_received[44] || vip_page_sent[44]))
                  rs_fec_neg = 1;
                else if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == FCFEC && (vip_page_received[45] || vip_page_sent[45]))
                  baser_fec_neg_en = 1;
              end
              else if(speed == _100G && env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)
                rs_fec_neg = 1;
            end
            else if(anlt_std == CONSORTIUM) begin
              if(speed == _25G) begin
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKR && vip_consortium_page_rcvd[40] && vip_consortium_page_sent[40] && (vip_consortium_page_rcvd[42] || vip_consortium_page_sent[42]))
                  rs_fec_neg = 1;
                else if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == FCFEC && vip_consortium_page_rcvd[41] && vip_consortium_page_sent[41] && (vip_consortium_page_rcvd[43] || vip_consortium_page_sent[43]))
                  baser_fec_neg_en = 1;
              end
              else if(speed == _50G) begin
                if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKR && vip_consortium_page_rcvd[40] && vip_consortium_page_sent[40] && (vip_consortium_page_rcvd[42] || vip_consortium_page_sent[42]))
                  rs_fec_neg = 1;
              end
            end
            else if(anlt_std == IEEE_CONSORTIUM) begin
              if(((speed == _50G && env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1) && (vip_consortium_page_rcvd[37] && vip_consortium_page_sent[37]) && (vip_consortium_page_rcvd[44] || vip_consortium_page_sent[44])) ||
                 ((speed == _100G && env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2) && (vip_consortium_page_rcvd[38] && vip_consortium_page_sent[38]) && (vip_consortium_page_rcvd[44] || vip_consortium_page_sent[44])) ||
                 ((speed == _200G && env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4) && (vip_consortium_page_rcvd[39] && vip_consortium_page_sent[39]) && (vip_consortium_page_rcvd[44] || vip_consortium_page_sent[44]))) 
                 ll_fec_neg = 1;
                 else 
                   rs_fec_neg = 1;
             end

            neg_port = get_neg_port(speed,inst,anlt_std);
            gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_cfg1")),.read_data(read_data),.speed(speed)); 
            an_adv_rf = read_data[3];
            exp_an_status = {ll_fec_neg,rs_fec_neg,neg_port[17],neg_port[16:12],neg_port[11:0],neg_fail,consortium_np_rcvd,an_fail,baser_fec_neg_en,an_lp_ability,an_status,an_ability,1'b0,an_adv_rf,an_complete,an_page_rcvd,1'b0};
	    
            gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_status")),.read_data(read_data),.speed(speed)); 
            `uvm_info(get_name(), $sformatf("%s: AN  STATUS register read data :%0h",func_name,read_data), UVM_NONE);
            if(read_data[29:9] != exp_an_status[29:9] ||
               read_data[7:0] != exp_an_status[7:0]) //Revisit:vinoth2x - Fix FEC negotiated bit in slave mode
	      `uvm_error(get_type_name(), $sformatf("%s: AN  STATUS read data is incorrect. EXP=%0x, ACT=%0x",func_name,exp_an_status,read_data));//need to update for rsfec support
	    check_base_page(speed,node,inst,vip_page_received,anlt_std);
            if((anlt_std == CONSORTIUM) && (vip_consortium_page_rcvd[34:16] != get_tech_ability(speed,inst,anlt_std))) 
              `uvm_error(get_type_name(), $sformatf("%s: Consortium tech sent to VIP is incorrect \nEXP tech ability=%0x, ACT tech ability=%0x",func_name,get_tech_ability(speed,inst,anlt_std),vip_consortium_page_rcvd[34:16]));
	    // Check frame received
            gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_status1")),.read_data(c7_data),.speed(speed)); 
            gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_status2")),.read_data(c8_data),.speed(speed)); 
	    if ((c7_data[4:0] != vip_page_sent[4:0]) // selector
		|| (c7_data[9:5] != vip_page_sent[9:5]) // enonce
		|| (c7_data[12:10] != vip_page_sent[12:10]) // pause
		|| (c7_data[13] != vip_page_sent[13]) // rf
		|| (c7_data[15] != vip_page_sent[15]) // np
		|| (c8_data[4:0] != vip_page_sent[20:16]) // tnonce
		|| ((anlt_std != CONSORTIUM) && (c8_data[26:5] != vip_page_sent[42:21])) // tech ability
        //|| (c8_data[31:27] != vip_page_sent[47:43]) // REvisit:: fec bit disable comparsion
        )
	      `uvm_error(get_type_name(), $sformatf("%s: Page received from VIP incorrect.\nEXP selector=%0x, ACT selector=%0x \nEXP enonce=%0x, ACT enonce=%0x, \nEXP pause=%0x, ACT pause=%0x, \nEXP rf=%0x, ACT rf=%0x, \nEXP np=%0x, ACT np=%0x, \nEXP tnonce=%0x, ACT tnonce=%0x, \nEXP tech ability=%0x, ACT tech ability=%0x, \nEXP fec=%0x, ACT=%0x",func_name,vip_page_sent[4:0],c7_data[4:0],vip_page_sent[9:5],c7_data[9:5],vip_page_sent[12:10],c7_data[12:10],vip_page_sent[13],c7_data[13],vip_page_sent[15],c7_data[15],vip_page_sent[20:16],c8_data[4:0],vip_page_sent[42:21],c8_data[26:5],vip_page_sent[47:43],c8_data[31:27]));

             /* gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_status6")),.read_data(ce_data),.speed(speed)); :: Revisit:: Aditya: HSD::16013345640--In a latest regmap an_status6 entire register 0xCE is reserved 
              if((anlt_std == CONSORTIUM) && ((ce_data[8:0] != vip_consortium_page_sent[8:0]) || (ce_data[18:13] != vip_consortium_page_sent[26:20]))) //Revisit:vinoth2x - check the register field for 400G_8
                `uvm_error(get_type_name(), $sformatf("%s: Consortium tech received from VIP is incorrect \nEXP Extend tech ability=%0x, ACT Extend tech ability=%0x\nEXP tech ability=%0x, ACT tech ability=%0x",func_name,vip_consortium_page_sent[8:0],ce_data[8:0],vip_consortium_page_sent[26:20],ce_data[18:13]));*/

	    disable wait_an_complete;
	 end
	 begin
            #2000us;
	    `uvm_fatal(get_type_name(), $sformatf("%s: AN timeout",func_name));
	    disable wait_an_complete;
	 end
      join
   end else // block: wait_seq_an
     `uvm_info(get_type_name(), $sformatf("%s: AN Disabled",func_name), UVM_LOW);
     
   `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW);
endtask:wait_for_an_complete

task eth_top_env :: wait_for_lt_complete(speed_e speed = _25G, int node = 0, int inst = 0, bit skip_c3_delay=1'b0, bit skip_reconfig=1'b0);
   string func_name = "wait_for_lt_complete";
   uvm_reg_data_t read_data,lt_cfg;
   bit lt_en=0,lt_timeout_en=0;
   bit max_disable_timer=0;
   bit [31:0] lane_status;
   bit [31:0] exp_lane_status;
   bit max_timeout_expire;
   uvm_status_e      status;
   bit [31:0] c3_read_data;
   event ev_lt_lane_up;
   bit [7:0] vip_lt_done;
   `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW);

   gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"lt_cfg1")),.read_data(read_data),.speed(speed)); 
   lt_en = read_data[0];//LT Enable
   `uvm_info(get_name(), $sformatf("%s: LT CFG(add :0xd0) register read data :%0h",func_name,read_data), UVM_NONE);


   if (lt_en) begin

         #125us;
         enable_lt_snps_errors(speed,inst);

         if (env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1) begin
	   exp_lane_status = 'h1;
         end else if (env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2) begin
	   exp_lane_status = 'h11;
         end else if (env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4) begin
	   exp_lane_status = 'h11_11;
         end else if (env_ip[inst].dyn_rcfg_obj_inst.ch_num == 8) begin
	   exp_lane_status = 'h11_11_11_11;
	 end


      if (!skip_reconfig)
      reconfig_vip_for_lt_mode(speed,inst);
      // Wait for SEQ AN mode
      fork : wait_seq_lt
	 begin
	     wait(env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.status_rx.autoadaptation_training_state_lane0 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
             vip_lt_done[0] = 1'b1;
            `uvm_info("wait_for_lt_complete", $psprintf("lane 0 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	     wait(env_ip[inst].spy_if.lt_trained[0] && !env_ip[inst].spy_if.lt_training[0]);
	    `uvm_info("wait_for_lt_complete", $sformatf("DUT lane 0 trained"), UVM_NONE);
	    lane_status[0] = 1'b1;
	    -> ev_lt_lane_up;
	 end	 
	 begin
	    if (env_ip[inst].dyn_rcfg_obj_inst.ch_num > 1) begin
	       wait(env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.status_rx.autoadaptation_training_state_lane1 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
               vip_lt_done[1] = 1'b1;
              `uvm_info("wait_for_lt_complete", $psprintf("lane 1 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	       wait(env_ip[inst].spy_if.lt_trained[1] && !env_ip[inst].spy_if.lt_training[1]);
	      `uvm_info("wait_for_lt_complete", $sformatf("DUT lane 1 trained"), UVM_NONE);
	      lane_status[4] = 1'b1;
	      -> ev_lt_lane_up;
	    end
	 end
	 begin
	    if (env_ip[inst].dyn_rcfg_obj_inst.ch_num > 2) begin
	       wait(env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.status_rx.autoadaptation_training_state_lane2 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
               vip_lt_done[2] = 1'b1;
              `uvm_info("wait_for_lt_complete", $psprintf("lane 2 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	      wait(env_ip[inst].spy_if.lt_trained[2] && !env_ip[inst].spy_if.lt_training[2]);
	      `uvm_info("wait_for_lt_complete", $sformatf("DUT lane 2 trained"), UVM_NONE);
	      lane_status[8] = 1'b1;
	      -> ev_lt_lane_up;
	    end
	 end	    
	 begin
	    if (env_ip[inst].dyn_rcfg_obj_inst.ch_num > 2) begin
	       wait(env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.status_rx.autoadaptation_training_state_lane3 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
               vip_lt_done[3] = 1'b1;
              `uvm_info("wait_for_lt_complete", $psprintf("lane 3 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	      wait(env_ip[inst].spy_if.lt_trained[3] && !env_ip[inst].spy_if.lt_training[3]);
	      `uvm_info("wait_for_lt_complete", $sformatf("DUT lane 3 trained"), UVM_NONE);
	      lane_status[12] = 1'b1;
	      -> ev_lt_lane_up;
	    end
	 end 
	 begin
	    if (env_ip[inst].dyn_rcfg_obj_inst.ch_num > 4) begin
	        wait(env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.status_rx.autoadaptation_training_state_lane4 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
                vip_lt_done[4] = 1'b1;
               `uvm_info("wait_for_lt_complete", $psprintf("lane 4 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	       wait(env_ip[inst].spy_if.lt_trained[4] && !env_ip[inst].spy_if.lt_training[4]);
	       `uvm_info("wait_for_lt_complete", $sformatf("DUT lane 4 trained"), UVM_NONE);
	       lane_status[16] = 1'b1;
	       -> ev_lt_lane_up;
	    end
	 end
	  begin
	    if (env_ip[inst].dyn_rcfg_obj_inst.ch_num > 4) begin
	       wait(env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.status_rx.autoadaptation_training_state_lane5 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
               vip_lt_done[5] = 1'b1;
              `uvm_info("wait_for_lt_complete", $psprintf("lane 5 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	      wait(env_ip[inst].spy_if.lt_trained[5] && !env_ip[inst].spy_if.lt_training[5]);
	      `uvm_info("wait_for_lt_complete", $sformatf("DUT lane 5 trained"), UVM_NONE);
	      lane_status[20] = 1'b1;
	      -> ev_lt_lane_up;
	    end
	 end
	  begin
	    if (env_ip[inst].dyn_rcfg_obj_inst.ch_num > 4) begin
	       wait(env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.status_rx.autoadaptation_training_state_lane6 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
               vip_lt_done[6] = 1'b1;
              `uvm_info("wait_for_lt_complete", $psprintf("lane 6 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	      wait(env_ip[inst].spy_if.lt_trained[6] && !env_ip[inst].spy_if.lt_training[6]);
	      `uvm_info("wait_for_lt_complete", $sformatf("DUT lane 6 trained"), UVM_NONE);
	      lane_status[24] = 1'b1;
	      -> ev_lt_lane_up;
	    end
	 end
	  begin
	    if (env_ip[inst].dyn_rcfg_obj_inst.ch_num > 4) begin
	       wait(env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.status_rx.autoadaptation_training_state_lane7 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
               vip_lt_done[7] = 1'b1;
              `uvm_info("wait_for_lt_complete", $psprintf("lane 7 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	      wait(env_ip[inst].spy_if.lt_trained[7] && !env_ip[inst].spy_if.lt_training[7]);
	      `uvm_info("wait_for_lt_complete", $sformatf("DUT lane 7 trained"), UVM_NONE);
	      lane_status[28] = 1'b1;
	      -> ev_lt_lane_up;
	    end
	 end
         begin
	    #4ms;
	    `uvm_error(get_type_name(), $sformatf("%s: LT timeout",func_name)); 

           gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"lt_status1")),.read_data(read_data),.speed(speed)); 
           `uvm_info(get_name(), $sformatf("%s: LT STATUS register read data :%0h",func_name,read_data), UVM_NONE);
           if(read_data != 'h0808_0808) `uvm_error(get_type_name(), $sformatf("%s: LT STATUS(addr : 0xd2) data is  incorrect ",func_name)); 

	   max_timeout_expire = 1;
           `uvm_error(get_type_name(), $sformatf("%s: LT timed out ",func_name))
          disable wait_seq_lt; 

	 end
	 begin
	    forever
	      begin
		  @(ev_lt_lane_up);
                   disable_lt_snps_errors(speed,inst);
		 `uvm_info(get_type_name(), $sformatf("%s: lane_status =%0h exp_lane_status =%0h",func_name,lane_status,exp_lane_status), UVM_LOW);
                  gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"seq_status")),.read_data(read_data),.speed(speed)); 
		 `uvm_info(get_name(), $sformatf("%s: AN SEQ STATUS register read data :%0h",func_name,read_data), UVM_NONE);
		 //Ram this is Late check. by this time DUT chnage mode from
		 //LT to Data. 
		 //if(read_data[13:8] != 'h2) 
		 //  `uvm_error(get_type_name(), $sformatf("%s: SEQ recofig mode is incorrect ",func_name));

                 if (lane_status == exp_lane_status)begin
                   #30us;
			disable wait_seq_lt; 
		 end
	      end // forever begin
	 end // fork branch
        begin
	    if (env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1) begin
             wait(vip_lt_done==1'b1);
            end
	    else if (env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2) begin
             wait(vip_lt_done==2'b11);
            end
	    else if (env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4) begin
             wait(vip_lt_done==4'b1111);
            end
	    else if (env_ip[inst].dyn_rcfg_obj_inst.ch_num == 8) begin
             wait(vip_lt_done==8'b1111_1111);
            end
            reconfig_vip_for_datamode(speed,inst);
        end
      join


   if( lane_status == exp_lane_status  )
	begin
	   fork : wait_lt_status
	      begin
		 wait (env_ip[inst].spy_if.lt_training==4'h0);
		 `uvm_info(get_type_name(), $sformatf("%s:  LT is done",func_name), UVM_LOW);
                 gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"lt_status1")),.read_data(read_data),.speed(speed)); 
		 `uvm_info(get_name(), $sformatf("%s: LT STATUS register read data :%0h",func_name,read_data), UVM_NONE);
                 if (read_data != exp_lane_status) begin
                   `uvm_error(get_type_name(), $sformatf("%s: LT STATUS(addr : 0xd2) data is  incorrect ",func_name));
                 end
		   disable wait_lt_status;
	      end
	      begin
		 #200us;
		 `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting for LT status",func_name));
	      end
	   join_none;
	end
      env_ip[inst].`MAC_CFG.enable_autoadaptation = 0;
      env_ip[inst].`MAC_CFG.enable_autoadaptation_pam = 0;
   end  else begin// if (lt_en)
       reconfig_vip_for_datamode(speed,inst);
   end
   `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW);
endtask:wait_for_lt_complete

function void eth_top_env::disable_an_snps_errors(speed_e speed = _25G, int inst = 0);
   string func_name = "disable_an_snps_errors";
   `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW)
     env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_detect_mv_pair_after_max_time.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_trans_detect_after_data_max_time.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_clk_detect_before_min_time.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_pulse_too_short.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_new_tnonce_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_nonce_match_in_abilty_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_detect_mv_pair_after_max_time.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_clk_detect_after_max_time.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_trans_detect_before_mvd_min_time.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_ack_bit_enonce_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_pulse_too_long.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_trans_detect_after_mvd_max_time.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_detect_mv_pair_before_min_time.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_no_transiton_in_dme_page.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_trans_detect_before_data_min_time.set_default_fail_effect(svt_err_check_stats::IGNORE);   
   
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_detect_mv_pair_after_max_time.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_clk_detect_before_min_time.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_trans_detect_after_data_max_time.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_pulse_too_short.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_new_tnonce_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_nonce_match_in_abilty_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_detect_mv_pair_after_max_time.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_clk_detect_after_max_time.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_trans_detect_before_mvd_min_time.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_ack_bit_enonce_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_pulse_too_long.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_trans_detect_after_mvd_max_time.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_detect_mv_pair_before_min_time.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_no_transiton_in_dme_page.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_trans_detect_before_data_min_time.set_default_fail_effect(svt_err_check_stats::IGNORE);   
   
   `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW);
endfunction:disable_an_snps_errors

function void eth_top_env::enable_an_snps_errors(speed_e speed = _25G, int inst = 0);
   string func_name = "enable_an_snps_errors";
   `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW);
     if (speed == _100G) begin
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_detect_mv_pair_after_max_time.set_default_fail_effect(svt_err_check_stats::ERROR);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_clk_detect_after_max_time.set_default_fail_effect(svt_err_check_stats::ERROR);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_pulse_too_short.set_default_fail_effect(svt_err_check_stats::ERROR);
    end
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_new_tnonce_field.set_default_fail_effect(svt_err_check_stats::ERROR);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_nonce_match_in_abilty_field.set_default_fail_effect(svt_err_check_stats::ERROR);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_trans_detect_before_mvd_min_time.set_default_fail_effect(svt_err_check_stats::ERROR);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_trans_detect_after_data_max_time.set_default_fail_effect(svt_err_check_stats::ERROR);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_clk_detect_before_min_time.set_default_fail_effect(svt_err_check_stats::ERROR);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_ack_bit_enonce_field.set_default_fail_effect(svt_err_check_stats::ERROR);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_pulse_too_long.set_default_fail_effect(svt_err_check_stats::ERROR);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_trans_detect_after_mvd_max_time.set_default_fail_effect(svt_err_check_stats::ERROR);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_detect_mv_pair_before_min_time.set_default_fail_effect(svt_err_check_stats::ERROR);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_no_transiton_in_dme_page.set_default_fail_effect(svt_err_check_stats::ERROR);   
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_an73_trans_detect_before_data_min_time.set_default_fail_effect(svt_err_check_stats::ERROR);   
      
     if (speed == _100G) begin
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_detect_mv_pair_after_max_time.set_default_fail_effect(svt_err_check_stats::ERROR);
    end
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_pulse_too_short.set_default_fail_effect(svt_err_check_stats::ERROR);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_new_tnonce_field.set_default_fail_effect(svt_err_check_stats::ERROR);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_nonce_match_in_abilty_field.set_default_fail_effect(svt_err_check_stats::ERROR);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_clk_detect_after_max_time.set_default_fail_effect(svt_err_check_stats::ERROR);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_trans_detect_before_mvd_min_time.set_default_fail_effect(svt_err_check_stats::ERROR);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_trans_detect_after_data_max_time.set_default_fail_effect(svt_err_check_stats::ERROR);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_clk_detect_before_min_time.set_default_fail_effect(svt_err_check_stats::ERROR);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_ack_bit_enonce_field.set_default_fail_effect(svt_err_check_stats::ERROR);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_pulse_too_long.set_default_fail_effect(svt_err_check_stats::ERROR);
      env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_trans_detect_after_mvd_max_time.set_default_fail_effect(svt_err_check_stats::ERROR);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_detect_mv_pair_before_min_time.set_default_fail_effect(svt_err_check_stats::ERROR);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_no_transiton_in_dme_page.set_default_fail_effect(svt_err_check_stats::ERROR);   
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_an73_trans_detect_before_data_min_time.set_default_fail_effect(svt_err_check_stats::ERROR); 
   `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW);
endfunction:enable_an_snps_errors


   function void eth_top_env::disable_lt_snps_errors(speed_e speed = _25G, int inst = 0);
      string func_name = "disable_lt_snps_errors";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_autoadaptation_frame_pattern_ffff0000.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_autoadaptation_invalid_prbs_last_2bit.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_autoadaptation_invalid_prbs.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_autoadaptation_dme_encoding.set_default_fail_effect(svt_err_check_stats::IGNORE);

       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_autoadaptation_frame_pattern_ffff0000.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_autoadaptation_invalid_prbs_last_2bit.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_autoadaptation_invalid_prbs.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_autoadaptation_dme_encoding.set_default_fail_effect(svt_err_check_stats::IGNORE);    
      `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW);
   endfunction:disable_lt_snps_errors

   function void eth_top_env::enable_lt_snps_errors(speed_e speed = _25G, int inst = 0);
      string func_name = "enable_lt_snps_errors";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_autoadaptation_frame_pattern_ffff0000.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_autoadaptation_invalid_prbs_last_2bit.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_autoadaptation_invalid_prbs.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_autoadaptation_dme_encoding.set_default_fail_effect(svt_err_check_stats::IGNORE);

       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_autoadaptation_frame_pattern_ffff0000.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_autoadaptation_invalid_prbs_last_2bit.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_autoadaptation_invalid_prbs.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_autoadaptation_dme_encoding.set_default_fail_effect(svt_err_check_stats::IGNORE);    
      `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW);
   endfunction:enable_lt_snps_errors

   function void eth_top_env::enable_10_25G_snps_errors(speed_e speed = _25G, int inst = 0);
   string func_name = "enable_10_25G_snps_errors";
   
   `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW)   
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::ERROR);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::ERROR);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::ERROR);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::ERROR);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::ERROR);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::ERROR);	   
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::ERROR);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_xsbi_err_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::ERROR);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::ERROR);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::ERROR);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_reserved_control_char.set_default_fail_effect(svt_err_check_stats::ERROR);

   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::ERROR);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::ERROR);   
   
   /*if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFEC) begin
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_checksum.set_default_fail_effect(svt_err_check_stats::ERROR);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_btf.set_default_fail_effect(svt_err_check_stats::ERROR);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_second_align_marker.set_default_fail_effect(svt_err_check_stats::ERROR);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_first_five_bit_of_transcode.set_default_fail_effect(svt_err_check_stats::ERROR);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
   end*/
   
   
   `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW)
endfunction:enable_10_25G_snps_errors

function void eth_top_env::disable_10_25G_snps_errors(speed_e speed = _25G, int inst = 0);
   string func_name = "disable_10_25G_snps_errors";
   
   `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW)   
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);	   
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_rsvrd_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_xsbi_err_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_reserved_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);

   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);


   /*if(env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFEC) begin
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_btf.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_second_align_marker.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_first_five_bit_of_transcode.set_default_fail_effect(svt_err_check_stats::IGNORE);
   env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);   
   endif*/

   `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW)
endfunction:disable_10_25G_snps_errors

// This method waits for pcs ready to go high 
task eth_top_env::wait_rx_pcs_ready(speed_e speed = _25G, int node = 0, int inst = 0, anlt_std_e anlt_std = IEEE);
   uvm_reg_data_t read_data;
   uvm_status_e      status;
   bit crc_cover_preamble;
   bit an_en=0;
   bit dut_pcs_ready, vip_pcs_ready;
   string func_name = "wait_rx_pcs_ready";
   bit [31:0] exp_an_status = 32'h0;
   bit [31:0] exp_seq_mode ;
   `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_NONE);
   
   if(speed == _100G) begin
     disable_snps_errors(speed,inst);
   end
   else if(speed inside {_10G,_25G}) begin
     disable_10_25G_snps_errors(speed,inst);
   end
   wait_for_an_complete(speed,node,inst,anlt_std);
   wait_for_lt_complete(speed,node,inst);
   //reconfig_vip_for_datamode(speed,inst);
   
   dut_pcs_ready=0;
   vip_pcs_ready=0;
   `uvm_info("wait_rx_pcs_ready", $sformatf("Waiting for Rx pcs ready...=%0t", $time), UVM_NONE);
   fork: link_ready
      begin   
	 wait(env_ip[inst].spy_if.rx_pcs_ready  == 1'b1);
	 //wait(env_ip[inst].master_agent.mast_agt_if.rx_pcs_ready == 1'b1);
	 `uvm_info("wait_rx_pcs_ready", $sformatf("Rx pcs ready asserted...=%0t", $time), UVM_NONE);
	 dut_pcs_ready=1;
      end
      begin
	 `uvm_info("wait_rx_pcs_ready", $sformatf("Wait VIP to link up...=%0t", $time), UVM_NONE)
	 env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.EVENT_LINK_UP.wait_trigger();
	 `uvm_info("wait_rx_pcs_ready", $sformatf("Done waiting VIP to link up...=%0t", $time), UVM_NONE)
	 vip_pcs_ready=1;
      end
      begin
        wait (vip_pcs_ready && dut_pcs_ready);
        disable link_ready;
      end
      begin
	 #2ms;
	 `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting for PCS ready",func_name));
      end
   join 
   `uvm_info("wait_rx_pcs_ready", $sformatf("Done waiting for Rx pcs ready...=%0t", $time), UVM_NONE);   
  
   if(speed == _100G) begin
     enable_snps_errors(speed,inst);
   end
   else if(speed == _25G) begin
     //wait(env_ip[inst].spy_if.o_sl_tx_ready == 1'b1);
     enable_10_25G_snps_errors(speed,inst);
   end 

   `uvm_info("wait_rx_pcs_ready", $sformatf("Enabled SNPS protocol errors"), UVM_NONE)
   //reg_model.phy_tx_pll_locked.predict(.value(4'hF),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map)); 
   //PHY_CLK FB:535993
   //reg_model.PHY_CLK.predict(.value(1'h1),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map)); 
   
  //if(speed == _50G)
   //reg_model.EIO_FREQ_LOCK.predict(.value(4'h3),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map)); 
  //else
   //reg_model.EIO_FREQ_LOCK.predict(.value(4'hF),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map)); 
  
   //reg_model.RX_PCS_FULLY_ALIGNED_S.predict(.value(2'h1),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map)); 
   //reg_model.AM_LOCK.predict(.value(1'h1),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));

   //Chintan : Need to configure tx/rxcrc_cover_preamble with same value in feedback mode
//`ifndef ENABLE_ETH_VIP
//   if(rand_crc_cover_preamble == 1'b1) crc_cover_preamble=$urandom();
//
//   if(crc_cover_preamble ==1'b1) 
//     `uvm_info("wait_rx_pcs_ready", $psprintf("Preamble will be included in CRC\n"),UVM_LOW)
//   else
//     `uvm_info("wait_rx_pcs_ready", $psprintf("Preamble will not be included in CRC\n"),UVM_LOW)
//
//   //reg_model.txmac_ehip_cfg.read(status,.value(read_data), .map(reg_model.default_map));
//   read_data[9]=crc_cover_preamble;
//   //reg_model.txmac_ehip_cfg.write(status,.value(read_data), .map(reg_model.default_map));
//   if(speed == _50G) begin
//   //FB:551395:In 50G TX pp=1 in DUT always. Setting actual pp value in RAL as writting above reg will change it to 1
//   //reg_model.txmac_ehip_cfg.en_pp.set(tb_cfg.preamble_passthrough);
//   end
//
//   //reg_model.rxmac_ehip_cfg.read(status,.value(read_data), .map(reg_model.default_map));
//   read_data[1]=crc_cover_preamble;
//   //reg_model.rxmac_ehip_cfg.write(status,.value(read_data), .map(reg_model.default_map));
//`endif
//

if(speed == _10G) begin 
  exp_seq_mode = 32'h04;
end else if(speed == _25G) begin 
  exp_seq_mode = 32'h08;
end  else if(speed == _50G) begin
  if(env_ip[inst].spy_if.ch_num == 2) exp_seq_mode = 32'h10;
  if(env_ip[inst].spy_if.ch_num == 1) exp_seq_mode = 32'h100;
end  else if(speed == _40G) begin
  exp_seq_mode = 32'h40;
end  else if(speed == _100G) begin
  if(env_ip[inst].spy_if.ch_num == 4) exp_seq_mode = 32'h20;
  if(env_ip[inst].spy_if.ch_num == 2) exp_seq_mode = 32'h80;
  if(env_ip[inst].spy_if.ch_num == 1) exp_seq_mode = 32'h800;
end  else if(speed == _200G) begin
  if(env_ip[inst].spy_if.ch_num == 4) exp_seq_mode = 32'h200;
  if(env_ip[inst].spy_if.ch_num == 2) exp_seq_mode = 32'h1000;
end  else if(speed == _400G) begin
  if(env_ip[inst].spy_if.ch_num == 8) exp_seq_mode = 32'h400;
  if(env_ip[inst].spy_if.ch_num == 4) exp_seq_mode = 32'h2000;
end

fork : wait_status_update
      begin
	 wait (env_ip[inst].spy_if.an_status_c2[6]==1'b1);
	 wait (env_ip[inst].spy_if.seq_mode==exp_seq_mode);
	 wait (env_ip[inst].spy_if.seq_link_ready==1'h1);
	 gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_cfg1")),.read_data(read_data),.speed(speed));
	 an_en = read_data[0];
	 if (an_en) begin
	    gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_status")),.read_data(read_data),.speed(speed));
	    if (read_data[6] != 1'b1)
	      `uvm_error(get_type_name(), $sformatf("%s: AN  STATUS read data is incorrect. EXP[6]=1, ACT[6]=%2x",func_name,read_data[6]));
	 end	  
	 #2us;
	 gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"seq_status")),.read_data(read_data),.speed(speed));
	 if (read_data != 32'h2001) begin
	    if (read_data[0]!=1'b1)
	      `uvm_error(get_type_name(), $sformatf("%s: Seq link ready value incorrect. EXP=1, ACT=0",func_name));
	    if (read_data[1]!=1'b0)
	      `uvm_error(get_type_name(), $sformatf("%s: Seq an timeout value incorrect. EXP=0, ACT=1",func_name));
	    if (read_data[2]!=1'b0)
	      `uvm_error(get_type_name(), $sformatf("%s: Seq lt timeout value incorrect. EXP=0, ACT=1",func_name));
	    if (read_data[21:8]!= exp_seq_mode)
	      `uvm_error(get_type_name(), $sformatf("%s: Seq reconfig mode value incorrect. EXP=6'h20, ACT=%0x",func_name,read_data[21:8]));
	 end
	 disable wait_status_update;
      end 
      begin
	 #300us;
	 disable wait_status_update;
	 `uvm_warning(get_type_name(), $sformatf("%s: Timeout waiting for ANLT link done status to update",func_name));
      end
join

//// Crete3 takes longer to set an_status  
// if(speed == _25G) begin// 10/25G - exclude checking data mode due to reconfig
//   `uvm_info(get_type_name(), $sformatf("%s: Waiting for 10/25G ANLT sequencer status update...",func_name), UVM_NONE);
//   fork : wait_10_25g_status_update
//      begin
//	 wait (env_ip[inst].spy_if.an_status_c2[6]==1'b1);
//	 wait (env_ip[inst].spy_if.seq_link_ready==1'h1);
//	 gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_cfg1")),.read_data(read_data),.speed(speed));
//	 an_en = read_data[0];
//	 if (an_en) begin
//	    gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_status")),.read_data(read_data),.speed(speed));
//	    if (read_data[7:0] != 8'he6 && read_data[7:0] != 8'hee)
//	      `uvm_error(get_type_name(), $sformatf("%s: AN  STATUS read data is incorrect. EXP[7:0]='8f4, ACT[7:0]=%2x",func_name,read_data));//need to update for rsfec support
//	 end	    
//	 gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"seq_status")),.read_data(read_data),.speed(speed));
//
//	 if (read_data[2:0] != 3'h1) begin
//	    if (read_data[0]!=1'b1)
//	      `uvm_error(get_type_name(), $sformatf("%s: Seq link ready value incorrect. EXP=1, ACT=0",func_name));
//	    if (read_data[1]!=1'b0)
//	      `uvm_error(get_type_name(), $sformatf("%s: Seq an timeout value incorrect. EXP=0, ACT=1",func_name));
//	    if (read_data[2]!=1'b0)
//	      `uvm_error(get_type_name(), $sformatf("%s: Seq an timeout value incorrect. EXP=0, ACT=1",func_name));
//	 end
//	 disable wait_10_25g_status_update;
//     end // UNMATCHED !!
//     begin
//         #800us;
//         `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting for 10/25G ANLT link done status to update",func_name));
//     end
//   join_any
// end
// else if(speed != _25G) begin
//   `uvm_info(get_type_name(), $sformatf("%s: Waiting for ANLT sequencer status update...",func_name), UVM_NONE);
//   fork : wait_status_update
//      begin
//	 wait (env_ip[inst].spy_if.an_status_c2[6]==1'b1);
//	 wait (env_ip[inst].spy_if.seq_mode==6'h20);
//	 gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_cfg1")),.read_data(read_data),.speed(speed));
//	 an_en = read_data[0];
//	 if (an_en) begin
//	    gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_status")),.read_data(read_data),.speed(speed));
//	    if (read_data[6] != 1'b1)
//	      `uvm_error(get_type_name(), $sformatf("%s: AN  STATUS read data is incorrect. EXP[6]=1, ACT[6]=%2x",func_name,read_data[6]));
//	 end	  
//	 #2us;
//	 gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"seq_status")),.read_data(read_data),.speed(speed));
//	 if (read_data != 32'h2001) begin
//	    if (read_data[0]!=1'b1)
//	      `uvm_error(get_type_name(), $sformatf("%s: Seq link ready value incorrect. EXP=1, ACT=0",func_name));
//	    if (read_data[1]!=1'b0)
//	      `uvm_error(get_type_name(), $sformatf("%s: Seq an timeout value incorrect. EXP=0, ACT=1",func_name));
//	    if (read_data[2]!=1'b0)
//	      `uvm_error(get_type_name(), $sformatf("%s: Seq lt timeout value incorrect. EXP=0, ACT=1",func_name));
//	    if (read_data[15:8]!=6'h20)
//	      `uvm_error(get_type_name(), $sformatf("%s: Seq reconfig mode value incorrect. EXP=6'h20, ACT=%0x",func_name,read_data[15:8]));
//	 end
//	 disable wait_status_update;
//      end // UNMATCHED !!
//      begin
//	 #300us;
//	 `uvm_warning(get_type_name(), $sformatf("%s: Timeout waiting for ANLT link done status to update",func_name));
//      end
//      forever begin
//	 @ (env_ip[inst].spy_if.rx_pcs_ready);
//	 if (!env_ip[inst].spy_if.rx_pcs_ready)
//	   disable wait_status_update;
//      end
//   join_none
// end
//	 wait(env_ip[inst].spy_if.debug_signal  == 'h1F0);

   `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_NONE);
   
endtask:wait_rx_pcs_ready

function void eth_top_env::disable_snps_errors(speed_e speed = _25G, int inst = 0, string ERR_TYPE = "ALL");
   string func_name = "disable_snps_errors";
   `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW)
   
   //dsamantx :FIXME for different speeds in GDR
   //and also if particular snps error are required to be disabled.use extra code using ERR_TYPE
   
   /*if( ERR_TYPE== "ALL") begin
     
     if(speed == _100G) begin
       `uvm_info(get_type_name(), $sformatf("%s: Disabling 100G snps errors",func_name), UVM_LOW)
       //TX
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_count.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_autoadaptation_frame_pattern_ffff0000.set_default_fail_effect(svt_err_check_stats::IGNORE);//Demote Error
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_autoadaptation_invalid_prbs_last_2bit.set_default_fail_effect(svt_err_check_stats::IGNORE);//Demote Error
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_autoadaptation_invalid_prbs.set_default_fail_effect(svt_err_check_stats::IGNORE);//Demote Error
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_csbi_am_not_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_csbi_invalid_bip_rcvd.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_start_c_char_after_start_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_term_c_char_not_followed_by_idle_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);   
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_seq_char_not_followed_by_zeroes_in_lane_4_to_7.set_default_fail_effect(svt_err_check_stats::IGNORE);
       //env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_rs_fec_no_am_rcvd_at_am_boundary.set_default_fail_effect(svt_err_check_stats::NOTE); // RAMI - newly added for 100G NoFEC->FEC bringup
       
       //RX
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_start_c_char_after_start_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_no_am_rcvd_at_am_boundary.set_default_fail_effect(svt_err_check_stats::NOTE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_csbi_am_not_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_csbi_invalid_bip_rcvd.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_term_c_char_not_followed_by_idle_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);   
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
       
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_rsvrd_seq_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE); //Seen for eth_reset_during_dr_test in PERT 3510963 - RAMI
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);//{modified}
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_preamble_count.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_autoadaptation_frame_pattern_ffff0000.set_default_fail_effect(svt_err_check_stats::IGNORE);//Demote Error
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_autoadaptation_invalid_prbs_last_2bit.set_default_fail_effect(svt_err_check_stats::IGNORE);//Demote Error
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_autoadaptation_invalid_prbs.set_default_fail_effect(svt_err_check_stats::IGNORE);//Demote Error
       //pbenittx
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_invalid_am_order_within_transcode_block.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_invalid_tbd.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_invalid_first_5bits_of_control_transcode.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_no_am_rcvd_at_am_boundary.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_no_am_rcvd_at_am_boundary.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_signal_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE); //dsamantx:added for 100G NoFEC->FEC bringup:seen in register_rsfec_reset in pert 3617957
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_multilane_high_ber.set_default_fail_effect(svt_err_check_stats::IGNORE);//dsamantx :seen during DR in multple_switches_test
       //if (env_ip[inst].dyn_rcfg_obj_inst.fec_type == 1) begin 
       //RX
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_invalid_first_5bits_of_control_transcode.set_default_fail_effect(svt_err_check_stats::IGNORE);
       //TX
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_rs_fec_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_rs_fec_invalid_first_5bits_of_control_transcode.set_default_fail_effect(svt_err_check_stats::IGNORE);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_rsvrd_seq_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE); // RAMI - newly added for 100G FEC bringup {muralasx}
       //end
       
       if (env_ip[inst].dyn_rcfg_obj_inst.mode == OTN) begin
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_csbi_invalid_bip_rcvd.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
       end
      end // if(speed ==_100G)

     else if((speed == _25G) || speed ==_10G)) begin
         
          `uvm_info(get_type_name(), $sformatf("%s: Disabling 10G_25G snps errors",func_name), UVM_LOW)   
          //RX
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);	   
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_rsvrd_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_xsbi_err_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_reserved_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_signal_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE); 

          //TX
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_rsvrd_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_xsbi_err_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_reserved_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          

          //////
          //TODO disabling all m_snps_flexe_otn_agent checks
          //////
	  if(env_ip[inst].dyn_rcfg_obj_inst.mode inside {OTN,FLEXE}) begin
          `uvm_info(get_type_name(), $sformatf("%s: Disabling m_snps_flexe_otn_agent checks temporarily",func_name), UVM_LOW)   
          //RX
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);	   
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_mac_rsvrd_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_rx.svt_xsbi_err_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_reserved_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          //TX
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_xsbi_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_xsbi_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);	   
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_mac_rsvrd_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_xsbi_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_tx.svt_xsbi_err_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_xsbi_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_xsbi_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
          env_ip[inst].m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_xsbi_reserved_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
        end

          if (env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKR || env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKP ) begin 
             //RX
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_invalid_bit_in_align_marker.set_default_fail_effect(svt_err_check_stats::IGNORE);//{modified}
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_btf.set_default_fail_effect(svt_err_check_stats::IGNORE);
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_second_align_marker.set_default_fail_effect(svt_err_check_stats::IGNORE);
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_first_five_bit_of_transcode.set_default_fail_effect(svt_err_check_stats::IGNORE);
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);   
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE); // RAMI - newly added for 100G FEC bringup 
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_signal_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE); // RAMI - newly added for 100G FEC bringup 
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_rsvrd_seq_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE); // RAMI - newly added for 100G FEC bringup
             //TX
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_lsbi_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_lsbi_invalid_btf.set_default_fail_effect(svt_err_check_stats::IGNORE);
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_lsbi_invalid_second_align_marker.set_default_fail_effect(svt_err_check_stats::IGNORE);
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_lsbi_invalid_first_five_bit_of_transcode.set_default_fail_effect(svt_err_check_stats::IGNORE);
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);   
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE); // RAMI - newly added for 100G FEC bringup 
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_signal_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE); // RAMI - newly added for 100G FEC bringup 
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_rsvrd_seq_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE); // RAMI - newly added for 100G FEC bringup
          end
      end  //if (speed inside {_10G,_25G})
    end // if(ERR_TYPE=ALL)
   else if( ERR_TYPE== "MID_SIM_RST")
    begin
     `uvm_info(get_type_name(), $sformatf("%s: Disabling MID_SIM_RST snps errors",func_name), UVM_LOW)
     env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
     env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
     env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
     env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
     env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
     env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    end*/
   `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW)
endfunction:disable_snps_errors

function void eth_top_env::enable_snps_errors(speed_e speed = _25G, int inst = 0, string ERR_TYPE = "ALL");
   string func_name = "enable_snps_errors";
   `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW)
   
   /*if(ERR_TYPE == "ALL") begin

     if (speed == _100G ) begin
        `uvm_info(get_type_name(), $sformatf("%s: Enabling 100G snps errors",func_name), UVM_LOW)
        //TX
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_count.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_autoadaptation_frame_pattern_ffff0000.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_autoadaptation_invalid_prbs_last_2bit.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_autoadaptation_invalid_prbs.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_csbi_am_not_found.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_csbi_invalid_bip_rcvd.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_term_c_char_not_followed_by_idle_c_char.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_seq_char_not_followed_by_zeroes_in_lane_4_to_7.set_default_fail_effect(svt_err_check_stats::ERROR);
        //RX
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_start_c_char_after_start_c_char.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
        
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_autoadaptation_frame_pattern_ffff0000.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_autoadaptation_invalid_prbs_last_2bit.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_autoadaptation_invalid_prbs.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_preamble_count.set_default_fail_effect(svt_err_check_stats::ERROR);
        
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::ERROR);
        
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_no_am_rcvd_at_am_boundary.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_term_c_char_not_followed_by_idle_c_char.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_start_c_char_after_start_c_char.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_signal_ordered_set.set_default_fail_effect(svt_err_check_stats::ERROR); //dsamantx:added for 100G NoFEC->FEC bringup:seen in register_rsfec_reset in pert 3617957
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_multilane_high_ber.set_default_fail_effect(svt_err_check_stats::ERROR);//dsamantx :seen during DR in multple_switches_test
        //if (env_ip[inst].dyn_rcfg_obj_inst.fec_type == 1) begin 
        //RX
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_invalid_checksum.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_invalid_first_5bits_of_control_transcode.set_default_fail_effect(svt_err_check_stats::ERROR);
        //TX
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_rs_fec_invalid_checksum.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_rs_fec_invalid_first_5bits_of_control_transcode.set_default_fail_effect(svt_err_check_stats::ERROR);
        env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_rsvrd_seq_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR); // RAMI - newly added for 100G FEC bringup   {muralasx}
        //end
        if (env_ip[inst].dyn_rcfg_obj_inst.mode == OTN) begin 
           env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_csbi_invalid_bip_rcvd.set_default_fail_effect(svt_err_check_stats::ERROR);
           env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::ERROR);
        end
      end // if(speed ==_100G)

      else if ((speed == _25G) || (speed ==_10G)) begin
         
          `uvm_info(get_type_name(), $sformatf("%s: Enabling 10G_25G snps_errors",func_name), UVM_LOW)   
          //RX
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::ERROR);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::ERROR);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::ERROR);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::ERROR);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::ERROR);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::ERROR);	   
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::ERROR);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_xsbi_err_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::ERROR);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::ERROR);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::ERROR);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_reserved_control_char.set_default_fail_effect(svt_err_check_stats::ERROR);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::ERROR);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_signal_ordered_set.set_default_fail_effect(svt_err_check_stats::ERROR);  
          //TX
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::ERROR);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::ERROR);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::ERROR);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::ERROR);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::ERROR);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::ERROR);	   
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::ERROR);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_xsbi_err_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::ERROR);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::ERROR);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::ERROR);
          env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_reserved_control_char.set_default_fail_effect(svt_err_check_stats::ERROR);

          if (env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKR || env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKP ) begin 
             //RX
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_invalid_bit_in_align_marker.set_default_fail_effect(svt_err_check_stats::ERROR);
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_checksum.set_default_fail_effect(svt_err_check_stats::ERROR);
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_btf.set_default_fail_effect(svt_err_check_stats::ERROR);
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_second_align_marker.set_default_fail_effect(svt_err_check_stats::ERROR);
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_first_five_bit_of_transcode.set_default_fail_effect(svt_err_check_stats::ERROR);
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
             //TX
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_lsbi_invalid_checksum.set_default_fail_effect(svt_err_check_stats::ERROR);
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_lsbi_invalid_btf.set_default_fail_effect(svt_err_check_stats::ERROR);
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_lsbi_invalid_second_align_marker.set_default_fail_effect(svt_err_check_stats::ERROR);
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_lsbi_invalid_first_five_bit_of_transcode.set_default_fail_effect(svt_err_check_stats::ERROR);
             env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
          end
      end //if(speed ==_10G || speed ==_25G)
    end //if(ERR_TYPE==ALL)
   else if(ERR_TYPE == "MID_SIM_RST") begin
      
       `uvm_info(get_type_name(), $sformatf("%s: enabling MID_SIM_RST snps_errors",func_name), UVM_LOW)
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::ERROR);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::ERROR);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::ERROR);
       env_ip[inst].`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::ERROR);
    end*/
   `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW)
endfunction:enable_snps_errors

`endif //  `ifdef ENABLE_ETH_VIP

function eth_top_env::new(string name= "eth_top_env",uvm_component parent=null);
   super.new(name,parent);
endfunction:new

function void eth_top_env::build_phase(uvm_phase phase);
   super.build_phase(phase);

   //env_ip             = new[`NUM_INST]; 
   env_ip = new[num_inst];

   //Create subENV
   foreach (env_ip[i]) begin
      env_ip[i] = eth_env_env::type_id::create($sformatf("env_ip%0d", i), this);
      uvm_config_db#(string)::set(uvm_root::get(),$sformatf("*env_ip%0d*", i),"env_name",$sformatf("env_ip%0d", i)); 
   end
      
   // Object :virtual_sequencer_inst 
   // This is virtual sequnecer instance
   top_virtual_sequencer_inst = eth_top_virtual_sequencer::type_id::create("top_virtual_sequencer_inst",this);

         anlt_reg_cov = anlt_register_coverage::type_id::create("anlt_reg_cov",this);
   
   // Get kr avmm cfg obj
   if(!uvm_config_db#(kr_cfg)::get(this, "", "kr_cfg_inst", kr_cfg_inst)) begin 
      `uvm_fatal("kr_cfg", "failed to get kr_cfginst object from test");
   end 
   uvm_config_db #(kr_cfg)::set(this,"*", "kr_cfg_inst",kr_cfg_inst);

   // Build KR AVMM for kr avmm interfaces
   if(kr_cfg_inst.is_speed_10g) begin
     if(!uvm_config_db#(string)::get(this,"","kr10g_avmm_rtb_path", kr10g_avmm_rtb_path)) begin
        `uvm_fatal("kr10g_avmm_rtb_path", "failed to get kr10g_avmm_rtb_path");
     end
     `uvm_info(get_type_name(),$sformatf("10G AVMM Path: %s",kr10g_avmm_rtb_path), UVM_LOW);
     kr10g_avmm_agt_cfg     = altuvm_avalon_mm_config::type_id::create("kr10g_avmm_agt_cfg");
     kr10g_avmm_agt_cfg.m_msg_id = "KR10G_AVMM_CFG";
     `altuvm_set_config_db(altuvm_avalon_mm_config, "m_config", kr10g_avmm_agt_cfg, "kr10g_avmm_agt")
     kr10g_avmm_agt  = altuvm_avalon_mm_agent::type_id::create("kr10g_avmm_agt", this);
     kr10g_avmm_agt.set_rtb_path({"eth_env_top.",kr10g_avmm_rtb_path});

     kr10g_reg_adpt  = altuvm_avalon_mm_reg_adapter_eth::type_id::create("kr10g_reg_adpt", this);

     kr10g_reg_model = eth_anlt_f_csr_doc_urm::type_id::create("kr10g_reg_model", this);
     kr10g_reg_model.build();
     kr10g_reg_model.reset(); 
     kr10g_reg_model.default_map.set_auto_predict(1);
     kr10g_reg_model.lock_model();
    
     anlt_reg_cov.anlt_reg_model = kr10g_reg_model;
   end

         //anlt_reg_cov.anlt_reg_model = kr25g_reg_model;
   if(kr_cfg_inst.is_speed_25g) begin
     if(!uvm_config_db#(string)::get(this,"","kr25g_avmm_rtb_path", kr25g_avmm_rtb_path)) begin
        `uvm_fatal("kr25g_avmm_rtb_path", "failed to get kr25g_avmm_rtb_path");
     end
     `uvm_info(get_type_name(),$sformatf("25G AVMM Path: %s",kr25g_avmm_rtb_path), UVM_LOW);
     kr25g_avmm_agt_cfg     = altuvm_avalon_mm_config::type_id::create("kr25g_avmm_agt_cfg");
     kr25g_avmm_agt_cfg.m_msg_id = "KR25G_AVMM_CFG";
     `altuvm_set_config_db(altuvm_avalon_mm_config, "m_config", kr25g_avmm_agt_cfg, "kr25g_avmm_agt")
     kr25g_avmm_agt  = altuvm_avalon_mm_agent::type_id::create("kr25g_avmm_agt", this);
     kr25g_avmm_agt.set_rtb_path({"eth_env_top.",kr25g_avmm_rtb_path});

     kr25g_reg_adpt  = altuvm_avalon_mm_reg_adapter_eth::type_id::create("kr25g_reg_adpt", this);

     kr25g_reg_model = eth_anlt_f_csr_doc_urm::type_id::create("kr25g_reg_model", this);
     kr25g_reg_model.build();
     kr25g_reg_model.reset(); 
     kr25g_reg_model.default_map.set_auto_predict(1);
     kr25g_reg_model.lock_model();
     
     anlt_reg_cov.anlt_reg_model = kr25g_reg_model;
   end

   if(kr_cfg_inst.is_speed_40g) begin
     if(!uvm_config_db#(string)::get(this,"","kr40g_avmm_rtb_path", kr40g_avmm_rtb_path)) begin
        `uvm_fatal("kr40g_avmm_rtb_path", "failed to get kr40g_avmm_rtb_path");
     end
     `uvm_info(get_type_name(),$sformatf("40G AVMM Path: %s",kr40g_avmm_rtb_path), UVM_LOW);
     kr40g_avmm_agt_cfg     = altuvm_avalon_mm_config::type_id::create("kr40g_avmm_agt_cfg");
     kr40g_avmm_agt_cfg.m_msg_id = "KR40G_AVMM_CFG";
     `altuvm_set_config_db(altuvm_avalon_mm_config, "m_config", kr40g_avmm_agt_cfg, "kr40g_avmm_agt")
     kr40g_avmm_agt  = altuvm_avalon_mm_agent::type_id::create("kr40g_avmm_agt", this);
     kr40g_avmm_agt.set_rtb_path({"eth_env_top.",kr40g_avmm_rtb_path});

     kr40g_reg_adpt  = altuvm_avalon_mm_reg_adapter_eth::type_id::create("kr40g_reg_adpt", this);

     kr40g_reg_model = eth_anlt_f_csr_doc_urm::type_id::create("kr40g_reg_model", this);
     kr40g_reg_model.build();
     kr40g_reg_model.reset(); 
     kr40g_reg_model.default_map.set_auto_predict(1);
     kr40g_reg_model.lock_model();

     anlt_reg_cov.anlt_reg_model = kr40g_reg_model;
   end
   
   if(kr_cfg_inst.is_speed_50g) begin
     if(!uvm_config_db#(string)::get(this,"","kr50g_avmm_rtb_path", kr50g_avmm_rtb_path)) begin
        `uvm_fatal("kr50g_avmm_rtb_path", "failed to get kr50g_avmm_rtb_path");
     end
     `uvm_info(get_type_name(),$sformatf("50G AVMM Path: %s",kr50g_avmm_rtb_path), UVM_LOW);
     kr50g_avmm_agt_cfg     = altuvm_avalon_mm_config::type_id::create("kr50g_avmm_agt_cfg");
     kr50g_avmm_agt_cfg.m_msg_id = "KR50G_AVMM_CFG";
     `altuvm_set_config_db(altuvm_avalon_mm_config, "m_config", kr50g_avmm_agt_cfg, "kr50g_avmm_agt")
     kr50g_avmm_agt  = altuvm_avalon_mm_agent::type_id::create("kr50g_avmm_agt", this);
     kr50g_avmm_agt.set_rtb_path({"eth_env_top.",kr50g_avmm_rtb_path});

     kr50g_reg_adpt  = altuvm_avalon_mm_reg_adapter_eth::type_id::create("kr50g_reg_adpt", this);

     kr50g_reg_model = eth_anlt_f_csr_doc_urm::type_id::create("kr50g_reg_model", this);
     kr50g_reg_model.build();
     kr50g_reg_model.reset(); 
     kr50g_reg_model.default_map.set_auto_predict(1);
     kr50g_reg_model.lock_model();
     anlt_reg_cov.anlt_reg_model = kr50g_reg_model;
   end

   if(kr_cfg_inst.is_speed_100g) begin
     if(!uvm_config_db#(string)::get(this,"","kr100g_avmm_rtb_path", kr100g_avmm_rtb_path)) begin
        `uvm_fatal("kr100g_avmm_rtb_path", "failed to get kr100g_avmm_rtb_path");
     end
     `uvm_info(get_type_name(),$sformatf("100G AVMM Path: %s",kr100g_avmm_rtb_path), UVM_LOW);
     kr100g_avmm_agt_cfg     = altuvm_avalon_mm_config::type_id::create("kr100g_avmm_agt_cfg");
     kr100g_avmm_agt_cfg.m_msg_id = "KR100G_AVMM_CFG";
     `altuvm_set_config_db(altuvm_avalon_mm_config, "m_config", kr100g_avmm_agt_cfg, "kr100g_avmm_agt")
     kr100g_avmm_agt  = altuvm_avalon_mm_agent::type_id::create("kr100g_avmm_agt", this);
     kr100g_avmm_agt.set_rtb_path({"eth_env_top.",kr100g_avmm_rtb_path});

     kr100g_reg_adpt  = altuvm_avalon_mm_reg_adapter_eth::type_id::create("kr100g_reg_adpt", this);

     kr100g_reg_model = eth_anlt_f_csr_doc_urm::type_id::create("kr100g_reg_model", this);
     kr100g_reg_model.build();
     kr100g_reg_model.reset(); 
     kr100g_reg_model.default_map.set_auto_predict(1);
     kr100g_reg_model.lock_model();
     anlt_reg_cov.anlt_reg_model = kr100g_reg_model;
   end

   if(kr_cfg_inst.is_speed_200g) begin
     if(!uvm_config_db#(string)::get(this,"","kr200g_avmm_rtb_path", kr200g_avmm_rtb_path)) begin
        `uvm_fatal("kr200g_avmm_rtb_path", "failed to get kr200g_avmm_rtb_path");
     end
     `uvm_info(get_type_name(),$sformatf("200G AVMM Path: %s",kr200g_avmm_rtb_path), UVM_LOW);
     kr200g_avmm_agt_cfg     = altuvm_avalon_mm_config::type_id::create("kr200g_avmm_agt_cfg");
     kr200g_avmm_agt_cfg.m_msg_id = "KR200G_AVMM_CFG";
     `altuvm_set_config_db(altuvm_avalon_mm_config, "m_config", kr200g_avmm_agt_cfg, "kr200g_avmm_agt")
     kr200g_avmm_agt  = altuvm_avalon_mm_agent::type_id::create("kr200g_avmm_agt", this);
     kr200g_avmm_agt.set_rtb_path({"eth_env_top.",kr200g_avmm_rtb_path});

     kr200g_reg_adpt  = altuvm_avalon_mm_reg_adapter_eth::type_id::create("kr200g_reg_adpt", this);

     kr200g_reg_model = eth_anlt_f_csr_doc_urm::type_id::create("kr200g_reg_model", this);
     kr200g_reg_model.build();
     kr200g_reg_model.reset(); 
     kr200g_reg_model.default_map.set_auto_predict(1);
     kr200g_reg_model.lock_model();
     anlt_reg_cov.anlt_reg_model = kr200g_reg_model;
   end

   if(kr_cfg_inst.is_speed_400g) begin
     if(!uvm_config_db#(string)::get(this,"","kr400g_avmm_rtb_path", kr400g_avmm_rtb_path)) begin
        `uvm_fatal("kr400g_avmm_rtb_path", "failed to get kr400g_avmm_rtb_path");
     end
     `uvm_info(get_type_name(),$sformatf("400G AVMM Path: %s",kr400g_avmm_rtb_path), UVM_LOW);
     kr400g_avmm_agt_cfg     = altuvm_avalon_mm_config::type_id::create("kr400g_avmm_agt_cfg");
     kr400g_avmm_agt_cfg.m_msg_id = "KR400G_AVMM_CFG";
     `altuvm_set_config_db(altuvm_avalon_mm_config, "m_config", kr400g_avmm_agt_cfg, "kr400g_avmm_agt")
     kr400g_avmm_agt  = altuvm_avalon_mm_agent::type_id::create("kr400g_avmm_agt", this);
     kr400g_avmm_agt.set_rtb_path({"eth_env_top.",kr400g_avmm_rtb_path});

    kr400g_reg_adpt  = altuvm_avalon_mm_reg_adapter_eth::type_id::create("kr400g_reg_adpt", this);

     kr400g_reg_model = eth_anlt_f_csr_doc_urm::type_id::create("kr400g_reg_model", this);
     kr400g_reg_model.build();
     kr400g_reg_model.reset(); 
     kr400g_reg_model.default_map.set_auto_predict(1);
     kr400g_reg_model.lock_model();
     anlt_reg_cov.anlt_reg_model = kr400g_reg_model;
   end

//  if (env_ip[0].dyn_rcfg_obj_inst.ptp==1) begin
`ifdef PTP_EN
      if(!uvm_config_db#(string)::get(this,"","p2p_avmm_rtb_path", p2p_avmm_rtb_path)) begin
          `uvm_fatal("p2p_avmm_rtb_path", "failed to get p2p_avmm_rtb_path");
      end
      `uvm_info(get_type_name(),$sformatf("P2P AVMM Path: %s",p2p_avmm_rtb_path), UVM_LOW);
      p2p_avmm_agt_cfg     = altuvm_avalon_mm_config::type_id::create("p2p_avmm_agt_cfg");
      p2p_avmm_agt_cfg.m_msg_id = "P2P_AVMM_CFG";
      `altuvm_set_config_db(altuvm_avalon_mm_config, "m_config", p2p_avmm_agt_cfg, "p2p_avmm_agt")
      p2p_avmm_agt  = altuvm_avalon_mm_agent::type_id::create("p2p_avmm_agt", this);
      p2p_avmm_agt.set_rtb_path({"eth_env_top.",p2p_avmm_rtb_path});
      p2p_avmm_agt_cfg.set_command_timeout(3000);
      p2p_avmm_agt_cfg.set_waitrequest_timeout(3000);

      if(!uvm_config_db#(string)::get(this,"","asm_avmm_rtb_path", asm_avmm_rtb_path)) begin
          `uvm_fatal("asm_avmm_rtb_path", "failed to get asm_avmm_rtb_path");
      end
      `uvm_info(get_type_name(),$sformatf("ASM AVMM Path: %s",asm_avmm_rtb_path), UVM_LOW);
      asm_avmm_agt_cfg     = altuvm_avalon_mm_config::type_id::create("asm_avmm_agt_cfg");
      asm_avmm_agt_cfg.m_msg_id = "ASM_AVMM_CFG";
      `altuvm_set_config_db(altuvm_avalon_mm_config, "m_config", asm_avmm_agt_cfg, "asm_avmm_agt")
      asm_avmm_agt  = altuvm_avalon_mm_agent::type_id::create("asm_avmm_agt", this);
      asm_avmm_agt.set_rtb_path({"eth_env_top.",asm_avmm_rtb_path});
      asm_avmm_agt_cfg.set_command_timeout(3000);
      asm_avmm_agt_cfg.set_waitrequest_timeout(3000);

      p2p_reg_adpt  = altuvm_avalon_mm_reg_adapter::type_id::create("p2p_reg_adpt", this);
      p2p_reg_model = gdr_ehip_p2p_urm::type_id::create("p2p_reg_model", this);
      p2p_reg_predictor = altuvm_avalon_mm_reg_predictor::type_id::create("p2p_reg_predictor", this);
      p2p_reg_model.build();
      p2p_reg_model.reset();
      p2p_reg_model.config_map.set_auto_predict(0);
      p2p_reg_model.config_map.set_base_addr(`P2P_CFG_BASE_ADDR);
      p2p_reg_model.lock_model();

      asm_reg_adpt  = altuvm_avalon_mm_reg_adapter::type_id::create("asm_reg_adpt", this);
      asm_reg_model = gdr_ehip_asm_urm::type_id::create("asm_reg_model", this);
      asm_reg_predictor = altuvm_avalon_mm_reg_predictor::type_id::create("asm_reg_predictor", this);
      asm_reg_model.build();
      asm_reg_model.reset();
      asm_reg_model.config_map.set_auto_predict(0);
      asm_reg_model.config_map.set_base_addr(`ASM_CFG_BASE_ADDR);
      asm_reg_model.lock_model();
//  end
`endif
   m_axi_st_env = svt_axi_system_env::type_id::create("m_axi_st_env", this);
   if (!uvm_config_db#(svt_axi_system_configuration)::get(this, "", "m_axi_system_cfg", m_axi_system_cfg)) begin
      `uvm_error(get_name(), $sformatf("Failed to get m_axi_system_cfg"))
   end
endfunction: build_phase

function void eth_top_env::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   
   top_virtual_sequencer_inst.top_env = this;

   for(int i =0;i<num_inst ;i++)begin
      top_virtual_sequencer_inst.virtual_sequencer_inst[i]= env_ip[i].virtual_sequencer_inst;
      top_virtual_sequencer_inst.top_env = this;
      env_ip[i].virtual_sequencer_inst.top_env = this;
      env_ip[i].virtual_sequencer_inst.axi_mst_seqr = m_axi_st_env.master[0].sequencer;
   end // for (int i =0;i<`NUM_INST;i++)

   if (env_ip[0].dyn_rcfg_obj_inst.ptp==1) begin
       top_virtual_sequencer_inst.avmm_p2p_sqr = p2p_avmm_agt.m_sequencer;
       top_virtual_sequencer_inst.avmm_asm_sqr = asm_avmm_agt.m_sequencer;
       p2p_reg_model.config_map.set_sequencer( .sequencer( p2p_avmm_agt.m_sequencer),.adapter(p2p_reg_adpt ) );
       asm_reg_model.config_map.set_sequencer( .sequencer( asm_avmm_agt.m_sequencer),.adapter(asm_reg_adpt ) );
       p2p_reg_predictor.map =  p2p_reg_model.config_map;
       p2p_reg_predictor.adapter = p2p_reg_adpt;
       p2p_avmm_agt.monitor_ap.connect(p2p_reg_predictor.bus_in);
       asm_reg_predictor.map =  asm_reg_model.config_map;
       asm_reg_predictor.adapter = asm_reg_adpt;
       asm_avmm_agt.monitor_ap.connect(asm_reg_predictor.bus_in);

       for(int i =0;i<num_inst;i++)begin
           p2p_avmm_agt.monitor_ap.connect(env_ip[i].m_ptp_tx_ref_model.a_imp_avmm_p2p_mst);
           asm_avmm_agt.monitor_ap.connect(env_ip[i].m_ptp_tx_ref_model.a_imp_avmm_asm_mst);
       end // for (int i =0;i<`NUM_INST;i++)
   end

   if(kr_cfg_inst.is_speed_10g) begin
   kr10g_avmm_agt.monitor_ap.connect(anlt_reg_cov.avmm_bus_anlt);
     top_virtual_sequencer_inst.kr10g_sqr = kr10g_avmm_agt.m_sequencer;
     kr10g_reg_model.default_map.set_sequencer( .sequencer( kr10g_avmm_agt.m_sequencer),.adapter(kr10g_reg_adpt ) );
   end
   
   //kr25g_avmm_agt.monitor_ap.connect(anlt_reg_cov.avmm_bus_anlt);

   if(kr_cfg_inst.is_speed_25g) begin
   kr25g_avmm_agt.monitor_ap.connect(anlt_reg_cov.avmm_bus_anlt);
     top_virtual_sequencer_inst.kr25g_sqr = kr25g_avmm_agt.m_sequencer;
     kr25g_reg_model.default_map.set_sequencer( .sequencer( kr25g_avmm_agt.m_sequencer),.adapter(kr25g_reg_adpt ) );
   end
   if(kr_cfg_inst.is_speed_40g) begin
   kr40g_avmm_agt.monitor_ap.connect(anlt_reg_cov.avmm_bus_anlt);
     top_virtual_sequencer_inst.kr40g_sqr = kr40g_avmm_agt.m_sequencer;
     kr40g_reg_model.default_map.set_sequencer( .sequencer( kr40g_avmm_agt.m_sequencer),.adapter(kr40g_reg_adpt ) );
   end
   if(kr_cfg_inst.is_speed_50g) begin
   kr50g_avmm_agt.monitor_ap.connect(anlt_reg_cov.avmm_bus_anlt);
     top_virtual_sequencer_inst.kr50g_sqr = kr50g_avmm_agt.m_sequencer;
     kr50g_reg_model.default_map.set_sequencer( .sequencer( kr50g_avmm_agt.m_sequencer),.adapter(kr50g_reg_adpt ) );
   end
   if(kr_cfg_inst.is_speed_100g) begin
   kr100g_avmm_agt.monitor_ap.connect(anlt_reg_cov.avmm_bus_anlt);
     top_virtual_sequencer_inst.kr100g_sqr = kr100g_avmm_agt.m_sequencer;
     kr100g_reg_model.default_map.set_sequencer( .sequencer( kr100g_avmm_agt.m_sequencer),.adapter(kr100g_reg_adpt ) );
   end
   if(kr_cfg_inst.is_speed_200g) begin
   kr200g_avmm_agt.monitor_ap.connect(anlt_reg_cov.avmm_bus_anlt);
     top_virtual_sequencer_inst.kr200g_sqr = kr200g_avmm_agt.m_sequencer;
     kr200g_reg_model.default_map.set_sequencer( .sequencer( kr200g_avmm_agt.m_sequencer),.adapter(kr200g_reg_adpt ) );
   end
   if(kr_cfg_inst.is_speed_400g) begin
   kr400g_avmm_agt.monitor_ap.connect(anlt_reg_cov.avmm_bus_anlt);
     top_virtual_sequencer_inst.kr400g_sqr = kr400g_avmm_agt.m_sequencer;
     kr400g_reg_model.default_map.set_sequencer( .sequencer( kr400g_avmm_agt.m_sequencer),.adapter(kr400g_reg_adpt ) );
   end

endfunction: connect_phase



function void eth_top_env::start_of_simulation_phase(uvm_phase phase);
   super.start_of_simulation_phase(phase);
`ifdef UVM_VERSION_1_0
   uvm_top.print_topology();  
   factory.print();          
`endif
   
`ifdef UVM_VERSION_1_1
   uvm_root::get().print_topology(); 
   uvm_factory::get().print();      
`endif

`ifdef UVM_POST_VERSION_1_1
   uvm_root::get().print_topology(); 
   uvm_factory::get().print();      
`endif

   //ToDo : Implement this phase here 
endfunction: start_of_simulation_phase


task eth_top_env::reset_phase(uvm_phase phase);
   super.reset_phase(phase);
   //ToDo: Reset DUT
endtask:reset_phase

task eth_top_env::configure_phase (uvm_phase phase);
   super.configure_phase(phase);
   //ToDo: Configure components here
endtask:configure_phase

task eth_top_env::run_phase(uvm_phase phase);
   int byte_count;
   //int dist_between_two_starts;
   super.run_phase(phase);
   //ToDo: Run your simulation here*/
endtask:run_phase

function void eth_top_env::report_phase(uvm_phase phase);
   super.report_phase(phase);
   //ToDo: Implement this phase here
endfunction:report_phase

task eth_top_env::shutdown_phase(uvm_phase phase);
   super.shutdown_phase(phase);
   //ToDo: Implement this phase here
endtask:shutdown_phase


//================================ P2P RAL Function ===================================//
task eth_top_env::gdr_ral_write_p2p(string reg_name, uvm_reg_data_t addr, uvm_reg_data_t write_data);
     uvm_status_e    status;
     uvm_reg         reg_select;
     altuvm_avalon_mm_write_seq write_seq;

     reg_select = p2p_reg_model.get_reg_by_name(reg_name);
     if (reg_select != null)
     begin
         `uvm_info("AVMM REG WRITE", $sformatf("Register(%s) Name write data :'h%0h",reg_select.get_name(),write_data), UVM_MEDIUM)
         reg_select.write(status,.value(write_data), .map(p2p_reg_model.config_map));
     end
     else
     begin
         `uvm_warning("AVMM REG WRITE", $sformatf("No Registeri name found for p2p register for write data : %0h it seems reserved space",write_data));
         reg_select = p2p_reg_model.config_map.get_reg_by_offset(addr);
         if (reg_select != null)
         begin
             `uvm_info("AVMM REG WRITE", $sformatf("Register(%s) address 'h%0h write data :'h%0h",reg_select.get_name(),addr,write_data), UVM_NONE)
             reg_select.write(status,.value(write_data), .map(p2p_reg_model.config_map));
         end
         else
         begin
             `uvm_warning("AVMM REG WRITE", $sformatf("No Register found with address :%0h, write data : %0h it seems reserved space",addr,write_data));
             write_seq = altuvm_avalon_mm_write_seq::type_id::create("write");
             write_seq.set_sequencer( top_virtual_sequencer_inst.avmm_p2p_sqr );
             write_seq.randomize() with {
                 init_latency inside {[0:3]};
                 address   == addr<<2;
                 foreach (byteenable[i]) byteenable[i] == 1;
                 writedata[0] == write_data[7:0];
                 writedata[1] == write_data[15:8];
                 writedata[2] == write_data[23:16];
                 writedata[3] == write_data[31:24];
             };
             write_seq.start(top_virtual_sequencer_inst.status_seqr);
         end
     end
endtask

task eth_top_env::gdr_ral_read_p2p(string reg_name,ref uvm_reg_data_t read_data);
     uvm_status_e    status;
     uvm_reg         reg_select;

     reg_select = p2p_reg_model.get_reg_by_name(reg_name);
     reg_select.read(status,.value(read_data), .map(p2p_reg_model.config_map));
endtask

function int eth_top_env::gdr_ral_offset_p2p(string reg_name);
    uvm_reg     reg_select;

    reg_select = p2p_reg_model.get_reg_by_name(reg_name);
     return reg_select.get_offset();
endfunction

function int eth_top_env::gdr_ral_get_p2p(string reg_name, string field_name);
    uvm_reg_field reg_field;
    uvm_reg       reg_select;

    reg_select = p2p_reg_model.get_reg_by_name(reg_name);
     if(field_name == "")
       return reg_select.get();
     else begin
       reg_field = reg_select.get_field_by_name(field_name);
       return reg_field.get();
     end
endfunction

function void eth_top_env::gdr_ral_predict_p2p(string reg_name, string field_name, uvm_reg_data_t reg_data, uvm_predict_e kind);
    uvm_reg   reg_select;

    reg_select = p2p_reg_model.get_reg_by_name(reg_name);
    reg_select.predict(.value(reg_data), .kind(kind), .map(p2p_reg_model.config_map));
     return;
endfunction

function void eth_top_env::gdr_ral_set_reset_p2p(string reg_name, string field_name, int field_val);
    uvm_reg_field  reg_field;
    uvm_reg        reg_select;

    reg_select = p2p_reg_model.get_reg_by_name(reg_name);
    reg_field  = reg_select.get_field_by_name(field_name);
    reg_field.set_reset(field_val);
    return;
endfunction

function void eth_top_env::gdr_ral_set_p2p(string reg_name, string field_name, int field_val);
    uvm_reg_field  reg_field;
    uvm_reg        reg_select;

    reg_select = p2p_reg_model.get_reg_by_name(reg_name);

    reg_field  = reg_select.get_field_by_name(field_name);
    reg_field.set(field_val);
    return;
endfunction

function void eth_top_env::gdr_ral_reset_p2p(string reg_name, string field_name);
    uvm_reg_field  reg_field;
    uvm_reg        reg_select;

    reg_select = p2p_reg_model.get_reg_by_name(reg_name);

    if(field_name == "")
        reg_select.reset();
    else begin
        reg_field  = reg_select.get_field_by_name(field_name);
        reg_field.reset();
    end
    return;
endfunction

task eth_top_env::reg_read_p2p(string reg_name,ref uvm_reg_data_t read_data,input bit[1:0] disable_check=0,uvm_reg_byte_en_t byte_enable='hf);

        uvm_status_e      status;
        uvm_reg         regs[$];
        uvm_reg         select_reg;
        altuvm_avalon_mm_read_seq           read_seq;
        bit [31:0] rsvd_val = 'd0;
        int masked_val;
        bit[31:0] byte_en_mask;
        uvm_reg_data_t mir_data;

        gdr_ral_read_p2p(reg_name,read_data);

        select_reg = p2p_reg_model.get_reg_by_name(reg_name);
        mir_data = select_reg.get_mirrored_value();

        if(disable_check == 0)begin
                if(mir_data != read_data) begin
                        `uvm_error("AVMM P2P REG READ", $sformatf("Register(%s) read data mismatch",select_reg.get_name()));
                end else begin
         `uvm_info("AVMM P2P REG READ", $sformatf("Register(%s) read data matches with read value %0h",select_reg.get_name(),read_data),UVM_MEDIUM)
      end
        end

endtask: reg_read_p2p
//================================ P2P RAL Function ===================================//

//================================ ASM RAL Function ===================================//
task eth_top_env::gdr_ral_write_asm(string reg_name, uvm_reg_data_t addr, uvm_reg_data_t write_data);
     uvm_status_e    status;
     uvm_reg         reg_select;
     altuvm_avalon_mm_write_seq write_seq;

     reg_select = asm_reg_model.get_reg_by_name(reg_name);
     if (reg_select != null)
     begin
         `uvm_info("AVMM REG WRITE", $sformatf("Register(%s) Name write data :'h%0h",reg_select.get_name(),write_data), UVM_MEDIUM)
         reg_select.write(status,.value(write_data), .map(asm_reg_model.config_map));
     end
     else
     begin
         `uvm_warning("AVMM REG WRITE", $sformatf("No Registeri name found for ASM register for write data : %0h it seems reserved space",write_data));
         reg_select = asm_reg_model.config_map.get_reg_by_offset(addr);
         if (reg_select != null)
         begin
             `uvm_info("AVMM REG WRITE", $sformatf("Register(%s) address 'h%0h write data :'h%0h",reg_select.get_name(),addr,write_data), UVM_NONE)
             reg_select.write(status,.value(write_data), .map(asm_reg_model.config_map));
         end
         else
         begin
             `uvm_warning("AVMM REG WRITE", $sformatf("No Register found with address :%0h, write data : %0h it seems reserved space",addr,write_data));
             write_seq = altuvm_avalon_mm_write_seq::type_id::create("write");
             write_seq.set_sequencer( top_virtual_sequencer_inst.avmm_asm_sqr );
             write_seq.randomize() with {
                 init_latency inside {[0:3]};
                 address   == addr<<2;
                 foreach (byteenable[i]) byteenable[i] == 1;
                 writedata[0] == write_data[7:0];
                 writedata[1] == write_data[15:8];
                 writedata[2] == write_data[23:16];
                 writedata[3] == write_data[31:24];
             };
             write_seq.start(top_virtual_sequencer_inst.status_seqr);
         end
     end
endtask

task eth_top_env::gdr_ral_read_asm(string reg_name,ref uvm_reg_data_t read_data);
     uvm_status_e    status;
     uvm_reg         reg_select;

     reg_select = asm_reg_model.get_reg_by_name(reg_name);
     reg_select.read(status,.value(read_data), .map(asm_reg_model.config_map));
endtask

function int eth_top_env::gdr_ral_offset_asm(string reg_name);
    uvm_reg     reg_select;

    reg_select = asm_reg_model.get_reg_by_name(reg_name);
     return reg_select.get_offset();
endfunction

function int eth_top_env::gdr_ral_get_asm(string reg_name, string field_name);
    uvm_reg_field reg_field;
    uvm_reg       reg_select;

    reg_select = asm_reg_model.get_reg_by_name(reg_name);
     if(field_name == "")
       return reg_select.get();
     else begin
       reg_field = reg_select.get_field_by_name(field_name);
       return reg_field.get();
     end
endfunction

function void eth_top_env::gdr_ral_predict_asm(string reg_name, string field_name, uvm_reg_data_t reg_data, uvm_predict_e kind);
    uvm_reg   reg_select;

    reg_select = asm_reg_model.get_reg_by_name(reg_name);
    reg_select.predict(.value(reg_data), .kind(kind), .map(asm_reg_model.config_map));
     return;
endfunction

function void eth_top_env::gdr_ral_set_reset_asm(string reg_name, string field_name, int field_val);
    uvm_reg_field  reg_field;
    uvm_reg        reg_select;

    reg_select = asm_reg_model.get_reg_by_name(reg_name);
    reg_field  = reg_select.get_field_by_name(field_name);
    reg_field.set_reset(field_val);
    return;
endfunction

function void eth_top_env::gdr_ral_set_asm(string reg_name, string field_name, int field_val);
    uvm_reg_field  reg_field;
    uvm_reg        reg_select;

    reg_select = asm_reg_model.get_reg_by_name(reg_name);

    reg_field  = reg_select.get_field_by_name(field_name);
    reg_field.set(field_val);
    return;
endfunction

function void eth_top_env::gdr_ral_reset_asm(string reg_name, string field_name);
    uvm_reg_field  reg_field;
    uvm_reg        reg_select;

    reg_select = asm_reg_model.get_reg_by_name(reg_name);

    if(field_name == "")
        reg_select.reset();
    else begin
        reg_field  = reg_select.get_field_by_name(field_name);
        reg_field.reset();
    end
    return;
endfunction

task eth_top_env::reg_read_asm(string reg_name,ref uvm_reg_data_t read_data,input bit[1:0] disable_check=0,uvm_reg_byte_en_t byte_enable='hf);

        uvm_status_e      status;
        uvm_reg         regs[$];
        uvm_reg         select_reg;
        altuvm_avalon_mm_read_seq           read_seq;
        bit [31:0] rsvd_val = 'd0;
        int masked_val;
        bit[31:0] byte_en_mask;
        uvm_reg_data_t mir_data;

        gdr_ral_read_asm(reg_name,read_data);

        select_reg = asm_reg_model.get_reg_by_name(reg_name);
        mir_data = select_reg.get_mirrored_value();

        if(disable_check == 0)begin
                if(mir_data != read_data) begin
                        `uvm_error("AVMM ASM REG READ", $sformatf("Register(%s) read data mismatch",select_reg.get_name()));
                end else begin
         `uvm_info("AVMM ASM REG READ", $sformatf("Register(%s) read data matches with read value %0h",select_reg.get_name(),read_data),UVM_MEDIUM)
      end
        end

endtask: reg_read_asm

task eth_top_env::write_asym_p2p_latency(bit [23:0] asym_lat= 130, bit [23:0] p2p_lat= 131, bit rand_asym_p2p_lat= 1);

   `uvm_info("asym_p2p_latency", $psprintf("Start the write_asym_p2p_latency task"), UVM_MEDIUM)
     fork
     begin
        string tx_reg_asm;
        for (int i = 0; i < 128; i ++) begin
            if (rand_asym_p2p_lat) begin
                asym_lat = $urandom_range(24'h000080,24'hffffff);
            end
            tx_reg_asm = {"tx_asm",$sformatf("%0d",i)};
            gdr_ral_write_asm($sformatf("%s", tx_reg_asm), ('h0040 + ('h4 * i)), asym_lat);
            `uvm_info("asym_p2p_latency", $psprintf(" Writing tx_ptp_asym_latency register %s with %0d ", tx_reg_asm, asym_lat), UVM_MEDIUM)
        end
     end
     begin
        string tx_reg_p2p;
        for (int i = 0; i < 128; i ++) begin
            if (rand_asym_p2p_lat) begin
                p2p_lat = $urandom_range(24'h000080,24'hffffff);
            end
            tx_reg_p2p = {"tx_p2p",$sformatf("%0d",i)};
            gdr_ral_write_p2p($sformatf("%s", tx_reg_p2p), ('h0040 + ('h4 * i)), p2p_lat);
            `uvm_info("asym_p2p_latency", $psprintf(" Writing tx_ptp_p2p_latency register %s with %0d ", tx_reg_p2p, p2p_lat), UVM_MEDIUM)
        end
     end
     join

   `uvm_info("asym_p2p_latency", $psprintf("Completed the write_asym_p2p_latency task"), UVM_MEDIUM)

  endtask : write_asym_p2p_latency

task eth_top_env::read_asym_p2p_latency(bit compare_dis = 0);

        uvm_reg_data_t read_data;

        `uvm_info("asym_p2p_latency", $psprintf("Start the read_asym_p2p_latency task"), UVM_MEDIUM)

        fork
        begin
                string tx_reg_asm;
                for (int i = 0; i < 128; i ++) begin
                        tx_reg_asm = {"tx_asm",$sformatf("%0d",i)};
                        reg_read_asm($sformatf("%s", tx_reg_asm), read_data);
                end
        end
        begin
                string tx_reg_p2p;
                for (int i = 0; i < 128; i ++) begin
                        tx_reg_p2p = {"tx_p2p",$sformatf("%0d",i)};
                        reg_read_p2p($sformatf("%s", tx_reg_p2p), read_data);
                end
        end
        join

        `uvm_info("asym_p2p_latency", $psprintf("Completed the read_asym_p2p_latency task"), UVM_MEDIUM)

endtask: read_asym_p2p_latency

//================================ ASM RAL Function ===================================//



`endif // ETH_TOP_ENV__SV
