`ifndef RAL_USER_CSR_SPACE
`define RAL_USER_CSR_SPACE

import uvm_pkg::*;

class ral_reg_user_csr_space_user_csr_space_block_STATUS_REG extends uvm_reg;
	uvm_reg_field Reserved;
	uvm_reg_field op_speed;
	uvm_reg_field rx_block_lock;
	uvm_reg_field tx_ready;
	uvm_reg_field rx_ready;
	uvm_reg_field mrphy_pll_lock;

	covergroup cg_vals ();
		option.per_instance = 1;
		Reserved_value : coverpoint Reserved.value {
			bins min = { 25'h0 };
			bins max = { 25'h1FFFFFF };
			bins others = { [25'h1:25'h1FFFFFE] };
			option.weight = 3;
		}
		op_speed_value : coverpoint op_speed.value[2:0] {
			option.weight = 8;
		}
		rx_block_lock_value : coverpoint rx_block_lock.value[0:0] {
			option.weight = 2;
		}
		tx_ready_value : coverpoint tx_ready.value[0:0] {
			option.weight = 2;
		}
		rx_ready_value : coverpoint rx_ready.value[0:0] {
			option.weight = 2;
		}
		mrphy_pll_lock_value : coverpoint mrphy_pll_lock.value[0:0] {
			option.weight = 2;
		}
	endgroup : cg_vals

	function new(string name = "user_csr_space_user_csr_space_block_STATUS_REG");
		super.new(name, 32,build_coverage(UVM_CVR_FIELD_VALS));
		add_coverage(build_coverage(UVM_CVR_FIELD_VALS));
		if (has_coverage(UVM_CVR_FIELD_VALS))
			cg_vals = new();
	endfunction: new
   virtual function void build();
      this.Reserved = uvm_reg_field::type_id::create("Reserved",,get_full_name());
      this.Reserved.configure(this, 25, 7, "RO", 0, 25'h0, 1, 0, 0);
      this.op_speed = uvm_reg_field::type_id::create("op_speed",,get_full_name());
      this.op_speed.configure(this, 3, 4, "RO", 0, 3'h4, 1, 0, 0);
      this.rx_block_lock = uvm_reg_field::type_id::create("rx_block_lock",,get_full_name());
      this.rx_block_lock.configure(this, 1, 3, "RO", 0, 1'h0, 1, 0, 0);
      this.tx_ready = uvm_reg_field::type_id::create("tx_ready",,get_full_name());
      this.tx_ready.configure(this, 1, 2, "RO", 0, 1'h0, 1, 0, 0);
      this.rx_ready = uvm_reg_field::type_id::create("rx_ready",,get_full_name());
      this.rx_ready.configure(this, 1, 1, "RO", 0, 1'h0, 1, 0, 0);
      this.mrphy_pll_lock = uvm_reg_field::type_id::create("mrphy_pll_lock",,get_full_name());
      this.mrphy_pll_lock.configure(this, 1, 0, "RO", 0, 1'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_user_csr_space_user_csr_space_block_STATUS_REG)


	function void sample_values();
	   super.sample_values();
	   if (get_coverage(UVM_CVR_FIELD_VALS)) begin
	      if(cg_vals!=null) cg_vals.sample();
	   end
	endfunction
endclass : ral_reg_user_csr_space_user_csr_space_block_STATUS_REG


class ral_reg_user_csr_space_user_csr_space_block_RESET_CTRL extends uvm_reg;
	uvm_reg_field Reserved;
	rand uvm_reg_field i_rx_rst_n;
	rand uvm_reg_field i_tx_rst_n;
	rand uvm_reg_field i_rst_n;

	covergroup cg_vals ();
		option.per_instance = 1;
		Reserved_value : coverpoint Reserved.value {
			bins min = { 29'h0 };
			bins max = { 29'h1FFFFFFF };
			bins others = { [29'h1:29'h1FFFFFFE] };
			option.weight = 3;
		}
		i_rx_rst_n_value : coverpoint i_rx_rst_n.value[0:0] {
			option.weight = 2;
		}
		i_tx_rst_n_value : coverpoint i_tx_rst_n.value[0:0] {
			option.weight = 2;
		}
		i_rst_n_value : coverpoint i_rst_n.value[0:0] {
			option.weight = 2;
		}
	endgroup : cg_vals

	function new(string name = "user_csr_space_user_csr_space_block_RESET_CTRL");
		super.new(name, 32,build_coverage(UVM_CVR_FIELD_VALS));
		add_coverage(build_coverage(UVM_CVR_FIELD_VALS));
		if (has_coverage(UVM_CVR_FIELD_VALS))
			cg_vals = new();
	endfunction: new
   virtual function void build();
      this.Reserved = uvm_reg_field::type_id::create("Reserved",,get_full_name());
      this.Reserved.configure(this, 29, 3, "RO", 0, 29'h0, 1, 0, 0);
      this.i_rx_rst_n = uvm_reg_field::type_id::create("i_rx_rst_n",,get_full_name());
      this.i_rx_rst_n.configure(this, 1, 2, "RW", 0, 1'h1, 1, 0, 0);
      this.i_tx_rst_n = uvm_reg_field::type_id::create("i_tx_rst_n",,get_full_name());
      this.i_tx_rst_n.configure(this, 1, 1, "RW", 0, 1'h1, 1, 0, 0);
      this.i_rst_n = uvm_reg_field::type_id::create("i_rst_n",,get_full_name());
      this.i_rst_n.configure(this, 1, 0, "RW", 0, 1'h1, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_user_csr_space_user_csr_space_block_RESET_CTRL)


	function void sample_values();
	   super.sample_values();
	   if (get_coverage(UVM_CVR_FIELD_VALS)) begin
	      if(cg_vals!=null) cg_vals.sample();
	   end
	endfunction
endclass : ral_reg_user_csr_space_user_csr_space_block_RESET_CTRL


class ral_reg_user_csr_space_user_csr_space_block_DELAY_TX extends uvm_reg;
	uvm_reg_field Reserved;
	uvm_reg_field Additional_User_added_delay1;

	covergroup cg_vals ();
		option.per_instance = 1;
		Reserved_value : coverpoint Reserved.value {
			bins min = { 28'h0 };
			bins max = { 28'hFFFFFFF };
			bins others = { [28'h1:28'hFFFFFFE] };
			option.weight = 3;
		}
		Additional_User_added_delay1_value : coverpoint Additional_User_added_delay1.value[3:0] {
			option.weight = 16;
		}
	endgroup : cg_vals

	function new(string name = "user_csr_space_user_csr_space_block_DELAY_TX");
		super.new(name, 32,build_coverage(UVM_CVR_FIELD_VALS));
		add_coverage(build_coverage(UVM_CVR_FIELD_VALS));
		if (has_coverage(UVM_CVR_FIELD_VALS))
			cg_vals = new();
	endfunction: new
   virtual function void build();
      this.Reserved = uvm_reg_field::type_id::create("Reserved",,get_full_name());
      this.Reserved.configure(this, 28, 4, "RO", 0, 28'h0, 1, 0, 0);
      this.Additional_User_added_delay1 = uvm_reg_field::type_id::create("Additional_User_added_delay1",,get_full_name());
      this.Additional_User_added_delay1.configure(this, 4, 0, "RO", 0, 4'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_user_csr_space_user_csr_space_block_DELAY_TX)


	function void sample_values();
	   super.sample_values();
	   if (get_coverage(UVM_CVR_FIELD_VALS)) begin
	      if(cg_vals!=null) cg_vals.sample();
	   end
	endfunction
endclass : ral_reg_user_csr_space_user_csr_space_block_DELAY_TX


class ral_reg_user_csr_space_user_csr_space_block_DELAY_RX extends uvm_reg;
	uvm_reg_field Reserved;
	uvm_reg_field Additional_User_added_delay1;

	covergroup cg_vals ();
		option.per_instance = 1;
		Reserved_value : coverpoint Reserved.value {
			bins min = { 28'h0 };
			bins max = { 28'hFFFFFFF };
			bins others = { [28'h1:28'hFFFFFFE] };
			option.weight = 3;
		}
		Additional_User_added_delay1_value : coverpoint Additional_User_added_delay1.value[3:0] {
			option.weight = 16;
		}
	endgroup : cg_vals

	function new(string name = "user_csr_space_user_csr_space_block_DELAY_RX");
		super.new(name, 32,build_coverage(UVM_CVR_FIELD_VALS));
		add_coverage(build_coverage(UVM_CVR_FIELD_VALS));
		if (has_coverage(UVM_CVR_FIELD_VALS))
			cg_vals = new();
	endfunction: new
   virtual function void build();
      this.Reserved = uvm_reg_field::type_id::create("Reserved",,get_full_name());
      this.Reserved.configure(this, 28, 4, "RO", 0, 28'h0, 1, 0, 0);
      this.Additional_User_added_delay1 = uvm_reg_field::type_id::create("Additional_User_added_delay1",,get_full_name());
      this.Additional_User_added_delay1.configure(this, 4, 0, "RO", 0, 4'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_user_csr_space_user_csr_space_block_DELAY_RX)


	function void sample_values();
	   super.sample_values();
	   if (get_coverage(UVM_CVR_FIELD_VALS)) begin
	      if(cg_vals!=null) cg_vals.sample();
	   end
	endfunction
endclass : ral_reg_user_csr_space_user_csr_space_block_DELAY_RX


class ral_reg_user_csr_space_user_csr_space_block_ERROR extends uvm_reg;
	uvm_reg_field Reserved;
	rand uvm_reg_field Unsupported_Speed_Error1;

	covergroup cg_vals ();
		option.per_instance = 1;
		Reserved_value : coverpoint Reserved.value {
			bins min = { 31'h0 };
			bins max = { 31'h7FFFFFFF };
			bins others = { [31'h1:31'h7FFFFFFE] };
			option.weight = 3;
		}
		Unsupported_Speed_Error1_value : coverpoint Unsupported_Speed_Error1.value[0:0] {
			option.weight = 2;
		}
	endgroup : cg_vals

	function new(string name = "user_csr_space_user_csr_space_block_ERROR");
		super.new(name, 32,build_coverage(UVM_CVR_FIELD_VALS));
		add_coverage(build_coverage(UVM_CVR_FIELD_VALS));
		if (has_coverage(UVM_CVR_FIELD_VALS))
			cg_vals = new();
	endfunction: new
   virtual function void build();
      this.Reserved = uvm_reg_field::type_id::create("Reserved",,get_full_name());
      this.Reserved.configure(this, 31, 1, "RO", 0, 31'h0, 1, 0, 0);
      this.Unsupported_Speed_Error1 = uvm_reg_field::type_id::create("Unsupported_Speed_Error1",,get_full_name());
      this.Unsupported_Speed_Error1.configure(this, 1, 0, "RW", 0, 1'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_user_csr_space_user_csr_space_block_ERROR)


	function void sample_values();
	   super.sample_values();
	   if (get_coverage(UVM_CVR_FIELD_VALS)) begin
	      if(cg_vals!=null) cg_vals.sample();
	   end
	endfunction
endclass : ral_reg_user_csr_space_user_csr_space_block_ERROR


class ral_reg_user_csr_space_user_csr_space_block_DR_STATUS extends uvm_reg;
	uvm_reg_field Reserved1;
	uvm_reg_field dr_new_cfg_applied;
	uvm_reg_field Reserved2;
	rand uvm_reg_field dr_error_status;

	covergroup cg_vals ();
		option.per_instance = 1;
		Reserved1_value : coverpoint Reserved1.value {
			bins min = { 15'h0 };
			bins max = { 15'h7FFF };
			bins others = { [15'h1:15'h7FFE] };
			option.weight = 3;
		}
		dr_new_cfg_applied_value : coverpoint dr_new_cfg_applied.value[0:0] {
			option.weight = 2;
		}
		Reserved2_value : coverpoint Reserved2.value {
			bins min = { 15'h0 };
			bins max = { 15'h7FFF };
			bins others = { [15'h1:15'h7FFE] };
			option.weight = 3;
		}
		dr_error_status_value : coverpoint dr_error_status.value[0:0] {
			option.weight = 2;
		}
	endgroup : cg_vals

	function new(string name = "user_csr_space_user_csr_space_block_DR_STATUS");
		super.new(name, 32,build_coverage(UVM_CVR_FIELD_VALS));
		add_coverage(build_coverage(UVM_CVR_FIELD_VALS));
		if (has_coverage(UVM_CVR_FIELD_VALS))
			cg_vals = new();
	endfunction: new
   virtual function void build();
      this.Reserved1 = uvm_reg_field::type_id::create("Reserved1",,get_full_name());
      this.Reserved1.configure(this, 15, 17, "RO", 0, 15'h0, 1, 0, 0);
      this.dr_new_cfg_applied = uvm_reg_field::type_id::create("dr_new_cfg_applied",,get_full_name());
      this.dr_new_cfg_applied.configure(this, 1, 16, "RO", 0, 1'h0, 1, 0, 0);
      this.Reserved2 = uvm_reg_field::type_id::create("Reserved2",,get_full_name());
      this.Reserved2.configure(this, 15, 1, "RO", 0, 15'h0, 1, 0, 0);
      this.dr_error_status = uvm_reg_field::type_id::create("dr_error_status",,get_full_name());
      this.dr_error_status.configure(this, 1, 0, "RW", 0, 1'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_user_csr_space_user_csr_space_block_DR_STATUS)


	function void sample_values();
	   super.sample_values();
	   if (get_coverage(UVM_CVR_FIELD_VALS)) begin
	      if(cg_vals!=null) cg_vals.sample();
	   end
	endfunction
endclass : ral_reg_user_csr_space_user_csr_space_block_DR_STATUS


class ral_reg_user_csr_space_user_csr_space_block_XCVR_MODE extends uvm_reg;
	uvm_reg_field Reserved;
	rand uvm_reg_field xcvr_mode;

	covergroup cg_vals ();
		option.per_instance = 1;
		Reserved_value : coverpoint Reserved.value {
			bins min = { 30'h0 };
			bins max = { 30'h3FFFFFFF };
			bins others = { [30'h1:30'h3FFFFFFE] };
			option.weight = 3;
		}
		xcvr_mode_value : coverpoint xcvr_mode.value[1:0] {
			option.weight = 4;
		}
	endgroup : cg_vals

	function new(string name = "user_csr_space_user_csr_space_block_XCVR_MODE");
		super.new(name, 32,build_coverage(UVM_CVR_FIELD_VALS));
		add_coverage(build_coverage(UVM_CVR_FIELD_VALS));
		if (has_coverage(UVM_CVR_FIELD_VALS))
			cg_vals = new();
	endfunction: new
   virtual function void build();
      this.Reserved = uvm_reg_field::type_id::create("Reserved",,get_full_name());
      this.Reserved.configure(this, 30, 2, "RO", 0, 30'h0, 1, 0, 0);
      this.xcvr_mode = uvm_reg_field::type_id::create("xcvr_mode",,get_full_name());
      this.xcvr_mode.configure(this, 2, 0, "RW", 0, 2'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_user_csr_space_user_csr_space_block_XCVR_MODE)


	function void sample_values();
	   super.sample_values();
	   if (get_coverage(UVM_CVR_FIELD_VALS)) begin
	      if(cg_vals!=null) cg_vals.sample();
	   end
	endfunction
endclass : ral_reg_user_csr_space_user_csr_space_block_XCVR_MODE


class ral_reg_user_csr_space_user_csr_space_block_PHY0_TX_DELAY extends uvm_reg;
	uvm_reg_field Reserved;
	uvm_reg_field Any_PHY_Delay;

	covergroup cg_vals ();
		option.per_instance = 1;
		Reserved_value : coverpoint Reserved.value {
			bins min = { 16'h0 };
			bins max = { 16'hFFFF };
			bins others = { [16'h1:16'hFFFE] };
			option.weight = 3;
		}
		Any_PHY_Delay_value : coverpoint Any_PHY_Delay.value {
			bins min = { 16'h0 };
			bins max = { 16'hFFFF };
			bins others = { [16'h1:16'hFFFE] };
			option.weight = 3;
		}
	endgroup : cg_vals

	function new(string name = "user_csr_space_user_csr_space_block_PHY0_TX_DELAY");
		super.new(name, 32,build_coverage(UVM_CVR_FIELD_VALS));
		add_coverage(build_coverage(UVM_CVR_FIELD_VALS));
		if (has_coverage(UVM_CVR_FIELD_VALS))
			cg_vals = new();
	endfunction: new
   virtual function void build();
      this.Reserved = uvm_reg_field::type_id::create("Reserved",,get_full_name());
      this.Reserved.configure(this, 16, 16, "RO", 0, 16'h0, 1, 0, 1);
      this.Any_PHY_Delay = uvm_reg_field::type_id::create("Any_PHY_Delay",,get_full_name());
      this.Any_PHY_Delay.configure(this, 16, 0, "RO", 0, 16'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_user_csr_space_user_csr_space_block_PHY0_TX_DELAY)


	function void sample_values();
	   super.sample_values();
	   if (get_coverage(UVM_CVR_FIELD_VALS)) begin
	      if(cg_vals!=null) cg_vals.sample();
	   end
	endfunction
endclass : ral_reg_user_csr_space_user_csr_space_block_PHY0_TX_DELAY


class ral_reg_user_csr_space_user_csr_space_block_PHY0_RX_DELAY extends uvm_reg;
	uvm_reg_field Reserved;
	uvm_reg_field Any_PHY_Delay;

	covergroup cg_vals ();
		option.per_instance = 1;
		Reserved_value : coverpoint Reserved.value {
			bins min = { 16'h0 };
			bins max = { 16'hFFFF };
			bins others = { [16'h1:16'hFFFE] };
			option.weight = 3;
		}
		Any_PHY_Delay_value : coverpoint Any_PHY_Delay.value {
			bins min = { 16'h0 };
			bins max = { 16'hFFFF };
			bins others = { [16'h1:16'hFFFE] };
			option.weight = 3;
		}
	endgroup : cg_vals

	function new(string name = "user_csr_space_user_csr_space_block_PHY0_RX_DELAY");
		super.new(name, 32,build_coverage(UVM_CVR_FIELD_VALS));
		add_coverage(build_coverage(UVM_CVR_FIELD_VALS));
		if (has_coverage(UVM_CVR_FIELD_VALS))
			cg_vals = new();
	endfunction: new
   virtual function void build();
      this.Reserved = uvm_reg_field::type_id::create("Reserved",,get_full_name());
      this.Reserved.configure(this, 16, 16, "RO", 0, 16'h0, 1, 0, 1);
      this.Any_PHY_Delay = uvm_reg_field::type_id::create("Any_PHY_Delay",,get_full_name());
      this.Any_PHY_Delay.configure(this, 16, 0, "RO", 0, 16'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_user_csr_space_user_csr_space_block_PHY0_RX_DELAY)


	function void sample_values();
	   super.sample_values();
	   if (get_coverage(UVM_CVR_FIELD_VALS)) begin
	      if(cg_vals!=null) cg_vals.sample();
	   end
	endfunction
endclass : ral_reg_user_csr_space_user_csr_space_block_PHY0_RX_DELAY


class ral_reg_user_csr_space_user_csr_space_block_Reserved extends uvm_reg;
	uvm_reg_field Reserved;

	covergroup cg_vals ();
		option.per_instance = 1;
		Reserved_value : coverpoint Reserved.value {
			bins min = { 32'h0 };
			bins max = { 32'hFFFFFFFF };
			bins others = { [32'h1:32'hFFFFFFFE] };
			option.weight = 3;
		}
	endgroup : cg_vals

	function new(string name = "user_csr_space_user_csr_space_block_Reserved");
		super.new(name, 32,build_coverage(UVM_CVR_FIELD_VALS));
		add_coverage(build_coverage(UVM_CVR_FIELD_VALS));
		if (has_coverage(UVM_CVR_FIELD_VALS))
			cg_vals = new();
	endfunction: new
   virtual function void build();
      this.Reserved = uvm_reg_field::type_id::create("Reserved",,get_full_name());
      this.Reserved.configure(this, 32, 0, "RO", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_user_csr_space_user_csr_space_block_Reserved)


	function void sample_values();
	   super.sample_values();
	   if (get_coverage(UVM_CVR_FIELD_VALS)) begin
	      if(cg_vals!=null) cg_vals.sample();
	   end
	endfunction
endclass : ral_reg_user_csr_space_user_csr_space_block_Reserved


class ral_block_user_csr_space_user_csr_space_block extends uvm_reg_block;
	rand ral_reg_user_csr_space_user_csr_space_block_STATUS_REG STATUS_REG;
	rand ral_reg_user_csr_space_user_csr_space_block_RESET_CTRL RESET_CTRL;
	rand ral_reg_user_csr_space_user_csr_space_block_DELAY_TX DELAY_TX;
	rand ral_reg_user_csr_space_user_csr_space_block_DELAY_RX DELAY_RX;
	rand ral_reg_user_csr_space_user_csr_space_block_ERROR ERROR;
	rand ral_reg_user_csr_space_user_csr_space_block_DR_STATUS DR_STATUS;
	rand ral_reg_user_csr_space_user_csr_space_block_XCVR_MODE XCVR_MODE;
	rand ral_reg_user_csr_space_user_csr_space_block_PHY0_TX_DELAY PHY0_TX_DELAY;
	rand ral_reg_user_csr_space_user_csr_space_block_PHY0_RX_DELAY PHY0_RX_DELAY;
	rand ral_reg_user_csr_space_user_csr_space_block_Reserved Reserved;
   local uvm_reg_data_t m_offset;
	uvm_reg_field STATUS_REG_Reserved;
	uvm_reg_field STATUS_REG_op_speed;
	uvm_reg_field op_speed;
	uvm_reg_field STATUS_REG_rx_block_lock;
	uvm_reg_field rx_block_lock;
	uvm_reg_field STATUS_REG_tx_ready;
	uvm_reg_field tx_ready;
	uvm_reg_field STATUS_REG_rx_ready;
	uvm_reg_field rx_ready;
	uvm_reg_field STATUS_REG_mrphy_pll_lock;
	uvm_reg_field mrphy_pll_lock;
	uvm_reg_field RESET_CTRL_Reserved;
	rand uvm_reg_field RESET_CTRL_i_rx_rst_n;
	rand uvm_reg_field i_rx_rst_n;
	rand uvm_reg_field RESET_CTRL_i_tx_rst_n;
	rand uvm_reg_field i_tx_rst_n;
	rand uvm_reg_field RESET_CTRL_i_rst_n;
	rand uvm_reg_field i_rst_n;
	uvm_reg_field DELAY_TX_Reserved;
	uvm_reg_field DELAY_TX_Additional_User_added_delay1;
	uvm_reg_field DELAY_RX_Reserved;
	uvm_reg_field DELAY_RX_Additional_User_added_delay1;
	uvm_reg_field ERROR_Reserved;
	rand uvm_reg_field ERROR_Unsupported_Speed_Error1;
	rand uvm_reg_field Unsupported_Speed_Error1;
	uvm_reg_field DR_STATUS_Reserved1;
	uvm_reg_field Reserved1;
	uvm_reg_field DR_STATUS_dr_new_cfg_applied;
	uvm_reg_field dr_new_cfg_applied;
	uvm_reg_field DR_STATUS_Reserved2;
	uvm_reg_field Reserved2;
	rand uvm_reg_field DR_STATUS_dr_error_status;
	rand uvm_reg_field dr_error_status;
	uvm_reg_field XCVR_MODE_Reserved;
	rand uvm_reg_field XCVR_MODE_xcvr_mode;
	rand uvm_reg_field xcvr_mode;
	uvm_reg_field PHY0_TX_DELAY_Reserved;
	uvm_reg_field PHY0_TX_DELAY_Any_PHY_Delay;
	uvm_reg_field PHY0_RX_DELAY_Reserved;
	uvm_reg_field PHY0_RX_DELAY_Any_PHY_Delay;
	uvm_reg_field Reserved_Reserved;


	covergroup cg_addr (input string name);
	option.per_instance = 1;
option.name = get_name();

	STATUS_REG : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h0 };
		option.weight = 1;
	}

	RESET_CTRL : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h4 };
		option.weight = 1;
	}

	DELAY_TX : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h8 };
		option.weight = 1;
	}

	DELAY_RX : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'hC };
		option.weight = 1;
	}

	ERROR : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h10 };
		option.weight = 1;
	}

	DR_STATUS : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h14 };
		option.weight = 1;
	}

	XCVR_MODE : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h18 };
		option.weight = 1;
	}

	PHY0_TX_DELAY : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h1C };
		option.weight = 1;
	}

	PHY0_RX_DELAY : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h20 };
		option.weight = 1;
	}

	Reserved : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h40 };
		option.weight = 1;
	}
endgroup
	function new(string name = "user_csr_space_user_csr_space_block");
		super.new(name, build_coverage(UVM_CVR_ADDR_MAP+UVM_CVR_FIELD_VALS));
		add_coverage(build_coverage(UVM_CVR_ADDR_MAP+UVM_CVR_FIELD_VALS));
		if (has_coverage(UVM_CVR_ADDR_MAP))
			cg_addr = new("cg_addr");
	endfunction: new

   virtual function void build();
      this.default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);
      this.STATUS_REG = ral_reg_user_csr_space_user_csr_space_block_STATUS_REG::type_id::create("STATUS_REG",,get_full_name());
      this.STATUS_REG.configure(this, null, "");
      this.STATUS_REG.build();
      this.default_map.add_reg(this.STATUS_REG, `UVM_REG_ADDR_WIDTH'h0, "RO", 0);
		this.STATUS_REG_Reserved = this.STATUS_REG.Reserved;
		this.STATUS_REG_op_speed = this.STATUS_REG.op_speed;
		this.op_speed = this.STATUS_REG.op_speed;
		this.STATUS_REG_rx_block_lock = this.STATUS_REG.rx_block_lock;
		this.rx_block_lock = this.STATUS_REG.rx_block_lock;
		this.STATUS_REG_tx_ready = this.STATUS_REG.tx_ready;
		this.tx_ready = this.STATUS_REG.tx_ready;
		this.STATUS_REG_rx_ready = this.STATUS_REG.rx_ready;
		this.rx_ready = this.STATUS_REG.rx_ready;
		this.STATUS_REG_mrphy_pll_lock = this.STATUS_REG.mrphy_pll_lock;
		this.mrphy_pll_lock = this.STATUS_REG.mrphy_pll_lock;
      this.RESET_CTRL = ral_reg_user_csr_space_user_csr_space_block_RESET_CTRL::type_id::create("RESET_CTRL",,get_full_name());
      this.RESET_CTRL.configure(this, null, "");
      this.RESET_CTRL.build();
      this.default_map.add_reg(this.RESET_CTRL, `UVM_REG_ADDR_WIDTH'h4, "RW", 0);
		this.RESET_CTRL_Reserved = this.RESET_CTRL.Reserved;
		this.RESET_CTRL_i_rx_rst_n = this.RESET_CTRL.i_rx_rst_n;
		this.i_rx_rst_n = this.RESET_CTRL.i_rx_rst_n;
		this.RESET_CTRL_i_tx_rst_n = this.RESET_CTRL.i_tx_rst_n;
		this.i_tx_rst_n = this.RESET_CTRL.i_tx_rst_n;
		this.RESET_CTRL_i_rst_n = this.RESET_CTRL.i_rst_n;
		this.i_rst_n = this.RESET_CTRL.i_rst_n;
      this.DELAY_TX = ral_reg_user_csr_space_user_csr_space_block_DELAY_TX::type_id::create("DELAY_TX",,get_full_name());
      this.DELAY_TX.configure(this, null, "");
      this.DELAY_TX.build();
      this.default_map.add_reg(this.DELAY_TX, `UVM_REG_ADDR_WIDTH'h8, "RO", 0);
		this.DELAY_TX_Reserved = this.DELAY_TX.Reserved;
		this.DELAY_TX_Additional_User_added_delay1 = this.DELAY_TX.Additional_User_added_delay1;
      this.DELAY_RX = ral_reg_user_csr_space_user_csr_space_block_DELAY_RX::type_id::create("DELAY_RX",,get_full_name());
      this.DELAY_RX.configure(this, null, "");
      this.DELAY_RX.build();
      this.default_map.add_reg(this.DELAY_RX, `UVM_REG_ADDR_WIDTH'hC, "RO", 0);
		this.DELAY_RX_Reserved = this.DELAY_RX.Reserved;
		this.DELAY_RX_Additional_User_added_delay1 = this.DELAY_RX.Additional_User_added_delay1;
      this.ERROR = ral_reg_user_csr_space_user_csr_space_block_ERROR::type_id::create("ERROR",,get_full_name());
      this.ERROR.configure(this, null, "");
      this.ERROR.build();
      this.default_map.add_reg(this.ERROR, `UVM_REG_ADDR_WIDTH'h10, "RW", 0);
		this.ERROR_Reserved = this.ERROR.Reserved;
		this.ERROR_Unsupported_Speed_Error1 = this.ERROR.Unsupported_Speed_Error1;
		this.Unsupported_Speed_Error1 = this.ERROR.Unsupported_Speed_Error1;
      this.DR_STATUS = ral_reg_user_csr_space_user_csr_space_block_DR_STATUS::type_id::create("DR_STATUS",,get_full_name());
      this.DR_STATUS.configure(this, null, "");
      this.DR_STATUS.build();
      this.default_map.add_reg(this.DR_STATUS, `UVM_REG_ADDR_WIDTH'h14, "RW", 0);
		this.DR_STATUS_Reserved1 = this.DR_STATUS.Reserved1;
		this.Reserved1 = this.DR_STATUS.Reserved1;
		this.DR_STATUS_dr_new_cfg_applied = this.DR_STATUS.dr_new_cfg_applied;
		this.dr_new_cfg_applied = this.DR_STATUS.dr_new_cfg_applied;
		this.DR_STATUS_Reserved2 = this.DR_STATUS.Reserved2;
		this.Reserved2 = this.DR_STATUS.Reserved2;
		this.DR_STATUS_dr_error_status = this.DR_STATUS.dr_error_status;
		this.dr_error_status = this.DR_STATUS.dr_error_status;
      this.XCVR_MODE = ral_reg_user_csr_space_user_csr_space_block_XCVR_MODE::type_id::create("XCVR_MODE",,get_full_name());
      this.XCVR_MODE.configure(this, null, "");
      this.XCVR_MODE.build();
      this.default_map.add_reg(this.XCVR_MODE, `UVM_REG_ADDR_WIDTH'h18, "RW", 0);
		this.XCVR_MODE_Reserved = this.XCVR_MODE.Reserved;
		this.XCVR_MODE_xcvr_mode = this.XCVR_MODE.xcvr_mode;
		this.xcvr_mode = this.XCVR_MODE.xcvr_mode;
      this.PHY0_TX_DELAY = ral_reg_user_csr_space_user_csr_space_block_PHY0_TX_DELAY::type_id::create("PHY0_TX_DELAY",,get_full_name());
      this.PHY0_TX_DELAY.configure(this, null, "");
      this.PHY0_TX_DELAY.build();
      this.default_map.add_reg(this.PHY0_TX_DELAY, `UVM_REG_ADDR_WIDTH'h1C, "RO", 0);
		this.PHY0_TX_DELAY_Reserved = this.PHY0_TX_DELAY.Reserved;
		this.PHY0_TX_DELAY_Any_PHY_Delay = this.PHY0_TX_DELAY.Any_PHY_Delay;
      this.PHY0_RX_DELAY = ral_reg_user_csr_space_user_csr_space_block_PHY0_RX_DELAY::type_id::create("PHY0_RX_DELAY",,get_full_name());
      this.PHY0_RX_DELAY.configure(this, null, "");
      this.PHY0_RX_DELAY.build();
      this.default_map.add_reg(this.PHY0_RX_DELAY, `UVM_REG_ADDR_WIDTH'h20, "RO", 0);
		this.PHY0_RX_DELAY_Reserved = this.PHY0_RX_DELAY.Reserved;
		this.PHY0_RX_DELAY_Any_PHY_Delay = this.PHY0_RX_DELAY.Any_PHY_Delay;
      this.Reserved = ral_reg_user_csr_space_user_csr_space_block_Reserved::type_id::create("Reserved",,get_full_name());
      this.Reserved.configure(this, null, "");
      this.Reserved.build();
      this.default_map.add_reg(this.Reserved, `UVM_REG_ADDR_WIDTH'h40, "RO", 0);
		this.Reserved_Reserved = this.Reserved.Reserved;
   endfunction : build

	`uvm_object_utils(ral_block_user_csr_space_user_csr_space_block)


function void sample(uvm_reg_addr_t offset,
                     bit            is_read,
                     uvm_reg_map    map);
  if (get_coverage(UVM_CVR_ADDR_MAP)) begin
    m_offset = offset;
    cg_addr.sample();
  end
endfunction

	function void sample_values();
	   super.sample_values();
		if (get_coverage(UVM_CVR_FIELD_VALS)) begin
			if (STATUS_REG.cg_vals != null) STATUS_REG.cg_vals.sample();
			if (RESET_CTRL.cg_vals != null) RESET_CTRL.cg_vals.sample();
			if (DELAY_TX.cg_vals != null) DELAY_TX.cg_vals.sample();
			if (DELAY_RX.cg_vals != null) DELAY_RX.cg_vals.sample();
			if (ERROR.cg_vals != null) ERROR.cg_vals.sample();
			if (DR_STATUS.cg_vals != null) DR_STATUS.cg_vals.sample();
			if (XCVR_MODE.cg_vals != null) XCVR_MODE.cg_vals.sample();
			if (PHY0_TX_DELAY.cg_vals != null) PHY0_TX_DELAY.cg_vals.sample();
			if (PHY0_RX_DELAY.cg_vals != null) PHY0_RX_DELAY.cg_vals.sample();
			if (Reserved.cg_vals != null) Reserved.cg_vals.sample();
		end
	endfunction
endclass : ral_block_user_csr_space_user_csr_space_block


class ral_sys_user_csr_space extends uvm_reg_block;

   rand ral_block_user_csr_space_user_csr_space_block user_csr_space_block;

	function new(string name = "user_csr_space");
		super.new(name);
	endfunction: new

	function void build();
      this.default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);
      this.user_csr_space_block = ral_block_user_csr_space_user_csr_space_block::type_id::create("user_csr_space_block",,get_full_name());
      this.user_csr_space_block.configure(this, "");
      this.user_csr_space_block.build();
      this.default_map.add_submap(this.user_csr_space_block.default_map, `UVM_REG_ADDR_WIDTH'h0);
	  uvm_config_db #(uvm_reg_block)::set(null,"","RegisterModel_Debug",this);
	endfunction : build

	`uvm_object_utils(ral_sys_user_csr_space)
endclass : ral_sys_user_csr_space



`endif
