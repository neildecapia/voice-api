class SoundUploader < CarrierWave::Uploader::Base

  def store_dir
    File.join Rails.application.config.asset_base, mounted_as.to_s, model.id.to_s
  end

  def extension_white_list
    %w(wav mp3)
  end

end
