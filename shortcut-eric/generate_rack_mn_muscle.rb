#!/usr/bin/ruby

# generate an fpga-fpga testbed
# Sirish Nandyala
# hi@siri.sh

require './shortcut'

def generate_network
  
  $modulename = 'rack_mn_muscle'
  
  #i_in = TriggeredInput.new 0, "lce", [50,6]
  
  lce = Lce.new
  
  #spindle = Spindle.new
  #spindle.connect_parameters  # create and connect the default parameter inputs

  #ia_afferent = Neuron.new "Ia"
  
  rack = FPGARack.new
  #sn_neurons = Neuron.new
  mn_neurons = Neuron.new
  #i_in.connect_to neurons
  muscle = Muscle.new
  muscle.connect_parameters
  output = Output.new
  
  #led = LED.new
  
  rack.connect_to mn_neurons
  lce.connect_to muscle
  lce.connect_to output
  #spindle.connect_to ia_afferent
  #spindle.connect_to output


  #ia_afferent.connect_to sn_neurons
  
  mn_neurons.connect_to output
  mn_neurons.connect_to muscle
  muscle.connect_to output
  #mn_neurons.connect_to output
  #mn_neurons.connect_to rack
  
end

if __FILE__ == $0

  generate_network
  generate_verilog

end
