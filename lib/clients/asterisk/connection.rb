require 'ruby_ami'

class Clients::Asterisk::Connection

  def initialize(config, handler, logger)
    RubyAMI::Stream.supervise_as(
      :ami_stream,
      config['host'].presence || 'localhost',
      config['port'].presence || '5038',
      config['username'],
      config['password'],
      handler,
      logger,
      config['timeout'].presence || 0
    )
  end

  def method_missing(method, *args, &block)
    stream.send_action method, *args, &block
  end


  private

  def stream
    Celluloid::Actor[:ami_stream].tap do |stream|
      stream.async.run unless stream.started?
    end
  end


end
