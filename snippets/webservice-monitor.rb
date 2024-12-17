#!/usr/bin/ruby
#Snippet: webservice-monitor.rb
require 'net/http'
require 'digest'

#Main function: Monitor webservice availability and integrity
def monitor_webservice(url, expected_hash = nil)
    loop do
    begin
        response = Net::HTTP.get_response(URI(url))
        if response.is_a?(Net::HTTPSuccess)
            content = response.body
            hash = Digest::SHA256.hexdigest(content)
            if expected_hash
                if hash == expected_hash
                    puts "[*] Integrity passed for #{url}."
                else
                    puts "[!] Integrity failed with hash: #{hash}"
                    break
                end
            else
                puts "[*] Obtained hash #{hash} for #{url}."
                expected_hash = hash
            end
        else
            puts "[!] Failed to fetch #{url}: #{response.code}"
        end
    rescue => e
        puts "[!] Error accessing #{url}: #{e.message}"
    end
    puts "[*] Retrying in 60 seconds..."
    sleep(60)
    end
end

#Defaults and user input
url = ARGV[0] || "http://example.com"   #Default URL
expected_hash = ARGV[1]                 #Optional expected hash
puts "[*] Monitoring #{url}..."
monitor_webservice(url, expected_hash)
