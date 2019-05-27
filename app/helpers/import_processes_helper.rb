module ImportProcessesHelper
  def short_description(process)
    case process.status
    when 'working'
      t(process.status, :time_ago => time_ago_in_words(process.created_at), :scope => [:label, :import_process, :status])
    when 'failed', 'success'
      t(process.status, :start_time => l(process.created_at, :format => :long), :time_later => distance_of_time_in_words(process.created_at, process.updated_at), :scope => [:label, :import_process, :status])
    when 'idle'
      t(process.status, :time_ago => time_ago_in_words(process.created_at), :scope => [:label, :import_process, :status])
    else
      "Estado desconocido"
    end
  end
end
