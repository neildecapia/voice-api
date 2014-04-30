json.(@call, :id, :status, :message, :created_at)

if @call.destination.present?
  json.(@call, :destination)
end

if @call.time_limit.present?
  json.(@call, :time_limit)
end
