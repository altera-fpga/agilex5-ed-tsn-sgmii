//
svt_axi_if axi_if();
assign axi_if.common_aclk = uif_cru.clk_mon[0];
assign axi_if.master_if[0].aresetn = uif_cru.rst_mon_n[0];
assign axi_if.slave_if[0].aresetn = uif_cru.rst_mon_n[0];

// Connnect master to slave loopback
// Fixme: This connection changes when DUT is instantiated
assign axi_if.master_if[0].tready = axi_if.slave_if[0].tready;
assign axi_if.slave_if[0].tvalid = axi_if.master_if[0].tvalid;
assign axi_if.slave_if[0].tdata  = axi_if.master_if[0].tdata;
assign axi_if.slave_if[0].tstrb  = axi_if.master_if[0].tstrb;
assign axi_if.slave_if[0].tdest  = axi_if.master_if[0].tdest;
assign axi_if.slave_if[0].tkeep  = axi_if.master_if[0].tkeep;
assign axi_if.slave_if[0].tlast  = axi_if.master_if[0].tlast;
assign axi_if.slave_if[0].tid    = axi_if.master_if[0].tid  ;
assign axi_if.slave_if[0].tuser  = axi_if.master_if[0].tuser;

//
initial begin
  uvm_config_db#(virtual svt_axi_if)::set(uvm_root::get(),"uvm_test_top.m_env.m_axi_st_env*", "vif", axi_if);
end
