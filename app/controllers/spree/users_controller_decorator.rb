Spree::UsersController.class_eval do

  def show
    @orders = @user.orders.complete.order('completed_at desc')
    @contact = Contact.new(email_address: @user.email)
    if @user.billing_address
      @contact.first_name ||= @user.billing_address.firstname
      @contact.last_name  ||= @user.billing_address.lastname
    end
  end

end