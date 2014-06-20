class Clients::Asterisk::Client

  def initialize(config)
    @config = config

    @handler = Clients::Asterisk::EventHandler.new self

    @connection = Clients::Asterisk::Connection.new(
      @config.connection_options,
      @handler,
      @config.logger
    )
  end

  def call(options = {})
    @connection.originate call_params_from_options(options)
  end

  def hangup(channel)
    @connection.hangup channel: channel
  end

  def play_sound(options = {})
    path = options[:path]
    path = path.chomp File.extname(path)
    @connection.agi(
      command: "exec playback \"#{path}\"",
      channel: options[:channel]
    )
  end

  def stop_sound(options = {})
    @connection.redirect @config.redirect_options.merge(
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
        call_params[:timeout] = Integer(options[:ring_timeout]) * 10_000
      rescue TypeError
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

end
