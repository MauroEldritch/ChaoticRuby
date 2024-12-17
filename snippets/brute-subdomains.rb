#!/usr/bin/ruby
#Snippet: brute-subdomains.rb
require 'net/http'
require 'socket'

target = ARGV[0] || "example.com"
subs_file = ARGV[1] || "subdomains.txt"
dirs_file = ARGV[2] || "directories.txt"
subdomains = File.exist?(subs_file) ? File.readlines(subs_file, chomp: true) : ["www", "mail"]
directories = File.exist?(dirs_file) ? File.readlines(dirs_file, chomp: true) : ["login", "admin"]

puts "[*] Brute-forcing #{target}..."
subdomains.each do |sub|
    domain = "#{sub}.#{target}"
    begin
        Addrinfo.getaddrinfo(domain, nil)
        puts "[*] Subdomain: #{domain}"
        ["http", "https"].each do |protocol|
            directories.each do |dir|
                url = "#{protocol}://#{domain}/#{dir}"
                begin
                    res = Net::HTTP.get_response(URI(url))
                    puts "   [*] Found: #{url}" if res.code.to_i == 200
                rescue
                    nil
                end
            end
        end
    rescue SocketError
        nil
    end
end
