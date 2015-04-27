Spree::OrdersController.class_eval do

  def change_art_state
    order = Spree::Order.find(params[:order_id])
    order.update_attribute("art_ship_state",params[:state])
    render text: params[:state]
  end

  # Shows the current incomplete order from the session
  # Now go back to last item on order when user says "Continue Shopping...Dan"
  def edit
    @order = current_order || Order.incomplete.find_or_initialize_by(guest_token: cookies.signed[:guest_token])
    @continue_shopping_path = product_path(@order.line_items.last.variant.product) rescue products_path
    associate_user
  end

  def ajax_cart
    @order = current_order || Order.incomplete.find_or_initialize_by(guest_token: cookies.signed[:guest_token])
    @continue_shopping_path = product_path(@order.line_items.last.variant.product) rescue products_path
    associate_user
    render partial: 'ajax_cart',layout: false
  end

  # Adds a new item to the order (creating a new order if none already exists)
  def populate
    order    = current_order(create_order_if_necessary: true)
    variant  = Spree::Variant.find(params[:variant_id])
    quantity = params[:quantity].to_i
    options  = params[:options] || {}

    # 2,147,483,647 is crazy. See issue #2695.
    if quantity.between?(1, 2_147_483_647)
      begin
        order.contents.add(variant, quantity, options)
      rescue ActiveRecord::RecordInvalid => e
        error = e.record.errors.full_messages.join(", ")
      end
    else
      error = Spree.t(:please_enter_reasonable_quantity)
    end

    json_rtn = {}

    if request.xhr?
      if error
          flash[:error] = error
          #redirect_back_or_default(spree.root_path)
          json_rtn.merge!(status: 'error')
          json_rtn.merge!(mess: error)
          render :json => json_rtn.to_json
      else
          json_rtn.merge!(status: 'success')
          json_rtn.merge!(mess: %Q{Item #{variant.sku} Added to cart})
          render :json => json_rtn.to_json
      end
    else
      if error
        flash[:error] = error
        redirect_back_or_default(spree.root_path)
      else
        respond_with(order) do |format|
          flash[:notice] = "Item added to cart"
          format.html { redirect_to %Q{#{request.referer}?variant_id=#{variant.id}} }
        end
      end
    end

  end

end