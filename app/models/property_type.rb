class PropertyType < ApplicationRecord
    has_many :transactions
    has_many :county_ufs
    has_many :transaction_results, :through => :transactions

    def self.get_property_type_transaction(property_type)
      calculate_uf = false

      if property_type.nil?
        property_type= "OTRO"
      else
        case property_type.upcase 
        when "C"
          property_type = "CASA"
          calculate_uf = true
        when "D"
          property_type = "DEPARTAMENTO"
        when "O"
          property_type = "OFICINA"
        when "E"
          property_type = "ESTACIONAMIENTO"
        when "S"
          property_type = "SITIO"
          calculate_uf = true
        when "LC"
          property_type = "LOCAL COMERCIAL"
        when "B"
          property_type = "BODEGA"
        when "P"
          property_type = "PARCELA"
          calculate_uf = true
        when "IN"
          property_type = "INDUSTRIA"
          calculate_uf = true
        else
          property_type = "OTRO"
        end
      end

      p = PropertyType.find_by_name(property_type)
      p = PropertyType.create :name => property_type if p.nil? 

      return p, calculate_uf
    end

    def self.group_transactions_by_prop_types(params)
      Transaction.
                  select("property_types.name, property_type_id as id, SUM(1 / sample_factor) as value").
                  joins(Transaction.build_joins.join(" ")).
                  where(Transaction.build_conditions(params, 'property_type')).
                  group('property_types.name, property_type_id').
                  order('value DESC')
    end

    def get_my_initials
      case self.name 
      when "CASA"
        return "C"
      when "DEPARTAMENTO"
        return "D"
      when "OFICINA"
        return "O"
      when "ESTACIONAMIENTO"
        return "E"
      when "SITIO"
        return "S"
      when "LOCAL COMERCIAL"
        return "LC"
      when "BODEGA"
        return "B"
      when "PARCELA"
        return "P"
      when "INDUSTRIA"
        return "IN"
      else
        return "OTRO"
      end
    end

    def self.get_property_types_by_result_id(result_id)
      PropertyType.select("DISTINCT property_types.id, property_types.name as label"). 
                         joins(transaction_results).
                         where("result_id= #{result_id}")
    end
end
