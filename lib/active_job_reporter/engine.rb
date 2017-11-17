# frozen_string_literal: true

module ActiveJobReporter
  class Engine < ::Rails::Engine
    paths["app/models"] << "lib/active_job_reporter/models"
  end
end
