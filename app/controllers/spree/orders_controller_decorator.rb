Spree::OrdersController.class_eval do

  def change_art_state
    order = Spree::Order.find(params[:order_id])
    order.update_attribute("art_ship_state",params[:state])
    render text: params[:state]
  end

end