module Ndice
  #終了コマンド(/stop)
  BOT.command :stop, help_available: false  do |event|
	  BOT.stop
  end
end