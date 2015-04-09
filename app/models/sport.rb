class Sport < ActiveRecord::Base
  has_one :web_item, foreign_key: :item, primary_key: :item
end
