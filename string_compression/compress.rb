require 'minitest/autorun'
require 'pry'
# aabbbccccdddddaaa

def get_first_or_nil string
  return nil if string.nil?
  string[0]
end

def remove_first_char string
  return nil if string.nil?
  return string.reverse.chop!&.reverse
end


def compress string
  return '' if string.nil? || string.empty?

  first_char = get_first_or_nil string
  string = remove_first_char string
  next_char = get_first_or_nil string
  string = remove_first_char string
  count = 1
  while !next_char.nil? && next_char == first_char
    count += 1
    next_char = get_first_or_nil string
    string = remove_first_char string if !next_char.nil? && next_char == first_char
  end

  return "#{first_char}#{count}#{compress(string)}"
end


def decompress string
  return '' if string.nil? || string.empty?

  first_char = get_first_or_nil string
  string = remove_first_char string
  count = string.match(/^\d+/)[0].to_i
  string = string.sub!(/^\d+/, '')
  return "#{first_char*count}#{decompress(string)}"
end



class TestCompress < Minitest::Test
  # To run tests:
  # >ruby -Ilib:test ./make_change.rb
  def test_base_case
    assert_equal '', compress('')
  end

  def test_first_compress_case
    assert_equal 'a2b3c4d5', compress('aabbbccccddddd')
  end

  def test_second_compress_case
    assert_equal 'a2b3c4d5a3', compress('aabbbccccdddddaaa')
  end

  def test_first_decompress_case
    assert_equal 'aabbbccccddddd', decompress('a2b3c4d5')
  end

  def test_second_decompress_case
    assert_equal 'aabbbccccdddddaaa', decompress('a2b3c4d5a3')
  end
end