class SoundUploader < CarrierWave::Uploader::Base

  def store_dir
    "uploads/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(wav mp3)
  end

end
