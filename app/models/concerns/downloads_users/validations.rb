module DownloadsUsers::Validations
  extend ActiveSupport::Concern

  included do
    validates :title, presence: true
    validates :title, uniqueness: { case_sensitive: false }
  end
end
