class seq_item extends uvm_sequence_item;
  
  //Registration of the DUT signals and its data type in the UVM Factory 
  function new(string path="seq_item");
    super.new(path);
  endfunction
 
  rand bit[7:0] A;
  rand bit[7:0] B;
  rand bit[2:0] op;
  rand bit pushin,stopin;
  bit[8:0] sum;
  bit pushout,stopout;
 
  `uvm_object_utils_begin(seq_item)
  `uvm_field_int(A,UVM_ALL_ON)
  `uvm_field_int(B,UVM_ALL_ON)
  `uvm_field_int(op,UVM_ALL_ON)
  `uvm_field_int(pushin,UVM_ALL_ON)
  `uvm_field_int(stopin,UVM_ALL_ON)
  `uvm_field_int(sum,UVM_ALL_ON)
  `uvm_object_utils_end
  
endclass