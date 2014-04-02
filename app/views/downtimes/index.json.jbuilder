json.array!(@downtimes) do |downtime|
  json.extract! downtime, :id, :start, :downtime_type, :end, :comment, :sla_per_day_id
  json.url downtime_url(downtime, format: :json)
end
