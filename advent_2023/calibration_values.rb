#!/usr/bin/env ruby
require 'pry'


=begin
--- Day 1: Trebuchet?! ---
Something is wrong with global snow production, and you've been selected to take a look. The Elves have even given you a map; on it, they've used stars to mark the top fifty locations that are likely to be having problems.

You've been doing this long enough to know that to restore snow operations, you need to check all fifty stars by December 25th.

Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

You try to ask why they can't just use a weather machine ("not powerful enough") and where they're even sending you ("the sky") and why your map looks mostly blank ("you sure ask a lot of questions") and hang on did you just say the sky ("of course, where do you think snow comes from") when you realize that the Elves are already loading you into a trebuchet ("please hold still, we need to strap you in").

As they're making the final adjustments, they discover that their calibration document (your puzzle input) has been amended by a very young Elf who was apparently just excited to show off her art skills. Consequently, the Elves are having trouble reading the values on the document.

The newly-improved calibration document consists of lines of text; each line originally contained a specific calibration value that the Elves now need to recover. On each line, the calibration value can be found by combining the first digit and the last digit (in that order) to form a single two-digit number.

For example:

1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
In this example, the calibration values of these four lines are 12, 38, 15, and 77. Adding these together produces 142.

Consider your entire calibration document. What is the sum of all of the calibration values?
=end

class CalibrationValues
  attr_reader :input_lines

  WORD_NUMBERS = ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']
  MAX_LINE_LENGTH = 10000

  def initialize(input_file = './day1_input.txt')
    @input_file = input_file
    @input_lines = File.readlines(@input_file, chomp: true)
  end

  def convert_to_int(string_or_int)
    word_to_int_mapping = {
      'one' => 1,
      'two' => 2,
      'three' => 3,
      'four' => 4,
      'five' => 5,
      'six' => 6,
      'seven' => 7,
      'eight' => 8,
      'nine' => 9
    }

    int = nil
    if string_or_int.is_a?(String)
      int =   word_to_int_mapping[string_or_int]
      int ||= string_or_int.to_i
    else
      int = string_or_int
    end

    int
  end

  def find_first_word_number_as_int(line)
    WORD_NUMBERS.each do |word_number|
      if line.include?(word_number) && line.index(word_number) == 0
        return convert_to_int(word_number)
      end
    end
  end

  def index_of_first_digit(line)
    line.split('').each_with_index do |char, idx|
      if char =~ /[[:digit:]]/
        return idx
      end
    end
    nil
  end

  def index_of_first_word_number(line)
    min_index = MAX_LINE_LENGTH
    WORD_NUMBERS.each do |word_number|
      min_index = [min_index, line.index(word_number)].min if line.include?(word_number)
    end
    min_index
  end

  def build_int_array_from_line(line)
    int_array = []
    shrinking_line = line

    while shrinking_line.size > 0
      number_index = [index_of_first_digit(shrinking_line), index_of_first_word_number(shrinking_line)].compact.min
      break if number_index.nil? || number_index > shrinking_line.size

      if number_index == index_of_first_word_number(shrinking_line)
        int_array << find_first_word_number_as_int(shrinking_line[number_index..])
      else
        int_array << convert_to_int(shrinking_line[number_index])
      end

      # This does not feel like the optimal solution, but it works for the majority of cases.
      shrinking_line = shrinking_line[number_index + 1..]
    end

    int_array
  end

  def sum
    sum_of_all_calibration_values = 0

    @input_lines.each do |line|
      int_array = build_int_array_from_line(line)
      calibration_value = "#{int_array.first}#{int_array.last}".to_i
      sum_of_all_calibration_values += calibration_value
    end

    sum_of_all_calibration_values
  end
end


# binding.pry