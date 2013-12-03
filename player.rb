class Player
	attr_reader :name, :color

	def initialize(name, color)
		@name = name
		@color = color
	end

	def get_move
		puts "#{name}, please enter a slide, jump or jump sequence: "
		move = gets.chomp
		sequence = move.split(" ").map { |coord_pair| coord_pair.split(",") }
		sequence.map do |coord_pair|
			coord_pair.map do |coord|
				coord.to_i
			end
		end
	end
end