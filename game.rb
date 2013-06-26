#!/usr/bin/env ruby

require_relative 'world'

x_size = 50
y_size = 30
steps  = 50

world = World.new
world.populate x_size, y_size
world.set_neighbours
(1..steps).each do |turn|
  puts `clear`
  print world
  world.process_turn
  sleep 0.5 
end
print "\n\n"
