json.(@call, :account_id)

json.message @message

json.(@call,
  :to,
  :status,
  :started_at,
  :ended_at,
  :answered_at
)

json.duration @call.billable_duration
json.(@call, :per_minute_rate)
