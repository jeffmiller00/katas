require_relative '../calibration_values.rb'

RSpec.describe "CalibraionValuesTest", type: :request do

  describe "check the initial calibration values sum" do
    it "should be eq to 56049 when only digits are in play" do
      cv = CalibrationValues.new
      expect(cv.sum).to eq(54530)
    end
  end


  describe 'build an in order array of numbers from a line' do
    it 'should return an in order array of digits' do
      expect(CalibrationValues.new.build_int_array_from_line('dc1jcj2')).to eq([1, 2])
    end

    it 'should return an in order array of word numbers' do
      expect(CalibrationValues.new.build_int_array_from_line('tnzrrzmcsnfivefeightrjnithreenexrhnnfbcb')).to eq([5, 8, 3])
    end

    it 'should return an in order array of digits and word numbers' do
      expect(CalibrationValues.new.build_int_array_from_line('eighttxqtfjrldgxdpgkblzt3three')).to eq([8, 3, 3])
    end
  end


  describe 'check numeric and word digits' do
    it 'should find words and treat them as digits' do
      cv = CalibrationValues.new
      expect(cv.index_of_first_word_number('heightseven4two5')).to eq(1)
    end
  end

end