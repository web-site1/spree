Spree::CheckoutController.class_eval do
  def update_registration
    if params[:order][:email] =~ Devise.email_regexp && current_order.update_attribute(:email, params[:order][:email])
      contact = Contact.new(email_address: params[:order][:email], lists: MASTER_LIST_ID).save if params[:order][:allow_mailings] == '1'
      redirect_to spree.checkout_path
    else
      flash[:registration_error] = t(:email_is_invalid, :scope => [:errors, :messages])
      @user = Spree::User.new
      render 'registration'
    end
  end
end