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
    empty_columns = nil
    expanding_y = 0
    @galaxies = []
    @map = File.readlines(input_file, chomp: true).map(&:chars)
    @map.each_with_index do |line, idx|
      empty_columns ||= Array.new(line.size, nil)
      empty_columns[idx] = 1 unless @map.map{ |r| r[idx] }.include?('#')
    end

    @map.each_with_index do |line, row_index|
      map_line = line.join
      col = 0

      line.tally['#'].to_i.times do |i|
        col = map_line[col..].index('#')
        x = col + empty_columns[0..col].map(&:to_i).sum + i
        y = row_index + expanding_y
        @galaxies << Galaxy.new(x, y)
        col += 1
      end

      expanding_y += 1 if line.tally['#'].to_i.zero?
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
    puts "Part 2: ___"
  end
end