# frozen_string_literal: true

require "active_support/concern"

module ActiveJobReporter
  module HasJobs
    extend ::ActiveSupport::Concern

    included do
      has_many :job_objects, as: :object, class_name: "ActiveJobReporter::JobObject"
      has_many :jobs, through: :job_objects, class_name: ActiveJobReporter.configuration.job_class_name
    end
  end
end
