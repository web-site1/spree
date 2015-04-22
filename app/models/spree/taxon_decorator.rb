Spree::Taxon.class_eval do

  scope :featured, ->{
    where('name = ?','featured')
  }


end