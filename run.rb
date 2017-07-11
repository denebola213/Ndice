#! ruby -Ku

#----- Ndice -----#
# Discordにダイス機能やその他便利機能、ネタを追加するbotです
# produced by Tak2580, denebola213

::RBNACL_LIBSODIUM_GEM_LIB_PATH = 'libsodium.dll'
require 'bundler'
Bundler.require
require_relative 'src/bot.rb'