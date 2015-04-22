Spree::ProductsHelper.module_eval do
  def active_results_per_page(per_pg,num)
    if per_pg == num
      "active"
    end
  end

  def compare_lengths(a,b)
  	aa = a.split('-')
	na=0
	if(aa.length>1) # has a dash
		na = aa[0].to_f
		aal = aa[1].split('/')
	else # doesn't have a dash
		aal = aa[0].split('/')
	end

	if aal.length > 1
		na += aal[0].to_f/aal[1].to_f 
	else
		na += aal[0].to_f
	end


	bb = b.split('-')
	nb=0
	if(bb.length>1)
		nb = bb[0].to_f
		bbl = bb[1].split('/')
	else
		bbl = bb[0].split('/')
	end
	
	if bbl.length > 1
		nb+= bbl[0].to_f/bbl[1].to_f
	else
		nb+=bbl[0].to_f
	end

	na <=> nb	
  end

end