Deface::Override.new(:virtual_path => 'spree/backend/app/views/spree/admin/users/_form.html.erb',
                     :name => 'add_cust_number_to_customer_edit',
                     :insert_after => "erb[loud]:contains('hidden_field_tag user[spree_role_ids][]')",
                     :text => "<%= f.field_container :cust_number do %>
      <%= f.label :cust_number %>
      <%= f.text_field :cust_number, :value => @user.cust_number %>
      <%= f.error_message_on :cust_number %>
    <% end %>  ")
