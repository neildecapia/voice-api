require 'yaml'

class Clients::Asterisk::Config

  attr_accessor :logger, :env, :path

  def connection_options
    @connection_options ||= YAML.load_file(path)[env]
  end

  def call_options
    @call_options ||= connection_options['calls']
  end

end
