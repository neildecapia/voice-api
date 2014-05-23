json.array!(@calls) do |call|
  json.extract! call,
    :account_id,
    :from,
    :caller_name,
    :to,
    :status,
    :started_at,
    :ended_at,
    :answered_at

  json.duration call.billable_duration
  json.extract! call, :per_minute_rate
end
