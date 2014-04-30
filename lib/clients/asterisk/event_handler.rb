class Clients::Asterisk::EventHandler

  def initialize(client)
    @client = client
  end

  def call(event)
    case event
    when RubyAMI::Stream::ConnectionStatus

    when RubyAMI::Event
      dispatch event
    end
  end


  protected

  def dispatch(event)
    send event.name.to_s.underscore, event

  rescue NoMethodError
  end

  def originate_response(event)
  end

end
