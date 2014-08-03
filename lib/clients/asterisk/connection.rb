require 'ruby_ami'

class Clients::Asterisk::Connection

  def initialize(config, handler, logger)
    @logger = logger

    RubyAMI::Stream.supervise_as(
      :ami_stream,
      config['host'].presence || 'localhost',
      config['port'].presence || '5038',
      config['username'],
      config['password'],
      handler,
      @logger,
      config['timeout'].presence || 0
    )
  end

  def start!
    stream
  end

  def method_missing(method, *args, &block)
    stream.send_action method, *args, &block

  rescue StandardError => e
    @logger.error "Error communicating with stream: #{e.message}"
    raise Clients::Asterisk::ConnectionError, e.message
  end


  private

  def stream
    Celluloid::Actor[:ami_stream].tap do |stream|
      stream.async.run unless stream.started?
    end
  end

end
