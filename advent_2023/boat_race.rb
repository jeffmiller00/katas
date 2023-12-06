#!/usr/bin/env ruby
require 'pry'


class BoatRace

  attr_reader :length, :record_distance

  def initialize(length, record_distance)
    @length = length
    @record_distance = record_distance
  end

  def distance(hold_duration)
    (@length - hold_duration) * hold_duration
  end

  def possible_wins
    wins = 0
    (1..@length/2).each do |hold_duration|
      wins += 1 if distance(hold_duration) > @record_distance
    end
    wins = wins * 2
    wins -= 1 if distance((@length/2)) > @record_distance if @length.even?
    wins
  end
end

if __FILE__ == $0
  which_part = ARGV[0] || '2'

  if which_part == '1'
    input = File.read('./input_data/day6.txt', chomp: true)
    durations = input.split("\n").first.split(':').last.split(' ').map(&:to_i)
    distances = input.split("\n").last.split(':').last.split(' ').map(&:to_i)
    possible_wins = []
    durations.map.with_index do |duration, idx|
      possible_wins << BoatRace.new(duration, distances[idx]).possible_wins
    end
    puts possible_wins.reduce(:*)
  elsif which_part == '2'
    input = File.read('./input_data/day6.txt', chomp: true)
    duration = input.split("\n").first.split(':').last.split(' ').join.to_i
    distance = input.split("\n").last.split(':').last.split(' ').join.to_i
    puts BoatRace.new(duration, distance).possible_wins
  end
end