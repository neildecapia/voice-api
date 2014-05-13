json.array!(@calls) do |call|
  json.extract! call, :account_id, :source, :caller_id, :destination
  json.disposition call.disposition.to_s.downcase

  json.extract! call, :started_at, :ended_at, :answered_at
  json.call_duration call.billable_duration
end
