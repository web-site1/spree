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
end