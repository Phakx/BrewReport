json.array!(@sla_per_months) do |sla_per_month|
  json.extract! sla_per_month, :id, :month, :year, :customer_id
  json.url sla_per_month_url(sla_per_month, format: :json)
end
