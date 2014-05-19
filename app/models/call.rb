class Call < ActiveRecord::Base

  NULL_TIMESTAMP = Time.at(0).utc

  class_attribute :client
  self.client = Api::Application.config.client

  belongs_to :account, class_name: 'Doorkeeper::Application'

  validates :account, presence: true
  validates :destination_channel, presence: true
  validates :time_limit,
    numericality: {
      only_integer: true,
      allow_nil: true,
      greater_than_or_equal_to: 0
    }
  validates :per_minute_rate,
    numericality: {
      allow_nil: true,
      greater_than_or_equal_to: 0
    }
  validates :ring_timeout,
    numericality: {
      only_integer: true,
      allow_nil: true,
      greater_than_or_equal_to: 0
    }

  after_validation :place_call
  before_save :never_save_from_here
  before_destroy :never_destroy_from_here

  alias_attribute :to, :destination_channel
  attr_accessor :time_limit, :ring_timeout

  def status
    return self[:status] unless self[:status].respond_to?(:downcase)
    self[:status].downcase
  end

  # @hack Better if we can get Asterisk to set proper NULL timestamps.
  def answered_at
    if self[:answered_at] && (self[:answered_at] > NULL_TIMESTAMP)
      self[:answered_at]
    end
  end

  def ring_timeout
    Integer(self[:ring_timeout]).seconds

  rescue TypeError
    120.seconds
  end


  protected

  def place_call
    return unless errors.empty?

    begin
      result = client.call(
        account: account_id,
        destination: destination_channel,
        callerid: caller_name,
        time_limit: time_limit,
        per_minute_rate: per_minute_rate,
        ring_timeout: ring_timeout
      )

      parse_response result

    rescue StandardError => e
      parse_error e

    ensure
      self.started_at = Time.now.utc
    end
  end

  def never_save_from_here
    false
  end
  alias never_destroy_from_here never_save_from_here


  private

  def parse_response(response)
    self.id = response.action_id
  end

  def parse_error(error)
    self.id = error.action_id
    self.errors[:base] = error.message
  end

end
