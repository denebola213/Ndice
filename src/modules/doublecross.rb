module Ndice
  module Modules
    module Dice
      require_relative 'diceroll.rb'

      class DoubleCross < DiceRoll
        def initialize(num, cri = 10)
          @num = num
          @val = 10
          @cri = cri
        end

        def roll
          roll_val = 0
          roll_all = Array.new

          loop do
            #ダイス振って
            roll_all << super.all

            #クリティカルチェック
            @num = roll_all.last.count do |item| item >= @cri end

            if @num == 0 then
              roll_val += roll_all.last.max
              break
            else
              roll_val += 10
            end
            
          end

          return DxResponse.new(roll_all, roll_val)
        end
      end

      class DxResponse
        attr_reader :all, :val

        def initialize(all, val)
          @all = all
          @val = val
        end
      end
      
    end
    
  end
  
end