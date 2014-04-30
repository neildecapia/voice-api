require 'ruby_ami'

class Clients::Asterisk::Connection

  def initialize(config, handler, logger)
    @stream = RubyAMI::Stream.new(
      config['host'].presence || 'localhost',
      config['port'].presence || '5038',
      config['username'],
      config['password'],
      handler,
      logger,
      config['timeout'].presence || 0
    )

    @stream.async.run
  end

  def method_missing(method, *args, &block)
    @stream.send_action method, *args, &block
  end

end
