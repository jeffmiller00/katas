#!/usr/bin/env ruby
require 'pry'


class Galaxy
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def -(other_galaxy)
    (other_galaxy.x - @x).abs + (other_galaxy.y - @y).abs
  end
end

class GalaxyMap
  attr_reader :galaxies

  def initialize(input_file = './input_data/day11.txt')
    @galaxies = []
    @map = File.readlines(input_file, chomp: true).map(&:chars)

    @expanded_rows = []
    @expanded_cols = []
    # For Part 1 @expansion_size = 1, for Part 2 @expansion_size = 1_000_000 - 1
    @expansion_size = 1_000_000 - 1 # Subtract 1 to account for the original row/col.

    expand_universe

    @map.each_with_index do |line, row_index|
      line.each_index.select{|i| line[i] == '#'}.each do |col_index|
        col = col_index + (@expanded_cols.count{|i| i <= col_index} * @expansion_size)
        row = row_index + (@expanded_rows.count{|i| i <= row_index} * @expansion_size)
        @galaxies << Galaxy.new(col, row)
      end
    end
  end

  def expand_universe
    @map.each_with_index do |line, idx|
      @expanded_rows << idx if line.tally['#'].to_i.zero?
      @expanded_cols << idx if @map.map{|row| row[idx]}.tally['#'].to_i.zero?
    end
  end

  def shortest_path_sum
    @galaxies.combination(2).map{ |g1, g2| g2 - g1 }.sum
  end
end

if __FILE__ == $0
  which_part = ARGV[0].to_i || 1
  if which_part == 1
    puts "Part 1: #{GalaxyMap.new.shortest_path_sum}"
  else
    puts "Part 2: #{GalaxyMap.new.shortest_path_sum}"
  end
end