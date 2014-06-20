require 'yaml'

class Clients::Asterisk::Config

  attr_accessor :logger, :env, :path

  def connection_options
    @connection_options ||= YAML.load_file(path)[env]
  end

  def call_options
    @call_options ||= connection_options['calls']
  end

  def redirect_options
    @redirect_options ||= connection_options['redirect']
  end

  def logger
    @logger ||=
      begin
        log = File.open Rails.root.join('log', 'asterisk.log'), 'a'
        log.binmode
        log.sync = Rails.configuration.autoflush_log

        ActiveSupport::Logger.new(log).tap do |logger|
          logger.level = Rails.logger.level
        end
      end
  end

end
