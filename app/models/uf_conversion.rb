class UfConversion < ApplicationRecord

attr_accessor :file 

  def self.load_file tmpfile
    require 'csv'
    csvfile = tmpfile.read
    CSV.parse(csvfile, col_sep: ";") do |row|
      uf = UfConversion.find_or_create_by(uf_date: Date.strptime(row[0],'%d/%m/%Y'))
      uf.uf_value = row[1].gsub(",", ".").to_f
      uf.save
    end
  end

end
