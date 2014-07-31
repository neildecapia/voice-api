class Account < ActiveRecord::Base

  has_many :applications, class_name: 'Doorkeeper::Application', as: :owner

  has_many :calls
  has_many :active_calls

  has_many :sounds
  has_many :recordings

  validates :callback_url, url: { allow_blank: true }

  devise(
    :database_authenticatable,
    :registerable,
    :confirmable,
    :lockable,
    :recoverable,
    :rememberable,
    #:timeoutable,
    :trackable,
    :validatable
  )

end
