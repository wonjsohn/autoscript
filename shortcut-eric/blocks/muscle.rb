# generate verilog for muscle model
# Sirish Nandyala
# hi@siri.sh

class Muscle

    attr_reader :id
    attr_accessor :input_id, :tau_id
    
    def initialize
        $muscles ||= []
        @@muscle_block_count ||= -1
        @@muscle_block_count += 1
        @id = ["muscle", @@muscle_block_count]
        @tau_id = ["dummy_input", 999]
        @input_id = ["dummy_neuron", 999]
        @lce_id= ["dummy_wave", 999]
        $muscles += [self]
    end
    
    def connect_to(destination)
        destination.connect_from self
    end
    
    def connect_from(source)
        (block_type,index) = source.id
	
        if block_type == "neuron" 
            @input_id = source.spike_counter.id
        elsif block_type == "spike_counter"
            @input_id = source.id
        elsif ["triggered_input", "static_input"].include? block_type
            @tau_id = source.id
        elsif block_type == "waveform"
            @lce_id = source.id
        elsif block_type == "mixed_input"
            @lce_id = source.id
        else
            raise "cannot connect #{source} to #{self}"
        end
    end


    def connect_parameters
        @@tau ||= TriggeredInput.new 0.03, "tau", [50,2]
        @@tau.connect_to self
    end

    def put_wire_definitions
        wires = %{
        // Muscle #{@id.join} Wire Definitions
        wire [31:0] total_force_out_#{@id.join};
        wire [31:0] current_A_#{@id.join};
        wire [31:0] current_fp_spikes_#{@id.join};
        }
        puts wires
    end
    
    def put_instance_definition
        (block_name,index)=@input_id
        instance = %{
        // Muscle #{@id.join} Wire Definitions
        shadmehr_muscle #{@id.join}(
            .i_spike_cnt(spike_count_neuron#{index}),
            .f_pos(#{@lce_id.join}),
            .f_vel(32'd0),
            .clk(sim_clk),
            .reset(reset_global),
            .f_tau(#{@tau_id.join}),
            .f_total_force_out(total_force_out_#{@id.join}),
            .f_current_A(current_A_#{@id.join}),
            .f_current_fp_spikes(current_fp_spikes_#{@id.join})
        );     
        } 
        puts instance
    end

    
end
