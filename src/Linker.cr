require "http/client"
require "http/headers"
require "json"
require "colorize"

class Linker
    @link : String = ""
    @short : String = ""
    @token : String = ""
    @url : String = "https://ls.johannespour.de"

    def to_s : String
        "<short: #{@short}, link: #{@link}, token: #{@token}>"
    end

    # Returns a formatted version of this object (including the token) 
    def to_pretty_s : Colorize::Object(String)
        "Short: #{@short}\nLink: #{@link}#{("\nToken: "+@token) if original?}".colorize(:blue)
    end

    def create(link) : Bool|String
        body = {
            "link": link
        }
        content_type = HTTP::Headers.new.add "Content-type", "application/json"
        res = HTTP::Client.post "#{@url}/create", body: body.to_json, headers: content_type 

        body = JSON.parse res.body
        @short = body["short"].to_s
        return false if @short == nil

        @link = link
        begin
            @token = body["token"].to_s
        rescue
            # Here: Token is an empty string
        end
        @short
    end
    
    def save
        data = {
            "link" => JSON::Any.new(@link),
            "token" => JSON::Any.new(@token)
        }

        begin
            file_content = JSON.parse(File.read("./shorts.json")).as_h
        rescue
            File.write("./shorts.json", "{}")
            file_content = JSON.parse(File.read("./shorts.json")).as_h
        end
        
        file_content[@short] = JSON::Any.new data
        File.write("./shorts.json", file_content.to_pretty_json)
    end

    def load(shortcut) : Bool
        begin
            file_content = JSON.parse(File.read("./shorts.json"))
            info = file_content[shortcut]
        rescue
            return false
        end

        @short = shortcut
        @token = info["token"].to_s
        @link = info["link"].to_s
        
        true
    end

    def original? : Bool
        @token.size > 0
    end

    def empty? : Bool
        @link.empty? && @short.empty? && @token.empty?
    end

    def url : String
        @url
    end

    def short : String
        @short
    end

    def link : String
        @link
    end
end