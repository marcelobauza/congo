module FutureProjectsHelper
  def status_future_project_type row
    if row.future_project_type.name == 'ANTEPROYECTO'
      if (Date.today - row.file_date).days > 6.months
        'Caducado'
      else
        'Vigente'
      end
    elsif row.future_project_type.name == 'PERMISO DE EDIFICACION'
      if (Date.today - row.file_date).days > 3.years
        'Caducado'
      else
        'Vigente'
      end
    end
  end
end
