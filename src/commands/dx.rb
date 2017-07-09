module Ndice
  module Commands

    ## それは裏切りを意味するコマンド(/dx)
    BOT.command :dx, help_available: true, description: "/h d を参照してください"  do |event, arg|
      #argの処理(xDyが含まれてる?)
      if arg =~ /(\d+)[Dd][Xx]/ then
        num = $1.to_i
        plus = Ndice::Modules.plus_to_i(arg)
        #クリティカル値
        cri = $1.to_i if arg =~ /@(\d+)/

        # dxオブジェクト定義
        dx_bot = Ndice::Modules::Dice::DoubleCross.new(num, cri)

        # ダイスロール,結果出力
        roll = dx_bot.roll
        event << "#{event.user.name}さんの結果:"
        roll.all.each_with_index do |vals, i|
          event << "#{i+1}. #{vals}"
        end
        event << " + #{plus} => #{roll.val + plus}"

      else
        event << "ERROR:コマンドが有効ではありません"
        event << "/h dx を参照してください"
      end
      event << ""
    end
  end
end