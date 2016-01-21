class Player_hand
  include Comparable
  attr_accessor :name, :c
  def initialize(n)
    @name = n
  end

  def show_hand

    puts "#{name} is #{@c}"
  end

  def  <=>(another_hand)
    if @c == another_hand.c
      0
    elsif (@c == 'p' && another_hand.c == 'r') || (@c == 'r' && another_hand.c == 's') || (@c == 's' && another_hand.c == 'p')
      1
    else
     -1
    end 
  end


end

class Human_hand < Player_hand
  attr_accessor :c
  def pick_hand
    begin
      puts 'Pick one (p,r,s):'
    @c = gets.chomp.downcase
    end until Game::CHOICES.keys.include?(c)
  end

end

class Computer_hand < Player_hand

  def pick_hand
    @c = Game::CHOICES.keys.sample
  end

end

class Game
  attr_accessor :player, :computer
  CHOICES ={"p" => "paper", "r" => "rock", "s" => "scissors"}  
  
  def initialize
    @player = Human_hand.new("yoga")
    @computer = Computer_hand.new("Sheldon")
  end

  def compare_hand
    if player == computer
      puts "It's Tie"
    elsif player > computer
      puts "#{player.name} won!"
    else
      puts "#{computer.name} Won!"
    end

  end

        

  def play
    player.pick_hand
    computer.pick_hand
    player.show_hand
    computer.show_hand
    compare_hand
  end  
end
Game.new.play
