class ImportProcessJob < ApplicationJob
  queue_as :default

  def perform(import)
    ImportProcess.load_from_zip(import)
  end
end
