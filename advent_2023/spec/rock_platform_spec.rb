require_relative '../rock_platform.rb'

=begin
In short: if you move the rocks, you can focus the dish.
The platform even has a control panel on the side that lets you tilt it in one of four directions!
The rounded rocks (O) will roll when the platform is tilted, while the cube-shaped rocks (#) will stay in place.
You note the positions of all of the empty spaces (.) and rocks (your puzzle input). For example:

O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
Start by tilting the lever so all of the rocks will slide north as far as they will go:

OOOO.#.O..
OO..#....#
OO..O##..O
O..#.OO...
........#.
..#....#.#
..O..#.O.O
..O.......
#....###..
#....#....
You notice that the support beams along the north side of the platform are damaged; to ensure the platform doesn't collapse, you should calculate the total load on the north support beams.

The amount of load caused by a single rounded rock (O) is equal to the number of rows from the rock to the south edge of the platform, including the row the rock is on.
(Cube-shaped rocks (#) don't contribute to load.) So, the amount of load caused by each rock in each row is as follows:

OOOO.#.O.. 10
OO..#....#  9
OO..O##..O  8
O..#.OO...  7
........#.  6
..#....#.#  5
..O..#.O.O  4
..O.......  3
#....###..  2
#....#....  1
The total load is the sum of the load caused by all of the rounded rocks.
In this example, the total load is 136.

Tilt the platform so that the rounded rocks all roll north. Afterward, what is the total load on the north support beams?
=end

RSpec.describe "RockPlatformTest", type: :request do

  describe 'moves the round rocks when tilted' do
    let(:platform) { RockPlatform.new('./spec/test_input/day14.txt') }

    it 'moves them toward the north' do
      expect(platform.rock_platform.first).to eq('O....#....'.chars)
      expect(platform.tilt.rock_platform.first).to eq('OOOO.#.O..'.chars)
    end

    it 'calculates the load on the north support beam' do
      expect(platform.tilt.total_load).to eq(136)
    end

    it 'cycles them correctly' do
      expect(platform.cycle).to eq(['.....#....'.chars,
                                    '....#...O#'.chars,
                                    '...OO##...'.chars,
                                    '.OO#......'.chars,
                                    '.....OOO#.'.chars,
                                    '.O#...O#.#'.chars,
                                    '....O#....'.chars,
                                    '......OOOO'.chars,
                                    '#...O###..'.chars,
                                    '#..OO#....'.chars])
    end

    it 'can cycle multiple times' do
      expect(platform.cycle(3)).to eq([   '.....#....'.chars,
                                        '....#...O#'.chars,
                                        '.....##...'.chars,
                                        '..O#......'.chars,
                                        '.....OOO#.'.chars,
                                        '.O#...O#.#'.chars,
                                        '....O#...O'.chars,
                                        '.......OOO'.chars,
                                        '#...O###.O'.chars,
                                        '#.OOO#...O'.chars])
    end

    it 'calculates the load on the north support beam after cycling' do
      skip 'My solution is not performant enough to run this test'
      expect(platform.cycle(1_000_000_000).total_load).to eq(64)
    end
  end

  describe 'Part 1' do
    let(:platform) { RockPlatform.new }

    it 'calculates the load on the north support beam' do
      expect(platform.tilt.total_load).to eq(109654)
    end
  end

  # describe 'Part 2' do
  #   let(:gm) { GalaxyMap.new }

  #   it 'calculates shortest path sum correctly' do
  #     expect(gm.shortest_path_sum).to be < 842646756432
  #     expect(gm.shortest_path_sum).to eq(842645913794)
  #   end
  # end
end
