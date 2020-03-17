require 'spec_helper'

describe Trip do
  describe '#new' do
    it 'takes three parameters' do
      expect(Trip.new('00:01', '01:01', '60')).to be_an_instance_of Trip
    end

    it 'should not allow the end time to be after the start time' do
      driver = Driver.new('Test')
      expect{Trip.new('01:01', '00:01', '60')}.to raise_error(ArgumentError)
    end

    it 'should not create a trip if the speed is too low' do
      driver = Driver.new('Test')
      # Requirement: Discard any trips that average a speed of less than 5 mph or greater than 100 mph.
      expect{Trip.new('00:01', '01:01', '4.9')}.to raise_error(ArgumentError)
    end

    it 'should not create a trip if the speed is too high' do
      driver = Driver.new('Test')
      # Requirement: Discard any trips that average a speed of less than 5 mph or greater than 100 mph.
      expect{Trip.new('00:01', '01:01', '100.1')}.to raise_error(ArgumentError)
    end
  end

  it "should properly calculate the trip's length" do
    expect(Trip.new('00:01', '02:31', '100.2').length).to eq 2.5
  end

  it "should properly calculate the trip's speed" do
    expect(Trip.new('00:01', '02:01', '100.2').miles_per_hour).to eq 50.1
  end
end