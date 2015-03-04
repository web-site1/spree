# remove_all_items - Delete all data from Products table and related tables


require File.expand_path('../../config/environment', __FILE__)
##### - Script to add auto_renew column to Memberships table - 2014-09-30 ############

# To run from Rails.root, ruby ./app/me_scripts/add_freeze_fields.rb
def confirm(msg)
  STDOUT.printf "OK to " + msg + " (y/n)? "
  input = STDIN.gets.chomp.downcase
  input == "y"
end

db = 'spree99'

puts("\n\n########################################################################################\n")
puts("WARNING: THIS SCRIPT WILL ERASE ALL PRODUCT DATA INCLUDING IMAGES!")
puts("\n\n########################################################################################\n")
puts("Empty tables containing product specific data in #{db}")
puts("\nExecution Time : " + Time.now().to_s)

sql = "select table_name from INFORMATION_SCHEMA.columns where TABLE_CATALOG = '#{db}' and (column_name = 'product_id' or (table_name = 'spree_products' and column_name = 'id')) "
@databases = Spree::Product.find_by_sql(sql)
sql = "select table_name from INFORMATION_SCHEMA.columns where TABLE_CATALOG = '#{db}' and column_name = 'variant_id' "
@databases += Spree::Product.find_by_sql(sql)

@databases.each {|d| puts d.table_name}
puts"Total DB's = #{@databases.count}"

msg = "OK to continue? "
unless confirm(msg)
  puts "Chicken."
  exit(1)
end

# First delete records using dependent => destroy
puts("Destroying Products before DELETEing...")
Spree::Product.destroy_all

$db_number = 0;

for db in @databases
  $db_number = $db_number + 1
  puts("\nDatabase #{db.table_name}")
  begin

    sql = ActiveRecord::Base.connection()
    sql.execute('delete from '+db.table_name)
    sql.execute("DBCC CHECKIDENT ('#{db.table_name}', RESEED, 0);")

  rescue ActiveRecord::StatementInvalid => e
    puts e.inspect
    next
  rescue Exception => e
    raise e
  end
end
puts"\nTotal DB's = #{$db_number}"

puts("\n\n########################################################################################\n")
