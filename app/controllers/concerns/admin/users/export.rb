module Admin::Users::Export
  extend ActiveSupport::Concern

  def export_data
    export = User.export_data
    send_file export, :type => 'text/csv', :disposition => "inline", :filename => "limites_descargas.csv"
  end
end
