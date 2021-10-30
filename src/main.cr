require "option_parser"
require "./Linker"
require "colorize"

# Version needs to be updated manually at the moment
version = "1.0.0"

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
    puts "Short: #{linker.create(link)}"
    puts "Link: #{linker.url}/#{linker.short}"
  end

  parser.on "-s", "--save", "Save the current/selected shortcut/link/token" do
    if linker.empty?
      puts "No shortcut selected".colorize(:red)
    else
      linker.save
    end
  end

  parser.on "-l SHORTCUT", "--load=SHORTCUT", "Load a link and its token by a shortcut" do |shortcut|
    unless linker.load(shortcut)
      print "The shortcut ".colorize(:red)
      print shortcut.colorize(:blue)
      puts " wasn't found".colorize(:red)
    end
  end

  parser.on "-?", "--show", "Show the attributes of the currently selected shortcut" do
    if linker.empty?
      puts "Please use -? after you created or loaded a shortcut".colorize(:red)
    else
      puts linker.to_pretty_s
    end
  end

  parser.invalid_option do |op|
    STDERR.print "Error: ".colorize(:red)
    STDERR.puts "Invalid option: #{op}"
    exit(1)
  end
end
