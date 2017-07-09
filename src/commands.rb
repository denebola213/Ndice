module Ndice

    # commandsディレクトリすべて読み込み
    Dir[File.dirname(__FILE__) + '/commands/*.rb'].each do |file|
        require_relative file
    end
end