require_relative '../cubes_game.rb'

=begin
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green

In game 1, the game could have been played with as few as 4 red, 2 green, and 6 blue cubes. If any color had even one fewer cube, the game would have been impossible.
Game 2 could have been played with a minimum of 1 red, 3 green, and 4 blue cubes.
Game 3 must have been played with at least 20 red, 13 green, and 6 blue cubes.
Game 4 required at least 14 red, 3 green, and 15 blue cubes.
Game 5 needed no fewer than 6 red, 3 green, and 2 blue cubes in the bag.
=end

RSpec.describe "CubeGameTest", type: :request do

  describe 'the validity of a game' do
    it 'has a sum of valid game game IDs that is 2265' do
      input_file = './day2_input.txt'
      game_lines = File.readlines(input_file, chomp: true)

      valid_games_sum = 0
      game_lines.each do |game|
        game = CubesGame.new(game)
        valid_games_sum += game.game_id if game.valid?
      end

      expect(valid_games_sum).to eq(2265)
    end
  end

  describe 'the minimum cubes for a game' do
    it 'produces the minimum cubes for the games' do
      min_cubes_answers = [
        {game_id: 1, red: 4, green: 2, blue: 6},
        {game_id: 2, red: 1, green: 3, blue: 4},
        {game_id: 3, red: 20, green: 13, blue: 6},
        {game_id: 4, red: 14, green: 3, blue: 15},
        {game_id: 5, red: 6, green: 3, blue: 2}
      ]
      [ 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green',
        'Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue',
        'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red',
        'Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red',
        'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green'].each_with_index do |game, idx|

        game = CubesGame.new(game)

        min_cubes = game.min_cubes_needed
        expect(min_cubes[:red]).to eq(min_cubes_answers[idx][:red])
        expect(min_cubes[:green]).to eq(min_cubes_answers[idx][:green])
        expect(min_cubes[:blue]).to eq(min_cubes_answers[idx][:blue])
      end
    end
  end

  describe 'the power of a game' do
    it 'produces the power of the sample games' do
      power_answers = [48, 12, 1560, 630, 36]

      [ 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green',
        'Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue',
        'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red',
        'Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red',
        'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green'].each_with_index do |game, idx|

        game = CubesGame.new(game)

        expect(game.power).to eq(power_answers[idx])
      end
    end

    it 'produces the power of all the games' do
      input_file = './day2_input.txt'
      game_lines = File.readlines(input_file, chomp: true)

      power_sum = 0
      game_lines.each do |game|
        game = CubesGame.new(game)
        power_sum += game.power
      end

      expect(power_sum).to eq(64097)
    end
  end
end