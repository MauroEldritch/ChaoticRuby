#!/usr/bin/ruby
#Snippet: web-fingerprinting.rb
require 'net/http'
require 'uri'
KNOWN_JS_LIBRARIES = ['jquery', 'react', 'vue', 'angular', 'bootstrap.min', 'ether', 'chart', 'chartjs', 'd3', 'moment']

#Main function: Fingerprint a web server and find JS libraries
def fingerprint_web(url)
    begin
        uri = URI(url)
        response = Net::HTTP.get_response(uri)
        puts "[*] HTTP Status: #{response.code} #{response.message}"
        server = response['server']
        x_powered_by = response['x-powered-by']
        x_served_by = response['x-served-by']
        puts "[*] Fingerprinting Results:"
        puts "  Server: #{server}" if server
        puts "  X-Powered-By: #{x_powered_by}" if x_powered_by
        puts "  X-Served-By: #{x_served_by}" if x_served_by
        find_js_libraries(response.body) if response.is_a?(Net::HTTPSuccess)
    rescue => e
        puts "[!] Error: #{e.message}"
    end
end

#Function to find JS libraries
def find_js_libraries(html)
    found_libraries = KNOWN_JS_LIBRARIES.select { |lib| html.include?("#{lib}.js") }
    puts found_libraries.empty? ? "[*] No known JavaScript libraries detected." : "[*] Detected JavaScript libraries: #{found_libraries.join(', ')}"
end

#Defaults and user input
url = ARGV[0] || "http://example.com" #Default URL
puts "[*] Fingerprinting #{url}..."
fingerprint_web(url)
