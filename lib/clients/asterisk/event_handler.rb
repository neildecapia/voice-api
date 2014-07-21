class Clients::Asterisk::EventHandler

  def initialize(client)
    @client = client
  end

  def call(event)
    return unless RubyAMI::Event === event

    method = event.name.to_s.underscore
    __send__ method, event if respond_to?(method)
  end

  def shutdown(event)
    @client.disconnect!
  end

end
