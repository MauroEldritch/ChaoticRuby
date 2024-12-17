#!/usr/bin/ruby
#Snippet: reverse-proxy.rb
require 'socket'

#Main function: raise a reverse proxy
def reverse_proxy(port, log_file)
    server = TCPServer.new(port)
    puts "[*] Proxy listening on port #{port}..."
    loop do
        client = server.accept
        request = client.readpartial(1024) rescue ""
        host, dest_port = request[/Host:\s+(.+)/, 1]&.split(":")
        next client.close unless host
        backend = TCPSocket.new(host, (dest_port || 80).to_i)
        backend.write(request)
        response = backend.read
        client.write(response)
        log_traffic(request, response, log_file)
        client.close
        backend.close
    end
end
def log_traffic(request, response, log_file)
    File.open(log_file, "a") do |f|
        f.puts("[#{Time.now}] REQUEST:\n#{request}\nRESPONSE:\n#{response}\n---")
    end
end
reverse_proxy((ARGV[0] || 8080).to_i, ARGV[1] || "proxy.log")
