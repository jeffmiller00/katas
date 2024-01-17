#!/usr/bin/env ruby
require 'rss'
require 'open-uri'
require 'pry'

all_url = 'https://www.goodreads.com/review/list_rss/75655479?key=Tt8soer4Aj_JcLAjAxBJblQhIpii7DaWhZwX_Lz-6miLtJmG&shelf=to-read&order=d&per_page=200'
own_url = 'https://www.goodreads.com/review/list_rss/75655479?key=Tt8soer4Aj_JcLAjAxBJblQhIpii7DaWhZwX_Lz-6miLtJmG&shelf=own&per_page=200'

case ARGV[0]
  when 'own'
    urls = [own_url]
  when 'mix'
    urls = []
  else
    urls = [all_url]
end

def get_goodreads_list(url)
  URI.open(url) do |rss|
    feed = RSS::Parser.parse(rss)
   puts "Title: #{feed.channel.title}"
    puts "|--------------------------------------------------"
    return feed.items
  end
end

def select_random_weighted_book(url)
  books = get_goodreads_list(url)
  # puts "Random read is: #{books.sample.title}"
  weighted_list = []
  books.each do |book|
    weight = (book.description.split('rating:')[1].split('book published:')[0].to_f * 100).round
    weighted_list << Array.new(weight, book.title)
  end
  weighted_list.flatten!
  # puts "Weighted random read is: #{weighted_list.flatten.sample}"

  i = 0
  random = books.sample.title
  weighted_random = weighted_list.sample
  while random != weighted_random
    random = books.sample.title
    weighted_random = weighted_list.sample
    i += 1
    puts "Attempt: #{i}"
  end
  puts "📖 #{random} | #{weighted_random}"
end


if urls.empty?
  weight_of_owned = 5
  owned_books = get_goodreads_list(own_url).map(&:title)
  weighted_list = get_goodreads_list(all_url).sample(owned_books.size).map(&:title)
  weight_of_owned.times { weighted_list += owned_books }
  puts "Owned books weighted #{weight_of_owned} times higher, the random read is:"
  puts "📖 #{weighted_list.sample}"
else
  select_random_weighted_book(urls.first)
end
