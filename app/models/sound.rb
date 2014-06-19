class Sound < ActiveRecord::Base

  belongs_to :account, class_name: 'Doorkeeper::Application'

  mount_uploader :sound, SoundUploader

  delegate :path, to: :sound

  def name
    self[:name].presence || sound.identifier
  end

end
