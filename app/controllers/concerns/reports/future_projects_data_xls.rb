module Reports::FutureProjectsDataXls
  extend ActiveSupport::Concern

  include FutureProjectsHelper

  def future_projects_data_xls
    xlsx_package = Axlsx::Package.new

    if @message
      wb = xlsx_package.workbook

      wb.add_worksheet(name: "Expedientes_Municipales") do |sheet|
        sheet.add_row [@message]
      end
    else
      if current_user.role.name == 'IPRO+' || current_user.role.name == 'Admin'|| current_user.role.name == 'IPRO+ Plus'
        wb = xlsx_package.workbook
        wb.add_worksheet(name: "Expedientes_Municipales") do |sheet|
          sheet.add_row [
            'X',
            'Y',
            'Código',
            'Dirección',
            'Comuna',
            'Tipo Expediente',
            'Numero Expediente',
            'Fecha Expediente',
            'Rol',
            'Destino',
            'Propietario',
            'Representante Legal',
            'Arquitecto',
            'Altura Pisos',
            'Viviendas',
            'Estacionamientos',
            'Oficinas',
            'Locales',
            'Total m2',
            'Util m2',
            'Terreno m2',
            'Fecha Catastro',
            'Bimestre',
            'Año',
            'Estado'
          ]
          @xl.each do |row|
            sheet.add_row [
              row.the_geom.x,
              row.the_geom.y,
              row.code,
              row.address,
              row.county_name,
              row.future_project_type.name,
              row.file_number,
              row.file_date,
              row.role_number,
              row.name,
              row.owner,
              row.legal_agent,
              row.architect,
              row.floors,
              row.total_units,
              row.total_parking,
              row.t_ofi,
              row.total_commercials,
              row.m2_approved,
              row.m2_built,
              row.m2_field,
              row.cadastral_date,
              row.bimester,
              row.year,
              status_future_project_type(row)
            ]
          end
        end
      end
    end

    xlsx_package
  end
end
