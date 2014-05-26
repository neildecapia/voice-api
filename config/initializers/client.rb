require 'clients/asterisk'

Clients::Asterisk.configure do
  config.env = Rails.env
  config.path = Rails.root.join('config', 'asterisk.yml').to_s
end

Rails.application.config.client = Clients::Asterisk.client