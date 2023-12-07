#!/usr/bin/env ruby
require 'pry'


class Hand
  attr_reader :cards, :bid

  def initialize(hand_input)
    @cards = build_hand(hand_input.split(' ').first)
    @bid = hand_input.split(' ').last.to_i
  end

  def card_to_value(card_input)
    case card_input
    when 'A'
      14
    when 'K'
      13
    when 'Q'
      12
    when 'J'
      11
    when 'T'
      10
    else
      card_input.to_i
    end
  end

  def build_hand(hand_input)
    hand = []
    hand_input.split('').map do |card_input|
      hand << card_to_value(card_input)
    end
    hand.sort.reverse
  end

  def power
    if five_of_a_kind?
      7
    elsif four_of_a_kind?
      6
    elsif full_house?
      5
    elsif three_of_a_kind?
      4
    elsif two_pair?
      3
    elsif one_pair?
      2
    else
      1
    end
  end

  def five_of_a_kind?
    @cards.uniq.size == 1
  end

  def four_of_a_kind?
    @cards.uniq.size == 2 && @cards.tally.values.max == 4
  end

  def full_house?
    @cards.uniq.size == 2 && @cards.tally.values.max == 3 && @cards.tally.values.min == 2
  end

  def three_of_a_kind?
    @cards.uniq.size == 3 && @cards.tally.values.max == 3
  end

  def two_pair?
    @cards.tally.values.tally[2] == 2
  end

  def one_pair?
    @cards.tally.values.max == 2 && @cards.tally.values.uniq == [1,2]
  end

  def has_higher_card_than?(other_cards)
    @cards.each_with_index do |card, idx|
      next if card == other_cards[idx]
      return true if card > other_cards[idx]
      return false if card < other_cards[idx]
    end
  end

  def >(other_hand)
    if self.power == other_hand.power
      return true if self.has_higher_card_than?(other_hand.cards)
    else
      return self.power > other_hand.power
    end
    false
  end

  def <(other_hand)
    !(self > other_hand)
  end
end

class CamelCards
  attr_reader :hands

  def initialize(input_file = './input_data/day7.txt')
    @hands = []
    File.readlines(input_file).each do |line|
      @hands << Hand.new(line)
    end
  end

  def winnings
    total_winnings = 0
    self.order_hands.each_with_index do |hand, idx|
      total_winnings += hand.bid * (idx + 1)
    end
    total_winnings
  end

  def order_hands
    sorted_hands = []
    semi_sorted_hands = @hands.sort_by(&:power)
    sorted_hands << semi_sorted_hands.shift

    while semi_sorted_hands.any?
      inserted = false
      hand_to_compare = semi_sorted_hands.shift

      sorted_hands.each_with_index do |hand, idx|
        # Something subtle is likely wrong in here...
        if hand_to_compare < hand
          sorted_hands.insert(idx, hand_to_compare)
          inserted = true
        end
        break if inserted
      end
      sorted_hands << hand_to_compare unless inserted
    end

    sorted_hands
  end
end

if __FILE__ == $0
  binding.pry
  puts "Part 1: The total winnings are: #{CamelCards.new.winnings}"
end