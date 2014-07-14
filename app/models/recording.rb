class Recording < ActiveRecord::Base

  DEFAULT_FORMAT = 'mp3'
  MAX_LENGTH = 60.seconds

  belongs_to :account, class_name: 'Doorkeeper::Application'

  validates :account, presence: true
  validates :filename, presence: true
  validates :format,
    presence: true,
    inclusion: {
      in: Api::Application.config.client.config.supported_formats,
      allow_blank: true
    }
  validates :time_limit,
    numericality: {
      only_integer: true,
      allow_nil: true,
      greater_than: 0,
      less_than_or_equal_to: MAX_LENGTH
    }
  validates :active_call, presence: true

  before_validation :set_filename
  before_validation :set_format
  after_validation :record_call

  attr_accessor :time_limit, :active_call

  def path
    unless persisted?
      raise NotImplementedError, 'Cannot compute path of unsaved recording.'
    end

    "#{path_without_extname}.#{format}"
  end


  protected

  def set_filename
    if self[:filename].blank?
      self[:filename] = SecureRandom.uuid
    end
    return
  end

  def set_format
    if self[:format].blank?
      self[:format] = DEFAULT_FORMAT
    end
    return
  end

  def record_call
    return unless errors.empty?

    @active_call.record(
      filename: path_without_extname,
      format: format,
      time_limit: time_limit.presence || MAX_LENGTH
    )
    return
  end


  private

  def path_without_extname
    File.join asset_dir, filename
  end

  def asset_dir
    # @note Surely Asterisk is able to manage directory creation?
    FileUtils.mkdir_p(
      File.join(asset_base, 'accounts', account_id.to_s)
    )
  end

  def asset_base
    Api::Application.config.client.config.asset_paths['recordings']
  end

end
