#!/usr/bin/ruby
#Snippet: ioc-extractor.rb
require 'set'

#Main function: extract IOCs
def extract_iocs(file)
    iocs = {
        ip: /\b(?:\d{1,3}\.){3}\d{1,3}\b/,
        domain: /\b[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}\b/,
        email: /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b/,
        hash: /\b[a-fA-F0-9]{32,64}\b/,
        url: %r{\bhttps?://[^\s]+\b}
    }
    results = Hash.new { |h, k| h[k] = Set.new }
    File.foreach(file) do |line|
        iocs.each { |type, regex| results[type].merge(line.scan(regex)) }
    end
    results
end
def print_iocs(results)
    results.each do |type, matches|
        puts "[*] #{type.capitalize}s Found (#{matches.size}):"
        matches.each { |match| puts "  - #{match}" }
    end
end
#Defaults and user input
file = ARGV[0] || "log.txt"
puts "[*] Extracting IOCs from #{file}..."
print_iocs(extract_iocs(file))
