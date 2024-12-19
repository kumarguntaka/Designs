class our_monitor extends uvm_monitor;
  `uvm_component_utils(our_monitor)

  virtual intf vif_1;
  seq_item trans_dut[$];
  uvm_analysis_port#(seq_item) request_in_port;
  uvm_analysis_port#(seq_item) request_out_port;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    assert(uvm_config_db#(virtual intf)::get(null, "", "vif", vif_1)) 
    else begin
      `uvm_fatal("ALU_MONITOR", "Unable to get FP_ALU interface!")
    end
    request_in_port = new("request_in_port", this);
    request_out_port = new("request_out_port", this);
  endfunction : build_phase 

  virtual task run_phase(uvm_phase phase);
    request_in_monitor();
    request_out_monitor();
  endtask : run_phase

  virtual task request_in_monitor();
    seq_item request;

    forever begin
      if(vif_1.pushin && vif_1.stopin) begin
        request = new();
        request.op = vif_1.op;
        request.A = vif_1.A;
        request.B = vif_1.B;
        request.pushin = vif_1.pushin;
        request.stopin = vif_1.stopin;
        request_in_port.write(request);
        trans_dut.push_back(request);
        end
       @(posedge vif_1.clk);
     end
   endtask : request_in_monitor

        // To Handle DUT output
   virtual task request_out_monitor();
    seq_item request1;

    forever begin
        if(vif_1.pushout) begin
          if(trans_dut.size() == 0) begin
            `uvm_fatal("ALU_MONITOR", "Received response without any request")
          end
          request1 = new trans_dut.pop_front();
          request1.sum = vif_1.sum;
          request1.pushout = vif_1.pushout;
          request1.stopout = vif_1.stopout;
          request_out_port.write(request1);
        end
      @(posedge vif_1.clk);
    end
  endtask : request_out_monitor

endclass : our_monitor
