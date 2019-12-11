require 'minitest/autorun'

def make_change amount, coins = []
  return [] if amount == 0

  coin   = 25 if amount >= 25
  coin ||= 10 if amount >= 10
  coin ||=  5 if amount >=  5
  coin ||=  1

  coins << coin
  make_change(amount - coin, coins)
  coins
end


class TestMakeChange < Minitest::Test
  # To run tests:
  # >ruby -Ilib:test ./make_change.rb
  def test_base_case
    assert_equal [], make_change(0)
  end

  def test_we_get_an_array
    (0..100).each do |n|
      assert_instance_of(Array, make_change(n))
    end
  end

  def test_a_variety_of_amounts
    assert_equal [1], make_change(1).sort
    assert_equal [1,1,1,1], make_change(4).sort
    assert_equal [1,1,1,1,5], make_change(9).sort
    assert_equal [1,1,1,1,10,10], make_change(24).sort
    assert_equal [1,5,10,25], make_change(41).sort
    assert_equal [1,25,25,25,25], make_change(101).sort
  end
end