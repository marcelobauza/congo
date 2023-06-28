class DownloadsUser < ApplicationRecord
  belongs_to :user

  scope :by_user, lambda { |user_id| where(user_id: user_id) if user_id.present? }
  scope :disabled_only, lambda { |disabled| where(disabled: disabled) }
  scope :by_layer_type, lambda { |layer_type| where(layer_type: layer_type) if layer_type.present? }

  include DownloadsUsers::Exports
end
