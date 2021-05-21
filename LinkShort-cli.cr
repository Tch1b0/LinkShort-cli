require "option_parser"
require "./Linker"
require "colorize"

version = 0.1
linker = Linker.new

OptionParser.parse do |parser|
    parser.banner = "Welcome to the LinkShort-cli!"

    parser.on "-v", "--version", "Show version" do
        puts "version #{version}"
        exit
    end

    parser.on "-h", "--help", "Show help" do
        puts parser
        exit
    end

    parser.on "-c LINK", "--create=LINK", "Create a new shortcut" do |link|
        puts "Short: #{linker.short(link)}"
        puts "Link: #{linker.url}/#{linker.short}"
    end

    parser.on "-s", "--save", "Save the current/selected shortcut/link/token" do
        if linker.empty?
            puts "No shortcut selected".colorize(:red) 
        else
            linker.save
        end
    end

end