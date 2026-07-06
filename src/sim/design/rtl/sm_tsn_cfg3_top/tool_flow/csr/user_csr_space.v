//-----------------------------------------------------------------------------------------------//
//   Generated with Magillem S.A. MRV generator.                                  
//   MRV generator version : 0.2
//   Protocol :  AVALON
//   Wait State : WS1_OUTPUT                                         
//   Date : Mon Oct 16 11:33:54 PDT 2023           
//-----------------------------------------------------------------------------------------------//


//-----------------------------------------------------------------------------------------------//
//   Verilog Register Bank
//   Component Name: user_csr_space
//   File Ref: /nfs/site/disks/swuser_work_hamiline/tsn/csr/user_csr_space/_workspace_mrv_gen_py_/xmlProject/_local_copy_Vendor_Library_user_csr_space_1.0.xml                                             
//   Magillem Version :   5.11.2.1                                                                         
//-----------------------------------------------------------------------------------------------//
// 
module user_csr_space (
// register offset : 0x00, field offset : 0, access : RO, STATUS_REG_PHY_0.mrphy_pll_lock
input   STATUS_REG_PHY_0_mrphy_pll_lock_i,
// register offset : 0x00, field offset : 1, access : RO, STATUS_REG_PHY_0.rx_ready
input   STATUS_REG_PHY_0_rx_ready_i,
// register offset : 0x00, field offset : 2, access : RO, STATUS_REG_PHY_0.tx_ready
input   STATUS_REG_PHY_0_tx_ready_i,
// register offset : 0x00, field offset : 3, access : RO, STATUS_REG_PHY_0.rx_block_lock
input   STATUS_REG_PHY_0_rx_block_lock_i,
// register offset : 0x00, field offset : 4, access : RO, STATUS_REG_PHY_0.op_speed
input  [2:0] STATUS_REG_PHY_0_op_speed_i,
// register offset : 0x00, field offset : 7, access : RO, STATUS_REG_PHY_0.Reserved
// register offset : 0x04, field offset : 0, access : RW, RESET_CTRL_PHY_0.i_rst_n
input   we_RESET_CTRL_PHY_0_i_rst_n,
input   RESET_CTRL_PHY_0_i_rst_n_i,
output  reg RESET_CTRL_PHY_0_i_rst_n,
// register offset : 0x04, field offset : 1, access : RW, RESET_CTRL_PHY_0.i_tx_rst_n
input   we_RESET_CTRL_PHY_0_i_tx_rst_n,
input   RESET_CTRL_PHY_0_i_tx_rst_n_i,
output  reg RESET_CTRL_PHY_0_i_tx_rst_n,
// register offset : 0x04, field offset : 2, access : RW, RESET_CTRL_PHY_0.i_rx_rst_n
input   we_RESET_CTRL_PHY_0_i_rx_rst_n,
input   RESET_CTRL_PHY_0_i_rx_rst_n_i,
output  reg RESET_CTRL_PHY_0_i_rx_rst_n,
// register offset : 0x04, field offset : 3, access : RO, RESET_CTRL_PHY_0.Reserved
// register offset : 0x08, field offset : 0, access : RO, DELAY_TX_PHY_0.Additional_User_added_delay3
// register offset : 0x08, field offset : 4, access : RO, DELAY_TX_PHY_0.Additional_User_added_delay2
// register offset : 0x08, field offset : 8, access : RO, DELAY_TX_PHY_0.Additional_User_added_delay1
// register offset : 0x08, field offset : 12, access : RO, DELAY_TX_PHY_0.Reserved
// register offset : 0x0c, field offset : 0, access : RO, DELAY_RX_PHY_0.Additional_User_added_delay3
// register offset : 0x0c, field offset : 4, access : RO, DELAY_RX_PHY_0.Additional_User_added_delay2
// register offset : 0x0c, field offset : 8, access : RO, DELAY_RX_PHY_0.Additional_User_added_delay1
// register offset : 0x0c, field offset : 12, access : RO, DELAY_RX_PHY_0.Reserved
// register offset : 0x10, field offset : 0, access : RW, ERROR.Unsupported_Speed_Error2
output  reg ERROR_Unsupported_Speed_Error2,
// register offset : 0x10, field offset : 1, access : RW, ERROR.Unsupported_Speed_Error1
output  reg[1:0] ERROR_Unsupported_Speed_Error1,
// register offset : 0x10, field offset : 3, access : RO, ERROR.Reserved
// register offset : 0x14, field offset : 0, access : RW, DR_STATUS.dr_error_status
input   we_DR_STATUS_dr_error_status,
input   DR_STATUS_dr_error_status_i,
output  reg DR_STATUS_dr_error_status,
// register offset : 0x14, field offset : 1, access : RO, DR_STATUS.Reserved2
// register offset : 0x14, field offset : 3, access : RO, DR_STATUS.Reserved1
// register offset : 0x18, field offset : 0, access : RO, PHY_DELAY.Any_PHY_Delay
input  [15:0] PHY_DELAY_Any_PHY_Delay_i,
// register offset : 0x18, field offset : 16, access : RO, PHY_DELAY.Reserved
// register offset : 0x20, field offset : 0, access : RO, STATUS_REG_PHY_1.mrphy_pll_lock



`ifdef CONCURRENT_TSN

input   STATUS_REG_PHY_1_mrphy_pll_lock_i,
// register offset : 0x20, field offset : 1, access : RO, STATUS_REG_PHY_1.rx_ready
input   STATUS_REG_PHY_1_rx_ready_i,
// register offset : 0x20, field offset : 2, access : RO, STATUS_REG_PHY_1.tx_ready
input   STATUS_REG_PHY_1_tx_ready_i,
// register offset : 0x20, field offset : 3, access : RO, STATUS_REG_PHY_1.rx_block_lock
input   STATUS_REG_PHY_1_rx_block_lock_i,
// register offset : 0x20, field offset : 4, access : RO, STATUS_REG_PHY_1.op_speed
input  [2:0] STATUS_REG_PHY_1_op_speed_i,
// register offset : 0x20, field offset : 7, access : RO, STATUS_REG_PHY_1.Reserved
// register offset : 0x24, field offset : 0, access : RW, RESET_CTRL_PHY_1.i_rst_n
input   we_RESET_CTRL_PHY_1_i_rst_n,
input   RESET_CTRL_PHY_1_i_rst_n_i,
output  reg RESET_CTRL_PHY_1_i_rst_n,
// register offset : 0x24, field offset : 1, access : RW, RESET_CTRL_PHY_1.i_tx_rst_n
input   we_RESET_CTRL_PHY_1_i_tx_rst_n,
input   RESET_CTRL_PHY_1_i_tx_rst_n_i,
output  reg RESET_CTRL_PHY_1_i_tx_rst_n,
// register offset : 0x24, field offset : 2, access : RW, RESET_CTRL_PHY_1.i_rx_rst_n
input   we_RESET_CTRL_PHY_1_i_rx_rst_n,
input   RESET_CTRL_PHY_1_i_rx_rst_n_i,
output  reg RESET_CTRL_PHY_1_i_rx_rst_n,
// register offset : 0x24, field offset : 3, access : RO, RESET_CTRL_PHY_1.Reserved
// register offset : 0x28, field offset : 0, access : RO, DELAY_TX_PHY_1.Additional_User_added_delay3
// register offset : 0x28, field offset : 4, access : RO, DELAY_TX_PHY_1.Additional_User_added_delay2
// register offset : 0x28, field offset : 8, access : RO, DELAY_TX_PHY_1.Additional_User_added_delay1
// register offset : 0x28, field offset : 12, access : RO, DELAY_TX_PHY_1.Reserved
// register offset : 0x2c, field offset : 0, access : RO, DELAY_RX_PHY_1.Additional_User_added_delay3
// register offset : 0x2c, field offset : 4, access : RO, DELAY_RX_PHY_1.Additional_User_added_delay2
// register offset : 0x2c, field offset : 8, access : RO, DELAY_RX_PHY_1.Additional_User_added_delay1
// register offset : 0x2c, field offset : 12, access : RO, DELAY_RX_PHY_1.Reserved
// register offset : 0x30, field offset : 0, access : RO, STATUS_REG_PHY_2.mrphy_pll_lock
input   STATUS_REG_PHY_2_mrphy_pll_lock_i,
// register offset : 0x30, field offset : 1, access : RO, STATUS_REG_PHY_2.rx_ready
input   STATUS_REG_PHY_2_rx_ready_i,
// register offset : 0x30, field offset : 2, access : RO, STATUS_REG_PHY_2.tx_ready
input   STATUS_REG_PHY_2_tx_ready_i,
// register offset : 0x30, field offset : 3, access : RO, STATUS_REG_PHY_2.rx_block_lock
input   STATUS_REG_PHY_2_rx_block_lock_i,
// register offset : 0x30, field offset : 4, access : RO, STATUS_REG_PHY_2.op_speed
input  [2:0] STATUS_REG_PHY_2_op_speed_i,
// register offset : 0x30, field offset : 7, access : RO, STATUS_REG_PHY_2.Reserved
// register offset : 0x34, field offset : 0, access : RW, RESET_CTRL_PHY_2.i_rst_n
input   we_RESET_CTRL_PHY_2_i_rst_n,
input   RESET_CTRL_PHY_2_i_rst_n_i,
output  reg RESET_CTRL_PHY_2_i_rst_n,
// register offset : 0x34, field offset : 1, access : RW, RESET_CTRL_PHY_2.i_tx_rst_n
input   we_RESET_CTRL_PHY_2_i_tx_rst_n,
input   RESET_CTRL_PHY_2_i_tx_rst_n_i,
output  reg RESET_CTRL_PHY_2_i_tx_rst_n,
// register offset : 0x34, field offset : 2, access : RW, RESET_CTRL_PHY_2.i_rx_rst_n
input   we_RESET_CTRL_PHY_2_i_rx_rst_n,
input   RESET_CTRL_PHY_2_i_rx_rst_n_i,
output  reg RESET_CTRL_PHY_2_i_rx_rst_n,

`endif

// register offset : 0x34, field offset : 3, access : RO, RESET_CTRL_PHY_2.Reserved
// register offset : 0x38, field offset : 0, access : RO, DELAY_TX_PHY_2.Additional_User_added_delay3
// register offset : 0x38, field offset : 4, access : RO, DELAY_TX_PHY_2.Additional_User_added_delay2
// register offset : 0x38, field offset : 8, access : RO, DELAY_TX_PHY_2.Additional_User_added_delay1
// register offset : 0x38, field offset : 12, access : RO, DELAY_TX_PHY_2.Reserved
// register offset : 0x3c, field offset : 0, access : RO, DELAY_RX_PHY_2.Additional_User_added_delay3
// register offset : 0x3c, field offset : 4, access : RO, DELAY_RX_PHY_2.Additional_User_added_delay2
// register offset : 0x3c, field offset : 8, access : RO, DELAY_RX_PHY_2.Additional_User_added_delay1
// register offset : 0x3c, field offset : 12, access : RO, DELAY_RX_PHY_2.Reserved
//Bus Interface
input clk,
input reset,
input [31:0] writedata,
input read,
input write,
input [3:0] byteenable,
output reg [31:0] readdata,
output reg readdatavalid,
input [5:0] address

);


wire reset_n = !reset;	
// Protocol management
// combinatorial read data signal declaration
reg [31:0] rdata_comb;

// synchronous process for the read
always @(posedge clk)  
   if (!reset_n) readdata[31:0] <= 32'h0; else readdata[31:0] <= rdata_comb[31:0];

// read data is always returned on the next cycle
always @( posedge clk)
   if (!reset_n) readdatavalid <= 1'b0; else readdatavalid <= read;
//
//  Protocol specific assignment to inside signals
//
wire  we = write;
wire  re = read;
wire [5:0] addr = address[5:0];
wire [31:0] din  = writedata [31:0];
// A write byte enable for each register
// register RESET_CTRL_PHY_0 with  writeType: write
wire	  we_RESET_CTRL_PHY_0		=	we  & (addr[5:0]  == 6'h04)	?	byteenable[0]	:	1'b0;
// register ERROR with  writeType: write
wire	  we_ERROR		=	we  & (addr[5:0]  == 6'h10)	?	byteenable[0]	:	1'b0;
// register DR_STATUS with  writeType: write
wire	  we_DR_STATUS		=	we  & (addr[5:0]  == 6'h14)	?	byteenable[0]	:	1'b0;
// register RESET_CTRL_PHY_1 with  writeType: write
wire	  we_RESET_CTRL_PHY_1		=	we  & (addr[5:0]  == 6'h24)	?	byteenable[0]	:	1'b0;
// register RESET_CTRL_PHY_2 with  writeType: write
wire	  we_RESET_CTRL_PHY_2		=	we  & (addr[5:0]  == 6'h34)	?	byteenable[0]	:	1'b0;

// A read byte enable for each register

/* Definitions of REGISTER "STATUS_REG_PHY_0" */

// STATUS_REG_PHY_0_mrphy_pll_lock
// bitfield description: Asserted when PLL in MRPHY soft logic is locked
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: STATUS_REG_PHY_0_mrphy_pll_lock_i 
// outputPort:  "" 
// NO register generated




// STATUS_REG_PHY_0_rx_ready
// bitfield description: Asserted when MRPHY RX is ready
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: STATUS_REG_PHY_0_rx_ready_i 
// outputPort:  "" 
// NO register generated




// STATUS_REG_PHY_0_tx_ready
// bitfield description: Asserted when MRPHY TX is ready
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: STATUS_REG_PHY_0_tx_ready_i 
// outputPort:  "" 
// NO register generated




// STATUS_REG_PHY_0_rx_block_lock
// bitfield description: Asserted when 66b block alignment is finished on all PCS virtual lanes
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: STATUS_REG_PHY_0_rx_block_lock_i 
// outputPort:  "" 
// NO register generated




// STATUS_REG_PHY_0_op_speed
// bitfield description: MRPHY Op speed - 2.5G
// customType:  RO
// hwAccess: WO 
// reset value : 0x4 
// inputPort: STATUS_REG_PHY_0_op_speed_i 
// outputPort:  "" 
// NO register generated




// STATUS_REG_PHY_0_Reserved
// bitfield description: Reserved
// customType:  RO
// hwAccess: NA 
// reset value : 0x0000000 
// NO register generated


/* Definitions of REGISTER "RESET_CTRL_PHY_0" */

// RESET_CTRL_PHY_0_i_rst_n
// bitfield description: Global reset to MRPHY.
// Self cleared on o_rst_ack_n
// customType:  RW
// hwAccess: RW 
// reset value : 0x0 
// inputPort: RESET_CTRL_PHY_0_i_rst_n_i 
// outputPort:  "" 
// hardware write enable:  "we_RESET_CTRL_PHY_0_i_rst_n"  



always @( posedge clk)
   if (!reset_n)  begin
      RESET_CTRL_PHY_0_i_rst_n <= 1'h0;
   end
   else begin
   if (we_RESET_CTRL_PHY_0) begin 
      RESET_CTRL_PHY_0_i_rst_n   <=  din[0];  //
   end
   else if (we_RESET_CTRL_PHY_0_i_rst_n && !we_RESET_CTRL_PHY_0) begin
      RESET_CTRL_PHY_0_i_rst_n   <=  RESET_CTRL_PHY_0_i_rst_n_i;
   end	
end

// RESET_CTRL_PHY_0_i_tx_rst_n
// bitfield description: Reset MRPHY TX path.
// Self cleared on o_rx_rst_ack_n
// customType:  RW
// hwAccess: RW 
// reset value : 0x0 
// inputPort: RESET_CTRL_PHY_0_i_tx_rst_n_i 
// outputPort:  "" 
// hardware write enable:  "we_RESET_CTRL_PHY_0_i_tx_rst_n"  



always @( posedge clk)
   if (!reset_n)  begin
      RESET_CTRL_PHY_0_i_tx_rst_n <= 1'h0;
   end
   else begin
   if (we_RESET_CTRL_PHY_0) begin 
      RESET_CTRL_PHY_0_i_tx_rst_n   <=  din[1];  //
   end
   else if (we_RESET_CTRL_PHY_0_i_tx_rst_n && !we_RESET_CTRL_PHY_0) begin
      RESET_CTRL_PHY_0_i_tx_rst_n   <=  RESET_CTRL_PHY_0_i_tx_rst_n_i;
   end	
end

// RESET_CTRL_PHY_0_i_rx_rst_n
// bitfield description: Reset MRPHY RX path.
// Self cleared on o_rx_rst_ack_n
// customType:  RW
// hwAccess: RW 
// reset value : 0x0 
// inputPort: RESET_CTRL_PHY_0_i_rx_rst_n_i 
// outputPort:  "" 
// hardware write enable:  "we_RESET_CTRL_PHY_0_i_rx_rst_n"  



always @( posedge clk)
   if (!reset_n)  begin
      RESET_CTRL_PHY_0_i_rx_rst_n <= 1'h0;
   end
   else begin
   if (we_RESET_CTRL_PHY_0) begin 
      RESET_CTRL_PHY_0_i_rx_rst_n   <=  din[2];  //
   end
   else if (we_RESET_CTRL_PHY_0_i_rx_rst_n && !we_RESET_CTRL_PHY_0) begin
      RESET_CTRL_PHY_0_i_rx_rst_n   <=  RESET_CTRL_PHY_0_i_rx_rst_n_i;
   end	
end

// RESET_CTRL_PHY_0_Reserved
// bitfield description: Reserved
// customType:  RO
// hwAccess: NA 
// reset value : 0x00000000 
// NO register generated


/* Definitions of REGISTER "DELAY_TX_PHY_0" */

// DELAY_TX_PHY_0_Additional_User_added_delay3
// bitfield description: Additional GMII Datapath Delay added by used if timing issue arise in number of clock cycles gmii8_tx_clkout
// customType:  RO
// hwAccess: RO 
// reset value : 0x0 
// NO register generated



// DELAY_TX_PHY_0_Additional_User_added_delay2
// bitfield description: Future - In concurrent use case
// customType:  RO
// hwAccess: RO 
// reset value : 0x0 
// NO register generated



// DELAY_TX_PHY_0_Additional_User_added_delay1
// bitfield description: Future - In concurrent use case
// customType:  RO
// hwAccess: RO 
// reset value : 0x0 
// NO register generated



// DELAY_TX_PHY_0_Reserved
// bitfield description: Reserved
// customType:  RO
// hwAccess: NA 
// reset value : 0x00000 
// NO register generated


/* Definitions of REGISTER "DELAY_RX_PHY_0" */

// DELAY_RX_PHY_0_Additional_User_added_delay3
// bitfield description: Additional GMII Datapath Delay added by used if timing issue arise in number of clock cycles gmii8_rx_clkout
// customType:  RO
// hwAccess: RO 
// reset value : 0x0 
// NO register generated



// DELAY_RX_PHY_0_Additional_User_added_delay2
// bitfield description: Future - In concurrent use case
// customType:  RO
// hwAccess: RO 
// reset value : 0x0 
// NO register generated



// DELAY_RX_PHY_0_Additional_User_added_delay1
// bitfield description: Future - In concurrent use case
// customType:  RO
// hwAccess: RO 
// reset value : 0x0 
// NO register generated



// DELAY_RX_PHY_0_Reserved
// bitfield description: Reserved
// customType:  RO
// hwAccess: NA 
// reset value : 0x00000 
// NO register generated


/* Definitions of REGISTER "ERROR" */

// ERROR_Unsupported_Speed_Error2
// bitfield description: Assert high when XGMAC publish unsupported speeds.
// SW to clear these bits once addressed
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      ERROR_Unsupported_Speed_Error2 <= 1'h0;
   end
   else begin
   if (we_ERROR) begin 
      ERROR_Unsupported_Speed_Error2   <=  din[0];  //
   end
end

// ERROR_Unsupported_Speed_Error1
// bitfield description: For concurrent Usecases
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      ERROR_Unsupported_Speed_Error1 <= 2'h0;
   end
   else begin
   if (we_ERROR) begin 
      ERROR_Unsupported_Speed_Error1[1:0]   <=  din[2:1];  //
   end
end

// ERROR_Reserved
// bitfield description: Reserved
// customType:  RO
// hwAccess: NA 
// reset value : 0x00000000 
// NO register generated


/* Definitions of REGISTER "DR_STATUS" */

// DR_STATUS_dr_error_status
// bitfield description: Comes from DR Controller
// customType:  RW
// hwAccess: RW 
// reset value : 0x0 
// inputPort: DR_STATUS_dr_error_status_i 
// outputPort:  "" 
// hardware write enable:  "we_DR_STATUS_dr_error_status"  



always @( posedge clk)
   if (!reset_n)  begin
      DR_STATUS_dr_error_status <= 1'h0;
   end
   else begin
   if (we_DR_STATUS) begin 
      DR_STATUS_dr_error_status   <=  din[0];  //
   end
   else if (we_DR_STATUS_dr_error_status && !we_DR_STATUS) begin
      DR_STATUS_dr_error_status   <=  DR_STATUS_dr_error_status_i;
   end	
end

// DR_STATUS_Reserved2
// customType:  RO
// hwAccess: RO 
// reset value : 0x0 
// NO register generated



// DR_STATUS_Reserved1
// bitfield description: Reserved
// customType:  RO
// hwAccess: NA 
// reset value : 0x00000000 
// NO register generated


/* Definitions of REGISTER "PHY_DELAY" */

// PHY_DELAY_Any_PHY_Delay
// bitfield description: FPGA IO to Marvell PHY
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000 
// inputPort: PHY_DELAY_Any_PHY_Delay_i 
// outputPort:  "" 
// NO register generated




// PHY_DELAY_Reserved
// bitfield description: Reserved
// customType:  RO
// hwAccess: NA 
// reset value : 0x0000 
// NO register generated


/* Definitions of REGISTER "STATUS_REG_PHY_1" */

// STATUS_REG_PHY_1_mrphy_pll_lock
// bitfield description: Asserted when PLL in MRPHY soft logic is locked
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: STATUS_REG_PHY_1_mrphy_pll_lock_i 
// outputPort:  "" 
// NO register generated




// STATUS_REG_PHY_1_rx_ready
// bitfield description: Asserted when MRPHY RX is ready
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: STATUS_REG_PHY_1_rx_ready_i 
// outputPort:  "" 
// NO register generated




// STATUS_REG_PHY_1_tx_ready
// bitfield description: Asserted when MRPHY TX is ready
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: STATUS_REG_PHY_1_tx_ready_i 
// outputPort:  "" 
// NO register generated




// STATUS_REG_PHY_1_rx_block_lock
// bitfield description: Asserted when 66b block alignment is finished on all PCS virtual lanes
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: STATUS_REG_PHY_1_rx_block_lock_i 
// outputPort:  "" 
// NO register generated




// STATUS_REG_PHY_1_op_speed
// bitfield description: MRPHY Op speed - 2.5G
// customType:  RO
// hwAccess: WO 
// reset value : 0x4 
// inputPort: STATUS_REG_PHY_1_op_speed_i 
// outputPort:  "" 
// NO register generated




// STATUS_REG_PHY_1_Reserved
// bitfield description: Reserved
// customType:  RO
// hwAccess: NA 
// reset value : 0x0000000 
// NO register generated


/* Definitions of REGISTER "RESET_CTRL_PHY_1" */

// RESET_CTRL_PHY_1_i_rst_n
// bitfield description: Global reset to MRPHY.
// Self cleared on o_rst_ack_n
// customType:  RW
// hwAccess: RW 
// reset value : 0x0 
// inputPort: RESET_CTRL_PHY_1_i_rst_n_i 
// outputPort:  "" 
// hardware write enable:  "we_RESET_CTRL_PHY_1_i_rst_n"  


`ifdef CONCURRENT_TSN

always @( posedge clk)
   if (!reset_n)  begin
      RESET_CTRL_PHY_1_i_rst_n <= 1'h0;
   end
   else begin
   if (we_RESET_CTRL_PHY_1) begin 
      RESET_CTRL_PHY_1_i_rst_n   <=  din[0];  //
   end
   else if (we_RESET_CTRL_PHY_1_i_rst_n && !we_RESET_CTRL_PHY_1) begin
      RESET_CTRL_PHY_1_i_rst_n   <=  RESET_CTRL_PHY_1_i_rst_n_i;
   end	
end

// RESET_CTRL_PHY_1_i_tx_rst_n
// bitfield description: Reset MRPHY TX path.
// Self cleared on o_rx_rst_ack_n
// customType:  RW
// hwAccess: RW 
// reset value : 0x0 
// inputPort: RESET_CTRL_PHY_1_i_tx_rst_n_i 
// outputPort:  "" 
// hardware write enable:  "we_RESET_CTRL_PHY_1_i_tx_rst_n"  



always @( posedge clk)
   if (!reset_n)  begin
      RESET_CTRL_PHY_1_i_tx_rst_n <= 1'h0;
   end
   else begin
   if (we_RESET_CTRL_PHY_1) begin 
      RESET_CTRL_PHY_1_i_tx_rst_n   <=  din[1];  //
   end
   else if (we_RESET_CTRL_PHY_1_i_tx_rst_n && !we_RESET_CTRL_PHY_1) begin
      RESET_CTRL_PHY_1_i_tx_rst_n   <=  RESET_CTRL_PHY_1_i_tx_rst_n_i;
   end	
end

// RESET_CTRL_PHY_1_i_rx_rst_n
// bitfield description: Reset MRPHY RX path.
// Self cleared on o_rx_rst_ack_n
// customType:  RW
// hwAccess: RW 
// reset value : 0x0 
// inputPort: RESET_CTRL_PHY_1_i_rx_rst_n_i 
// outputPort:  "" 
// hardware write enable:  "we_RESET_CTRL_PHY_1_i_rx_rst_n"  



always @( posedge clk)
   if (!reset_n)  begin
      RESET_CTRL_PHY_1_i_rx_rst_n <= 1'h0;
   end
   else begin
   if (we_RESET_CTRL_PHY_1) begin 
      RESET_CTRL_PHY_1_i_rx_rst_n   <=  din[2];  //
   end
   else if (we_RESET_CTRL_PHY_1_i_rx_rst_n && !we_RESET_CTRL_PHY_1) begin
      RESET_CTRL_PHY_1_i_rx_rst_n   <=  RESET_CTRL_PHY_1_i_rx_rst_n_i;
   end	
end

// RESET_CTRL_PHY_1_Reserved
// bitfield description: Reserved
// customType:  RO
// hwAccess: NA 
// reset value : 0x00000000 
// NO register generated


/* Definitions of REGISTER "DELAY_TX_PHY_1" */

// DELAY_TX_PHY_1_Additional_User_added_delay3
// bitfield description: Additional GMII Datapath Delay added by used if timing issue arise in number of clock cycles gmii8_tx_clkout
// customType:  RO
// hwAccess: RO 
// reset value : 0x0 
// NO register generated



// DELAY_TX_PHY_1_Additional_User_added_delay2
// bitfield description: Future - In concurrent use case
// customType:  RO
// hwAccess: RO 
// reset value : 0x0 
// NO register generated



// DELAY_TX_PHY_1_Additional_User_added_delay1
// bitfield description: Future - In concurrent use case
// customType:  RO
// hwAccess: RO 
// reset value : 0x0 
// NO register generated



// DELAY_TX_PHY_1_Reserved
// bitfield description: Reserved
// customType:  RO
// hwAccess: NA 
// reset value : 0x00000 
// NO register generated


/* Definitions of REGISTER "DELAY_RX_PHY_1" */

// DELAY_RX_PHY_1_Additional_User_added_delay3
// bitfield description: Additional GMII Datapath Delay added by used if timing issue arise in number of clock cycles gmii8_rx_clkout
// customType:  RO
// hwAccess: RO 
// reset value : 0x0 
// NO register generated



// DELAY_RX_PHY_1_Additional_User_added_delay2
// bitfield description: Future - In concurrent use case
// customType:  RO
// hwAccess: RO 
// reset value : 0x0 
// NO register generated



// DELAY_RX_PHY_1_Additional_User_added_delay1
// bitfield description: Future - In concurrent use case
// customType:  RO
// hwAccess: RO 
// reset value : 0x0 
// NO register generated



// DELAY_RX_PHY_1_Reserved
// bitfield description: Reserved
// customType:  RO
// hwAccess: NA 
// reset value : 0x00000 
// NO register generated


/* Definitions of REGISTER "STATUS_REG_PHY_2" */

// STATUS_REG_PHY_2_mrphy_pll_lock
// bitfield description: Asserted when PLL in MRPHY soft logic is locked
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: STATUS_REG_PHY_2_mrphy_pll_lock_i 
// outputPort:  "" 
// NO register generated




// STATUS_REG_PHY_2_rx_ready
// bitfield description: Asserted when MRPHY RX is ready
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: STATUS_REG_PHY_2_rx_ready_i 
// outputPort:  "" 
// NO register generated




// STATUS_REG_PHY_2_tx_ready
// bitfield description: Asserted when MRPHY TX is ready
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: STATUS_REG_PHY_2_tx_ready_i 
// outputPort:  "" 
// NO register generated




// STATUS_REG_PHY_2_rx_block_lock
// bitfield description: Asserted when 66b block alignment is finished on all PCS virtual lanes
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: STATUS_REG_PHY_2_rx_block_lock_i 
// outputPort:  "" 
// NO register generated




// STATUS_REG_PHY_2_op_speed
// bitfield description: MRPHY Op speed - 2.5G
// customType:  RO
// hwAccess: WO 
// reset value : 0x4 
// inputPort: STATUS_REG_PHY_2_op_speed_i 
// outputPort:  "" 
// NO register generated




// STATUS_REG_PHY_2_Reserved
// bitfield description: Reserved
// customType:  RO
// hwAccess: NA 
// reset value : 0x0000000 
// NO register generated


/* Definitions of REGISTER "RESET_CTRL_PHY_2" */

// RESET_CTRL_PHY_2_i_rst_n
// bitfield description: Global reset to MRPHY.
// Self cleared on o_rst_ack_n
// customType:  RW
// hwAccess: RW 
// reset value : 0x0 
// inputPort: RESET_CTRL_PHY_2_i_rst_n_i 
// outputPort:  "" 
// hardware write enable:  "we_RESET_CTRL_PHY_2_i_rst_n"  



always @( posedge clk)
   if (!reset_n)  begin
      RESET_CTRL_PHY_2_i_rst_n <= 1'h0;
   end
   else begin
   if (we_RESET_CTRL_PHY_2) begin 
      RESET_CTRL_PHY_2_i_rst_n   <=  din[0];  //
   end
   else if (we_RESET_CTRL_PHY_2_i_rst_n && !we_RESET_CTRL_PHY_2) begin
      RESET_CTRL_PHY_2_i_rst_n   <=  RESET_CTRL_PHY_2_i_rst_n_i;
   end	
end

// RESET_CTRL_PHY_2_i_tx_rst_n
// bitfield description: Reset MRPHY TX path.
// Self cleared on o_rx_rst_ack_n
// customType:  RW
// hwAccess: RW 
// reset value : 0x0 
// inputPort: RESET_CTRL_PHY_2_i_tx_rst_n_i 
// outputPort:  "" 
// hardware write enable:  "we_RESET_CTRL_PHY_2_i_tx_rst_n"  



always @( posedge clk)
   if (!reset_n)  begin
      RESET_CTRL_PHY_2_i_tx_rst_n <= 1'h0;
   end
   else begin
   if (we_RESET_CTRL_PHY_2) begin 
      RESET_CTRL_PHY_2_i_tx_rst_n   <=  din[1];  //
   end
   else if (we_RESET_CTRL_PHY_2_i_tx_rst_n && !we_RESET_CTRL_PHY_2) begin
      RESET_CTRL_PHY_2_i_tx_rst_n   <=  RESET_CTRL_PHY_2_i_tx_rst_n_i;
   end	
end

// RESET_CTRL_PHY_2_i_rx_rst_n
// bitfield description: Reset MRPHY RX path.
// Self cleared on o_rx_rst_ack_n
// customType:  RW
// hwAccess: RW 
// reset value : 0x0 
// inputPort: RESET_CTRL_PHY_2_i_rx_rst_n_i 
// outputPort:  "" 
// hardware write enable:  "we_RESET_CTRL_PHY_2_i_rx_rst_n"  



always @( posedge clk)
   if (!reset_n)  begin
      RESET_CTRL_PHY_2_i_rx_rst_n <= 1'h0;
   end
   else begin
   if (we_RESET_CTRL_PHY_2) begin 
      RESET_CTRL_PHY_2_i_rx_rst_n   <=  din[2];  //
   end
   else if (we_RESET_CTRL_PHY_2_i_rx_rst_n && !we_RESET_CTRL_PHY_2) begin
      RESET_CTRL_PHY_2_i_rx_rst_n   <=  RESET_CTRL_PHY_2_i_rx_rst_n_i;
   end	
end

// RESET_CTRL_PHY_2_Reserved
// bitfield description: Reserved
// customType:  RO
// hwAccess: NA 
// reset value : 0x00000000 
// NO register generated


/* Definitions of REGISTER "DELAY_TX_PHY_2" */

// DELAY_TX_PHY_2_Additional_User_added_delay3
// bitfield description: Additional GMII Datapath Delay added by used if timing issue arise in number of clock cycles gmii8_tx_clkout
// customType:  RO
// hwAccess: RO 
// reset value : 0x0 
// NO register generated



// DELAY_TX_PHY_2_Additional_User_added_delay2
// bitfield description: Future - In concurrent use case
// customType:  RO
// hwAccess: RO 
// reset value : 0x0 
// NO register generated



// DELAY_TX_PHY_2_Additional_User_added_delay1
// bitfield description: Future - In concurrent use case
// customType:  RO
// hwAccess: RO 
// reset value : 0x0 
// NO register generated



// DELAY_TX_PHY_2_Reserved
// bitfield description: Reserved
// customType:  RO
// hwAccess: NA 
// reset value : 0x00000 
// NO register generated


/* Definitions of REGISTER "DELAY_RX_PHY_2" */

// DELAY_RX_PHY_2_Additional_User_added_delay3
// bitfield description: Additional GMII Datapath Delay added by used if timing issue arise in number of clock cycles gmii8_rx_clkout
// customType:  RO
// hwAccess: RO 
// reset value : 0x0 
// NO register generated



// DELAY_RX_PHY_2_Additional_User_added_delay2
// bitfield description: Future - In concurrent use case
// customType:  RO
// hwAccess: RO 
// reset value : 0x0 
// NO register generated



// DELAY_RX_PHY_2_Additional_User_added_delay1
// bitfield description: Future - In concurrent use case
// customType:  RO
// hwAccess: RO 
// reset value : 0x0 
// NO register generated



// DELAY_RX_PHY_2_Reserved
// bitfield description: Reserved
// customType:  RO
// hwAccess: NA 
// reset value : 0x00000 
// NO register generated

`endif


// read process
always @ (*)
begin
rdata_comb = 32'h00000000;
   if(re) begin
      case (addr)  
	6'h00 : begin
		rdata_comb [0]	= STATUS_REG_PHY_0_mrphy_pll_lock_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= STATUS_REG_PHY_0_rx_ready_i  ;		// readType = read   writeType =illegal
		rdata_comb [2]	= STATUS_REG_PHY_0_tx_ready_i  ;		// readType = read   writeType =illegal
		rdata_comb [3]	= STATUS_REG_PHY_0_rx_block_lock_i  ;		// readType = read   writeType =illegal
		rdata_comb [6:4]	= STATUS_REG_PHY_0_op_speed_i [2:0] ;		// readType = read   writeType =illegal
		rdata_comb [31:7]	= 25'h0000000 ;  // STATUS_REG_PHY_0_Reserved 	is reserved or a constant value, a read access gives the reset value
	end
	6'h04 : begin
		rdata_comb [0]	= RESET_CTRL_PHY_0_i_rst_n  ;		// readType = read   writeType =write
		rdata_comb [1]	= RESET_CTRL_PHY_0_i_tx_rst_n  ;		// readType = read   writeType =write
		rdata_comb [2]	= RESET_CTRL_PHY_0_i_rx_rst_n  ;		// readType = read   writeType =write
		rdata_comb [31:3]	= 29'h00000000 ;  // RESET_CTRL_PHY_0_Reserved 	is reserved or a constant value, a read access gives the reset value
	end
	6'h08 : begin
		rdata_comb [3:0]	= 4'h0 ;  // DELAY_TX_PHY_0_Additional_User_added_delay3 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [7:4]	= 4'h0 ;  // DELAY_TX_PHY_0_Additional_User_added_delay2 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [11:8]	= 4'h0 ;  // DELAY_TX_PHY_0_Additional_User_added_delay1 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [31:12]	= 20'h00000 ;  // DELAY_TX_PHY_0_Reserved 	is reserved or a constant value, a read access gives the reset value
	end
	6'h0c : begin
		rdata_comb [3:0]	= 4'h0 ;  // DELAY_RX_PHY_0_Additional_User_added_delay3 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [7:4]	= 4'h0 ;  // DELAY_RX_PHY_0_Additional_User_added_delay2 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [11:8]	= 4'h0 ;  // DELAY_RX_PHY_0_Additional_User_added_delay1 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [31:12]	= 20'h00000 ;  // DELAY_RX_PHY_0_Reserved 	is reserved or a constant value, a read access gives the reset value
	end
	6'h10 : begin
		rdata_comb [0]	= ERROR_Unsupported_Speed_Error2  ;		// readType = read   writeType =write
		rdata_comb [2:1]	= ERROR_Unsupported_Speed_Error1 [1:0] ;		// readType = read   writeType =write
		rdata_comb [31:3]	= 29'h00000000 ;  // ERROR_Reserved 	is reserved or a constant value, a read access gives the reset value
	end
	6'h14 : begin
		rdata_comb [0]	= DR_STATUS_dr_error_status  ;		// readType = read   writeType =write
		rdata_comb [2:1]	= 2'h0 ;  // DR_STATUS_Reserved2 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [31:3]	= 29'h00000000 ;  // DR_STATUS_Reserved1 	is reserved or a constant value, a read access gives the reset value
	end
	6'h18 : begin
		rdata_comb [15:0]	= PHY_DELAY_Any_PHY_Delay_i [15:0] ;		// readType = read   writeType =illegal
		rdata_comb [31:16]	= 16'h0000 ;  // PHY_DELAY_Reserved 	is reserved or a constant value, a read access gives the reset value
	end
	
	`ifdef CONCURRENT_TSN
	
	6'h20 : begin
		rdata_comb [0]	= STATUS_REG_PHY_1_mrphy_pll_lock_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= STATUS_REG_PHY_1_rx_ready_i  ;		// readType = read   writeType =illegal
		rdata_comb [2]	= STATUS_REG_PHY_1_tx_ready_i  ;		// readType = read   writeType =illegal
		rdata_comb [3]	= STATUS_REG_PHY_1_rx_block_lock_i  ;		// readType = read   writeType =illegal
		rdata_comb [6:4]	= STATUS_REG_PHY_1_op_speed_i [2:0] ;		// readType = read   writeType =illegal
		rdata_comb [31:7]	= 25'h0000000 ;  // STATUS_REG_PHY_1_Reserved 	is reserved or a constant value, a read access gives the reset value
	end
	6'h24 : begin
		rdata_comb [0]	= RESET_CTRL_PHY_1_i_rst_n  ;		// readType = read   writeType =write
		rdata_comb [1]	= RESET_CTRL_PHY_1_i_tx_rst_n  ;		// readType = read   writeType =write
		rdata_comb [2]	= RESET_CTRL_PHY_1_i_rx_rst_n  ;		// readType = read   writeType =write
		rdata_comb [31:3]	= 29'h00000000 ;  // RESET_CTRL_PHY_1_Reserved 	is reserved or a constant value, a read access gives the reset value
	end
	6'h28 : begin
		rdata_comb [3:0]	= 4'h0 ;  // DELAY_TX_PHY_1_Additional_User_added_delay3 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [7:4]	= 4'h0 ;  // DELAY_TX_PHY_1_Additional_User_added_delay2 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [11:8]	= 4'h0 ;  // DELAY_TX_PHY_1_Additional_User_added_delay1 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [31:12]	= 20'h00000 ;  // DELAY_TX_PHY_1_Reserved 	is reserved or a constant value, a read access gives the reset value
	end
	6'h2c : begin
		rdata_comb [3:0]	= 4'h0 ;  // DELAY_RX_PHY_1_Additional_User_added_delay3 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [7:4]	= 4'h0 ;  // DELAY_RX_PHY_1_Additional_User_added_delay2 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [11:8]	= 4'h0 ;  // DELAY_RX_PHY_1_Additional_User_added_delay1 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [31:12]	= 20'h00000 ;  // DELAY_RX_PHY_1_Reserved 	is reserved or a constant value, a read access gives the reset value
	end
	6'h30 : begin
		rdata_comb [0]	= STATUS_REG_PHY_2_mrphy_pll_lock_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= STATUS_REG_PHY_2_rx_ready_i  ;		// readType = read   writeType =illegal
		rdata_comb [2]	= STATUS_REG_PHY_2_tx_ready_i  ;		// readType = read   writeType =illegal
		rdata_comb [3]	= STATUS_REG_PHY_2_rx_block_lock_i  ;		// readType = read   writeType =illegal
		rdata_comb [6:4]	= STATUS_REG_PHY_2_op_speed_i [2:0] ;		// readType = read   writeType =illegal
		rdata_comb [31:7]	= 25'h0000000 ;  // STATUS_REG_PHY_2_Reserved 	is reserved or a constant value, a read access gives the reset value
	end
	6'h34 : begin
		rdata_comb [0]	= RESET_CTRL_PHY_2_i_rst_n  ;		// readType = read   writeType =write
		rdata_comb [1]	= RESET_CTRL_PHY_2_i_tx_rst_n  ;		// readType = read   writeType =write
		rdata_comb [2]	= RESET_CTRL_PHY_2_i_rx_rst_n  ;		// readType = read   writeType =write
		rdata_comb [31:3]	= 29'h00000000 ;  // RESET_CTRL_PHY_2_Reserved 	is reserved or a constant value, a read access gives the reset value
	end
	6'h38 : begin
		rdata_comb [3:0]	= 4'h0 ;  // DELAY_TX_PHY_2_Additional_User_added_delay3 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [7:4]	= 4'h0 ;  // DELAY_TX_PHY_2_Additional_User_added_delay2 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [11:8]	= 4'h0 ;  // DELAY_TX_PHY_2_Additional_User_added_delay1 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [31:12]	= 20'h00000 ;  // DELAY_TX_PHY_2_Reserved 	is reserved or a constant value, a read access gives the reset value
	end
	6'h3c : begin
		rdata_comb [3:0]	= 4'h0 ;  // DELAY_RX_PHY_2_Additional_User_added_delay3 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [7:4]	= 4'h0 ;  // DELAY_RX_PHY_2_Additional_User_added_delay2 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [11:8]	= 4'h0 ;  // DELAY_RX_PHY_2_Additional_User_added_delay1 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [31:12]	= 20'h00000 ;  // DELAY_RX_PHY_2_Reserved 	is reserved or a constant value, a read access gives the reset value
	end
	
	`endif
	
	default : begin
		rdata_comb = 32'h00000000;
	end
      endcase
   end
end

endmodule
