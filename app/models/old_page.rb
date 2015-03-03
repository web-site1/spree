class OldPage < ActiveRecord::Base
  belongs_to :taxon, :class_name => 'Spree::Taxon'
end
