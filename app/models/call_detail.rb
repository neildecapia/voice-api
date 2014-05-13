class CallDetail < ActiveRecord::Base

  NULL_TIMESTAMP = Time.at(0).utc

  # @hack Better if we can get Asterisk to set proper NULL timestamps.
  def answered_at
    if self[:answered_at] && (self[:answered_at] > NULL_TIMESTAMP)
      self[:answered_at]
    end
  end

end
