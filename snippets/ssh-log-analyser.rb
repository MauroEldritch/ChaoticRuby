#!/usr/bin/ruby
#Snippet: ssh-log-analyzer.rb

#Main function: Parse SSH log entries
def analyze_ssh_logs(file_path)
    activity = Hash.new{|h, k|h[k]={accepted: 0, preauth_closed: 0, postauth_closed: 0}}
    File.foreach(file_path) do |line|
        case line
        when /Accepted publickey for .* from (\d+\.\d+\.\d+\.\d+)/
            activity[$1][:accepted] += 1
        when /Connection closed by (\d+\.\d+\.\d+\.\d+)/
            activity[$1][:preauth_closed] += 1
        when /Received disconnect from (\d+\.\d+\.\d+\.\d+)/
            activity[$1][:postauth_closed] += 1
        end
    end
    puts "[>] Successful Logins:"
    activity.each{|ip, stats|puts "    #{ip}: #{stats[:accepted]} logins" if stats[:accepted] > 0}
    puts "\n[>] Pre-Auth Disconnections:"
    activity.each{|ip, stats|puts "    #{ip}: #{stats[:preauth_closed]} disconnections" if stats[:preauth_closed] > 0}
    puts "\n[>] Post-Auth Disconnections:"
    activity.each{|ip, stats|puts "    #{ip}: #{stats[:postauth_closed]} disconnections" if stats[:postauth_closed] > 0}
end

#Defaults and user input
file_path = ARGV[0]||"/var/log/auth.log"  #Default log file path
if File.exist?(file_path)
    puts "[*] Analyzing SSH logs from #{file_path}..."
    analyze_ssh_logs(file_path)
else
    puts "[!] Log file not found: #{file_path}"
end
