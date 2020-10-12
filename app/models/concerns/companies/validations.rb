module Companies::Validations
  extend ActiveSupport::Concern

  included do
    validates :name,
      :projects_downloads,
      :transactions_downloads,
      :future_projects_downloads,
      presence: true
    # validates :projects_downloads,
    #   :transactions_downloads,
    #   :future_projects_downloads,
    #   numericality: true,
    #   numericality: { only_integer: true }
  end
end
