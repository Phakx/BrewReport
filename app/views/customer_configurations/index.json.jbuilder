json.array!(@customer_configurations) do |customer_configuration|
  json.extract! customer_configuration, :id, :customer_id, :dailySlaStart, :dailySlaEnd, :weeklySlaDays, :excludedDays
  json.url customer_configuration_url(customer_configuration, format: :json)
end
