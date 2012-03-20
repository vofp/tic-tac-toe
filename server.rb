require 'socket'                # Get sockets from stdlib
require 'matrix'

def clients_puts(message)
	@client[0].puts message
	@client[1].puts message
end

def clients_board
	str = ""
	(0..2).each{ |i|
		(0..2).each{ |j|
			str += "#{@board[i][j]} "
		}
	}
	return str
end

def check_board
	@mat = Matrix.rows(@board)
	(0..2).each{|r|
		if @mat.row(r) == Vector['o','o','o']
			return 'o'
		elsif @mat.row(r) == Vector['x','x','x']
			return 'x'
		end
	}
	(0..2).each{|c|
		if @mat.column(c) == Vector['o','o','o']
			return 'o'
		elsif @mat.column(c) == Vector['x','x','x']
			return 'x'
		end
	}
	
	if [@mat[0,0], @mat[1,1], @mat[2,2]] == ['o','o','o']
		return 'o'
	elsif [@mat[0,0], @mat[1,1], @mat[2,2]] == ['x','x','x']
		return 'x'
	end

	if [@mat[0,2], @mat[1,1], @mat[2,0]] == ['o','o','o']
		return 'o'
	elsif [@mat[0,2], @mat[1,1], @mat[2,0]] == ['x','x','x']
		return 'x'
	end
	
	return 'c'
end

def request_move(player)
	client_number = player == 'o' ? 0 : 1
	@client[client_number].puts "REQ"
	return @client[client_number].gets
end

def change_board(player, spot)
	spot -= 1
	@board[spot/3][ spot%3] = player
end

@board = [[1,2,3],[4,5,6],[7,8,9]]
@client = []
server = TCPServer.open(2000)  # Socket to listen on port 2000
@client[0] = server.accept
@client[0].puts "PNT Hello Player o"
@client[1] = server.accept
@client[1].puts "PNT Hello Player x"
clients_puts "PNT Alright both players connected"
turn_player = 'o'
(1..9).each{ |turn_number|
	clients_puts "CLR"
	clients_puts "PNT Turn #{turn_number}: Player #{turn_player}"
	clients_puts "BRD #{clients_board}"
	change_board turn_player, (request_move turn_player).to_i
	if check_board != 'c'
		break
	end
	turn_player = turn_player == 'o' ? 'x' : 'o'
}

clients_puts "CLR"
clients_puts "BRD #{clients_board}"
clients_puts "PNT Winner: #{check_board}"
clients_puts "EXT"
@client[0].close                 # Disconnect from the client
@client[1].close                 # Disconnect from the client

