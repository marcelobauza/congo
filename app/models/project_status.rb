class ProjectStatus < ApplicationRecord
  has_many :project_instances
  has_many :project_instance_mix_views
end
