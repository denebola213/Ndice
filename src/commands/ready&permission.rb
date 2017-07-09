module Ndice
	module Commands
		BOT.ready do |event|

			puts "config loading ..."
			
			##コンフィグをもとに権限を設定
			#botがデプロイされているサーバクラスを取得
			BOT.servers.each_value do |ser|
				#サーバクラスからロールクラス取得
				ser.users.each do |user|
					#コンフィグと比較
					CONF['role_username'].each do |pms|
						if pms['name'].to_s == user.name then
							event.bot.set_user_permission(user.id, pms['num'].to_i)
						end
					end
				end
			end
		
			puts "Start Ndice!"
		end
	end
end

