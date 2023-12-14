#!/usr/bin/env ruby
require 'pry'


class PatternReflectionMap
  def initialize(input_file = './input_data/day13.txt')
    maps = File.read(input_file, chomp: true).split("\n\n")
    maps.map!{ |map| map.split("\n") }
    @patterns = maps.map{ |map| PatternReflection.new(map.map(&:chars)) }
  end

  def sum_summaries
    @patterns.map{ |pattern_map| pattern_map.summarize }.sum
  end
end


# Have to make this work with multiple patterns in one file.
class PatternReflection
  attr_reader :pattern_map

  def initialize(raw_pattern_input)
    @horizontal = true
    @pattern_map = raw_pattern_input
    @which_direction = nil
    @reflection = nil
    @used_smudge = false
  end

  def find_potential_inflection_points
    matching_rows = []
    index = 0.5
    @pattern_map.each_slice(2) do |top, bottom|
      matching_rows << index if top == bottom
      index += 2
    end
    index = 1.5
    @pattern_map[1..].each_slice(2) do |top, bottom|
      matching_rows << index if top == bottom
      index += 2
    end
    matching_rows
  end

  def is_horizontal?
    @which_direction == :horizontal
  end

  def is_a_reflection?(inflection_point)
    top_index = inflection_point.floor - 1
    bottom_index = inflection_point.ceil + 1
    while top_index >= 0 && bottom_index < @pattern_map.length
      if @pattern_map[top_index] == @pattern_map[bottom_index]
        top_index -= 1
        bottom_index += 1
      elsif !@used_smudge && @pattern_map[top_index].map.with_index{ |x,i| x == @pattern_map[bottom_index][i] }.tally[false] == 1
        smudge_cand_idx = @pattern_map[top_index].map.with_index{ |x,i| x == @pattern_map[bottom_index][i] }.index(false)
        @used_smudge = true
        next
      else
        return false
      end
    end
    return true
  end

  def find_reflection
    return @reflection unless @reflection.nil?
    # First try a horizontal reflection
    potential_inflection_points = find_potential_inflection_points

    potential_inflection_points.each do |inflection_point|
      if is_a_reflection?(inflection_point) && @used_smudge
        @reflection = inflection_point
        @which_direction = :horizontal
        return @reflection
      end
    end

    # If that doesn't work, try a vertical reflection
    @used_smudge = false
    @pattern_map = @pattern_map.transpose
    potential_inflection_points = find_potential_inflection_points
    potential_inflection_points.each do |inflection_point|
      if is_a_reflection?(inflection_point) && @used_smudge
        @reflection = inflection_point
        @which_direction = :vertical
        return @reflection
      end
    end

    nil
  end

  def summarize
    reflection = find_reflection
    base_number = @pattern_map[0..reflection.floor].size
    is_horizontal? ? base_number * 100 : base_number
  end
end

if __FILE__ == $0
  which_part = ARGV[0].to_i || 1
  if which_part == 1
    puts "Part 1: ___"
  else
    puts "Part 2: ___"
  end
end