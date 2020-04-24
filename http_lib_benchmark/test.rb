require 'benchmark'
require "httpi"
require "typhoeus"
require "httparty"
require 'faraday'


URL = 'http://api.stackexchange.com/2.2/questions?site=stackoverflow'
n = 100

Benchmark.bm do |benchmark|
  benchmark.report("HTTPI") do
    HTTPI.log = false
    n.times do
      HTTPI.get(URL)
    end
  end

  benchmark.report("Typhoeus") do
    n.times do
      Typhoeus.get(URL)
    end
  end

  benchmark.report("HTTParty") do
    n.times do
      HTTParty.get(URL)
    end
  end

  benchmark.report("Faraday") do
    n.times do
      Faraday.get(URL)
    end
  end
end
