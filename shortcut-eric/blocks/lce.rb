# generate verilog for waveform function generator
# Sirish Nandyala
# hi@siri.sh

class Lce

    attr_reader :id, :name

    def initialize(name=-1)
        $waveforms ||= []
        @@waveform_block_count ||= -1
        @@waveform_block_count += 1
        @id = ["mixed_input", @@waveform_block_count]
        @name = @id.join if name == -1
        @name = name unless name == -1
        $waveforms += [self]    
    end
    
    def connect_to(destination)
      destination.connect_from self
    end
    
    def put_wire_definitions
        wires = %{
        // Waveform Generator #{@id.join} Wire Definitions
        wire [31:0] #{@id.join};   // Wave out signal
        }
        puts wires
    end
    
    def put_instance_definition
        instance = %{
        // Waveform Generator #{@id.join} Instance Definition
        waveform_from_pipe_bram_2s gen_#{@id.join}(
            .reset(reset_global),               // reset the waveform
            .pipe_clk(ti_clk),                  // target interface clock from opalkelly interface
            .pipe_in_write(pipe_in_write),      // write enable signal from opalkelly pipe in
            .data_from_trig(triggered_input0),	// data from one of ep50 channel
            .is_from_trigger(is_from_trigger),
            .pipe_in_data(pipe_in_data),        // waveform data from opalkelly pipe in
            .pop_clk(sim_clk),                  // trigger next waveform sample every 1ms
            .wave(#{@id.join})                   // wave out signal
        );
        }
        puts instance
    end   
    
end
