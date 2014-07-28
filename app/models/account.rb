class Account < ActiveRecord::Base

  has_many :calls
  has_many :active_calls

  has_many :sounds
  has_many :recordings

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
