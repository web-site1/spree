# Constant Contact wrapper model for CC API SDK
class Ccontact

  attr_accessor

  def initialize
    @oauth = ConstantContact::Auth::OAuth2.new()
    @c = ConstantContact::Api.new(Rails.application.secrets.cc_access_key, Rails.application.secrets.cc_token)
  end

  def find(id)
    @cc = @c.get_contact(id.to_s) rescue nil
  end

  def add_to_list(list_id)
    @cc.lists << {id: list_id.to_s} unless @cc.lists.map(&:id).include?(list_id.to_s)
  end
end