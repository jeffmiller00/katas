require 'rss'
require 'open-uri'

url = 'https://www.goodreads.com/review/list_rss/75655479?key=Tt8soer4Aj_JcLAjAxBJblQhIpii7DaWhZwX_Lz-6miLtJmG&shelf=to-read&order=d'
open(url) do |rss|
  feed = RSS::Parser.parse(rss)
  puts "Title: #{feed.channel.title}"
  puts "|--------------------------------------------------"
  # puts "Random read is: #{feed.items.sample.title}"
  weighted_list = []
  feed.items.each do |item|
    weight = (item.description.split('rating:')[1].split('book published:')[0].to_f * 100).round
    weighted_list << Array.new(weight, item.title)
  end
  # puts "Weighted random read is: #{weighted_list.flatten.sample}"

  i = 0
  random = feed.items.sample.title
  weighted_random = weighted_list.flatten.sample
  while random != weighted_random
    random = feed.items.sample.title
    weighted_random = weighted_list.flatten.sample
    i += 1
    puts "Attempt: #{i}"
  end
  puts "#{random} | #{weighted_random}"
end