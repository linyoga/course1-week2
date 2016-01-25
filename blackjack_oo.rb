require 'rubygems'
require 'pry'
class Card
  attr_accessor :suit, :face_value
  def initialize(s, fv)
    @suit = s
    @face_value = fv
  end

  def output
   "the #{face_value} of #{suit}"
  end

  def to_s
    output
  end
end

class Deck
  attr_accessor :cards
  def initialize
    @cards = []
    %w[S H D C].each do |suit|
      %w[A 2 3 4 5 6 7 8 9 10 J Q K].each do |face_value|
        @cards << Card.new(suit, face_value)
      end
    end
    scramble!
  end

  def scramble!
    @cards.shuffle!
  end

  def deal_one
    cards.pop
  end

end

module Hand

  def show_hand
    puts "=====#{name}'card is "
    cards.each do |card|
    puts "=> #{card}"
    end
    puts "=> Total is #{total_value}"
  end

  def total_value
    total_points = 0
    ace = 0
    cards.each do |card|
    case card.face_value
    when "A"
      points = 11
      ace += 1
    when "10", "J", "Q", "K"
      points = 10
    when "2", "3", "4", "5", "6", "7", "8", "9"
      points = card.face_value.to_i
    end
    total_points += points
    while total_points > 21 && ace > 0
      total_points -= 10
      ace -= 1
      end
    end
  total_points
  end

  def add_card(new_card)
    cards << new_card
  end

  def is_busted?
    total_value > 21
  end

end

class Player
  include Hand
  attr_accessor :name, :cards
  def initialize(n)
    @name = n
    @cards = []
  end

   def show_flop
    show_hand
  end
  
end
class Dealer
  include Hand
  attr_accessor :name, :cards

    def initialize
      @name = "dealer"
      @cards = []
    end

    def show_flop
      puts "===== dealer' card is "
      puts "first card is hidden"
      puts "=>second card is #{cards[1]}"
    end
end

class Blackjack
  attr_accessor :deck, :player, :dealer
  BLACKJACK_AMOUNT = 21
  def initialize
    @deck = Deck.new
    @player = Player.new("player1")
    @dealer = Dealer.new
  end

  def set_player_name
    puts " What's your name? "
    player.name = gets.chomp
  end

  def deal_cards
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
  end

  def show_flop
    player.show_flop
    dealer.show_flop    
  end

  def blackjack_or_bust?(player_or_dealer)
    if player_or_dealer.total_value == BLACKJACK_AMOUNT
      if player_or_dealer.is_a?(Player)
        puts "#{player.name} hit blackjack, #{player.name} Wins!"
      else
        puts "dealer hit blackjack, #{player.name } loses"
      end
      play_again?
    elsif player_or_dealer.is_busted?
      if player_or_dealer.is_a?(Player)
        puts "#{player.name} is busted, #{player.name} Loses"
      else
        puts "Dealer is busted, #{player.name} Wins"
      end
      play_again?
    end
  end
        
  def player_turn
    puts "#{player.name} turn"

    blackjack_or_bust?(player)

      while !player.is_busted?
        puts "what would you like to do? 1)hit 2)stay"
        response = gets.chomp
      if !['1','2'].include?(response)
        puts "you should type 1 or 2"
        next
      end
      
      if response == '2'
        puts "#{player.name} choose stay."
        break
      end

      #hit
      new_card = deck.deal_one
      puts "Dealing card is #{new_card} to #{player.name}"
      player.add_card(new_card)
      puts "#{player.name} total_value is #{player.total_value}"

      blackjack_or_bust?(player)
    end
      puts "#{player.name} stays at #{player.total_value}"
  end

  def dealer_turn
    puts "dealer's turn"

    blackjack_or_bust?(dealer)
    while dealer.total_value < 17
      new_card = deck.deal_one
      puts "Dealing card is #{new_card} to dealer"
      dealer.add_card(new_card)
      puts "dealer's total_value is #{dealer.total_value}"

      blackjack_or_bust?(dealer)
    end
    dealer.show_hand
    puts "dealer's total_value is #{dealer.total_value}"
  end

  def who_won?
    if player.total_value > dealer.total_value
      puts "#{player.name} Wins"
    elsif player.total_value < dealer.total_value
      puts "#{player.name} Loses"
    else
      puts "It's Tie!"
    end
    play_again?
  end

  def play_again?
    puts "Do you want to play again? 1)yes 2)no"
    if gets.chomp == '1'
      puts "Starting new game..."
      puts ""
      self.deck = Deck.new
      player.cards = []
      dealer.cards = []
      start
    else
      puts "Bye"
      exit
    end
  end

  def start
    set_player_name
    deal_cards
    show_flop
    player_turn
    dealer_turn
    who_won?
  end
end
game = Blackjack.new
game.start