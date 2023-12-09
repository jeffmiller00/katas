require_relative '../oasis_report.rb'

=begin
You pull out your handy Oasis And Sand Instability Sensor and analyze your surroundings. The OASIS produces a report of many values and how they are changing over time (your puzzle input). Each line in the report contains the history of a single value. For example:

0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
To best protect the oasis, your environmental report should include a prediction of the next value in each history. To do this, start by making a new sequence from the difference at each step of your history. If that sequence is not all zeroes, repeat this process, using the sequence you just generated as the input sequence. Once all of the values in your latest sequence are zeroes, you can extrapolate what the next value of the original history should be.

In the above dataset, the first history is 0 3 6 9 12 15. Because the values increase by 3 each step, the first sequence of differences that you generate will be 3 3 3 3 3. Note that this sequence has one fewer value than the input sequence because at each step it considers two numbers from the input. Since these values aren't all zero, repeat the process: the values differ by 0 at each step, so the next sequence is 0 0 0 0. This means you have enough information to extrapolate the history! Visually, these sequences can be arranged like this:

0   3   6   9  12  15
  3   3   3   3   3
    0   0   0   0
To extrapolate, start by adding a new zero to the end of your list of zeroes; because the zeroes represent differences between the two values above them, this also means there is now a placeholder in every sequence above it:

0   3   6   9  12  15   B
  3   3   3   3   3   A
    0   0   0   0   0
You can then start filling in placeholders from the bottom up. A needs to be the result of increasing 3 (the value to its left) by 0 (the value below it); this means A must be 3:

0   3   6   9  12  15   B
  3   3   3   3   3   3
    0   0   0   0   0
Finally, you can fill in B, which needs to be the result of increasing 15 (the value to its left) by 3 (the value below it), or 18:

0   3   6   9  12  15  18
  3   3   3   3   3   3
    0   0   0   0   0
So, the next value of the first history is 18.

Finding all-zero differences for the second history requires an additional sequence:

1   3   6  10  15  21
  2   3   4   5   6
    1   1   1   1
      0   0   0
Then, following the same process as before, work out the next value in each sequence from the bottom up:

1   3   6  10  15  21  28
  2   3   4   5   6   7
    1   1   1   1   1
      0   0   0   0
So, the next value of the second history is 28.

The third history requires even more sequences, but its next value can be found the same way:

10  13  16  21  30  45  68
   3   3   5   9  15  23
     0   2   4   6   8
       2   2   2   2
         0   0   0
So, the next value of the third history is 68.

If you find the next value for each history in this example and add them together, you get 114.

Analyze your OASIS report and extrapolate the next value for each history. What is the sum of these extrapolated values?
=end

RSpec.describe "OasisReportTest", type: :request do

  describe 'builds a report' do
    let(:report) { OasisReport.new('./spec/test_input/day9.txt') }

    it 'creates numbers correctly' do
      expect(report.values.first.history).to eq([0,3,6,9,12,15])
    end

    it 'sums the next values' do
      expect(report.values.map(&:next_value).sum).to eq(114)
    end

    it 'solves the problem' do
      expect(OasisReport.new.values.map(&:next_value).sum).to eq(1901217887)
    end
  end

  # --- Part Two ---
  describe 'builds a report in reverse' do
    let(:report) { OasisReport.new('./spec/test_input/day9.txt', reverse: true) }

    it 'creates numbers correctly in reverse' do
      expect(report.values.first.history).to eq([0,3,6,9,12,15].reverse)
    end

    it 'sums the next values' do
      expect(report.values.map(&:next_value).sum).to eq(2)
    end
  end

  describe 'a single value history' do

    it 'finds the next value with consistent increments' do
      expect(ValueHistory.new([0,3,6,9,12,15]).next_value).to eq(18)
    end

    it 'finds the next value with two layers of differences' do
      expect(ValueHistory.new([1,3,6,10,15,21]).next_value).to eq(28)
    end

    it 'finds the next value with multiple layers of differences' do
      expect(ValueHistory.new([10,13,16,21,30,45]).next_value).to eq(68)
    end
  end
end
