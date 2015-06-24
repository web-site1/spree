Spree::UsersController.class_eval do

  def show
    @orders = @user.orders.complete.order('completed_at desc')
    @contact = Contact.find_by_email(@user.email)
  end

end