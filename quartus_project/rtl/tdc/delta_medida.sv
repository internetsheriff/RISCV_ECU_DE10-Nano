//-----------------------------------------------------
 // Design Name : delta_start
 // File Name   : delta_start.sv
 // Function    :  pulse delta_start
 // Coder      : wrmelo
 //-----------------------------------------------------
 
 module delta_medida    (
 output wire 		 	pulse_out     	,  // Output of the pulse
 input  wire      	pulse_A      	,  // start positive edge signal1
 input  wire      	pulse_B     		// start positive edge signal2
  );
  
 //-------------Code Starts Here-------
 
 xor gl (pulse_out, pulse_A, pulse_B) /* synthesis keep */;
 
 
endmodule 