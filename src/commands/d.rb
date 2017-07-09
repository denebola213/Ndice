module Ndice
  module Commands

    ## ダイスロールコマンド(/d)
    BOT.command :d, help_available: true, description: "/h d を参照してください"  do |event, *arg|
      #argの処理(xDyが含まれてる?)
      cmd_str = arg.first
      if cmd_str =~ /(\d+)[Dd](\d+)/u then
        num = $1.to_i
        val = $2.to_i
        plus = Ndice::Modules.plus_to_i(cmd_str)

        # diceのオブジェクト定義
        dice_bot  = Ndice::Modules::Dice::DiceRoll.new(num, val)

        # ダイスロール,結果出力
        roll = dice_bot.roll
        event << "#{event.user.name}さんの結果: #{roll.all} + #{plus}"
        event << " => #{roll.ans + plus}"

        # オプション処理
          #xDyを除いてオプションだけに
        arg.shift
        #Hashに
        opt_hash = Ndice::Modules.option(arg)
        opt_hash[:ALL].each do |opt|
          case opt
          # 最大値を表示
          when "-M" then
            event << "最大値: #{roll.max}"
          
          # 最小値を表示
          when "-m" then
            event << "最小値: #{roll.min}"
          end
        end
      else
        event << "ERROR:コマンドが有効ではありません"
        event << "/h d を参照してください"
      end
      event << ""
    end
  end
end