module Ndice
  module Modules
    module Dice

      #ダイスクラス
      # #roll => num D val の値を補正値を考慮して出す。 戻り値:ダイス結果(Integer Class)
      # @num => ダイス数(Integer Class)
      # @val => ダイス面の数(Integer Class)
      class DiceRoll
        attr_accessor :num, :val

        # 初期化メソッド
        def initialize(num, val)
          @num = num
          @val = val
        end

        # ダイス結果を配列で
        def roll
          buff = @num.times.map do |i|
            rand(1..@val)
          end
          DiceResponse.new(buff)
        end
      end
      
      #ダイス戻り値クラス
      class DiceResponse
        attr_reader :all
        def initialize(all)
          @all = all
        end

        #ダイス合計メソッド
        def ans
          all = 0
          @all.each do |item|
            all += item
          end
          all
        end

        #最大値
        def max
          @all.max
        end
        
        #最小値
        def min
          @all.min
        end
        
      end
    end
  end
end