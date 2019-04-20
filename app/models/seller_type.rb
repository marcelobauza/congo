class SellerType < ApplicationRecord
  has_many :transactions
  has_many :transaction_results, :through => :transactions

  def self.get_seller_type(seller_type)
    if seller_type.nil?
      seller_type = "SIN INFORMACION"
    else
      case seller_type.upcase
      when "P"
        seller_type = "PROPIETARIO"
      when "I", "i"
        seller_type = "INMOBILIARIA"
      when "B"
        seller_type = "BANCO"
      when "C"
        seller_type = "COOPERATIVA"
      when "E", "F"
        seller_type = "EMPRESA"
      when "M"
        seller_type = "MUNICIPALIDAD"
      when "SI", "S / I", "S/I"
        seller_type = "SIN INFORMACION"
      else
        seller_type = "OTRO"
      end
    end

    s = SellerType.find_by_name(seller_type)
    s = SellerType.create :name => seller_type if s.nil?

    return s
  end

  def self.group_transactions_by_seller_type(params)
    Transaction.select("seller_types.name, seller_type_id as id, SUM(1 / sample_factor) as value").
                joins(Transaction.build_joins.join(" ")).
                where(Transaction.build_conditions(params, 'seller_type')).
                group('seller_types.name, seller_type_id').
                order('value DESC')
  end

  def get_my_initials
    case self.name 
    when "PROPIETARIO"
      return "P"
    when "INMOBILIARIA"
      return "I"
    when "BANCO"
      return "B"
    when "COOPERATIVA"
      return "C"
    when "EMPRESA"
      return "E"
    when "MUNICIPALIDAD"
      return "M"
    when "SIN INFORMACION"
      return "S/I"
    else
      return "OTRO"
    end
  end

  def self.get_seller_types_by_result_id(result_id)
    SellerType.select("DISTINCT seller_types.id, seller_types.name"). 
               joins(:transaction_results).
               where("result_id= #{result_id}")
  end

end
