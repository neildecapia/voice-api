class Sound < ActiveRecord::Base

  belongs_to :account, class_name: 'Doorkeeper::Application'

  mount_uploader :sound, SoundUploader

  def name
    self[:name].presence || sound.identifier
  end

end
