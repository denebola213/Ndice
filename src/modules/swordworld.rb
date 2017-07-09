require 'csv'
module Ndice
  module Modules
    module Dice
      require_relative 'diceroll.rb'
      
      #ソードワールドクラス(DiceClass継承)
      # #roll => num D6 の値をクリティカルを考慮して出す。 戻り値:ダイス結果(Integer Class)
      # @num => ダイス数(Integer Class)
      # @val => ダイス面の数(Integer Class)
      class SwordWorld < DiceRoll
        # Swクラスからvalアクセッサを呼び出せなくする
        undef_method :val

        #初期化メソッド
        def initialize(num = 2)
          @num = num
          @val = 6
        end

        # ダメージロール
        def damage_roll(key, cri: 10, plus: 0, correction: 0, cor_flg: false, resist: false)
          vals = Array.new

          #出目修正
          if cor_flg == true then
            #出目指定
            dice_val = correction
          else
            #出目追加
            dice_val = self.roll.ans + correction
            dice_val = 12 if dice_val > 12
          end

          #クリティカルがなくなるまで回す
          loop do
            vals << dice_val
            if dice_val < cri
              break
            end
            dice_val = self.roll.ans
          end

          damage = 0
          vals.each do |val|
            damage += Damage.iryoku_val(key, val)
          end
          
          #補正値を足す
          damage += plus
          
          #精神抵抗半減
          if resist == true
            if damage % 2 == 0 then
              damage /= 2
            else
              damage /= 2
              damage += 1
            end
          end
          
          SwResponse.new(vals, damage)
        end
        
        #自動成功、自動失敗の情報を含んだダイス結果
        class SwResponse < DiceResponse
          attr_reader :all, :damage
          def initialize(all, damage)
            @all = all
            @damage = damage
          end

        end
        
      end
      
      #威力表参照クラス
      class Damage

        #キーから該当する威力表の配列を返す(クラスメソッド)
        def iryoku_key(key)
          @iryoku_table[key].flatten.map do |val|
            val.to_i
          end
        end
        
        #キーとダイス結果から威力を返す(クラスメソッド)
        def self.iryoku_val(key, dice_val)
          @iryoku_table = CSV.read('./src/modules/iryoku.csv')

          if dice_val > 12 then
            nil
          elsif dice_val < 3 then
            0
          else
            val_all = @iryoku_table[key].map do |val|
              val.to_i
            end
            val_all[dice_val - 3]
          end
        end

        private :iryoku_key
      end
    end
  end
end