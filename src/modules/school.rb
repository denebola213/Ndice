require 'open-uri'
require 'nokogiri'
require 'unicode'
require "date"

module Ndice
  module Modules
    module School

      # 休講情報関係
      class Kyuko
        attr_accessor :kyuko_data
        
        def initialize
          @kyuko_data = kyuko_load()
        end
        
        #休講情報をスクレイピング
        def kyuko_load
          #URL指定
          url = 'http://www.ibaraki-ct.ac.jp/?page_id=501'

          #Nokogiri::HTML::Document パース
          doc = Nokogiri::HTML(open(url))

          #結果を入れる変数と回数数えるフラグ
          kyuko = Array.new
          i = 0

          #情報が入ってるタグを回す
          doc.xpath("/html/body//div[@class='oshirase']/table/tr").each do |nodeset|
            #休講情報じゃなかったら飛ばす
            flag = nodeset.xpath("./td[@class='tbl_left']/a").text
            if flag !~ /休講情報/u
              next
            end
            
            #更新日に該当するStringを取得
            update = nodeset.xpath("./td[@class='tbl_left tbl_top']").text
            #正規表現で時間を抽出、Dateクラスへ変換
            update =~ /(\d{4})年(\d{,2})月(\d{,2})日/u
            update = Date.new($1.to_i, $2.to_i, $3.to_i)
            
            #/td[@class='tbl_left']内のデータをタグ付きで取得
            str = nodeset.xpath("./td[@class='tbl_left']").inner_html
            #整える
            str = Unicode::nfkc(str)
            str = str.gsub(/《/, "<<")
            str = str.gsub(/》/, ">>")
            str = str.gsub(/・/, ",")
            str = str.gsub(/●/, "@")
            str = str.gsub(/☆/, "@@")
            str = str.gsub(/◎/, "@@@@")
            str = str.gsub(/<\/?\w+>/, " ")
            str = str.gsub(/\s+/, " ")
            
            #日付のところで分解
            5.times do |j|
              s = str.rpartition(/<span style="text-decoration: underline;">\s*\d+[月\/]/u)
              result = s[1] + s[2]
              str = s[0]
              
              #date判定
              #日付をDateクラスへ
              if result =~ /<span style="text-decoration: underline;">\s*(\d+)[月\/]\s*(\d+)/u
                if update.month == 12 && $1 == 1 then
                  date = Date.new(update.year + 1, $1.to_i, $2.to_i)
                else
                  date = Date.new(update.year, $1.to_i, $2.to_i)
                end
              end
              
              #正規表現のために残してたspanタグを削除
              result = result.gsub(/<span style="text-decoration: underline;">/u, "")
              
              #<<なんか>>のとき、なんかをcommentに格納
              comment = result.scan(/<<([^<>]+)>>/u)
              
              #info判定,格納
              type = result.scan(/(@+)/u)
              cls = result.scan(/@+(専*\S+年*)/u)
              time = result.scan(/(\S+限)/u)
              lesson = result.scan(/限\s([^@]+)/u)
              
              #scanすると何故かArrayになるので平坦化
              type = type.flatten
              cls = cls.flatten
              time = time.flatten
              lesson = lesson.flatten
              comment = comment.flatten
              
              #ハッシュにして格納
              info = Array.new
              type.each_index do |k|
                #typeの復号化(1=休講,2=変更,4=補講で世界史みたいに足してるので、Stringへ)
                x = type[k].length
                type[k] = ""
                if ((x - 1) % 2) == 0
                  type[k] << "休講 "
                  x -= 1
                end
                if ((x - 2) % 4) == 0
                  type[k] << "変更 "
                  x -= 2
                end
                if x == 4
                  type[k] << "補講 "
                end
                
                #ハッシュにして格納
                info <<  Hash[type: type[k], cls: cls[k], time: time[k], lesson: lesson[k]]
              end
              #すべての情報を結果変数に格納
              kyuko << Hash[date: date, comment: comment, info: info]
            end
            
            i += 1
            #4回情報を取得したら終わり
            if i >=	4
              break
            end
          end
          #すべての結果を返す
          return kyuko
        end
        
        #今日の休講情報をハッシュで返す
        def kyuko_today
          @kyuko_data.find do |kyuko|
            kyuko[:date] == Date.today
          end
        end
        
        #一週間の休講情報を配列にしたハッシュで返す
        def kyuko_week
          @kyuko_data.find_all do |kyuko|
            kyuko[:date] >= Date.today && kyuko[:date] <= (Date.today + 7)
          end
        end

        class Kyuko_data
          attr_accessor :date, :comment, :info
          
          def initialize(date: Date.new(2000, 1, 1), comment: "", info: Array[Kyuko_info.new])
            @date = date
            @comment = comment
            @info = info
          end

          def each
            
          end
          
          
        end

        class Kyuko_info
          attr_accessor :type, :cls, :time, :lesson

          def initialize(type: Kyuko_Type.new, cls: Kyuko_Class.new, time: Array[0, 0], lesson: '')
            @type = type
            @cls = cls
            @time = time
            @lesson = lesson
          end
          
        end
        
        class Kyuko_Type
          attr_accessor :kyuko, :henko, :hokou

          def initialize(kyuko: false, henko: false, hokou: false)
            @kyuko = kyuko
            @henko = henko
            @hokou = hokou
          end

          def to_s
            type_str = ''
            type_str << '休講,' if kyuko == true
            type_str << '変更,' if henko == true
            type_str << '補講,' if hokou == true

            return type_str.chop
          end

        end

        class Kyuko_Class
          attr_accessor :year, :department, :cls

          def initialize(year: 0, department: nil, cls: 0)
            @year = year
            @department = department
            @cls = cls
          end

          def to_s
            return (year.to_s + department.to_s) if nil == department
            return (year.to_s + '-' + cls.to_s) unless nil == department
          end
          
          def self.parse(string)
            /(\d)-(\d)/ ~= string
            @year = $1.to_i
            @cls = $2.to_i
            /(\d)([MSEDC])/ ~= string
            @year = $1.to_i
            @department = $2
            /専(\d)/ ~= string
            @year = $1.to_i
            @department = '専'

            return self
          end
        end
      end
    end
  end
end



