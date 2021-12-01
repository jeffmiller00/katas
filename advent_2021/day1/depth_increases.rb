#!/usr/bin/env ruby

DEPTH_READINGS = './depth_reading.txt'

depths = File.read(DEPTH_READINGS).split("\n").map(&:to_i)
went_deeper_count = 0
last_depth = -1
depths.each do |d|
  went_deeper_count += 1 if (d > last_depth && last_depth > 0)
  last_depth = d
end

puts went_deeper_count