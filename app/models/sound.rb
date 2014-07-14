class Sound < ActiveRecord::Base

  belongs_to :account, class_name: 'Doorkeeper::Application'

  mount_uploader :sound, SoundUploader

  validates :account, presence: true
  validates :name,
    presence: true,
    uniqueness: { scope: :account_id, allow_blank: true }
  validates :sound, presence: true

  delegate :path, to: :sound

  def name
    self[:name].presence || sound.identifier
  end

end
