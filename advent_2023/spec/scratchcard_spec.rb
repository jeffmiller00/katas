require_relative '../scratchcard.rb'

=begin
For example:

Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
In the above example, card 1 has five winning numbers (41, 48, 83, 86, and 17) and eight numbers you have (83, 86, 6, 31, 17, 9, 48, and 53).
Of the numbers you have, four of them (48, 83, 17, and 86) are winning numbers!
That means card 1 is worth 8 points (1 for the first match, then doubled three times for each of the three matches after the first).

- Card 2 has two winning numbers (32 and 61), so it is worth 2 points.
- Card 3 has two winning numbers (1 and 21), so it is worth 2 points.
- Card 4 has one winning number (84), so it is worth 1 point.
- Card 5 has no winning numbers, so it is worth no points.
- Card 6 has no winning numbers, so it is worth no points.

So, in this example, the Elf's pile of scratchcards is worth 13 points.
=end

RSpec.describe "ScratchcardTest", type: :request do

  describe 'the structure of the card' do
    it 'builds the card correctly' do
      card = Scratchcard.new('Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53')
      expect(card.my_numbers).to eq([83, 86, 6, 31, 17, 9, 48, 53])
      expect(card.winning_numbers).to eq([41, 48, 83, 86, 17])
    end

    it 'determines the winning numbers' do
      examples = [
        'Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53',
        'Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19',
        'Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1',
        'Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83',
        'Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36',
        'Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11']
      results = [
        [48, 83, 17, 86],
        [32, 61],
        [1, 21],
        [84],
        [],
        []]
      examples.each_with_index do |example, index|
        card = Scratchcard.new(example)
        expect(card.winners.sort).to eq(results[index].sort)
      end
    end

    it 'scores the card correctly' do
      examples = [
        'Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53',
        'Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19',
        'Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1',
        'Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83',
        'Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36',
        'Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11']
      expected_results = [8, 2, 2, 1, 0, 0]
      results = []
      examples.each_with_index do |example, index|
        card = Scratchcard.new(example)
        results << card.score
        expect(card.score).to eq(expected_results[index])
      end
      expect(results.sum).to eq(13)
    end
  end

  describe 'processing of the whole file' do
    it 'scores the whole file correctly' do
      input_file = './input_data/day4.txt'
      all_games = File.readlines(input_file, chomp: true)
      results = []
      all_games.each do |game|
        card = Scratchcard.new(game)
        results << card.score
      end

      expect(results.sum).to eq(21485)
    end
  end
end