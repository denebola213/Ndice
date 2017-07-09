module Ndice
	module Commands
		##チーム振り分けコマンド
		team = Ndice::Modules::Team.new

		#エントリー開始コマンド
		BOT.command :team, help_available: true, description: "/h team を参照してください"  do |event, arg|
			if team.flg == 0 then
				if arg == nil 
					team.limit = nil
				else
					team.limit = arg.to_i
				end
				
				team.flg = 1
				team.ch = event.channel
				event << "entry とコメントしてください。"
			else
				event << "実行中"
			end
		end
		#エントリー読み取り
		BOT.message content: "entry", in: team.ch do |event|
			if team.flg == 1 && !(team.users.include?(event.user))
				team.users << event.user
				team.now += 1
				if team.limit != nil
					if team.now >= team.limit
						event << "人数が集まったため、締め切り"
						event << ""
						choose_ans = team.choose_up

						#メッセージput
						event << "- Red Team -"
						choose_ans[:red].each do |user|
							event << user.username
						end
						event << ""
						event << "- Blue Team -"
						choose_ans[:blue].each do |user|
							event << user.username
						end
						event << ""
						team.reset
					end
				end
				
			end
		end
		#エントリー終了コマンド
		BOT.command :team_end, help_available: true, description: "/h team_end を参照してください"  do |event, arg|
			if team.flg == 1 then
				choose_ans = team.choose_up
				#メッセージput
				event << "- Red Team -"
				choose_ans[:red].each do |user|
					event << user.username
				end
				event << ""
				event << "- Blue Team -"
				choose_ans[:blue].each do |user|
					event << user.username
				end
				team.reset
			else
				event << "/team を実行してください"
			end

			event << ""
		end
	end
end
