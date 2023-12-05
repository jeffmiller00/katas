#!/usr/bin/env ruby
require 'pry'


class SeedMap
  attr_reader :seeds, :seed_map
  def initialize(input_file = './input_data/day5.txt')
    @input_file = input_file
    @almanac = File.read(@input_file, chomp: true)
    @seed_map = {}
    @seed_map_keys = ['seed-to-soil', 'soil-to-fertilizer', 'fertilizer-to-water', 'water-to-light', 'light-to-temperature', 'temperature-to-humidity', 'humidity-to-location']
    @seeds = @almanac.split("\n\n").first.split(':').last.split(' ').map(&:to_i)
    parse_almanac
  end

  def build_range(range_name, rules)
    @seed_map[range_name] = []
    rules.each do |rule|
      destination_range_start, source_range_start, range_length = rule.split(' ').map(&:to_i)

      @seed_map[range_name] << [(source_range_start..(source_range_start + range_length - 1)), (destination_range_start..(destination_range_start + range_length - 1))]
    end
  end

  def map seed, range_name
    @seed_map[range_name].each do |rule|
      if rule[0].include?(seed)
        index = seed - rule[0].first
        return rule[1].first + index
      end
    end
    seed
  end

  def parse_almanac
    @almanac.split("\n\n")[1..].each do |map_rules|
      build_range('seed-to-soil', map_rules.split("\n")[1..]) if map_rules.include?('seed-to-soil')
      build_range('soil-to-fertilizer', map_rules.split("\n")[1..]) if map_rules.include?('soil-to-fertilizer')
      build_range('fertilizer-to-water', map_rules.split("\n")[1..]) if map_rules.include?('fertilizer-to-water')
      build_range('water-to-light', map_rules.split("\n")[1..]) if map_rules.include?('water-to-light')
      build_range('light-to-temperature', map_rules.split("\n")[1..]) if map_rules.include?('light-to-temperature')
      build_range('temperature-to-humidity', map_rules.split("\n")[1..]) if map_rules.include?('temperature-to-humidity')
      build_range('humidity-to-location', map_rules.split("\n")[1..]) if map_rules.include?('humidity-to-location')
    end
  end

  def find_location seed
    location = seed
    @seed_map_keys.each do |key|
      location = map(location, key)
    end

    location
  end
end

if __FILE__ == $0
  sm = SeedMap.new('./input_data/day5.txt')
  puts "The lowest location number is #{sm.seeds.map { |seed| sm.find_location(seed) }.min}"
end