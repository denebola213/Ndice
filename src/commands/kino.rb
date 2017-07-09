module Ndice
  module Commands
    BOT.command :kino, help_available: true, description: "/h kino を参照してください"  do |event, arg|
      kino = YAML.load_file("./src/commands/kino.yml")
      
      message = ""
      
      kino.each do |item|
        if item["vol"].to_s == arg then
          episode = item["episode"]
          title = item["title"]
          subtitle = item["subtitle"]
          
          event << " episode.#{episode} 「#{title}」-#{subtitle}-\n"
        end
      end
      
      event << "- END -"
    end
  end
end