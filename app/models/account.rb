class Account < ActiveRecord::Base

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
