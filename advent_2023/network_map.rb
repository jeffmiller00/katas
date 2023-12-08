#!/usr/bin/env ruby
require 'pry'


class NetworkMap
  attr_reader :direction_list, :network_map
  def initialize(input_file = './input_data/day8.txt')
    @input_file = input_file
    sub01_for_lr = File.readlines(@input_file, chomp: true).first.gsub('L', '0').gsub('R', '1')
    @direction_list = sub01_for_lr.split('').map(&:to_i)
    @network_map = {}
    File.readlines(@input_file, chomp: true)[2..-1].each do |line|
      @network_map[line.split(' = ').first] = line.split(' = ').last.gsub('(', '').gsub(')', '').split(', ')
    end
  end

  def go(starting_node = 'AAA', part_one = true)
    steps = 0
    current_node = starting_node
    if part_one
      while current_node != 'ZZZ'
        current_node = @network_map[current_node][@direction_list[steps % @direction_list.size]]
        steps += 1
      end
    else
      while current_node[-1] != 'Z'
        current_node = @network_map[current_node][@direction_list[steps % @direction_list.size]]
        steps += 1
      end
    end
    steps
  end

  def ghost_go
    steps = 0
    current_nodes = @network_map.keys.select { |k| k[-1] == 'A' }
    steps_needed = []

    current_nodes.each do |node|
      steps_needed << self.go(node, false)
    end

    steps_needed.reduce(1, :lcm)
  end
end

if __FILE__ == $0
  nm = NetworkMap.new
  # puts "The number of steps to reach ZZZ is: #{nm.go}"
  puts "The number of steps to reach all Z's is: #{nm.ghost_go}"
end