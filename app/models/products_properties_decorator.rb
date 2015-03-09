Spree::ProductProperty.class_eval do

  scope :product_values, -> (pid) {
    select(:value).
    where(property_id: pid)
  }

end