#!/usr/bin/ruby
#Snippet: brute-refined.rb

#Main function: Generate all possible combinations
def generate_combinations(data)
    combinations=[]
    data.each do|item1|
        data.each do|item2|
            next if item1==item2	#Skip if the items are identical
            combinations<<"#{item1}#{item2}"
        end
    end
    combinations.uniq
end

#Read user input or use default data
input_data=(ARGV[0]||"Mauro,2024,Leopoldo,Uruguay").split(',')

#Generate and display combinations
puts "[*] Generating combinations..."
combinations=generate_combinations(input_data)
puts "[*] Total combinations: #{combinations.size}"
combinations.take(3).each{|combo|puts combo}
puts "[...]"

#Save to file
File.open("refined_dictionary.txt",'w') { |file|
	combinations.each { |combo|
		file.puts(combo)
	}
}
puts "[*] Dictionary saved to refined_dictionary.txt"
