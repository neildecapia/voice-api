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
    @connection.originate options.reverse_merge(@config.call_options)
  end

end
