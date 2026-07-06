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



 class mac_cfg_txmac_saddrl_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_cfg_txmac_saddrl_urm  )
 
       rand uvm_reg_field mac_address;
 
       // Constructor
       function new(string name = "mac_cfg_txmac_saddrl_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          mac_address = uvm_reg_field::type_id::create("mac_address");
          // configure
          mac_address.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_cfg_txmac_saddrl_urm
       
       
       
 class mac_cfg_txmac_saddrh_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_cfg_txmac_saddrh_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field mac_address_upper;
 
       // Constructor
       function new(string name = "mac_cfg_txmac_saddrh_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          mac_address_upper = uvm_reg_field::type_id::create("mac_address_upper");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          // configure
          mac_address_upper.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
 
       endfunction : build
 
       
 endclass : mac_cfg_txmac_saddrh_urm
       
       
       
 class mac_reset_control_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_reset_control_urm  )
 
       rand uvm_reg_field Reserved2;
       rand uvm_reg_field rx_datapath_reset;
       rand uvm_reg_field Reserved1;
       rand uvm_reg_field tx_datapath_reset;
 
       // Constructor
       function new(string name = "mac_reset_control_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved2 = uvm_reg_field::type_id::create("Reserved2");
          rx_datapath_reset = uvm_reg_field::type_id::create("rx_datapath_reset");
          Reserved1 = uvm_reg_field::type_id::create("Reserved1");
          tx_datapath_reset = uvm_reg_field::type_id::create("tx_datapath_reset");
          // configure
          Reserved2.configure(
          .parent                 ( this ),
          .size                   (23),
          .lsb_pos                (9),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_datapath_reset.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (8),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          Reserved1.configure(
          .parent                 ( this ),
          .size                   (7),
          .lsb_pos                (1),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_datapath_reset.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_reset_control_urm
       
       
       
 class tx_packet_control_urm  extends uvm_reg;
 
       `uvm_object_utils(tx_packet_control_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field configure_tx_path;
 
       // Constructor
       function new(string name = "tx_packet_control_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          configure_tx_path = uvm_reg_field::type_id::create("configure_tx_path");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (31),
          .lsb_pos                (1),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          configure_tx_path.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : tx_packet_control_urm
       
       
       
 class tx_transfer_status_urm  extends uvm_reg;
 
       `uvm_object_utils(tx_transfer_status_urm  )
 
       rand uvm_reg_field Reserved3;
       rand uvm_reg_field tx_dataptah_reset_status;
       rand uvm_reg_field Reserved2;
       rand uvm_reg_field tx_datapath_status;
       rand uvm_reg_field Reserved1;
 
       // Constructor
       function new(string name = "tx_transfer_status_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved3 = uvm_reg_field::type_id::create("Reserved3");
          tx_dataptah_reset_status = uvm_reg_field::type_id::create("tx_dataptah_reset_status");
          Reserved2 = uvm_reg_field::type_id::create("Reserved2");
          tx_datapath_status = uvm_reg_field::type_id::create("tx_datapath_status");
          Reserved1 = uvm_reg_field::type_id::create("Reserved1");
          // configure
          Reserved3.configure(
          .parent                 ( this ),
          .size                   (19),
          .lsb_pos                (13),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_dataptah_reset_status.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (12),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          Reserved2.configure(
          .parent                 ( this ),
          .size                   (3),
          .lsb_pos                (9),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_datapath_status.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (8),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          Reserved1.configure(
          .parent                 ( this ),
          .size                   (8),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : tx_transfer_status_urm
       
       
       
 class tx_pad_control_urm  extends uvm_reg;
 
       `uvm_object_utils(tx_pad_control_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field pad_insertion_en;
 
       // Constructor
       function new(string name = "tx_pad_control_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          pad_insertion_en = uvm_reg_field::type_id::create("pad_insertion_en");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (31),
          .lsb_pos                (1),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          pad_insertion_en.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (1),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : tx_pad_control_urm
       
       
       
 class tx_crc_control_urm  extends uvm_reg;
 
       `uvm_object_utils(tx_crc_control_urm  )
 
       rand uvm_reg_field Reserved2;
       rand uvm_reg_field crc_insertion;
       rand uvm_reg_field Reserved1;
 
       // Constructor
       function new(string name = "tx_crc_control_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved2 = uvm_reg_field::type_id::create("Reserved2");
          crc_insertion = uvm_reg_field::type_id::create("crc_insertion");
          Reserved1 = uvm_reg_field::type_id::create("Reserved1");
          // configure
          Reserved2.configure(
          .parent                 ( this ),
          .size                   (30),
          .lsb_pos                (2),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          crc_insertion.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (1),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (1),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          Reserved1.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (1),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : tx_crc_control_urm
       
       
       
 class tx_preamble_control_urm  extends uvm_reg;//updated access from RW to RO because these register is updated when passthrough preamble is 1
 
       `uvm_object_utils(tx_preamble_control_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field preamble_passthorugh;
 
       // Constructor
       function new(string name = "tx_preamble_control_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          preamble_passthorugh = uvm_reg_field::type_id::create("preamble_passthorugh");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (31),
          .lsb_pos                (1),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          preamble_passthorugh.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : tx_preamble_control_urm
       
       
       
 class tx_src_addr_override_urm  extends uvm_reg;
 
       `uvm_object_utils(tx_src_addr_override_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field src_addr_override;
 
       // Constructor
       function new(string name = "tx_src_addr_override_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          src_addr_override = uvm_reg_field::type_id::create("src_addr_override");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (31),
          .lsb_pos                (1),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          src_addr_override.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : tx_src_addr_override_urm
       
       
       
 class mac_cfg_max_tx_size_config_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_cfg_max_tx_size_config_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_frame_length;
 
       // Constructor
       function new(string name = "mac_cfg_max_tx_size_config_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_frame_length = uvm_reg_field::type_id::create("tx_frame_length");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_frame_length.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (16'b010111101110),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_cfg_max_tx_size_config_urm
       
       
       
 class tx_vlan_detection_urm  extends uvm_reg;
 
       `uvm_object_utils(tx_vlan_detection_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_vlan_detection_disable;
 
       // Constructor
       function new(string name = "tx_vlan_detection_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_vlan_detection_disable = uvm_reg_field::type_id::create("tx_vlan_detection_disable");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (31),
          .lsb_pos                (1),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_vlan_detection_disable.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : tx_vlan_detection_urm
       
       
       
 class tx_ipg_10g_urm  extends uvm_reg;
 
       `uvm_object_utils(tx_ipg_10g_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field Reserved1;
       rand uvm_reg_field avg_ipg_10g;
 
       // Constructor
       function new(string name = "tx_ipg_10g_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          Reserved1 = uvm_reg_field::type_id::create("Reserved1");
          avg_ipg_10g = uvm_reg_field::type_id::create("avg_ipg_10g");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (24),
          .lsb_pos                (8),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));

	       Reserved1.configure(
          .parent                 ( this ),
          .size                   (7),
          .lsb_pos                (1),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));

          
          avg_ipg_10g.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (1),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : tx_ipg_10g_urm
       
       
       
 class tx_ipg_10M_100M_1G_urm  extends uvm_reg;
 
       `uvm_object_utils(tx_ipg_10M_100M_1G_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field ipg_10M_100M_1g;
 
       // Constructor
       function new(string name = "tx_ipg_10M_100M_1G_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          ipg_10M_100M_1g = uvm_reg_field::type_id::create("ipg_10M_100M_1g");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (24),
          .lsb_pos                (8),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          ipg_10M_100M_1g.configure(
          .parent                 ( this ),
          .size                   (8),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  ('b00001100),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : tx_ipg_10M_100M_1G_urm
       
       
       
 class tx_underflow_counter0_urm  extends uvm_reg;
 
       `uvm_object_utils(tx_underflow_counter0_urm  )
 
       rand uvm_reg_field underflow_counter_lo;
 
       // Constructor
       function new(string name = "tx_underflow_counter0_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          underflow_counter_lo = uvm_reg_field::type_id::create("underflow_counter_lo");
          // configure
          underflow_counter_lo.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : tx_underflow_counter0_urm
       
       
       
 class tx_underflow_counter1_urm  extends uvm_reg;
 
       `uvm_object_utils(tx_underflow_counter1_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field underflow_counter_hi;
 
       // Constructor
       function new(string name = "tx_underflow_counter1_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          underflow_counter_hi = uvm_reg_field::type_id::create("underflow_counter_hi");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          underflow_counter_hi.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : tx_underflow_counter1_urm
       
       
       
 class tx_pauseframe_control_urm  extends uvm_reg;
 
       `uvm_object_utils(tx_pauseframe_control_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field pause_frame_config;
 
       // Constructor
       function new(string name = "tx_pauseframe_control_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          pause_frame_config = uvm_reg_field::type_id::create("pause_frame_config");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (30),
          .lsb_pos                (2),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          pause_frame_config.configure(
          .parent                 ( this ),
          .size                   (2),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : tx_pauseframe_control_urm
       
       
       
 class mac_cfg_tx_pause_quanta_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_cfg_tx_pause_quanta_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_pause_quanta;
 
       // Constructor
       function new(string name = "mac_cfg_tx_pause_quanta_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_pause_quanta = uvm_reg_field::type_id::create("tx_pause_quanta");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_pause_quanta.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_cfg_tx_pause_quanta_urm
       
       
       
 class mac_cfg_retransmit_xoff_holdoff_quanta_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_cfg_retransmit_xoff_holdoff_quanta_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field xoff_quanta_gap;
 
       // Constructor
       function new(string name = "mac_cfg_retransmit_xoff_holdoff_quanta_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          xoff_quanta_gap = uvm_reg_field::type_id::create("xoff_quanta_gap");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          xoff_quanta_gap.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (1),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_cfg_retransmit_xoff_holdoff_quanta_urm
       
       
       
 class tx_pauseframe_enable_urm  extends uvm_reg;
 
       `uvm_object_utils(tx_pauseframe_enable_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field pauseframe_request;
       rand uvm_reg_field pause_frame_enable;
 
       // Constructor
       function new(string name = "tx_pauseframe_enable_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          pauseframe_request = uvm_reg_field::type_id::create("pauseframe_request");
          pause_frame_enable = uvm_reg_field::type_id::create("pause_frame_enable");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (29),
          .lsb_pos                (3),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          pauseframe_request.configure(
          .parent                 ( this ),
          .size                   (2),
          .lsb_pos                (1),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (2'b00),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          pause_frame_enable.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (1'b1),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : tx_pauseframe_enable_urm
       
       
       
 class tx_pfc_priority_enable_urm  extends uvm_reg; //updated access from RW to RO because these register not enabled in these version of ip
 
       `uvm_object_utils(tx_pfc_priority_enable_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_pfc_enable;
 
       // Constructor
       function new(string name = "tx_pfc_priority_enable_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_pfc_enable = uvm_reg_field::type_id::create("tx_pfc_enable");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (24),
          .lsb_pos                (8),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_pfc_enable.configure(
          .parent                 ( this ),
          .size                   (8),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : tx_pfc_priority_enable_urm
       
       
       
 class mac_cfg_pfc_pause_quanta_0_urm  extends uvm_reg;//updated access from RW to RO because these register is not enabled in these version of IP
 
       `uvm_object_utils(mac_cfg_pfc_pause_quanta_0_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field pfc_pause_quanta_0;
 
       // Constructor
       function new(string name = "mac_cfg_pfc_pause_quanta_0_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          pfc_pause_quanta_0 = uvm_reg_field::type_id::create("pfc_pause_quanta_0");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          pfc_pause_quanta_0.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_cfg_pfc_pause_quanta_0_urm
       
       
       
 class mac_cfg_pfc_pause_quanta_1_urm  extends uvm_reg;//updated access from RW to RO because these register is not enabled in these version of IP
 
       `uvm_object_utils(mac_cfg_pfc_pause_quanta_1_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field pfc_pause_quanta_1;
 
       // Constructor
       function new(string name = "mac_cfg_pfc_pause_quanta_1_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          pfc_pause_quanta_1 = uvm_reg_field::type_id::create("pfc_pause_quanta_1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          pfc_pause_quanta_1.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_cfg_pfc_pause_quanta_1_urm
       
       
       
 class mac_cfg_pfc_pause_quanta_2_urm  extends uvm_reg;//updated access from RW to RO because these register is not enabled in these version of IP
 
       `uvm_object_utils(mac_cfg_pfc_pause_quanta_2_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field pfc_pause_quanta_2;
 
       // Constructor
       function new(string name = "mac_cfg_pfc_pause_quanta_2_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          pfc_pause_quanta_2 = uvm_reg_field::type_id::create("pfc_pause_quanta_2");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          pfc_pause_quanta_2.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_cfg_pfc_pause_quanta_2_urm
       
       
       
 class mac_cfg_pfc_pause_quanta_3_urm  extends uvm_reg;//updated access from RW to RO because these register is not enabled in these version of IP
 
       `uvm_object_utils(mac_cfg_pfc_pause_quanta_3_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field pfc_pause_quanta_3;
 
       // Constructor
       function new(string name = "mac_cfg_pfc_pause_quanta_3_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          pfc_pause_quanta_3 = uvm_reg_field::type_id::create("pfc_pause_quanta_3");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          pfc_pause_quanta_3.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_cfg_pfc_pause_quanta_3_urm
       
       
       
 class mac_cfg_pfc_pause_quanta_4_urm  extends uvm_reg;//updated access from RW to RO because these register is not enabled in these version of IP
 
       `uvm_object_utils(mac_cfg_pfc_pause_quanta_4_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field pfc_pause_quanta_4;
 
       // Constructor
       function new(string name = "mac_cfg_pfc_pause_quanta_4_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          pfc_pause_quanta_4 = uvm_reg_field::type_id::create("pfc_pause_quanta_4");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          pfc_pause_quanta_4.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_cfg_pfc_pause_quanta_4_urm
       
       
       
 class mac_cfg_pfc_pause_quanta_5_urm  extends uvm_reg;//updated access from RW to RO because these register is not enabled in these version of IP
 
       `uvm_object_utils(mac_cfg_pfc_pause_quanta_5_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field pfc_pause_quanta_5;
 
       // Constructor
       function new(string name = "mac_cfg_pfc_pause_quanta_5_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          pfc_pause_quanta_5 = uvm_reg_field::type_id::create("pfc_pause_quanta_5");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          pfc_pause_quanta_5.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_cfg_pfc_pause_quanta_5_urm
       
       
       
 class mac_cfg_pfc_pause_quanta_6_urm  extends uvm_reg;//updated access from RW to RO because these register is not enabled in these version of IP
 
       `uvm_object_utils(mac_cfg_pfc_pause_quanta_6_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field pfc_pause_quanta_6;
 
       // Constructor
       function new(string name = "mac_cfg_pfc_pause_quanta_6_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          pfc_pause_quanta_6 = uvm_reg_field::type_id::create("pfc_pause_quanta_6");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          pfc_pause_quanta_6.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_cfg_pfc_pause_quanta_6_urm
       
       
       
 class mac_cfg_pfc_pause_quanta_7_urm  extends uvm_reg;//updated access from RW to RO because these register is not enabled in these version of IP
 
       `uvm_object_utils(mac_cfg_pfc_pause_quanta_7_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field pfc_pause_quanta_7;
 
       // Constructor
       function new(string name = "mac_cfg_pfc_pause_quanta_7_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          pfc_pause_quanta_7 = uvm_reg_field::type_id::create("pfc_pause_quanta_7");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          pfc_pause_quanta_7.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_cfg_pfc_pause_quanta_7_urm
       
       
       
 class mac_cfg_pfc_holdoff_quanta_0_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_cfg_pfc_holdoff_quanta_0_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field pfc_holdoff_quanta_0;
 
       // Constructor
       function new(string name = "mac_cfg_pfc_holdoff_quanta_0_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          pfc_holdoff_quanta_0 = uvm_reg_field::type_id::create("pfc_holdoff_quanta_0");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          pfc_holdoff_quanta_0.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (1),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_cfg_pfc_holdoff_quanta_0_urm
       
       
       
 class mac_cfg_pfc_holdoff_quanta_1_urm  extends uvm_reg;//updated access from RW to RO because these register is not enabled in these version of IP
 
       `uvm_object_utils(mac_cfg_pfc_holdoff_quanta_1_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field pfc_holdoff_quanta_1;
 
       // Constructor
       function new(string name = "mac_cfg_pfc_holdoff_quanta_1_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          pfc_holdoff_quanta_1 = uvm_reg_field::type_id::create("pfc_holdoff_quanta_1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          pfc_holdoff_quanta_1.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (1),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_cfg_pfc_holdoff_quanta_1_urm
       
       
       
 class mac_cfg_pfc_holdoff_quanta_2_urm  extends uvm_reg;//updated access from RW to RO because these register is not enabled in these version of IP
 
       `uvm_object_utils(mac_cfg_pfc_holdoff_quanta_2_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field pfc_holdoff_quanta_2;
 
       // Constructor
       function new(string name = "mac_cfg_pfc_holdoff_quanta_2_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          pfc_holdoff_quanta_2 = uvm_reg_field::type_id::create("pfc_holdoff_quanta_2");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          pfc_holdoff_quanta_2.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (1),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_cfg_pfc_holdoff_quanta_2_urm
       
       
       
 class mac_cfg_pfc_holdoff_quanta_3_urm  extends uvm_reg;//updated access from RW to RO because these register is not enabled in these version of IP
 
       `uvm_object_utils(mac_cfg_pfc_holdoff_quanta_3_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field pfc_holdoff_quanta_3;
 
       // Constructor
       function new(string name = "mac_cfg_pfc_holdoff_quanta_3_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          pfc_holdoff_quanta_3 = uvm_reg_field::type_id::create("pfc_holdoff_quanta_3");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          pfc_holdoff_quanta_3.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (1),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_cfg_pfc_holdoff_quanta_3_urm
       
       
       
 class mac_cfg_pfc_holdoff_quanta_4_urm  extends uvm_reg;//updated access from RW to RO because these register is not enabled in these version of IP
 
       `uvm_object_utils(mac_cfg_pfc_holdoff_quanta_4_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field pfc_holdoff_quanta_4;
 
       // Constructor
       function new(string name = "mac_cfg_pfc_holdoff_quanta_4_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          pfc_holdoff_quanta_4 = uvm_reg_field::type_id::create("pfc_holdoff_quanta_4");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          pfc_holdoff_quanta_4.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (1),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_cfg_pfc_holdoff_quanta_4_urm
       
       
       
 class mac_cfg_pfc_holdoff_quanta_5_urm  extends uvm_reg;//updated access from RW to RO because these register is not enabled in these version of IP
 
       `uvm_object_utils(mac_cfg_pfc_holdoff_quanta_5_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field pfc_holdoff_quanta_5;
 
       // Constructor
       function new(string name = "mac_cfg_pfc_holdoff_quanta_5_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          pfc_holdoff_quanta_5 = uvm_reg_field::type_id::create("pfc_holdoff_quanta_5");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          pfc_holdoff_quanta_5.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (1),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_cfg_pfc_holdoff_quanta_5_urm
       
       
       
 class mac_cfg_pfc_holdoff_quanta_6_urm  extends uvm_reg;//updated access from RW to RO because these register is not enabled in these version of IP
 
       `uvm_object_utils(mac_cfg_pfc_holdoff_quanta_6_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field pfc_holdoff_quanta_6;
 
       // Constructor
       function new(string name = "mac_cfg_pfc_holdoff_quanta_6_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          pfc_holdoff_quanta_6 = uvm_reg_field::type_id::create("pfc_holdoff_quanta_6");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          pfc_holdoff_quanta_6.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (1),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_cfg_pfc_holdoff_quanta_6_urm
       
       
       
 class mac_cfg_pfc_holdoff_quanta_7_urm  extends uvm_reg;//updated access from RW to RO because these register is not enabled in these version of IP
 
       `uvm_object_utils(mac_cfg_pfc_holdoff_quanta_7_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field pfc_holdoff_quanta_7;
 
       // Constructor
       function new(string name = "mac_cfg_pfc_holdoff_quanta_7_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          pfc_holdoff_quanta_7 = uvm_reg_field::type_id::create("pfc_holdoff_quanta_7");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          pfc_holdoff_quanta_7.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (1),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_cfg_pfc_holdoff_quanta_7_urm
       
       
       
 class tx_unidir_control_urm  extends uvm_reg;//updated access from RW to RO because these register is not enabled in these version of IP
 
       `uvm_object_utils(tx_unidir_control_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field remote_fault_notify;
       rand uvm_reg_field remote_fault_gen;
       rand uvm_reg_field unidir_en;
 
       // Constructor
       function new(string name = "tx_unidir_control_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          remote_fault_notify = uvm_reg_field::type_id::create("remote_fault_notify");
          remote_fault_gen = uvm_reg_field::type_id::create("remote_fault_gen");
          unidir_en = uvm_reg_field::type_id::create("unidir_en");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (29),
          .lsb_pos                (3),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          remote_fault_notify.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (2),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          remote_fault_gen.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (1),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          unidir_en.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : tx_unidir_control_urm
       
       
       
 class rx_transfer_control_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_transfer_control_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rxpath_en;
 
       // Constructor
       function new(string name = "rx_transfer_control_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rxpath_en = uvm_reg_field::type_id::create("rxpath_en");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (31),
          .lsb_pos                (1),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rxpath_en.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_transfer_control_urm
       
       
       
 class rx_transfer_status_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_transfer_status_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_datapath_reset_status;
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_datapath_status;
       rand uvm_reg_field Reserved;
 
       // Constructor
       function new(string name = "rx_transfer_status_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_datapath_reset_status = uvm_reg_field::type_id::create("rx_datapath_reset_status");
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_datapath_status = uvm_reg_field::type_id::create("rx_datapath_status");
          Reserved = uvm_reg_field::type_id::create("Reserved");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (19),
          .lsb_pos                (13),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_datapath_reset_status.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (12),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          Reserved.configure(
          .parent                 ( this ),
          .size                   (3),
          .lsb_pos                (9),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_datapath_status.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (8),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          Reserved.configure(
          .parent                 ( this ),
          .size                   (8),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_transfer_status_urm
       
       
       
 class rx_padcrc_control_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_padcrc_control_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_pad_crc_removal;
 
       // Constructor
       function new(string name = "rx_padcrc_control_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_pad_crc_removal = uvm_reg_field::type_id::create("rx_pad_crc_removal");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (30),
          .lsb_pos                (2),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_pad_crc_removal.configure(
          .parent                 ( this ),
          .size                   (2),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (2'b01),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_padcrc_control_urm
       
       
       
 class rx_crccheck_control_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_crccheck_control_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field crc_check_en;
       rand uvm_reg_field Reserved;
 
       // Constructor
       function new(string name = "rx_crccheck_control_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          crc_check_en = uvm_reg_field::type_id::create("crc_check_en");
          Reserved = uvm_reg_field::type_id::create("Reserved");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (30),
          .lsb_pos                (2),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          crc_check_en.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (1),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (1),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          Reserved.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_crccheck_control_urm
       
       
       
 class rx_custom_preamble_forward_urm  extends uvm_reg;//updated access from RW to RO because register will update only when passthrough preamble is 1
 
       `uvm_object_utils(rx_custom_preamble_forward_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field forward_preamble;
 
       // Constructor
       function new(string name = "rx_custom_preamble_forward_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          forward_preamble = uvm_reg_field::type_id::create("forward_preamble");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (31),
          .lsb_pos                (1),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          forward_preamble.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_custom_preamble_forward_urm
       
       
       
 class rx_preamble_control_urm  extends uvm_reg;//updated access from RW to RO because register will update only when passthrough preamble is 1
 
       `uvm_object_utils(rx_preamble_control_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field en_pp;
 
       // Constructor
       function new(string name = "rx_preamble_control_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          en_pp = uvm_reg_field::type_id::create("en_pp");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (31),
          .lsb_pos                (1),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          en_pp.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_preamble_control_urm
       
       
       
 class rx_frame_control_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_frame_control_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field EN_SUPP3;
       rand uvm_reg_field EN_SUPP2;
       rand uvm_reg_field EN_SUPP1;
       rand uvm_reg_field EN_SUPP0;
       rand uvm_reg_field Reserved;
       rand uvm_reg_field IGNORE_PAUSE;
       rand uvm_reg_field FWD_PAUSE;
       rand uvm_reg_field FWD_CONTROL;
       rand uvm_reg_field Reserved;
       rand uvm_reg_field EN_ALLMCAST;
       rand uvm_reg_field EN_ALLUCAST;
 
       // Constructor
       function new(string name = "rx_frame_control_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          EN_SUPP3 = uvm_reg_field::type_id::create("EN_SUPP3");
          EN_SUPP2 = uvm_reg_field::type_id::create("EN_SUPP2");
          EN_SUPP1 = uvm_reg_field::type_id::create("EN_SUPP1");
          EN_SUPP0 = uvm_reg_field::type_id::create("EN_SUPP0");
          Reserved = uvm_reg_field::type_id::create("Reserved");
          IGNORE_PAUSE = uvm_reg_field::type_id::create("IGNORE_PAUSE");
          FWD_PAUSE = uvm_reg_field::type_id::create("FWD_PAUSE");
          FWD_CONTROL = uvm_reg_field::type_id::create("FWD_CONTROL");
          Reserved = uvm_reg_field::type_id::create("Reserved");
          EN_ALLMCAST = uvm_reg_field::type_id::create("EN_ALLMCAST");
          EN_ALLUCAST = uvm_reg_field::type_id::create("EN_ALLUCAST");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (12),
          .lsb_pos                (20),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          EN_SUPP3.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (19),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          EN_SUPP2.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (18),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          EN_SUPP1.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (17),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          EN_SUPP0.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (16),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          Reserved.configure(
          .parent                 ( this ),
          .size                   (10),
          .lsb_pos                (6),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          IGNORE_PAUSE.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (5),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          FWD_PAUSE.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (4),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          FWD_CONTROL.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (3),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          Reserved.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (2),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          EN_ALLMCAST.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (1),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (1),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          EN_ALLUCAST.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (1),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_frame_control_urm
       
       
       
 class mac_cfg_max_rx_size_config_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_cfg_max_rx_size_config_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_frame_length;
 
       // Constructor
       function new(string name = "mac_cfg_max_rx_size_config_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_frame_length = uvm_reg_field::type_id::create("rx_frame_length");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_frame_length.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (16'b010111101110),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_cfg_max_rx_size_config_urm
       
       
       
 class rx_vlan_detection_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_vlan_detection_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_vlan_detection_disable;
 
       // Constructor
       function new(string name = "rx_vlan_detection_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_vlan_detection_disable = uvm_reg_field::type_id::create("rx_vlan_detection_disable");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (31),
          .lsb_pos                (1),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_vlan_detection_disable.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_vlan_detection_urm
       
       
       
 class rx_frame_spaddr0_0_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_frame_spaddr0_0_urm  )
 
       rand uvm_reg_field rx_frame_spaddr0_0;
 
       // Constructor
       function new(string name = "rx_frame_spaddr0_0_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_frame_spaddr0_0 = uvm_reg_field::type_id::create("rx_frame_spaddr0_0");
          // configure
          rx_frame_spaddr0_0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_frame_spaddr0_0_urm
       
       
       
 class rx_frame_spaddr0_1_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_frame_spaddr0_1_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_frame_spaddr0_1;
 
       // Constructor
       function new(string name = "rx_frame_spaddr0_1_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_frame_spaddr0_1 = uvm_reg_field::type_id::create("rx_frame_spaddr0_1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_frame_spaddr0_1.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_frame_spaddr0_1_urm
       
       
       
 class rx_frame_spaddr1_0_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_frame_spaddr1_0_urm  )
 
       rand uvm_reg_field rx_frame_spaddr1_0;
 
       // Constructor
       function new(string name = "rx_frame_spaddr1_0_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_frame_spaddr1_0 = uvm_reg_field::type_id::create("rx_frame_spaddr1_0");
          // configure
          rx_frame_spaddr1_0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_frame_spaddr1_0_urm
       
       
       
 class rx_frame_spaddr1_1_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_frame_spaddr1_1_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_frame_spaddr1_1;
 
       // Constructor
       function new(string name = "rx_frame_spaddr1_1_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_frame_spaddr1_1 = uvm_reg_field::type_id::create("rx_frame_spaddr1_1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_frame_spaddr1_1.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_frame_spaddr1_1_urm
       
       
       
 class rx_frame_spaddr2_0_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_frame_spaddr2_0_urm  )
 
       rand uvm_reg_field rx_frame_spaddr2_0;
 
       // Constructor
       function new(string name = "rx_frame_spaddr2_0_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_frame_spaddr2_0 = uvm_reg_field::type_id::create("rx_frame_spaddr2_0");
          // configure
          rx_frame_spaddr2_0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_frame_spaddr2_0_urm
       
       
       
 class rx_frame_spaddr2_1_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_frame_spaddr2_1_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_frame_spaddr2_1;
 
       // Constructor
       function new(string name = "rx_frame_spaddr2_1_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_frame_spaddr2_1 = uvm_reg_field::type_id::create("rx_frame_spaddr2_1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_frame_spaddr2_1.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_frame_spaddr2_1_urm
       
       
       
 class rx_frame_spaddr3_0_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_frame_spaddr3_0_urm  )
 
       rand uvm_reg_field rx_frame_spaddr3_0;
 
       // Constructor
       function new(string name = "rx_frame_spaddr3_0_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_frame_spaddr3_0 = uvm_reg_field::type_id::create("rx_frame_spaddr3_0");
          // configure
          rx_frame_spaddr3_0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_frame_spaddr3_0_urm
       
       
       
 class rx_frame_spaddr3_1_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_frame_spaddr3_1_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_frame_spaddr3_1;
 
       // Constructor
       function new(string name = "rx_frame_spaddr3_1_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_frame_spaddr3_1 = uvm_reg_field::type_id::create("rx_frame_spaddr3_1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_frame_spaddr3_1.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_frame_spaddr3_1_urm
       
       
       
 class rx_pfc_control_urm  extends uvm_reg;//updated access from RW to RO because these register is not enabled in these version of IP
 
       `uvm_object_utils(rx_pfc_control_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field fwd_pfc;
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_pfc_en;
 
       // Constructor
       function new(string name = "rx_pfc_control_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          fwd_pfc = uvm_reg_field::type_id::create("fwd_pfc");
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_pfc_en = uvm_reg_field::type_id::create("rx_pfc_en");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (15),
          .lsb_pos                (17),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          fwd_pfc.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          Reserved.configure(
          .parent                 ( this ),
          .size                   (8),
          .lsb_pos                (8),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_pfc_en.configure(
          .parent                 ( this ),
          .size                   (8),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  ('b11111111),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_pfc_control_urm
       
       
       
 class rx_pktovrflow_error0_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_pktovrflow_error0_urm  )
 
       rand uvm_reg_field rx_pktovrflow_error0;
 
       // Constructor
       function new(string name = "rx_pktovrflow_error0_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_pktovrflow_error0 = uvm_reg_field::type_id::create("rx_pktovrflow_error0");
          // configure
          rx_pktovrflow_error0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_pktovrflow_error0_urm
       
       
       
 class rx_pktovrflow_error1_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_pktovrflow_error1_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_pktovrflow_error1;
 
       // Constructor
       function new(string name = "rx_pktovrflow_error1_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_pktovrflow_error1 = uvm_reg_field::type_id::create("rx_pktovrflow_error1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_pktovrflow_error1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_pktovrflow_error1_urm
       
       
       
 class rx_pktovrflow_etherStatsDropEvents0_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_pktovrflow_etherStatsDropEvents0_urm  )
 
       rand uvm_reg_field rx_pktovrflow_etherStatsDropEvents0;
 
       // Constructor
       function new(string name = "rx_pktovrflow_etherStatsDropEvents0_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_pktovrflow_etherStatsDropEvents0 = uvm_reg_field::type_id::create("rx_pktovrflow_etherStatsDropEvents0");
          // configure
          rx_pktovrflow_etherStatsDropEvents0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_pktovrflow_etherStatsDropEvents0_urm
       
       
       
 class rx_pktovrflow_etherStatsDropEvents1_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_pktovrflow_etherStatsDropEvents1_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_pktovrflow_etherStatsDropEvents1;
 
       // Constructor
       function new(string name = "rx_pktovrflow_etherStatsDropEvents1_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_pktovrflow_etherStatsDropEvents1 = uvm_reg_field::type_id::create("rx_pktovrflow_etherStatsDropEvents1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_pktovrflow_etherStatsDropEvents1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_pktovrflow_etherStatsDropEvents1_urm
       
       
       
 class tx_stats_clr_urm  extends uvm_reg;
 
       `uvm_object_utils(tx_stats_clr_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_clr;
 
       // Constructor
       function new(string name = "tx_stats_clr_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_clr = uvm_reg_field::type_id::create("tx_stats_clr");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (31),
          .lsb_pos                (1),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_clr.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("WRC"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : tx_stats_clr_urm
       
       
       
 class rx_stats_clr_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_stats_clr_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_clr;
 
       // Constructor
       function new(string name = "rx_stats_clr_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_clr = uvm_reg_field::type_id::create("rx_stats_clr");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (31),
          .lsb_pos                (1),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_clr.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("WRC"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_stats_clr_urm
       
       
       
 class tx_stats_framesOK0_urm  extends uvm_reg;
 
       `uvm_object_utils(tx_stats_framesOK0_urm  )
 
       rand uvm_reg_field tx_stats_framesOK0;
 
       // Constructor
       function new(string name = "tx_stats_framesOK0_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_framesOK0 = uvm_reg_field::type_id::create("tx_stats_framesOK0");
          // configure
          tx_stats_framesOK0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : tx_stats_framesOK0_urm
       
       
       
 class tx_stats_framesOK1_urm  extends uvm_reg;
 
       `uvm_object_utils(tx_stats_framesOK1_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_framesOK1;
 
       // Constructor
       function new(string name = "tx_stats_framesOK1_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_framesOK1 = uvm_reg_field::type_id::create("tx_stats_framesOK1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_framesOK1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : tx_stats_framesOK1_urm
       
       
       
 class rx_stats_framesOK0_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_stats_framesOK0_urm  )
 
       rand uvm_reg_field rx_stats_framesOK0;
 
       // Constructor
       function new(string name = "rx_stats_framesOK0_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_framesOK0 = uvm_reg_field::type_id::create("rx_stats_framesOK0");
          // configure
          rx_stats_framesOK0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_stats_framesOK0_urm
       
       
       
 class rx_stats_framesOK1_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_stats_framesOK1_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_framesOK1;
 
       // Constructor
       function new(string name = "rx_stats_framesOK1_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_framesOK1 = uvm_reg_field::type_id::create("rx_stats_framesOK1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_framesOK1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_stats_framesOK1_urm
       
       
       
 class tx_stats_framesErr0_urm  extends uvm_reg;
 
       `uvm_object_utils(tx_stats_framesErr0_urm  )
 
       rand uvm_reg_field tx_stats_framesErr0;
 
       // Constructor
       function new(string name = "tx_stats_framesErr0_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_framesErr0 = uvm_reg_field::type_id::create("tx_stats_framesErr0");
          // configure
          tx_stats_framesErr0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : tx_stats_framesErr0_urm
       
       
       
 class tx_stats_framesErr1_urm  extends uvm_reg;
 
       `uvm_object_utils(tx_stats_framesErr1_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_framesErr1;
 
       // Constructor
       function new(string name = "tx_stats_framesErr1_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_framesErr1 = uvm_reg_field::type_id::create("tx_stats_framesErr1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_framesErr1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : tx_stats_framesErr1_urm
       
       
       
 class rx_stats_framesErr0_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_stats_framesErr0_urm  )
 
       rand uvm_reg_field rx_stats_framesErr0;
 
       // Constructor
       function new(string name = "rx_stats_framesErr0_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_framesErr0 = uvm_reg_field::type_id::create("rx_stats_framesErr0");
          // configure
          rx_stats_framesErr0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_stats_framesErr0_urm
       
       
       
 class rx_stats_framesErr1_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_stats_framesErr1_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_framesErr1;
 
       // Constructor
       function new(string name = "rx_stats_framesErr1_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_framesErr1 = uvm_reg_field::type_id::create("rx_stats_framesErr1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_framesErr1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : rx_stats_framesErr1_urm
       
       
       
 class mac_stats_cntr_rx_fcs_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_fcs_lo_urm  )
 
       rand uvm_reg_field rx_stats_framesCRCErr0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_fcs_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_framesCRCErr0 = uvm_reg_field::type_id::create("rx_stats_framesCRCErr0");
          // configure
          rx_stats_framesCRCErr0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_stats_cntr_rx_fcs_lo_urm
       
       
       
 class mac_stats_cntr_rx_fcs_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_fcs_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_framesCRCErr1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_fcs_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_framesCRCErr1 = uvm_reg_field::type_id::create("rx_stats_framesCRCErr1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_framesCRCErr1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_stats_cntr_rx_fcs_hi_urm
       
       
       
 class mac_stats_cntr_tx_payloadoctetsok_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_payloadoctetsok_lo_urm  )
 
       rand uvm_reg_field tx_stats_octetsOK0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_payloadoctetsok_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_octetsOK0 = uvm_reg_field::type_id::create("tx_stats_octetsOK0");
          // configure
          tx_stats_octetsOK0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_stats_cntr_tx_payloadoctetsok_lo_urm
       
       
       
 class mac_stats_cntr_tx_payloadoctetsok_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_payloadoctetsok_hi_urm  )
 
       rand uvm_reg_field tx_stats_octetsOK1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_payloadoctetsok_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_octetsOK1 = uvm_reg_field::type_id::create("tx_stats_octetsOK1");
          // configure
          tx_stats_octetsOK1.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_stats_cntr_tx_payloadoctetsok_hi_urm
       
       
       
 class mac_stats_cntr_rx_payloadoctetsok_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_payloadoctetsok_lo_urm  )
 
       rand uvm_reg_field rx_stats_octetsOK0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_payloadoctetsok_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_octetsOK0 = uvm_reg_field::type_id::create("rx_stats_octetsOK0");
          // configure
          rx_stats_octetsOK0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_stats_cntr_rx_payloadoctetsok_lo_urm
       
       
       
 class mac_stats_cntr_rx_payloadoctetsok_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_payloadoctetsok_hi_urm  )
 
       rand uvm_reg_field rx_stats_octetsOK1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_payloadoctetsok_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_octetsOK1 = uvm_reg_field::type_id::create("rx_stats_octetsOK1");
          // configure
          rx_stats_octetsOK1.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_stats_cntr_rx_payloadoctetsok_hi_urm
       
       
       
 class mac_stats_cntr_tx_pause_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_pause_lo_urm  )
 
       rand uvm_reg_field tx_stats_pauseMACCtrl_Frames0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_pause_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_pauseMACCtrl_Frames0 = uvm_reg_field::type_id::create("tx_stats_pauseMACCtrl_Frames0");
          // configure
          tx_stats_pauseMACCtrl_Frames0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_stats_cntr_tx_pause_lo_urm
       
       
       
 class mac_stats_cntr_tx_pause_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_pause_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_pauseMACCtrl_Frames1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_pause_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_pauseMACCtrl_Frames1 = uvm_reg_field::type_id::create("tx_stats_pauseMACCtrl_Frames1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_pauseMACCtrl_Frames1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
       
 endclass : mac_stats_cntr_tx_pause_hi_urm
       
       
       
 class mac_stats_cntr_rx_pause_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_pause_lo_urm  )
 
       rand uvm_reg_field rx_stats_pauseMACCtrl_Frames0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_pause_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_pauseMACCtrl_Frames0 = uvm_reg_field::type_id::create("rx_stats_pauseMACCtrl_Frames0");
          // configure
          rx_stats_pauseMACCtrl_Frames0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_pause_lo_urm
       
       
       
 class mac_stats_cntr_rx_pause_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_pause_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_pauseMACCtrl_Frames1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_pause_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_pauseMACCtrl_Frames1 = uvm_reg_field::type_id::create("rx_stats_pauseMACCtrl_Frames1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_pauseMACCtrl_Frames1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_pause_hi_urm
       
       
       
 class tx_stats_ifErrors0_urm  extends uvm_reg;
 
       `uvm_object_utils(tx_stats_ifErrors0_urm  )
 
       rand uvm_reg_field tx_stats_ifErrors0;
 
       // Constructor
       function new(string name = "tx_stats_ifErrors0_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_ifErrors0 = uvm_reg_field::type_id::create("tx_stats_ifErrors0");
          // configure
          tx_stats_ifErrors0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : tx_stats_ifErrors0_urm
       
       
       
 class tx_stats_ifErrors1_urm  extends uvm_reg;
 
       `uvm_object_utils(tx_stats_ifErrors1_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_ifErrors1;
 
       // Constructor
       function new(string name = "tx_stats_ifErrors1_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_ifErrors1 = uvm_reg_field::type_id::create("tx_stats_ifErrors1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_ifErrors1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : tx_stats_ifErrors1_urm
       
       
       
 class rx_stats_ifErrors0_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_stats_ifErrors0_urm  )
 
       rand uvm_reg_field rx_stats_ifErrors0;
 
       // Constructor
       function new(string name = "rx_stats_ifErrors0_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_ifErrors0 = uvm_reg_field::type_id::create("rx_stats_ifErrors0");
          // configure
          rx_stats_ifErrors0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : rx_stats_ifErrors0_urm
       
       
       
 class rx_stats_ifErrors1_urm  extends uvm_reg;
 
       `uvm_object_utils(rx_stats_ifErrors1_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_ifErrors1;
 
       // Constructor
       function new(string name = "rx_stats_ifErrors1_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_ifErrors1 = uvm_reg_field::type_id::create("rx_stats_ifErrors1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_ifErrors1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : rx_stats_ifErrors1_urm
       
       
       
 class mac_stats_cntr_tx_ucast_data_ok_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_ucast_data_ok_lo_urm  )
 
       rand uvm_reg_field tx_stats_unicast_FramesOK0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_ucast_data_ok_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_unicast_FramesOK0 = uvm_reg_field::type_id::create("tx_stats_unicast_FramesOK0");
          // configure
          tx_stats_unicast_FramesOK0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_ucast_data_ok_lo_urm
       
       
       
 class mac_stats_cntr_tx_ucast_data_ok_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_ucast_data_ok_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_unicast_FramesOK1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_ucast_data_ok_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_unicast_FramesOK1 = uvm_reg_field::type_id::create("tx_stats_unicast_FramesOK1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_unicast_FramesOK1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_ucast_data_ok_hi_urm
       
       
       
 class mac_stats_cntr_rx_ucast_data_ok_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_ucast_data_ok_lo_urm  )
 
       rand uvm_reg_field rx_stats_unicast_FramesOK0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_ucast_data_ok_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_unicast_FramesOK0 = uvm_reg_field::type_id::create("rx_stats_unicast_FramesOK0");
          // configure
          rx_stats_unicast_FramesOK0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_ucast_data_ok_lo_urm
       
       
       
 class mac_stats_cntr_rx_ucast_data_ok_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_ucast_data_ok_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_unicast_FramesOK1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_ucast_data_ok_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_unicast_FramesOK1 = uvm_reg_field::type_id::create("rx_stats_unicast_FramesOK1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_unicast_FramesOK1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_ucast_data_ok_hi_urm
       
       
       
 class mac_stats_cntr_tx_utcast_data_err_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_utcast_data_err_lo_urm  )
 
       rand uvm_reg_field tx_stats_unicast_FramesErr0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_utcast_data_err_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_unicast_FramesErr0 = uvm_reg_field::type_id::create("tx_stats_unicast_FramesErr0");
          // configure
          tx_stats_unicast_FramesErr0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_utcast_data_err_lo_urm
       
       
       
 class mac_stats_cntr_tx_utcast_data_err_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_utcast_data_err_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_unicast_FramesErr1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_utcast_data_err_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_unicast_FramesErr1 = uvm_reg_field::type_id::create("tx_stats_unicast_FramesErr1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_unicast_FramesErr1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_utcast_data_err_hi_urm
       
       
       
 class mac_stats_cntr_rx_ucast_data_err_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_ucast_data_err_lo_urm  )
 
       rand uvm_reg_field rx_stats_unicast_FramesErr0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_ucast_data_err_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_unicast_FramesErr0 = uvm_reg_field::type_id::create("rx_stats_unicast_FramesErr0");
          // configure
          rx_stats_unicast_FramesErr0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_ucast_data_err_lo_urm
       
       
       
 class mac_stats_cntr_rx_ucast_data_err_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_ucast_data_err_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_unicast_FramesErr1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_ucast_data_err_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_unicast_FramesErr1 = uvm_reg_field::type_id::create("rx_stats_unicast_FramesErr1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_unicast_FramesErr1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_ucast_data_err_hi_urm
       
       
       
 class mac_stats_cntr_tx_mcast_data_ok_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_mcast_data_ok_lo_urm  )
 
       rand uvm_reg_field tx_stats_multicast_FramesOK0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_mcast_data_ok_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_multicast_FramesOK0 = uvm_reg_field::type_id::create("tx_stats_multicast_FramesOK0");
          // configure
          tx_stats_multicast_FramesOK0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_mcast_data_ok_lo_urm
       
       
       
 class mac_stats_cntr_tx_mcast_data_ok_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_mcast_data_ok_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_multicast_FramesOK1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_mcast_data_ok_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_multicast_FramesOK1 = uvm_reg_field::type_id::create("tx_stats_multicast_FramesOK1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_multicast_FramesOK1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_mcast_data_ok_hi_urm
       
       
       
 class mac_stats_cntr_rx_mcast_data_ok_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_mcast_data_ok_lo_urm  )
 
       rand uvm_reg_field rx_stats_multicast_FramesOK0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_mcast_data_ok_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_multicast_FramesOK0 = uvm_reg_field::type_id::create("rx_stats_multicast_FramesOK0");
          // configure
          rx_stats_multicast_FramesOK0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_mcast_data_ok_lo_urm
       
       
       
 class mac_stats_cntr_rx_mcast_data_ok_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_mcast_data_ok_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_multicast_FramesOK1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_mcast_data_ok_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_multicast_FramesOK1 = uvm_reg_field::type_id::create("rx_stats_multicast_FramesOK1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_multicast_FramesOK1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_mcast_data_ok_hi_urm
       
       
       
 class mac_stats_cntr_tx_mcast_data_err_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_mcast_data_err_lo_urm  )
 
       rand uvm_reg_field tx_stats_multicast_FramesErr0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_mcast_data_err_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_multicast_FramesErr0 = uvm_reg_field::type_id::create("tx_stats_multicast_FramesErr0");
          // configure
          tx_stats_multicast_FramesErr0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_mcast_data_err_lo_urm
       
       
       
 class mac_stats_cntr_tx_mcast_data_err_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_mcast_data_err_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_multicast_FramesErr1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_mcast_data_err_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_multicast_FramesErr1 = uvm_reg_field::type_id::create("tx_stats_multicast_FramesErr1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_multicast_FramesErr1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_mcast_data_err_hi_urm
       
       
       
 class mac_stats_cntr_rx_mcast_data_err_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_mcast_data_err_lo_urm  )
 
       rand uvm_reg_field rx_stats_multicast_FramesErr0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_mcast_data_err_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_multicast_FramesErr0 = uvm_reg_field::type_id::create("rx_stats_multicast_FramesErr0");
          // configure
          rx_stats_multicast_FramesErr0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_mcast_data_err_lo_urm
       
       
       
 class mac_stats_cntr_rx_mcast_data_err_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_mcast_data_err_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_multicast_FramesErr1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_mcast_data_err_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_multicast_FramesErr1 = uvm_reg_field::type_id::create("rx_stats_multicast_FramesErr1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_multicast_FramesErr1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_mcast_data_err_hi_urm
       
       
       
 class mac_stats_cntr_tx_bcast_data_ok_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_bcast_data_ok_lo_urm  )
 
       rand uvm_reg_field tx_stats_broadcast_FramesOK0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_bcast_data_ok_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_broadcast_FramesOK0 = uvm_reg_field::type_id::create("tx_stats_broadcast_FramesOK0");
          // configure
          tx_stats_broadcast_FramesOK0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_bcast_data_ok_lo_urm
       
       
       
 class mac_stats_cntr_tx_bcast_data_ok_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_bcast_data_ok_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_broadcast_FramesOK1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_bcast_data_ok_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_broadcast_FramesOK1 = uvm_reg_field::type_id::create("tx_stats_broadcast_FramesOK1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_broadcast_FramesOK1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_bcast_data_ok_hi_urm
       
       
       
 class mac_stats_cntr_rx_bcast_data_ok_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_bcast_data_ok_lo_urm  )
 
       rand uvm_reg_field rx_stats_broadcast_FramesOK0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_bcast_data_ok_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_broadcast_FramesOK0 = uvm_reg_field::type_id::create("rx_stats_broadcast_FramesOK0");
          // configure
          rx_stats_broadcast_FramesOK0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_bcast_data_ok_lo_urm
       
       
       
 class mac_stats_cntr_rx_bcast_data_ok_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_bcast_data_ok_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_broadcast_FramesOK1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_bcast_data_ok_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_broadcast_FramesOK1 = uvm_reg_field::type_id::create("rx_stats_broadcast_FramesOK1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_broadcast_FramesOK1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_bcast_data_ok_hi_urm
       
       
       
 class mac_stats_cntr_tx_bcast_data_err_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_bcast_data_err_lo_urm  )
 
       rand uvm_reg_field tx_stats_broadcast_FramesErr0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_bcast_data_err_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_broadcast_FramesErr0 = uvm_reg_field::type_id::create("tx_stats_broadcast_FramesErr0");
          // configure
          tx_stats_broadcast_FramesErr0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_bcast_data_err_lo_urm
       
       
       
 class mac_stats_cntr_tx_bcast_data_err_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_bcast_data_err_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_broadcast_FramesErr1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_bcast_data_err_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_broadcast_FramesErr1 = uvm_reg_field::type_id::create("tx_stats_broadcast_FramesErr1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_broadcast_FramesErr1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_bcast_data_err_hi_urm
       
       
       
 class mac_stats_cntr_rx_bcast_data_err_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_bcast_data_err_lo_urm  )
 
       rand uvm_reg_field rx_stats_broadcast_FramesErr0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_bcast_data_err_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_broadcast_FramesErr0 = uvm_reg_field::type_id::create("rx_stats_broadcast_FramesErr0");
          // configure
          rx_stats_broadcast_FramesErr0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_bcast_data_err_lo_urm
       
       
       
 class mac_stats_cntr_rx_bcast_data_err_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_bcast_data_err_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_broadcast_FramesErr1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_bcast_data_err_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_broadcast_FramesErr1 = uvm_reg_field::type_id::create("rx_stats_broadcast_FramesErr1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_broadcast_FramesErr1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_bcast_data_err_hi_urm
       
       
       
 class mac_stats_cntr_tx_octetsok_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_octetsok_lo_urm  )
 
       rand uvm_reg_field tx_stats_etherStatsOctets0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_octetsok_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_etherStatsOctets0 = uvm_reg_field::type_id::create("tx_stats_etherStatsOctets0");
          // configure
          tx_stats_etherStatsOctets0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_octetsok_lo_urm
       
       
       
 class mac_stats_cntr_tx_octetsok_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_octetsok_hi_urm  )
 
       rand uvm_reg_field tx_stats_etherStatsOctets1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_octetsok_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_etherStatsOctets1 = uvm_reg_field::type_id::create("tx_stats_etherStatsOctets1");
          // configure
          tx_stats_etherStatsOctets1.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_octetsok_hi_urm
       
       
       
 class mac_stats_cntr_rx_octetsok_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_octetsok_lo_urm  )
 
       rand uvm_reg_field rx_stats_etherStatsOctets0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_octetsok_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_etherStatsOctets0 = uvm_reg_field::type_id::create("rx_stats_etherStatsOctets0");
          // configure
          rx_stats_etherStatsOctets0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_octetsok_lo_urm
       
       
       
 class mac_stats_cntr_rx_octetsok_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_octetsok_hi_urm  )
 
       rand uvm_reg_field rx_stats_etherStatsOctets1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_octetsok_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_etherStatsOctets1 = uvm_reg_field::type_id::create("rx_stats_etherStatsOctets1");
          // configure
          rx_stats_etherStatsOctets1.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_octetsok_hi_urm
       
       
       
 class mac_stats_cntr_tx_st_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_st_lo_urm  )
 
       rand uvm_reg_field tx_stats_etherStatsPkts0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_st_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_etherStatsPkts0 = uvm_reg_field::type_id::create("tx_stats_etherStatsPkts0");
          // configure
          tx_stats_etherStatsPkts0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_st_lo_urm
       
       
       
 class mac_stats_cntr_tx_st_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_st_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_etherStatsPkts1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_st_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_etherStatsPkts1 = uvm_reg_field::type_id::create("tx_stats_etherStatsPkts1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_etherStatsPkts1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_st_hi_urm
       
       
       
 class mac_stats_cntr_rx_st_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_st_lo_urm  )
 
       rand uvm_reg_field rx_stats_etherStatsPkts0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_st_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_etherStatsPkts0 = uvm_reg_field::type_id::create("rx_stats_etherStatsPkts0");
          // configure
          rx_stats_etherStatsPkts0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_st_lo_urm
       
       
       
 class mac_stats_cntr_rx_st_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_st_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_etherStatsPkts1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_st_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_etherStatsPkts1 = uvm_reg_field::type_id::create("rx_stats_etherStatsPkts1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_etherStatsPkts1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_st_hi_urm
       
       
       
 class mac_stats_cntr_tx_runt_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_runt_lo_urm  )
 
       rand uvm_reg_field tx_stats_etherStatsUndersizePkts0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_runt_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_etherStatsUndersizePkts0 = uvm_reg_field::type_id::create("tx_stats_etherStatsUndersizePkts0");
          // configure
          tx_stats_etherStatsUndersizePkts0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_runt_lo_urm
       
       
       
 class mac_stats_cntr_tx_runt_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_runt_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_etherStatsUndersizePkts1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_runt_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_etherStatsUndersizePkts1 = uvm_reg_field::type_id::create("tx_stats_etherStatsUndersizePkts1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_etherStatsUndersizePkts1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_runt_hi_urm
       
       
       
 class mac_stats_cntr_rx_runt_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_runt_lo_urm  )
 
       rand uvm_reg_field rx_stats_etherStatsUndersizePkts0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_runt_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_etherStatsUndersizePkts0 = uvm_reg_field::type_id::create("rx_stats_etherStatsUndersizePkts0");
          // configure
          rx_stats_etherStatsUndersizePkts0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_runt_lo_urm
       
       
       
 class mac_stats_cntr_rx_runt_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_runt_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_etherStatsUndersizePkts1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_runt_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_etherStatsUndersizePkts1 = uvm_reg_field::type_id::create("rx_stats_etherStatsUndersizePkts1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_etherStatsUndersizePkts1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_runt_hi_urm
       
       
       
 class mac_stats_cntr_tx_oversize_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_oversize_lo_urm  )
 
       rand uvm_reg_field tx_stats_etherStatsOversizePkts0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_oversize_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_etherStatsOversizePkts0 = uvm_reg_field::type_id::create("tx_stats_etherStatsOversizePkts0");
          // configure
          tx_stats_etherStatsOversizePkts0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (32'b00000000000000000000000000000000),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_oversize_lo_urm
       
       
       
 class mac_stats_cntr_tx_oversize_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_oversize_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_etherStatsOversizePkts1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_oversize_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_etherStatsOversizePkts1 = uvm_reg_field::type_id::create("tx_stats_etherStatsOversizePkts1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_etherStatsOversizePkts1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (4'b0000),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_oversize_hi_urm
       
       
       
 class mac_stats_cntr_rx_oversize_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_oversize_lo_urm  )
 
       rand uvm_reg_field rx_stats_etherStatsOversizePkts0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_oversize_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_etherStatsOversizePkts0 = uvm_reg_field::type_id::create("rx_stats_etherStatsOversizePkts0");
          // configure
          rx_stats_etherStatsOversizePkts0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_oversize_lo_urm
       
       
       
 class mac_stats_cntr_rx_oversize_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_oversize_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_etherStatsOversizePkts1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_oversize_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_etherStatsOversizePkts1 = uvm_reg_field::type_id::create("rx_stats_etherStatsOversizePkts1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_etherStatsOversizePkts1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_oversize_hi_urm
       
       
       
 class mac_stats_cntr_tx_64b_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_64b_lo_urm  )
 
       rand uvm_reg_field tx_stats_etherStatsPkts64Octets0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_64b_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_etherStatsPkts64Octets0 = uvm_reg_field::type_id::create("tx_stats_etherStatsPkts64Octets0");
          // configure
          tx_stats_etherStatsPkts64Octets0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_64b_lo_urm
       
       
       
 class mac_stats_cntr_tx_64b_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_64b_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_etherStatsPkts64Octets1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_64b_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_etherStatsPkts64Octets1 = uvm_reg_field::type_id::create("tx_stats_etherStatsPkts64Octets1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_etherStatsPkts64Octets1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_64b_hi_urm
       
       
       
 class mac_stats_cntr_rx_64b_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_64b_lo_urm  )
 
       rand uvm_reg_field rx_stats_etherStatsPkts64Octets0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_64b_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_etherStatsPkts64Octets0 = uvm_reg_field::type_id::create("rx_stats_etherStatsPkts64Octets0");
          // configure
          rx_stats_etherStatsPkts64Octets0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_64b_lo_urm
       
       
       
 class mac_stats_cntr_rx_64b_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_64b_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_etherStatsPkts64Octets1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_64b_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_etherStatsPkts64Octets1 = uvm_reg_field::type_id::create("rx_stats_etherStatsPkts64Octets1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_etherStatsPkts64Octets1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_64b_hi_urm
       
       
       
 class mac_stats_cntr_tx_65to127b_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_65to127b_lo_urm  )
 
       rand uvm_reg_field tx_stats_etherStatsPkts65to127Octets0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_65to127b_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_etherStatsPkts65to127Octets0 = uvm_reg_field::type_id::create("tx_stats_etherStatsPkts65to127Octets0");
          // configure
          tx_stats_etherStatsPkts65to127Octets0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (32'b00000000000000000000000000000000),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_65to127b_lo_urm
       
       
       
 class mac_stats_cntr_tx_65to127b_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_65to127b_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_etherStatsPkts65to127Octets1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_65to127b_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_etherStatsPkts65to127Octets1 = uvm_reg_field::type_id::create("tx_stats_etherStatsPkts65to127Octets1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_etherStatsPkts65to127Octets1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_65to127b_hi_urm
       
       
       
 class mac_stats_cntr_rx_65to127b_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_65to127b_lo_urm  )
 
       rand uvm_reg_field rx_stats_etherStatsPkts65to127Octets0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_65to127b_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_etherStatsPkts65to127Octets0 = uvm_reg_field::type_id::create("rx_stats_etherStatsPkts65to127Octets0");
          // configure
          rx_stats_etherStatsPkts65to127Octets0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_65to127b_lo_urm
       
       
       
 class mac_stats_cntr_rx_65to127b_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_65to127b_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_etherStatsPkts65to127Octets1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_65to127b_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_etherStatsPkts65to127Octets1 = uvm_reg_field::type_id::create("rx_stats_etherStatsPkts65to127Octets1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_etherStatsPkts65to127Octets1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_65to127b_hi_urm
       
       
       
 class mac_stats_cntr_tx_128to255b_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_128to255b_lo_urm  )
 
       rand uvm_reg_field tx_stats_etherStatsPkts128to255Octets0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_128to255b_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_etherStatsPkts128to255Octets0 = uvm_reg_field::type_id::create("tx_stats_etherStatsPkts128to255Octets0");
          // configure
          tx_stats_etherStatsPkts128to255Octets0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_128to255b_lo_urm
       
       
       
 class mac_stats_cntr_tx_128to255b_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_128to255b_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_etherStatsPkts128to255Octets1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_128to255b_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_etherStatsPkts128to255Octets1 = uvm_reg_field::type_id::create("tx_stats_etherStatsPkts128to255Octets1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_etherStatsPkts128to255Octets1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_128to255b_hi_urm
       
       
       
 class mac_stats_cntr_rx_128to255b_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_128to255b_lo_urm  )
 
       rand uvm_reg_field rx_stats_etherStatsPkts128to255Octets0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_128to255b_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_etherStatsPkts128to255Octets0 = uvm_reg_field::type_id::create("rx_stats_etherStatsPkts128to255Octets0");
          // configure
          rx_stats_etherStatsPkts128to255Octets0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_128to255b_lo_urm
       
       
       
 class mac_stats_cntr_rx_128to255b_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_128to255b_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_etherStatsPkts128to255Octets1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_128to255b_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_etherStatsPkts128to255Octets1 = uvm_reg_field::type_id::create("rx_stats_etherStatsPkts128to255Octets1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_etherStatsPkts128to255Octets1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_128to255b_hi_urm
       
       
       
 class mac_stats_cntr_tx_256to511b_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_256to511b_lo_urm  )
 
       rand uvm_reg_field tx_stats_etherStatsPkts256to511Octets0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_256to511b_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_etherStatsPkts256to511Octets0 = uvm_reg_field::type_id::create("tx_stats_etherStatsPkts256to511Octets0");
          // configure
          tx_stats_etherStatsPkts256to511Octets0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (32'b00000000000000000000000000000000),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_256to511b_lo_urm
       
       
       
 class mac_stats_cntr_tx_256to511b_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_256to511b_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_etherStatsPkts256to511Octets1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_256to511b_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_etherStatsPkts256to511Octets1 = uvm_reg_field::type_id::create("tx_stats_etherStatsPkts256to511Octets1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_etherStatsPkts256to511Octets1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_256to511b_hi_urm
       
       
       
 class mac_stats_cntr_rx_256to511b_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_256to511b_lo_urm  )
 
       rand uvm_reg_field rx_stats_etherStatsPkts256to511Octets0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_256to511b_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_etherStatsPkts256to511Octets0 = uvm_reg_field::type_id::create("rx_stats_etherStatsPkts256to511Octets0");
          // configure
          rx_stats_etherStatsPkts256to511Octets0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_256to511b_lo_urm
       
       
       
 class mac_stats_cntr_rx_256to511b_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_256to511b_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_etherStatsPkts256to511Octets1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_256to511b_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_etherStatsPkts256to511Octets1 = uvm_reg_field::type_id::create("rx_stats_etherStatsPkts256to511Octets1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_etherStatsPkts256to511Octets1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_256to511b_hi_urm
       
       
       
 class mac_stats_cntr_tx_512to1023b_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_512to1023b_lo_urm  )
 
       rand uvm_reg_field tx_stats_etherStatsPkts512to1023Octets0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_512to1023b_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_etherStatsPkts512to1023Octets0 = uvm_reg_field::type_id::create("tx_stats_etherStatsPkts512to1023Octets0");
          // configure
          tx_stats_etherStatsPkts512to1023Octets0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_512to1023b_lo_urm
       
       
       
 class mac_stats_cntr_tx_512to1023b_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_512to1023b_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_etherStatsPkts512to1023Octets1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_512to1023b_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_etherStatsPkts512to1023Octets1 = uvm_reg_field::type_id::create("tx_stats_etherStatsPkts512to1023Octets1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_etherStatsPkts512to1023Octets1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_512to1023b_hi_urm
       
       
       
 class mac_stats_cntr_rx_512to1023b_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_512to1023b_lo_urm  )
 
       rand uvm_reg_field rx_stats_etherStatsPkts512to1023Octets0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_512to1023b_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_etherStatsPkts512to1023Octets0 = uvm_reg_field::type_id::create("rx_stats_etherStatsPkts512to1023Octets0");
          // configure
          rx_stats_etherStatsPkts512to1023Octets0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_512to1023b_lo_urm
       
       
       
 class mac_stats_cntr_rx_512to1023b_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_512to1023b_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_etherStatsPkts512to1023Octets1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_512to1023b_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_etherStatsPkts512to1023Octets1 = uvm_reg_field::type_id::create("rx_stats_etherStatsPkts512to1023Octets1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_etherStatsPkts512to1023Octets1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_512to1023b_hi_urm
       
       
       
 class mac_stats_cntr_tx_1024to1518b_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_1024to1518b_lo_urm  )
 
       rand uvm_reg_field tx_stats_etherStatsPkts1024to1518Octets0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_1024to1518b_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_etherStatsPkts1024to1518Octets0 = uvm_reg_field::type_id::create("tx_stats_etherStatsPkts1024to1518Octets0");
          // configure
          tx_stats_etherStatsPkts1024to1518Octets0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (32'b00000000000000000000000000000000),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_1024to1518b_lo_urm
       
       
       
 class mac_stats_cntr_tx_1024to1518b_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_1024to1518b_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_etherStatsPkts1024to1518Octets1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_1024to1518b_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_etherStatsPkts1024to1518Octets1 = uvm_reg_field::type_id::create("tx_stats_etherStatsPkts1024to1518Octets1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_etherStatsPkts1024to1518Octets1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_1024to1518b_hi_urm
       
       
       
 class mac_stats_cntr_rx_1024to1518b_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_1024to1518b_lo_urm  )
 
       rand uvm_reg_field rx_stats_etherStatsPkts1024to1518Octets0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_1024to1518b_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_etherStatsPkts1024to1518Octets0 = uvm_reg_field::type_id::create("rx_stats_etherStatsPkts1024to1518Octets0");
          // configure
          rx_stats_etherStatsPkts1024to1518Octets0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_1024to1518b_lo_urm
       
       
       
 class mac_stats_cntr_rx_1024to1518b_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_1024to1518b_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_etherStatsPkts1024to1518Octets1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_1024to1518b_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_etherStatsPkts1024to1518Octets1 = uvm_reg_field::type_id::create("rx_stats_etherStatsPkts1024to1518Octets1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_etherStatsPkts1024to1518Octets1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_1024to1518b_hi_urm
       
       
       
 class mac_stats_cntr_tx_1519tomaxb_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_1519tomaxb_lo_urm  )
 
       rand uvm_reg_field tx_stats_etherStatsPkts1519toXOctets0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_1519tomaxb_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_etherStatsPkts1519toXOctets0 = uvm_reg_field::type_id::create("tx_stats_etherStatsPkts1519toXOctets0");
          // configure
          tx_stats_etherStatsPkts1519toXOctets0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_1519tomaxb_lo_urm
       
       
       
 class mac_stats_cntr_tx_1519tomaxb_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_1519tomaxb_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_etherStatsPkts1519toXOctets1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_1519tomaxb_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_etherStatsPkts1519toXOctets1 = uvm_reg_field::type_id::create("tx_stats_etherStatsPkts1519toXOctets1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_etherStatsPkts1519toXOctets1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_1519tomaxb_hi_urm
       
       
       
 class mac_stats_cntr_rx_1519tomaxb_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_1519tomaxb_lo_urm  )
 
       rand uvm_reg_field rx_stats_etherStatsPkts1519toXOctets0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_1519tomaxb_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_etherStatsPkts1519toXOctets0 = uvm_reg_field::type_id::create("rx_stats_etherStatsPkts1519toXOctets0");
          // configure
          rx_stats_etherStatsPkts1519toXOctets0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_1519tomaxb_lo_urm
       
       
       
 class mac_stats_cntr_rx_1519tomaxb_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_1519tomaxb_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_etherStatsPkts1519toXOctets1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_1519tomaxb_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_etherStatsPkts1519toXOctets1 = uvm_reg_field::type_id::create("rx_stats_etherStatsPkts1519toXOctets1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_etherStatsPkts1519toXOctets1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_1519tomaxb_hi_urm
       
       
       
 class mac_stats_cntr_rx_fragments_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_fragments_lo_urm  )
 
       rand uvm_reg_field rx_stats_etherStatsFragments0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_fragments_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_etherStatsFragments0 = uvm_reg_field::type_id::create("rx_stats_etherStatsFragments0");
          // configure
          rx_stats_etherStatsFragments0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_fragments_lo_urm
       
       
       
 class mac_stats_cntr_rx_fragments_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_fragments_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_etherStatsFragments1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_fragments_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_etherStatsFragments1 = uvm_reg_field::type_id::create("rx_stats_etherStatsFragments1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_etherStatsFragments1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_fragments_hi_urm
       
       
       
 class mac_stats_cntr_rx_jabbers_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_jabbers_lo_urm  )
 
       rand uvm_reg_field rx_stats_etherStatsJabbers0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_jabbers_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_etherStatsJabbers0 = uvm_reg_field::type_id::create("rx_stats_etherStatsJabbers0");
          // configure
          rx_stats_etherStatsJabbers0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_jabbers_lo_urm
       
       
       
 class mac_stats_cntr_rx_jabbers_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_jabbers_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_etherStatsJabbers1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_jabbers_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_etherStatsJabbers1 = uvm_reg_field::type_id::create("rx_stats_etherStatsJabbers1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_etherStatsJabbers1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_jabbers_hi_urm
       
       
       
 class mac_stats_cntr_rx_fcs_err_okpkt_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_fcs_err_okpkt_lo_urm  )
 
       rand uvm_reg_field rx_stats_etherStatsCRCErr0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_fcs_err_okpkt_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_etherStatsCRCErr0 = uvm_reg_field::type_id::create("rx_stats_etherStatsCRCErr0");
          // configure
          rx_stats_etherStatsCRCErr0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_fcs_err_okpkt_lo_urm
       
       
       
 class mac_stats_cntr_rx_fcs_err_okpkt_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_fcs_err_okpkt_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_etherStatsCRCErr1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_fcs_err_okpkt_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_etherStatsCRCErr1 = uvm_reg_field::type_id::create("rx_stats_etherStatsCRCErr1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_etherStatsCRCErr1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_fcs_err_okpkt_hi_urm
       
       
       
 class mac_stats_cntr_tx_ucast_ctrl_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_ucast_ctrl_lo_urm  )
 
       rand uvm_reg_field tx_stats_unicastMACCtrlFrames0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_ucast_ctrl_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_unicastMACCtrlFrames0 = uvm_reg_field::type_id::create("tx_stats_unicastMACCtrlFrames0");
          // configure
          tx_stats_unicastMACCtrlFrames0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_ucast_ctrl_lo_urm
       
       
       
 class mac_stats_cntr_tx_ucast_ctrl_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_ucast_ctrl_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_unicastMACCtrlFrames1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_ucast_ctrl_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_unicastMACCtrlFrames1 = uvm_reg_field::type_id::create("tx_stats_unicastMACCtrlFrames1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_unicastMACCtrlFrames1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_ucast_ctrl_hi_urm
       
       
       
 class mac_stats_cntr_rx_ucast_ctrl_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_ucast_ctrl_lo_urm  )
 
       rand uvm_reg_field rx_stats_unicastMACCtrlFrames0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_ucast_ctrl_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_unicastMACCtrlFrames0 = uvm_reg_field::type_id::create("rx_stats_unicastMACCtrlFrames0");
          // configure
          rx_stats_unicastMACCtrlFrames0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_ucast_ctrl_lo_urm
       
       
       
 class mac_stats_cntr_rx_ucast_ctrl_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_ucast_ctrl_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_unicastMACCtrlFrames1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_ucast_ctrl_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_unicastMACCtrlFrames1 = uvm_reg_field::type_id::create("rx_stats_unicastMACCtrlFrames1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_unicastMACCtrlFrames1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_ucast_ctrl_hi_urm
       
       
       
 class mac_stats_cntr_tx_mcast_ctrl_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_mcast_ctrl_lo_urm  )
 
       rand uvm_reg_field tx_stats_multicastMACCtrlFrames0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_mcast_ctrl_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_multicastMACCtrlFrames0 = uvm_reg_field::type_id::create("tx_stats_multicastMACCtrlFrames0");
          // configure
          tx_stats_multicastMACCtrlFrames0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (32'b00000000000000000000000000000000),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_mcast_ctrl_lo_urm
       
       
       
 class mac_stats_cntr_tx_mcast_ctrl_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_mcast_ctrl_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_multicastMACCtrlFrames1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_mcast_ctrl_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_multicastMACCtrlFrames1 = uvm_reg_field::type_id::create("tx_stats_multicastMACCtrlFrames1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_multicastMACCtrlFrames1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_mcast_ctrl_hi_urm
       
       
       
 class mac_stats_cntr_rx_mcast_ctrl_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_mcast_ctrl_lo_urm  )
 
       rand uvm_reg_field rx_stats_multicastMACCtrlFrames0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_mcast_ctrl_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_multicastMACCtrlFrames0 = uvm_reg_field::type_id::create("rx_stats_multicastMACCtrlFrames0");
          // configure
          rx_stats_multicastMACCtrlFrames0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_mcast_ctrl_lo_urm
       
       
       
 class mac_stats_cntr_rx_mcast_ctrl_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_mcast_ctrl_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_multicastMACCtrlFrames1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_mcast_ctrl_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_multicastMACCtrlFrames1 = uvm_reg_field::type_id::create("rx_stats_multicastMACCtrlFrames1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_multicastMACCtrlFrames1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_mcast_ctrl_hi_urm
       
       
       
 class mac_stats_cntr_tx_bcast_ctrl_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_bcast_ctrl_lo_urm  )
 
       rand uvm_reg_field tx_stats_broadcastMACCtrlFrames0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_bcast_ctrl_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_broadcastMACCtrlFrames0 = uvm_reg_field::type_id::create("tx_stats_broadcastMACCtrlFrames0");
          // configure
          tx_stats_broadcastMACCtrlFrames0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_bcast_ctrl_lo_urm
       
       
       
 class mac_stats_cntr_tx_bcast_ctrl_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_bcast_ctrl_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_broadcastMACCtrlFrames1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_bcast_ctrl_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_broadcastMACCtrlFrames1 = uvm_reg_field::type_id::create("tx_stats_broadcastMACCtrlFrames1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_broadcastMACCtrlFrames1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_bcast_ctrl_hi_urm
       
       
       
 class mac_stats_cntr_rx_bcast_ctrl_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_bcast_ctrl_lo_urm  )
 
       rand uvm_reg_field rx_stats_broadcastMACCtrlFrames0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_bcast_ctrl_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_broadcastMACCtrlFrames0 = uvm_reg_field::type_id::create("rx_stats_broadcastMACCtrlFrames0");
          // configure
          rx_stats_broadcastMACCtrlFrames0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_bcast_ctrl_lo_urm
       
       
       
 class mac_stats_cntr_rx_bcast_ctrl_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_bcast_ctrl_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_broadcastMACCtrlFrames1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_bcast_ctrl_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_broadcastMACCtrlFrames1 = uvm_reg_field::type_id::create("rx_stats_broadcastMACCtrlFrames1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_broadcastMACCtrlFrames1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_bcast_ctrl_hi_urm
       
       
       
 class mac_stats_cntr_tx_pfc_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_pfc_lo_urm  )
 
       rand uvm_reg_field tx_stats_PFCMACCtrlFrames0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_pfc_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          tx_stats_PFCMACCtrlFrames0 = uvm_reg_field::type_id::create("tx_stats_PFCMACCtrlFrames0");
          // configure
          tx_stats_PFCMACCtrlFrames0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (32'b00000000000000000000000000000000),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_pfc_lo_urm
       
       
       
 class mac_stats_cntr_tx_pfc_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_tx_pfc_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field tx_stats_PFCMACCtrlFrames1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_tx_pfc_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          tx_stats_PFCMACCtrlFrames1 = uvm_reg_field::type_id::create("tx_stats_PFCMACCtrlFrames1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          tx_stats_PFCMACCtrlFrames1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_tx_pfc_hi_urm
       
       
       
 class mac_stats_cntr_rx_pfc_lo_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_pfc_lo_urm  )
 
       rand uvm_reg_field rx_stats_PFCMACCtrlFrames0;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_pfc_lo_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          rx_stats_PFCMACCtrlFrames0 = uvm_reg_field::type_id::create("rx_stats_PFCMACCtrlFrames0");
          // configure
          rx_stats_PFCMACCtrlFrames0.configure(
          .parent                 ( this ),
          .size                   (32),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_pfc_lo_urm
       
       
       
 class mac_stats_cntr_rx_pfc_hi_urm  extends uvm_reg;
 
       `uvm_object_utils(mac_stats_cntr_rx_pfc_hi_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_stats_PFCMACCtrlFrames1;
 
       // Constructor
       function new(string name = "mac_stats_cntr_rx_pfc_hi_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_stats_PFCMACCtrlFrames1 = uvm_reg_field::type_id::create("rx_stats_PFCMACCtrlFrames1");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_stats_PFCMACCtrlFrames1.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : mac_stats_cntr_rx_pfc_hi_urm
       
       
       
 class usxgmii_control_urm  extends uvm_reg;
 
       `uvm_object_utils(usxgmii_control_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field RESTART_AN;
       rand uvm_reg_field Reserved;
       rand uvm_reg_field USXGMII_SPEED;
       rand uvm_reg_field USXGMII_AN_ENA;
       rand uvm_reg_field USXGMII_ENA;
 
       // Constructor
       function new(string name = "usxgmii_control_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          RESTART_AN = uvm_reg_field::type_id::create("RESTART_AN");
          Reserved = uvm_reg_field::type_id::create("Reserved");
          USXGMII_SPEED = uvm_reg_field::type_id::create("USXGMII_SPEED");
          USXGMII_AN_ENA = uvm_reg_field::type_id::create("USXGMII_AN_ENA");
          USXGMII_ENA = uvm_reg_field::type_id::create("USXGMII_ENA");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (22),
          .lsb_pos                (10),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (22'b0000000000000000000000),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          RESTART_AN.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (9),
          .access                 ("WRC"),
          .volatile               (1),
          .reset                  (1'b0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          Reserved.configure(
          .parent                 ( this ),
          .size                   (4),
          .lsb_pos                (5),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (4'b0000),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          USXGMII_SPEED.configure(
          .parent                 ( this ),
          .size                   (3),
          .lsb_pos                (2),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (3'b011),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          USXGMII_AN_ENA.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (1),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (1'b1),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          USXGMII_ENA.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (1'b1),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : usxgmii_control_urm
       
       
       
 class usxgmii_status_urm  extends uvm_reg;
 
       `uvm_object_utils(usxgmii_status_urm  )
 
       rand uvm_reg_field Reserved3;
       rand uvm_reg_field AN_COMPLETE;
       rand uvm_reg_field Reserved2;
       rand uvm_reg_field LINK_STATUS;
       rand uvm_reg_field Reserved1;
 
       // Constructor
       function new(string name = "usxgmii_status_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved3 = uvm_reg_field::type_id::create("Reserved3");
          AN_COMPLETE = uvm_reg_field::type_id::create("AN_COMPLETE");
          Reserved2 = uvm_reg_field::type_id::create("Reserved2");
          LINK_STATUS = uvm_reg_field::type_id::create("LINK_STATUS");
          Reserved1 = uvm_reg_field::type_id::create("Reserved1");
          // configure
          Reserved3.configure(
          .parent                 ( this ),
          .size                   (26),
          .lsb_pos                (6),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          AN_COMPLETE.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (5),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          Reserved2.configure(
          .parent                 ( this ),
          .size                   (2),
          .lsb_pos                (3),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (2'b01),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          LINK_STATUS.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (2),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (1'b0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          Reserved1.configure(
          .parent                 ( this ),
          .size                   (2),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (2'b01),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : usxgmii_status_urm
       
       
       
 class usxgmii_an_resp_mode_urm  extends uvm_reg;
 
       `uvm_object_utils(usxgmii_an_resp_mode_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field duplex_resp_mode;
       rand uvm_reg_field speed_resp_mode;
       rand uvm_reg_field eee_capability;
       rand uvm_reg_field eee_clock_stop_capability;
 
       // Constructor
       function new(string name = "usxgmii_an_resp_mode_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          duplex_resp_mode = uvm_reg_field::type_id::create("duplex_resp_mode");
          speed_resp_mode = uvm_reg_field::type_id::create("speed_resp_mode");
          eee_capability = uvm_reg_field::type_id::create("eee_capability");
          eee_clock_stop_capability = uvm_reg_field::type_id::create("eee_clock_stop_capability");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (28),
          .lsb_pos                (4),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          duplex_resp_mode.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (3),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          speed_resp_mode.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (2),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          eee_capability.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (1),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          eee_clock_stop_capability.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : usxgmii_an_resp_mode_urm
       
       
       
 class usxgmii_dev_ability_urm  extends uvm_reg;
 
       `uvm_object_utils(usxgmii_dev_ability_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field DUPLEX ;
       rand uvm_reg_field SPEED ;
       rand uvm_reg_field eee_capability;
       rand uvm_reg_field eee_clock_stop_capability;
       rand uvm_reg_field Reserved;
 
       // Constructor
       function new(string name = "usxgmii_dev_ability_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          DUPLEX  = uvm_reg_field::type_id::create("DUPLEX ");
          SPEED  = uvm_reg_field::type_id::create("SPEED ");
          eee_capability = uvm_reg_field::type_id::create("eee_capability");
          eee_clock_stop_capability = uvm_reg_field::type_id::create("eee_clock_stop_capability");
          Reserved = uvm_reg_field::type_id::create("Reserved");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (19),
          .lsb_pos                (13),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          DUPLEX .configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (12),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          SPEED .configure(
          .parent                 ( this ),
          .size                   (3),
          .lsb_pos                (9),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          eee_capability.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (8),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          eee_clock_stop_capability.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (7),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          Reserved.configure(
          .parent                 ( this ),
          .size                   (7),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (1),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : usxgmii_dev_ability_urm
       
       
       
 class usxgmii_partner_ability_urm  extends uvm_reg;
 
       `uvm_object_utils(usxgmii_partner_ability_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field LINK;
       rand uvm_reg_field ACKNOWLEDGE;
       rand uvm_reg_field Reserved;
       rand uvm_reg_field DUPLEX;
       rand uvm_reg_field SPEED;
       rand uvm_reg_field eee_capability;
       rand uvm_reg_field eee_clock_stop_capability;
       rand uvm_reg_field Reserved;
 
       // Constructor
       function new(string name = "usxgmii_partner_ability_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          LINK = uvm_reg_field::type_id::create("LINK");
          ACKNOWLEDGE = uvm_reg_field::type_id::create("ACKNOWLEDGE");
          Reserved = uvm_reg_field::type_id::create("Reserved");
          DUPLEX = uvm_reg_field::type_id::create("DUPLEX");
          SPEED = uvm_reg_field::type_id::create("SPEED");
          eee_capability = uvm_reg_field::type_id::create("eee_capability");
          eee_clock_stop_capability = uvm_reg_field::type_id::create("eee_clock_stop_capability");
          Reserved = uvm_reg_field::type_id::create("Reserved");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (16),
          .lsb_pos                (16),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          LINK.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (15),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          ACKNOWLEDGE.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (14),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          Reserved.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (13),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          DUPLEX.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (12),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (1),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          SPEED.configure(
          .parent                 ( this ),
          .size                   (3),
          .lsb_pos                (9),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (2),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          eee_capability.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (8),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          eee_clock_stop_capability.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (7),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          Reserved.configure(
          .parent                 ( this ),
          .size                   (7),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (7'b0000001),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : usxgmii_partner_ability_urm
       
       
       
 class usxgmii_link_timer_urm  extends uvm_reg;
 
       `uvm_object_utils(usxgmii_link_timer_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field AN_LINK_TIMER;
       rand uvm_reg_field Reserved;
 
       // Constructor
       function new(string name = "usxgmii_link_timer_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          AN_LINK_TIMER = uvm_reg_field::type_id::create("AN_LINK_TIMER");
          Reserved = uvm_reg_field::type_id::create("Reserved");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (12),
          .lsb_pos                (20),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          AN_LINK_TIMER.configure(
          .parent                 ( this ),
          .size                   (6),
          .lsb_pos                (14),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (6'b011111),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          Reserved.configure(
          .parent                 ( this ),
          .size                   (14),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : usxgmii_link_timer_urm
       
       
       
 class phy_serial_loopback_urm  extends uvm_reg;
 
       `uvm_object_utils(phy_serial_loopback_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field loopback_enable;
 
       // Constructor
       function new(string name = "phy_serial_loopback_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          loopback_enable = uvm_reg_field::type_id::create("loopback_enable");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (31),
          .lsb_pos                (1),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          loopback_enable.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : phy_serial_loopback_urm
       
       
       
 class FRM_ERR_urm  extends uvm_reg;
 
       `uvm_object_utils(FRM_ERR_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field frame_error;
 
       // Constructor
       function new(string name = "FRM_ERR_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          frame_error = uvm_reg_field::type_id::create("frame_error");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (31),
          .lsb_pos                (1),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          frame_error.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : FRM_ERR_urm
       
       
       
 class SCLR_FRM_ERR_urm  extends uvm_reg;
 
       `uvm_object_utils(SCLR_FRM_ERR_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field sync_clr_frame_err;
 
       // Constructor
       function new(string name = "SCLR_FRM_ERR_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          sync_clr_frame_err = uvm_reg_field::type_id::create("sync_clr_frame_err");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (31),
          .lsb_pos                (1),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          sync_clr_frame_err.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("RW"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : SCLR_FRM_ERR_urm
       
//LL10G -> masking RX_PCS_FULLY_ALIGNED_S_OFFSET_REG since this is not available in LL10G design

/* class RX_PCS_FULLY_ALIGNED_S_urm  extends uvm_reg;
 
       `uvm_object_utils(RX_PCS_FULLY_ALIGNED_S_urm  )
 
       rand uvm_reg_field Reserved;
       rand uvm_reg_field rx_pcs_error_status;
       rand uvm_reg_field rx_pcs_word_lock;
 
       // Constructor
       function new(string name = "RX_PCS_FULLY_ALIGNED_S_urm");
          super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
       
       endfunction : new
 
       // Build
       virtual function void build();
          // create bitfield  
          Reserved = uvm_reg_field::type_id::create("Reserved");
          rx_pcs_error_status = uvm_reg_field::type_id::create("rx_pcs_error_status");
          rx_pcs_word_lock = uvm_reg_field::type_id::create("rx_pcs_word_lock");
          // configure
          Reserved.configure(
          .parent                 ( this ),
          .size                   (30),
          .lsb_pos                (2),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_pcs_error_status.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (1),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (1'b0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          rx_pcs_word_lock.configure(
          .parent                 ( this ),
          .size                   (1),
          .lsb_pos                (0),
          .access                 ("RO"),
          .volatile               (1),
          .reset                  (0),
          .has_reset              (1),
          .is_rand                (1),
          .individually_accessible(0));
          
          
       endfunction : build
 
              
 endclass : RX_PCS_FULLY_ALIGNED_S_urm */
       
       
       
 class registers_urm  extends  uvm_reg_block;
 
        `uvm_object_utils(registers_urm  )
 
       rand mac_cfg_txmac_saddrl_urm mac_cfg_txmac_saddrl;
       rand mac_cfg_txmac_saddrh_urm mac_cfg_txmac_saddrh;
       rand mac_reset_control_urm mac_reset_control;
       rand tx_packet_control_urm tx_packet_control;
       rand tx_transfer_status_urm tx_transfer_status;
       rand tx_pad_control_urm tx_pad_control;
       rand tx_crc_control_urm tx_crc_control;
       rand tx_preamble_control_urm tx_preamble_control;
       rand tx_src_addr_override_urm tx_src_addr_override;
       rand mac_cfg_max_tx_size_config_urm mac_cfg_max_tx_size_config;
       rand tx_vlan_detection_urm tx_vlan_detection;
       rand tx_ipg_10g_urm tx_ipg_10g;
       rand tx_ipg_10M_100M_1G_urm tx_ipg_10M_100M_1G;
       rand tx_underflow_counter0_urm tx_underflow_counter0;
       rand tx_underflow_counter1_urm tx_underflow_counter1;
       rand tx_pauseframe_control_urm tx_pauseframe_control;
       rand mac_cfg_tx_pause_quanta_urm mac_cfg_tx_pause_quanta;
       rand mac_cfg_retransmit_xoff_holdoff_quanta_urm mac_cfg_retransmit_xoff_holdoff_quanta;
       rand tx_pauseframe_enable_urm tx_pauseframe_enable;
       rand tx_pfc_priority_enable_urm tx_pfc_priority_enable;
       rand mac_cfg_pfc_pause_quanta_0_urm mac_cfg_pfc_pause_quanta_0;
       rand mac_cfg_pfc_pause_quanta_1_urm mac_cfg_pfc_pause_quanta_1;
       rand mac_cfg_pfc_pause_quanta_2_urm mac_cfg_pfc_pause_quanta_2;
       rand mac_cfg_pfc_pause_quanta_3_urm mac_cfg_pfc_pause_quanta_3;
       rand mac_cfg_pfc_pause_quanta_4_urm mac_cfg_pfc_pause_quanta_4;
       rand mac_cfg_pfc_pause_quanta_5_urm mac_cfg_pfc_pause_quanta_5;
       rand mac_cfg_pfc_pause_quanta_6_urm mac_cfg_pfc_pause_quanta_6;
       rand mac_cfg_pfc_pause_quanta_7_urm mac_cfg_pfc_pause_quanta_7;
       rand mac_cfg_pfc_holdoff_quanta_0_urm mac_cfg_pfc_holdoff_quanta_0;
       rand mac_cfg_pfc_holdoff_quanta_1_urm mac_cfg_pfc_holdoff_quanta_1;
       rand mac_cfg_pfc_holdoff_quanta_2_urm mac_cfg_pfc_holdoff_quanta_2;
       rand mac_cfg_pfc_holdoff_quanta_3_urm mac_cfg_pfc_holdoff_quanta_3;
       rand mac_cfg_pfc_holdoff_quanta_4_urm mac_cfg_pfc_holdoff_quanta_4;
       rand mac_cfg_pfc_holdoff_quanta_5_urm mac_cfg_pfc_holdoff_quanta_5;
       rand mac_cfg_pfc_holdoff_quanta_6_urm mac_cfg_pfc_holdoff_quanta_6;
       rand mac_cfg_pfc_holdoff_quanta_7_urm mac_cfg_pfc_holdoff_quanta_7;
       rand tx_unidir_control_urm tx_unidir_control;
       rand rx_transfer_control_urm rx_transfer_control;
       rand rx_transfer_status_urm rx_transfer_status;
       rand rx_padcrc_control_urm rx_padcrc_control;
       rand rx_crccheck_control_urm rx_crccheck_control;
       rand rx_custom_preamble_forward_urm rx_custom_preamble_forward;
       rand rx_preamble_control_urm rx_preamble_control;
       rand rx_frame_control_urm rx_frame_control;
       rand mac_cfg_max_rx_size_config_urm mac_cfg_max_rx_size_config;
       rand rx_vlan_detection_urm rx_vlan_detection;
       rand rx_frame_spaddr0_0_urm rx_frame_spaddr0_0;
       rand rx_frame_spaddr0_1_urm rx_frame_spaddr0_1;
       rand rx_frame_spaddr1_0_urm rx_frame_spaddr1_0;
       rand rx_frame_spaddr1_1_urm rx_frame_spaddr1_1;
       rand rx_frame_spaddr2_0_urm rx_frame_spaddr2_0;
       rand rx_frame_spaddr2_1_urm rx_frame_spaddr2_1;
       rand rx_frame_spaddr3_0_urm rx_frame_spaddr3_0;
       rand rx_frame_spaddr3_1_urm rx_frame_spaddr3_1;
       rand rx_pfc_control_urm rx_pfc_control;
       rand rx_pktovrflow_error0_urm rx_pktovrflow_error0;
       rand rx_pktovrflow_error1_urm rx_pktovrflow_error1;
       rand rx_pktovrflow_etherStatsDropEvents0_urm rx_pktovrflow_etherStatsDropEvents0;
       rand rx_pktovrflow_etherStatsDropEvents1_urm rx_pktovrflow_etherStatsDropEvents1;
       rand tx_stats_clr_urm tx_stats_clr;
       rand rx_stats_clr_urm rx_stats_clr;
       rand tx_stats_framesOK0_urm tx_stats_framesOK0;
       rand tx_stats_framesOK1_urm tx_stats_framesOK1;
       rand rx_stats_framesOK0_urm rx_stats_framesOK0;
       rand rx_stats_framesOK1_urm rx_stats_framesOK1;
       rand tx_stats_framesErr0_urm tx_stats_framesErr0;
       rand tx_stats_framesErr1_urm tx_stats_framesErr1;
       rand rx_stats_framesErr0_urm rx_stats_framesErr0;
       rand rx_stats_framesErr1_urm rx_stats_framesErr1;
       rand mac_stats_cntr_rx_fcs_lo_urm mac_stats_cntr_rx_fcs_lo;
       rand mac_stats_cntr_rx_fcs_hi_urm mac_stats_cntr_rx_fcs_hi;
       rand mac_stats_cntr_tx_payloadoctetsok_lo_urm mac_stats_cntr_tx_payloadoctetsok_lo;
       rand mac_stats_cntr_tx_payloadoctetsok_hi_urm mac_stats_cntr_tx_payloadoctetsok_hi;
       rand mac_stats_cntr_rx_payloadoctetsok_lo_urm mac_stats_cntr_rx_payloadoctetsok_lo;
       rand mac_stats_cntr_rx_payloadoctetsok_hi_urm mac_stats_cntr_rx_payloadoctetsok_hi;
       rand mac_stats_cntr_tx_pause_lo_urm mac_stats_cntr_tx_pause_lo;
       rand mac_stats_cntr_tx_pause_hi_urm mac_stats_cntr_tx_pause_hi;
       rand mac_stats_cntr_rx_pause_lo_urm mac_stats_cntr_rx_pause_lo;
       rand mac_stats_cntr_rx_pause_hi_urm mac_stats_cntr_rx_pause_hi;
       rand tx_stats_ifErrors0_urm tx_stats_ifErrors0;
       rand tx_stats_ifErrors1_urm tx_stats_ifErrors1;
       rand rx_stats_ifErrors0_urm rx_stats_ifErrors0;
       rand rx_stats_ifErrors1_urm rx_stats_ifErrors1;
       rand mac_stats_cntr_tx_ucast_data_ok_lo_urm mac_stats_cntr_tx_ucast_data_ok_lo;
       rand mac_stats_cntr_tx_ucast_data_ok_hi_urm mac_stats_cntr_tx_ucast_data_ok_hi;
       rand mac_stats_cntr_rx_ucast_data_ok_lo_urm mac_stats_cntr_rx_ucast_data_ok_lo;
       rand mac_stats_cntr_rx_ucast_data_ok_hi_urm mac_stats_cntr_rx_ucast_data_ok_hi;
       rand mac_stats_cntr_tx_utcast_data_err_lo_urm mac_stats_cntr_tx_utcast_data_err_lo;
       rand mac_stats_cntr_tx_utcast_data_err_hi_urm mac_stats_cntr_tx_utcast_data_err_hi;
       rand mac_stats_cntr_rx_ucast_data_err_lo_urm mac_stats_cntr_rx_ucast_data_err_lo;
       rand mac_stats_cntr_rx_ucast_data_err_hi_urm mac_stats_cntr_rx_ucast_data_err_hi;
       rand mac_stats_cntr_tx_mcast_data_ok_lo_urm mac_stats_cntr_tx_mcast_data_ok_lo;
       rand mac_stats_cntr_tx_mcast_data_ok_hi_urm mac_stats_cntr_tx_mcast_data_ok_hi;
       rand mac_stats_cntr_rx_mcast_data_ok_lo_urm mac_stats_cntr_rx_mcast_data_ok_lo;
       rand mac_stats_cntr_rx_mcast_data_ok_hi_urm mac_stats_cntr_rx_mcast_data_ok_hi;
       rand mac_stats_cntr_tx_mcast_data_err_lo_urm mac_stats_cntr_tx_mcast_data_err_lo;
       rand mac_stats_cntr_tx_mcast_data_err_hi_urm mac_stats_cntr_tx_mcast_data_err_hi;
       rand mac_stats_cntr_rx_mcast_data_err_lo_urm mac_stats_cntr_rx_mcast_data_err_lo;
       rand mac_stats_cntr_rx_mcast_data_err_hi_urm mac_stats_cntr_rx_mcast_data_err_hi;
       rand mac_stats_cntr_tx_bcast_data_ok_lo_urm mac_stats_cntr_tx_bcast_data_ok_lo;
       rand mac_stats_cntr_tx_bcast_data_ok_hi_urm mac_stats_cntr_tx_bcast_data_ok_hi;
       rand mac_stats_cntr_rx_bcast_data_ok_lo_urm mac_stats_cntr_rx_bcast_data_ok_lo;
       rand mac_stats_cntr_rx_bcast_data_ok_hi_urm mac_stats_cntr_rx_bcast_data_ok_hi;
       rand mac_stats_cntr_tx_bcast_data_err_lo_urm mac_stats_cntr_tx_bcast_data_err_lo;
       rand mac_stats_cntr_tx_bcast_data_err_hi_urm mac_stats_cntr_tx_bcast_data_err_hi;
       rand mac_stats_cntr_rx_bcast_data_err_lo_urm mac_stats_cntr_rx_bcast_data_err_lo;
       rand mac_stats_cntr_rx_bcast_data_err_hi_urm mac_stats_cntr_rx_bcast_data_err_hi;
       rand mac_stats_cntr_tx_octetsok_lo_urm mac_stats_cntr_tx_octetsok_lo;
       rand mac_stats_cntr_tx_octetsok_hi_urm mac_stats_cntr_tx_octetsok_hi;
       rand mac_stats_cntr_rx_octetsok_lo_urm mac_stats_cntr_rx_octetsok_lo;
       rand mac_stats_cntr_rx_octetsok_hi_urm mac_stats_cntr_rx_octetsok_hi;
       rand mac_stats_cntr_tx_st_lo_urm mac_stats_cntr_tx_st_lo;
       rand mac_stats_cntr_tx_st_hi_urm mac_stats_cntr_tx_st_hi;
       rand mac_stats_cntr_rx_st_lo_urm mac_stats_cntr_rx_st_lo;
       rand mac_stats_cntr_rx_st_hi_urm mac_stats_cntr_rx_st_hi;
       rand mac_stats_cntr_tx_runt_lo_urm mac_stats_cntr_tx_runt_lo;
       rand mac_stats_cntr_tx_runt_hi_urm mac_stats_cntr_tx_runt_hi;
       rand mac_stats_cntr_rx_runt_lo_urm mac_stats_cntr_rx_runt_lo;
       rand mac_stats_cntr_rx_runt_hi_urm mac_stats_cntr_rx_runt_hi;
       rand mac_stats_cntr_tx_oversize_lo_urm mac_stats_cntr_tx_oversize_lo;
       rand mac_stats_cntr_tx_oversize_hi_urm mac_stats_cntr_tx_oversize_hi;
       rand mac_stats_cntr_rx_oversize_lo_urm mac_stats_cntr_rx_oversize_lo;
       rand mac_stats_cntr_rx_oversize_hi_urm mac_stats_cntr_rx_oversize_hi;
       rand mac_stats_cntr_tx_64b_lo_urm mac_stats_cntr_tx_64b_lo;
       rand mac_stats_cntr_tx_64b_hi_urm mac_stats_cntr_tx_64b_hi;
       rand mac_stats_cntr_rx_64b_lo_urm mac_stats_cntr_rx_64b_lo;
       rand mac_stats_cntr_rx_64b_hi_urm mac_stats_cntr_rx_64b_hi;
       rand mac_stats_cntr_tx_65to127b_lo_urm mac_stats_cntr_tx_65to127b_lo;
       rand mac_stats_cntr_tx_65to127b_hi_urm mac_stats_cntr_tx_65to127b_hi;
       rand mac_stats_cntr_rx_65to127b_lo_urm mac_stats_cntr_rx_65to127b_lo;
       rand mac_stats_cntr_rx_65to127b_hi_urm mac_stats_cntr_rx_65to127b_hi;
       rand mac_stats_cntr_tx_128to255b_lo_urm mac_stats_cntr_tx_128to255b_lo;
       rand mac_stats_cntr_tx_128to255b_hi_urm mac_stats_cntr_tx_128to255b_hi;
       rand mac_stats_cntr_rx_128to255b_lo_urm mac_stats_cntr_rx_128to255b_lo;
       rand mac_stats_cntr_rx_128to255b_hi_urm mac_stats_cntr_rx_128to255b_hi;
       rand mac_stats_cntr_tx_256to511b_lo_urm mac_stats_cntr_tx_256to511b_lo;
       rand mac_stats_cntr_tx_256to511b_hi_urm mac_stats_cntr_tx_256to511b_hi;
       rand mac_stats_cntr_rx_256to511b_lo_urm mac_stats_cntr_rx_256to511b_lo;
       rand mac_stats_cntr_rx_256to511b_hi_urm mac_stats_cntr_rx_256to511b_hi;
       rand mac_stats_cntr_tx_512to1023b_lo_urm mac_stats_cntr_tx_512to1023b_lo;
       rand mac_stats_cntr_tx_512to1023b_hi_urm mac_stats_cntr_tx_512to1023b_hi;
       rand mac_stats_cntr_rx_512to1023b_lo_urm mac_stats_cntr_rx_512to1023b_lo;
       rand mac_stats_cntr_rx_512to1023b_hi_urm mac_stats_cntr_rx_512to1023b_hi;
       rand mac_stats_cntr_tx_1024to1518b_lo_urm mac_stats_cntr_tx_1024to1518b_lo;
       rand mac_stats_cntr_tx_1024to1518b_hi_urm mac_stats_cntr_tx_1024to1518b_hi;
       rand mac_stats_cntr_rx_1024to1518b_lo_urm mac_stats_cntr_rx_1024to1518b_lo;
       rand mac_stats_cntr_rx_1024to1518b_hi_urm mac_stats_cntr_rx_1024to1518b_hi;
       rand mac_stats_cntr_tx_1519tomaxb_lo_urm mac_stats_cntr_tx_1519tomaxb_lo;
       rand mac_stats_cntr_tx_1519tomaxb_hi_urm mac_stats_cntr_tx_1519tomaxb_hi;
       rand mac_stats_cntr_rx_1519tomaxb_lo_urm mac_stats_cntr_rx_1519tomaxb_lo;
       rand mac_stats_cntr_rx_1519tomaxb_hi_urm mac_stats_cntr_rx_1519tomaxb_hi;
       rand mac_stats_cntr_rx_fragments_lo_urm mac_stats_cntr_rx_fragments_lo;
       rand mac_stats_cntr_rx_fragments_hi_urm mac_stats_cntr_rx_fragments_hi;
       rand mac_stats_cntr_rx_jabbers_lo_urm mac_stats_cntr_rx_jabbers_lo;
       rand mac_stats_cntr_rx_jabbers_hi_urm mac_stats_cntr_rx_jabbers_hi;
       rand mac_stats_cntr_rx_fcs_err_okpkt_lo_urm mac_stats_cntr_rx_fcs_err_okpkt_lo;
       rand mac_stats_cntr_rx_fcs_err_okpkt_hi_urm mac_stats_cntr_rx_fcs_err_okpkt_hi;
       rand mac_stats_cntr_tx_ucast_ctrl_lo_urm mac_stats_cntr_tx_ucast_ctrl_lo;
       rand mac_stats_cntr_tx_ucast_ctrl_hi_urm mac_stats_cntr_tx_ucast_ctrl_hi;
       rand mac_stats_cntr_rx_ucast_ctrl_lo_urm mac_stats_cntr_rx_ucast_ctrl_lo;
       rand mac_stats_cntr_rx_ucast_ctrl_hi_urm mac_stats_cntr_rx_ucast_ctrl_hi;
       rand mac_stats_cntr_tx_mcast_ctrl_lo_urm mac_stats_cntr_tx_mcast_ctrl_lo;
       rand mac_stats_cntr_tx_mcast_ctrl_hi_urm mac_stats_cntr_tx_mcast_ctrl_hi;
       rand mac_stats_cntr_rx_mcast_ctrl_lo_urm mac_stats_cntr_rx_mcast_ctrl_lo;
       rand mac_stats_cntr_rx_mcast_ctrl_hi_urm mac_stats_cntr_rx_mcast_ctrl_hi;
       rand mac_stats_cntr_tx_bcast_ctrl_lo_urm mac_stats_cntr_tx_bcast_ctrl_lo;
       rand mac_stats_cntr_tx_bcast_ctrl_hi_urm mac_stats_cntr_tx_bcast_ctrl_hi;
       rand mac_stats_cntr_rx_bcast_ctrl_lo_urm mac_stats_cntr_rx_bcast_ctrl_lo;
       rand mac_stats_cntr_rx_bcast_ctrl_hi_urm mac_stats_cntr_rx_bcast_ctrl_hi;
       rand mac_stats_cntr_tx_pfc_lo_urm mac_stats_cntr_tx_pfc_lo;
       rand mac_stats_cntr_tx_pfc_hi_urm mac_stats_cntr_tx_pfc_hi;
       rand mac_stats_cntr_rx_pfc_lo_urm mac_stats_cntr_rx_pfc_lo;
       rand mac_stats_cntr_rx_pfc_hi_urm mac_stats_cntr_rx_pfc_hi;
       rand usxgmii_control_urm usxgmii_control;
       rand usxgmii_status_urm usxgmii_status;
       rand usxgmii_an_resp_mode_urm usxgmii_an_resp_mode;
       rand usxgmii_dev_ability_urm usxgmii_dev_ability;
       rand usxgmii_partner_ability_urm usxgmii_partner_ability;
       rand usxgmii_link_timer_urm usxgmii_link_timer;
       rand phy_serial_loopback_urm phy_serial_loopback;
       rand FRM_ERR_urm FRM_ERR;
       rand SCLR_FRM_ERR_urm SCLR_FRM_ERR;
       //rand RX_PCS_FULLY_ALIGNED_S_urm RX_PCS_FULLY_ALIGNED_S;
       
       // uvm_reg_map _map;
 
       //Constructor
       function new(string name = "registers_urm");
          endfunction : new
 
       //Build
       virtual function void build();
          
          // Create registers
          mac_cfg_txmac_saddrl = mac_cfg_txmac_saddrl_urm::type_id::create("mac_cfg_txmac_saddrl");
          mac_cfg_txmac_saddrl.configure(this,null,"");
          mac_cfg_txmac_saddrl.build();
          
          mac_cfg_txmac_saddrh = mac_cfg_txmac_saddrh_urm::type_id::create("mac_cfg_txmac_saddrh");
          mac_cfg_txmac_saddrh.configure(this,null,"");
          mac_cfg_txmac_saddrh.build();
          
          mac_reset_control = mac_reset_control_urm::type_id::create("mac_reset_control");
          mac_reset_control.configure(this,null,"");
          mac_reset_control.build();
          
          tx_packet_control = tx_packet_control_urm::type_id::create("tx_packet_control");
          tx_packet_control.configure(this,null,"");
          tx_packet_control.build();
          
          tx_transfer_status = tx_transfer_status_urm::type_id::create("tx_transfer_status");
          tx_transfer_status.configure(this,null,"");
          tx_transfer_status.build();
          
          tx_pad_control = tx_pad_control_urm::type_id::create("tx_pad_control");
          tx_pad_control.configure(this,null,"");
          tx_pad_control.build();
          
          tx_crc_control = tx_crc_control_urm::type_id::create("tx_crc_control");
          tx_crc_control.configure(this,null,"");
          tx_crc_control.build();
          
          tx_preamble_control = tx_preamble_control_urm::type_id::create("tx_preamble_control");
          tx_preamble_control.configure(this,null,"");
          tx_preamble_control.build();
          
          tx_src_addr_override = tx_src_addr_override_urm::type_id::create("tx_src_addr_override");
          tx_src_addr_override.configure(this,null,"");
          tx_src_addr_override.build();
          
          mac_cfg_max_tx_size_config = mac_cfg_max_tx_size_config_urm::type_id::create("mac_cfg_max_tx_size_config");
          mac_cfg_max_tx_size_config.configure(this,null,"");
          mac_cfg_max_tx_size_config.build();
          
          tx_vlan_detection = tx_vlan_detection_urm::type_id::create("tx_vlan_detection");
          tx_vlan_detection.configure(this,null,"");
          tx_vlan_detection.build();
          
          tx_ipg_10g = tx_ipg_10g_urm::type_id::create("tx_ipg_10g");
          tx_ipg_10g.configure(this,null,"");
          tx_ipg_10g.build();
          
          tx_ipg_10M_100M_1G = tx_ipg_10M_100M_1G_urm::type_id::create("tx_ipg_10M_100M_1G");
          tx_ipg_10M_100M_1G.configure(this,null,"");
          tx_ipg_10M_100M_1G.build();
          
          tx_underflow_counter0 = tx_underflow_counter0_urm::type_id::create("tx_underflow_counter0");
          tx_underflow_counter0.configure(this,null,"");
          tx_underflow_counter0.build();
          
          tx_underflow_counter1 = tx_underflow_counter1_urm::type_id::create("tx_underflow_counter1");
          tx_underflow_counter1.configure(this,null,"");
          tx_underflow_counter1.build();
          
          tx_pauseframe_control = tx_pauseframe_control_urm::type_id::create("tx_pauseframe_control");
          tx_pauseframe_control.configure(this,null,"");
          tx_pauseframe_control.build();
          
          mac_cfg_tx_pause_quanta = mac_cfg_tx_pause_quanta_urm::type_id::create("mac_cfg_tx_pause_quanta");
          mac_cfg_tx_pause_quanta.configure(this,null,"");
          mac_cfg_tx_pause_quanta.build();
          
          mac_cfg_retransmit_xoff_holdoff_quanta = mac_cfg_retransmit_xoff_holdoff_quanta_urm::type_id::create("mac_cfg_retransmit_xoff_holdoff_quanta");
          mac_cfg_retransmit_xoff_holdoff_quanta.configure(this,null,"");
          mac_cfg_retransmit_xoff_holdoff_quanta.build();
          
          tx_pauseframe_enable = tx_pauseframe_enable_urm::type_id::create("tx_pauseframe_enable");
          tx_pauseframe_enable.configure(this,null,"");
          tx_pauseframe_enable.build();
          
          tx_pfc_priority_enable = tx_pfc_priority_enable_urm::type_id::create("tx_pfc_priority_enable");
          tx_pfc_priority_enable.configure(this,null,"");
          tx_pfc_priority_enable.build();
          
          mac_cfg_pfc_pause_quanta_0 = mac_cfg_pfc_pause_quanta_0_urm::type_id::create("mac_cfg_pfc_pause_quanta_0");
          mac_cfg_pfc_pause_quanta_0.configure(this,null,"");
          mac_cfg_pfc_pause_quanta_0.build();
          
          mac_cfg_pfc_pause_quanta_1 = mac_cfg_pfc_pause_quanta_1_urm::type_id::create("mac_cfg_pfc_pause_quanta_1");
          mac_cfg_pfc_pause_quanta_1.configure(this,null,"");
          mac_cfg_pfc_pause_quanta_1.build();
          
          mac_cfg_pfc_pause_quanta_2 = mac_cfg_pfc_pause_quanta_2_urm::type_id::create("mac_cfg_pfc_pause_quanta_2");
          mac_cfg_pfc_pause_quanta_2.configure(this,null,"");
          mac_cfg_pfc_pause_quanta_2.build();
          
          mac_cfg_pfc_pause_quanta_3 = mac_cfg_pfc_pause_quanta_3_urm::type_id::create("mac_cfg_pfc_pause_quanta_3");
          mac_cfg_pfc_pause_quanta_3.configure(this,null,"");
          mac_cfg_pfc_pause_quanta_3.build();
          
          mac_cfg_pfc_pause_quanta_4 = mac_cfg_pfc_pause_quanta_4_urm::type_id::create("mac_cfg_pfc_pause_quanta_4");
          mac_cfg_pfc_pause_quanta_4.configure(this,null,"");
          mac_cfg_pfc_pause_quanta_4.build();
          
          mac_cfg_pfc_pause_quanta_5 = mac_cfg_pfc_pause_quanta_5_urm::type_id::create("mac_cfg_pfc_pause_quanta_5");
          mac_cfg_pfc_pause_quanta_5.configure(this,null,"");
          mac_cfg_pfc_pause_quanta_5.build();
          
          mac_cfg_pfc_pause_quanta_6 = mac_cfg_pfc_pause_quanta_6_urm::type_id::create("mac_cfg_pfc_pause_quanta_6");
          mac_cfg_pfc_pause_quanta_6.configure(this,null,"");
          mac_cfg_pfc_pause_quanta_6.build();
          
          mac_cfg_pfc_pause_quanta_7 = mac_cfg_pfc_pause_quanta_7_urm::type_id::create("mac_cfg_pfc_pause_quanta_7");
          mac_cfg_pfc_pause_quanta_7.configure(this,null,"");
          mac_cfg_pfc_pause_quanta_7.build();
          
          mac_cfg_pfc_holdoff_quanta_0 = mac_cfg_pfc_holdoff_quanta_0_urm::type_id::create("mac_cfg_pfc_holdoff_quanta_0");
          mac_cfg_pfc_holdoff_quanta_0.configure(this,null,"");
          mac_cfg_pfc_holdoff_quanta_0.build();
          
          mac_cfg_pfc_holdoff_quanta_1 = mac_cfg_pfc_holdoff_quanta_1_urm::type_id::create("mac_cfg_pfc_holdoff_quanta_1");
          mac_cfg_pfc_holdoff_quanta_1.configure(this,null,"");
          mac_cfg_pfc_holdoff_quanta_1.build();
          
          mac_cfg_pfc_holdoff_quanta_2 = mac_cfg_pfc_holdoff_quanta_2_urm::type_id::create("mac_cfg_pfc_holdoff_quanta_2");
          mac_cfg_pfc_holdoff_quanta_2.configure(this,null,"");
          mac_cfg_pfc_holdoff_quanta_2.build();
          
          mac_cfg_pfc_holdoff_quanta_3 = mac_cfg_pfc_holdoff_quanta_3_urm::type_id::create("mac_cfg_pfc_holdoff_quanta_3");
          mac_cfg_pfc_holdoff_quanta_3.configure(this,null,"");
          mac_cfg_pfc_holdoff_quanta_3.build();
          
          mac_cfg_pfc_holdoff_quanta_4 = mac_cfg_pfc_holdoff_quanta_4_urm::type_id::create("mac_cfg_pfc_holdoff_quanta_4");
          mac_cfg_pfc_holdoff_quanta_4.configure(this,null,"");
          mac_cfg_pfc_holdoff_quanta_4.build();
          
          mac_cfg_pfc_holdoff_quanta_5 = mac_cfg_pfc_holdoff_quanta_5_urm::type_id::create("mac_cfg_pfc_holdoff_quanta_5");
          mac_cfg_pfc_holdoff_quanta_5.configure(this,null,"");
          mac_cfg_pfc_holdoff_quanta_5.build();
          
          mac_cfg_pfc_holdoff_quanta_6 = mac_cfg_pfc_holdoff_quanta_6_urm::type_id::create("mac_cfg_pfc_holdoff_quanta_6");
          mac_cfg_pfc_holdoff_quanta_6.configure(this,null,"");
          mac_cfg_pfc_holdoff_quanta_6.build();
          
          mac_cfg_pfc_holdoff_quanta_7 = mac_cfg_pfc_holdoff_quanta_7_urm::type_id::create("mac_cfg_pfc_holdoff_quanta_7");
          mac_cfg_pfc_holdoff_quanta_7.configure(this,null,"");
          mac_cfg_pfc_holdoff_quanta_7.build();
          
          tx_unidir_control = tx_unidir_control_urm::type_id::create("tx_unidir_control");
          tx_unidir_control.configure(this,null,"");
          tx_unidir_control.build();
          
          rx_transfer_control = rx_transfer_control_urm::type_id::create("rx_transfer_control");
          rx_transfer_control.configure(this,null,"");
          rx_transfer_control.build();
          
          rx_transfer_status = rx_transfer_status_urm::type_id::create("rx_transfer_status");
          rx_transfer_status.configure(this,null,"");
          rx_transfer_status.build();
          
          rx_padcrc_control = rx_padcrc_control_urm::type_id::create("rx_padcrc_control");
          rx_padcrc_control.configure(this,null,"");
          rx_padcrc_control.build();
          
          rx_crccheck_control = rx_crccheck_control_urm::type_id::create("rx_crccheck_control");
          rx_crccheck_control.configure(this,null,"");
          rx_crccheck_control.build();
          
          rx_custom_preamble_forward = rx_custom_preamble_forward_urm::type_id::create("rx_custom_preamble_forward");
          rx_custom_preamble_forward.configure(this,null,"");
          rx_custom_preamble_forward.build();
          
          rx_preamble_control = rx_preamble_control_urm::type_id::create("rx_preamble_control");
          rx_preamble_control.configure(this,null,"");
          rx_preamble_control.build();
          
          rx_frame_control = rx_frame_control_urm::type_id::create("rx_frame_control");
          rx_frame_control.configure(this,null,"");
          rx_frame_control.build();
          
          mac_cfg_max_rx_size_config = mac_cfg_max_rx_size_config_urm::type_id::create("mac_cfg_max_rx_size_config");
          mac_cfg_max_rx_size_config.configure(this,null,"");
          mac_cfg_max_rx_size_config.build();
          
          rx_vlan_detection = rx_vlan_detection_urm::type_id::create("rx_vlan_detection");
          rx_vlan_detection.configure(this,null,"");
          rx_vlan_detection.build();
          
          rx_frame_spaddr0_0 = rx_frame_spaddr0_0_urm::type_id::create("rx_frame_spaddr0_0");
          rx_frame_spaddr0_0.configure(this,null,"");
          rx_frame_spaddr0_0.build();
          
          rx_frame_spaddr0_1 = rx_frame_spaddr0_1_urm::type_id::create("rx_frame_spaddr0_1");
          rx_frame_spaddr0_1.configure(this,null,"");
          rx_frame_spaddr0_1.build();
          
          rx_frame_spaddr1_0 = rx_frame_spaddr1_0_urm::type_id::create("rx_frame_spaddr1_0");
          rx_frame_spaddr1_0.configure(this,null,"");
          rx_frame_spaddr1_0.build();
          
          rx_frame_spaddr1_1 = rx_frame_spaddr1_1_urm::type_id::create("rx_frame_spaddr1_1");
          rx_frame_spaddr1_1.configure(this,null,"");
          rx_frame_spaddr1_1.build();
          
          rx_frame_spaddr2_0 = rx_frame_spaddr2_0_urm::type_id::create("rx_frame_spaddr2_0");
          rx_frame_spaddr2_0.configure(this,null,"");
          rx_frame_spaddr2_0.build();
          
          rx_frame_spaddr2_1 = rx_frame_spaddr2_1_urm::type_id::create("rx_frame_spaddr2_1");
          rx_frame_spaddr2_1.configure(this,null,"");
          rx_frame_spaddr2_1.build();
          
          rx_frame_spaddr3_0 = rx_frame_spaddr3_0_urm::type_id::create("rx_frame_spaddr3_0");
          rx_frame_spaddr3_0.configure(this,null,"");
          rx_frame_spaddr3_0.build();
          
          rx_frame_spaddr3_1 = rx_frame_spaddr3_1_urm::type_id::create("rx_frame_spaddr3_1");
          rx_frame_spaddr3_1.configure(this,null,"");
          rx_frame_spaddr3_1.build();
          
          rx_pfc_control = rx_pfc_control_urm::type_id::create("rx_pfc_control");
          rx_pfc_control.configure(this,null,"");
          rx_pfc_control.build();
          
          rx_pktovrflow_error0 = rx_pktovrflow_error0_urm::type_id::create("rx_pktovrflow_error0");
          rx_pktovrflow_error0.configure(this,null,"");
          rx_pktovrflow_error0.build();
          
          rx_pktovrflow_error1 = rx_pktovrflow_error1_urm::type_id::create("rx_pktovrflow_error1");
          rx_pktovrflow_error1.configure(this,null,"");
          rx_pktovrflow_error1.build();
          
          rx_pktovrflow_etherStatsDropEvents0 = rx_pktovrflow_etherStatsDropEvents0_urm::type_id::create("rx_pktovrflow_etherStatsDropEvents0");
          rx_pktovrflow_etherStatsDropEvents0.configure(this,null,"");
          rx_pktovrflow_etherStatsDropEvents0.build();
          
          rx_pktovrflow_etherStatsDropEvents1 = rx_pktovrflow_etherStatsDropEvents1_urm::type_id::create("rx_pktovrflow_etherStatsDropEvents1");
          rx_pktovrflow_etherStatsDropEvents1.configure(this,null,"");
          rx_pktovrflow_etherStatsDropEvents1.build();
          
          tx_stats_clr = tx_stats_clr_urm::type_id::create("tx_stats_clr");
          tx_stats_clr.configure(this,null,"");
          tx_stats_clr.build();
          
          rx_stats_clr = rx_stats_clr_urm::type_id::create("rx_stats_clr");
          rx_stats_clr.configure(this,null,"");
          rx_stats_clr.build();
          
          tx_stats_framesOK0 = tx_stats_framesOK0_urm::type_id::create("tx_stats_framesOK0");
          tx_stats_framesOK0.configure(this,null,"");
          tx_stats_framesOK0.build();
          
          tx_stats_framesOK1 = tx_stats_framesOK1_urm::type_id::create("tx_stats_framesOK1");
          tx_stats_framesOK1.configure(this,null,"");
          tx_stats_framesOK1.build();
          
          rx_stats_framesOK0 = rx_stats_framesOK0_urm::type_id::create("rx_stats_framesOK0");
          rx_stats_framesOK0.configure(this,null,"");
          rx_stats_framesOK0.build();
          
          rx_stats_framesOK1 = rx_stats_framesOK1_urm::type_id::create("rx_stats_framesOK1");
          rx_stats_framesOK1.configure(this,null,"");
          rx_stats_framesOK1.build();
          
          tx_stats_framesErr0 = tx_stats_framesErr0_urm::type_id::create("tx_stats_framesErr0");
          tx_stats_framesErr0.configure(this,null,"");
          tx_stats_framesErr0.build();
          
          tx_stats_framesErr1 = tx_stats_framesErr1_urm::type_id::create("tx_stats_framesErr1");
          tx_stats_framesErr1.configure(this,null,"");
          tx_stats_framesErr1.build();
          
          rx_stats_framesErr0 = rx_stats_framesErr0_urm::type_id::create("rx_stats_framesErr0");
          rx_stats_framesErr0.configure(this,null,"");
          rx_stats_framesErr0.build();
          
          rx_stats_framesErr1 = rx_stats_framesErr1_urm::type_id::create("rx_stats_framesErr1");
          rx_stats_framesErr1.configure(this,null,"");
          rx_stats_framesErr1.build();
          
          mac_stats_cntr_rx_fcs_lo = mac_stats_cntr_rx_fcs_lo_urm::type_id::create("mac_stats_cntr_rx_fcs_lo");
          mac_stats_cntr_rx_fcs_lo.configure(this,null,"");
          mac_stats_cntr_rx_fcs_lo.build();
          
          mac_stats_cntr_rx_fcs_hi = mac_stats_cntr_rx_fcs_hi_urm::type_id::create("mac_stats_cntr_rx_fcs_hi");
          mac_stats_cntr_rx_fcs_hi.configure(this,null,"");
          mac_stats_cntr_rx_fcs_hi.build();
          
          mac_stats_cntr_tx_payloadoctetsok_lo = mac_stats_cntr_tx_payloadoctetsok_lo_urm::type_id::create("mac_stats_cntr_tx_payloadoctetsok_lo");
          mac_stats_cntr_tx_payloadoctetsok_lo.configure(this,null,"");
          mac_stats_cntr_tx_payloadoctetsok_lo.build();
          
          mac_stats_cntr_tx_payloadoctetsok_hi = mac_stats_cntr_tx_payloadoctetsok_hi_urm::type_id::create("mac_stats_cntr_tx_payloadoctetsok_hi");
          mac_stats_cntr_tx_payloadoctetsok_hi.configure(this,null,"");
          mac_stats_cntr_tx_payloadoctetsok_hi.build();
          
          mac_stats_cntr_rx_payloadoctetsok_lo = mac_stats_cntr_rx_payloadoctetsok_lo_urm::type_id::create("mac_stats_cntr_rx_payloadoctetsok_lo");
          mac_stats_cntr_rx_payloadoctetsok_lo.configure(this,null,"");
          mac_stats_cntr_rx_payloadoctetsok_lo.build();
          
          mac_stats_cntr_rx_payloadoctetsok_hi = mac_stats_cntr_rx_payloadoctetsok_hi_urm::type_id::create("mac_stats_cntr_rx_payloadoctetsok_hi");
          mac_stats_cntr_rx_payloadoctetsok_hi.configure(this,null,"");
          mac_stats_cntr_rx_payloadoctetsok_hi.build();
          
          mac_stats_cntr_tx_pause_lo = mac_stats_cntr_tx_pause_lo_urm::type_id::create("mac_stats_cntr_tx_pause_lo");
          mac_stats_cntr_tx_pause_lo.configure(this,null,"");
          mac_stats_cntr_tx_pause_lo.build();
          
          mac_stats_cntr_tx_pause_hi = mac_stats_cntr_tx_pause_hi_urm::type_id::create("mac_stats_cntr_tx_pause_hi");
          mac_stats_cntr_tx_pause_hi.configure(this,null,"");
          mac_stats_cntr_tx_pause_hi.build();
          
          mac_stats_cntr_rx_pause_lo = mac_stats_cntr_rx_pause_lo_urm::type_id::create("mac_stats_cntr_rx_pause_lo");
          mac_stats_cntr_rx_pause_lo.configure(this,null,"");
          mac_stats_cntr_rx_pause_lo.build();
          
          mac_stats_cntr_rx_pause_hi = mac_stats_cntr_rx_pause_hi_urm::type_id::create("mac_stats_cntr_rx_pause_hi");
          mac_stats_cntr_rx_pause_hi.configure(this,null,"");
          mac_stats_cntr_rx_pause_hi.build();
          
          tx_stats_ifErrors0 = tx_stats_ifErrors0_urm::type_id::create("tx_stats_ifErrors0");
          tx_stats_ifErrors0.configure(this,null,"");
          tx_stats_ifErrors0.build();
          
          tx_stats_ifErrors1 = tx_stats_ifErrors1_urm::type_id::create("tx_stats_ifErrors1");
          tx_stats_ifErrors1.configure(this,null,"");
          tx_stats_ifErrors1.build();
          
          rx_stats_ifErrors0 = rx_stats_ifErrors0_urm::type_id::create("rx_stats_ifErrors0");
          rx_stats_ifErrors0.configure(this,null,"");
          rx_stats_ifErrors0.build();
          
          rx_stats_ifErrors1 = rx_stats_ifErrors1_urm::type_id::create("rx_stats_ifErrors1");
          rx_stats_ifErrors1.configure(this,null,"");
          rx_stats_ifErrors1.build();
          
          mac_stats_cntr_tx_ucast_data_ok_lo = mac_stats_cntr_tx_ucast_data_ok_lo_urm::type_id::create("mac_stats_cntr_tx_ucast_data_ok_lo");
          mac_stats_cntr_tx_ucast_data_ok_lo.configure(this,null,"");
          mac_stats_cntr_tx_ucast_data_ok_lo.build();
          
          mac_stats_cntr_tx_ucast_data_ok_hi = mac_stats_cntr_tx_ucast_data_ok_hi_urm::type_id::create("mac_stats_cntr_tx_ucast_data_ok_hi");
          mac_stats_cntr_tx_ucast_data_ok_hi.configure(this,null,"");
          mac_stats_cntr_tx_ucast_data_ok_hi.build();
          
          mac_stats_cntr_rx_ucast_data_ok_lo = mac_stats_cntr_rx_ucast_data_ok_lo_urm::type_id::create("mac_stats_cntr_rx_ucast_data_ok_lo");
          mac_stats_cntr_rx_ucast_data_ok_lo.configure(this,null,"");
          mac_stats_cntr_rx_ucast_data_ok_lo.build();
          
          mac_stats_cntr_rx_ucast_data_ok_hi = mac_stats_cntr_rx_ucast_data_ok_hi_urm::type_id::create("mac_stats_cntr_rx_ucast_data_ok_hi");
          mac_stats_cntr_rx_ucast_data_ok_hi.configure(this,null,"");
          mac_stats_cntr_rx_ucast_data_ok_hi.build();
          
          mac_stats_cntr_tx_utcast_data_err_lo = mac_stats_cntr_tx_utcast_data_err_lo_urm::type_id::create("mac_stats_cntr_tx_utcast_data_err_lo");
          mac_stats_cntr_tx_utcast_data_err_lo.configure(this,null,"");
          mac_stats_cntr_tx_utcast_data_err_lo.build();
          
          mac_stats_cntr_tx_utcast_data_err_hi = mac_stats_cntr_tx_utcast_data_err_hi_urm::type_id::create("mac_stats_cntr_tx_utcast_data_err_hi");
          mac_stats_cntr_tx_utcast_data_err_hi.configure(this,null,"");
          mac_stats_cntr_tx_utcast_data_err_hi.build();
          
          mac_stats_cntr_rx_ucast_data_err_lo = mac_stats_cntr_rx_ucast_data_err_lo_urm::type_id::create("mac_stats_cntr_rx_ucast_data_err_lo");
          mac_stats_cntr_rx_ucast_data_err_lo.configure(this,null,"");
          mac_stats_cntr_rx_ucast_data_err_lo.build();
          
          mac_stats_cntr_rx_ucast_data_err_hi = mac_stats_cntr_rx_ucast_data_err_hi_urm::type_id::create("mac_stats_cntr_rx_ucast_data_err_hi");
          mac_stats_cntr_rx_ucast_data_err_hi.configure(this,null,"");
          mac_stats_cntr_rx_ucast_data_err_hi.build();
          
          mac_stats_cntr_tx_mcast_data_ok_lo = mac_stats_cntr_tx_mcast_data_ok_lo_urm::type_id::create("mac_stats_cntr_tx_mcast_data_ok_lo");
          mac_stats_cntr_tx_mcast_data_ok_lo.configure(this,null,"");
          mac_stats_cntr_tx_mcast_data_ok_lo.build();
          
          mac_stats_cntr_tx_mcast_data_ok_hi = mac_stats_cntr_tx_mcast_data_ok_hi_urm::type_id::create("mac_stats_cntr_tx_mcast_data_ok_hi");
          mac_stats_cntr_tx_mcast_data_ok_hi.configure(this,null,"");
          mac_stats_cntr_tx_mcast_data_ok_hi.build();
          
          mac_stats_cntr_rx_mcast_data_ok_lo = mac_stats_cntr_rx_mcast_data_ok_lo_urm::type_id::create("mac_stats_cntr_rx_mcast_data_ok_lo");
          mac_stats_cntr_rx_mcast_data_ok_lo.configure(this,null,"");
          mac_stats_cntr_rx_mcast_data_ok_lo.build();
          
          mac_stats_cntr_rx_mcast_data_ok_hi = mac_stats_cntr_rx_mcast_data_ok_hi_urm::type_id::create("mac_stats_cntr_rx_mcast_data_ok_hi");
          mac_stats_cntr_rx_mcast_data_ok_hi.configure(this,null,"");
          mac_stats_cntr_rx_mcast_data_ok_hi.build();
          
          mac_stats_cntr_tx_mcast_data_err_lo = mac_stats_cntr_tx_mcast_data_err_lo_urm::type_id::create("mac_stats_cntr_tx_mcast_data_err_lo");
          mac_stats_cntr_tx_mcast_data_err_lo.configure(this,null,"");
          mac_stats_cntr_tx_mcast_data_err_lo.build();
          
          mac_stats_cntr_tx_mcast_data_err_hi = mac_stats_cntr_tx_mcast_data_err_hi_urm::type_id::create("mac_stats_cntr_tx_mcast_data_err_hi");
          mac_stats_cntr_tx_mcast_data_err_hi.configure(this,null,"");
          mac_stats_cntr_tx_mcast_data_err_hi.build();
          
          mac_stats_cntr_rx_mcast_data_err_lo = mac_stats_cntr_rx_mcast_data_err_lo_urm::type_id::create("mac_stats_cntr_rx_mcast_data_err_lo");
          mac_stats_cntr_rx_mcast_data_err_lo.configure(this,null,"");
          mac_stats_cntr_rx_mcast_data_err_lo.build();
          
          mac_stats_cntr_rx_mcast_data_err_hi = mac_stats_cntr_rx_mcast_data_err_hi_urm::type_id::create("mac_stats_cntr_rx_mcast_data_err_hi");
          mac_stats_cntr_rx_mcast_data_err_hi.configure(this,null,"");
          mac_stats_cntr_rx_mcast_data_err_hi.build();
          
          mac_stats_cntr_tx_bcast_data_ok_lo = mac_stats_cntr_tx_bcast_data_ok_lo_urm::type_id::create("mac_stats_cntr_tx_bcast_data_ok_lo");
          mac_stats_cntr_tx_bcast_data_ok_lo.configure(this,null,"");
          mac_stats_cntr_tx_bcast_data_ok_lo.build();
          
          mac_stats_cntr_tx_bcast_data_ok_hi = mac_stats_cntr_tx_bcast_data_ok_hi_urm::type_id::create("mac_stats_cntr_tx_bcast_data_ok_hi");
          mac_stats_cntr_tx_bcast_data_ok_hi.configure(this,null,"");
          mac_stats_cntr_tx_bcast_data_ok_hi.build();
          
          mac_stats_cntr_rx_bcast_data_ok_lo = mac_stats_cntr_rx_bcast_data_ok_lo_urm::type_id::create("mac_stats_cntr_rx_bcast_data_ok_lo");
          mac_stats_cntr_rx_bcast_data_ok_lo.configure(this,null,"");
          mac_stats_cntr_rx_bcast_data_ok_lo.build();
          
          mac_stats_cntr_rx_bcast_data_ok_hi = mac_stats_cntr_rx_bcast_data_ok_hi_urm::type_id::create("mac_stats_cntr_rx_bcast_data_ok_hi");
          mac_stats_cntr_rx_bcast_data_ok_hi.configure(this,null,"");
          mac_stats_cntr_rx_bcast_data_ok_hi.build();
          
          mac_stats_cntr_tx_bcast_data_err_lo = mac_stats_cntr_tx_bcast_data_err_lo_urm::type_id::create("mac_stats_cntr_tx_bcast_data_err_lo");
          mac_stats_cntr_tx_bcast_data_err_lo.configure(this,null,"");
          mac_stats_cntr_tx_bcast_data_err_lo.build();
          
          mac_stats_cntr_tx_bcast_data_err_hi = mac_stats_cntr_tx_bcast_data_err_hi_urm::type_id::create("mac_stats_cntr_tx_bcast_data_err_hi");
          mac_stats_cntr_tx_bcast_data_err_hi.configure(this,null,"");
          mac_stats_cntr_tx_bcast_data_err_hi.build();
          
          mac_stats_cntr_rx_bcast_data_err_lo = mac_stats_cntr_rx_bcast_data_err_lo_urm::type_id::create("mac_stats_cntr_rx_bcast_data_err_lo");
          mac_stats_cntr_rx_bcast_data_err_lo.configure(this,null,"");
          mac_stats_cntr_rx_bcast_data_err_lo.build();
          
          mac_stats_cntr_rx_bcast_data_err_hi = mac_stats_cntr_rx_bcast_data_err_hi_urm::type_id::create("mac_stats_cntr_rx_bcast_data_err_hi");
          mac_stats_cntr_rx_bcast_data_err_hi.configure(this,null,"");
          mac_stats_cntr_rx_bcast_data_err_hi.build();
          
          mac_stats_cntr_tx_octetsok_lo = mac_stats_cntr_tx_octetsok_lo_urm::type_id::create("mac_stats_cntr_tx_octetsok_lo");
          mac_stats_cntr_tx_octetsok_lo.configure(this,null,"");
          mac_stats_cntr_tx_octetsok_lo.build();
          
          mac_stats_cntr_tx_octetsok_hi = mac_stats_cntr_tx_octetsok_hi_urm::type_id::create("mac_stats_cntr_tx_octetsok_hi");
          mac_stats_cntr_tx_octetsok_hi.configure(this,null,"");
          mac_stats_cntr_tx_octetsok_hi.build();
          
          mac_stats_cntr_rx_octetsok_lo = mac_stats_cntr_rx_octetsok_lo_urm::type_id::create("mac_stats_cntr_rx_octetsok_lo");
          mac_stats_cntr_rx_octetsok_lo.configure(this,null,"");
          mac_stats_cntr_rx_octetsok_lo.build();
          
          mac_stats_cntr_rx_octetsok_hi = mac_stats_cntr_rx_octetsok_hi_urm::type_id::create("mac_stats_cntr_rx_octetsok_hi");
          mac_stats_cntr_rx_octetsok_hi.configure(this,null,"");
          mac_stats_cntr_rx_octetsok_hi.build();
          
          mac_stats_cntr_tx_st_lo = mac_stats_cntr_tx_st_lo_urm::type_id::create("mac_stats_cntr_tx_st_lo");
          mac_stats_cntr_tx_st_lo.configure(this,null,"");
          mac_stats_cntr_tx_st_lo.build();
          
          mac_stats_cntr_tx_st_hi = mac_stats_cntr_tx_st_hi_urm::type_id::create("mac_stats_cntr_tx_st_hi");
          mac_stats_cntr_tx_st_hi.configure(this,null,"");
          mac_stats_cntr_tx_st_hi.build();
          
          mac_stats_cntr_rx_st_lo = mac_stats_cntr_rx_st_lo_urm::type_id::create("mac_stats_cntr_rx_st_lo");
          mac_stats_cntr_rx_st_lo.configure(this,null,"");
          mac_stats_cntr_rx_st_lo.build();
          
          mac_stats_cntr_rx_st_hi = mac_stats_cntr_rx_st_hi_urm::type_id::create("mac_stats_cntr_rx_st_hi");
          mac_stats_cntr_rx_st_hi.configure(this,null,"");
          mac_stats_cntr_rx_st_hi.build();
          
          mac_stats_cntr_tx_runt_lo = mac_stats_cntr_tx_runt_lo_urm::type_id::create("mac_stats_cntr_tx_runt_lo");
          mac_stats_cntr_tx_runt_lo.configure(this,null,"");
          mac_stats_cntr_tx_runt_lo.build();
          
          mac_stats_cntr_tx_runt_hi = mac_stats_cntr_tx_runt_hi_urm::type_id::create("mac_stats_cntr_tx_runt_hi");
          mac_stats_cntr_tx_runt_hi.configure(this,null,"");
          mac_stats_cntr_tx_runt_hi.build();
          
          mac_stats_cntr_rx_runt_lo = mac_stats_cntr_rx_runt_lo_urm::type_id::create("mac_stats_cntr_rx_runt_lo");
          mac_stats_cntr_rx_runt_lo.configure(this,null,"");
          mac_stats_cntr_rx_runt_lo.build();
          
          mac_stats_cntr_rx_runt_hi = mac_stats_cntr_rx_runt_hi_urm::type_id::create("mac_stats_cntr_rx_runt_hi");
          mac_stats_cntr_rx_runt_hi.configure(this,null,"");
          mac_stats_cntr_rx_runt_hi.build();
          
          mac_stats_cntr_tx_oversize_lo = mac_stats_cntr_tx_oversize_lo_urm::type_id::create("mac_stats_cntr_tx_oversize_lo");
          mac_stats_cntr_tx_oversize_lo.configure(this,null,"");
          mac_stats_cntr_tx_oversize_lo.build();
          
          mac_stats_cntr_tx_oversize_hi = mac_stats_cntr_tx_oversize_hi_urm::type_id::create("mac_stats_cntr_tx_oversize_hi");
          mac_stats_cntr_tx_oversize_hi.configure(this,null,"");
          mac_stats_cntr_tx_oversize_hi.build();
          
          mac_stats_cntr_rx_oversize_lo = mac_stats_cntr_rx_oversize_lo_urm::type_id::create("mac_stats_cntr_rx_oversize_lo");
          mac_stats_cntr_rx_oversize_lo.configure(this,null,"");
          mac_stats_cntr_rx_oversize_lo.build();
          
          mac_stats_cntr_rx_oversize_hi = mac_stats_cntr_rx_oversize_hi_urm::type_id::create("mac_stats_cntr_rx_oversize_hi");
          mac_stats_cntr_rx_oversize_hi.configure(this,null,"");
          mac_stats_cntr_rx_oversize_hi.build();
          
          mac_stats_cntr_tx_64b_lo = mac_stats_cntr_tx_64b_lo_urm::type_id::create("mac_stats_cntr_tx_64b_lo");
          mac_stats_cntr_tx_64b_lo.configure(this,null,"");
          mac_stats_cntr_tx_64b_lo.build();
          
          mac_stats_cntr_tx_64b_hi = mac_stats_cntr_tx_64b_hi_urm::type_id::create("mac_stats_cntr_tx_64b_hi");
          mac_stats_cntr_tx_64b_hi.configure(this,null,"");
          mac_stats_cntr_tx_64b_hi.build();
          
          mac_stats_cntr_rx_64b_lo = mac_stats_cntr_rx_64b_lo_urm::type_id::create("mac_stats_cntr_rx_64b_lo");
          mac_stats_cntr_rx_64b_lo.configure(this,null,"");
          mac_stats_cntr_rx_64b_lo.build();
          
          mac_stats_cntr_rx_64b_hi = mac_stats_cntr_rx_64b_hi_urm::type_id::create("mac_stats_cntr_rx_64b_hi");
          mac_stats_cntr_rx_64b_hi.configure(this,null,"");
          mac_stats_cntr_rx_64b_hi.build();
          
          mac_stats_cntr_tx_65to127b_lo = mac_stats_cntr_tx_65to127b_lo_urm::type_id::create("mac_stats_cntr_tx_65to127b_lo");
          mac_stats_cntr_tx_65to127b_lo.configure(this,null,"");
          mac_stats_cntr_tx_65to127b_lo.build();
          
          mac_stats_cntr_tx_65to127b_hi = mac_stats_cntr_tx_65to127b_hi_urm::type_id::create("mac_stats_cntr_tx_65to127b_hi");
          mac_stats_cntr_tx_65to127b_hi.configure(this,null,"");
          mac_stats_cntr_tx_65to127b_hi.build();
          
          mac_stats_cntr_rx_65to127b_lo = mac_stats_cntr_rx_65to127b_lo_urm::type_id::create("mac_stats_cntr_rx_65to127b_lo");
          mac_stats_cntr_rx_65to127b_lo.configure(this,null,"");
          mac_stats_cntr_rx_65to127b_lo.build();
          
          mac_stats_cntr_rx_65to127b_hi = mac_stats_cntr_rx_65to127b_hi_urm::type_id::create("mac_stats_cntr_rx_65to127b_hi");
          mac_stats_cntr_rx_65to127b_hi.configure(this,null,"");
          mac_stats_cntr_rx_65to127b_hi.build();
          
          mac_stats_cntr_tx_128to255b_lo = mac_stats_cntr_tx_128to255b_lo_urm::type_id::create("mac_stats_cntr_tx_128to255b_lo");
          mac_stats_cntr_tx_128to255b_lo.configure(this,null,"");
          mac_stats_cntr_tx_128to255b_lo.build();
          
          mac_stats_cntr_tx_128to255b_hi = mac_stats_cntr_tx_128to255b_hi_urm::type_id::create("mac_stats_cntr_tx_128to255b_hi");
          mac_stats_cntr_tx_128to255b_hi.configure(this,null,"");
          mac_stats_cntr_tx_128to255b_hi.build();
          
          mac_stats_cntr_rx_128to255b_lo = mac_stats_cntr_rx_128to255b_lo_urm::type_id::create("mac_stats_cntr_rx_128to255b_lo");
          mac_stats_cntr_rx_128to255b_lo.configure(this,null,"");
          mac_stats_cntr_rx_128to255b_lo.build();
          
          mac_stats_cntr_rx_128to255b_hi = mac_stats_cntr_rx_128to255b_hi_urm::type_id::create("mac_stats_cntr_rx_128to255b_hi");
          mac_stats_cntr_rx_128to255b_hi.configure(this,null,"");
          mac_stats_cntr_rx_128to255b_hi.build();
          
          mac_stats_cntr_tx_256to511b_lo = mac_stats_cntr_tx_256to511b_lo_urm::type_id::create("mac_stats_cntr_tx_256to511b_lo");
          mac_stats_cntr_tx_256to511b_lo.configure(this,null,"");
          mac_stats_cntr_tx_256to511b_lo.build();
          
          mac_stats_cntr_tx_256to511b_hi = mac_stats_cntr_tx_256to511b_hi_urm::type_id::create("mac_stats_cntr_tx_256to511b_hi");
          mac_stats_cntr_tx_256to511b_hi.configure(this,null,"");
          mac_stats_cntr_tx_256to511b_hi.build();
          
          mac_stats_cntr_rx_256to511b_lo = mac_stats_cntr_rx_256to511b_lo_urm::type_id::create("mac_stats_cntr_rx_256to511b_lo");
          mac_stats_cntr_rx_256to511b_lo.configure(this,null,"");
          mac_stats_cntr_rx_256to511b_lo.build();
          
          mac_stats_cntr_rx_256to511b_hi = mac_stats_cntr_rx_256to511b_hi_urm::type_id::create("mac_stats_cntr_rx_256to511b_hi");
          mac_stats_cntr_rx_256to511b_hi.configure(this,null,"");
          mac_stats_cntr_rx_256to511b_hi.build();
          
          mac_stats_cntr_tx_512to1023b_lo = mac_stats_cntr_tx_512to1023b_lo_urm::type_id::create("mac_stats_cntr_tx_512to1023b_lo");
          mac_stats_cntr_tx_512to1023b_lo.configure(this,null,"");
          mac_stats_cntr_tx_512to1023b_lo.build();
          
          mac_stats_cntr_tx_512to1023b_hi = mac_stats_cntr_tx_512to1023b_hi_urm::type_id::create("mac_stats_cntr_tx_512to1023b_hi");
          mac_stats_cntr_tx_512to1023b_hi.configure(this,null,"");
          mac_stats_cntr_tx_512to1023b_hi.build();
          
          mac_stats_cntr_rx_512to1023b_lo = mac_stats_cntr_rx_512to1023b_lo_urm::type_id::create("mac_stats_cntr_rx_512to1023b_lo");
          mac_stats_cntr_rx_512to1023b_lo.configure(this,null,"");
          mac_stats_cntr_rx_512to1023b_lo.build();
          
          mac_stats_cntr_rx_512to1023b_hi = mac_stats_cntr_rx_512to1023b_hi_urm::type_id::create("mac_stats_cntr_rx_512to1023b_hi");
          mac_stats_cntr_rx_512to1023b_hi.configure(this,null,"");
          mac_stats_cntr_rx_512to1023b_hi.build();
          
          mac_stats_cntr_tx_1024to1518b_lo = mac_stats_cntr_tx_1024to1518b_lo_urm::type_id::create("mac_stats_cntr_tx_1024to1518b_lo");
          mac_stats_cntr_tx_1024to1518b_lo.configure(this,null,"");
          mac_stats_cntr_tx_1024to1518b_lo.build();
          
          mac_stats_cntr_tx_1024to1518b_hi = mac_stats_cntr_tx_1024to1518b_hi_urm::type_id::create("mac_stats_cntr_tx_1024to1518b_hi");
          mac_stats_cntr_tx_1024to1518b_hi.configure(this,null,"");
          mac_stats_cntr_tx_1024to1518b_hi.build();
          
          mac_stats_cntr_rx_1024to1518b_lo = mac_stats_cntr_rx_1024to1518b_lo_urm::type_id::create("mac_stats_cntr_rx_1024to1518b_lo");
          mac_stats_cntr_rx_1024to1518b_lo.configure(this,null,"");
          mac_stats_cntr_rx_1024to1518b_lo.build();
          
          mac_stats_cntr_rx_1024to1518b_hi = mac_stats_cntr_rx_1024to1518b_hi_urm::type_id::create("mac_stats_cntr_rx_1024to1518b_hi");
          mac_stats_cntr_rx_1024to1518b_hi.configure(this,null,"");
          mac_stats_cntr_rx_1024to1518b_hi.build();
          
          mac_stats_cntr_tx_1519tomaxb_lo = mac_stats_cntr_tx_1519tomaxb_lo_urm::type_id::create("mac_stats_cntr_tx_1519tomaxb_lo");
          mac_stats_cntr_tx_1519tomaxb_lo.configure(this,null,"");
          mac_stats_cntr_tx_1519tomaxb_lo.build();
          
          mac_stats_cntr_tx_1519tomaxb_hi = mac_stats_cntr_tx_1519tomaxb_hi_urm::type_id::create("mac_stats_cntr_tx_1519tomaxb_hi");
          mac_stats_cntr_tx_1519tomaxb_hi.configure(this,null,"");
          mac_stats_cntr_tx_1519tomaxb_hi.build();
          
          mac_stats_cntr_rx_1519tomaxb_lo = mac_stats_cntr_rx_1519tomaxb_lo_urm::type_id::create("mac_stats_cntr_rx_1519tomaxb_lo");
          mac_stats_cntr_rx_1519tomaxb_lo.configure(this,null,"");
          mac_stats_cntr_rx_1519tomaxb_lo.build();
          
          mac_stats_cntr_rx_1519tomaxb_hi = mac_stats_cntr_rx_1519tomaxb_hi_urm::type_id::create("mac_stats_cntr_rx_1519tomaxb_hi");
          mac_stats_cntr_rx_1519tomaxb_hi.configure(this,null,"");
          mac_stats_cntr_rx_1519tomaxb_hi.build();
          
          mac_stats_cntr_rx_fragments_lo = mac_stats_cntr_rx_fragments_lo_urm::type_id::create("mac_stats_cntr_rx_fragments_lo");
          mac_stats_cntr_rx_fragments_lo.configure(this,null,"");
          mac_stats_cntr_rx_fragments_lo.build();
          
          mac_stats_cntr_rx_fragments_hi = mac_stats_cntr_rx_fragments_hi_urm::type_id::create("mac_stats_cntr_rx_fragments_hi");
          mac_stats_cntr_rx_fragments_hi.configure(this,null,"");
          mac_stats_cntr_rx_fragments_hi.build();
          
          mac_stats_cntr_rx_jabbers_lo = mac_stats_cntr_rx_jabbers_lo_urm::type_id::create("mac_stats_cntr_rx_jabbers_lo");
          mac_stats_cntr_rx_jabbers_lo.configure(this,null,"");
          mac_stats_cntr_rx_jabbers_lo.build();
          
          mac_stats_cntr_rx_jabbers_hi = mac_stats_cntr_rx_jabbers_hi_urm::type_id::create("mac_stats_cntr_rx_jabbers_hi");
          mac_stats_cntr_rx_jabbers_hi.configure(this,null,"");
          mac_stats_cntr_rx_jabbers_hi.build();
          
          mac_stats_cntr_rx_fcs_err_okpkt_lo = mac_stats_cntr_rx_fcs_err_okpkt_lo_urm::type_id::create("mac_stats_cntr_rx_fcs_err_okpkt_lo");
          mac_stats_cntr_rx_fcs_err_okpkt_lo.configure(this,null,"");
          mac_stats_cntr_rx_fcs_err_okpkt_lo.build();
          
          mac_stats_cntr_rx_fcs_err_okpkt_hi = mac_stats_cntr_rx_fcs_err_okpkt_hi_urm::type_id::create("mac_stats_cntr_rx_fcs_err_okpkt_hi");
          mac_stats_cntr_rx_fcs_err_okpkt_hi.configure(this,null,"");
          mac_stats_cntr_rx_fcs_err_okpkt_hi.build();
          
          mac_stats_cntr_tx_ucast_ctrl_lo = mac_stats_cntr_tx_ucast_ctrl_lo_urm::type_id::create("mac_stats_cntr_tx_ucast_ctrl_lo");
          mac_stats_cntr_tx_ucast_ctrl_lo.configure(this,null,"");
          mac_stats_cntr_tx_ucast_ctrl_lo.build();
          
          mac_stats_cntr_tx_ucast_ctrl_hi = mac_stats_cntr_tx_ucast_ctrl_hi_urm::type_id::create("mac_stats_cntr_tx_ucast_ctrl_hi");
          mac_stats_cntr_tx_ucast_ctrl_hi.configure(this,null,"");
          mac_stats_cntr_tx_ucast_ctrl_hi.build();
          
          mac_stats_cntr_rx_ucast_ctrl_lo = mac_stats_cntr_rx_ucast_ctrl_lo_urm::type_id::create("mac_stats_cntr_rx_ucast_ctrl_lo");
          mac_stats_cntr_rx_ucast_ctrl_lo.configure(this,null,"");
          mac_stats_cntr_rx_ucast_ctrl_lo.build();
          
          mac_stats_cntr_rx_ucast_ctrl_hi = mac_stats_cntr_rx_ucast_ctrl_hi_urm::type_id::create("mac_stats_cntr_rx_ucast_ctrl_hi");
          mac_stats_cntr_rx_ucast_ctrl_hi.configure(this,null,"");
          mac_stats_cntr_rx_ucast_ctrl_hi.build();
          
          mac_stats_cntr_tx_mcast_ctrl_lo = mac_stats_cntr_tx_mcast_ctrl_lo_urm::type_id::create("mac_stats_cntr_tx_mcast_ctrl_lo");
          mac_stats_cntr_tx_mcast_ctrl_lo.configure(this,null,"");
          mac_stats_cntr_tx_mcast_ctrl_lo.build();
          
          mac_stats_cntr_tx_mcast_ctrl_hi = mac_stats_cntr_tx_mcast_ctrl_hi_urm::type_id::create("mac_stats_cntr_tx_mcast_ctrl_hi");
          mac_stats_cntr_tx_mcast_ctrl_hi.configure(this,null,"");
          mac_stats_cntr_tx_mcast_ctrl_hi.build();
          
          mac_stats_cntr_rx_mcast_ctrl_lo = mac_stats_cntr_rx_mcast_ctrl_lo_urm::type_id::create("mac_stats_cntr_rx_mcast_ctrl_lo");
          mac_stats_cntr_rx_mcast_ctrl_lo.configure(this,null,"");
          mac_stats_cntr_rx_mcast_ctrl_lo.build();
          
          mac_stats_cntr_rx_mcast_ctrl_hi = mac_stats_cntr_rx_mcast_ctrl_hi_urm::type_id::create("mac_stats_cntr_rx_mcast_ctrl_hi");
          mac_stats_cntr_rx_mcast_ctrl_hi.configure(this,null,"");
          mac_stats_cntr_rx_mcast_ctrl_hi.build();
          
          mac_stats_cntr_tx_bcast_ctrl_lo = mac_stats_cntr_tx_bcast_ctrl_lo_urm::type_id::create("mac_stats_cntr_tx_bcast_ctrl_lo");
          mac_stats_cntr_tx_bcast_ctrl_lo.configure(this,null,"");
          mac_stats_cntr_tx_bcast_ctrl_lo.build();
          
          mac_stats_cntr_tx_bcast_ctrl_hi = mac_stats_cntr_tx_bcast_ctrl_hi_urm::type_id::create("mac_stats_cntr_tx_bcast_ctrl_hi");
          mac_stats_cntr_tx_bcast_ctrl_hi.configure(this,null,"");
          mac_stats_cntr_tx_bcast_ctrl_hi.build();
          
          mac_stats_cntr_rx_bcast_ctrl_lo = mac_stats_cntr_rx_bcast_ctrl_lo_urm::type_id::create("mac_stats_cntr_rx_bcast_ctrl_lo");
          mac_stats_cntr_rx_bcast_ctrl_lo.configure(this,null,"");
          mac_stats_cntr_rx_bcast_ctrl_lo.build();
          
          mac_stats_cntr_rx_bcast_ctrl_hi = mac_stats_cntr_rx_bcast_ctrl_hi_urm::type_id::create("mac_stats_cntr_rx_bcast_ctrl_hi");
          mac_stats_cntr_rx_bcast_ctrl_hi.configure(this,null,"");
          mac_stats_cntr_rx_bcast_ctrl_hi.build();
          
          mac_stats_cntr_tx_pfc_lo = mac_stats_cntr_tx_pfc_lo_urm::type_id::create("mac_stats_cntr_tx_pfc_lo");
          mac_stats_cntr_tx_pfc_lo.configure(this,null,"");
          mac_stats_cntr_tx_pfc_lo.build();
          
          mac_stats_cntr_tx_pfc_hi = mac_stats_cntr_tx_pfc_hi_urm::type_id::create("mac_stats_cntr_tx_pfc_hi");
          mac_stats_cntr_tx_pfc_hi.configure(this,null,"");
          mac_stats_cntr_tx_pfc_hi.build();
          
          mac_stats_cntr_rx_pfc_lo = mac_stats_cntr_rx_pfc_lo_urm::type_id::create("mac_stats_cntr_rx_pfc_lo");
          mac_stats_cntr_rx_pfc_lo.configure(this,null,"");
          mac_stats_cntr_rx_pfc_lo.build();
          
          mac_stats_cntr_rx_pfc_hi = mac_stats_cntr_rx_pfc_hi_urm::type_id::create("mac_stats_cntr_rx_pfc_hi");
          mac_stats_cntr_rx_pfc_hi.configure(this,null,"");
          mac_stats_cntr_rx_pfc_hi.build();
          
          usxgmii_control = usxgmii_control_urm::type_id::create("usxgmii_control");
          usxgmii_control.configure(this,null,"");
          usxgmii_control.build();
          
          usxgmii_status = usxgmii_status_urm::type_id::create("usxgmii_status");
          usxgmii_status.configure(this,null,"");
          usxgmii_status.build();
          
          usxgmii_an_resp_mode = usxgmii_an_resp_mode_urm::type_id::create("usxgmii_an_resp_mode");
          usxgmii_an_resp_mode.configure(this,null,"");
          usxgmii_an_resp_mode.build();
          
          usxgmii_dev_ability = usxgmii_dev_ability_urm::type_id::create("usxgmii_dev_ability");
          usxgmii_dev_ability.configure(this,null,"");
          usxgmii_dev_ability.build();
          
          usxgmii_partner_ability = usxgmii_partner_ability_urm::type_id::create("usxgmii_partner_ability");
          usxgmii_partner_ability.configure(this,null,"");
          usxgmii_partner_ability.build();
          
          usxgmii_link_timer = usxgmii_link_timer_urm::type_id::create("usxgmii_link_timer");
          usxgmii_link_timer.configure(this,null,"");
          usxgmii_link_timer.build();
          
          phy_serial_loopback = phy_serial_loopback_urm::type_id::create("phy_serial_loopback");
          phy_serial_loopback.configure(this,null,"");
          phy_serial_loopback.build();
          
          FRM_ERR = FRM_ERR_urm::type_id::create("FRM_ERR");
          FRM_ERR.configure(this,null,"");
          FRM_ERR.build();
          
          SCLR_FRM_ERR = SCLR_FRM_ERR_urm::type_id::create("SCLR_FRM_ERR");
          SCLR_FRM_ERR.configure(this,null,"");
          SCLR_FRM_ERR.build();
          
//LL10G -> masking RX_PCS_FULLY_ALIGNED_S_OFFSET_REG since this is not available in LL10G design
       /*   RX_PCS_FULLY_ALIGNED_S = RX_PCS_FULLY_ALIGNED_S_urm::type_id::create("RX_PCS_FULLY_ALIGNED_S");
          RX_PCS_FULLY_ALIGNED_S.configure(this,null,"");
          RX_PCS_FULLY_ALIGNED_S.build(); */
          
          
          // Create the address map
          default_map = create_map("default_map",  `UVM_REG_ADDR_WIDTH'h0, 4, UVM_LITTLE_ENDIAN,1);
          //this.default_map = this.default_map;
          
          //mapping
          this.default_map.add_reg(mac_cfg_txmac_saddrl, `UVM_REG_ADDR_WIDTH'hA010, "RW");
          this.default_map.add_reg(mac_cfg_txmac_saddrh, `UVM_REG_ADDR_WIDTH'hA011, "RW");
          this.default_map.add_reg(mac_reset_control, `UVM_REG_ADDR_WIDTH'hA01F, "RW");
          this.default_map.add_reg(tx_packet_control, `UVM_REG_ADDR_WIDTH'hA020, "RW");
          this.default_map.add_reg(tx_transfer_status, `UVM_REG_ADDR_WIDTH'hA022, "RO");
          this.default_map.add_reg(tx_pad_control, `UVM_REG_ADDR_WIDTH'hA024, "RW");
          this.default_map.add_reg(tx_crc_control, `UVM_REG_ADDR_WIDTH'hA026, "RW");
          this.default_map.add_reg(tx_preamble_control, `UVM_REG_ADDR_WIDTH'hA028, "RO");//updated access from RW to RO because register will update only when passthrough preamble is 1
          this.default_map.add_reg(tx_src_addr_override, `UVM_REG_ADDR_WIDTH'hA02A, "RW");
          this.default_map.add_reg(mac_cfg_max_tx_size_config, `UVM_REG_ADDR_WIDTH'hA02C, "RW");
          this.default_map.add_reg(tx_vlan_detection, `UVM_REG_ADDR_WIDTH'hA02D, "RW");
          this.default_map.add_reg(tx_ipg_10g, `UVM_REG_ADDR_WIDTH'hA02E, "RW");
          this.default_map.add_reg(tx_ipg_10M_100M_1G, `UVM_REG_ADDR_WIDTH'hA02F, "RW");
          this.default_map.add_reg(tx_underflow_counter0, `UVM_REG_ADDR_WIDTH'hA03E, "RO");
          this.default_map.add_reg(tx_underflow_counter1, `UVM_REG_ADDR_WIDTH'hA03F, "RO");
          this.default_map.add_reg(tx_pauseframe_control, `UVM_REG_ADDR_WIDTH'hA040, "RW");
          this.default_map.add_reg(mac_cfg_tx_pause_quanta, `UVM_REG_ADDR_WIDTH'hA042, "RW");
          this.default_map.add_reg(mac_cfg_retransmit_xoff_holdoff_quanta, `UVM_REG_ADDR_WIDTH'hA043, "RW");
          this.default_map.add_reg(tx_pauseframe_enable, `UVM_REG_ADDR_WIDTH'hA044, "RW");
          this.default_map.add_reg(tx_pfc_priority_enable, `UVM_REG_ADDR_WIDTH'hA046, "RO");//updated access from RW to RO because these register is not enabled in these version of IP
          this.default_map.add_reg(mac_cfg_pfc_pause_quanta_0, `UVM_REG_ADDR_WIDTH'hA048, "RO");//updated access from RW to RO because these register is not enabled in these version of IP
          this.default_map.add_reg(mac_cfg_pfc_pause_quanta_1, `UVM_REG_ADDR_WIDTH'hA049, "RO");//updated access from RW to RO because these register is not enabled in these version of IP
          this.default_map.add_reg(mac_cfg_pfc_pause_quanta_2, `UVM_REG_ADDR_WIDTH'hA04A, "RO");//updated access from RW to RO because these register is not enabled in these version of IP
          this.default_map.add_reg(mac_cfg_pfc_pause_quanta_3, `UVM_REG_ADDR_WIDTH'hA04B, "RO");//updated access from RW to RO because these register is not enabled in these version of IP
          this.default_map.add_reg(mac_cfg_pfc_pause_quanta_4, `UVM_REG_ADDR_WIDTH'hA04C, "RO");//updated access from RW to RO because these register is not enabled in these version of IP
          this.default_map.add_reg(mac_cfg_pfc_pause_quanta_5, `UVM_REG_ADDR_WIDTH'hA04D, "RO");//updated access from RW to RO because these register is not enabled in these version of IP
          this.default_map.add_reg(mac_cfg_pfc_pause_quanta_6, `UVM_REG_ADDR_WIDTH'hA04E, "RO");//updated access from RW to RO because these register is not enabled in these version of IP
          this.default_map.add_reg(mac_cfg_pfc_pause_quanta_7, `UVM_REG_ADDR_WIDTH'hA04F, "RO");//updated access from RW to RO because these register is not enabled in these version of IP
          this.default_map.add_reg(mac_cfg_pfc_holdoff_quanta_0, `UVM_REG_ADDR_WIDTH'hA058, "RO");//updated access from RW to RO because these register is not enabled in these version of IP
          this.default_map.add_reg(mac_cfg_pfc_holdoff_quanta_1, `UVM_REG_ADDR_WIDTH'hA059, "RO");//updated access from RW to RO because these register is not enabled in these version of IP
          this.default_map.add_reg(mac_cfg_pfc_holdoff_quanta_2, `UVM_REG_ADDR_WIDTH'hA05A, "RO");//updated access from RW to RO because these register is not enabled in these version of IP
          this.default_map.add_reg(mac_cfg_pfc_holdoff_quanta_3, `UVM_REG_ADDR_WIDTH'hA05B, "RO");//updated access from RW to RO because these register is not enabled in these version of IP
          this.default_map.add_reg(mac_cfg_pfc_holdoff_quanta_4, `UVM_REG_ADDR_WIDTH'hA05C, "RO");//updated access from RW to RO because these register is not enabled in these version of IP
          this.default_map.add_reg(mac_cfg_pfc_holdoff_quanta_5, `UVM_REG_ADDR_WIDTH'hA05D, "RO");//updated access from RW to RO because these register is not enabled in these version of IP
          this.default_map.add_reg(mac_cfg_pfc_holdoff_quanta_6, `UVM_REG_ADDR_WIDTH'hA05E, "RO");//updated access from RW to RO because these register is not enabled in these version of IP
          this.default_map.add_reg(mac_cfg_pfc_holdoff_quanta_7, `UVM_REG_ADDR_WIDTH'hA05F, "RO");//updated access from RW to RO because these register is not enabled in these version of IP
          this.default_map.add_reg(tx_unidir_control, `UVM_REG_ADDR_WIDTH'hA070, "RO");//updated access from RW to RO because these register is not enabled in these version of IP
          this.default_map.add_reg(rx_transfer_control, `UVM_REG_ADDR_WIDTH'hA0A0, "RW");
          this.default_map.add_reg(rx_transfer_status, `UVM_REG_ADDR_WIDTH'hA0A2, "RO");
          this.default_map.add_reg(rx_padcrc_control, `UVM_REG_ADDR_WIDTH'hA0A4, "RW");
          this.default_map.add_reg(rx_crccheck_control, `UVM_REG_ADDR_WIDTH'hA0A6, "RW");
          this.default_map.add_reg(rx_custom_preamble_forward, `UVM_REG_ADDR_WIDTH'hA0A8, "RO");//updated access from RW to RO because register will update only when passthrough preamble is 1
          this.default_map.add_reg(rx_preamble_control, `UVM_REG_ADDR_WIDTH'hA0AA, "RO");//updated access from RW to RO because register will update only when passthrough preamble is 1
          this.default_map.add_reg(rx_frame_control, `UVM_REG_ADDR_WIDTH'hA0AC, "RW");
          this.default_map.add_reg(mac_cfg_max_rx_size_config, `UVM_REG_ADDR_WIDTH'hA0AE, "RW");
          this.default_map.add_reg(rx_vlan_detection, `UVM_REG_ADDR_WIDTH'hA0AF, "RW");
          this.default_map.add_reg(rx_frame_spaddr0_0, `UVM_REG_ADDR_WIDTH'hA0B0, "RW");
          this.default_map.add_reg(rx_frame_spaddr0_1, `UVM_REG_ADDR_WIDTH'hA0B1, "RW");
          this.default_map.add_reg(rx_frame_spaddr1_0, `UVM_REG_ADDR_WIDTH'hA0B2, "RW");
          this.default_map.add_reg(rx_frame_spaddr1_1, `UVM_REG_ADDR_WIDTH'hA0B3, "RW");
          this.default_map.add_reg(rx_frame_spaddr2_0, `UVM_REG_ADDR_WIDTH'hA0B4, "RW");
          this.default_map.add_reg(rx_frame_spaddr2_1, `UVM_REG_ADDR_WIDTH'hA0B5, "RW");
          this.default_map.add_reg(rx_frame_spaddr3_0, `UVM_REG_ADDR_WIDTH'hA0B6, "RW");
          this.default_map.add_reg(rx_frame_spaddr3_1, `UVM_REG_ADDR_WIDTH'hA0B7, "RW");
          this.default_map.add_reg(rx_pfc_control, `UVM_REG_ADDR_WIDTH'hA0C0, "RO");//updated access from RW to RO because these register is not enabled in these version of IP
          this.default_map.add_reg(rx_pktovrflow_error0, `UVM_REG_ADDR_WIDTH'hA0FC, "RO");
          this.default_map.add_reg(rx_pktovrflow_error1, `UVM_REG_ADDR_WIDTH'hA0FD, "RO");
          this.default_map.add_reg(rx_pktovrflow_etherStatsDropEvents0, `UVM_REG_ADDR_WIDTH'hA0FE, "RO");
          this.default_map.add_reg(rx_pktovrflow_etherStatsDropEvents1, `UVM_REG_ADDR_WIDTH'hA0FF, "RO");
          this.default_map.add_reg(tx_stats_clr, `UVM_REG_ADDR_WIDTH'hA140, "WRC");
          this.default_map.add_reg(rx_stats_clr, `UVM_REG_ADDR_WIDTH'hA1C0, "WRC");
          this.default_map.add_reg(tx_stats_framesOK0, `UVM_REG_ADDR_WIDTH'hA142, "RO");
          this.default_map.add_reg(tx_stats_framesOK1, `UVM_REG_ADDR_WIDTH'hA143, "RO");
          this.default_map.add_reg(rx_stats_framesOK0, `UVM_REG_ADDR_WIDTH'hA1C2, "RO");
          this.default_map.add_reg(rx_stats_framesOK1, `UVM_REG_ADDR_WIDTH'hA1C3, "RO");
          this.default_map.add_reg(tx_stats_framesErr0, `UVM_REG_ADDR_WIDTH'hA144, "RO");
          this.default_map.add_reg(tx_stats_framesErr1, `UVM_REG_ADDR_WIDTH'hA145, "RO");
          this.default_map.add_reg(rx_stats_framesErr0, `UVM_REG_ADDR_WIDTH'hA1C4, "RO");
          this.default_map.add_reg(rx_stats_framesErr1, `UVM_REG_ADDR_WIDTH'hA1C5, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_fcs_lo, `UVM_REG_ADDR_WIDTH'hA1C6, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_fcs_hi, `UVM_REG_ADDR_WIDTH'hA1C7, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_payloadoctetsok_lo, `UVM_REG_ADDR_WIDTH'hA148, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_payloadoctetsok_hi, `UVM_REG_ADDR_WIDTH'hA149, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_payloadoctetsok_lo, `UVM_REG_ADDR_WIDTH'hA1C8, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_payloadoctetsok_hi, `UVM_REG_ADDR_WIDTH'hA1C9, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_pause_lo, `UVM_REG_ADDR_WIDTH'hA14A, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_pause_hi, `UVM_REG_ADDR_WIDTH'hA14B, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_pause_lo, `UVM_REG_ADDR_WIDTH'hA1CA, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_pause_hi, `UVM_REG_ADDR_WIDTH'hA1CB, "RO");
          this.default_map.add_reg(tx_stats_ifErrors0, `UVM_REG_ADDR_WIDTH'hA14C, "RO");
          this.default_map.add_reg(tx_stats_ifErrors1, `UVM_REG_ADDR_WIDTH'hA14D, "RO");
          this.default_map.add_reg(rx_stats_ifErrors0, `UVM_REG_ADDR_WIDTH'hA1CC, "RO");
          this.default_map.add_reg(rx_stats_ifErrors1, `UVM_REG_ADDR_WIDTH'hA1CD, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_ucast_data_ok_lo, `UVM_REG_ADDR_WIDTH'hA14E, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_ucast_data_ok_hi, `UVM_REG_ADDR_WIDTH'hA14F, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_ucast_data_ok_lo, `UVM_REG_ADDR_WIDTH'hA1CE, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_ucast_data_ok_hi, `UVM_REG_ADDR_WIDTH'hA1CF, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_utcast_data_err_lo, `UVM_REG_ADDR_WIDTH'hA150, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_utcast_data_err_hi, `UVM_REG_ADDR_WIDTH'hA151, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_ucast_data_err_lo, `UVM_REG_ADDR_WIDTH'hA1D0, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_ucast_data_err_hi, `UVM_REG_ADDR_WIDTH'hA1D1, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_mcast_data_ok_lo, `UVM_REG_ADDR_WIDTH'hA152, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_mcast_data_ok_hi, `UVM_REG_ADDR_WIDTH'hA153, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_mcast_data_ok_lo, `UVM_REG_ADDR_WIDTH'hA1D2, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_mcast_data_ok_hi, `UVM_REG_ADDR_WIDTH'hA1D3, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_mcast_data_err_lo, `UVM_REG_ADDR_WIDTH'hA154, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_mcast_data_err_hi, `UVM_REG_ADDR_WIDTH'hA155, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_mcast_data_err_lo, `UVM_REG_ADDR_WIDTH'hA1D4, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_mcast_data_err_hi, `UVM_REG_ADDR_WIDTH'hA1D5, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_bcast_data_ok_lo, `UVM_REG_ADDR_WIDTH'hA156, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_bcast_data_ok_hi, `UVM_REG_ADDR_WIDTH'hA157, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_bcast_data_ok_lo, `UVM_REG_ADDR_WIDTH'hA1D6, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_bcast_data_ok_hi, `UVM_REG_ADDR_WIDTH'hA1D7, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_bcast_data_err_lo, `UVM_REG_ADDR_WIDTH'hA158, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_bcast_data_err_hi, `UVM_REG_ADDR_WIDTH'hA159, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_bcast_data_err_lo, `UVM_REG_ADDR_WIDTH'hA1D8, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_bcast_data_err_hi, `UVM_REG_ADDR_WIDTH'hA1D9, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_octetsok_lo, `UVM_REG_ADDR_WIDTH'hA15A, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_octetsok_hi, `UVM_REG_ADDR_WIDTH'hA15B, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_octetsok_lo, `UVM_REG_ADDR_WIDTH'hA1DA, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_octetsok_hi, `UVM_REG_ADDR_WIDTH'hA1DB, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_st_lo, `UVM_REG_ADDR_WIDTH'hA15C, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_st_hi, `UVM_REG_ADDR_WIDTH'hA15D, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_st_lo, `UVM_REG_ADDR_WIDTH'hA1DC, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_st_hi, `UVM_REG_ADDR_WIDTH'hA1DD, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_runt_lo, `UVM_REG_ADDR_WIDTH'hA15E, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_runt_hi, `UVM_REG_ADDR_WIDTH'hA15F, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_runt_lo, `UVM_REG_ADDR_WIDTH'hA1DE, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_runt_hi, `UVM_REG_ADDR_WIDTH'hA1DF, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_oversize_lo, `UVM_REG_ADDR_WIDTH'hA160, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_oversize_hi, `UVM_REG_ADDR_WIDTH'hA161, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_oversize_lo, `UVM_REG_ADDR_WIDTH'hA1E0, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_oversize_hi, `UVM_REG_ADDR_WIDTH'hA1E1, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_64b_lo, `UVM_REG_ADDR_WIDTH'hA162, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_64b_hi, `UVM_REG_ADDR_WIDTH'hA163, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_64b_lo, `UVM_REG_ADDR_WIDTH'hA1E2, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_64b_hi, `UVM_REG_ADDR_WIDTH'hA1E3, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_65to127b_lo, `UVM_REG_ADDR_WIDTH'hA164, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_65to127b_hi, `UVM_REG_ADDR_WIDTH'hA165, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_65to127b_lo, `UVM_REG_ADDR_WIDTH'hA1E4, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_65to127b_hi, `UVM_REG_ADDR_WIDTH'hA1E5, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_128to255b_lo, `UVM_REG_ADDR_WIDTH'hA166, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_128to255b_hi, `UVM_REG_ADDR_WIDTH'hA167, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_128to255b_lo, `UVM_REG_ADDR_WIDTH'hA1E6, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_128to255b_hi, `UVM_REG_ADDR_WIDTH'hA1E7, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_256to511b_lo, `UVM_REG_ADDR_WIDTH'hA168, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_256to511b_hi, `UVM_REG_ADDR_WIDTH'hA169, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_256to511b_lo, `UVM_REG_ADDR_WIDTH'hA1E8, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_256to511b_hi, `UVM_REG_ADDR_WIDTH'hA1E9, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_512to1023b_lo, `UVM_REG_ADDR_WIDTH'hA16A, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_512to1023b_hi, `UVM_REG_ADDR_WIDTH'hA16B, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_512to1023b_lo, `UVM_REG_ADDR_WIDTH'hA1EA, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_512to1023b_hi, `UVM_REG_ADDR_WIDTH'hA1EB, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_1024to1518b_lo, `UVM_REG_ADDR_WIDTH'hA16C, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_1024to1518b_hi, `UVM_REG_ADDR_WIDTH'hA16D, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_1024to1518b_lo, `UVM_REG_ADDR_WIDTH'hA1EC, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_1024to1518b_hi, `UVM_REG_ADDR_WIDTH'hA1ED, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_1519tomaxb_lo, `UVM_REG_ADDR_WIDTH'hA16E, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_1519tomaxb_hi, `UVM_REG_ADDR_WIDTH'hA16F, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_1519tomaxb_lo, `UVM_REG_ADDR_WIDTH'hA1EE, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_1519tomaxb_hi, `UVM_REG_ADDR_WIDTH'hA1EF, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_fragments_lo, `UVM_REG_ADDR_WIDTH'hA1F0, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_fragments_hi, `UVM_REG_ADDR_WIDTH'hA1F1, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_jabbers_lo, `UVM_REG_ADDR_WIDTH'hA1F2, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_jabbers_hi, `UVM_REG_ADDR_WIDTH'hA1F3, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_fcs_err_okpkt_lo, `UVM_REG_ADDR_WIDTH'hA1F4, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_fcs_err_okpkt_hi, `UVM_REG_ADDR_WIDTH'hA1F5, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_ucast_ctrl_lo, `UVM_REG_ADDR_WIDTH'hA176, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_ucast_ctrl_hi, `UVM_REG_ADDR_WIDTH'hA177, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_ucast_ctrl_lo, `UVM_REG_ADDR_WIDTH'hA1F6, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_ucast_ctrl_hi, `UVM_REG_ADDR_WIDTH'hA1F7, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_mcast_ctrl_lo, `UVM_REG_ADDR_WIDTH'hA178, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_mcast_ctrl_hi, `UVM_REG_ADDR_WIDTH'hA179, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_mcast_ctrl_lo, `UVM_REG_ADDR_WIDTH'hA1F8, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_mcast_ctrl_hi, `UVM_REG_ADDR_WIDTH'hA1F9, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_bcast_ctrl_lo, `UVM_REG_ADDR_WIDTH'hA17A, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_bcast_ctrl_hi, `UVM_REG_ADDR_WIDTH'hA17B, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_bcast_ctrl_lo, `UVM_REG_ADDR_WIDTH'hA1FA, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_bcast_ctrl_hi, `UVM_REG_ADDR_WIDTH'hA1FB, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_pfc_lo, `UVM_REG_ADDR_WIDTH'hA17C, "RO");
          this.default_map.add_reg(mac_stats_cntr_tx_pfc_hi, `UVM_REG_ADDR_WIDTH'hA17D, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_pfc_lo, `UVM_REG_ADDR_WIDTH'hA1FC, "RO");
          this.default_map.add_reg(mac_stats_cntr_rx_pfc_hi, `UVM_REG_ADDR_WIDTH'hA1FD, "RO");
          this.default_map.add_reg(usxgmii_control, `UVM_REG_ADDR_WIDTH'h9400, "RW");
          this.default_map.add_reg(usxgmii_status, `UVM_REG_ADDR_WIDTH'h9401, "RO");
          this.default_map.add_reg(usxgmii_an_resp_mode, `UVM_REG_ADDR_WIDTH'h9403, "RW");
          this.default_map.add_reg(usxgmii_dev_ability, `UVM_REG_ADDR_WIDTH'h9404, "RW");
          this.default_map.add_reg(usxgmii_partner_ability, `UVM_REG_ADDR_WIDTH'h9405, "RO");
          this.default_map.add_reg(usxgmii_link_timer, `UVM_REG_ADDR_WIDTH'h9412, "RW");
          this.default_map.add_reg(phy_serial_loopback, `UVM_REG_ADDR_WIDTH'h9461, "RW");
          this.default_map.add_reg(FRM_ERR, `UVM_REG_ADDR_WIDTH'h9470, "RO");
          this.default_map.add_reg(SCLR_FRM_ERR, `UVM_REG_ADDR_WIDTH'h9471, "RW");
          //this.default_map.add_reg(RX_PCS_FULLY_ALIGNED_S, `UVM_REG_ADDR_WIDTH'h9472, "RO");
          
       endfunction : build
 
 endclass : registers_urm
