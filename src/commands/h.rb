module Ndice
  module Commands
    ##ヘルプコマンド(/h)
    BOT.command :h, help_available: true, description: "各コマンドのヘルプを表示します."  do |event, arg|
      
      prefix = BOT.prefix
      case arg
      #/h d
      when "d" then
        event << "ダイスを振るコマンドです。"
        event << "オプションで表示結果を選択できます。"
        event << ""
        event << "#{prefix}d (ダイス数)D(ダイス面)+(補正値) (オプション)"
        event << "ダイスを振ります。 例:#{prefix}sw 3D10+2 -M"
        event << ""
        event << " -M : ダイス目の最大値を表示します"
        event << " -m : ダイス目の最小値を表示します"
        
      #/h sw
      when "sw" then
        event << "ソード・ワールド用のダイスです。"
        event << "通常の6面ダイスと威力表に対応しています"
        event << ""
        event << "#{prefix}sw (ダイス数)D+(補正値)"
        event << "6面ダイスを振ります。 例:#{prefix}sw 2D+2"
        event << ""
        event << "#{prefix}sw K(威力)+(ボーナス)@(クリティカル)$(出目修正)"
        event << "威力表を振ります。 例:#{prefix}sw K22+4-2@11$12"

      #/h dx
      when "dx" then
        event << "ダブルクロス用のダイスです。"
        event << "DX独自のクリティカルに対応した10面ダイスが振れます。"
        event << ""
        event << "#{prefix}dx (ダイス数)DX+(補正値)@(クリティカル)"
        event << "クリティカル処理する10面ダイスを振ります。"
        event << "例:#{prefix}dx 5dx+24@8"
        
      #/h kino
      when "kino" then
        event << "キノの旅の各話のタイトルとサブタイトルを検索するコマンドです。"
        event << "#{prefix}kino 巻数"
        event << "指定した巻の情報を表示します 例:#{prefix}kino 8"
        
      when "team","team_end" then
        event << "登録したユーザーを2チームに分けます。"
        event << "#{prefix}team を実行した後、参加するユーザーは entry と入力してください。"
        event << "#{prefix}team_end で参加を締め切り、チームを割り振ります。"
        event << "#{prefix}team (人数)"
        event << "人数制限を設け、人数を満たした段階でチーム分けを行います。"
        event << "例:#{prefix}team 6"

      when "kyuko" then
		    event << "その日の休講情報を出力します。"
        event << "#{prefix}kyuko (option)"
        event << "オプションなし : 今日と明日の情報"
        event << "week : 一週間の情報"
        event << "year/month/day : 指定日の情報"
        
        
      else
        event << "#{prefix}h [知りたいコマンド名] と入力してください。"
        event << "-- Command List --"
        event << "d, sw, dx, kino, team, team_end"
        event << "# developer only #"
        event << "stop"
        
      end
      
      event << ""
      event << "フィードバックや不具合報告は @denebola213 まで"
    end
    
  end
end