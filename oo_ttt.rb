require 'pry'

class Player
  attr_accessor :spot_selection

  def fill_spot(board, player, fill_content)
    board.grid_spots[player.spot_selection] = fill_content
  end
end

class Human < Player
  def choose_a_spot(board)
    begin
      puts "Pick a square from 1-9."
      self.spot_selection = gets.chomp
    end until %w(1 2 3 4 5 6 7 8 9).include?(self.spot_selection)
    until board.remaining_empty_spots.map{|number| number.to_s}.include?(spot_selection)
      binding.pry
      puts "That spot's already taken! Pick another square."
      self.spot_selection = gets.chomp
    end 
    self.spot_selection = self.spot_selection.to_i
    board.grid_spots[self.spot_selection] = 'X'
    board.remaining_empty_spots.delete(self.spot_selection)
  end
end

class Computer < Player
  def choose_a_spot(board)
    self.spot_selection = board.remaining_empty_spots.sample.to_i
    board.grid_spots[self.spot_selection] = 'O'
    board.remaining_empty_spots.delete(self.spot_selection)
  end
end

class Board
  WINNING_LINES = [[1,2,3],[1,5,9],[1,4,7],[2,5,8],[3,6,9],[3,5,7],[4,5,6],[7,8,9]]
  attr_accessor :grid_spots
  attr_reader :remaining_empty_spots

  def initialize
    @grid_spots = []
    @remaining_empty_spots = []
    for i in 1..9
      grid_spots[i] = " "
      remaining_empty_spots << i
    end
  end

  def draw_board
    system 'clear'
    puts "       |       |       "
    puts "   #{grid_spots[1]}   |   #{grid_spots[2]}   |   #{grid_spots[3]}   "
    puts "       |       |       "
    puts "-----------------------"
    puts "       |       |       "
    puts "   #{grid_spots[4]}   |   #{grid_spots[5]}   |   #{grid_spots[6]}   "
    puts "       |       |       "
    puts "-----------------------"
    puts "       |       |       "
    puts "   #{grid_spots[7]}   |   #{grid_spots[8]}   |   #{grid_spots[9]}   "
    puts "       |       |       "
  end
end

class Game
  attr_accessor :board, :human, :computer, :winner

  def initialize
    @board = Board.new
    @human = Human.new
    @computer = Computer.new
    @winner = nil
  end

  def check_for_winner
    Board::WINNING_LINES.each do |line|
      if line.select {|num| board.grid_spots[num] == 'X'}.length == 3
        binding.pry
        winner = "you"
      elsif line.select {|num| board.grid_spots[num] == 'O'}.length == 3
        winner = "computer"
      end
    end
  end

  def declare_winner
    puts "The winner is #{winner}!"
  end

  def play
    board.draw_board
    puts "Welcome to Tic-Tac-Toe!"
    begin
      human.choose_a_spot(board)
      computer.choose_a_spot(board)
      human.fill_spot(board, human, 'X')
      self.check_for_winner
      break if winner
      #binding.pry
      computer.fill_spot(board, computer, 'O')
      self.check_for_winner
      break if winner
      board.draw_board
    end until winner != nil
    self.declare_winner
  end

end

ttt = Game.new.play