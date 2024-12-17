#!/usr/bin/ruby
#Snippet: brute-dict.rb

#Main function: generate a dictionary
def generate_dictionary(characters, length, output_file)
    #Permutate charset
    dict = characters.chars.repeated_permutation(length).map(&:join)
    #Write combinations
    File.open(output_file, "w") do |file|
        dict.each { |entry| file.puts(entry) }
    end
    #Output
    puts "[*] Dictionary: #{output_file}\n[*] Combinations: #{dict.size}."
end

#Read arguments or set defaults
output_file = ARGV[0] || "brute.txt"    #Output file name
length = (ARGV[1] || 4).to_i            #Max length of every combination
characters = ARGV[2] || "abc123?"       #Characters to use

#Call the main function
generate_dictionary(characters, length, output_file)
