require "open-uri"
require "nokogiri"

new_entries = []

("A".."Z").to_a.each do |letter|
    1.upto(100) do |page|
        uri = "https://signdict.org/entry?letter=#{letter}&page=#{page}"
        open(uri) do |page|
            content = page.read
            new_entries = content.scan(/"so-search-result--link" href="\/entry\/(\d+)-[^"]+">([^<]+)</)

            new_entries.each do |id, meaning|
                uri = "https://signdict.org/entry/#{id}"
                open(uri) do |page2|
                    content = page2.read

                    n = Nokogiri::HTML(content)
                    meaning = n.css(".so-video-details--headline").text
                    note = n.css(".so-video-details--headline + p").text
                    variants = n.css(".sc-sidebar .so-video-list--item--thumbnail a")
                    variants.each do |v|
                        video = v["href"]
                        puts "#{video}\t#{meaning}\t#{note}"
                        STDOUT.flush
                    end
                end
            end
        end
        break if new_entries.empty?
    end
end
