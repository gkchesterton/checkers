require_relative 'board'
require_relative 'player'

class Game

	def initialize(player1 = Player.new("George Washington Carver", :red), 
			player2 = Player.new("Kanye West", :black))

		@player1 = player1
		@player2 = player2
		@board = Board.new
	end

	def play
		until @board.over?
			[@player1, @player2].each do |player|
				puts @board
				begin	
					move = player.get_move
					raise "wrong color" if player.color != @board[move[0]].color 
					@board[move[0]].perform_moves(move[1..-1])
				rescue
					puts "Invalid, please try again."
					retry
				end
			end
		end
	end

end

class InvalidMoveError < StandardError
end

if __FILE__ == $PROGRAM_NAME

Game.new.play 



end