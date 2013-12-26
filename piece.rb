#!/bin/env ruby
# encoding: utf-8
require 'debugger'

class Piece 
	attr_accessor :position, :promoted, :board 
	attr_reader :color

	DIFFS = [[-1, -1], [-1, 1], [1, -1], [1, 1]]

	def initialize(position, color, board)
		@board = board
		@position = position
		@color = color
		@promoted = false
	end

	def diffs
		if @promoted
			return DIFFS
		else 
			@color == :red ? DIFFS[0..1] : DIFFS[2..3]
		end
	end

	def dup(new_board)
		piece = Piece.new(@position.dup, @color, new_board)
		piece.promoted = @promoted
		piece
	end

	def out_of_bounds?(pos)
		y, x = pos
		!y.between?(0, 9) || !x.between?(0, 9)
	end

	def perform_jump(pos)
		jump = possible_jumps.select { |coords| coords[1] == pos }
		if !jump.empty?
			jumped_space = jump[0][0]
			@board[@position] = nil
			@board[pos] = self
			@board[jumped_space] = nil
			@position = pos
			@promoted = promote? unless @promoted == true
			if @color == :red
				@board.red_count -= 1
			else
				@board.black_count -= 1
			end
		else
			raise InvalidMoveError, "Invalid move!"
		end
	end

	def perform_moves(move_sequence)
		move_count = 0
		move_sequence.each do |move_pos|
			if move_count == 0
				begin
					perform_slide(move_pos) 
				rescue
					perform_jump(move_pos)
					move_count += 1
				end
			else	
				perform_jump(move_pos)
			end
			
		end
	end

	def perform_moves!(move_sequence)
		if valid_seq?(move_sequence)
			perform_moves(move_sequence)
		else
			raise InvalidMoveError, "Invalid move!"
		end
	end

	def perform_slide(pos)
		if possible_slides.include?(pos)
			@board[@position] = nil
			@board[pos] = self
			@position = pos
			@promoted = promote? unless @promoted == true
		else
			raise InvalidMoveError, "Invalid Move!"
		end
	end

	def possible_jumps
		jumps = []
		diffs.each do |diff|
			y, x = @position
			dy, dx = diff
			y += dy; x += dx;
			jumped_space = [y, x]
			y += dy; x += dx;
			landing_space = [y, x]
			next if out_of_bounds?(jumped_space)
			next if out_of_bounds?(landing_space)
			if (!self.board[jumped_space].nil? && 
					self.board[jumped_space].color != self.color) && self.board[landing_space].nil?
				jumps << [jumped_space, landing_space] 		
			end
		end
		jumps
	end

	def possible_slides
		possible_slides = []
		diffs.each do |diff|
			y, x = @position
			dy, dx = diff
			y += dy; x += dx;
			possible_slide = [y, x]
			next if out_of_bounds?(possible_slide)
			possible_slides << possible_slide if @board[possible_slide].nil?
		end
		possible_slides
	end

	def promote?
		if @color == :red
			@position[0] == 0
		elsif @color == :black
			@position[0] == 9
		end
	end

	def to_s
		if @promoted
			@color == :red ? "♚" : "♔"
		else
			@color == :red ? "☻" : "☺"
		end
	end

	def valid_seq?(move_sequence)
		dup_board = @board.dup
		begin
			dup_board[@position].perform_moves(move_sequence)
			return true
		rescue => error 
			p error.message
			return false
		end
	end

end