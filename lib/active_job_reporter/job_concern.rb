# frozen_string_literal: true

require "active_support/concern"

module ActiveJobReporter
  module JobConcern
    extend ::ActiveSupport::Concern

    included do
      self.table_name = ActiveJobReporter.configuration.jobs_table_name

      enum status: [:enqueued, :running, :finished]

      validates :job_id, :job_type, presence: true

      has_many :job_objects, class_name: "ActiveJobReporter::JobObject"

      has_many :messages, foreign_key: "job_id", class_name: "ActiveJobReporter::JobMessage"

      belongs_to :user, class_name: ActiveJobReporter.configuration.user_class_name, optional: true
    end

    def add_message(type:, message:)
      messages << JobMessage.create(message_type: type, message: message)
    end
  end
end
