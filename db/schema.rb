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

ActiveRecord::Schema.define(version: 2021_10_06_193957) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "postgis_topology"

  create_table "agencies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "agency_rols", force: :cascade do |t|
    t.string "rol"
    t.integer "project_id"
    t.bigint "agency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_agency_rols_on_agency_id"
  end

  create_table "application_statuses", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "user_id"
    t.text "polygon"
    t.bigint "layer_type_id"
    t.jsonb "filters"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["layer_type_id"], name: "index_application_statuses_on_layer_type_id"
    t.index ["user_id"], name: "index_application_statuses_on_user_id"
  end

  create_table "bots", force: :cascade do |t|
    t.date "publish"
    t.string "code"
    t.string "property_status"
    t.string "modality"
    t.string "properties"
    t.string "region"
    t.bigint "county_id"
    t.string "comune"
    t.string "street"
    t.string "number"
    t.string "furnished"
    t.string "apt"
    t.integer "floor"
    t.integer "bedroom"
    t.integer "bathroom"
    t.string "parking_lo"
    t.string "cellar"
    t.decimal "surface", precision: 12, scale: 2
    t.decimal "surface_t", precision: 12, scale: 2
    t.decimal "price", precision: 12, scale: 2
    t.decimal "price_uf", precision: 12, scale: 2
    t.decimal "price_usd", precision: 12, scale: 2
    t.string "real_state"
    t.string "phone"
    t.string "email"
    t.integer "bimester"
    t.integer "year"
    t.geometry "the_geom", limit: {:srid=>0, :type=>"st_point"}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bimester"], name: "index_bots_on_bimester"
    t.index ["county_id"], name: "index_bots_on_county_id"
    t.index ["the_geom"], name: "index_bots_on_the_geom", using: :gist
    t.index ["year"], name: "index_bots_on_year"
  end

  create_table "building_regulation_land_use_types", force: :cascade do |t|
    t.bigint "building_regulation_id"
    t.bigint "land_use_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_regulation_id"], name: "index_building_regulation_id"
    t.index ["land_use_type_id"], name: "index_building_regulation_land_use_types_on_land_use_type_id"
  end

  create_table "building_regulations", force: :cascade do |t|
    t.string "building_zone"
    t.decimal "construct"
    t.decimal "land_ocupation"
    t.string "site"
    t.geometry "the_geom", limit: {:srid=>4326, :type=>"multi_polygon"}
    t.string "identifier"
    t.bigint "density_type_id"
    t.bigint "county_id"
    t.string "comments"
    t.decimal "hectarea_inhabitants"
    t.string "grouping"
    t.string "parkings"
    t.integer "am_cc"
    t.decimal "aminciti"
    t.decimal "icinciti"
    t.decimal "osinciti"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "freezed", default: false
    t.string "freezed_observations"
    t.index ["county_id"], name: "index_building_regulations_on_county_id"
    t.index ["density_type_id"], name: "index_building_regulations_on_density_type_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name_en"
    t.string "name_es"
    t.boolean "income"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "census", force: :cascade do |t|
    t.integer "geocode"
    t.integer "age_0_9"
    t.integer "Age_10_19"
    t.integer "Age_20_29"
    t.integer "Age_30_39"
    t.integer "Age_40_49"
    t.integer "Age_50_59"
    t.integer "Age_60_69"
    t.integer "Age_70_79"
    t.integer "age_80_more"
    t.integer "age_tot"
    t.integer "home_1p"
    t.integer "home_2p"
    t.integer "home_3p"
    t.integer "home_4p"
    t.integer "home_5p"
    t.integer "home_6_more"
    t.integer "home_tot"
    t.integer "male"
    t.integer "female"
    t.integer "basica"
    t.integer "media"
    t.integer "media_tec"
    t.integer "tecnica"
    t.integer "profesional"
    t.integer "magister"
    t.integer "doctor"
    t.integer "owner"
    t.integer "leased"
    t.integer "transferred"
    t.integer "free"
    t.integer "possesion"
    t.integer "married"
    t.integer "coexist"
    t.integer "single"
    t.integer "canceled"
    t.integer "separated"
    t.integer "widowed"
    t.integer "salaried"
    t.integer "domestic_service"
    t.integer "independent"
    t.integer "employee_employer"
    t.integer "unpaid_familiar"
    t.integer "ismt_zn"
    t.integer "gse_zn"
    t.integer "n_hog"
    t.integer "n_abc1"
    t.integer "n_c2"
    t.integer "n_c3"
    t.integer "n_d"
    t.integer "n_e"
    t.bigint "county_id"
    t.bigint "census_source_id"
    t.geometry "the_geom", limit: {:srid=>0, :type=>"multi_polygon"}
    t.index ["census_source_id"], name: "index_census_on_census_source_id"
    t.index ["county_id"], name: "index_census_on_county_id"
  end

  create_table "census_sources", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.integer "projects_downloads", default: 0, null: false
    t.integer "transactions_downloads", default: 0, null: false
    t.integer "future_projects_downloads", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enabled", default: true
    t.date "enabled_date"
  end

  create_table "counties", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "transaction_data"
    t.boolean "demography_data"
    t.boolean "legislation_data"
    t.boolean "sales_project_data"
    t.boolean "future_project_data"
    t.string "commercial_project_data"
    t.integer "code_sii"
    t.integer "number_last_project_future"
    t.geometry "the_geom", limit: {:srid=>0, :type=>"st_polygon"}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enabled", default: false
    t.bigint "region_id"
    t.geometry "county_centroid", limit: {:srid=>0, :type=>"st_point"}
    t.index ["region_id"], name: "index_counties_on_region_id"
  end

  create_table "counties_users", force: :cascade do |t|
    t.bigint "county_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_counties_users_on_county_id"
    t.index ["user_id"], name: "index_counties_users_on_user_id"
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

  create_table "density_types", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.integer "position"
    t.integer "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "downloads_users", force: :cascade do |t|
    t.integer "transactions", default: 0
    t.integer "projects", default: 0
    t.integer "future_projects", default: 0
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_downloads_users_on_user_id"
  end

  create_table "expense_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "abbreviation", limit: 200
    t.index ["name"], name: "index_expense_types_on_name", unique: true
  end

  create_table "expenses", force: :cascade do |t|
    t.bigint "expense_type_id"
    t.decimal "abc1", precision: 12, scale: 2
    t.decimal "c2", precision: 12, scale: 2
    t.decimal "c3", precision: 12, scale: 2
    t.decimal "d", precision: 12, scale: 2
    t.decimal "e", precision: 12, scale: 2
    t.boolean "santiago_only"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_type_id"], name: "index_expenses_on_expense_type_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.jsonb "properties"
    t.string "layer_type"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "row_id"
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "flex_reports", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.text "filters"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "transaction_ids", default: [], array: true
    t.index ["user_id"], name: "index_flex_reports_on_user_id"
  end

  create_table "future_project_sub_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.bigint "future_project_sub_type_id"
    t.string "reference"
    t.index ["county_id"], name: "index_future_projects_on_county_id"
    t.index ["future_project_sub_type_id"], name: "index_future_projects_on_future_project_sub_type_id"
    t.index ["future_project_type_id"], name: "index_future_projects_on_future_project_type_id"
    t.index ["project_type_id"], name: "index_future_projects_on_project_type_id"
  end

  create_table "homogeneous_zones", force: :cascade do |t|
    t.integer "objectid", default: 0, null: false
    t.integer "cnt_cod_zc", default: 0, null: false
    t.integer "sum_house_p", default: 0, null: false
    t.integer "sum_house_a", default: 0, null: false
    t.integer "sum_house_o", default: 0, null: false
    t.integer "sum_other_p", default: 0, null: false
    t.integer "sum_other_o", default: 0, null: false
    t.integer "total_population", default: 0, null: false
    t.integer "total17", default: 0, null: false
    t.integer "sum_dept_p", default: 0, null: false
    t.integer "sum_dept_a", default: 0, null: false
    t.integer "sum_dept_o", default: 0, null: false
    t.integer "sum_other_a", default: 0, null: false
    t.integer "total12", default: 0, null: false
    t.integer "mp250", default: 0, null: false
    t.decimal "shape_leng", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "shape_area", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "house", default: 0, null: false
    t.integer "dpto", default: 0, null: false
    t.integer "house_prop", default: 0, null: false
    t.integer "dept_prop", default: 0, null: false
    t.integer "house_arr", default: 0, null: false
    t.integer "dept_arr", default: 0, null: false
    t.string "province", null: false
    t.string "commune", null: false
    t.string "region", null: false
    t.bigint "conty_id"
    t.integer "zone_txt", default: 0, null: false
    t.integer "district_txt", default: 0, null: false
    t.integer "cod_zc_txt", default: 0, null: false
    t.integer "occupied_dwelling_17", default: 0, null: false
    t.integer "vancant_dwelling_17", default: 0, null: false
    t.integer "house_17", default: 0, null: false
    t.integer "dept_17", default: 0, null: false
    t.geometry "the_geom", limit: {:srid=>4326, :type=>"multi_polygon"}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conty_id"], name: "index_homogeneous_zones_on_conty_id"
  end

  create_table "households_censu", force: :cascade do |t|
    t.integer "objectid", default: 0, null: false
    t.integer "cnt_cod_zc", default: 0, null: false
    t.integer "sum_house_p", default: 0, null: false
    t.integer "sum_house_a", default: 0, null: false
    t.integer "sum_house_o", default: 0, null: false
    t.integer "sum_other_p", default: 0, null: false
    t.integer "sum_other_o", default: 0, null: false
    t.integer "total_population", default: 0, null: false
    t.integer "total17", default: 0, null: false
    t.integer "sum_dept_p", default: 0, null: false
    t.integer "sum_dept_a", default: 0, null: false
    t.integer "sum_dept_o", default: 0, null: false
    t.integer "sum_other_a", default: 0, null: false
    t.integer "total12", default: 0, null: false
    t.integer "mp250", default: 0, null: false
    t.decimal "shape_leng", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "shape_area", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "house", default: 0, null: false
    t.integer "dpto", default: 0, null: false
    t.integer "house_prop", default: 0, null: false
    t.integer "dept_prop", default: 0, null: false
    t.integer "house_arr", default: 0, null: false
    t.integer "dept_arr", default: 0, null: false
    t.string "province", null: false
    t.string "commune", null: false
    t.string "region", null: false
    t.bigint "county_id"
    t.integer "zone_txt", default: 0, null: false
    t.integer "district_txt", default: 0, null: false
    t.integer "cod_zc_txt", default: 0, null: false
    t.integer "occupied_dwelling_17", default: 0, null: false
    t.integer "vancant_dwelling_17", default: 0, null: false
    t.integer "house_17", default: 0, null: false
    t.integer "dept_17", default: 0, null: false
    t.geometry "the_geom", limit: {:srid=>4326, :type=>"multi_polygon"}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_households_censu_on_county_id"
  end

  create_table "import_errors", force: :cascade do |t|
    t.integer "import_process_id"
    t.text "message"
    t.integer "row_index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "import_processes", force: :cascade do |t|
    t.string "status"
    t.string "file_path"
    t.integer "processed"
    t.integer "inserted"
    t.integer "updated"
    t.integer "failed"
    t.bigint "user_id"
    t.string "data_source"
    t.string "original_filename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_import_processes_on_user_id"
  end

  create_table "land_use_types", force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
    t.integer "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "layer_types", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lots", force: :cascade do |t|
    t.decimal "surface"
    t.bigint "county_id"
    t.geometry "the_geom", limit: {:srid=>0, :type=>"multi_polygon"}
    t.string "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_lots_on_county_id"
  end

  create_table "monthly_census_incomes", force: :cascade do |t|
    t.decimal "abc1", default: "0.0", null: false
    t.decimal "c2", default: "0.0", null: false
    t.decimal "c3", default: "0.0", null: false
    t.decimal "d", default: "0.0", null: false
    t.decimal "e", default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "neighborhoods", force: :cascade do |t|
    t.string "name"
    t.integer "total_houses"
    t.integer "total_departments"
    t.float "tenure"
    t.geometry "the_geom", limit: {:srid=>4326, :type=>"st_polygon"}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "geocode"
    t.boolean "active", default: true
    t.index ["the_geom"], name: "index_neighborhoods_on_the_geom", using: :gist
  end

  create_table "parcels", force: :cascade do |t|
    t.string "region"
    t.string "province"
    t.string "commune"
    t.decimal "shape_area"
    t.integer "code"
    t.string "area_name"
    t.geometry "the_geom", limit: {:srid=>0, :type=>"multi_polygon"}
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

  create_table "poi_subcategories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pois", force: :cascade do |t|
    t.string "name"
    t.bigint "poi_subcategory_id"
    t.geometry "the_geom", limit: {:srid=>0, :type=>"st_point"}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["poi_subcategory_id"], name: "index_pois_on_poi_subcategory_id"
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

  create_table "project_primary_data", force: :cascade do |t|
    t.integer "parcel_id"
    t.integer "year"
    t.integer "bimester"
    t.integer "proj_qty"
    t.integer "offer"
    t.integer "availability"
    t.integer "vmr"
    t.decimal "vmd"
    t.decimal "vvm"
    t.decimal "mas"
    t.decimal "usable_m2"
    t.decimal "terrace"
    t.decimal "uf_m2"
    t.integer "uf"
    t.decimal "uf_m2_u"
    t.decimal "pxqr"
    t.decimal "pxqd"
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
    t.string "abbreviation"
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
    t.decimal "vhmo", precision: 8, scale: 1, default: "0.0"
    t.index ["county_id"], name: "index_projects_on_county_id"
    t.index ["project_type_id"], name: "index_projects_on_project_type_id"
  end

  create_table "property_types", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.geometry "centroid", limit: {:srid=>0, :type=>"st_point"}
  end

  create_table "regions_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_regions_users_on_region_id"
    t.index ["user_id"], name: "index_regions_users_on_user_id"
  end

  create_table "rent_future_projects", force: :cascade do |t|
    t.string "code"
    t.string "address"
    t.string "name"
    t.string "role_number"
    t.decimal "file_number"
    t.date "file_date"
    t.string "owner"
    t.string "legal_agent"
    t.string "architech"
    t.integer "floors"
    t.integer "undergrounds"
    t.integer "total_units"
    t.integer "total_parking"
    t.integer "total_commercials"
    t.decimal "m2_approved", precision: 12, scale: 2
    t.decimal "m2_built", precision: 12, scale: 2
    t.decimal "m2_field", precision: 12, scale: 2
    t.string "t_ofi"
    t.date "cadastral_date"
    t.text "comments"
    t.integer "bimester"
    t.integer "year"
    t.integer "project_type_id"
    t.string "future_project_type_id"
    t.integer "county_id"
    t.geometry "the_geom", limit: {:srid=>0, :type=>"st_point"}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bimester"], name: "index_rent_future_projects_on_bimester"
    t.index ["the_geom"], name: "index_rent_future_projects_on_the_geom", using: :gist
    t.index ["year"], name: "index_rent_future_projects_on_year"
  end

  create_table "rent_projects", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.bigint "county_id"
    t.bigint "project_type_id"
    t.integer "floors", null: false
    t.date "sale_date"
    t.date "catastral_date"
    t.integer "offer"
    t.float "surface_util"
    t.float "terrace"
    t.decimal "price"
    t.geometry "the_geom", limit: {:srid=>0, :type=>"st_point"}
    t.integer "bedroom", null: false
    t.integer "bathroom", null: false
    t.integer "half_bedroom"
    t.integer "total_beds"
    t.integer "population_per_building"
    t.decimal "square_meters_terrain"
    t.decimal "uf_terrain"
    t.integer "bimester", null: false
    t.integer "year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bimester"], name: "index_rent_projects_on_bimester"
    t.index ["county_id"], name: "index_rent_projects_on_county_id"
    t.index ["project_type_id"], name: "index_rent_projects_on_project_type_id"
    t.index ["the_geom"], name: "index_rent_projects_on_the_geom", using: :gist
    t.index ["year"], name: "index_rent_projects_on_year"
  end

  create_table "rent_transactions", force: :cascade do |t|
    t.integer "property_type_id"
    t.string "address"
    t.integer "sheet"
    t.integer "number"
    t.date "inscription_date"
    t.string "buyer_name"
    t.integer "seller_type_id"
    t.string "department"
    t.string "blueprint"
    t.decimal "uf_value", precision: 12, scale: 2
    t.decimal "real_value", precision: 12, scale: 2
    t.decimal "calculated_value", precision: 12, scale: 2
    t.integer "quarter"
    t.date "quarter_date"
    t.integer "year"
    t.decimal "sample_factor", precision: 12, scale: 2
    t.integer "county_id"
    t.integer "cellar"
    t.integer "parking"
    t.string "role"
    t.string "seller_name"
    t.string "buyer_rut"
    t.decimal "uf_m2", precision: 12, scale: 2
    t.integer "tome"
    t.string "lot"
    t.string "block"
    t.string "village"
    t.decimal "surface", precision: 12, scale: 2
    t.string "requiring_entity"
    t.string "comments"
    t.integer "surveyor_id"
    t.boolean "active"
    t.integer "bimester"
    t.integer "code_sii"
    t.decimal "total_surface_building", precision: 12, scale: 2
    t.decimal "total_surface_terrain", precision: 12, scale: 2
    t.decimal "uf_m2_u", precision: 12, scale: 2
    t.decimal "uf_m2_t", precision: 12, scale: 2
    t.string "role_1"
    t.string "role_2"
    t.string "role_3"
    t.string "code_destination"
    t.string "code_material"
    t.string "year_sii"
    t.string "role_associated"
    t.string "additional_roles"
    t.geometry "the_geom", limit: {:srid=>0, :type=>"st_point"}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bimester"], name: "index_rent_transactions_on_bimester"
    t.index ["the_geom"], name: "index_rent_transactions_on_the_geom", using: :gist
    t.index ["year"], name: "index_rent_transactions_on_year"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.boolean "read_only"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "square_meters_download_area", default: 0
    t.integer "meters_download_radius", default: 0
    t.integer "square_meters_download_projects", default: 0
    t.integer "square_meters_download_future_projects", default: 0
    t.integer "square_meters_download_transactions", default: 0
    t.integer "meters_download_radius_projects", default: 0
    t.integer "meters_download_radius_future_projects", default: 0
    t.integer "meters_download_radius_transactions", default: 0
    t.integer "total_download_projects", default: 0
    t.integer "total_download_future_projects", default: 0
    t.integer "total_download_transactions", default: 0
  end

  create_table "seller_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "surveyors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tax_lands", force: :cascade do |t|
    t.string "rol_number"
    t.string "address"
    t.string "destination_code"
    t.string "land_m2"
    t.integer "county_sii_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "land_m2", precision: 12, scale: 1
    t.integer "tax_appraisal"
    t.index ["county_sii_id"], name: "tax_lands_county_sii_idx"
    t.index ["rol_number"], name: "tax_lands_role_idx"
  end

  create_table "tax_useful_surfaces", force: :cascade do |t|
    t.string "rol_number"
    t.integer "building_sequence_number"
    t.string "year"
    t.decimal "m2_built"
    t.string "destination_code"
    t.integer "county_sii_id"
    t.string "code_material"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tenements", force: :cascade do |t|
    t.string "address"
    t.bigint "property_type_id"
    t.bigint "county_id"
    t.decimal "building_surface", precision: 8, scale: 2
    t.string "terrain_surface"
    t.integer "parking"
    t.integer "cellar"
    t.string "uf"
    t.bigint "flex_report_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_tenements_on_county_id"
    t.index ["flex_report_id"], name: "index_tenements_on_flex_report_id"
    t.index ["property_type_id"], name: "index_tenements_on_property_type_id"
  end

  create_table "transactions", force: :cascade do |t|
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
    t.integer "quarter"
    t.date "quarter_date"
    t.integer "year"
    t.decimal "sample_factor", precision: 12, scale: 2
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
    t.decimal "surface", precision: 12, scale: 2
    t.string "requiring_entity"
    t.string "comments"
    t.bigint "user_id"
    t.integer "surveyor_id"
    t.boolean "active", default: true
    t.integer "bimester"
    t.integer "code_sii"
    t.decimal "total_surface_building", precision: 12, scale: 2
    t.decimal "total_surface_terrain", precision: 12, scale: 2
    t.decimal "uf_m2_u", precision: 12, scale: 2
    t.decimal "uf_m2_t", precision: 12, scale: 2
    t.string "building_regulation"
    t.string "role_1"
    t.string "role_2"
    t.string "code_destination"
    t.string "code_material"
    t.string "year_sii"
    t.string "role_associated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "additional_roles"
    t.integer "tax_appraisal"
    t.boolean "analyzable", default: true
    t.string "type_gistration"
    t.decimal "lot_m2", precision: 12, scale: 2
    t.index ["bimester"], name: "index_transactions_bimester"
    t.index ["county_id"], name: "index_transactions_on_county_id"
    t.index ["number"], name: "index_transactions_number"
    t.index ["role"], name: "role_1_idx"
    t.index ["user_id"], name: "index_transactions_on_user_id"
    t.index ["year"], name: "index_transactions_year"
  end

  create_table "uf_conversions", force: :cascade do |t|
    t.date "uf_date"
    t.string "uf_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_polygons", force: :cascade do |t|
    t.bigint "user_id"
    t.text "wkt"
    t.string "layertype"
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_polygons_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "complete_name"
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
    t.bigint "region_id"
    t.integer "layer_types", default: [], array: true
    t.string "unique_session_id"
    t.datetime "last_activity_at"
    t.datetime "expired_at"
    t.bigint "company_id"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["expired_at"], name: "index_users_on_expired_at"
    t.index ["last_activity_at"], name: "index_users_on_last_activity_at"
    t.index ["region_id"], name: "index_users_on_region_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "agency_rols", "agencies"
  add_foreign_key "building_regulation_land_use_types", "building_regulations"
  add_foreign_key "building_regulation_land_use_types", "land_use_types"
  add_foreign_key "building_regulations", "counties"
  add_foreign_key "building_regulations", "density_types"
  add_foreign_key "counties", "regions"
  add_foreign_key "counties_users", "counties"
  add_foreign_key "counties_users", "users"
  add_foreign_key "county_ufs", "counties"
  add_foreign_key "county_ufs", "property_types"
  add_foreign_key "expenses", "expense_types"
  add_foreign_key "flex_reports", "users"
  add_foreign_key "future_projects", "counties"
  add_foreign_key "future_projects", "future_project_sub_types"
  add_foreign_key "future_projects", "future_project_types"
  add_foreign_key "future_projects", "project_types"
  add_foreign_key "import_processes", "users"
  add_foreign_key "lots", "counties"
  add_foreign_key "pois", "poi_subcategories"
  add_foreign_key "project_instance_mixes", "project_instances"
  add_foreign_key "project_instances", "project_statuses"
  add_foreign_key "project_instances", "projects"
  add_foreign_key "regions_users", "regions"
  add_foreign_key "regions_users", "users"
  add_foreign_key "rent_projects", "counties"
  add_foreign_key "rent_projects", "project_types"
  add_foreign_key "tenements", "counties"
  add_foreign_key "tenements", "property_types"
  add_foreign_key "user_polygons", "users"
  add_foreign_key "users", "regions"

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
  create_function :cleangeometry, sql_definition: <<-SQL
      CREATE OR REPLACE FUNCTION public.cleangeometry(geometry)
       RETURNS geometry
       LANGUAGE plpgsql
      AS $function$DECLARE
      inGeom ALIAS for $1;
      outGeom geometry;
      tmpLinestring geometry;

      Begin

        outGeom := NULL;

        IF (GeometryType(inGeom) = 'POLYGON' OR GeometryType(inGeom) = 'MULTIPOLYGON') THEN
          if not isValid(inGeom) THEN
            tmpLinestring := st_union(st_multi(st_boundary(inGeom)),st_pointn(boundary(inGeom),1));
            outGeom = buildarea(tmpLinestring);
            IF (GeometryType(inGeom) = 'MULTIPOLYGON') THEN
              RETURN st_multi(outGeom);
            ELSE
              RETURN outGeom;
          END IF;
        else
          RETURN inGeom;
          END IF;
        ELSIF (GeometryType(inGeom) = 'LINESTRING') THEN
          outGeom := st_union(st_multi(inGeom),st_pointn(inGeom,1));
          RETURN outGeom;
        ELSIF (GeometryType(inGeom) = 'MULTILINESTRING') THEN
          outGeom := multi(st_union(st_multi(inGeom),st_pointn(inGeom,1)));
          RETURN outGeom;
        ELSE
          RAISE NOTICE 'The input type % is not supported',GeometryType(inGeom);
          RETURN inGeom;
          END IF;
          End;$function$
  SQL
  create_function :pp_uf, sql_definition: <<-SQL
      CREATE OR REPLACE FUNCTION public.pp_uf(proj_instance_id bigint)
       RETURNS real
       LANGUAGE plpgsql
      AS $function$
      declare t_m2 real;
      BEGIN
        t_m2 = (select sum(total_m2) from project_instance_mix_views
          where project_instance_id = proj_instance_id);

        if (t_m2 = 0) then
          return 0;
        else
          RETURN (select (sum(total_m2 * uf_avg_percent)/t_m2)
            as pp_uf
            from project_instance_mix_views
            where project_instance_id = proj_instance_id);
        end if;
                                            END;
                                            $function$
  SQL
  create_function :months, sql_definition: <<-SQL
      CREATE OR REPLACE FUNCTION public.months(proj_instance_id bigint)
       RETURNS real
       LANGUAGE plpgsql
      AS $function$
        BEGIN

            RETURN (select (date_part('year', to_date(pi.cadastre, 'DD/MM/YYYY')) - date_part('year', to_date(p.sale_date, 'DD/MM/YYYY'))) * 12 +
              (date_part('month', to_date(pi.cadastre, 'DD/MM/YYYY')) - date_part('month', to_date(p.sale_date, 'DD/MM/YYYY')))
              from project_instances pi inner join projects p
              on pi.project_id = p.id where pi.id = proj_instance_id) as months;

          END;
          $function$
  SQL
  create_function :pxq, sql_definition: <<-SQL
      CREATE OR REPLACE FUNCTION public.pxq(proj_instance_id bigint)
       RETURNS real
       LANGUAGE plpgsql
      AS $function$
        declare ppuf real;
        BEGIN
            ppuf = (select pp_uf(proj_instance_id));

              if (ppuf = 0) then
                    return 0;
                      else
                            RETURN (select vhmo(proj_instance_id) * ppuf / 1000) as pxq;
                              end if;

                            END;
                            $function$
  SQL
  create_function :vhmd, sql_definition: <<-SQL
      CREATE OR REPLACE FUNCTION public.vhmd(proj_instance_id bigint)
       RETURNS real
       LANGUAGE plpgsql
      AS $function$
      declare
      mixes RECORD;
      result REAL;
      BEGIN
        result = 0.0;

        for mixes in select project_instance_id, vhmu, masud from project_instance_mix_views where project_instance_id = proj_instance_id loop
          if mixes.masud > 0 then
            result = result + mixes.vhmu;
          end if;
        end loop;

        RETURN result;

                                    END;
                                    $function$
  SQL
  create_function :pp_uf_dis, sql_definition: <<-SQL
      CREATE OR REPLACE FUNCTION public.pp_uf_dis(proj_instance_id bigint)
       RETURNS real
       LANGUAGE plpgsql
      AS $function$
      declare sum_dis_m2 real;
      BEGIN
        sum_dis_m2 = (select sum(dis_m2) from project_instance_mix_views where project_instance_id = proj_instance_id);

        if (sum_dis_m2 = 0) then
          return 0;
        else
          RETURN (select sum(dis_m2 * uf_avg_percent) / sum(dis_m2::real)
            from project_instance_mix_views
            where project_instance_id = proj_instance_id) as pp_uf_dis;
        end if;

                                      END;
                                      $function$
  SQL
  create_function :vhmo, sql_definition: <<-SQL
      CREATE OR REPLACE FUNCTION public.vhmo(proj_instance_id bigint)
       RETURNS real
       LANGUAGE plpgsql
      AS $function$
        BEGIN

            RETURN (select sum(vhmu) from project_instance_mix_views where project_instance_id = proj_instance_id) as vhmo;

          END;
          $function$
  SQL
  create_function :county_name, sql_definition: <<-SQL
      CREATE OR REPLACE FUNCTION public.county_name(county_id integer)
       RETURNS character varying
       LANGUAGE plpgsql
      AS $function$BEGIN
          RETURN(Select name from counties where id = county_id);
        END;$function$
  SQL
  create_function :masd, sql_definition: <<-SQL
      CREATE OR REPLACE FUNCTION public.masd(proj_instance_id bigint)
       RETURNS real
       LANGUAGE plpgsql
      AS $function$
      declare
      result REAL;
      BEGIN
        result = vhmd(proj_instance_id);

        if result > 0 then
          RETURN (select total_available(proj_instance_id) / result) as masd;
        else
          return result;
        end if;

                            END;
                            $function$
  SQL
  create_function :total_available, sql_definition: <<-SQL
      CREATE OR REPLACE FUNCTION public.total_available(proj_instance_id bigint)
       RETURNS integer
       LANGUAGE plpgsql
      AS $function$
      BEGIN

        RETURN (select sum(stock_units)
          from project_instance_mixes
          where project_instance_id = proj_instance_id) as total_available;

                END;
                $function$
  SQL

  create_trigger :layer_integrity_checks, sql_definition: <<-SQL
      CREATE TRIGGER layer_integrity_checks BEFORE DELETE OR UPDATE ON topology.layer FOR EACH ROW EXECUTE FUNCTION topology.layertrigger()
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
  create_view "building_regulations_info", sql_definition: <<-SQL
      SELECT building_regulations.id,
      building_regulations.building_zone,
      ( SELECT array_to_string(array_agg(land_use_types.abbreviation), ','::text) AS array_to_string
             FROM (building_regulation_land_use_types
               JOIN land_use_types ON ((building_regulation_land_use_types.land_use_type_id = land_use_types.id)))
            WHERE (building_regulation_land_use_types.building_regulation_id = building_regulations.id)) AS land_use,
      building_regulations.the_geom,
      round(building_regulations.construct, 1) AS construct,
      round(building_regulations.land_ocupation, 1) AS land_ocupation,
      building_regulations.hectarea_inhabitants AS max_density,
      building_regulations."grouping",
      building_regulations.site,
      building_regulations.comments,
      building_regulations.aminciti AS am_cc,
      building_regulations.parkings,
      building_regulations.updated_at,
      building_regulations.county_id,
      density_types.color
     FROM (building_regulations
       JOIN density_types ON ((building_regulations.density_type_id = density_types.id)))
    ORDER BY building_regulations.updated_at DESC;
  SQL
  create_view "pois_infos", sql_definition: <<-SQL
      SELECT p.name,
      ps.name AS subcategories,
      p.the_geom,
      counties.id AS county_id
     FROM ((pois p
       JOIN poi_subcategories ps ON ((p.poi_subcategory_id = ps.id)))
       JOIN counties ON (st_contains(counties.the_geom, p.the_geom)));
  SQL
  create_view "project_department_reports", sql_definition: <<-SQL
      SELECT project_instances.bimester,
      project_instances.year,
      projects.code,
      projects.name AS project_name,
      projects.address,
      projects.county_id,
      projects.floors,
      projects.build_date,
      projects.sale_date,
      projects.transfer_date,
      projects.pilot_opening_date,
      project_instances.cadastre,
      project_statuses.name AS status,
      pim.living_room,
      pim.service_room,
      pim.h_office,
      pim.discount,
      pim.mix_usable_square_meters,
      pim.mix_terrace_square_meters,
      pim.total_units,
      pim.stock_units,
      pim.home_type,
      pim.mix_m2_field,
      pim.mix_m2_built,
      round(pim.uf_parking, 0) AS uf_parking,
      round(pim.uf_cellar, 0) AS uf_cellar,
      project_mixes.bedroom,
      project_mixes.bathroom,
      project_types.name AS project_type_name,
      ( SELECT a.name
             FROM (agencies a
               JOIN agency_rols ar ON ((a.id = ar.agency_id)))
            WHERE ((ar.project_id = projects.id) AND ((ar.rol)::text = 'INMOBILIARIA'::text))) AS agency_name,
      ( SELECT round((sum((project_instance_mixes.mix_usable_square_meters * (project_instance_mixes.total_units)::numeric)) / (sum(project_instance_mixes.total_units))::numeric), 1) AS round
             FROM project_instance_mixes
            WHERE (project_instance_mixes.project_instance_id = project_instances.id)) AS pp_utiles,
      ( SELECT round((sum((project_instance_mixes.mix_terrace_square_meters * (project_instance_mixes.total_units)::numeric)) / (sum(project_instance_mixes.total_units))::numeric), 1) AS round
             FROM project_instance_mixes
            WHERE (project_instance_mixes.project_instance_id = project_instances.id)) AS pp_terrazas,
      ( SELECT round((sum(((project_instance_mixes.mix_usable_square_meters * (project_instance_mixes.total_units)::numeric) * round(((((project_instance_mixes.uf_min * ((1)::numeric - (project_instance_mixes.percentage / (100)::numeric))) + (project_instance_mixes.uf_max * ((1)::numeric - (project_instance_mixes.percentage / (100)::numeric)))) / (2)::numeric) / (project_instance_mixes.mix_usable_square_meters + (project_instance_mixes.mix_terrace_square_meters * 0.5))), 1))) / sum((project_instance_mixes.mix_usable_square_meters * (project_instance_mixes.total_units)::numeric))), 1) AS round
             FROM project_instance_mixes
            WHERE (project_instance_mixes.project_instance_id = project_instances.id)) AS pp_ufm2ut,
      ( SELECT round((sum(((((project_instance_mixes.mix_usable_square_meters * (project_instance_mixes.total_units)::numeric) * ((project_instance_mixes.uf_min * ((1)::numeric - (project_instance_mixes.percentage / (100)::numeric))) + (project_instance_mixes.uf_max * ((1)::numeric - (project_instance_mixes.percentage / (100)::numeric))))) / (2)::numeric) / project_instance_mixes.mix_usable_square_meters)) / sum((project_instance_mixes.mix_usable_square_meters * (project_instance_mixes.total_units)::numeric))), 1) AS round
             FROM project_instance_mixes
            WHERE (project_instance_mixes.project_instance_id = project_instances.id)) AS pp_ufm2u,
      round((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))), 0) AS uf_min_percent,
      round((pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric))), 0) AS uf_max_percent,
      round((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric), 0) AS uf_avg_percent,
      round((pp_uf(project_instances.id))::numeric, 0) AS pp_uf,
      round((vhmu(pim.total_units, pim.stock_units, project_instances.cadastre, projects.sale_date))::numeric, 1) AS vhmu,
      round((pxq(project_instances.id))::numeric, 1) AS pxq,
      round((((vhmd(pim.project_instance_id) * pp_uf_dis(pim.project_instance_id)) / (1000)::double precision))::numeric, 1) AS pxq_d,
      round(((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) / (pim.mix_usable_square_meters + (pim.mix_terrace_square_meters * 0.5))), 1) AS uf_m2,
      round(((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) / pim.mix_usable_square_meters), 1) AS uf_m2_u,
      round((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric)) AS mix_uf_value,
      round((round(((pim.total_units - pim.stock_units))::numeric, 2) / (pim.total_units)::numeric), 2) AS percentage_sold,
      (pim.total_units - pim.stock_units) AS sold_units,
      months(project_instances.id) AS months,
          CASE
              WHEN (((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) >= (0)::numeric) AND ((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) <= (440)::numeric)) THEN '0 a 440'::text
              WHEN (((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) >= (441)::numeric) AND ((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) <= (929)::numeric)) THEN '441 a 929'::text
              WHEN (((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) >= (930)::numeric) AND ((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) <= (1549)::numeric)) THEN '930 a 1549'::text
              WHEN (((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) >= (1550)::numeric) AND ((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) <= (3399)::numeric)) THEN '1550 a 3399'::text
              WHEN (((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) >= (3400)::numeric) AND ((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) <= (5390)::numeric)) THEN '3400 a 5390'::text
              WHEN (((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) >= (5391)::numeric) AND ((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) <= (7950)::numeric)) THEN '5391 a 7950'::text
              WHEN (((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) >= (7951)::numeric) AND ((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) <= (11500)::numeric)) THEN '7951 a 11500'::text
              WHEN (((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) >= (11501)::numeric) AND ((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) <= (15600)::numeric)) THEN '11501 a 15600'::text
              WHEN (((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) >= (15601)::numeric) AND ((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) <= (500000)::numeric)) THEN '15601 a 500000'::text
              ELSE NULL::text
          END AS range_uf,
          CASE
              WHEN ((pim.mix_usable_square_meters >= (0)::numeric) AND (pim.mix_usable_square_meters <= 30.99)) THEN '< 30'::text
              WHEN ((pim.mix_usable_square_meters >= (31)::numeric) AND (pim.mix_usable_square_meters <= 45.99)) THEN '31 a 45'::text
              WHEN ((pim.mix_usable_square_meters >= (46)::numeric) AND (pim.mix_usable_square_meters <= 60.99)) THEN '46 a 60'::text
              WHEN ((pim.mix_usable_square_meters >= (61)::numeric) AND (pim.mix_usable_square_meters <= 80.99)) THEN '61 a 80'::text
              WHEN ((pim.mix_usable_square_meters >= (81)::numeric) AND (pim.mix_usable_square_meters <= 100.99)) THEN '81 a 100'::text
              WHEN ((pim.mix_usable_square_meters >= (101)::numeric) AND (pim.mix_usable_square_meters <= 120.99)) THEN '101 a 120'::text
              WHEN ((pim.mix_usable_square_meters >= (121)::numeric) AND (pim.mix_usable_square_meters <= 140.99)) THEN '121 a 140'::text
              WHEN ((pim.mix_usable_square_meters >= (141)::numeric) AND (pim.mix_usable_square_meters <= 160.99)) THEN '141 a 160'::text
              WHEN ((pim.mix_usable_square_meters >= (161)::numeric) AND (pim.mix_usable_square_meters <= 180.99)) THEN '161 a 180'::text
              WHEN ((pim.mix_usable_square_meters >= (181)::numeric) AND (pim.mix_usable_square_meters <= 200.99)) THEN '181 a 200'::text
              WHEN (pim.mix_usable_square_meters > (200)::numeric) THEN '>200'::text
              ELSE NULL::text
          END AS range_util,
          CASE masud(pim.total_units, pim.stock_units, project_instances.cadastre, projects.sale_date)
              WHEN 0 THEN (0)::numeric
              ELSE round((vhmu(pim.total_units, pim.stock_units, project_instances.cadastre, projects.sale_date))::numeric, 1)
          END AS vhmud,
      projects.the_geom,
      st_x(projects.the_geom) AS x,
      st_y(projects.the_geom) AS y
     FROM (((((projects
       JOIN project_instances ON ((project_instances.project_id = projects.id)))
       JOIN project_instance_mixes pim ON ((project_instances.id = pim.project_instance_id)))
       JOIN project_mixes ON ((pim.mix_id = project_mixes.id)))
       JOIN project_types ON ((project_types.id = projects.project_type_id)))
       JOIN project_statuses ON ((project_statuses.id = project_instances.project_status_id)))
    WHERE (projects.project_type_id = 2);
  SQL
  create_view "project_home_reports", sql_definition: <<-SQL
      SELECT project_instances.bimester,
      project_instances.year,
      projects.code,
      projects.name AS project_name,
      projects.address,
      county_name((projects.county_id)::integer) AS county_name,
      projects.county_id,
      ( SELECT a.name
             FROM (agencies a
               JOIN agency_rols ar ON ((a.id = ar.agency_id)))
            WHERE ((ar.project_id = projects.id) AND ((ar.rol)::text = 'INMOBILIARIA'::text))) AS agency_name,
      pim.model,
      projects.floors,
      pim.t_min,
      pim.t_max,
      pim.mix_usable_square_meters,
      ( SELECT round((sum((((project_instance_mixes.t_min + project_instance_mixes.t_max) / (2)::numeric) * (project_instance_mixes.total_units)::numeric)) / (sum(project_instance_mixes.total_units))::numeric), 1) AS round
             FROM project_instance_mixes
            WHERE (project_instance_mixes.project_instance_id = project_instances.id)) AS pp_terreno,
      pp_utiles(project_instances.id) AS pp_utiles,
      project_mixes.bedroom,
      project_mixes.bathroom,
      pim.living_room,
      pim.service_room,
      pim.h_office,
      pim.discount,
      round((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))), 0) AS uf_min_percent,
      round((pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric))), 0) AS uf_max_percent,
      round((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric), 0) AS uf_avg_percent,
      pp_uf(project_instances.id) AS pp_uf,
      round(pim.uf_parking, 0) AS uf_parking,
      round(pim.uf_cellar, 0) AS uf_cellar,
      round(((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) / (pim.mix_usable_square_meters + (((pim.t_min + pim.t_max) / (2)::numeric) * 0.25))), 1) AS uf_m2_ut,
      ( SELECT round((sum(((project_instance_mixes.mix_usable_square_meters * (project_instance_mixes.total_units)::numeric) * round(((((project_instance_mixes.uf_min * ((1)::numeric - (project_instance_mixes.percentage / (100)::numeric))) + (project_instance_mixes.uf_max * ((1)::numeric - (project_instance_mixes.percentage / (100)::numeric)))) / (2)::numeric) / (project_instance_mixes.mix_usable_square_meters + (((project_instance_mixes.t_min + project_instance_mixes.t_max) / (2)::numeric) * 0.25))), 1))) / sum((project_instance_mixes.mix_usable_square_meters * (project_instance_mixes.total_units)::numeric))), 2) AS round
             FROM project_instance_mixes
            WHERE (project_instance_mixes.project_instance_id = project_instances.id)) AS pp_ufm2ut,
      round(((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) / pim.mix_usable_square_meters), 1) AS uf_m2_u,
      ( SELECT round((sum(((project_instance_mixes.mix_usable_square_meters * (project_instance_mixes.total_units)::numeric) * round(((((project_instance_mixes.uf_min * ((1)::numeric - (project_instance_mixes.percentage / (100)::numeric))) + (project_instance_mixes.uf_max * ((1)::numeric - (project_instance_mixes.percentage / (100)::numeric)))) / (2)::numeric) / project_instance_mixes.mix_usable_square_meters), 1))) / sum((project_instance_mixes.mix_usable_square_meters * (project_instance_mixes.total_units)::numeric))), 1) AS round
             FROM project_instance_mixes
            WHERE (project_instance_mixes.project_instance_id = project_instances.id)) AS pp_ufm2u,
      pim.total_units,
      pim.stock_units,
      (pim.total_units - pim.stock_units) AS sold_units,
      months(project_instances.id) AS months,
      round((vhmu(pim.total_units, pim.stock_units, project_instances.cadastre, projects.sale_date))::numeric, 1) AS vhmu,
      round((pxq(project_instances.id))::numeric, 1) AS pxq,
      round((((vhmd(pim.project_instance_id) * pp_uf_dis(pim.project_instance_id)) / (1000)::double precision))::numeric, 1) AS pxq_d,
      project_statuses.name AS status,
      projects.build_date,
      projects.sale_date,
      projects.transfer_date,
      project_instances.cadastre,
          CASE
              WHEN (((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) >= (0)::numeric) AND ((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) <= (440)::numeric)) THEN '0 a 440'::text
              WHEN (((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) >= (441)::numeric) AND ((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) <= (929)::numeric)) THEN '441 a 929'::text
              WHEN (((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) >= (930)::numeric) AND ((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) <= (1549)::numeric)) THEN '930 a 1549'::text
              WHEN (((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) >= (1550)::numeric) AND ((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) <= (3399)::numeric)) THEN '1550 a 3399'::text
              WHEN (((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) >= (3400)::numeric) AND ((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) <= (5390)::numeric)) THEN '3400 a 5390'::text
              WHEN (((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) >= (5391)::numeric) AND ((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) <= (7950)::numeric)) THEN '5391 a 7950'::text
              WHEN (((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) >= (7951)::numeric) AND ((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) <= (11500)::numeric)) THEN '7951 a 11500'::text
              WHEN (((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) >= (11501)::numeric) AND ((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) <= (15600)::numeric)) THEN '11501 a 15600'::text
              WHEN (((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) >= (156001)::numeric) AND ((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric) <= (500000)::numeric)) THEN '156010 a 500000'::text
              ELSE NULL::text
          END AS range_uf,
          CASE
              WHEN ((pim.mix_usable_square_meters >= (0)::numeric) AND (pim.mix_usable_square_meters <= 30.99)) THEN '< 30'::text
              WHEN ((pim.mix_usable_square_meters >= (31)::numeric) AND (pim.mix_usable_square_meters <= 45.99)) THEN '31 a 45'::text
              WHEN ((pim.mix_usable_square_meters >= (46)::numeric) AND (pim.mix_usable_square_meters <= 60.99)) THEN '46 a 60'::text
              WHEN ((pim.mix_usable_square_meters >= (61)::numeric) AND (pim.mix_usable_square_meters <= 80.99)) THEN '61 a 80'::text
              WHEN ((pim.mix_usable_square_meters >= (81)::numeric) AND (pim.mix_usable_square_meters <= 100.99)) THEN '81 a 100'::text
              WHEN ((pim.mix_usable_square_meters >= (101)::numeric) AND (pim.mix_usable_square_meters <= 120.99)) THEN '101 a 120'::text
              WHEN ((pim.mix_usable_square_meters >= (121)::numeric) AND (pim.mix_usable_square_meters <= 140.99)) THEN '121 a 140'::text
              WHEN ((pim.mix_usable_square_meters >= (141)::numeric) AND (pim.mix_usable_square_meters <= 160.99)) THEN '141 a 160'::text
              WHEN ((pim.mix_usable_square_meters >= (161)::numeric) AND (pim.mix_usable_square_meters <= 180.99)) THEN '161 a 180'::text
              WHEN ((pim.mix_usable_square_meters >= (181)::numeric) AND (pim.mix_usable_square_meters <= 200.99)) THEN '181 a 200'::text
              WHEN (pim.mix_usable_square_meters > (200)::numeric) THEN '>200'::text
              ELSE NULL::text
          END AS range_util,
      project_types.name AS project_type_name,
      pim.home_type,
      round((((pim.uf_min * ((1)::numeric - (pim.percentage / (100)::numeric))) + (pim.uf_max * ((1)::numeric - (pim.percentage / (100)::numeric)))) / (2)::numeric)) AS mix_uf_value,
      pim.mix_m2_field,
      pim.mix_m2_built,
      round((round(((pim.total_units - pim.stock_units))::numeric, 2) / (pim.total_units)::numeric), 2) AS percentage_sold,
      projects.pilot_opening_date,
      round((masd(project_instances.id))::numeric, 1) AS vhmud,
      projects.the_geom,
      st_x(projects.the_geom) AS x,
      st_y(projects.the_geom) AS y
     FROM (((((projects
       JOIN project_instances ON ((project_instances.project_id = projects.id)))
       JOIN project_instance_mixes pim ON ((project_instances.id = pim.project_instance_id)))
       JOIN project_mixes ON ((pim.mix_id = project_mixes.id)))
       JOIN project_types ON ((project_types.id = projects.project_type_id)))
       JOIN project_statuses ON ((project_statuses.id = project_instances.project_status_id)))
    WHERE (projects.project_type_id = 1);
  SQL
  create_view "counties_enabled_by_users", sql_definition: <<-SQL
      SELECT c.name,
      u.id AS user_id,
      st_centroid(c.the_geom) AS geom
     FROM ((counties_users cu
       JOIN users u ON ((cu.user_id = u.id)))
       JOIN counties c ON ((cu.county_id = c.id)));
  SQL
end
