config_file =
  begin
    YAML.load_file(Rails.root.join('config', 'carrierwave.yml'))[Rails.env]

  rescue StandardError
    {}
  end

CarrierWave.configure do |config|
  config.base_path = config_file['base_path'].presence || Rails.public_path.to_s
  config.permissions = 0644
  config.directory_permissions = 0755
  config.storage_engines = { file: 'CarrierWave::Storage::File' }
  config.enable_processing = config_file['enable_processing'].presence || true
  config.storage = (config_file['storage'].presence || 'file').to_sym
end
