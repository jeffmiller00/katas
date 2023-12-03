#!/usr/bin/env ruby
require 'pry'

=begin
The engine schematic (your puzzle input) consists of a visual representation of the engine.
There are lots of numbers and symbols you don't really understand, but apparently any number adjacent to a symbol, even diagonally, is a "part number" and should be included in your sum.
(Periods (.) do not count as a symbol.)

Of course, the actual engine schematic is much larger. What is the sum of all of the part numbers in the engine schematic?
=end


class Gondola
  def initialize(input_file = './input_data/day3.txt')
    @input_file = input_file
    @engine_schematic = File.readlines(@input_file, chomp: true)
  end

  def valid_part_number?(line_num, char_range)
    special_chars = []
    special_chars << @engine_schematic[line_num][char_range].split('')
    special_chars << @engine_schematic[line_num-1][char_range].split('') unless line_num-1 < 0
    special_chars << @engine_schematic[line_num+1][char_range].split('') unless line_num+1 > @engine_schematic.size - 1
    special_chars.flatten!
    special_chars.reject! { |char| char =~ /[[:digit:]]/ || char == '.' }

    !special_chars.empty?
  end

  def find_part_numbers
    part_numbers = []
    @engine_schematic.each_with_index do |line, idx|
      begin_range = 0
      end_range = 0
      special_char_range = nil
      while !line[end_range..].index(/(^|\D)\d+($|\D)/).nil?
        begin_range = end_range + [line[end_range..].index(/(^|\D)\d+($|\D)/), 0].max
        end_range = begin_range + line[begin_range+1..].index(/$|\D/) + 1
        special_char_range = begin_range..end_range

        num = line[special_char_range].gsub(/\D/, '')
        part_numbers << num.to_i if self.valid_part_number?(idx, special_char_range)
      end
    end

    part_numbers
  end

  def get_numbers_from_line(line_num, gear_index)
    numbers = []
    expanding_index = 1
    expanding_range = (gear_index-expanding_index)..(gear_index+expanding_index)
    while (@engine_schematic[line_num][expanding_range].chars.first =~ /[[:digit:]]/ && expanding_range.first > 0) ||
          (@engine_schematic[line_num][expanding_range].chars.last =~ /[[:digit:]]/ && expanding_range.last < @engine_schematic[line_num-1].size - 1)
      if @engine_schematic[line_num][expanding_range].chars.first.match(/\d/)
        expand_left = [expanding_range.first - 1, 0].max
      else
        expand_left = expanding_range.first
      end
      if @engine_schematic[line_num][expanding_range].chars.last.match(/\d/)
        expand_right = expanding_range.last + 1
      else
        expand_right = expanding_range.last
      end
      expanding_range = (expand_left..expand_right)
    end
    numbers << @engine_schematic[line_num][expanding_range].split(/\D/).reject(&:empty?).map(&:to_i)

    numbers.flatten
  end

  def find_numbers_touching_gear(line_num, gear_index)
    numbers = []

    numbers << get_numbers_from_line(line_num, gear_index)
    numbers << get_numbers_from_line(line_num - 1, gear_index)
    numbers << get_numbers_from_line(line_num + 1, gear_index)

    numbers.flatten
  end

  def find_gear_ratios
    gear_ratios = []
    @engine_schematic.each_with_index do |line, idx|
      gear_index = 0
      while !line[gear_index+1..].index('*').nil?
        gear_index = gear_index + 1 + [line[gear_index+1..].index('*'), 0].max

        nums = find_numbers_touching_gear(idx, gear_index)
        gear_ratios << nums.reduce(:*) if nums.size > 1
      end
    end

    gear_ratios
  end
end