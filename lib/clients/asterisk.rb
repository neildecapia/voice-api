module Clients::Asterisk

  autoload :Config, 'clients/asterisk/config'
  autoload :Logger, 'clients/asterisk/logger'
  autoload :Client, 'clients/asterisk/client'
  autoload :Connection, 'clients/asterisk/connection'
  autoload :EventHandler, 'clients/asterisk/event_handler'

  @@config = nil
  @@client = nil

  class << self

    def configure(&block)
      instance_exec(&block)
    end

    def config
      @@config ||= Config.new
    end

    def client
      @@client ||= Client.new config
    end

  end

end
