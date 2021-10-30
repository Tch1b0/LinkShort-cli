require "linkshort"

class Shorts
  @linkers = [] of LinkShort::Linker
  @current : LinkShort::Linker

  getter :linkers
  getter :current
  setter :current

  def initialize(@linkshort : LinkShort::LinkShort = LinkShort::LinkShort.new)
    @current = LinkShort::Linker.new "", "", "", @linkshort
    load
  end

  def append(linker : LinkShort::Linker)
    @linkers << linker
  end

  def remove(linker : LinkShort::Linker)
    @linkers.delete linker
  end

  def select(short : String) : LinkShort::Linker | Bool
    val = @linkers.select! { |linker| linker.short == short }
    if val.size > 0
      @current = val[0]
      return val[0]
    else
      return false
    end
  end

  def has_current? : Bool
    @current.active?
  end

  def load(linkshort : LinkShort::LinkShort = LinkShort::LinkShort.new)
    begin
      content = JSON.parse(File.read("shorts.json")).as_a
      @linkers = [] of LinkShort::Linker
    rescue
      return
    end

    content.each do |data|
      @linkers << LinkShort::Linker.from_h data.as_h, linkshort.base_uri, @linkshort
    end
  end

  def save
    content = JSON.build do |json|
      json.array do
        @linkers.each do |linker|
          json.object do
            json.field "short", linker.short
            json.field "token", linker.token
            json.field "destination", linker.destination
            json.field "uri", linker.uri
          end
        end
      end
    end

    File.write("shorts.json", content)
  end
end
