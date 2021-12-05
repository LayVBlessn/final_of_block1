class Hand

  attr_accessor :hand

  def initialize
    @hand = []
  end

  def add_card(card)
    @hand << card
  end

  def scores
    sum = 0
    @hand.each do |card|
      if ['J', 'Q', 'K'].include?(card.rank)
        sum += 10
      elsif card.rank == 'A'
        sum+11 <= 21 ? sum +=11 : sum += 1
      elsif card.rank.is_a?(Integer)
        sum += card.rank.to_i
      end
    end
    sum
  end

end
