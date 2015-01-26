class OldPage < ActiveRecord::Base
  has_one :taxon, :class_name => 'Spree::Taxon'
end
