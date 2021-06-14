class ImportProcess < ApplicationRecord
  require 'rgeo/shapefile'
  has_many :import_errors, :dependent => :destroy, :autosave => true
  belongs_to :user
  attr_accessor :file
  delegate :complete_name, :to => :user, :prefix => true, :allow_nil => true

  include Ibiza
  include ImportProcess::BuildingRegulations
  include ImportProcess::ParseFile
  include ImportProcess::RentProjects

  after_create_commit :import_job

  def import_job
    ImportProcessJob.perform_now(self)
  end
end
