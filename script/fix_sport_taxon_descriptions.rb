require '../config/environment'


s = Sport.where("ws_cat IN( 'NFL Licensed Ribbon','MLB Ribbon', 'Collegiate Licensed Ribbon')").order(:ws_cat,:ws_subcat,:ws_color)

taxons = s.map{|m| [m.ws_cat,m.ws_subcat]}.uniq


taxons.each do |t|

  cat = Spree::Taxon.find_by_name(t.first)

  subcat = Spree::Taxon.find_by_name_and_parent_id(t.last.titleize,cat.id)

  rcpbs = s.where("ws_cat = '#{t.first}' and ws_subcat = '#{t.last}' ").first


  p_des = %Q{This #{rcpbs.ws_subcat.strip.titlecase} ribbon captures team spirit at its best. }
  p_des += %Q{Manufactured as a 100% polyester woven-edge satin ribbon, this pattern is offered }
  p_des += %Q{in a #{rcpbs.ws_color.strip.downcase.gsub('spool','').gsub('spools','').titlecase} spool. Select your desired putup, width and pattern.}

  subcat.update_attribute(:description,p_des)
end