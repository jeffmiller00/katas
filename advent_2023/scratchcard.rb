#!/usr/bin/env ruby
require 'pry'

=begin
As far as the Elf has been able to figure out, you have to figure out which of the numbers you have appear in the list of winning numbers.
The first match makes the card worth one point and each match after the first doubles the point value of that card.
=end


# input_file = './input_data/day4.txt')
# @engine_schematic = File.readlines(input_file, chomp: true)


class Scratchcard
  attr_reader :my_numbers, :winning_numbers

  BASE_SCORE = 1

  def initialize(single_card)
    @card_input = single_card
    @my_numbers = @card_input.split(':').last.split('|').last.split(' ').map(&:to_i)
    @winning_numbers = @card_input.split(':').last.split('|').first.split(' ').map(&:to_i)
  end

  def losers
    @my_numbers - @winning_numbers
  end

  def winners
    @my_numbers - losers
  end

  def score
    return 0 if winners.empty?
    score = BASE_SCORE
    (winners.count - 1).times do
      score *= 2
    end
    score
  end
end