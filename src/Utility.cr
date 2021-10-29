macro define_version_parser
    def parse_version
        content = File.read("shard.yml").split
        content.each_index do |index|
            if content[index] == "version:"
                return content[ index +1]
            end
        end

        return "?.?.?"
    end
end

define_version_parser 