#!/usr/bin/env ruby
require 'pry'

=begin
You play several games and record the information from each game (your puzzle input). Each game is listed with its ID number (like the 11 in Game 11: ...) followed by a semicolon-separated list of subsets of cubes that were revealed from the bag (like 3 red, 5 green, 4 blue).

For example, the record of a few games might look like this:

Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
In game 1, three sets of cubes are revealed from the bag (and then put back again). The first set is 3 blue cubes and 4 red cubes; the second set is 1 red cube, 2 green cubes, and 6 blue cubes; the third set is only 2 green cubes.

The Elf would first like to know which games would have been possible if the bag contained only 12 red cubes, 13 green cubes, and 14 blue cubes?

In the example above, games 1, 2, and 5 would have been possible if the bag had been loaded with that configuration. However, game 3 would have been impossible because at one point the Elf showed you 20 red cubes at once; similarly, game 4 would also have been impossible because the Elf showed you 15 blue cubes at once. If you add up the IDs of the games that would have been possible, you get 8.

Determine which games would have been possible if the bag had been loaded with only 12 red cubes, 13 green cubes, and 14 blue cubes. What is the sum of the IDs of those games?
=end

class CubesGame
  attr_reader :game_id

  MAX_RED_CUBES = 12
  MAX_GREEN_CUBES = 13
  MAX_BLUE_CUBES = 14

  def initialize(game_input)
    @game_input = game_input
    @game_id = game_input.split(':').first.split(' ').last.to_i
    @red_cubes = MAX_RED_CUBES
    @green_cubes = MAX_GREEN_CUBES
    @blue_cubes = MAX_BLUE_CUBES
  end

  def min_cubes_needed
    min_cubes = {red: 0, green: 0, blue: 0}
    @game_input.split(':').last.split(/[\,,;]/).each do |game_pulls|
      number_pulled = game_pulls.split(' ').first.to_i
      min_cubes[:red] = number_pulled if game_pulls.include?('red') && number_pulled > min_cubes[:red]
      min_cubes[:green] = number_pulled if game_pulls.include?('green') && number_pulled > min_cubes[:green]
      min_cubes[:blue] = number_pulled if game_pulls.include?('blue') && number_pulled > min_cubes[:blue]
    end
    min_cubes
  end

  def power
    min_cubes_needed.values.reduce(:*)
  end

  def valid?
    max_cubes_pulled = min_cubes_needed

    max_cubes_pulled[:red] <= MAX_RED_CUBES && max_cubes_pulled[:green] <= MAX_GREEN_CUBES && max_cubes_pulled[:blue] <= MAX_BLUE_CUBES
  end

  def play_game
    @game_input.split(':').last.split(';').each do |game_round|
      game_round.split(',').each do |cube_pull|
        @red_cubes -= cube_pull.split(' ').first.to_i if cube_pull.include?('red')
        @green_cubes -= cube_pull.split(' ').first.to_i if cube_pull.include?('green')
        @blue_cubes -= cube_pull.split(' ').first.to_i if cube_pull.include?('blue')
        raise StandardError.new "Invalid game." if @red_cubes < 0 || @green_cubes < 0 || @blue_cubes < 0
      end

    end
  end
end
