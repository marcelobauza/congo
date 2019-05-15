# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_05_09_051257) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "postgis_topology"

  create_table "counties", id: :integer, default: nil, force: :cascade do |t|
    t.geometry "the_geom", limit: {:srid=>4326, :type=>"multi_polygon"}
    t.string "name"
    t.integer "code"
    t.string "state"
    t.string "transaction_data"
    t.string "demography_data"
    t.string "legislation_data"
    t.string "sales_project_data"
    t.string "created_at"
    t.string "updated_at"
    t.string "simple_geom"
    t.string "future_project_data"
    t.string "commercial_project_data"
    t.float "rate"
    t.string "zip_file_file_name"
    t.string "zip_file_content_type"
    t.integer "zip_file_file_size"
    t.string "zip_file_updated_at"
    t.integer "code_sii"
    t.integer "number_last_project_future"
    t.index ["the_geom"], name: "sidx_counties_the_geom", using: :gist
  end

  create_table "county_ufs", force: :cascade do |t|
    t.bigint "county_id"
    t.bigint "property_type_id"
    t.decimal "uf_min"
    t.decimal "uf_max"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_county_ufs_on_county_id"
    t.index ["property_type_id"], name: "index_county_ufs_on_property_type_id"
  end

  create_table "future_project_types", force: :cascade do |t|
    t.string "name"
    t.string "abbrev"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "future_projects", force: :cascade do |t|
    t.string "code"
    t.string "address"
    t.string "name"
    t.string "role_number"
    t.string "file_number"
    t.date "file_date"
    t.string "owner"
    t.string "legal_agent"
    t.string "architect"
    t.integer "floors"
    t.integer "undergrounds"
    t.integer "total_units"
    t.integer "total_parking"
    t.integer "total_commercials"
    t.decimal "m2_approved"
    t.decimal "m2_built"
    t.decimal "m2_field"
    t.date "cadastral_date"
    t.string "comments"
    t.integer "bimester"
    t.integer "year"
    t.string "cadastre"
    t.boolean "active"
    t.bigint "project_type_id"
    t.bigint "future_project_type_id"
    t.bigint "county_id"
    t.geometry "the_geom", limit: {:srid=>0, :type=>"st_point"}
    t.integer "t_ofi"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_future_projects_on_county_id"
    t.index ["future_project_type_id"], name: "index_future_projects_on_future_project_type_id"
    t.index ["project_type_id"], name: "index_future_projects_on_project_type_id"
  end

  create_table "layer_types", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "periods", force: :cascade do |t|
    t.integer "bimester"
    t.integer "year"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_instance_mixes", force: :cascade do |t|
    t.bigint "project_instance_id"
    t.bigint "mix_id"
    t.decimal "percentage", default: "0.0"
    t.integer "stock_units"
    t.decimal "mix_m2_field"
    t.decimal "mix_m2_built"
    t.decimal "mix_usable_square_meters"
    t.decimal "mix_terrace_square_meters"
    t.decimal "mix_uf_m2"
    t.decimal "mix_selling_speed"
    t.decimal "mix_uf_value"
    t.integer "living_room"
    t.string "service_room"
    t.integer "h_office"
    t.decimal "discount"
    t.decimal "uf_min"
    t.decimal "uf_max"
    t.decimal "uf_parking"
    t.decimal "uf_cellar"
    t.decimal "common_expenses"
    t.decimal "withdrawal_percent"
    t.integer "total_units"
    t.decimal "t_min"
    t.decimal "t_max"
    t.string "home_type"
    t.string "model"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mix_id"], name: "index_project_instance_mixes_on_mix_id"
    t.index ["project_instance_id"], name: "index_project_instance_mixes_on_project_instance_id"
  end

  create_table "project_instances", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "project_status_id"
    t.integer "bimester"
    t.integer "year"
    t.boolean "active", default: true
    t.string "comments"
    t.string "cadastre"
    t.boolean "validated", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_instances_on_project_id"
    t.index ["project_status_id"], name: "index_project_instances_on_project_status_id"
  end

  create_table "project_mixes", force: :cascade do |t|
    t.decimal "bedroom"
    t.integer "bathroom"
    t.string "mix_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_types", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "address"
    t.integer "floors", default: 0
    t.bigint "county_id"
    t.bigint "agency_id"
    t.bigint "project_type_id"
    t.geometry "the_geom", limit: {:srid=>0, :type=>"st_point"}
    t.string "build_date"
    t.string "sale_date"
    t.string "transfer_date"
    t.string "pilot_opening_date"
    t.integer "quantity_department_for_floor"
    t.integer "elevators"
    t.text "general_observation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_projects_on_agency_id"
    t.index ["county_id"], name: "index_projects_on_county_id"
    t.index ["project_type_id"], name: "index_projects_on_project_type_id"
  end

  create_table "property_types", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "seller_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", id: :serial, force: :cascade do |t|
    t.integer "property_type_id"
    t.string "address", limit: 255
    t.integer "sheet"
    t.integer "number"
    t.date "inscription_date"
    t.string "buyer_name", limit: 255
    t.integer "seller_type_id"
    t.string "department", limit: 255
    t.string "blueprint", limit: 255
    t.decimal "real_value"
    t.decimal "calculated_value"
    t.integer "quarter"
    t.integer "year"
    t.decimal "sample_factor", default: "1.0"
    t.integer "county_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.geometry "the_geom", limit: {:srid=>4326, :type=>"st_point"}
    t.integer "cellar", default: 0
    t.integer "parking", default: 0
    t.string "role", limit: 255
    t.string "seller_name", limit: 255
    t.string "buyer_rut", limit: 255
    t.decimal "uf_m2"
    t.integer "tome"
    t.string "lot", limit: 255
    t.string "block", limit: 255
    t.string "village", limit: 255
    t.decimal "surface"
    t.string "requiring_entity", limit: 255
    t.text "comments"
    t.integer "user_id"
    t.integer "surveyor_id"
    t.boolean "active", default: true
    t.integer "bimester"
    t.integer "code_sii"
    t.decimal "total_surface_building", precision: 8, scale: 2
    t.decimal "total_surface_terrain", precision: 8, scale: 2
    t.decimal "uf_m2_u", precision: 8, scale: 2
    t.decimal "uf_m2_t", precision: 8, scale: 2
    t.string "building_regulation", limit: 250
    t.string "role_1", limit: 255
    t.string "role_2", limit: 255
    t.text "code_destination"
    t.text "code_material"
    t.text "year_sii"
    t.string "role_associated"
    t.index ["property_type_id", "seller_type_id", "user_id"], name: "idx_transaction", order: "NULLS FIRST"
    t.index ["role"], name: "rol_number", order: "NULLS FIRST"
  end

  create_table "transactions_new", id: :bigint, default: -> { "nextval('transactions_id_seq'::regclass)" }, force: :cascade do |t|
    t.bigint "property_type_id"
    t.string "address"
    t.integer "sheet"
    t.integer "number"
    t.date "inscription_date"
    t.string "buyer_name"
    t.bigint "seller_type_id"
    t.string "department"
    t.string "blueprint"
    t.decimal "uf_value"
    t.decimal "real_value"
    t.decimal "calculated_value"
    t.date "quarter"
    t.date "quarter_date"
    t.integer "year"
    t.decimal "sample_factor", precision: 8, scale: 2
    t.bigint "county_id"
    t.geometry "the_geom", limit: {:srid=>4326, :type=>"st_point"}
    t.integer "cellar", default: 0
    t.integer "parkingi", default: 0
    t.string "role"
    t.string "seller_name"
    t.string "buyer_rut"
    t.decimal "uf_m2"
    t.integer "tome"
    t.string "lot"
    t.string "block"
    t.string "village"
    t.decimal "surface", precision: 8, scale: 2
    t.string "requiring_entity"
    t.string "comments"
    t.bigint "user_id"
    t.integer "surveyor_id"
    t.boolean "active", default: true
    t.integer "bimester"
    t.integer "code_sii"
    t.decimal "total_surface_building", precision: 8, scale: 2
    t.decimal "total_surface_terrain", precision: 8, scale: 2
    t.decimal "uf_m2_u", precision: 8, scale: 2
    t.decimal "uf_m2_t", precision: 8, scale: 2
    t.string "building_regulation"
    t.string "role_1"
    t.string "role_2"
    t.string "code_destination"
    t.string "code_material"
    t.string "year_sii"
    t.string "role_associated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_transactions_on_county_id"
    t.index ["property_type_id"], name: "index_transactions_on_property_type_id"
    t.index ["seller_type_id"], name: "index_transactions_on_seller_type_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "complete_name"
    t.string "company"
    t.string "city"
    t.string "token"
    t.boolean "is_temporal", default: false
    t.boolean "disabled"
    t.string "rut"
    t.string "phone"
    t.string "address"
    t.integer "role_id"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "county_ufs", "counties"
  add_foreign_key "county_ufs", "property_types"
  add_foreign_key "future_projects", "counties"
  add_foreign_key "future_projects", "future_project_types"
  add_foreign_key "future_projects", "project_types"
  add_foreign_key "project_instance_mixes", "project_instances"
  add_foreign_key "project_instances", "project_statuses"
  add_foreign_key "project_instances", "projects"

  create_function :masud, sql_definition: <<-SQL
      CREATE OR REPLACE FUNCTION public.masud(total_units integer, stock_units integer, cadastre character varying, sale_date character varying)
       RETURNS real
       LANGUAGE plpgsql
      AS $function$
      DECLARE m int;
      BEGIN
        m = months2(cadastre, sale_date);
        RETURN ( SELECT CASE (total_units - stock_units) WHEN 0 THEN 0 
        ELSE CASE m WHEN 0 THEN null
        ELSE (stock_units / ((total_units - stock_units)::double precision /m)) END
                                                      END) as masud;

                                                  END;
                                                  $function$
  SQL
  create_function :months2, sql_definition: <<-SQL
      CREATE OR REPLACE FUNCTION public.months2(cadastre character varying, sale_date character varying)
       RETURNS real
       LANGUAGE plpgsql
      AS $function$
      BEGIN
        
      	RETURN (select (date_part('year', to_date(cadastre, 'DD/MM/YYYY')) - date_part('year', to_date(sale_date, 'DD/MM/YYYY'))) * 12 +
      (date_part('month', to_date(cadastre, 'DD/MM/YYYY')) - date_part('month', to_date(sale_date, 'DD/MM/YYYY'))));

      END;
      $function$
  SQL
  create_function :pp_utiles, sql_definition: <<-SQL
      CREATE OR REPLACE FUNCTION public.pp_utiles(proj_instance_id bigint)
       RETURNS real
       LANGUAGE plpgsql
      AS $function$
      declare disp int;
      BEGIN
        disp = (select sum(pim.stock_units)
          from project_instance_mixes pim
          where pim.project_instance_id = proj_instance_id);

        if (disp = 0) then
          return 0;
        else
          RETURN (select sum(pim.mix_usable_square_meters * pim.stock_units)/disp::int 
            as pp_utiles
            from project_instance_mixes pim
            where pim.project_instance_id = proj_instance_id);
        end if;
                                          END;
                                          $function$
  SQL
  create_function :vhmu, sql_definition: <<-SQL
      CREATE OR REPLACE FUNCTION public.vhmu(total_units integer, stock_units integer, cadastre character varying, sale_date character varying)
       RETURNS real
       LANGUAGE plpgsql
      AS $function$
      DECLARE m int;
      BEGIN

        m = months2(cadastre, sale_date);
        RETURN (  SELECT CASE m WHEN 0 THEN 1
        ELSE (total_units - stock_units) / m::numeric END) as vhmu;
        END;
      $function$
  SQL

  create_trigger :layer_integrity_checks, sql_definition: <<-SQL
      CREATE TRIGGER layer_integrity_checks BEFORE DELETE OR UPDATE ON topology.layer FOR EACH ROW EXECUTE PROCEDURE topology.layertrigger()
  SQL

  create_view "counties_info", sql_definition: <<-SQL
      SELECT counties.id,
      counties.name,
      counties.the_geom
     FROM counties;
  SQL
  create_view "future_projects_info", sql_definition: <<-SQL
      SELECT future_projects.id,
      future_projects.code,
      future_projects.address,
      future_projects.name,
      future_projects.role_number,
      future_projects.file_number,
      future_projects.file_date,
      future_projects.owner,
      future_projects.legal_agent,
      future_projects.architect,
      future_projects.floors,
      future_projects.undergrounds,
      future_projects.total_units,
      future_projects.total_parking,
      future_projects.total_commercials,
      future_projects.m2_approved,
      future_projects.m2_built,
      future_projects.m2_field,
      future_projects.cadastral_date,
      future_projects.comments,
      future_projects.bimester,
      future_projects.year,
      future_projects.cadastre,
      future_projects.active,
      future_projects.project_type_id,
      future_projects.future_project_type_id,
      future_projects.county_id,
      future_projects.the_geom,
      future_projects.t_ofi,
      future_projects.created_at,
      future_projects.updated_at
     FROM future_projects;
  SQL
  create_view "project_instance_mix_views", sql_definition: <<-SQL
      SELECT pim.project_instance_id,
      (pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) AS uf_min_percent,
      (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric))) AS uf_max_percent,
      (((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) AS uf_avg_percent,
      (pim.mix_usable_square_meters * (pim.total_units)::numeric) AS total_m2,
      (pim.mix_usable_square_meters + (pim.mix_terrace_square_meters * 0.5)) AS u_half_terrace,
      ((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) / (pim.mix_usable_square_meters + (pim.mix_terrace_square_meters * 0.5))) AS uf_m2,
      (((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric))::double precision / ((pim.mix_usable_square_meters)::double precision + ((((pim.t_min + pim.t_max))::double precision / (2)::double precision) * (0.25)::double precision))) AS uf_m2_home,
      ((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) / pim.mix_usable_square_meters) AS uf_m2_u,
      (vhmu(pim.total_units, pim.stock_units, pi.cadastre, p.sale_date))::numeric AS vhmu,
      ((pim.stock_units)::numeric * pim.mix_usable_square_meters) AS dis_m2,
      masud(pim.total_units, pim.stock_units, pi.cadastre, p.sale_date) AS masud,
          CASE masud(pim.total_units, pim.stock_units, pi.cadastre, p.sale_date)
              WHEN 0 THEN (0)::real
              ELSE vhmu(pim.total_units, pim.stock_units, pi.cadastre, p.sale_date)
          END AS vhmud,
      (pim.total_units - pim.stock_units) AS sold_units,
      pim.id,
      (((pim.t_min + pim.t_max))::double precision / (2)::double precision) AS ps_terreno,
      pim.stock_units,
      pim.total_units,
      pim.mix_terrace_square_meters,
      pim.mix_usable_square_meters,
      pim.t_min,
      pim.t_max,
      p.county_id,
      p.id AS project_id,
      p.the_geom,
      pi.year,
      pi.bimester,
      pi.project_status_id,
      p.project_type_id,
      pim.mix_id,
      p.name,
      pp_utiles(pi.id) AS pp_utiles,
      p.floors,
      p.agency_id
     FROM ((project_instance_mixes pim
       JOIN project_instances pi ON ((pim.project_instance_id = pi.id)))
       JOIN projects p ON ((pi.project_id = p.id)));
  SQL
  create_view "project_instance_mix_views_anterior", sql_definition: <<-SQL
      SELECT pim.project_instance_id,
      (pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) AS uf_min_percent,
      (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric))) AS uf_max_percent,
      (((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) AS uf_avg_percent,
      (pim.mix_usable_square_meters * (pim.total_units)::numeric) AS total_m2,
      (pim.mix_usable_square_meters + (pim.mix_terrace_square_meters * 0.5)) AS u_half_terrace,
      ((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) / (pim.mix_usable_square_meters + (pim.mix_terrace_square_meters * 0.5))) AS uf_m2,
      (((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric))::double precision / ((pim.mix_usable_square_meters)::double precision + ((((pim.t_min + pim.t_max))::double precision / (2)::double precision) * (0.25)::double precision))) AS uf_m2_home,
      ((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) / pim.mix_usable_square_meters) AS uf_m2_u,
      (vhmu(pim.total_units, pim.stock_units, pi.cadastre, p.sale_date))::numeric AS vhmu,
      ((pim.stock_units)::numeric * pim.mix_usable_square_meters) AS dis_m2,
      masud(pim.total_units, pim.stock_units, pi.cadastre, p.sale_date) AS masud,
          CASE masud(pim.total_units, pim.stock_units, pi.cadastre, p.sale_date)
              WHEN 0 THEN (0)::real
              ELSE vhmu(pim.total_units, pim.stock_units, pi.cadastre, p.sale_date)
          END AS vhmud,
      (pim.total_units - pim.stock_units) AS sold_units,
      pim.id,
      (((pim.t_min + pim.t_max))::double precision / (2)::double precision) AS ps_terreno,
      pim.stock_units,
      pim.total_units,
      pim.mix_terrace_square_meters,
      pim.mix_usable_square_meters,
      pim.t_min,
      pim.t_max,
      p.county_id,
      p.id AS project_id,
      p.the_geom,
      pi.year,
      pi.bimester,
      pi.project_status_id,
      p.project_type_id
     FROM ((project_instance_mixes pim
       JOIN project_instances pi ON ((pim.project_instance_id = pi.id)))
       JOIN projects p ON ((pi.project_id = p.id)));
  SQL
  create_view "project_instance_views", sql_definition: <<-SQL
      SELECT pi.id,
      pi.project_id,
      pi.project_status_id,
      pi.bimester,
      pi.year,
      pi.active,
      pi.comments,
      pi.cadastre,
      ( SELECT sum(project_instance_mix_views.stock_units) AS sum
             FROM project_instance_mix_views_anterior project_instance_mix_views
            WHERE (project_instance_mix_views.project_instance_id = pi.id)) AS stock_units,
      ( SELECT
                  CASE sum(project_instance_mix_views.vhmu)
                      WHEN 0 THEN (0)::numeric
                      ELSE (sum((project_instance_mix_views.uf_avg_percent * project_instance_mix_views.vhmu)) / sum(project_instance_mix_views.vhmu))
                  END AS sum
             FROM project_instance_mix_views_anterior project_instance_mix_views
            WHERE (project_instance_mix_views.project_instance_id = pi.id)) AS uf_value,
      ( SELECT
                  CASE
                      WHEN (sum(project_instance_mix_views.uf_m2) IS NULL) THEN round((sum((project_instance_mix_views.total_m2 * (project_instance_mix_views.uf_m2_home)::numeric)) / sum(project_instance_mix_views.total_m2)), 1)
                      ELSE round((sum((project_instance_mix_views.total_m2 * project_instance_mix_views.uf_m2)) / sum(project_instance_mix_views.total_m2)), 1)
                  END AS sum
             FROM project_instance_mix_views
            WHERE (project_instance_mix_views.project_instance_id = pi.id)) AS uf_m2,
      ( SELECT sum(project_instance_mix_views.vhmu) AS sum
             FROM project_instance_mix_views_anterior project_instance_mix_views
            WHERE (project_instance_mix_views.project_instance_id = pi.id)) AS selling_speed,
      ( SELECT
                  CASE sum(project_instance_mix_views.vhmu)
                      WHEN 0 THEN (0)::numeric
                      ELSE (sum((project_instance_mix_views.mix_usable_square_meters * project_instance_mix_views.vhmu)) / sum(project_instance_mix_views.vhmu))
                  END AS "case"
             FROM project_instance_mix_views_anterior project_instance_mix_views
            WHERE (project_instance_mix_views.project_instance_id = pi.id)) AS usable_square_meters,
      ( SELECT
                  CASE sum(project_instance_mix_views.vhmu)
                      WHEN 0 THEN (0)::numeric
                      ELSE (sum((project_instance_mix_views.mix_terrace_square_meters * project_instance_mix_views.vhmu)) / sum(project_instance_mix_views.vhmu))
                  END AS "case"
             FROM project_instance_mix_views_anterior project_instance_mix_views
            WHERE (project_instance_mix_views.project_instance_id = pi.id)) AS terrace_square_meters
     FROM project_instances pi;
  SQL
  create_view "projects_feature_info", sql_definition: <<-SQL
      SELECT projects.id,
      projects.address,
      projects.name AS project_name,
      project_statuses.name AS status_name,
      sum(project_instance_mixes.total_units) AS total_units,
      sum(project_instance_mixes.stock_units) AS stock_units,
      sum((project_instance_mixes.total_units - project_instance_mixes.stock_units)) AS sold_units,
      projects.floors,
      round(project_instance_views.uf_m2, 1) AS uf_m2,
      round(project_instance_views.uf_value, 1) AS uf_value,
      round(project_instance_views.selling_speed, 1) AS selling_speed,
      round((((1)::numeric - ((sum(project_instance_mixes.stock_units))::numeric / sum((project_instance_mixes.total_units)::numeric))) * (100)::numeric), 1) AS percentage_sold,
      project_instance_views.id AS project_instance_id,
      round(project_instance_views.usable_square_meters, 1) AS usable_square_meters,
      round(project_instance_views.terrace_square_meters, 1) AS terrace_square_meters,
      round(sum(project_instance_mixes.mix_m2_field), 1) AS m2_field,
      round(sum(project_instance_mixes.mix_m2_built), 1) AS m2_built,
      project_instance_mixes.home_type,
      project_instances.bimester,
      project_instances.year,
      projects.the_geom,
      projects.build_date,
      projects.sale_date,
      projects.transfer_date,
      projects.pilot_opening_date,
      project_instances.comments
     FROM ((((project_instances
       JOIN project_instance_views ON ((project_instances.id = project_instance_views.id)))
       JOIN project_instance_mixes ON ((project_instances.id = project_instance_mixes.project_instance_id)))
       JOIN projects ON ((projects.id = project_instances.project_id)))
       JOIN project_statuses ON ((project_instances.project_status_id = project_statuses.id)))
    GROUP BY projects.id, projects.address, projects.name, project_statuses.name, project_instance_views.uf_m2, project_instance_views.uf_value, project_instance_views.selling_speed, project_instance_views.id, project_instance_mixes.home_type, project_instances.bimester, project_instances.year, projects.the_geom, projects.build_date, projects.sale_date, projects.transfer_date, projects.pilot_opening_date, project_instances.comments, projects.floors, project_instance_views.usable_square_meters, project_instance_views.terrace_square_meters;
  SQL
  create_view "transactions_info", sql_definition: <<-SQL
      SELECT transactions.id,
      transactions.property_type_id,
      transactions.address,
      transactions.sheet,
      transactions.number,
      transactions.inscription_date,
      transactions.buyer_name,
      transactions.seller_type_id,
      transactions.department,
      transactions.blueprint,
      transactions.real_value,
      transactions.calculated_value,
      transactions.quarter,
      transactions.year,
      transactions.sample_factor,
      transactions.county_id,
      transactions.created_at,
      transactions.updated_at,
      transactions.the_geom,
      transactions.cellar,
      transactions.parking,
      transactions.role,
      transactions.seller_name,
      transactions.buyer_rut,
      transactions.uf_m2,
      transactions.tome,
      transactions.lot,
      transactions.block,
      transactions.village,
      transactions.surface,
      transactions.requiring_entity,
      transactions.comments,
      transactions.user_id,
      transactions.surveyor_id,
      transactions.active,
      transactions.bimester,
      transactions.code_sii,
      transactions.total_surface_building,
      transactions.total_surface_terrain,
      transactions.uf_m2_u,
      transactions.uf_m2_t,
      transactions.building_regulation,
      transactions.role_1,
      transactions.role_2,
      transactions.code_destination,
      transactions.code_material,
      transactions.year_sii,
      transactions.role_associated
     FROM transactions;
  SQL
end
