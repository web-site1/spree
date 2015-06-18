json.array!(@contacts) do |contact|
  json.extract! contact, :id, :id, :status, :first_name, :middle_name, :last_name, :confirmed, :email_addresses, :prefix_name, :job_title, :addresses, :company_name, :home_phone, :work_phone, :cell_phone, :fax, :custom_fields, :lists, :source_details, :notes, :source
  json.url contact_url(contact, format: :json)
end
