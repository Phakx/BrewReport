json.array!(@downtimes) do |downtime|
  json.extract! downtime, :id, :start, :downtimeType, :end, :comment
  json.url downtime_url(downtime, format: :json)
end
