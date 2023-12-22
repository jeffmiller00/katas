#!/usr/bin/env ruby
require 'state_machines'
require 'pry'


class PulsePropagation
  # attr_reader :init_strings

  def initialize(input_file = './input_data/day20.txt')
    @input_file = input_file
    @modules = []

    File.readlines(@input_file).each do |line|
      # Parse the line
      source = line.split('->').map(&:strip).first
      destinations = line.split('->').last.split(',').map(&:strip)

      if source == 'broadcaster'
        # Create a broadcaster module
        @modules << BroadcastModule.new(destinations)
      elsif source[0] == '%'
        # Create a flip-flop module
        @modules << FlipFlopModule.new(source[1..], destinations)
      elsif source[0] == '&'
        # Create a conjunction module
        @modules << ConjunctionModule.new(source[1..], destinations)
      else
        raise "Unknown module type: #{source}"
      end
    end

    # Create any leaf modules
    (@modules.map(&:destinations).flatten.uniq - @modules.map(&:name).uniq).each do |leaf_module_name|
      @modules << BaseModule.new(leaf_module_name, [])
    end

    # Initialize the ConjunctionModule memory.
    @modules.select { |m| m.is_a?(ConjunctionModule) }.each do |cm|
      cm.init_memory(@modules.select{ |m| m.destinations.include?(cm.name) }.uniq)
    end
  end

  def broadcast_module
    @modules.find { |m| m.name == 'broadcaster' }
  end

  def push_button
    queue = self.broadcast_module.destinations.map{ |dest_name| {src_name: self.broadcast_module.name, dest_name: dest_name, power: :low} }
    # Count the button push.
    self.broadcast_module.increment(:low)

    while queue.size > 0
      destination = queue.shift

      module_to_process = @modules.find { |m| m.name == destination[:dest_name] }
      next if module_to_process.nil?
      self.broadcast_module.increment(destination[:power])

      pulse = module_to_process.process_pulse(destination[:src_name], destination[:power])

      queue += module_to_process.destinations.map{ |dest_name| {src_name: module_to_process.name, dest_name: dest_name, power: pulse} } unless pulse.nil?
      binding.pry if queue.include?({src_name: 'kj', dest_name: 'rx', power: :low})
    end
  end
end

class BaseModule
  attr_reader :name, :destinations

  @@counts = {
    low: 0,
    high: 0
  }

  def self.increment(power)
    @@counts[power] += 1
  end

  def self.counts
    @@counts
  end

  def self.total
    @@counts[:low] * @@counts[:high]
  end

  def self.reset_counts
    @@counts = {
      low: 0,
      high: 0
    }
  end


  def initialize(name, destinations)
    @name = name
    @destinations = destinations
  end

  def increment(power)
    self.class.increment(power)
  end

  def process_pulse(source, power)
    nil
  end
end

class BroadcastModule < BaseModule
  def initialize(destinations)
    name = 'broadcaster'
    super(name, destinations)
  end
end

class FlipFlopModule < BaseModule
  attr_reader :state

  def initialize(name, destinations)
    super(name, destinations)
    @state = 'off'
  end

  def process_pulse(source, power)
    return nil if power.to_sym == :high

    # If it was off, it turns on and sends a high pulse. If it was on, it turns off and sends a low pulse.
    if power.to_sym == :low
      if @state == 'off'
        @state = 'on'
        return :high
      elsif @state == 'on'
        @state = 'off'
        return :low
      end
    end
  end
end

class ConjunctionModule < BaseModule
  def initialize(name, destinations)
    super(name, destinations)
    @states = {}
  end

  def init_memory(sources)
    sources.each do |source|
      binding.pry if source.destinations.empty?
      next if source.destinations.empty?
      source_name = source.name
      next if (source_name == self.name) || (source_name == 'broadcaster')
      @states[source_name] = :low
    end
  end

  def process_pulse(source, power)
    @states[source] = power.to_sym

    if @states.values.uniq == [:high]
      return :low
    else
      return :high
    end
  end
end


if __FILE__ == $0
  binding.pry
  which_part = ARGV[0].to_i || 1
  if which_part == 1
    # puts "Part 1: #{HolidayHash.new.init_sum}"
  else
    # hh = HolidayHash.new
    # hh.build_hashmap
    # puts "Part 2: #{hh.total_focus_power}"
  end
end