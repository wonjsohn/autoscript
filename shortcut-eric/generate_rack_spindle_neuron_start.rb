#!/usr/bin/ruby

# generate an fpga-fpga testbed
# Sirish Nandyala
# hi@siri.sh

require './shortcut'

def generate_network
  
  $modulename = 'rack_test'
  
  #i_in = TriggeredInput.new 0, "lce", [50,6]
  
  lce = Lce.new
  
  spindle = Spindle.new
  spindle.connect_parameters  # create and connect the default parameter inputs

  ia_afferent = Neuron.new "Ia"
  #sn_neurons = Neuron.new
  #mn_neurons = Neuron.new
 #i_in.connect_to neurons
  
  output = Output.new
  rack = FPGARack.new
  
  lce.connect_to spindle
  spindle.connect_to ia_afferent
  ia_afferent.connect_to rack
  lce.connect_to output
  spindle.connect_to output

  #ia_afferent.connect_to sn_neurons
  #sn_neurons.connect_to mn_neurons
  #mn_neurons.connect_to output
  #mn_neurons.connect_to rack
  
end

if __FILE__ == $0
  generate_network
  generate_verilog

end
