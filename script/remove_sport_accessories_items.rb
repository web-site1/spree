# remove_sport_items - Delete all sports from Products table and related tables


require File.expand_path('../../config/environment', __FILE__)
##### - Script to add auto_renew column to Memberships table - 2014-09-30 ############

# To run from Rails.root, ruby ./app/me_scripts/add_freeze_fields.rb
def confirm(msg)
  STDOUT.printf "OK to " + msg + " (y/n)? "
  input = STDIN.gets.chomp.downcase
  input == "y"
end                            removeremov

db = 'spree99'

puts("\n\n########################################################################################\n")
puts("WARNING: THIS SCRIPT WILL ERASE ALL PRODUCT DATA INCLUDING IMAGES!")
puts("\n\n########################################################################################\n")
puts("Empty tables containing product specific data in #{db}")
puts("\nExecution Time : " + Time.now().to_s)

sql = "select table_name from INFORMATION_SCHEMA.columns where TABLE_CATALOG = '#{db}' and (column_name = 'product_id') "
@prod_id_databases = Spree::Product.find_by_sql(sql)

sql = "select table_name from INFORMATION_SCHEMA.columns where TABLE_CATALOG = '#{db}' and column_name = 'variant_id' "
@var_id_databases = Spree::Product.find_by_sql(sql)



msg = "OK to continue? "

unless confirm(msg)
  puts "Chicken."
  exit(1)
end

# First delete records using dependent => destroy
puts("Destroying Products before DELETEing...")

prod_to_delete_array = []

accessories_taxon = Spree::Taxon.find_by_name('NFL Accessories')

accessories_taxon.products.each{|p| prod_to_delete_array << p }

accessories_taxon.children.each do |c|
  c.products.each{|p| prod_to_delete_array << p}
  c.children.each{|cc| cc.products.each{|cp| prod_to_delete_array << cp}}
end

array_of_ids =  prod_to_delete_array.map{|p| p.id}

variants_to_del = Spree::Variant.where("product_id IN(?)",array_of_ids)

array_of_var_ids = variants_to_del.map{|v| v.id}

# Spree::Product.destroy_all

Spree::Product.where('id IN(?)',array_of_ids).destroy_all

csv_prod_id = array_of_ids.map{|i| %Q{'#{i}'}  }.join(",")
csv_var_id =  array_of_var_ids.map{|i| %Q{'#{i}'}  }.join(",")

$db_number = 0;


begin

  sql = ActiveRecord::Base.connection()
  sql.execute("delete from spree_products where id IN(#{csv_prod_id}) ")
    #sql.execute("DBCC CHECKIDENT ('#{db.table_name}', RESEED, 0);")

rescue ActiveRecord::StatementInvalid => e
  puts e.inspect
rescue Exception => e
  raise e
end



for db in @prod_id_databases
  $db_number = $db_number + 1
  puts("\nDatabase #{db.table_name}")
  begin

    sql = ActiveRecord::Base.connection()
    sql.execute('delete from '+db.table_name+ " where product_id IN(#{csv_prod_id}) ")
    #sql.execute("DBCC CHECKIDENT ('#{db.table_name}', RESEED, 0);")

  rescue ActiveRecord::StatementInvalid => e
    puts e.inspect
    next
  rescue Exception => e
    raise e
  end
end

for db in @var_id_databases
  $db_number = $db_number + 1
  puts("\nDatabase #{db.table_name}")
  begin

    sql = ActiveRecord::Base.connection()
    sql.execute('delete from '+db.table_name+ " where variant_id IN(#{csv_var_id}) ")
      #sql.execute("DBCC CHECKIDENT ('#{db.table_name}', RESEED, 0);")

  rescue ActiveRecord::StatementInvalid => e
    puts e.inspect
    next
  rescue Exception => e
    raise e
  end
end




puts"\nTotal DB's = #{$db_number}"

puts("\n\n########################################################################################\n")
