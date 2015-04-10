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
      #binding.pry
      puts "That spot's already taken! Pick another square."
      self.spot_selection = gets.chomp
    end 
    self.spot_selection = self.spot_selection.to_i
    board.grid_spots[self.spot_selection] = 'X'
    board.remaining_empty_spots.delete(self.spot_selection)
  end
end

class Computer < Player
  attr_accessor :position_to_choose

  def two_in_a_row(board)
    Board::WINNING_LINES.each do |line|
      num_x_in_each_line = line.select {|num| board.grid_spots[num] == 'X'}
      if num_x_in_each_line.length == 2
        third_in_the_row = (line - num_x_in_each_line).first
        if (board.remaining_empty_spots.include?(third_in_the_row))
          self.position_to_choose = third_in_the_row
          break
        end
      end
    end
  end

  def choose_a_spot(board)
    self.two_in_a_row(board)
    if position_to_choose
      self.spot_selection = position_to_choose
    else
      self.spot_selection = board.remaining_empty_spots.sample.to_i
    end
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

  def full_board?
    self.remaining_empty_spots.empty?
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
        self.winner = "you"
        break
      elsif line.select {|num| board.grid_spots[num] == 'O'}.length == 3
        self.winner = "computer"
        break
      end
    end
  end

  def declare_winner
    if self.winner == "you"
      puts "Yay, you win!"
    elsif self.winner == "computer"
      puts "Aww, computer wins :("
    else
      puts "It's a tie!"
    end
  end

  def play
    board.draw_board
    puts "Welcome to Tic-Tac-Toe!"
    begin
      human.choose_a_spot(board)
      computer.choose_a_spot(board)
      human.fill_spot(board, human, 'X')
      board.draw_board
      self.check_for_winner
      break if winner
      computer.fill_spot(board, computer, 'O')
      board.draw_board
      self.check_for_winner
      break if winner
    end until board.full_board?
    self.declare_winner
    puts "Want to play again? Y/N"
    play_again = gets.chomp.downcase
    Game.new.play if play_again == 'y'
  end

end

ttt = Game.new.play