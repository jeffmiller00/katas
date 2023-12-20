#!/usr/bin/env ruby
require 'pry'


class String
  def holiday_hash
    current_value = 0
    self.chars.each do |char|
      current_value += char.ord
      current_value *= 17
      current_value %= 256
    end
    current_value
  end
end

class HolidayHash
  attr_reader :init_strings

  def initialize(input_file = './input_data/day15.txt')
    @init_strings = File.read(input_file, chomp: true).split(',')
    @hashmap = {}
  end

  def init_sum
    @init_strings.map(&:holiday_hash).sum
  end

  def build_hashmap
    @init_strings.each_with_index do |init_string, index|
      @hashmap[init_string[0..1].holiday_hash] ||= []
      if init_string.include?('=')
        add_value_to_hashmap(init_string)
      elsif init_string.include?('-')
        # Remove the lens
        remove_lens(init_string)
      end
    end
  end

  def add_value_to_hashmap(init_string)
    prev_index = @hashmap[init_string[0..1].holiday_hash].each_index.select{ |index| @hashmap[init_string[0..1].holiday_hash][index][0..1] == init_string[0..1]}
    if prev_index.empty?
      @hashmap[init_string[0..1].holiday_hash] << init_string.sub('=', ' ')
    else
      @hashmap[init_string[0..1].holiday_hash][prev_index.first] = init_string.sub('=', ' ')
    end
  end

  def remove_lens(init_string)
    @hashmap[init_string[0..1].holiday_hash].reject!{ |lens| lens[0..1] == init_string[0..1]}
  end

  def focus_power(lens_label)
    @hashmap[lens_label.holiday_hash].each_with_index do |lens_value, index|
      return (lens_label.holiday_hash + 1) * (index + 1) * lens_value.split(' ').last.to_i if lens_value[0..1] == lens_label
    end
    0
  end

  def total_focus_power(lens_labels = @init_strings.map{|s| s[0..1]})
    lens_labels.map{ |lens_label| self.focus_power(lens_label) }.sum
  end
end

if __FILE__ == $0
  which_part = ARGV[0].to_i || 1
  if which_part == 1
    puts "Part 1: #{HolidayHash.new.init_sum}"
  else
    hh = HolidayHash.new
    hh.build_hashmap
    puts "Part 2: #{hh.total_focus_power}"
  end
end