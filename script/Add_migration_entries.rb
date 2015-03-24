require File.expand_path('../../config/environment', __FILE__)
require 'rake'

files = Dir.glob("../db/migrate/*")

sql_lst_ver = "select max(version) from schema_migrations"

t = ActiveRecord::Base.connection.select_rows(sql_lst_ver)

last_version =  t[0].first


timestamps = files.collect{|f| f.split("/").last.split("_").first}.sort

index =  timestamps.index(last_version)


last = timestamps.length

Dir.chdir ".."

timestamps[index+1..last].each{|t|

  begin
      @sql = "insert into schema_migrations (version) values ('#{t}')"
      p = "VERSION=#{t}"
      #Rake::Task['db:migrate'].invoke(p)
      o = system("bundle exec rake db:migrate #{p}")
      #puts o
      ActiveRecord::Base.connection.execute(@sql) rescue nil
    rescue Exception => e
      puts e.to_s
  end


}