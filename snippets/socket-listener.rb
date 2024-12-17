#!/usr/bin/ruby
#Snippet: socket-listener.rb
require 'socket'

#Main function: start a listener on the specified port and protocol
def start_listener(port, protocol)
    if protocol.downcase == "tcp"
        server = TCPServer.new(port)
        puts "[*] Listening for TCP connections on port #{port}..."
        loop do
            client = server.accept
            puts "[*] Connection received from #{client.peeraddr[3]}"
            message = client.gets
            puts "[*] Message: #{message.strip}" if message
            client.puts "Echo: #{message}" if message
            client.close
        end
    elsif protocol.downcase == "udp"
        server = UDPSocket.new
        server.bind("0.0.0.0", port)
        puts "[*] Listening for UDP packets on port #{port}..."
        loop do
            message, addr = server.recvfrom(1024)
            puts "[*] Packet received from #{addr[3]}:#{addr[1]}"
            puts "[*] Message: #{message.strip}"
            server.send("Echo: #{message}", 0, addr[3], addr[1])
        end
    else
        puts "[!] Unsupported protocol. Use TCP or UDP."
    end
end

#Read arguments or set defaults
port = (ARGV[0] || 8080).to_i   #Port to listen on
protocol = ARGV[1] || "tcp"     #Protocol to use (tcp or udp)

#Call the main function
start_listener(port, protocol)
