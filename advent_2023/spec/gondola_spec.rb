require_relative '../gondola.rb'

=begin
Here is an example engine schematic:

467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
In this schematic, two numbers are not part numbers because they are not adjacent to a symbol: 114 (top right) and 58 (middle right). Every other number is adjacent to a symbol and so is a part number; their sum is 4361.
=end

RSpec.describe "GondolaTest", type: :request do

  describe 'the engine schematic' do
    it 'finds the part numbers' do
      gondola = Gondola.new('./spec/test_input/day3.txt')

      expect(gondola.find_part_numbers).to eq([467, 35, 633, 617, 592, 755, 664, 598])
    end

    it 'finds the sum of the sample part numbers' do
      gondola = Gondola.new('./spec/test_input/day3.txt')

      expect(gondola.find_part_numbers.sum).to eq(4361)
    end

    it 'finds the sum of all part numbers' do
      gondola = Gondola.new

      expect(gondola.find_part_numbers.sum).to eq(537832)
    end


    it 'finds the gear ratios' do
      gondola = Gondola.new('./spec/test_input/day3.txt')

      expect(gondola.find_gear_ratios).to eq([16345, 451490])
    end

    it 'finds the sum of the sample part numbers' do
      gondola = Gondola.new('./spec/test_input/day3.txt')

      expect(gondola.find_gear_ratios.sum).to eq(467835)
    end

    it 'finds the sum of all part numbers' do
      gondola = Gondola.new

      expect(gondola.find_gear_ratios.sum).to eq(81939900)
    end
  end
end