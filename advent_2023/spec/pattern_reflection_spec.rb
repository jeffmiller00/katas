require_relative '../pattern_reflection.rb'

=begin
You note down the patterns of ash (.) and rocks (#) that you see as you walk (your puzzle input); perhaps by carefully analyzing these patterns, you can figure out where the mirrors are!

For example:

#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
To find the reflection in each pattern, you need to find a perfect reflection across either a horizontal line between two rows or across a vertical line between two columns.

In the first pattern, the reflection is across a vertical line between two columns; arrows on each of the two columns point at the line between the columns:

123456789
    ><
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.
    ><
123456789
In this pattern, the line of reflection is the vertical line between columns 5 and 6.
Because the vertical line is not perfectly in the middle of the pattern, part of the pattern (column 1) has nowhere to reflect onto and can be ignored; every other column has a reflected column within the pattern and must match exactly: column 2 matches column 9, column 3 matches 8, 4 matches 7, and 5 matches 6.

The second pattern reflects across a horizontal line instead:

1 #...##..# 1
2 #....#..# 2
3 ..##..### 3
4v#####.##.v4
5^#####.##.^5
6 ..##..### 6
7 #....#..# 7
This pattern reflects across the horizontal line between rows 4 and 5. Row 1 would reflect with a hypothetical row 8, but since that's not in the pattern, row 1 doesn't need to match anything.
The remaining rows match: row 2 matches row 7, row 3 matches row 6, and row 4 matches row 5.

To summarize your pattern notes, add up the number of columns to the left of each vertical line of reflection;
to that, also add 100 multiplied by the number of rows above each horizontal line of reflection.
In the above example, the first pattern's vertical line has 5 columns to its left and the second pattern's horizontal line has 4 rows above it, a total of 405.

Find the line of reflection in each of the patterns in your notes. What number do you get after summarizing all of your notes?
=end

RSpec.describe "PatternReflectionTest", type: :request do

  xdescribe 'a horizontal reflection pattern' do
    let(:pattern) { PatternReflection.new(File.readlines('./spec/test_input/day13-horiz.txt', chomp: true).map(&:chars)) }

    it 'finds the inflection points' do
      expect(pattern.find_potential_inflection_points).to eq([3.5])
      expect(pattern.find_reflection).to eq(3.5)
    end

    it 'calculates the summary correctly' do
      expect(pattern.summarize).to eq(400)
    end
  end

  xdescribe 'a vertical reflection pattern' do
    let(:pattern) { PatternReflection.new(File.readlines('./spec/test_input/day13-vert.txt', chomp: true).map(&:chars)) }

    it 'finds the potential inflection points' do
      # expect(pattern.find_potential_inflection_points).to eq([4.5])
      expect(pattern.find_reflection).to eq(4.5)
    end

    it 'calculates the summary correctly' do
      expect(pattern.summarize).to eq(5)
    end
  end

  xdescribe 'multiple reflection patterns' do
    let(:patterns) { PatternReflectionMap.new('./spec/test_input/day13.txt') }

    it 'sums the summaries' do
      expect(patterns.sum_summaries).to eq(405)
    end
  end

  describe 'Part 1' do
    let(:patterns) { PatternReflectionMap.new }

    it 'calculates reflection summary sum correctly' do
      expect(patterns.sum_summaries).to eq(37975)
    end
  end


  # --- Part 2 ---
  describe 'a horizontal reflection pattern' do
    let(:pattern) { PatternReflection.new(File.readlines('./spec/test_input/day13-vert.txt', chomp: true).map(&:chars)) }

    it 'finds the inflection points' do
      expect(pattern.find_potential_inflection_points).to eq([2.5])
      expect(pattern.find_reflection).to eq(2.5)
    end

    it 'calculates the summary correctly' do
      expect(pattern.summarize).to eq(400)
    end
  end

  xdescribe 'Part 2' do
    let(:gm) { GalaxyMap.new }

    it 'calculates shortest path sum correctly' do
      expect(gm.shortest_path_sum).to be < 842646756432
      expect(gm.shortest_path_sum).to eq(842645913794)
    end
  end
end
