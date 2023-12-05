require_relative '../seed_map.rb'

=begin
Given the input in test_input/day5.txt:

The almanac starts by listing which seeds need to be planted: seeds 79, 14, 55, and 13.

The rest of the almanac contains a list of maps which describe how to convert numbers from a source category into numbers in a destination category. That is, the section that starts with seed-to-soil map: describes how to convert a seed number (the source) to a soil number (the destination). This lets the gardener and his team know which soil to use with which seeds, which water to use with which fertilizer, and so on.

Rather than list every source number and its corresponding destination number one by one, the maps describe entire ranges of numbers that can be converted. Each line within a map contains three numbers: the destination range start, the source range start, and the range length.

Consider again the example seed-to-soil map:

50 98 2
52 50 48
The first line has a destination range start of 50, a source range start of 98, and a range length of 2.
This line means that the source range starts at 98 and contains two values: 98 and 99.
The destination range is the same length, but it starts at 50, so its two values are 50 and 51.
With this information, you know that seed number 98 corresponds to soil number 50 and that seed number 99 corresponds to soil number 51.

The second line means that the source range starts at 50 and contains 48 values: 50, 51, ..., 96, 97. This corresponds to a destination range starting at 52 and also containing 48 values: 52, 53, ..., 98, 99. So, seed number 53 corresponds to soil number 55.

Any source numbers that aren't mapped correspond to the same destination number. So, seed number 10 corresponds to soil number 10.

So, the entire list of seed numbers and their corresponding soil numbers looks like this:

seed  soil
0     0
1     1
...   ...
48    48
49    49
50    52
51    53
...   ...
96    98
97    99
98    50
99    51
With this map, you can look up the soil number required for each initial seed number:

Seed number 79 corresponds to soil number 81.
Seed number 14 corresponds to soil number 14.
Seed number 55 corresponds to soil number 57.
Seed number 13 corresponds to soil number 13.
The gardener and his team want to get started as soon as possible, so they'd like to know the closest location that needs a seed. Using these maps, find the lowest location number that corresponds to any of the initial seeds. To do this, you'll need to convert each seed number through other categories until you can find its corresponding location number. In this example, the corresponding types are:

Seed 79, soil 81, fertilizer 81, water 81, light 74, temperature 78, humidity 78, location 82.
Seed 14, soil 14, fertilizer 53, water 49, light 42, temperature 42, humidity 43, location 43.
Seed 55, soil 57, fertilizer 57, water 53, light 46, temperature 82, humidity 82, location 86.
Seed 13, soil 13, fertilizer 52, water 41, light 34, temperature 34, humidity 35, location 35.
So, the lowest location number in this example is 35.

What is the lowest location number that corresponds to any of the initial seed numbers?
=end

RSpec.describe "SeedMapTest", type: :request do

  describe 'the various maps' do
    let(:sm) { SeedMap.new('./spec/test_input/day5.txt') }

    it 'sets the seeds' do
      expect(sm.seeds).to eq([79,14,55,13])
    end

    it 'creates the seed-to-soil map' do
      expect(sm.seed_map['seed-to-soil']).to eq([[98..99, 50..51], [50..97, 52..99]])
    end

    it 'maps the seeds to the right soil' do
      expected_results = [[79,81],[14,14],[55,57],[13,13]]
      expected_results.each do |seed, soil|
        expect(sm.map(seed, 'seed-to-soil')).to eq(soil)
      end
    end

    it 'creates the rest of the maps' do
      expect(sm.seed_map['soil-to-fertilizer'].class).to eq(Array)
      expect(sm.seed_map['fertilizer-to-water'].class).to eq(Array)
      expect(sm.seed_map['water-to-light'].class).to eq(Array)
      expect(sm.seed_map['light-to-temperature'].class).to eq(Array)
      expect(sm.seed_map['temperature-to-humidity'].class).to eq(Array)
      expect(sm.seed_map['humidity-to-location'].class).to eq(Array)
    end
  end

  describe 'the seed mapping process' do
    let(:sm) { SeedMap.new('./spec/test_input/day5.txt') }

    it 'maps the seeds to the right location' do
      expected_results = [[79,82],[14,43],[55,86],[13,35]]
      expected_results.each do |seed, location|
        expect(sm.find_location(seed)).to eq(location)
      end
    end

    it 'finds the lowest location' do
      expect(sm.seeds.map { |seed| sm.find_location(seed) }.min).to eq(35)
    end
  end
end
