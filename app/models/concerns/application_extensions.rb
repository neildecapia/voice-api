module ApplicationExtensions

  extend ActiveSupport::Concern

  included do
    with_options foreign_key: 'account_id' do |account|
      account.has_many :calls
      account.has_many :active_calls

      account.has_many :sounds
    end
  end

end

Doorkeeper::Application.send :include, ApplicationExtensions
