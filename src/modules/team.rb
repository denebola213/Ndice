module Ndice
  module Modules
    class Team
      def initialize
        @users = Array.new(0)
        @ch = nil	#コマンド入力したチャンネル
        @flg = 0		  #/team実行したかのフラグ
        @limit = nil     #人数制限の設定値
        @now = 0         #現在の人数
      end

      def reset
        initialize()
      end

      def choose_up
        
        half = (@users.length / 2).to_i
        
        #ランダムにuserclassを取り出す
        red_team = @users.sample(half)
        blue_team = @users.select do |user|
          !(red_team.include?(user))
        end

        Hash[red: red_team, blue: blue_team]
      end
      
      attr_accessor :users, :ch, :flg, :limit, :now
    end
  end
end



