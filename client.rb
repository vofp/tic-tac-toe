require 'socket'      # Sockets are in standard library

`git pull`

hostname = 'localhost'
port = 2000

s = TCPSocket.open(hostname, port)

data = s.gets.chop
while data != "EXT"
	a = data.split
	case a[0]
	when "PNT"
		puts a[1,a.size-1].join(" ")
	when "BRD"
		puts "#{a[1]}|#{a[2]}|#{a[3]}"
		puts "-----"
		puts "#{a[4]}|#{a[5]}|#{a[6]}"
		puts "-----"
		puts "#{a[7]}|#{a[8]}|#{a[9]}"
	when "REQ"
		puts "Where do you want to move"
		s.puts gets
	when "CLR"
		system("clear")
	end
	data = s.gets.chop
end


s.close               # Close the socket when done

