module ApplicationExtensions

  extend ActiveSupport::Concern

  included do
    has_many :call_details, foreign_key: 'account_id'
  end

end

Doorkeeper::Application.send :include, ApplicationExtensions
