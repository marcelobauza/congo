class Concerns::Projects::Migrations
  # def self.migrate_projects code

  #   project =  Project.where(county_id: ).first
  #   project_instances = ProjectInstance.
  #     where(project_id: project.id).
  #     where(bimester: 3).
  #     where(year: 2019)

  #    project_instances.each do |pi|

  #     project_instance_new = ProjectInstance.create!(
  #       project_id: pi.project_id,
  #       project_status_id: pi.project_status_id,
  #       bimester: 1,
  #       year: 2020,
  #       cadastre: '01/01/2020'
  #     )
  #     project_instance_mixes = ProjectInstanceMix.where(project_instance_id: pi.id)

  #     project_instance_mixes.each do |pim|
  #       ProjectInstanceMix.create!(
  #           project_instance_id: project_instance_new.id,
  #           mix_id: pim.mix_id,
  #           percentage: pim.percentage,
  #           stock_units: pim.stock_units,
  #           mix_m2_field: pim.mix_m2_field,
  #           mix_m2_built: pim.mix_m2_built,
  #           mix_usable_square_meters: pim.mix_usable_square_meters,
  #           mix_terrace_square_meters: pim.mix_terrace_square_meters,
  #           mix_uf_m2: pim.mix_uf_m2,
  #           mix_selling_speed: pim.mix_selling_speed,
  #           mix_uf_value: pim.mix_uf_value,
  #           living_room: pim.living_room,
  #           service_room: pim.service_room,
  #           h_office: pim.h_office,
  #           discount: pim.discount,
  #           uf_min: pim.uf_min,
  #           uf_max: pim.uf_max,
  #           uf_parking: pim.uf_parking,
  #           uf_cellar: pim.uf_cellar,
  #           common_expenses: pim.common_expenses,
  #           withdrawal_percent: pim.withdrawal_percent,
  #           total_units: pim.total_units,
  #           t_min: pim.t_min,
  #           t_max: pim.t_max,
  #           home_type: pim.home_type,
  #           model: pim.model
  #       )
  #     end
  #   end
  # end
end
