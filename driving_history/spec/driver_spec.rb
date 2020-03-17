require 'spec_helper'

describe Driver do
  describe '#new' do
    it 'takes one parameter' do
      expect(Driver.new('Test')).to be_an_instance_of Driver
    end

    it 'should allow the name to be returned' do
      expect(Driver.new('Test Name').full_name).to eq 'Test Name'
    end

    it 'always returns an array for the trips' do
      expect(Driver.new('Test').trips).to be_an_instance_of Array
    end
  end

  describe 'the calculations' do
    let(:driver) { Driver.new('Test') }

    it 'can calculate the total distance of all the trips' do
      driver.add_trip(Trip.new('00:01', '01:01', '60.1'))
      driver.add_trip(Trip.new('00:01', '01:01', '40.1'))
      expect(driver.total_distance).to eq 100.2
    end

    it 'can calculate the total length of all the trips' do
      driver.add_trip(Trip.new('00:01', '01:01', '60.1'))
      driver.add_trip(Trip.new('00:01', '01:01', '40.1'))
      expect(driver.total_length).to eq 2
    end

    it 'can calculate a simple average speed of all the trips' do
      driver.add_trip(Trip.new('00:01', '01:01', '60'))
      driver.add_trip(Trip.new('00:01', '01:01', '40'))
      expect(driver.average_speed).to eq 50
    end

    it 'can calculate a more complex average speed of all the trips' do
      driver.add_trip(Trip.new('00:01', '02:01', '40'))
      driver.add_trip(Trip.new('00:01', '03:01', '25'))
      expect(driver.average_speed).to eq 13
    end

    it 'can calculate the average speed from the requirements' do
      driver.add_trip(Trip.new('07:15', '07:45', '17.3'))
      driver.add_trip(Trip.new('06:12', '06:32', '21.8'))
      expect(driver.average_speed.round).to eq 47
    end

    it 'includes all of the elements we care about in the output' do
      driver.add_trip(Trip.new('00:01', '02:01', '40'))
      driver.add_trip(Trip.new('00:01', '04:01', '25'))
      expect(driver.to_s).to include(driver.full_name)
      expect(driver.to_s).to include(driver.total_distance.round.to_s)
      expect(driver.to_s).to include(driver.average_speed.round.to_s)
    end

    it 'includes all of the elements we care about in the output' do
      expect(driver.to_s).to include(driver.full_name)
      expect(driver.to_s).to include(driver.total_distance.round.to_s)
    end
  end

  describe 'the class functions' do
    before(:each) { Driver.class_variable_set :@@all_drivers, [] }

    it 'finds the correct driver based on name' do
      d1 = Driver.create!('Test1')
      d2 = Driver.create!('Test2')
      d3 = Driver.create!('Test3')
      expect(Driver.find('Test2')).to eq d2
    end

    it 'sorts the drivers desc based on distance driven' do
      d1 = Driver.create!('Test1')
      # No trips

      d2 = Driver.create!('Test2')
      d2.add_trip(Trip.new('01:00', '01:01', '1'))

      d3 = Driver.create!('Test3')
      d3.add_trip(Trip.new('01:00', '01:01', '1'))
      d3.add_trip(Trip.new('02:00', '02:01', '1'))

      d4 = Driver.create!('Test4')
      d4.add_trip(Trip.new('01:00', '01:01', '1'))
      d4.add_trip(Trip.new('02:00', '02:01', '1'))
      d4.add_trip(Trip.new('03:00', '03:01', '1'))

      expect(Driver.sort_by_total_distance!).to eq [d4,d3,d2,d1]
    end
  end
end