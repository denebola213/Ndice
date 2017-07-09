module Ndice
  module Commands
    BOT.command :sw, help_available: true, description: "/h sw を参照してください"  do |event, arg|
      #argの処理
      if arg =~ /(\d+)[Dd]/ then
        num = $1.to_i
        plus = Ndice::Modules.plus_to_i(arg)
        
        #SwordWorldクラスの宣言
        sw_bot = Ndice::Modules::Dice::SwordWorld.new(num)

        #ダイスロール,結果出力
        roll = sw_bot.roll
        event << "#{event.user.name}さんの結果: #{roll.all} + #{plus}"
        event << " => #{roll.ans + plus}"
        
      elsif arg =~ /[kK](\d+)/ then
        #初期化
        cri = 10
        correction = 0
        cor_flg = false
        resist = false
        key = $1.to_i
        #補正値
        plus = Ndice::Modules.plus_to_i(arg)
        #クリティカル値
        cri = $1.to_i if arg =~ /@(\d+)/
        #出目補正
        if arg =~ /\$\+(\d+)/ then
          correction = $1.to_i
          cor_flg = false
        elsif arg =~ /\$(\d+)/ then
          correction = $1.to_i
          cor_flg = true
        end
        #抵抗半減
        resist = true if arg =~ /!$/

        #ロール
        sw_bot = Ndice::Modules::Dice::SwordWorld.new
        roll = sw_bot.damage_roll(
          key,
          cri: cri,
          plus: plus,
          correction: correction,
          cor_flg: cor_flg,
          resist: resist)
          
        event << "#{event.user.name}さんの結果: #{roll.all} + #{plus}"
        event << " =(damage)=> #{roll.damage}"

      else
        event << "ERROR:コマンドが有効ではありません"
        event << "/h sw を参照してください"
      end
      event << ""
    end
  end
  
end