class Call

  class_attribute :client
  self.client = Api::Application.config.client

  attr_accessor :id, :status, :message, :destination, :created_at

  class << self

    def create(*args)
      new(*args).save
    end

  end

  def initialize(args)
    return unless Hash === args
    @attrs = args.with_indifferent_access
  end

  [ :account_id, :from, :to, :caller_name, :time_limit, :call_cost ]
    .each do |attr|
      define_method attr do
        @attrs[attr]
      end
    end

  def ring_timeout
    Integer(@attrs[:ring_timeout])

  rescue TypeError
    120
  end

  def save
    place_call
    self
  end


  protected

  def place_call
    params = {
      account: account_id,
      channel: to,
      timeout: ring_timeout * 10_000
    }
    params.update(callerid: caller_name) if caller_name.present?

    result = client.call params
    parse_response result

  rescue StandardError => e
    parse_error e

  ensure
    @created_at = Time.now
  end


  private

  def parse_response(response)
    @id = response.action_id
    @status = response.has_text_body? ? response.text_body : 'OK'
    @message = response['Message']
    @destination = to
  end

  def parse_error(error)
    @id = error.action_id
    @status = 'ERR'
    @message = error.message
  end

end
