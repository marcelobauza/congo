module Admin::ProjectMixesHelper
  def project_mixes_for_select
    ProjectMix.all.collect { |c| [c.mix_type, c.id]}
  end
end
