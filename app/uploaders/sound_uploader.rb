class SoundUploader < CarrierWave::Uploader::Base

  def store_dir
    File.join asset_base, mounted_as.to_s, model.id.to_s
  end

  def extension_white_list
    %w(alaw gsm ulaw wav mp3)
  end


  private

  def asset_base
    Rails.application.config.client.config.asset_paths['sounds']
  end

end
