module Ndice
  #gem
  require 'yaml'
  #myself
  require_relative 'modules.rb'
  

  #コンフィグロード
  CONF = YAML.load_file("config.yml")
  TOKEN = CONF['token'].to_s
  CLIENT_ID = CONF['client'].to_i
  PREFIX = CONF['prefix'].to_s

  BOT = Discordrb::Commands::CommandBot.new(
    token: TOKEN,
    client_id: CLIENT_ID,
    prefix: PREFIX)
  
  require_relative 'commands.rb'

  BOT.run

end