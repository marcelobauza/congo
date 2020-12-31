module Users::Export
  extend ActiveSupport::Concern

  module ClassMethods
    def export_data
      u = User.all
      get_download_limits_csv u
    end

    private
      def get_download_limits_csv users
        header   = %w(Nombre Descargas_prv Descargas_CBR Descargas_EM )
        tempFile = Tempfile.new('descargas.csv')

        CSV.open(tempFile.path, 'w') do |writer|
          writer << header
          users.each do |u|
            values = [
              u.name,
              u.downloads_users.sum(:projects),
              u.downloads_users.sum(:transactions),
              u.downloads_users.sum(:future_projects)
            ]
           writer << values
          end
        end

        tempFile.path
      end
  end
end
