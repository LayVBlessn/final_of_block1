require_relative 'card'
require_relative 'player'
require_relative 'deck'

class Logic

  attr_reader :player, :diler, :bank

  def initialize(player_name)
    @player = User.new(player_name)
    @diler = Diler.new
    @bank = 0
  end

  def len_check
    return true if @player.card_number==3 and @diler.card_number ==3
    false
  end

  def free_hands()
    @player.show_cards!
    @diler.show_cards!
  end

  def hand_out_cards
    puts 'Раздача карт...'
    @deck = Deck.new
    2.times{@player.take_card(@deck.take_card!);@diler.take_card(@deck.take_card!)}
  end

  def set_bank
    @bank = 20
    @player.make_a_bet
    @diler.make_a_bet
  end

  def check_end_of_the_game
    if @player.hand.scores == @diler.hand.scores
      draw
      true
    else
      if (21 - @player.hand.scores) < (21 - @diler.hand.scores)
        player_wins
        true
      else
        diler_wins
        true
      end
    end
    false
  end

  def draw
    @player.take_bank(@bank/2)
    @diler.take_bank(@bank/2)
    @bank = 0
    puts 'Ничья!', 'Карты дилера: ' ,@diler.hand.hand.map{|card| "#{card.rank}#{card.suit}"}.join(' ,')
  end

  def diler_wins
    puts 'Победил ', @diler.name, 'Карты дилера: ' ,@diler.hand.hand.map{|card| "#{card.rank}#{card.suit}"}.join(' ,')
    @player.show_cards!
    @diler.show_cards!
    @diler.take_bank(@bank)
    @bank = 0
  end

  def player_wins
    puts 'Победил ', @player.name,'Карты дилера: ' ,@diler.hand.hand.map{|card| "#{card.rank}#{card.suit}"}.join(' ,')
    @player.show_cards!
    @diler.show_cards!
    @player.take_bank(@bank)
    @bank = 0
  end

  def check_end_of_the_game_extern
    if @player.hand.scores == 21
      player_wins
      false
    elsif @diler.hand.scores == 21
      diler_wins
      false
    elsif @player.hand.scores > 21
      diler_wins
      false
    elsif @diler.hand.scores > 21
      player_wins
      false
    end
    true
  end

  def player_turn(interface)
    interface.call(@player, @diler)
    puts "1. Взять карту
2. Пропустить ход
3. Открыть карты"
    print('Ваш выбор: ')
    choice = gets.chomp.to_i

    case choice
    when 1
      @player.take_card(@deck.take_card!)
      interface.call(@player, @diler)
      check_end_of_the_game_extern
    when 2
      @player.skip_turn
      return true
    when 3
      check_end_of_the_game
    end
  end

  def diler_turn(interface)
    if @diler.hand.scores < 17 and @diler.card_number != 3
      @diler.take_card(@deck.take_card!)
      interface.call(@player, @diler)
      check_end_of_the_game_extern
    else
      @diler.skip_turn
    end
  end
end
