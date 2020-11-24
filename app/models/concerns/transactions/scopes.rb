module Transactions::Scopes
  extend ActiveSupport::Concern

  included do
    def number_filter number
      return all unless !number.empty?
      where(number: number)
    end

    def role_filter role
      return all unless !role.empty?
      where(role: role)
    end

    def property_type_filter property_type_id
      return all unless !property_type_id.empty?
      where(property_type_id: property_type_id)
    end

    def inscription_date_filter inscription_date
      return all unless !inscription_date.empty?
      where(inscription_date: inscription_date)
    end
  end
end
