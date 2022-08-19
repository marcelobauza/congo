module FlexReports::Validations
  extend ActiveSupport::Concern

  included do
    validates :name, presence: true
    validates :name, uniqueness: { case_sensitive: false }
    validate :has_credits_available

    def has_credits_available

      orders  = Current.user.flex_orders.where(status: 'approved').sum(&:amount).to_i
      reports = Current.user.flex_reports.size
      total   = orders - reports

      errors.add(:base, 'Creditos consumidos') if total <= 0
    end
  end
end
