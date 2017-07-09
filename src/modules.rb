module Ndice
  # modulesディレクトリすべて読み込み
  Dir[File.dirname(__FILE__) + '/modules/*.rb'].each do |file|
      require_relative file
  end
end