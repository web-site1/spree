require File.expand_path('../../config/environment', __FILE__)

r = Sport.where(" ws_cat = 'NFL LICENSED RIBBON' and width = '2-1/2\"' ")

ov_to_change = Spree::OptionValue.find(2835)

r.each do |s|
  next if !(s.desc =~ /1-5\/16/)
  v = Spree::Variant.find_by_sku(s.new_pbs_desc_1)
  p = v.product
  p.update_attribute(:name,p.name.gsub('2-1/2','1-5/16') )
  p.update_attribute(:description,p.description.gsub('2-1/2','1-5/16') )

  ovs = v.option_values
  keep = ovs.select{|o| !(o.option_type_id == 7)}
  keep.each{|v| v.option_values << v}
  v.option_values << ov_to_change
  v.save!

  puts %Q{#{s.new_pbs_desc_1} done}
end