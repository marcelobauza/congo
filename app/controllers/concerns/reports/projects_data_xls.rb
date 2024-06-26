module Reports::ProjectsDataXls
  extend ActiveSupport::Concern

  def projects_data_xls
    xlsx_package = Axlsx::Package.new
    wb           = xlsx_package.workbook

    if @data.blank? || @data.second.blank?
      wb.add_worksheet(name: "Edificios") do |sheet|
        sheet.add_row ['No se encontraron datos']
      end
    else
      if (current_user.role.name == 'IPRO+') || (current_user.role.name == 'IPRO+ Plus') || (current_user.role.name == 'Admin')
        forced_integer_format           = wb.styles.add_style :format_code => '0'
        forced_float_format             = wb.styles.add_style :format_code => '0.0'
        forced_float_format_two_decimal = wb.styles.add_style :format_code => '0.00'
        wb.add_worksheet(name: 'Edificios') do |sheet|
          sheet.add_row [
            'X',
            'Y',
            'Bimestre',
            'Año',
            'Código',
            'Nombre',
            'Dirección',
            'Comuna',
            'Inmobiliaria',
            'Tipo',
            'Pisos',
            'M2-Útil',
            'M2-Terraza',
            'PP Utiles',
            'PP Terraza',
            'Dormitorios',
            'Baños',
            'Estar',
            'Tipo Servicio',
            'Hoffice',
            '% Desc',
            'UF Min %D',
            'UF Max %D',
            'UF Prom %D',
            'PP UF',
            'UF Estacionamiento',
            'UF Bodega',
            'UF/m2 util + t',
            'PP UF/m² ut',
            'UF/m2 util',
            'PP UF/m2 u',
            'Oferta Inicial',
            'Disponible',
            'Venta',
            'Porcentaje Vendido',
            'Venta Mensual Regimen',
            'Venta Mensual Disponible',
            'PxQ R',
            'PxQ D',
            'Estado Obra',
            'Inicio Construccion',
            'Inicio Ventas',
            'Entrega',
            'Catastro',
            'Rango UF',
            'Rango Util'
          ]
          @data.second.each do |row|
            sheet.add_row [
              ('%.6f' % row[:x]).to_f,
              ('%.6f' % row[:y]).to_f,
              row[:bimester],
              row[:year],
              row[:code],
              row[:project_name],
              row[:address],
              row[:county_name],
              row[:agency_name],
              row[:project_type_name],
              row[:floors],
              ("%.1f" %row[:mix_usable_square_meters]).to_f,
              ("%.1f" % row[:mix_terrace_square_meters]).to_f,
              ("%.1f" % row[:pp_utiles]).to_f,
              ("%.1f" % row[:pp_terrazas]).to_f,
              ("%.1f" %row[:bedroom]).to_f,
              row[:bathroom],
              row[:living_room],
              row[:service_room],
              row[:h_office],
              row[:discount] * 100,
              row[:uf_min_percent],
              row[:uf_max_percent],
              row[:uf_avg_percent],
              row[:pp_uf],
              row[:uf_parking],
              row[:uf_cellar],
              ("%.1f" % row[:uf_m2]).to_f,
              ("%.1f" % row[:pp_ufm2ut]).to_f,
              ("%.1f" % row[:uf_m2_u]).to_f,
              ("%.1f" % row[:pp_ufm2u]).to_f,
              row[:total_units],
              row[:stock_units],
              row[:sold_units],
              row[:percentage_sold] * 100,
              ("%.1f" % row[:vhmu]).to_f,
              ("%.1f" % row[:vhmud]).to_f,
              (("%.1f" % row[:pxq]).to_f unless row[:pxq].nil?),
              (("%.1f" % row[:pxq_d]).to_f unless row[:pxq_d].nil?),
              row[:status],
              row[:build_date],
              row[:sale_date],
              row[:transfer_date],
              row[:cadastre],
              row[:range_uf],
              row[:range_util]
            ], :style => [
              nil,
              nil,
              nil,
              nil,
              nil,
              nil,
              nil,
              nil,
              nil,
              nil,
              nil,
              forced_float_format,
              forced_float_format,
              forced_float_format,
              forced_float_format,
              forced_float_format,
              nil,
              nil,
              nil,
              nil,
              nil,
              nil,
              nil,
              nil,
              nil,
              nil,
              nil,
              forced_float_format,
              forced_float_format,
              forced_float_format,
              forced_float_format,
              nil,
              nil,
              nil,
              nil,
              forced_float_format,
              forced_float_format,
              forced_float_format,
              forced_float_format
            ]
          end
        end
      end
    end

    if @data.blank? || (@data.first.blank?)
      wb.add_worksheet(name: "Casas") do |sheet|
        sheet.add_row ['No se encontraron datos']
      end
    else
      wb.add_worksheet(name: 'Casas') do |sheet|
        sheet.add_row [
          'X',
          'Y',
          'Bimestre',
          'Año',
          'Código',
          'Nombre',
          'Dirección',
          'Comuna',
          'Inmobiliaria',
          'Tipo',
          'Modelo',
          'Pisos',
          'Subt.',
          'Adosa',
          'Min. Terreno',
          'Max. Terreno',
          'M2 Utiles',
          'PP Terreno',
          'PP Utiles',
          'Total Dorm.',
          'Total Baños',
          'Estar',
          'Tipo Servicio',
          '% Desc',
          'UF Min %D',
          'UF Max %D',
          'UF Prom %D',
          'PP UF',
          'UF/m2 util + t',
          'PP UF/m² ut',
          'UF/m2 util',
          'PP UF/m2 u',
          'Oferta Inicial',
          'Disponible',
          'Venta',
          'Meses en venta',
          '% Vendido',
          'Venta Mensual Régimen',
          'Venta Mensual Disponible',
          'PxQ R',
          'PxQ D',
          'Estado Obra',
          'Inicio de Construccion',
          'Ventas',
          'Entrega',
          'Catastro',
          'Rango UF',
          'Rango Util'
        ]
        @data.first.each do |row|
          sheet.add_row [
            ('%.6f' % row[:x]).to_f,
            ('%.6f' % row[:y]).to_f,
            row[:bimester],
            row[:year],
            row[:code],
            row[:project_name],
            row[:address],
            row[:county_name],
            row[:agency_name],
            row[:project_type_name],
            row[:model],
            row[:floors],
            row[:sub].to_i,
            row[:home_type],
            ("%.1f" % row[:t_min]).to_f,
            ("%.1f" % row[:t_max]).to_f,
            ("%.1f" % row[:mix_usable_square_meters]).to_f,
            ("%.1f" % row[:pp_terreno]).to_f,
            ("%.1f" % row[:pp_utiles]).to_f,
            ("%.1f" % row[:bedroom]).to_f,
            row[:bathroom],
            row[:living_room],
            row[:service_room],
            row[:discount] * 100,
            row[:uf_min_percent],
            row[:uf_max_percent],
            row[:uf_avg_percent],
            row[:pp_uf].to_i,
            ("%.1f" % row[:uf_m2_ut]).to_f,
            ("%.1f" % row[:pp_ufm2ut]).to_f,
            ("%.1f" % row[:uf_m2_u]).to_f,
            ("%.1f" % row[:pp_ufm2u]).to_f,
            row[:total_units],
            row[:stock_units],
            row[:sold_units],
            row[:months],
            row[:percentage_sold] * 100,
            ("%.1f" % row[:vhmu]).to_f,
            ("%.1f" % row[:vhmud]).to_f,
            ("%.1f" % row[:pxq]).to_f,
            ("%.1f" % row[:pxq_d]).to_f,
            row[:status],
            row[:build_date],
            row[:sale_date],
            row[:transfer_date],
            row[:cadastre],
            row[:range_uf],
            row[:range_util]
          ], :style => [
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            forced_integer_format,
            nil,
            forced_float_format,
            forced_float_format,
            forced_float_format,
            forced_float_format,
            forced_float_format,
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            forced_float_format,
            forced_float_format,
            forced_float_format,
            forced_float_format,
            nil,
            nil,
            nil,
            nil,
            nil,
            forced_float_format,
            forced_float_format,
            forced_float_format,
            forced_float_format
          ]
        end
      end
    end

    xlsx_package
  end
end
