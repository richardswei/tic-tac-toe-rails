
class Board
	attr_accessor :board

	def initialize()
		@board = []
		9.times do |i|
			@board.push(Square.new(i))
		end
	end

	def show_values
		@board.each_with_index do |square, i|
			#  if value is nil show underscore for empty value
			value = square.get_value || "_"
			if (i+1)%3==0
				puts "| #{value} |"
			else 
				print "| #{value} |"
			end
		end
	end

	def show_available_positions
		@board.each_with_index do |square, i|
			# if value is not nil then show position
			position = square.get_value ? "_" : square.get_position
			if (i+1)%3==0
				puts "| #{position} |"
			else 
				print "| #{position} |"
			end
		end
	end

	def get_available_positions
		filtered_board = @board.filter do	|square|
			!square.get_value
		end
		filtered_board.map { |square|
			square.get_position.to_s
		}
	end

	def set_move(position, symbol)
		square = @board[position]
		square.set_value(symbol)
	end

end

class Square
	attr_accessor :position
	attr_accessor :value

	def initialize(position)
		@position = position 
		@value = nil
	end

	def get_position
		@position
	end
	
	def get_value
		@value
	end

	def set_value(symbol)
		@value = symbol
	end

end

# turn
def player_turn(current_board, symbol)
	puts ".",".","."
	puts "Player 1's turn. This is the current board"
	current_board.show_values
	puts "Select the position you want you place #{symbol}"
	current_board.show_available_positions
	position = prompt(current_board)
	current_board.set_move(position, symbol)
end


def prompt(board)
	position = gets.chomp
	if board.get_available_positions.include?(position)
		puts "position #{position} selected"
		return position.to_i
	else
		puts "position not available pick an available position"
		prompt(board)
	end
end


def check_for_win(current_board, symbol)
	win_conditions=[
		[0,1,2],
		[3,4,5],
		[6,7,8],
		[0,3,6],
		[1,4,7],
		[2,5,8],
		[0,4,8],
		[2,4,6],
	]
	# check for winning condidtions of the player that just went
	relevant_squares = current_board.show_values.map { |square, i|
		square.get_value==symbol ? square.get_position : nil 
	}

	for condition in win_conditions do
		if (condition - relevant_squares).empty?
			p "#{symbol} WINS!"
			return true
		end
	end
	return false
end


game = Board.new
puts "New Game Started"
game_is_over = false

while !game_is_over
	player_turn(game, "X")
	game_is_over = check_for_win(game, "X")
	break if game_is_over

	player_turn(game, "O")
	game_is_over = check_for_win(game, "O")
end






