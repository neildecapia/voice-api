class Clients::Asterisk::Client

  attr_reader :config

  def initialize(config)
    @config = config
    @handler = Clients::Asterisk::EventHandler.new self
  end

  def connect!
    attempts = 0

    begin
      attempts += 1

      @connection = Clients::Asterisk::Connection.new(
        @config.connection_options,
        @handler,
        @config.logger
      )
      @connected = true

    rescue StandardError => e
      if attempts > 3
        @config.logger.error "Unable to connect to Asterisk: #{e.message}"
        raise ConnectionError, e.message
      end

      sleep attempts
      retry
    end
  end

  def disconnect!
    @connection = nil
    @connected = false
  end

  def call(options = {})
    connection.originate call_params_from_options(options)
  end

  def answer(channel)
    connection.agi(
      command: 'answer',
      channel: channel
    )
  end

  def hangup(channel)
    connection.hangup channel: channel
  end

  def play_sound(options = {})
    path = options[:path]
    path = path.chomp File.extname(path)
    connection.agi(
      command: %Q[stream file "#{path}" "0123456789"],
      channel: options[:channel]
    )
  end

  def stop_sound(options = {})
    connection.redirect @config.redirect_options.merge(
      channel: options[:channel]
    )
  end

  def record(options = {})
    filename = options[:filename]
    format = options[:format]
    escape_digits = (0..9).to_a.join
    timeout =
      begin
        Integer(options[:timeout])

      rescue TypeError
        -1
      end

    connection.agi(
      command: %Q[record file #{filename} #{format} "#{escape_digits}" #{timeout}],
      channel: options[:channel]
    )
  end


  protected

  def call_params_from_options(options)
    raise ArgumentError unless Hash === options

    call_params = options.slice(:account)
    call_params[:channel] = options[:destination]

    if options[:callerid].present?
      call_params[:callerid] = options[:callerid]
    end

    if options[:ring_timeout].present?
      begin
        call_params[:timeout] = Integer(options[:ring_timeout]) * 1_000
      rescue TypeError, ArgumentError
      end
    end

    variables = []
    if options[:time_limit].present?
      variables.push "TIMEOUT(absolute)=#{options[:time_limit]}"
    end
    if options[:per_minute_rate].present?
      variables.push "CDR(per_minute_rate)=#{options[:per_minute_rate]}"
    end
    unless variables.empty?
      call_params[:variable] = variables.join(',')
    end

    call_params.reverse_merge @config.call_options
  end


  private

  def connection
    connect! unless @connected
    @connection
  end

end
