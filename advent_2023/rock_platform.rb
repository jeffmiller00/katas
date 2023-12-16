#!/usr/bin/env ruby
require 'pry'


class RockPlatform
  attr_reader :rock_platform

  def initialize(input_file = './input_data/day14.txt')
    @input_file = input_file
    @rock_platform = File.readlines(@input_file).map(&:chomp).map(&:chars)
  end

  def roll_rocks(rock_line)
    (('O' * rock_line.chars.tally['O'].to_i) + ('.' * rock_line.chars.tally['.'].to_i)).chars
  end

  def move_rocks
    @rock_platform.each_with_index do |row, row_index|
      moved_rocks = []
      square_rock_indexes = row.each_index.select{|i| row[i] == '#'}

      if square_rock_indexes.empty?
        moved_rocks = roll_rocks(row.join)
      else
        row.join.split('#') do |rock_line|
          moved_rocks += roll_rocks(rock_line)
        end

        square_rock_indexes.each do |sq_rock_index|
          moved_rocks.insert(sq_rock_index, '#')
        end
      end

      @rock_platform[row_index] = moved_rocks
    end
  end

  def tilt(which_direction = :north)
    case which_direction
    when :north
      @rock_platform = @rock_platform.transpose
      move_rocks
      @rock_platform = @rock_platform.transpose
    when :south
      @rock_platform = @rock_platform.transpose.map(&:reverse)
      move_rocks
      @rock_platform = @rock_platform.map(&:reverse).transpose
    when :east
      @rock_platform = @rock_platform.map(&:reverse)
      move_rocks
      @rock_platform = @rock_platform.map(&:reverse)
    when :west
      move_rocks
    end

    self
  end

  def cycle(how_many_times = 1)
    how_many_times.times do
      directions = [:north, :west, :south, :east]
      directions.each do |direction|
        tilt(direction)
      end
    end
    @rock_platform
  end

  def total_load(which_direction = :north)
    @rock_platform.each_with_index.map do |row, row_index|
      (@rock_platform.size-row_index) * row.count('O')
    end.sum
  end
end

if __FILE__ == $0
  which_part = ARGV[0].to_i || 1
  if which_part == 1
    puts "Part 1: #{RockPlatform.new.tilt.total_load}"
  else
    puts "Part 2: #{RockPlatform.new.cycle(1_000_000_000).total_load}"
  end
end