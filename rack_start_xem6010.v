
`timescale 1ns / 1ps

// rack_start_xem6010.v
// Generated on Mon Mar 04 14:53:00 -0800 2013

    module rack_start_xem6010(
	    input  wire [7:0]  hi_in,
	    output wire [1:0]  hi_out,
	    inout  wire [15:0] hi_inout,
	    inout  wire        hi_aa,

	    output wire        i2c_sda,
	    output wire        i2c_scl,
	    output wire        hi_muxsel,
	    input  wire        clk1,
	    input  wire        clk2,
	
	    output wire [7:0]  led,
	    
	    // Neuron array inputs
          input wire spikein1,  
          input wire spikein2,
          input wire spikein3,
          input wire spikein4,
          input wire spikein5,
          input wire spikein6,
          input wire spikein7,
          input wire spikein8,
          input wire spikein9,
          input wire spikein10,
          input wire spikein11,
          input wire spikein12,
          input wire spikein13,
          input wire spikein14,
      
          // Neuron array outputs
          output wire spikeout1, 
          output wire spikeout2,
          output wire spikeout3,
          output wire spikeout4,
          output wire spikeout5,
          output wire spikeout6,
          output wire spikeout7,
          output wire spikeout8,
          output wire spikeout9,
          output wire spikeout10,
          output wire spikeout11,
          output wire spikeout12,
          output wire spikeout13,
          output wire spikeout14
       );
       
        parameter NN = 8;
		
        // *** Dump all the declarations here:
        wire         ti_clk;
        wire [30:0]  ok1;
        wire [16:0]  ok2;   
        wire reset_global;

        // *** Target interface bus:
        assign i2c_sda = 1'bz;
        assign i2c_scl = 1'bz;
        assign hi_muxsel = 1'b0;
    
/////////////////////// BEGIN WIRE DEFINITIONS ////////////////////////////

        // Clock Generator clk_gen0 Wire Definitions
        wire neuron_clk;  // neuron clock (128 cycles per 1ms simulation time) 
        wire sim_clk;     // simulation clock (1 cycle per 1ms simulation time)
        wire spindle_clk; // spindle clock (3 cycles per 1ms simulation time)
        

        // Triggered Input triggered_input0 Wire Definitions
        reg [31:0] triggered_input0;    // Triggered input sent from USB (I_in)       
        

        // Triggered Input triggered_input1 Wire Definitions
        reg [31:0] triggered_input1;    // Triggered input sent from USB (clk_divider)       
        

        // Output and OpalKelly Interface Wire Definitions
        
        wire [6*17-1:0] ok2x;
        wire [15:0] ep00wire, ep01wire, ep02wire;
        wire [15:0] ep50trig;
        
        wire pipe_in_write;
        wire [15:0] pipe_in_data;
        

        // Spike Counter spike_counter0 Wire Definitions
        wire [31:0] spike_count_neuron0;
        

    // FPGA Input/Output Rack Wire Definitions
    // these are in the top module input/output list
    

        // Neuron neuron0 Wire Definitions
        wire [31:0] v_neuron0;   // membrane potential
        wire spike_neuron0;      // spike sample for visualization only
        wire each_spike_neuron0; // raw spike signals
        wire [127:0] population_neuron0; // spike raster for entire population        
        
/////////////////////// END WIRE DEFINITIONS //////////////////////////////

/////////////////////// BEGIN INSTANCE DEFINITIONS ////////////////////////

        // Clock Generator clk_gen0 Instance Definition
        gen_clk clocks(
            .rawclk(clk1),
            .half_cnt(triggered_input1),
            .clk_out1(neuron_clk),
            .clk_out2(sim_clk),
            .clk_out3(spindle_clk),
            .int_neuron_cnt_out()
        );
        

        // Triggered Input triggered_input0 Instance Definition (I_in)
        always @ (posedge ep50trig[6] or posedge reset_global)
        if (reset_global)
            triggered_input0 <= 32'd10240;         //reset to 10      
        else
            triggered_input0 <= {ep02wire, ep01wire};        
        

        // Triggered Input triggered_input1 Instance Definition (clk_divider)
        always @ (posedge ep50trig[7] or posedge reset_global)
        if (reset_global)
            triggered_input1 <= triggered_input1;         //reset to triggered_input1      
        else
            triggered_input1 <= {ep02wire, ep01wire};        
        

        // Output and OpalKelly Interface Instance Definitions
        assign led = 0;
        assign reset_global = ep00wire[0];
        okWireOR # (.N(6)) wireOR (ok2, ok2x);
        okHost okHI(
            .hi_in(hi_in),  .hi_out(hi_out),    .hi_inout(hi_inout),    .hi_aa(hi_aa),
            .ti_clk(ti_clk),    .ok1(ok1),  .ok2(ok2)   );
        
        //okTriggerIn ep50    (.ok1(ok1), .ep_addr(8'h50),    .ep_clk(clk1),  .ep_trigger(ep50trig)   );
        okTriggerIn ep50    (.ok1(ok1), .ep_addr(8'h50),    .ep_clk(sim_clk),  .ep_trigger(ep50trig)   );
        
        okWireIn    wi00    (.ok1(ok1), .ep_addr(8'h00),    .ep_dataout(ep00wire)   );
        okWireIn    wi01    (.ok1(ok1), .ep_addr(8'h01),    .ep_dataout(ep01wire)   );
        okWireIn    wi02    (.ok1(ok1), .ep_addr(8'h02),    .ep_dataout(ep02wire)   );
        
        okWireOut wo20 (    .ep_datain(v_neuron0[15:0]),  .ok1(ok1),  .ok2(ok2x[0*17 +: 17]), .ep_addr(8'h20)    );
        okWireOut wo21 (    .ep_datain(v_neuron0[31:16]),  .ok1(ok1),  .ok2(ok2x[1*17 +: 17]), .ep_addr(8'h21)   );    
        
        okWireOut wo22 (    .ep_datain(population_neuron0[15:0]),  .ok1(ok1),  .ok2(ok2x[2*17 +: 17]), .ep_addr(8'h22)    );
        okWireOut wo23 (    .ep_datain(population_neuron0[31:16]),  .ok1(ok1),  .ok2(ok2x[3*17 +: 17]), .ep_addr(8'h23)   );    
        
        okWireOut wo24 (    .ep_datain(spike_count_neuron0[15:0]),  .ok1(ok1),  .ok2(ok2x[4*17 +: 17]), .ep_addr(8'h24)    );
        okWireOut wo25 (    .ep_datain(spike_count_neuron0[31:16]),  .ok1(ok1),  .ok2(ok2x[5*17 +: 17]), .ep_addr(8'h25)   );    
        

        // Spike Counter spike_counter0 Instance Definition
        spike_counter spike_counter0(
            .clk(neuron_clk),
            .reset(reset_global),
            .spike_in(each_spike_neuron0), 
            .spike_count( spike_count_neuron0)
        );
        
    //FPGA-FPGA Outputs
    assign spikeout1 = each_spike_neuron0;
    assign spikeout2 = 1'b0;
    assign spikeout3 = 1'b0;
    assign spikeout4 = 1'b0;
    assign spikeout5 = 1'b0;
    assign spikeout6 = 1'b0;
    assign spikeout7 = 1'b0;
    assign spikeout8 = 1'b0;
    assign spikeout9 = 1'b0;
    assign spikeout10 = 1'b0;
    assign spikeout11 = 1'b0;
    assign spikeout12 = 1'b0;
    assign spikeout13 = 1'b0;
    assign spikeout14 = 1'b0;


        // Neuron neuron0 Instance Definition
        izneuron neuron0(
            .clk(neuron_clk),               // neuron clock (128 cycles per 1ms simulation time)
            .reset(reset_global),           // reset to initial conditions
            .I_in(  triggered_input0 ),          // input current from synapse
            .v_out(v_neuron0),               // membrane potential
            .spike(spike_neuron0),           // spike sample
            .each_spike(each_spike_neuron0), // raw spikes
            .population(population_neuron0)  // spikes of population per 1ms simulation time
        );
        
/////////////////////// END INSTANCE DEFINITIONS //////////////////////////
endmodule