class DownloadsUser < ApplicationRecord
  belongs_to :user

  include DownloadsUsers::Exports

end
