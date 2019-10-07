class Censu < ApplicationRecord
  belongs_to :census_source
  belongs_to :county


  def self.average_people_by_home(filters)

    conditions = "census.census_source_id = 1"
    #    conditions += "#{Util.and}census.county_id IN(#{User.current.county_ids.join(",")})" if User.current.county_ids.length > 0
    select = "SUM(home_tot) as homes_total, SUM(age_tot) as people_total,
                                          (SUM(age_tot) / cast(SUM(home_tot) as float)) as people_avg"
    @data = Censu.where(filter_area_conditions(filters)).where(conditions).select(select).take
  end

  def  self.filter_area_conditions(filters)

    if !filters[:county_id].nil?
      conditions = WhereBuilder.build_in_condition("county_id",filters[:county_id])
    elsif !filters[:wkt].nil?
      conditions = WhereBuilder.build_within_condition(filters[:wkt])
      else
        conditions = WhereBuilder.build_within_condition_radius(filters[:centerpt], filters[:radius] )
      end
    conditions
  end

  def self.education_levels(filters)
        select = "SUM(basica) AS basica, SUM(media) AS media,  SUM(media_tec) AS media_tec, SUM(tecnica) AS tecnica, SUM(profesional) AS profesional, SUM(magister) AS magister, sum(doctor) as doctor"
    @data = Censu.where(filter_area_conditions(filters)).select(select).take
    end


  def self.civil_status(filters)
        select = "SUM(separated) AS separated, SUM(widowed) AS widowed,  SUM(single) AS single, SUM(married) AS married, SUM(coexist) as coexist, sum(canceled) as canceled"
    @data = Censu.where(filter_area_conditions(filters)).select(select).take

  end

  def self.gse(filters)
        select = "SUM(n_abc1) AS abc1, SUM(n_c2) AS c2,  SUM(n_c3) AS c3, SUM(n_d) AS d, SUM(n_e) as e"
        @data = Censu.where(filter_area_conditions(filters)).select(select).take

  end

  def self.age(filters)
        select = "SUM(age_0_9) AS age_0_9, SUM(age_10_19) AS age_10_19,  SUM(age_20_29) AS age_20_29, SUM(age_30_39) AS age_30_39, SUM(age_40_49) as age_40_49, "
        select += " SUM(age_50_59) AS age_50_59, SUM(age_60_69) AS age_60_69,  SUM(age_70_79) AS age_70_79, SUM(age_80_more) AS age_80_more"
    @data = Censu.where(filter_area_conditions(filters)).select(select).take

  end

  def self.homes(filters)
        select = "SUM(home_1p) AS home_1p, SUM(home_2p) AS home_2p,  SUM(home_3p) AS home_3p, SUM(home_4p) AS home_4p, "
        select += " SUM(home_5p) as home_5p, SUM(home_6_more) as  "
    @data = Censu.where(filter_area_conditions(filters)).select(select).take
  end

  def self.professions(filters)
    select = "SUM(salaried) as salaried, SUM(domestic_service) as domestic_service, SUM(independent) as independent, SUM(employee_employer) as employee_employer, SUM(unpaid_familiar) as unpaid_familiar"
    @data = Censu.where(filter_area_conditions(filters)).select(select).take
  end

  def self.property_tenure(filters)
    select = "SUM(owner) as owner, SUM(leased) as leased , SUM(transferred) as transferred , SUM(free) as free , SUM(possesion) as possesion "
    @data = Censu.where(filter_area_conditions(filters)).select(select).take
  end

  def self.summary(params)

    result=[]
    data =[]
    people_by_home = average_people_by_home(params)
    homes_total = (people_by_home.nil? or people_by_home[:homes_total].nil?)? 0.0 : people_by_home[:homes_total]
    people_total = (people_by_home.nil? or people_by_home[:people_total].nil?)? 0.0 : people_by_home[:people_total]
    homes_avg = (people_by_home.nil? or people_by_home[:homes_avg].nil?)? 0.0 : people_by_home[:homes_avg]
    people_avg = (people_by_home.nil? or people_by_home[:people_avg].nil?)? 0.0 : people_by_home[:people_avg]

    data = [
      {:name => I18n.t(:HOMES_TOTAL), :count => NumberFormatter.format(homes_total, false)},
      {:name => I18n.t(:PEOPLE_TOTAL), :count => NumberFormatter.format(people_total, false)},
      {:name => I18n.t(:HOMES_AVG), :count => NumberFormatter.format(homes_avg, true)},
      {:name => I18n.t(:PEOPLE_AVG), :count => NumberFormatter.format(people_avg, true)},
    ]
    result.push({"title":"Resumen","data": data})

    # Variable
    @census_sources = CensusSource.all
    result.push("title":"Variable","data": @census_sources)

    data =[]
    @education_levels = education_levels(params)

    data = [
      {name: "Básica", count: @education_levels.basica},
      {name: "Media", count: @education_levels.media},
      {name: "Media Técnica", count: @education_levels.media_tec},
      {name: "Técnica", count: @education_levels.tecnica},
      {name: "Profesional", count: @education_levels.profesional},
      {name: "Magíster", count: @education_levels.magister},
      {name: "Doctor", count: @education_levels.doctor}
    ]

    result.push({"title":"Nivel Educacional","data": data})

  @civil_status = civil_status(params)

    data =[
      {name: "Solteros/as", count: @civil_status.single},
      {name: "Casados/as", count: @civil_status.married},
      {name: "Separados/as", count: @civil_status.separated},
      {name: "Viudos/as", count: @civil_status.widowed},
      {name: "Conviven", count: @civil_status.coexist},
      {name: "Anulados/as", count: @civil_status.canceled}
    ]

    result.push({"title":"Estado Civil","data": data})

  @gse = gse(params)
    data =[
      {name: "abc", count: @gse.abc1},
      {name: "c2", count: @gse.c2},
      {name: "c3", count: @gse.c3},
      {name: "d", count: @gse.d},
      {name: "e", count: @gse.e}
    ]

    result.push({"title":"Segmentación Socioeconómica","data": data})

    @age = age(params)
    data =[
      {name: "0-9", count: @age.age_0_9},
      {name: "10-19", count: @age.age_10_19},
      {name: "20-29", count: @age.age_20_29},
      {name: "30-39", count: @age.age_30_39},
      {name: "40-49", count: @age.age_40_49},
      {name: "50-59", count: @age.age_50_59},
      {name: "60-69", count: @age.age_60_69},
      {name: "70-79", count: @age.age_70_79},
      {name: "+80", count: @age.age_80_more}
    ]

    result.push({"title":"Rangos Etáreos","data": data})

    @homes= age(params)
    data =[
      {name: "1 pers.", count: @homes.age_0_9},
      {name: "2 pers.", count: @homes.age_10_19},
      {name: "3 pers.", count: @homes.age_20_29},
      {name: "4 pers.", count: @homes.age_30_39},
      {name: "5 pers.", count: @homes.age_40_49},
      {name: "+6 pers.", count: @homes.age_50_59}
    ]

    result.push({"title":"Hogares Según Tamaño","data": data})

    @professions = professions(params)

    data = [
      {name: "Asalariado", count: @professions.salaried },
      {name: "Servicio Doméstico", count: @professions.domestic_service },
      {name: "Independiente", count: @professions.independent },
      {name: "Empleado o Empleador", count: @professions.employee_employer },
      {name: "Familiar No Remunerado", count: @professions.unpaid_familiar }
    ]
    result.push({"title":"Situación Laboral","data": data})

    @property_tenure = property_tenure(params)
    data = [
      {name: "Propietario", count: @property_tenure.owner },
      {name: "Arrendatario", count: @property_tenure.leased },
      {name: "Transferida", count: @property_tenure.transferred },
      {name: "Gratuita", count: @property_tenure.free },
      {name: "Cedida", count: @property_tenure.possesion }
    ]
    result.push({"title":"Propiedad y Tenencia", "data": data})

result
  end


end
