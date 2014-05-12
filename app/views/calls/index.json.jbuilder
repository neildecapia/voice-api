json.array!(@calls) do |call|
  json.extract! call, :id, :account_id, :source, :caller_id,
    :destination, :destination_channel, :disposition,
    :started_at, :ended_at, :answered_at, :billable_duration
end
