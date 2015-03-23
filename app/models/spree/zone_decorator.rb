Spree::Zone.class_eval do
  def kind
    if members.any? && !members.any? { |member| member.try(:zoneable_type).nil? }
      members.last.zoneable_type.demodulize.underscore
    end
  end
end