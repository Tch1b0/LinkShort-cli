require "option_parser"
require "colorize"
require "linkshort"
require "./shorts"

# Version needs to be updated manually at the moment
version = "1.0.1"

linkshort = LinkShort::LinkShort.new
shorts = Shorts.new linkshort

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

  parser.on "-c DESTINATION", "--create=DESTINATION", "Create a new shortcut" do |destination|
    linker = linkshort.create(destination)
    shorts.current = linker
    shorts.append linker
    puts "Short: #{linker.short}"
    puts "Link: #{linker.shortcut_url}"
  end

  parser.on "-s", "--save", "Save the current/selected shortcut/link/token" do
    if !shorts.has_current?
      puts "No shortcut selected".colorize(:red)
    else
      shorts.save
    end
  end

  parser.on "-l SHORTCUT", "--load=SHORTCUT", "Load a link and its token by a shortcut" do |shortcut|
    if !shorts.select(shortcut)
      print "The shortcut ".colorize(:red)
      print shortcut.colorize(:blue)
      puts " wasn't found".colorize(:red)
    end
  end

  parser.on "-e DESTINATION", "--edit DESTINATION", "Edit the destination of the current shortcut" do |destination|
    if !shorts.has_current?
      puts "No shortcut loaded".colorize(:red)
    elsif !shorts.current.original?
      puts "You don't have the permission to edit the shortcut"
    else
      shorts.current.edit destination
      shorts.save
    end
  end

  parser.on "-d", "--delete", "Delete the current shortcut" do
    if !shorts.has_current?
      puts "No shortcut loaded".colorize(:red)
    elsif !shorts.current.original?
      puts "You don't have the permission to edit the shortcut"
    else
      shorts.remove shorts.current
      shorts.current.delete
      shorts.save
    end
  end

  parser.on "-?", "--show", "Show the attributes of the currently selected shortcut" do
    unless shorts.has_current?
      puts "Please use -? after you created or loaded a shortcut".colorize(:red)
    else
      linker = shorts.current
      puts "Short: #{linker.short}\nUrl: #{linker.shortcut_url}\nDestination: #{linker.destination}#{("\nToken: " + linker.token) if linker.original?}".colorize(:blue)
    end
  end

  parser.invalid_option do |op|
    STDERR.print "Error: ".colorize(:red)
    STDERR.puts "Invalid option: #{op}"
    exit(1)
  end
end
