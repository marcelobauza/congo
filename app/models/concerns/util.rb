module Util
  extend ActiveSupport::Concern
  MAX_RADIUS = 3000 # meters
  UTM_SRID = "32719"
  WGS84_SRID = "4326"

  INCITI_FOLDER = "inciti_pro-"

  AND_CONNECTOR = " AND "
  OR_CONNECTOR = " OR "

  NORMAL_MARKER_SIZE = 14

  NORMAL_MARKER_COLOR = "#9A2022"
  SEARCH_MARKER_COLOR = "#FFEF3F"

  INTERVALS_QUANTITY = 9 #5

  MAX_AREA = 12566370 #2km circle radius π×2000²
  BOOST_AREA = 775820 #500m circle radius more or less

  VERY_DISTINCT_COLOS = ["#DF0101", "#DF7401", "#D7DF01", "#74DF00", "#01DFA5",
                         "#01DFD7", "#0174DF", "#A901DB", "#DF01D7", "#4C0B5F",
                         "#F6CEF5", "#D8CEF6", "#CEE3F6", "#CEF6EC", "#E3F6CE"]

  MARITAL_STATUSES = [
    [I18n.t("lookup.marital_status.married_marital_status"),1],
    [I18n.t("lookup.marital_status.divorced_marital_status"),2],
    [I18n.t("lookup.marital_status.single_marital_status"),3],
    [I18n.t("lookup.marital_status.widower_marital_status"),4]]

  MARITAL_REGIME = [
    [I18n.t("lookup.marital_regime.marital_regime"),1],
    [I18n.t("lookup.marital_regime.possession_divition_marital_regime"),2],
    [I18n.t("lookup.marital_regime.conjugal_marital_regime"),3]]

  def self.get_shape_files_from_zip(file_path)
    # Create the directory
    temp_path = File.join(Dir::tmpdir, Time.now.to_f.to_s)
    FileUtils.mkdir temp_path
    # Extract the file
    extract(file_path, temp_path)

    # Parse the shape file
    shps = file_find(temp_path, "*.shp", true)

    return shps, temp_path
  end

  def self.extract(src, dst)
    require 'rubygems'
    require 'zip'
    Zip::ZipFile.open(src) do |zip|
      zip.each do |f|
        file_path = File.join(dst, f.to_s)

        if File.exists?(file_path[0, file_path.rindex("/") + 1]) == false
          FileUtils.mkdir(file_path[0, file_path.rindex("/") + 1])
        end

        zip.extract(f, file_path)
      end
    end
  end

  def self.compress(path)
    require 'zip/zip'
    require 'zip/zipfilesystem'

    path.sub!(%r[/$], '')
    archive = File.join(path,File.basename(path)) + '.zip'
    FileUtils.rm archive, :force => true

    Zip::ZipFile.open(archive, 'w') do |zipfile|
      Dir["#{path}/**/**"].reject{|f| f == archive}.each do |file|
        zipfile.add(file.sub(path + '/', ''), file)
      end
    end

    archive
  end

  def self.file_find(dir, filename="*.*", subdirs=true)
    Dir[ subdirs ? File.join(dir.split(/\\/), "**", filename) : File.join(dir.split(/\\/), filename) ]
  end

  def self.sql_value statement
    ActiveRecord::Base.connection.select_value(statement)
  end

  def self.calc_area(text_polygon)
    res = ActiveRecord::Base.connection.execute("SELECT ST_Area(ST_GeomFromText('#{text_polygon}', #{WGS84_SRID})) as area")
    return res[0]["area"].to_f
  end

  def self.sql_exec statement
    ActiveRecord::Base.connection.execute(statement)
  end

  def self.make_temp_dir
    # Create the directory
    token = INCITI_FOLDER + Digest::MD5.hexdigest(rand.to_s)
    temp_path = File.join(Dir::tmpdir, token)
    FileUtils.mkdir temp_path
    temp_path
  end

  def self.make_dir_emi
    # Create the directory
    token = INCITI_FOLDER + Digest::MD5.hexdigest(rand.to_s)
    dir = "public/images/emi/"
    temp_path = File.join(dir, token)
    FileUtils.mkdir temp_path
    temp_path
  end


  def self.numeric?(object)
    true if Float(object) rescue false
  end

  def self.execute(sql)
    ActiveRecord::Base.connection().execute(sql)
  end

  def self.get_bimester_from_date(current_date)
    return current_date.nil? ? 1 : (current_date.month.to_f / 2).to_f.round
  end

  def self.and
    AND_CONNECTOR
  end

  def self.or
    OR_CONNECTOR
  end

  def self.generate_pass(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("1".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

  def self.generate_colors ids_arr
    colors = []
    ids_arr.each_with_index do |id, index|
      if VERY_DISTINCT_COLOS[index]
        color = VERY_DISTINCT_COLOS[index]
      else
        color = "#%06x" % (rand * 0xffffff)
      end

      colors << {:id => id, :color => color}
    end
    colors
  end
end
