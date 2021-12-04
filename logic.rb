require_relative 'card'
require_relative 'player'
require_relative 'deck'

module Logic

  def ask_player_name
    puts 'Здравствуйте! Представьтесь и начнем игру!'
    print 'Введите Ваше имя: '
    name = gets.chomp
  end

  def print_info
    puts 'На данный момент у Вас и у Диллера в банке по $100.'
    puts 'Ваша задача набрать 21 очко, либо ближайшеие к 21 очки'
    puts 'Вы проиграете, если у вас на руке будет больше 21. Удачи!'
  end


  def create
    player_name = ask_player_name
    [User.new(player_name), Diler.new]
  end

  def len_check
    return true if @player.card_number==3 and @diler.card_number ==3
    false
  end

  def free_hands
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

  def interface
    puts "#{'='*5} Дилер #{'='*5}"
    puts "Карты: #{'*'*@diler.card_number}"
    puts "#{'='*5} #{@player.name} #{'='*5}"
    puts "Карты: #{@player.hand.hand.map{|card| "#{card.rank}#{card.suit}"}.join(' ,')}"
    puts "Очки: #{@player.hand.scores}"
    puts "Баланс: #{@player.balance}"
    puts '='*15
  end

  def check_end_of_the_game
    if @player.hand.scores == @diler.hand.scores
      draw
    else
      if (21 - @player.hand.scores) < (21 - @diler.hand.scores)
        player_wins
      else
        diler_wins
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

  def play_next_game?
    puts "Хотите сыграть еще раз?
1. Да
2. Нет"
    print 'Ваш выбор: '
    choice = gets.chomp.to_i
    case choice
    when 1
      false
    when 2
      true
    end
  end

  def player_turn
    interface
    puts "1. Взять карту
2. Пропустить ход
3. Открыть карты"
    print('Ваш выбор: ')
    choice = gets.chomp.to_i

    case choice
    when 1
      @player.take_card(@deck.take_card!)
      interface
      return check_end_of_the_game_extern
    when 2
      @player.skip_turn
      return true
    when 3
      return check_end_of_the_game
    end
  end

  def goodbye
    puts "До свидания, #{@player.name}!"
  end


  def diler_turn
    if @diler.hand.scores < 17 and @diler.card_number != 3
      @diler.take_card(@deck.take_card!)
      interface
      check_end_of_the_game_extern
    else
      @diler.skip_turn
    end
  end
end
