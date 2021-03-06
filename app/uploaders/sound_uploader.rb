class SoundUploader < CarrierWave::Uploader::Base

  def store_dir
    File.join asset_base, mounted_as.to_s, model.id.to_s
  end

  def extension_white_list
    Api::Application.config.client.config.supported_formats
  end


  private

  def asset_base
    Api::Application.config.client.config.asset_paths['sounds']
  end

end
