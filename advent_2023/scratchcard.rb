#!/usr/bin/env ruby
require 'pry'

=begin
As far as the Elf has been able to figure out, you have to figure out which of the numbers you have appear in the list of winning numbers.
The first match makes the card worth one point and each match after the first doubles the point value of that card.
=end

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

class ScratchcardGame
  attr_reader :cards

  def initialize(input_file: './input_data/day4.txt', direct_input: nil)
    @cards = []
    @card_input = []
    @number_of_cards = {}
    if direct_input.nil?
      @input_file = input_file
      @card_input = File.readlines(@input_file, chomp: true)
    else
      @card_input = direct_input
    end

    @card_input.each_with_index do |card, index|
      @cards << Scratchcard.new(card)
      @number_of_cards[index] = 1
    end
  end

  def total_score
    @cards.map(&:score).sum
  end

  def play
    @cards.each_with_index do |card, index|
      @number_of_cards[index].times do
        card.winners.each_with_index do |winner, winner_index|
          @number_of_cards[index + winner_index + 1] = @number_of_cards[index + winner_index + 1].to_i + 1
        end
      end
    end
    @number_of_cards
  end

  def total_cards
    @number_of_cards.values.sum
  end
end
