module Reports::TransactionsDataXls
  extend ActiveSupport::Concern

  def transaction_data_xls
    p = Axlsx::Package.new

    if @message
      wb = p.workbook

      wb.add_worksheet(name: "Compraventas") do |sheet|
        sheet.add_row [@message]
      end
    else
      if current_user.role.name == 'MYPE'

        wb = p.workbook
        wb.add_worksheet(name: "Compraventas") do |sheet|
          sheet.add_row [
            'Tipo',
            'Dirección',
            'Comuna',
            'Rol',
            'Rol1',
            'Rol2',
            'Foja',
            'Numero',
            'Fecha',
            'Tipo Vendedor',
            'UF',
            'uf_m2_u',
            'Est.',
            'Bod.',
            'sup.t_te',
            'Sup_l_cons',
            'Año Construccion',
          ]
          @xl.each do |row|
            sheet.add_row [
              row.property_type_name,
              row.address,
              row.county_name,
              row.role,
              row.role_1,
              row.role_2,
              row.sheet,
              row.number,
              row.inscription_date,
              row.seller_type_name,
              row.calculated_value,
              row.uf_m2_u,
              row.parkingi,
              row.cellar,
              row.total_surface_terrain,
              row.total_surface_building,
              row.year_sii,
            ]
          end
        end
      else
        if current_user.role.name == 'IPRO+' || current_user.role.name == 'Admin' || current_user.role.name == 'IPRO+ Plus' || current_user.role.name == 'PRO_FLEX'
          wb = p.workbook
          wb.add_worksheet(name: "Compraventas") do |sheet|
            sheet.add_row [
              'X',
              'Y',
              'Tipo',
              'Dirección',
              'Comuna',
              'Depto',
              'Plano',
              'Rol',
              'Rol1',
              'Rol2',
              'Foja',
              'Numero',
              'Fecha',
              'Comprador',
              'Tipo Vendedor',
              'Vendedor',
              'UF',
              'Est.',
              'Bod.',
              'sup.t_te',
              'Sup_l_cons',
              'uf_m2_u',
              'uf_m2_t',
              'Bimestre',
              'Año',
              'Codigo Destino',
              'Codigo Material',
              'Año Construccion',
              'Observaciones'
            ]
            @xl.each do |row|
              sheet.add_row [
                row.the_geom.x,
                row.the_geom.y,
                row.property_type_name,
                row.address,
                row.county_name,
                row.department,
                row.blueprint,
                row.role,
                row.role_1,
                row.role_2,
                row.sheet,
                row.number,
                row.inscription_date,
                row.buyer_name,
                row.seller_type_name,
                row.seller_name,
                row.calculated_value,
                row.parkingi,
                row.cellar,
                row.total_surface_terrain,
                row.total_surface_building,
                row.uf_m2_u,
                row.uf_m2_t,
                row.bimester,
                row.year,
                row.code_destination,
                row.code_material,
                row.year_sii,
                row.comments
              ]
            end
          end
          wb.add_worksheet(name: "Codigos SII") do |code|
            code.add_row ['Destinos']
            code.add_row ['Abreviatura', 'Descripción']
            code.add_row ['A', 'AGRICOLA']
            code.add_row ['B', 'AGRICOLA POR ASIMILACION']
            code.add_row ['C', 'COMERCIO']
            code.add_row ['D', 'DEPORTE Y RECREACION']
            code.add_row ['E', 'EDUCACION CULTURA']
            code.add_row ['F', 'FORESTAL']
            code.add_row ['G', 'HOTEL MOTEL']
            code.add_row ['H', 'HABITACIONAL']
            code.add_row ['I', 'INDUSTRIA']
            code.add_row ['K', 'BIENES COMUNES']
            code.add_row ['L', 'BODEGA Y ALMACENAJE']
            code.add_row ['M', 'MINERIA']
            code.add_row ['O', 'OFICINA']
            code.add_row ['P', 'ADMINISTRACION PUBLICA Y DEFENSA']
            code.add_row ['Q', 'CULTO']
            code.add_row ['S', 'SALUD']
            code.add_row ['T', 'TRANSPORTE Y TELECOMUNICACIONES']
            code.add_row ['V', 'OTROS NO CONSIDERADOS']
            code.add_row ['W', 'SITIO ERIAZO']
            code.add_row ['Y', 'GALLINEROS, CHANCHERAS Y OTROS']
            code.add_row ['Z', 'ESTACIONAMIENTO']
            code.add_row []
            code.add_row ['Materiales']
            code.add_row ['Abreviatura', 'Descripción']
            code.add_row ['GA', 'Acero']
            code.add_row ['GB', 'Hormigón Armado']
            code.add_row ['GC', 'Albañilería ']
            code.add_row ['GE', 'Madera']
            code.add_row ['GL', 'Madera Laminada']
            code.add_row ['GF', 'Adobe']
            code.add_row ['OA', 'Acero']
            code.add_row ['OB', 'Hormigón Armado']
            code.add_row ['OE', 'Madera']
            code.add_row ['SA', 'Silo de Acero']
            code.add_row ['SB', 'Silo de Hormigón Armado']
            code.add_row ['EA', 'Estanque de Acero']
            code.add_row ['EB', 'Estanque de Hormigón Armado']
            code.add_row ['M', 'Marquesina']
            code.add_row ['P', 'Pavimento']
            code.add_row ['W', 'Piscina']
            code.add_row ['TA', 'Techumbre Apoyada de Acero']
            code.add_row ['TE', 'Techumbre Apoyada de Madera']
            code.add_row ['TL', 'Techumbre Apoyada de Madera Laminada']
            code.add_row ['A', 'AceroA  en tubos y perfiles']
            code.add_row ['B', 'Hormigón armado.']
            code.add_row ['C', 'Albañilería de ladrillo de arcilla, piedra, bloque de cemento u hormigón celular']
            code.add_row ['E', 'Madera']
            code.add_row ['F', 'Adobe']
            code.add_row ['G', 'Perfiles metálicos']
            code.add_row ['K', 'Estructura con elementos prefabricados e industrializados']
          end
        end
      end
    end

    p
  end
end
