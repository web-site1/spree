Spree::Admin::UsersController.class_eval do

  def user_params
    params.require(:user).permit(permitted_user_attributes |
                                     [:cust_number,
                                      :spree_role_ids,
                                      ship_address_attributes: permitted_address_attributes,
                                      bill_address_attributes: permitted_address_attributes])
  end

end