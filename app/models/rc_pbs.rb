class RcPbs < ActiveRecord::Base

  has_one :web_item, foreign_key: :item, primary_key: :item

  has_one :variant,class_name: 'Spree::Variant',:foreign_key => :item_no, :primary_key => :new_pbs_item

end
