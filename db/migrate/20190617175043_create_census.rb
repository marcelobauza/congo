class CreateCensus < ActiveRecord::Migration[5.2]
  def change
    create_table :census do |t|
      t.integer :age_0_9
      t.integer :age_10_19
      t.integer :age_20_29
      t.integer :age_30_39
      t.integer :age_40_49
      t.integer :age_50_59
      t.integer :age_60_69
      t.integer :age_70_79
      t.integer :age_80_more
      t.integer :home_1p
      t.integer :home_2p
      t.integer :home_3p
      t.integer :home_4p
      t.integer :home_5p
      t.integer :owner
      t.integer :leased
      t.integer :transferred
      t.integer :free
      t.integer :possession
      t.integer :male
      t.integer :female
      t.integer :married
      t.integer :coexist
      t.integer :single
      t.integer :canceled
      t.integer :separated
      t.integer :widowed
      t.integer :m_status_total
      t.integer :not_attended
      t.integer :basic
      t.integer :high_school
      t.integer :cft
      t.integer :ip
      t.integer :university
      t.integer :education_level_total
      t.integer :salaried
      t.integer :domestic_service
      t.integer :independient
      t.integer :employee_employer
      t.integer :unpaid_familiar
      t.integer :labor_total
      t.integer :abc1
      t.integer :c2
      t.integer :c3
      t.integer :d
      t.integer :e
      t.integer :socio_economic_total
      t.integer :homes_abc1
      t.integer :homes_c2
      t.integer :homes_c3
      t.integer :homes_d
      t.integer :homes_e
      t.integer :predominant
      t.references :census_source, foreign_key: true
      t.references :county, foreign_key: true
      t.numeric :block
      t.st_point :the_geom
      t.integer :homes_total
      t.integer :population_total

      t.timestamps
    end
  end
end
