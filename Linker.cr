require "http/client"
require "http/headers"
require "json"
require "colorize"

class Linker
    @link = ""
    @short = ""
    @token = ""
    @url = "https://ls.johannespour.de"

    def short(link)
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
            puts "Tokens are currently unavailable on the LinkShort server.".colorize(:red)
        end
        @short
    end
    
    def save
        data = {
            "link" => @link,
            "token" => @token
        }.to_json
        begin
            file_content = JSON.parse(File.read("./shorts.json")).as_h
        rescue
            File.write("./shorts.json", "{}")
            file_content = JSON.parse(File.read("./shorts.json")).as_h
        end
        file_content[@short] = JSON::Any.new(data)
        File.write("./shorts.json", file_content.to_pretty_json)
    end

    def empty?
        @link.empty? && @short.empty? && @token.empty?
    end

    def url
        @url
    end

    def short
        @short
    end
end