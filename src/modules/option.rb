## コマンド用モジュールメソッド

module Ndice
  module Modules
    class << self
      ##オプションをハッシュにして返す
      #引数:オプションと値 オプション複数可(Array => String)
      #戻り値:オプション名と値(hash) keyがALL=>オプション名一覧(Array) 
      def option(opt_array)
        opt_hash = Hash.new
        opt_name = Array.new
        each_flag = 0

        opt_array.each do |str|
          if str =~ /-(\w+)/u then
            #オプション名は配列へ
            opt_name << str
          else
            #値はハッシュへ
            opt_hash[opt_name.last.to_sym] = str
          end
        end
        
        #ハッシュにオプション名一覧を追加
        opt_hash[:ALL] = opt_name
        return opt_hash
      end

      #文字列から補正値を
      def plus_to_i(str)
        ans = 0
        #補正値(-)
        str.scan(/-(\d+)/).flatten.each do |val|
          ans -= val.to_i
        end
        #補正値(+)
        str.scan(/[^$]?\+(\d+)/).flatten.each do |val|
          ans += val.to_i
        end
        return ans
      end
    end
  end
end
