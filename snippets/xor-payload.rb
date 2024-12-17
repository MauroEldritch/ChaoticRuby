#!/usr/bin/ruby
#Snippet: xor-payload.rb

#Main function: XOR encoding/decoding
def xor(data, key)
    data.bytes.map.with_index { |byte, i| byte ^ key[i % key.size].ord }.pack('C*')
end
def generate_key(length = 4)
    Array.new(length) { rand(33..126).chr }.join # Random printable ASCII
end

#Defaults and user input
mode = ARGV[0] || "e"               #"e" for encode, "d" for decode
input = ARGV[1] || "Eldritch"       #Default payload
key = ARGV[2] || generate_key       #Default to a generated key

#Processing
if mode == "e"
    puts "[*] Encoding payload..."
    result = xor(input, key)
    puts "[*] Encoded payload: #{result.unpack1('H*')}"
    puts "[*] XOR Key: #{key}"
elsif mode == "d"
    puts "[*] Decoding payload..."
    result = xor([input].pack('H*'), key)
    puts "[*] Decoded payload: #{result}"
end
