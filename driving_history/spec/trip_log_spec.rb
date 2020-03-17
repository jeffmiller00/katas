require 'spec_helper'

describe TripLog do
  describe '#parse' do
    context 'Driver command' do
      it 'correctly parses a basic command' do
        commands = TripLog.parse('Driver Test')
        expect(commands[:command]).to eq 'Driver'
        expect(commands[:name]).to eq 'Test'
      end

      it 'correctly parses a more complicated Driver command' do
        commands = TripLog.parse('Driver Testy McTesterson')
        expect(commands[:command]).to eq 'Driver'
        expect(commands[:name]).to eq 'Testy McTesterson'
      end
    end

    context 'Trip command' do
      before(:each) { Driver.class_variable_set :@@all_drivers, [] }

      it 'correctly parses a basic Trip command' do
        Driver.create!('Test')
        commands = TripLog.parse('Trip Test 01:00 02:00 3')
        expect(commands[:command]).to    eq 'Trip'
        expect(commands[:name]).to       eq 'Test'
        expect(commands[:start_time]).to eq '01:00'
        expect(commands[:end_time]).to   eq '02:00'
        expect(commands[:distance]).to   eq '3'
      end

      it 'correctly parses a more complicated Trip command' do
        Driver.create!('Test McTesterson the III')
        commands = TripLog.parse('Trip Test McTesterson the III 01:00 02:00 3')
        expect(commands[:command]).to    eq 'Trip'
        expect(commands[:name]).to       eq 'Test McTesterson the III'
        expect(commands[:start_time]).to eq '01:00'
        expect(commands[:end_time]).to   eq '02:00'
        expect(commands[:distance]).to   eq '3'
      end
    end
  end
end