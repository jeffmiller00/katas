require_relative '../camel_cards.rb'

=begin
In Camel Cards, you get a list of hands, and your goal is to order them based on the strength of each hand. A hand consists of five cards labeled one of A, K, Q, J, T, 9, 8, 7, 6, 5, 4, 3, or 2. The relative strength of each card follows this order, where A is the highest and 2 is the lowest.

Every hand is exactly one type. From strongest to weakest, they are:

- Five of a kind, where all five cards have the same label: AAAAA
- Four of a kind, where four cards have the same label and one card has a different label: AA8AA
- Full house, where three cards have the same label, and the remaining two cards share a different label: 23332
- Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98
- Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432
- One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4
- High card, where all cards' labels are distinct: 23456
- Hands are primarily ordered based on type; for example, every full house is stronger than any three of a kind.

If two hands have the same type, a second ordering rule takes effect. Start by comparing the first card in each hand. If these cards are different, the hand with the stronger first card is considered stronger. If the first card in each hand have the same label, however, then move on to considering the second card in each hand. If they differ, the hand with the higher second card wins; otherwise, continue with the third card in each hand, then the fourth, then the fifth.

So, 33332 and 2AAAA are both four of a kind hands, but 33332 is stronger because its first card is stronger. Similarly, 77888 and 77788 are both a full house, but 77888 is stronger because its third card is stronger (and both hands have the same first and second card).

To play Camel Cards, you are given a list of hands and their corresponding bid (your puzzle input). For example:

32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
This example shows five hands; each hand is followed by its bid amount. Each hand wins an amount equal to its bid multiplied by its rank, where the weakest hand gets rank 1, the second-weakest hand gets rank 2, and so on up to the strongest hand. Because there are five hands in this example, the strongest hand will have rank 5 and its bid will be multiplied by 5.

So, the first step is to put the hands in order of strength:

- 32T3K is the only one pair and the other hands are all a stronger type, so it gets rank 1.
- KK677 and KTJJT are both two pair. Their first cards both have the same label, but the second card of KK677 is stronger (K vs T), so KTJJT gets rank 2 and KK677 gets rank 3.
- T55J5 and QQQJA are both three of a kind. QQQJA has a stronger first card, so it gets rank 5 and T55J5 gets rank 4.
Now, you can determine the total winnings of this set of hands by adding up the result of multiplying each hand's bid with its rank (765 * 1 + 220 * 2 + 28 * 3 + 684 * 4 + 483 * 5). So the total winnings in this example are 6440.

Find the rank of every hand in your set. What are the total winnings?
=end

RSpec.describe "CamelCardsTest", type: :request do

  describe 'builds a game' do
    let(:game) { CamelCards.new('./spec/test_input/day7-1.txt', false) }

    it 'creates hands correctly' do
      expect(game.hands.first.cards).to eq([3,2,10,3,13])
      expect(game.hands.first.bid).to eq(765)
    end

    it 'determines the power of a hand' do
      expect(game.hands.first.power).to eq(2)
      expect(game.hands[1].power).to eq(4)
      expect(game.hands[2].power).to eq(3)
      expect(game.hands[3].power).to eq(3)
      expect(game.hands[4].power).to eq(4)
    end

    it 'determines the power of a five-of-a-kind hand' do
      hand = Hand.new('AAAAA 1')
      expect(hand.power).to eq(7)
    end

    it 'determines the power of a four-of-a-kind hand' do
      hand = Hand.new('AA1AA 1')
      expect(hand.power).to eq(6)
    end

    it 'determines the power of a full house hand' do
      hand = Hand.new('55AAA 1')
      expect(hand.power).to eq(5)
    end

    it 'determines the power of a one pair hand' do
      hand = Hand.new('J6396 1')
      expect(hand.power).to eq(2)
    end

    it 'determines the power of nothing in hand' do
      hand = Hand.new('AK359 1')
      expect(hand.power).to eq(1)
    end

    it 'orders the hands' do
      expect(game.order_hands.map!(&:bid)).to eq([765, 220, 28, 684, 483])
    end

    it 'calculates the winnings' do
      expect(game.winnings).to eq(6440)
    end

    it 'solves the puzzle' do
      game = CamelCards.new
      winnings = game.winnings
      expect(winnings).to be > 247775809
      expect(winnings).to be < 248038280
      expect(winnings).to eq(247823654)
    end
  end

=begin
--- Part Two ---
To make things a little more interesting, the Elf introduces one additional rule.
Now, J cards are jokers - wildcards that can act like whatever card would make the hand the strongest type possible.

To balance this, J cards are now the weakest individual cards, weaker even than 2.
The other cards stay in the same order: A, K, Q, T, 9, 8, 7, 6, 5, 4, 3, 2, J.

J cards can pretend to be whatever card is best for the purpose of determining hand type; for example, QJJQ2 is now considered four of a kind. However, for the purpose of breaking ties between two hands of the same type, J is always treated as J, not the card it's pretending to be: JKKK2 is weaker than QQQQ2 because J is weaker than Q.

Now, the above example goes very differently:

32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
- 32T3K is still the only one pair; it doesn't contain any jokers, so its strength doesn't increase.
- KK677 is now the only two pair, making it the second-weakest hand.
- T55J5, KTJJT, and QQQJA are now all four of a kind! T55J5 gets rank 3, QQQJA gets rank 4, and KTJJT gets rank 5.
- With the new joker rule, the total winnings in this example are 5905.

Using the new joker rule, find the rank of every hand in your set. What are the new total winnings?
=end

  describe 'builds a game including the Joker' do
    let(:game) { CamelCards.new('./spec/test_input/day7-2.txt', true) }

    it 'creates hands correctly' do
      expect(game.hands[1].cards).to eq([10,5,5,1,5])
      expect(game.hands[1].bid).to eq(684)
    end

    it 'determines the power of a hand' do
      expect(game.hands.first.power).to eq(2)
      expect(game.hands[1].power).to eq(6)
      expect(game.hands[2].power).to eq(3)
      expect(game.hands[3].power).to eq(6)
      expect(game.hands[4].power).to eq(6)
    end

    it 'determines the power of a five-of-a-kind hand' do
      hand = Hand.new('AAAAA 1', true)
      expect(hand.power).to eq(7)
    end

    it 'determines the power of a five-of-a-kind hand with joker' do
      hand = Hand.new('AAJJA 1', true)
      expect(hand.power).to eq(7)
    end

    it 'determines the power of a four-of-a-kind hand' do
      hand = Hand.new('AA2AA 1', true)
      expect(hand.power).to eq(6)
    end

    it 'determines the power of a four-of-a-kind hand with joker' do
      hand = Hand.new('JJ2JA 1', true)
      expect(hand.power).to eq(6)
    end

    it 'determines the power of a full house hand' do
      hand = Hand.new('55AAA 1', true)
      expect(hand.power).to eq(5)
    end

    it 'determines the power of a full house hand with joker' do
      hand = Hand.new('J22AA 1', true)
      expect(hand.power).to eq(5)
    end

    it 'determines the power of a three-of-a-kind hand' do
      hand = Hand.new('A52AA 1', true)
      expect(hand.power).to eq(4)
    end

    it 'determines the power of a three-of-a-kind hand with joker' do
      hand = Hand.new('AJ27A 1', true)
      expect(hand.power).to eq(4)
    end

    it 'determines the power of a two pair hand with joker' do
      # This scenario can't happen...so expected result is a 3-of-a-kind
      hand = Hand.new('AAJK5 1', true)
      expect(hand.power).to eq(4)
    end

    it 'determines the power of a one pair hand' do
      hand = Hand.new('26396 1', true)
      expect(hand.power).to eq(2)
    end

    it 'determines the power of a one pair hand with joker' do
      hand = Hand.new('8AJ75 1', true)
      expect(hand.power).to eq(2)
    end

    it 'determines the power of nothing in hand' do
      hand = Hand.new('AK359 1', true)
      expect(hand.power).to eq(1)
    end

    it 'orders the hands' do
      expect(game.order_hands.map!(&:bid)).to eq([765, 28, 684, 483, 220])
    end

    it 'calculates the winnings' do
      expect(game.winnings).to eq(5905)
    end

    it 'solves the part 2 puzzle' do
      game = CamelCards.new('./input_data/day7.txt', true)
      winnings = game.winnings
      expect(winnings).to be > 245363459
      expect(winnings).to be < 248010791
      expect(winnings).to eq(245461700)
    end
  end
end
