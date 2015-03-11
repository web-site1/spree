Spree::OptionValue.class_eval do
  scope :option_names, -> (otid) {
    select(:presentation,:position).
        where(option_type_id: otid)
  }

end