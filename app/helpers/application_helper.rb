module ApplicationHelper

  def quick_src_selected(name='',val='')
    selected=''
    if params.has_key?(:quick_search) && params[:quick_search] == 'Y'
      if params.has_key?(name.to_sym) && params[name.to_sym].include?(val)
        selected = 'selected'
      end
    end
    return selected
  end

end
