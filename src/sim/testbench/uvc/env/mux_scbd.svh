//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

`ifndef __MUX_SCBD_SVH__
`define __MUX_SCBD_SVH__


`define sb_info(msg,verbosity) \
  `uvm_info(get_name(),msg,verbosity)

`define sb_error(msg) \
  `uvm_error(get_name(),msg)

`define sb_fatal(msg) \
  `uvm_fatal(get_name(),msg)

`uvm_analysis_imp_decl(_exp)
`uvm_analysis_imp_decl(_act)

//------------------------------------------------------------------------------
// Class: mux_scbd
//   Generic Data Checker class for all required IPs
//   This class contains analysis import declaration.
//   Both actual and expected data for comparison are stored in this class.
//------------------------------------------------------------------------------
class mux_scbd #(type TRAN = svt_ethernet_transaction) extends altuvm_scoreboard;

  typedef enum {InOrder = 0,OutOfOrder = 1} compare_type_e;
  typedef enum {ENABLE = 0, DISABLE=1} data_checker_en_e;
  typedef enum {RCD_QUEUE = 0 , MATCH_QUEUE = 1} compare_order_e;

  typedef enum int {
    SB_NONE   = 0,
    SB_LOW    = 100,
    SB_MEDIUM = 200,
    SB_HIGH   = 300,
    SB_FULL   = 400,
    SB_DEBUG  = 500
                     } verbosity_e;
  //----------------------------------------
  // Name ID
  //----------------------------------------
  string name = "mux_scbd";

  //--------------------------------
  // Port: m_exp
  // Import port declaration of expected
  //--------------------------------
  uvm_analysis_imp_exp  #(TRAN, mux_scbd#(TRAN) ) m_exp ;

  //--------------------------------
  //Import port declaration of Actual
  //--------------------------------
  uvm_analysis_imp_act  #(TRAN, mux_scbd #(TRAN) ) m_act;

  //--------------------------------
  //Stores expected data
  //--------------------------------
  TRAN exp_q[$];

  //--------------------------------
  //Stores actual data
  //--------------------------------
  TRAN act_q[$];

  //--------------------------------
  //Stores sent and received time
  //--------------------------------
  realtime    sent_time[$];
  realtime    received_time[$];

  //--------------------------------
  //queue threshold
  //--------------------------------
  int unsigned queue_threshold = 65536;

  //--------------------------------
  //Represents the comparator type
  compare_type_e comparison_type = InOrder;


  //--------------------------------
  //Enable/Disable  Data comparision
  //--------------------------------
  data_checker_en_e data_checker_en = ENABLE;

  //--------------------------------
  // Stores count of received actual packets
  //--------------------------------
  int act_no   = 0;

  //--------------------------------
  // Stores count of received expected packets
  //--------------------------------
  int exp_no   = 0;

  // Variable: m_matches
  //   Counter for matched transaction
  int m_matches;

  // Variable: m_mismatches
  //   Counter for transaction which are not matched
  int m_mismatches;

  // Variable: m_mismatches
  //   Accumulator of payload length sent/requested
  int payload_length=0;

  `uvm_component_param_utils_begin(mux_scbd#(TRAN))
    `uvm_field_int(queue_threshold, UVM_ALL_ON);
    `uvm_field_enum(compare_type_e,comparison_type, UVM_ALL_ON)
    `uvm_field_enum(data_checker_en_e,data_checker_en, UVM_ALL_ON)
  `uvm_component_utils_end

  //------------------------------------------------------------------------------
  //  Function: new
  //
  //  This function is constructor of class.
  //
  //  Parameters:
  //
  //    name - name of object
  //    parent - methodology dependent
  //
  //  Return:
  //
  //   None
  //------------------------------------------------------------------------------

  function new ( string name = "mux_scbd", uvm_component parent = null);
    super.new(name,parent);
    this.name = name;
    m_exp = new ({name,"_Expected_port"},this);
    m_act = new ({name,"_Actual_port"},this);
  endfunction : new

  //------------------------------------------------------------------------------
  //  Function: print_info_msg
  //
  //    Print function to print the simple info message
  //
  //  Parameters:
  //
  //   msg - input message string
  //
  //  Return:
  //
  //   None
  //------------------------------------------------------------------------------

  function void print_info_msg(string msg);
    `sb_info({{name,"_DATA_CHECKER"},$psprintf(" %s",msg)},SB_LOW);
  endfunction :print_info_msg

  //------------------------------------------------------------------------------
  //  Function: print_fatal_error_msg
  //
  //     Print function to print the fatal error message
  //     when queue size goes greater then queue threshold value
  //
  //  Parameters:
  //
  //    None
  //
  //  Return:
  //
  //   None
  //------------------------------------------------------------------------------

  function void print_fatal_error_msg();
    `sb_fatal({{name,"_DATA_CHECKER"},
    $sformatf("Either Expected Queue size ('d%0d) or Actual Queue size('d%0d) is more than queue threshold value('d%0d)",
    exp_q.size(),act_q.size(), queue_threshold)});
  endfunction :print_fatal_error_msg

  //------------------------------------------------------------------------------
  //  Function: match_transaction_print
  //
  //    Print function to print the transaction match message
  //
  //  Parameters:
  //
  //  act - actutal packet handle
  //  exp - expected packet handle
  //
  //  Return:
  //
  //   None
  //------------------------------------------------------------------------------

  function void match_transaction_print(TRAN act,TRAN exp);
    `sb_info({{name,"_DATA_CHECKER"},
    $psprintf(" Actual transaction\n %s \nmatches with expected transaction\n%s",
    act.sprint,exp.sprint())},SB_DEBUG);
  endfunction

  //------------------------------------------------------------------------------
  //  Function: mismatch_inorder_transaction_print
  //
  //    Print function to print the transaction mismatch message when
  //    in order comparision checking
  //
  //  Parameters:
  //
  //    act - actutal packet handle
  //    exp - expected packet handle
  //
  //  Return:
  //
  //    None
  //------------------------------------------------------------------------------

  function void mismatch_inorder_transaction_print(TRAN act,TRAN exp);
    `sb_error({{name,"_DATA_CHECKER"},
    $psprintf(" Actual transaction\n %s \n does not match with expected transaction\n%s",
    act.sprint,exp.sprint())});
  endfunction

  //------------------------------------------------------------------------------
  //  Function: mismatch_outoforder_transaction_print
  //
  //      Print function to print the transaction mismatch message when
  //      out of order comparision checking
  //
  //  Parameters:
  //
  //  act - packet handle
  //
  //  Return:
  //
  //   None
  //------------------------------------------------------------------------------

  function void mismatch_outoforder_transaction_print(TRAN act);
    `sb_error({{name,"_DATA_CHECKER"},$psprintf(" Transaction does not match with any transaction\n %s",
    act.sprint())});
  endfunction

  //------------------------------------------------------------------------------
  //  Function: enable_data_checking
  //
  //    this method used to enable the data checking
  //
  //  Parameters:
  //
  //    None
  //
  //  Return:
  //
  //   None
  //------------------------------------------------------------------------------

  function void enable_data_checking();
    print_info_msg("Enable data checker");
    data_checker_en = ENABLE;
  endfunction : enable_data_checking

  //------------------------------------------------------------------------------
  //  Function: disable_data_checking
  //
  //    this method used to disable data checking
  //
  //  Parameters:
  //
  //    None
  //
  //  Return:
  //
  //   None
  //------------------------------------------------------------------------------

  function void disable_data_checking();
    print_info_msg("Disable data checker");
    data_checker_en = DISABLE;
  endfunction : disable_data_checking

  //------------------------------------------------------------------------------
  //  Function: clear_data_checker
  //
  //    this method used to clear data checker veriables and queues
  //
  //  Parameters:
  //
  //    None
  //
  //  Return:
  //
  //    None
  //------------------------------------------------------------------------------

  function void clear_data_checker();
    //comparator_summary();
    print_info_msg("Clearing data checker queues and count variables");
    exp_q.delete();
    act_q.delete();
    act_no = 0;
    exp_no = 0;
    m_matches    = 0;
    m_mismatches = 0;
  endfunction : clear_data_checker

  //------------------------------------------------------------------------------
  //  Function: set_compare_type_f
  //
  //      Set mux_scbd either in-order or out-of-order
  //      This method "set_compare_type_f" is use to set the mux_scbd type with
  //      either in-order or out-of-order as per the received input argument.
  //      Select variable for
  //      if c_type = InOrder    ,data checker is configured as IN ORDER comparision
  //      if c_type = OutOfOrder ,data checker is configured as OUT OF ORDER comparision
  //
  //  Parameters:
  //
  //   c_type - scoreboarding approach
  //
  //  Return:
  //
  //   None
  //------------------------------------------------------------------------------

function void set_compare_type_f(compare_type_e c_type = OutOfOrder);
  comparison_type = c_type;
endfunction :set_compare_type_f

  //------------------------------------------------------------------------------
  //  Function: write_exp
  //
  //   Write method for analysis import
  //   This method "write_pcie_exp" describes the write method for analysis import
  //   declared as "_pcie_exp"
  //
  //  Parameters:
  //
  //  trans_inst - packet handle
  //
  //  Return:
  //
  //   None
  //------------------------------------------------------------------------------

  function void write_exp(TRAN trans_inst);

    TRAN trans;

    if(trans == null)
    begin
      trans = new;
      trans.copy(trans_inst);
    end

    if(data_checker_en == ENABLE)
    begin
      exp_q.push_front(trans);
      exp_no = exp_no + 1;
      sent_time.push_back($realtime);
      trans.set_sequence_id(exp_no);

      if(exp_q.size() > 0 && act_q.size()>0)
      begin
        if(comparison_type == OutOfOrder)
        begin
          out_of_order_compare(exp_q,act_q,RCD_QUEUE);
        end
        else
        begin
          in_order_comparator(exp_q,act_q,RCD_QUEUE);
        end
      end

      if(exp_q.size()>queue_threshold ||
         act_q.size()>queue_threshold)
      begin
        comparator_summary();
        print_fatal_error_msg();
      end

    end

  endfunction : write_exp

  //------------------------------------------------------------------------------
  //  Function: write_act
  //
  //   Write method for analysis import
  //   This method "write_pcie_act" describes the write method for analysis import
  //   declared as "_pcie_act"
  //
  //  Parameters:
  //
  //  rhs_ - packet handle
  //
  //  Return:
  //
  //   bit
  //------------------------------------------------------------------------------

  function void write_act(TRAN trans_inst);
    TRAN trans;

    if(trans == null)
    begin
      trans = new;
      trans.copy(trans_inst);
    end

    if(data_checker_en == ENABLE)
    begin
      act_q.push_front(trans);
      act_no = act_no + 1;
      received_time.push_back($realtime);
      trans.set_sequence_id(act_no);

      if(exp_q.size() > 0 && act_q.size()>0)
      begin
        if(comparison_type == OutOfOrder)
        begin
          out_of_order_compare(act_q,exp_q,MATCH_QUEUE);
        end
        else
        begin
          in_order_comparator(act_q,exp_q,MATCH_QUEUE);
        end
      end

      if(exp_q.size()>queue_threshold || act_q.size()>queue_threshold)
      begin
        comparator_summary();
        print_fatal_error_msg();
      end

    end

  endfunction : write_act

  //------------------------------------------------------------------------------
  //  Function: out_of_order_compare
  //
  //    Out of order comaprison method
  //    This method "compare_out_order_t" performs data comparison in out of order.
  //
  //  Parameters:
  //
  //  received_queue - received packet queue
  //  match_queue    - just arrived packet queue
  //  compare_order  - comparison order
  //
  //  Return:
  //
  //   None
  //------------------------------------------------------------------------------

  function void out_of_order_compare(ref TRAN received_queue[$],
                                     ref TRAN match_queue[$],
                                     input compare_order_e compare_order);
    int match_found =0;
    int index =0;
    TRAN t;
    string cmp_string;

    `sb_info($psprintf("Out of order comparator"),SB_MEDIUM);
    t = received_queue.pop_back();

    foreach(match_queue[i])
    begin
      if((match_queue[i].compare(t)))//, cmp_string)))
      begin
        index = i;
        match_found = 1;
        break;
      end
    end

    if(match_found)
    begin
      if(compare_order == MATCH_QUEUE)
      begin
        match_transaction_print(t,match_queue[index]);
      end
      else
      begin
        match_transaction_print(match_queue[index],t);
      end
      match_queue.delete(index);
      m_matches = m_matches + 1;
    end
    else
    begin
      received_queue.push_front(t);
    end
  endfunction : out_of_order_compare

  //------------------------------------------------------------------------------
  //  Function: in_order_comparator
  //
  //    In order comaprison task
  //    This task "compare_in_order_t" performs data comparison in out of order.
  //
  //  Parameters:
  //
  //  received_queue - received packet queue
  //  match_queue    - just arrived packet queue
  //  compare_order  - comparison order
  //
  //  Return:
  //
  //   None
  //------------------------------------------------------------------------------

  function void in_order_comparator(ref TRAN received_queue[$],
                                    ref TRAN match_queue[$],
                                    input compare_order_e compare_order);
    TRAN rcvd;
    TRAN match;
    string msg;
    string cmp_string;

    `sb_info($psprintf("In order comparator"),SB_MEDIUM);
    rcvd = received_queue.pop_back();
    match = match_queue.pop_back();

    if(!(rcvd.compare(match)))//, cmp_string)))
    begin
      if(compare_order == MATCH_QUEUE)
      begin
        mismatch_inorder_transaction_print(rcvd,match);
      end
      else
      begin
        mismatch_inorder_transaction_print(match,rcvd);
      end
      m_mismatches = m_mismatches + 1;
      `uvm_info(get_full_name(), $sformatf("Mismatched fields:%s", cmp_string), UVM_NONE)
    end
    else
    begin
      if(compare_order == MATCH_QUEUE)
      begin
        match_transaction_print(rcvd,match);
      end
      else
      begin
        match_transaction_print(match,rcvd);
      end
      m_matches = m_matches + 1;
    end
  endfunction

  //------------------------------------------------------------------------------
  //  Function: report_phase
  //
  //    This method "report" is called automatically after run phase.
  //    This method prints report of total data transmitted/received/compared/mis-compared during entire stimulation.
  //
  //  Parameters:
  //
  //    None
  //
  //  Return:
  //
  //    None
  //------------------------------------------------------------------------------

  virtual function void report_phase(uvm_phase phase);
    comparator_summary();
  endfunction : report_phase

//  virtual function void pre_abort();
//    comparator_summary();
//  endfunction : pre_abort

  //------------------------------------------------------------------------------
  //  Function: comparator_summary
  //
  //  This method prints report of total data transmitted/received/compared/mis-compared during entire stimulation.
  //
  //  Parameters:
  //
  //     None
  //
  //  Return:
  //
  //     None
  //------------------------------------------------------------------------------

  function void comparator_summary();
   realtime last_rec_time;
   realtime first_sent_time;
   longint unsigned bytes;
   bit throughput_test;
   real throughput;

   if(data_checker_en == ENABLE)
    begin
	uvm_config_db#(bit)::get(null, this.get_full_name(), "throughput_test", throughput_test);

       `sb_info({ {name,"_DATA_CHECKER"},
       $psprintf({"\n||************************************||************************************||\n",
                    "||-    Expected  -||-   Actual       -||-   Matched   -||-  Mismatched     -||\n",
                    "||-      %3d     -||-    %3d         -||-     %3d     -||-     %3d         -||\n",
                    "||************************************||************************************||\n"},
       exp_no,act_no,m_matches,m_mismatches)},SB_NONE);

       if(exp_q.size > 0)
       begin
        `sb_error("Following Expected Transactions are not match with any transactions\n");
         foreach(exp_q[i])
         begin
           `sb_error($psprintf("\nTransaction No :: %0d \n %s",exp_q[i].get_sequence_id,exp_q[i].sprint()));
         end
       end

       if(act_q.size > 0)
        begin
          `sb_error("Following Actual Transactions are Not match with any transactions\n");
          foreach(act_q[i])
          begin
            `sb_error($psprintf("\nTransaction No :: %0d \n %s",act_q[i].get_sequence_id,act_q[i].sprint()));
          end
        end
       if(throughput_test) begin
	if(act_no>0) begin
		bytes=payload_length*4;
	 	`uvm_info(get_type_name(), $psprintf("Count is %d ", act_no), UVM_LOW);
	end

	first_sent_time=sent_time.pop_front();
	last_rec_time=received_time.pop_back();
	throughput=(bytes*1000)/(last_rec_time - first_sent_time);
	`uvm_info(get_type_name(), $psprintf("First sent and last received TIME IS %t : %t",first_sent_time,last_rec_time), UVM_LOW);
	`uvm_info(get_type_name(), $psprintf("Latency is  %t",(last_rec_time-first_sent_time)), UVM_LOW);
	`uvm_info(get_type_name(), $psprintf("Throughput is %g MB/s with %d byte payload ", throughput, bytes), UVM_LOW);
      end

    end

  endfunction : comparator_summary

  //------------------------------------------------------------------------------
  //  Function: get_before_fifo_size
  //
  //      Returns the number of available transactions in the before queue
  //
  //  Parameters:
  //
  //      None
  //
  //  Return:
  //
  //   int
  //------------------------------------------------------------------------------

  virtual function int get_before_fifo_size();
    return exp_q.size();
  endfunction : get_before_fifo_size

  //------------------------------------------------------------------------------
  //  Function: get_after_fifo_size
  //
  //    Returns the number of available transactions in the after queue
  //
  //  Parameters:
  //
  //   None
  //
  //  Return:
  //
  //   int
  //------------------------------------------------------------------------------

  virtual function int get_after_fifo_size();
    return act_q.size();
  endfunction : get_after_fifo_size
//-------------------------------------------------------------------------------------------------------------------------------------
task run_phase(uvm_phase phase);

endtask
////  Function: phase_ready_to_end
////  Description: UVM phase wait till exp and actual packet count are equal
////  before ending the test
////  Parameters: phase
////------------------------------------------------------------------------------
//
//function void phase_ready_to_end (uvm_phase phase);
// if(phase.is(uvm_run_phase::get)) begin
//   phase.raise_objection(this, "Test Not Yet Ready To End");
//   fork begin
//     `uvm_info("SB","Packets may be pending", UVM_LOW);
//     wait_to_finish();
//     phase.drop_objection(this, "All packets compared");
//   end
//   join_none
//
// end
//
//endfunction: phase_ready_to_end
////------------------------------------------------------------------------------
////  Function: wait_to_finish
////  Description: waits to check if all the packets have been checked
////  Parameters: none
////------------------------------------------------------------------------------
//
//task wait_to_finish(); // wait till all queues are empty
//
//	wait(exp_q.size==0);
//
//endtask : wait_to_finish
endclass : mux_scbd

`endif//__MUX_SCBD_SVH__
