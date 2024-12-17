#!/usr/bin/ruby
#Snippet: firewall-rule-generator.rb

#Main function: Parse logs and generate firewall rules
def parse_logs_and_generate_rules(log_file, threshold)
    ip_counts = Hash.new(0)
    File.foreach(log_file) do |line|
        if line =~ /(\d+\.\d+\.\d+\.\d+).*"(GET|POST|HEAD).*HTTP\/.*" (\d+)/
            ip, status = $1, $3.to_i
            ip_counts[ip] += 1 if status != 200
        end
    end
    blocked_ips=ip_counts.select{|ip, count|count>=threshold}.keys
    File.open("iptables_rules.sh", "w") do |iptables_file|
        blocked_ips.each{|ip|iptables_file.puts("iptables -A INPUT -s #{ip} -j DROP")}
    end
    File.open("ufw_rules.sh", "w") do |ufw_file|
        blocked_ips.each{|ip|ufw_file.puts("ufw deny from #{ip}")}
    end
    puts "[*] Top 3 IPTables Rules:"
    blocked_ips.take(3).each{|ip|puts "iptables -A INPUT -s #{ip} -j DROP"}
    puts "\n[*] Top 3 UFW Rules:"
    blocked_ips.take(3).each{|ip|puts "ufw deny from #{ip}"}
    puts "\n[*] Firewall rules saved to iptables_rules.sh and ufw_rules.sh"
end

#Defaults and user input
log_file = ARGV[0]||"access.log"	#Default log file path
threshold = (ARGV[1]||5).to_i     	#Default error threshold for blocking
if File.exist?(log_file)
    puts "[*] Parsing #{log_file} and generating firewall rules..."
    parse_logs_and_generate_rules(log_file, threshold)
else
    puts "[!] Log file not found: #{log_file}"
end
