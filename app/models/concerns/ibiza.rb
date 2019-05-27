module Ibiza
  class ImportLogger
    attr_accessor :details
    attr_accessor :import_process
    attr_accessor :current_row_index
    attr_accessor :status
    attr_accessor :inserted
    attr_accessor :updated
    attr_accessor :failed
    attr_accessor :processed

    def initialize(import_process)
      self.import_process = import_process
      self.details = []
      self.status = import_process.status
      self.inserted = 0
      self.updated = 0
      self.failed = 0
      self.processed = 0
    end

    def save
      self.details.each do |detail|
        error = ImportError.new :row_index => (detail[:row_index] rescue ""), :message => detail[:message]
        self.import_process.import_errors << error
      end
      self.import_process.processed = self.processed
      self.import_process.inserted = self.inserted
      self.import_process.updated = self.updated
      self.import_process.failed = self.failed
      self.import_process.save
    end

    def status
      self.import_process.status
    end

    def status=(status)
      self.import_process.status = status
    end

  end
end
