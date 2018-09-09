require "json"
require "digest"

hash = JSON.load(File.read("German_Sign_Language/German_Sign_Language.json"))

hash["notes"] = []

IO.readlines("entries").each do |line|
    video, meaning, note = line.chomp.split("\t")

    video.gsub!("entry", "embed")
    video = "https://signdict.org"+video

    recording_id = video.scan(/video\/(\d+)/)[0][0]

    entry = {
        "__type__" => "Note",
        "data" => "",
        "fields" => [
            meaning,
            note,
            video
        ],
        "flags" => 0,
        "guid" => Digest::SHA1.hexdigest(recording_id)[8..16],
        "note_model_uuid" => "1c00f1a4-b468-11e8-9e8e-448500519c3a",
        "tags" => []
    }


    hash["notes"] << entry
end


json = JSON.pretty_generate(hash)
json.gsub!("  ", "    ")
json.gsub!(/,$/, ", ")
json.gsub!(/\[\s+\]/, "[]")

IO.write("German_Sign_Language/German_Sign_Language.json", json)
