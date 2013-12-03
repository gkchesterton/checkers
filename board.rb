require_relative 'piece'

class Board

	def initialize
		@grid = Array.new (10) {Array.new(10) { nil } }
		@black_count = 20
		@red_count = 20
		setup_grid
	end

	def [](pos) 
		y, x = pos
		@grid[y][x]
	end

	def []=(pos, value)
		y, x = pos
		@grid[y][x] = value
	end

	def dup
		dup_board = Board.new
		@grid.each_with_index do |row, row_index|
			row.each_index do |col_index|
				if @grid[row_index][col_index].nil?
					dup_board[[row_index, col_index]] = nil
				else
					dup_board[[row_index, col_index]] = @grid[row_index][col_index].dup(dup_board)
				end
			end
		end
		dup_board
	end

	def over?
		true if @black_count == 0 || @red_count == 0
	end

	def setup_grid
		black = (0..3).to_a
		red = (6..9).to_a
		setup_side(black, :black)
		setup_side(red, :red)
	end

	def setup_side(side, color)
		side.to_a.each do |row|
			@grid[row].each_index do |col|
				unless (row.even? && col.even?) || (row.odd? && col.odd?)
					@grid[row][col] = Piece.new([row, col], color, self)
				end
			end
		end		
	end

	def to_s
		@grid.map do |row|
			row.map do |col| 
				if col.nil?
					" "
				else
					col 
				end
			end.join(" ")	+ "\n"
		end.join("") + "\n"
	end
end