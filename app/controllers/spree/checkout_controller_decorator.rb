Spree::CheckoutController.class_eval do

  # If a user checks out as guest, this method saves the email to the order header.
  # Dan added the save to constant contact if user allows
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

  # Updates the order and advances to the next state (when possible.)
  # Dan added the update of first and last name to constant contact if contact exists out there

  def update
    if @order.update_from_params(params, permitted_checkout_attributes, request.headers.env)
      @order.temporary_address = !params[:save_user_address]
      unless @order.next
        flash[:error] = @order.errors.full_messages.join("\n")
        redirect_to checkout_state_path(@order.state) and return
      end

      if @order.completed?
        @order.update_contact # Update first and last name of contact from billing address
        @current_order = nil
        flash.notice = Spree.t(:order_processed_successfully)
        flash['order_completed'] = true
        redirect_to completion_route
      else
        redirect_to checkout_state_path(@order.state)
      end
    else
      render :edit
    end
  end
end