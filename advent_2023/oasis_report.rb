#!/usr/bin/env ruby
require 'pry'


class ValueHistory
  attr_reader :history

  def initialize(history)
    @history = history
  end

  def self.diff_line(line)
    return Array.new(line.size - 1, 0) if line.uniq == [0]
    line << line.last + diff_line(line.each_cons(2).map { |a, b| b - a }).last
  end

  def next_value(diff_line = ValueHistory.diff_line(@history))
    diff_line.last
  end
end

class OasisReport
  attr_reader :values

  def initialize(input_file = './input_data/day9.txt', reverse: false)
    @input_file = input_file
    @values = File.readlines(input_file).map do |line|
      if reverse
        ValueHistory.new(line.split(' ').map(&:to_i).reverse)
      else
        ValueHistory.new(line.split(' ').map(&:to_i))
      end
    end
  end
end

if __FILE__ == $0
  which_part = ARGV[0].to_i || 1
  if which_part == 1
    puts "The sum of the next values is: #{OasisReport.new.values.map(&:next_value).sum}"
  else
    puts "The sum of the previous values is: #{OasisReport.new('./input_data/day9.txt', reverse: true).values.map(&:next_value).sum}"
  end
end