#!/usr/bin/ruby
#Snippet: port-scan.rb
require 'socket'

#Main function: scan ports and grab banners
def port_scan(target, ports)
    ports.each do |port|
        begin
            #Connect to the target host and port with a given timeout
            socket = Socket.tcp(target, port, connect_timeout: 2)
            #Send a basic request and read the response
            socket.puts "HELLO"
            banner = socket.gets || "No banner received"
            puts "[*] Port #{port} is open - Banner: #{banner.strip}"
            socket.close
        rescue Errno::ECONNREFUSED
            puts "[*] Port #{port} is closed."
        rescue Errno::ETIMEDOUT
            puts "[*] Port #{port} timed out."
        rescue => e
            puts "[*] Error on port #{port}: #{e.message}"
        end
    end
end

#Read arguments or set defaults
target = ARGV[0] || "127.0.0.1"                         #Target host
ports = (ARGV[1] || "22,80,443").split(",").map(&:to_i) #Ports

#Call the main function
puts "[*] Scanning #{target} on ports #{ports.join(', ')}"
port_scan(target, ports)