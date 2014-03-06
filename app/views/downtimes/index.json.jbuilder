json.array!(@downtimes) do |downtime|
  json.extract! downtime, :id, :start, :downtimeType, :end, :comment, :SLAPerMonth_id
  json.url downtime_url(downtime, format: :json)
end
