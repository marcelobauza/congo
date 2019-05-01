class CreateProjectInstanceMixViews < ActiveRecord::Migration[5.2]
  def change
    create_view :project_instance_mix_views
  end
end
